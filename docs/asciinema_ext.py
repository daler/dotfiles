"""
Sphinx extension providing an ``asciinema`` directive that embeds a locally
vendored asciinema-player (docs/_static/asciinema/) for a .cast file.

Usage::

    .. asciinema:: screencasts/casts/telescope.cast
        :speed: 1.0
        :idle-time-limit: 1.5
        :caption: Find files by name and open a selected result.
        :autoplay:
        :loop:

Note that ``:rows:``/``:cols:`` are deliberately *not* used above. They override
the geometry recorded in the cast header instead of scaling to it, so a value
that disagrees with the recording produces wrapped output (player narrower than
the cast) or a dead margin (player wider). Set the geometry at record time with
``CAST_COLS``/``CAST_ROWS`` in ``docs/screencasts/recorder.sh`` and let the
header speak for itself; this directive warns on a mismatch.

The path is relative to the .rst file containing the directive (or absolute
from the docs source dir if it starts with "/").

The cast is inlined into the page as a JS string and handed to the player as a
``data:`` URL rather than being fetched from ``_static/``. This is deliberate:
the player always loads recordings with ``fetch()``, and a page opened straight
off disk (``file://...``, which is how most people check a local docs build)
is not allowed to fetch sibling files. Inlining means "open the html file and
it works", at the cost of some page weight.
"""

import json
import os
from docutils import nodes
from docutils.parsers.rst import Directive, directives
from sphinx.util import logging

logger = logging.getLogger(__name__)

TEMPLATE = """
<div class="asciinema-embed">
  <div id="{div_id}"></div>
</div>
<script>
  (function () {{
    var cast = {data};
    function create() {{
      AsciinemaPlayer.create(
        "data:application/json;charset=utf-8," + encodeURIComponent(cast),
        document.getElementById("{div_id}"),
        {opts}
      );
    }}
    if (document.readyState === "loading") {{
      document.addEventListener("DOMContentLoaded", create);
    }} else {{
      create();
    }}
  }})();
</script>
"""


def _js_string(text):
    """JSON-encode text as a JS string literal that is safe inside <script>."""
    encoded = json.dumps(text)
    # Neither "</script>" nor a bare U+2028/9 may appear literally in a script.
    return (
        encoded.replace("<", "\\u003c")
        .replace(">", "\\u003e")
        .replace("\u2028", "\\u2028")
        .replace("\u2029", "\\u2029")
    )


def _js(value):
    if isinstance(value, bool):
        return "true" if value else "false"
    if isinstance(value, (int, float)):
        return repr(value)
    return '"%s"' % value


class AsciinemaDirective(Directive):
    required_arguments = 1
    optional_arguments = 0
    final_argument_whitespace = False
    option_spec = {
        "rows": directives.positive_int,
        "cols": directives.positive_int,
        "speed": float,
        "idle-time-limit": float,
        "theme": directives.unchanged,
        "poster": directives.unchanged,
        "caption": directives.unchanged,
        "font-size": directives.unchanged,
        "fit": directives.unchanged,
        "autoplay": directives.flag,
        "loop": directives.flag,
        "preload": directives.flag,
    }

    def run(self):
        env = self.state.document.settings.env

        # Resolve relative to the current document, like .. image:: does.
        _, rel_path = env.relfn2path(self.arguments[0])
        abs_path = os.path.join(env.srcdir, rel_path)
        if not os.path.isfile(abs_path):
            logger.warning(
                "asciinema: cast file not found: %s" % abs_path,
                location=(env.docname, self.lineno),
            )
            return []

        # Rebuild this document when the recording changes.
        env.note_dependency(abs_path)

        with open(abs_path, encoding="utf-8") as fh:
            cast = fh.read()

        self._check_geometry(cast, env, abs_path)

        opts = {}
        for key in ("rows", "cols", "speed", "theme", "poster", "fit"):
            if key in self.options:
                opts[key] = self.options[key]
        if "idle-time-limit" in self.options:
            opts["idleTimeLimit"] = self.options["idle-time-limit"]
        if "font-size" in self.options:
            opts["fontSize"] = self.options["font-size"]
        for flag in ("autoplay", "loop", "preload"):
            if flag in self.options:
                opts[flag] = True

        html = TEMPLATE.format(
            div_id="asciinema-%s" % env.new_serialno("asciinema"),
            data=_js_string(cast),
            opts="{%s}" % ", ".join(
                "%s: %s" % (k, _js(v)) for k, v in sorted(opts.items())
            ),
        )
        player = nodes.raw("", html, format="html")
        if "caption" in self.options:
            caption_text = self.options["caption"]
            inline_nodes, messages = self.state.inline_text(caption_text, self.lineno)
            caption = nodes.caption(caption_text, "", *inline_nodes)
            figure = nodes.figure("", player, caption, classes=["screencast-figure"])
            return [figure, *messages]
        return [player]

    def _check_geometry(self, cast, env, abs_path):
        """Warn if :rows:/:cols: disagree with the cast's own header.

        The player treats these as the terminal size rather than a scale target,
        so a mismatch silently rewraps or letterboxes the recording -- an easy
        thing to misdiagnose as a bad recording. Missing/unparseable headers are
        ignored: this is a convenience check, not validation.
        """
        try:
            header = json.loads(cast.splitlines()[0])
        except (ValueError, IndexError):
            return
        # v3 nests geometry under "term"; v1/v2 put width/height at top level.
        term = header.get("term") or {}
        actual = {
            "cols": term.get("cols", header.get("width")),
            "rows": term.get("rows", header.get("height")),
        }
        for key in ("cols", "rows"):
            want, have = self.options.get(key), actual[key]
            if want is not None and have is not None and want != have:
                logger.warning(
                    "asciinema: :%s: %d does not match the cast header (%d) in "
                    "%s; the player will rewrap or pad the recording. Drop the "
                    "option and re-record at the size you want instead."
                    % (key, want, have, os.path.basename(abs_path)),
                    location=(env.docname, self.lineno),
                )


def setup(app):
    app.add_directive("asciinema", AsciinemaDirective)
    app.add_css_file("asciinema/asciinema-player.css")
    app.add_js_file("asciinema/asciinema-player.min.js")
    return {"version": "0.3", "parallel_read_safe": True}
