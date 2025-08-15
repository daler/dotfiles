"""
A Sphinx extension that provides a directive to display plugin metadata
extracted from git history.

Usage:
    .. plugin-metadata::
       :name: plugin-name
       :file: optional-filename-if-different

This will automatically extract:
- Date added (first commit with this plugin)
- Date updated (most recent commit modifying this plugin)
- Date removed (if applicable)

The data is extracted from git history at build time.
"""

import subprocess
import docutils.nodes
from docutils import nodes
import docutils.statemachine
import sphinx.util.nodes
from docutils.parsers.rst import Directive, directives
from datetime import datetime
import json
import pathlib
import os


class NestedParseNodes:
    """Helper class for nested parsing of reStructuredText. From
    https://www.drmoron.org/posts/sphinx-nested-parse-extensions/"""

    def __init__(self):
        self.source = docutils.statemachine.ViewList()

    def add_line(self, sourceline, filename, linenumber):
        self.source.append(sourceline, filename, linenumber)

    def get_nodes(self, directive):
        node = docutils.nodes.section()
        node.document = directive.state.document

        sphinx.util.nodes.nested_parse_with_titles(directive.state, self.source, node)
        return node.children


class plugin_metadata(nodes.Element, nodes.General):
    pass


class PluginMetadataDirective(Directive):
    has_content = False
    required_arguments = 0
    optional_arguments = 0
    final_argument_whitespace = True
    option_spec = {
        # Used to fill in config file; more convenient than providing full
        # config filename in most cases.
        "name": directives.unchanged_required,
        # Explicitly provide config file
        "file": directives.unchanged,
        # Optional explanation of why deprecated, though should be filled in if
        # the file was removed.
        "deprecation": directives.unchanged,
    }

    def run(self):
        plugin_name = self.options.get("name")
        if not plugin_name:
            raise self.error("Plugin name must be provided")

        file_name = self.options.get("file", None)
        if file_name is None:
            file_name = f"../.config/nvim/lua/plugins/{plugin_name}.lua"
        deprecation = self.options.get("deprecation", "")

        history = get_git_history(plugin_name, file_name)

        # We'll build up the node bit by bit, using ReST format, which will
        # then get parsed into HTML.
        parse = NestedParseNodes()
        current_source = self.state.document.current_source
        current_line = self.lineno

        # Helper functions
        _hash_link = (
            lambda hash: f"`{hash} <https://github.com/daler/dotfiles/commit/{hash}>`__ "
        )

        def _add_line(text, newline=True):
            parse.add_line(text, current_source, current_line)
            if newline:
                parse.add_line("", current_source, current_line)

        # For later CSS styling
        _add_line(".. container:: plugin-metadata")

        if history["added"]:
            _add_line(f"   :Added:")
            _add_line(
                f"    * {history['added']['date']} "
                f"{_hash_link(history['added']['hash'])} "
                f"*{history['added']['message']}*"
            )

        if history["changes"]:
            _add_line("   :Changes:")
            for change in history["changes"]:
                _add_line(
                    f"    * {change['date']} "
                    f"{_hash_link(change['hash'])}"
                    f"*{change['message']}*"
                )

        # if history["removed"]["date"] != "N/A":
        #     _add_line("   .. warning::")
        #     _add_line("     :Removed:")
        #     _add_line(
        #         f"        {history['removed']['date']} "
        #         f"{_hash_link(history['removed']['hash'])} "
        #         f"*{history['removed']['message']}*",
        #     )
        if deprecation:
            _add_line("    .. warning::")
            _add_line("     :DEPRECATED: " + deprecation)

        # This is where the nested parsing is useful: we can use the details
        # extension and it'll be parsed correctly
        if os.path.exists(file_name):
            file_label = file_name.replace("../", "")
            _add_line("   .. details:: Config")
            _add_line(
                f"      This can be found in :file:`{file_label}`:",
            )
            _add_line(f"      .. literalinclude:: {file_name}", False)
            _add_line("         :language: lua")
        else:
            print(f"{file_name} does not exist")

        # Return the parsed nodes
        return parse.get_nodes(self)


def get_git_history(plugin_name, file_name=None):
    """Extract git history for a plugin file.
    Cache results for quicker turnaround time when developing docs.
    """

    global _git_history_cache

    cache_key = f"{plugin_name}:{file_name}"
    if cache_key in _git_history_cache:
        print(f"Using cached git history for {plugin_name}")
        return _git_history_cache[cache_key]

    print(f"Fetching git history for {plugin_name}")

    # Look for:
    #   - plugin name mentioned in commit messages
    #   - plugin name in .lua file contents (to catch them when they were in
    #   a giant init.lua file)
    #   - plugin name in filename
    #
    # In each case, we keep track of results in strings of the form
    # "YYYY-MM-DD|hash|message"
    try:
        # Commit messages
        cmd_changes_commit_messages = [
            "git",
            "log",
            "--format=%ad|%h|%s",
            "--date=short",
            "-i",  # Case insensitive
            f"--grep={plugin_name}",  # Search in commit messages
        ]
        changes_commit_messages = (
            subprocess.check_output(cmd_changes_commit_messages, text=True)
            .strip()
            .split("\n")
        )

        # Changed file contents
        cmd_changes_file_contents = [
            "git",
            "log",
            "--format=%ad|%h|%s",
            "--date=short",
            "-i",  # Case insensitive
            "-p",  # Show patches
            f"-S{plugin_name}",  # Search for string in file contents
            "--",  # Separator between options and file paths
            "*.lua",  # Only search in .lua files
        ]
        changes_file_contents = (
            subprocess.check_output(cmd_changes_file_contents, text=True)
            .strip()
            .split("\n")
        )

        # Changed filenames containing the plugin name
        cmd_changes_filenames = [
            "git",
            "log",
            "--format=%ad|%h|%s",
            "--date=short",
            "-i",  # Case insensitive
            "--name-only",  # Show filenames
            "--",  # Separator between options and file paths
            f"*{plugin_name}*.lua",  # Files containing plugin name
        ]
        try:
            changes_filenames = (
                subprocess.check_output(cmd_changes_filenames, text=True)
                .strip()
                .split("\n")
            )
            changes_filenames = [
                r for r in changes_filenames if r and r.startswith("20")
            ]  # Keep only date lines
        except subprocess.CalledProcessError:
            changes_filenames = []

        # Actual file changes. If had originally split files (and was always
        # rigorous about git commits), this would have been all we needed.
        cmd_file_changes = [
            "git",
            "log",
            "--format=%ad|%h|%s",
            "--date=short",
            "--",
            file_name,
        ]
        try:
            file_changes = (
                subprocess.check_output(cmd_file_changes, text=True).strip().split("\n")
            )
        except subprocess.CalledProcessError:
            file_changes = []

        # Sorted list of unique changes without empty lines or non-date lines
        all_changes = set(
            changes_commit_messages
            + changes_file_contents
            + changes_filenames
            + file_changes
        )
        all_changes = [r for r in all_changes if r and r.startswith("20")]
        changes_info = sorted(list(all_changes))

        # Remove the first commit (which is the "added" commit) from changes if it exists
        if changes_info:
            added_info = changes_info.pop(0)
        else:
            added_info = "Unknown||"
        added_hash = added_info.split("|")[1] if len(added_info.split("|")) > 1 else ""
        changes_info = [
            change
            for change in changes_info
            if change
            and (
                not added_hash
                or len(change.split("|")) < 2
                or change.split("|")[1] != added_hash
            )
        ]

        cmd_removed = [
            "git",
            "log",
            "--diff-filter=D",
            "--format=%ad|%h|%s",
            "--date=short",
            "--",
            file_name,
        ]
        removed_info = subprocess.check_output(cmd_removed, text=True).strip()

        # Parse changes
        changes = []
        for change in changes_info:
            if change:
                parts = change.split("|", 2)
                hash = parts[1]

                # I guess we could have "|" in messages
                assert len(parts) >= 3

                changes.append({"date": parts[0], "hash": hash, "message": parts[2]})

        added_parts = added_info.split("|", 2) if added_info else ["Unknown", "", ""]
        removed_parts = removed_info.split("|", 2) if removed_info else ["N/A", "", ""]

        result = {
            "added": {
                "date": added_parts[0],
                "hash": added_parts[1] if len(added_parts) > 1 else "",
                "message": added_parts[2] if len(added_parts) > 2 else "",
            },
            "changes": sorted(changes, key=lambda x: x["date"]),
            "removed": {
                "date": removed_parts[0],
                "hash": removed_parts[1] if len(removed_parts) > 1 else "",
                "message": removed_parts[2] if len(removed_parts) > 2 else "",
            },
        }

        # Store in cache
        _git_history_cache[cache_key] = result

        return result
    except subprocess.CalledProcessError:
        result = {
            "added": {"date": "Unknown", "hash": "", "message": ""},
            "changes": [],
            "removed": {"date": "N/A", "hash": "", "message": ""},
        }

        # Store in cache
        _git_history_cache[cache_key] = result

        return result


# Global cache for git history
_git_history_cache = {}
_cache_file = pathlib.Path(".git_history_cache.json")
_cache_max_age_days = 7  # Only regenerate cache if older than this many days


def load_cache():
    """Load the git history cache from disk if it exists and is recent enough."""
    global _git_history_cache

    if not _cache_file.exists():
        print("No cache file found, will create new cache")
        _git_history_cache = {}
        return

    # Check if cache file is recent enough
    cache_age = datetime.now() - datetime.fromtimestamp(_cache_file.stat().st_mtime)
    if cache_age.days > _cache_max_age_days:
        print(
            f"Cache is {cache_age.days} days old (older than {_cache_max_age_days} days), will regenerate"
        )
        _git_history_cache = {}
        return

    # Cache exists and is recent enough, load it
    try:
        with open(_cache_file, "r") as f:
            _git_history_cache = json.load(f)
        print(
            f"Loaded git history cache with {len(_git_history_cache)} entries (age: {cache_age.days} days)"
        )
    except (json.JSONDecodeError, IOError) as e:
        print(f"Error loading git history cache: {e}")
        _git_history_cache = {}


def save_cache():
    """Save the git history cache to disk if it has been modified."""
    if not _git_history_cache:
        print("No cache entries to save")
        return

    _cache_file.parent.mkdir(exist_ok=True)
    try:
        with open(_cache_file, "w") as f:
            json.dump(_git_history_cache, f)
        print(f"Saved git history cache with {len(_git_history_cache)} entries")
    except IOError as e:
        print(f"Error saving git history cache: {e}")


def setup(app):
    app.add_node(plugin_metadata)
    app.add_directive("plugin-metadata", PluginMetadataDirective)

    # Add some CSS for styling
    app.add_css_file("plugin_metadata.css")

    # Load the cache when the extension is set up
    load_cache()

    # Save the cache when the build is finished, but only if we've added new entries
    app.connect("build-finished", lambda app, exc: save_cache())

    return {
        "version": "0.4",
        "parallel_read_safe": True,
        "parallel_write_safe": True,
    }
