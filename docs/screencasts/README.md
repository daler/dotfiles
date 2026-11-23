# Screencasts for the docs

These scripts record scripted Neovim sessions, with on-screen captions and
keystrokes, as [asciinema](https://asciinema.org) casts. The docs embed those
`.cast` files directly with a browser player. You write a short shell script
that says "show this caption, press these keys", and the tooling handles
recording, timing, and embedding.

This infrastructure was built with a lot of help from LLMs (mostly Opus and Sol
in their various versions, mostly run through the Pi harness). The code has
**not** been thoroughly reviewed by hand. It has been tested heavily in
practice, though, and the worst likely failure is an annotation that looks odd.

For advice on *writing* a good cast for a new plugin (what to show, pitfalls
specific to some plugins), see [NEXT.md](NEXT.md).


## Quick start

Paths are relative to this directory (`docs/screencasts/`) unless they start
with `docs/`.

1. **Build the container** (once, from the repository root). Everything runs
   inside it, so you don't need nvim, asciinema, or any plugins on the host:

   ```bash
   podman build -t dotfiles --platform linux/amd64 --format docker .
   ```

2. **Write an instruction script** at `instructions/<name>_instructions.sh`.
   Copy an existing one, like `instructions/aerial_instructions.sh`, or start
   from the [template](#writing-an-instruction-script) below.

3. **Record.** In `rebuild-casts.sh`, add a `record <name>` line and comment out
   the others, then run the script from this directory:

   ```bash
   ./rebuild-casts.sh
   ```

   Make your terminal at least 150x40 first (see [Config](#config)). nvim opens
   and plays your script by itself. Don't type anything or resize the window.
   The output is `casts/<name>.cast`.

4. **Preview** it in a browser:

   ```bash
   ./preview.sh casts/<name>.cast
   ```

5. **Adjust the timing** if needed ([below](#adjusting-timing)), then
   **embed** it in an `.rst` file ([below](#embedding-a-cast-in-the-docs)) and
   run `docs/regenerate-docs-font.sh`.


## Files

| File | What it does |
|---|---|
| `rebuild-casts.sh` | Entry point. `record <name> [start] [end]` runs the container, records, then trims the cast to the given markers (default: start at `marker:0`, which removes the shell prompt shown before nvim starts). |
| `recorder.sh` | Runs inside the container. Starts nvim under `asciinema rec`, runs your instruction script in the background against it, then embeds timing markers in the cast. |
| `lib.sh` | The commands your instruction script uses (`SAY`, `NV`, ...). |
| `caption.lua` | nvim plugin that draws the caption and keystroke overlays. |
| `timing.py` | Edits a cast after recording: retime, trim, remove dead air. |
| `preview.sh` | Plays a cast in the browser, using the docs' player and fonts. |
| `instructions/` | One `<name>_instructions.sh` per cast. |
| `setup/` | Shared fixtures (demo git repos, sample files) used by instruction scripts. |
| `casts/` | Recorded output, referenced from the docs. |

How it works: `recorder.sh` starts nvim listening on `/tmp/nvim.sock`. Your
instruction script is a separate process that drives nvim over that socket
(RPC). Each `SAY`/`NV`/`TYPE` also logs a timestamped *mark*. After recording,
the marks become asciicast v3 *marker* events inside the cast, so each step can
be retimed separately.


## Writing an instruction script

### Template

```bash
#!/usr/bin/env bash
set -euo pipefail
source /gifs/lib.sh                 # absolute paths only -- see below
source /gifs/setup/demo_repo.sh     # optional: a shared fixture

MAKE_DEMO_REPO                      # fixture prep goes BEFORE WAIT_NVIM

WAIT_NVIM                           # block until nvim is up
SETUP "cd $DEMO_REPO" 'e scripts/summarize.py'   # silent stage-setting

SAY 'telescope is a fuzzy finder; <leader>ff finds files by name' 3.0
NV ',ff' 1.5
SAY 'Search for "setup"'
TYPE 'setu'
NV '<CR>' 2.0

NV ':qa!<CR>' 0.5                   # required: ends the recording
```

The leader key is `,`, so `<leader>ff` is sent as `NV ',ff'`.

### Commands

| Command | Use |
|---|---|
| `WAIT_NVIM` | Must come first after prep. Waits for nvim and checks that the caption overlay loaded. |
| `SETUP 'ex cmd' ...` | Runs ex commands invisibly: no cmdline text, no keystroke overlay, no mark. Use it for stage plumbing (`:cd`, `:e`, window layout) that isn't part of the demo. |
| `SAY 'text' [secs] [corner]` | Shows a caption for `secs` (default 1.4). Corner is `NE` (default), `NW`, `SE`, or `SW`; move it to keep popups visible. `''` clears the caption. Long text wraps automatically; `\n` forces a line break. |
| `NV 'keys' [secs]` | Sends keys (vim notation: `<CR>`, `<Esc>`, `<C-r>`), shows them in the keystroke overlay, then waits `secs` (default 0.4). |
| `TYPE 'text' [secs]` | Types one character at a time, waiting `secs` (default 0.04) after each. |
| `WAIT_LUA 'lua' [timeout]` | Blocks until the Lua chunk returns true, e.g. `'return #vim.diagnostic.get(0) >= 3'`. Use it for anything async (LSP attach, formatters). Fails the take on timeout (default 15s). |
| `WAIT_TERMINAL_PATTERN 'pat' [timeout]` | Blocks until a terminal buffer has a line matching a Lua pattern (for REPLs). |

Rules that will bite you:

- **Use absolute `source` paths** (`/gifs/...`). The script runs from
  `/dotfiles`, so a relative path fails, `set -e` exits, and nothing drives
  nvim.
- **End with `NV ':qa!<CR>'`.** Otherwise asciinema keeps recording until you
  quit nvim yourself.
- **Wait on real state for async things.** Use `WAIT_LUA` or
  `WAIT_TERMINAL_PATTERN` instead of a long dwell or `sleep`. Fast recording
  (below) shortens dwells, but these waits are never shortened.
- **Use `SAY`/`NV` dwell arguments for pauses.** Literal `sleep` calls and
  `TYPE`'s per-character delay are recorded as-is.

### Starting with a file already open

- **The file already exists in the image** (anything under `/dotfiles`): pass
  `NVIM_ARGS`, and nvim opens it at startup, so nothing needs to be recorded.
  Add `-e NVIM_ARGS=...` to the `podman run` command (in `rebuild-casts.sh` or
  your own). Paths are relative to `/dotfiles`:

  ```bash
  -e NVIM_ARGS='setup.sh'
  -e NVIM_ARGS="-c 'cd /root/dockeruser/demo' scripts/summarize.py"
  ```

- **The script creates the file** (`MAKE_DEMO_REPO` and similar): use `SETUP`
  after `WAIT_NVIM`. nvim starts at the same time as your script, so
  `NVIM_ARGS` would point at a file that doesn't exist yet.


## Recording

`./rebuild-casts.sh` is the normal path. It uses **fast recording** by default
(`FAST_RECORD=1`): during the take, every `SAY`/`NV` dwell is cut to
`MIN_DWELL` (0.1s), and the full durations are added back to the cast
afterwards. A 60-second cast records in a few seconds. Playback still pauses for
the durations in your script. The time is added as a hold on the settled frame
at the end of each step. The final `:qa!` dwell is not restored.

To record one cast by hand, run this from the repository root:

```bash
CASTNAME=<name>
podman run -v $PWD/docs/screencasts:/gifs --platform linux/amd64 \
  --name cast --rm -it -e FAST_RECORD=1 dotfiles \
  bash /gifs/recorder.sh /gifs/casts/$CASTNAME.cast /gifs/instructions/${CASTNAME}_instructions.sh
```

If you leave out the instruction script argument, you get a plain nvim that you
drive and quit yourself.

When it finishes, `recorder.sh` prints the segment table (see
[timing](#adjusting-timing)) and leaves only the `.cast` file.

### When a take fails

- `DRIVER FAILED (exit N)`: your script errored. `recorder.sh` quits nvim for
  you, deletes the partial cast, and prints `casts/<name>.log`. Read that file.
  The script's stdout/stderr go there, not to the screen, because they would
  overwrite the nvim view.
- `recorded command: nvim ...` is printed at the start, so you can check for an
  `NVIM_ARGS` typo.
- `WARNING: caption.lua did not load` means `caption.lua` has a syntax error.
  The cast will have no captions.
- To keep the raw timestamp log for debugging, set `MARKS=/gifs/marks.txt`.


## Previewing

```bash
./preview.sh casts/<name>.cast             # opens a browser; same player and fonts as the docs
./preview.sh -s 2 casts/<name>.cast        # 2x speed
./preview.sh --no-open casts/<name>.cast   # just print the URL
```

`--pause-on-markers` stops at each step. `./preview.sh -h` lists all options.


## Adjusting timing

Dump an editable table with one row per `SAY`/`NV`/`TYPE`:

```bash
./timing.py casts/<name>.cast --dump <name>.timing
```

```text
# One row per segment: <index> <duration> <label>
# Edit the duration column and re-apply with --apply.
# Intervals inside a segment are scaled, so each row is independent.
  -    3.79  (start)
  0    3.31  say:telescope fuzzy finder: <leader>ff finds files by name
  1    1.54  nv:,ff
  2    1.68  say:Search for "setup"
  3    2.65  type:setu
  4    1.70  say:Hit enter to open the file
  5    2.35  nv:<CR>
  6    0.25  nv::qa!<CR>
```

Edit the durations, then apply them. Frames inside a segment are scaled
proportionally, so typing stays evenly spaced. Leave out `--in-place` to write
to stdout, or use `-o` to write to a different file:

```bash
./timing.py casts/<name>.cast --apply <name>.timing --in-place
```

Repeat dump, edit, apply, and preview as often as needed. Other useful
operations:

```bash
# Trim: remove everything before marker 0 / after the last marker.
# Markers are indices from the table; Python-style negatives work.
./timing.py casts/<name>.cast --trim-start marker:0 --trim-end marker:-1 --in-place

# Shorten every gap longer than 1.5s without moving segment boundaries
./timing.py casts/<name>.cast --max-gap 1.5 --in-place

# Hold the final frame
./timing.py casts/<name>.cast --hold 2 --in-place
```

Note: `idle-time-limit`, whether set on the command line or in the player, sets
an upper bound on frame length and overrides long pauses you set here.


## Embedding a cast in the docs

Use the `asciinema` directive from `docs/asciinema_ext.py`. The path is
relative to the `.rst` file:

```rst
.. asciinema:: screencasts/casts/conform.cast
    :preload:
    :poster: npt:0:03
    :caption: **Format Python.** Run the formatter, then undo and redo its edits.
```

- `:poster: npt:0:03` shows the frame at 3 seconds before playback starts.
  You can also use text: `:poster: data:text/plain,Press play...`.
- Other options: `:loop:`, `:autoplay:`, `:speed:`, `:theme:`, `:font-size:`,
  `:idle-time-limit:` (see the note above).
- **Don't use `:rows:`/`:cols:`.** The player treats them as the terminal size,
  so a mismatch rewraps or clips the recording. Set the size when recording
  instead ([Config](#config)).
- The cast data is inlined into the HTML, so local `file://` previews work.
- Player styling lives in `docs/_static/custom.css`.

### Regenerate the font (required after adding casts)

The player renders text as HTML, so Nerd Font icons come from a font the docs
ship with, not from your terminal's font. `docs/_static/fonts/` holds a subset
of JetBrainsMono Nerd Font **Mono** that contains only the glyphs the committed
casts use. After adding or re-recording a cast, run this from the repository
root:

```bash
# needs fonttools + brotli, either of:
#   conda create -n fonttools -c conda-forge fonttools brotli && conda activate fonttools
#   pip install 'fonttools[woff]'
./docs/regenerate-docs-font.sh     # or: cd docs && make regenerate
# then commit the .woff2 files in docs/_static/fonts/
```

Skipping this step produces no error. Missing glyphs just show up as boxes
("tofu"). The script downloads a large font, so it isn't part of the docs
build.

### Upgrading the player

The vendored player lives in `docs/_static/asciinema/` (MIT license). asciicast
v3 needs version 3.9 or later.

```bash
npm pack asciinema-player@<version>
tar xzf asciinema-player-<version>.tgz
cp package/dist/bundle/asciinema-player.min.js \
   package/dist/bundle/asciinema-player.css \
   package/LICENSE docs/_static/asciinema/
```


## Config

Pass these as `-e VAR=value` to `podman run`. The instruction script runs
inside the same container, so it sees them too.

| Variable | Default | Effect |
|---|---|---|
| `CAST_COLS` / `CAST_ROWS` | 150 / 40 | Recorded terminal size. |
| `FAST_RECORD` | 0 (1 in `rebuild-casts.sh`) | Shorten dwells while recording, then restore them in the cast. |
| `MIN_DWELL` | 0.1 | The shortened dwell used by `FAST_RECORD`. |
| `NVIM_ARGS` | empty | Extra nvim arguments, e.g. a file to open. |
| `CAP_STYLE` | `reverse` | Caption look: `reverse` (solid colored block) or `bold` (colored bold text). |
| `KEYCAST` | 1 | 0 hides the keystroke overlay. |
| `KEYCAST_POS` | `SE` | Keystroke overlay corner. |
| `VERBOSE` | 1 | Report overlay RPC failures in the log. |

**Terminal size:** your terminal must be at least `CAST_COLS`x`CAST_ROWS`. Some
asciinema versions won't record a size larger than the real terminal. Check the
cast header:

```bash
head -c 300 casts/<name>.cast   # look at "cols"/"rows"
```

If the header shows your terminal's size instead, enlarge the terminal or
record outside tmux. Don't resize during a take: resizes are recorded, and nvim
re-lays out its windows mid-cast.
