#!/usr/bin/env python3
"""Fold step marks into an asciicast v3 recording, then retime it.

The annotation step uses three files:

    telescope.cast       the recording itself (asciicast v3, relative intervals)
    telescope.t0         wall clock (epoch.nanos) when `asciinema rec` started
    telescope.marks.txt  'epoch.nanos label' per SAY/NV/TYPE step in the driver script,
                         plus 'wait:' lines for each WAIT_* span (see below)

`--annotate` converts telescope.marks.txt + telescope.t0 into native asciicast v3
marker events inside the cast. It also compresses each WAIT_* span (time spent
waiting on a REPL, LSP, formatter...) to at most its `show` seconds, so the
result does not depend on how fast the recording machine was; pass
--keep-waits to skip that. recorder.sh keeps the two inputs temporary
(KEEP_MARKS=1 saves them) because the embedded markers are all later timing
operations need. Those markers make the cast navigable
(`agg --select marker:3..marker:4`) and retimable (`--dump`/`--apply`) without
ever looking at the raw escape codes.

Everything else here works off those markers:

    --list                    show the segment table (one row per marker)
    --dump FILE               same table, in an editable form
    --apply FILE              rescale each segment to the durations in FILE
    --restore-dwells          restore sleeps shortened by FAST_RECORD
    --max-gap SECONDS         clamp dead air without moving segment boundaries
    --shift SECONDS           nudge every marker (use with --annotate)
    --trim-start SPEC         drop the run-up (nvim startup, dead air) at t=0
    --trim-end SPEC           drop the tail (the shell revealed after :qa)
    --hold SECONDS            linger on the final frame

SPEC is either seconds (4.2) or a marker (marker:0, m0, marker:-1).

Output goes to stdout unless -o/--in-place is given.
"""

from __future__ import annotations

import argparse
import json
import os
import sys

# Event codes that asciicast v3 defines. We only ever *create* markers, but the
# others have to survive a round-trip untouched.
MARKER = "m"


class Cast:
    """An asciicast v3 file held as (absolute time, code, data) triples.

    The on-disk format stores *relative* intervals, which is miserable to edit:
    every operation here (insert a marker, stretch a segment, clamp a gap) is
    naturally expressed against absolute times, so we convert on load and back
    on save.
    """

    def __init__(self, header: dict, events: list[tuple[float, str, object]]):
        self.header = header
        self.events = events

    @classmethod
    def load(cls, path: str) -> "Cast":
        with open(path, encoding="utf-8") as fh:
            lines = [ln for ln in (ln.strip() for ln in fh) if ln]
        if not lines:
            sys.exit(f"{path}: empty file")
        header = json.loads(lines[0])
        version = header.get("version")
        if version != 3:
            sys.exit(
                f"{path}: asciicast v{version}; this tool needs v3 "
                "(record with `asciinema rec -f asciicast-v3`)"
            )
        events, t = [], 0.0
        for ln in lines[1:]:
            interval, code, data = json.loads(ln)
            t += float(interval)
            events.append((t, code, data))
        return cls(header, events)

    def dumps(self) -> str:
        out = [json.dumps(self.header, separators=(",", ":"))]
        prev = 0.0
        for t, code, data in self.events:
            # Round the *interval*, not the absolute time, so that what we write
            # is exactly what a reader will reconstruct.
            interval = round(t - prev, 6)
            prev += interval
            out.append(json.dumps([interval, code, data], separators=(",", ":")))
        return "\n".join(out) + "\n"

    @property
    def duration(self) -> float:
        return self.events[-1][0] if self.events else 0.0

    def markers(self) -> list[tuple[int, float, str]]:
        """(index into self.events, time, label) for each marker, in order."""
        return [
            (i, t, data if isinstance(data, str) else "")
            for i, (t, code, data) in enumerate(self.events)
            if code == MARKER
        ]

    def strip_markers(self) -> None:
        self.events = [e for e in self.events if e[1] != MARKER]

    def insert_markers(self, marks: list[tuple[float, str]]) -> None:
        """Merge (time, label) markers into the event stream, keeping it sorted.

        Markers sort *before* an output event at the same timestamp: a mark is
        logged when a step begins, so it belongs in front of whatever that step
        drew on screen.
        """
        merged = [(t, MARKER, label) for t, label in marks] + self.events
        self.events = sorted(merged, key=lambda e: (e[0], e[1] != MARKER))


# ---------------------------------------------------------------------------
# segments: the span from one marker to the next
# ---------------------------------------------------------------------------


def segments(cast: Cast) -> list[dict]:
    """Split the cast at its markers.

    The leading span before the first marker is included as "(start)" with index
    -1 so that `--dump`/`--apply` can stretch or shrink the run-up (nvim
    starting, treesitter attaching) like any other step.
    """
    marks = cast.markers()
    bounds = [(-1, 0.0, "(start)")] + [(n, t, lbl) for n, (_, t, lbl) in enumerate(marks)]
    end = cast.duration
    segs = []
    for i, (n, start, label) in enumerate(bounds):
        stop = bounds[i + 1][1] if i + 1 < len(bounds) else end
        segs.append({"n": n, "start": start, "stop": stop, "label": label})
    return segs


def print_table(cast: Cast, stream=sys.stdout) -> None:
    print(f"{'#':>3}  {'t':>7}  {'dur':>6}  label", file=stream)
    for s in segments(cast):
        n = "-" if s["n"] < 0 else s["n"]
        dur = s["stop"] - s["start"]
        print(f"{n:>3}  {s['start']:7.2f}  {dur:6.2f}  {s['label']}", file=stream)


def dump_timing(cast: Cast, path: str) -> None:
    lines = [
        "# One row per segment: <index> <duration> <label>",
        "# Edit the duration column and re-apply with --apply.",
        "# Intervals inside a segment are scaled, so each row is independent.",
    ]
    for s in segments(cast):
        n = "-" if s["n"] < 0 else s["n"]
        lines.append(f"{n:>3}  {s['stop'] - s['start']:6.2f}  {s['label']}")
    text = "\n".join(lines) + "\n"
    if path == "-":
        sys.stdout.write(text)
    else:
        with open(path, "w", encoding="utf-8") as fh:
            fh.write(text)


def read_timing(path: str) -> list[float]:
    durations = []
    with open(path, encoding="utf-8") as fh:
        for ln in fh:
            ln = ln.strip()
            if not ln or ln.startswith("#"):
                continue
            parts = ln.split(None, 2)
            if len(parts) < 2:
                sys.exit(f"{path}: cannot parse line: {ln!r}")
            durations.append(float(parts[1]))
    return durations


def restore_dwells(cast: Cast, dwells: list[float]) -> None:
    """Insert fast-recording time before each segment's next marker.

    Output inside a segment keeps its real recording speed; only the settled
    final frame is held longer. The final marker has no following boundary and
    is intentionally ignored (it is normally the command that quits nvim).
    """
    marker_count = len(cast.markers())
    if len(dwells) != marker_count:
        sys.exit(
            f"dwell metadata has {len(dwells)} rows but the cast has "
            f"{marker_count} markers"
        )

    out = []
    cumulative = 0.0
    previous_hold = None
    marker_n = 0
    for t, code, data in cast.events:
        if code == MARKER:
            if previous_hold is not None:
                cumulative += previous_hold
            previous_hold = dwells[marker_n]
            marker_n += 1
        out.append((t + cumulative, code, data))
    cast.events = out


def apply_timing(cast: Cast, durations: list[float]) -> None:
    """Rescale each segment to the requested duration.

    Within a segment every interval is scaled by the same factor, so relative
    rhythm (per-keystroke pacing from TYPE, for instance) is preserved and no
    edit leaks into a neighbouring step.
    """
    segs = segments(cast)
    if len(durations) != len(segs):
        sys.exit(
            f"timing file has {len(durations)} rows but the cast has "
            f"{len(segs)} segments; re-run --dump"
        )

    # Build a piecewise-linear remap of old time -> new time.
    pieces, new_start = [], 0.0
    for s, want in zip(segs, durations):
        have = s["stop"] - s["start"]
        scale = (want / have) if have > 0 else 0.0
        pieces.append((s["start"], s["stop"], new_start, scale))
        new_start += want

    def remap(t: float) -> float:
        for start, stop, new, scale in pieces:
            if t < stop:
                return new + (t - start) * scale
        start, _, new, scale = pieces[-1]
        return new + (t - start) * scale

    cast.events = [(remap(t), code, data) for t, code, data in cast.events]


# ---------------------------------------------------------------------------
# trimming the head and tail
# ---------------------------------------------------------------------------


def resolve_spec(cast: Cast, spec: str) -> float:
    """Turn '4.2', 'marker:0', 'm0', 'marker:-1', 'start', 'end' into a time."""
    spec = spec.strip()
    if spec in ("start", "begin"):
        return 0.0
    if spec == "end":
        return cast.duration
    for prefix in ("marker:", "m:", "m"):
        if spec.startswith(prefix):
            marks = cast.markers()
            if not marks:
                sys.exit(f"{spec}: the cast has no markers (run --annotate first)")
            try:
                return marks[int(spec[len(prefix):])][1]
            except (ValueError, IndexError):
                sys.exit(f"{spec}: no such marker (cast has {len(marks)})")
    try:
        return float(spec)
    except ValueError:
        sys.exit(f"{spec}: expected seconds, marker:N, start or end")


def trim(cast: Cast, start: float, end: float) -> None:
    """Cut the cast down to [start, end], preserving screen state.

    Events before `start` cannot simply be deleted: they are what put the screen
    into the state the trimmed recording begins in (alt screen, theme/palette
    responses, nvim's first paint). Instead their payloads are *concatenated*
    into a single event at t=0, so the first frame is fully drawn but the run-up
    costs no time. Markers inside the cut region go away with it.

    The tail is a plain delete: everything after `end` (nvim restoring the
    terminal, thereby exposing the shell prompt, plus the `x` exit event) is
    content you do not want in a gif.
    """
    head_out, head_other, body = [], [], []
    for t, code, data in cast.events:
        if t < start:
            if code == "o":
                head_out.append(data)
            elif code != MARKER:
                head_other.append((0.0, code, data))  # e.g. resize events
        elif t <= end:
            body.append((t - start, code, data))

    prefix = head_other[:]
    if head_out:
        prefix.append((0.0, "o", "".join(head_out)))
    cast.events = prefix + body


def hold(cast: Cast, seconds: float) -> None:
    """Append an inert write so the final frame stays up for `seconds`.

    SGR-reset is the payload because it is a no-op here: attributes get reset
    constantly during the recording anyway, and every renderer accepts it.
    """
    if cast.events and seconds > 0:
        cast.events.append((cast.duration + seconds, "o", "\x1b[0m"))


def clamp_gaps(cast: Cast, max_gap: float) -> None:
    """Cap every inter-event interval, shifting the tail to match.

    Segment *structure* is untouched (markers move with their neighbours), so
    this composes with --apply; do the clamp first if you want both.
    """
    out, prev_old, prev_new = [], 0.0, 0.0
    for t, code, data in cast.events:
        gap = min(t - prev_old, max_gap)
        prev_new += gap
        prev_old = t
        out.append((prev_new, code, data))
    cast.events = out


# ---------------------------------------------------------------------------
# annotate: .marks.txt + .t0 -> marker events
# ---------------------------------------------------------------------------


def read_marks(path: str, t0: float, shift: float, duration: float):
    """Convert wall-clock marks into cast-relative marks and dwell metadata.

    Marks are logged by lib.sh's MARK() with nanosecond precision; $T0 is
    written by recorder.sh immediately before `asciinema rec` starts, and is the
    only clock precise enough to align them (the cast header's own `timestamp`
    is whole seconds). FAST_RECORD may append a tab-separated ``dwell=N`` field;
    it is returned separately so native marker labels stay human-readable.
    """
    marks, dwells, waits, dropped = [], [], [], 0
    with open(path, encoding="utf-8") as fh:
        for ln in fh:
            ln = ln.rstrip("\n")
            if not ln.strip():
                continue
            stamp, _, label = ln.partition(" ")
            if label.startswith("wait:") and "\tstart=" in label:
                waits.append(parse_wait(path, ln, stamp, label, t0, shift, duration))
                continue
            dwell = 0.0
            if "\tdwell=" in label:
                label, dwell_text = label.rsplit("\tdwell=", 1)
                try:
                    dwell = float(dwell_text)
                except ValueError:
                    sys.exit(f"{path}: cannot parse dwell in {ln!r}")
            try:
                t = float(stamp) - t0 + shift
            except ValueError:
                sys.exit(f"{path}: cannot parse timestamp in {ln!r}")
            if t < 0 or t > duration:
                dropped += 1
                continue
            marks.append((t, label.strip()))
            dwells.append(dwell)
    if dropped:
        print(
            f"warning: dropped {dropped} mark(s) outside the cast (0..{duration:.2f}s)",
            file=sys.stderr,
        )
    ordered = sorted(zip(marks, dwells), key=lambda item: item[0][0])
    waits = sorted(w for w in waits if w[1] > w[0])
    return [mark for mark, _ in ordered], [dwell for _, dwell in ordered], waits


def parse_wait(path, ln, stamp, label, t0, shift, duration):
    """Parse a WAIT_SPAN line into cast-relative (start, end, show).

    The span is clipped to the cast; a span entirely outside it collapses to
    start == end and is discarded by the caller.
    """
    fields = dict(f.split("=", 1) for f in label.split("\t")[1:] if "=" in f)
    try:
        end = float(stamp) - t0 + shift
        start = float(fields["start"]) - t0 + shift
        show = float(fields.get("show", "0.5"))
    except (KeyError, ValueError):
        sys.exit(f"{path}: cannot parse wait in {ln!r}")
    clip = lambda t: max(0.0, min(duration, t))
    return (clip(start), clip(end), show)


def compress_waits(cast: Cast, waits: list[tuple[float, float, float]]) -> float:
    """Squeeze each (start, end, show) span to at most `show` seconds.

    Frames inside a span are scaled (a REPL booting is fast-forwarded, not cut),
    and everything after it moves earlier. Spans already shorter than `show`
    are left alone. Returns the total seconds removed.

    This runs on the raw recording, before --restore-dwells, so the dwell
    preceding a wait is still restored in full (as a hold on the settled frame
    after the wait). Spans are applied latest-first so each one's coordinates
    are still valid when its turn comes.
    """
    removed = 0.0
    for start, end, show in sorted(waits, reverse=True):
        have = end - start
        if have <= show:
            continue
        scale = show / have
        cut = have - show

        def remap(t, start=start, end=end, scale=scale, cut=cut):
            if t <= start:
                return t
            if t < end:
                return start + (t - start) * scale
            return t - cut

        cast.events = [(remap(t), code, data) for t, code, data in cast.events]
        removed += cut
    return removed


def main() -> None:
    p = argparse.ArgumentParser(
        description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter
    )
    p.add_argument("cast", help="asciicast v3 file")
    p.add_argument(
        "--annotate",
        action="store_true",
        help="insert marker events from the marks log (replaces existing markers)",
    )
    p.add_argument("--marks", help="marks log (default: CASTNAME.marks.txt)")
    p.add_argument("--t0", help="t0 file (default: <cast>.t0, i.e. telescope.t0)")
    p.add_argument(
        "--shift", type=float, default=0.0, help="seconds to add to every mark/marker"
    )
    p.add_argument("--max-gap", type=float, help="clamp any interval longer than this")
    p.add_argument(
        "--trim-start",
        metavar="SPEC",
        help="discard the run-up before SPEC (seconds or marker:N), keeping screen state",
    )
    p.add_argument(
        "--trim-end", metavar="SPEC", help="discard everything after SPEC (seconds or marker:N)"
    )
    p.add_argument("--hold", type=float, help="seconds to linger on the final frame")
    p.add_argument("--list", action="store_true", help="print the segment table and exit")
    p.add_argument("--dump", metavar="FILE", help="write an editable timing table ('-' = stdout)")
    p.add_argument("--apply", metavar="FILE", help="rescale segments per a timing table")
    p.add_argument(
        "--restore-dwells",
        action="store_true",
        help="restore SAY/NV sleeps shortened by FAST_RECORD (requires --annotate)",
    )
    p.add_argument(
        "--keep-waits",
        action="store_true",
        help="with --annotate, leave WAIT_* spans at their real recorded length",
    )
    p.add_argument("-o", "--output", help="write the modified cast here ('-' = stdout)")
    p.add_argument("--in-place", action="store_true", help="overwrite the input cast")
    args = p.parse_args()

    cast = Cast.load(args.cast)
    base = os.path.splitext(args.cast)[0]

    if args.annotate:
        marks_path = args.marks or os.path.splitext(args.cast)[0] + ".marks.txt"
        t0_path = args.t0 or base + ".t0"
        for path in (marks_path, t0_path):
            if not os.path.exists(path):
                sys.exit(f"{path}: not found (needed by --annotate)")
        with open(t0_path, encoding="utf-8") as fh:
            t0 = float(fh.read().strip())
        marks, dwells, waits = read_marks(marks_path, t0, args.shift, cast.duration)
        cast.strip_markers()
        cast.insert_markers(marks)
        if waits and not args.keep_waits:
            removed = compress_waits(cast, waits)
            print(f"compressed {len(waits)} wait(s), removing {removed:.2f}s", file=sys.stderr)
        if args.restore_dwells:
            restore_dwells(cast, dwells)
            restored = sum(dwells[:-1]) if dwells else 0.0
            print(f"restored {restored:.2f}s of configured dwell time", file=sys.stderr)
        print(f"inserted {len(marks)} marker(s) from {marks_path}", file=sys.stderr)
    elif args.restore_dwells:
        sys.exit("--restore-dwells requires --annotate and the original marks log")
    elif args.shift:
        # No marks log involved: just move the markers already in the cast.
        existing = [(max(0.0, min(cast.duration, t + args.shift)), lbl) for _, t, lbl in cast.markers()]
        cast.strip_markers()
        cast.insert_markers(sorted(existing))

    # Trim first: it redefines the time base that the other options refer to.
    if args.trim_start or args.trim_end:
        start = resolve_spec(cast, args.trim_start) if args.trim_start else 0.0
        end = resolve_spec(cast, args.trim_end) if args.trim_end else cast.duration
        if end <= start:
            sys.exit(f"--trim-end ({end:.2f}s) must come after --trim-start ({start:.2f}s)")
        trim(cast, start, end)
    if args.max_gap is not None:
        clamp_gaps(cast, args.max_gap)
    if args.apply:
        apply_timing(cast, read_timing(args.apply))
    if args.hold:
        hold(cast, args.hold)

    if args.list:
        print_table(cast)
    if args.dump:
        dump_timing(cast, args.dump)

    modified = bool(
        args.annotate
        or args.restore_dwells
        or args.shift
        or args.max_gap is not None
        or args.apply
        or args.trim_start
        or args.trim_end
        or args.hold
    )
    if args.in_place or args.output:
        dest = args.cast if args.in_place else args.output
        if dest == "-":
            sys.stdout.write(cast.dumps())
        else:
            tmp = dest + ".tmp"
            with open(tmp, "w", encoding="utf-8") as fh:
                fh.write(cast.dumps())
            os.replace(tmp, dest)
            print(f"wrote {dest}", file=sys.stderr)
    elif modified and not (args.list or args.dump):
        # Nowhere to put the result: say so rather than silently doing nothing.
        sys.exit("nothing written; pass -o FILE or --in-place")


if __name__ == "__main__":
    main()
