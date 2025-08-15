# Configuration file for the Sphinx documentation builder.
#
# This file only contains a selection of the most common options. For a full
# list see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Path setup --------------------------------------------------------------

# If extensions (or modules to document with autodoc) are in another directory,
# add these directories to sys.path here. If the directory is relative to the
# documentation root, use os.path.abspath to make it absolute, like shown here.
#
# import os
# import sys
# sys.path.insert(0, os.path.abspath('.'))


# -- Project information -----------------------------------------------------

project = 'dotfiles'
copyright = '2020, Ryan Dale'
author = 'Ryan Dale'


# -- General configuration ---------------------------------------------------

# Add any Sphinx extension module names here, as strings. They can be
# extensions coming with Sphinx (named 'sphinx.ext.*') or your custom
# ones.
import sys
sys.path.insert(0, ".")
extensions = [
    "sphinx.ext.autosectionlabel",
    "details_ext",
    "plugin_metadata_ext"
]

# Add any paths that contain templates here, relative to this directory.
templates_path = ['_templates']

# List of patterns, relative to source directory, that match files and
# directories to ignore when looking for source files.
# This pattern also affects html_static_path and html_extra_path.
exclude_patterns = ['_build', 'Thumbs.db', '.DS_Store']


# -- Options for HTML output -------------------------------------------------

# The theme to use for HTML and HTML Help pages.  See the documentation for
# a list of builtin themes.
#
html_theme = 'alabaster'

# Add any paths that contain custom static files (such as style sheets) here,
# relative to this directory. They are copied after the builtin static files,
# so a file named "default.css" will overwrite the builtin "default.css".
html_static_path = ['_static']

html_theme_options = {
    'show_relbars': True,
}

# Running `make linkcheck` will ensure links are working. However, some sites
# are resistant to scraping, so need some tweaks here:
linkcheck_request_headers = {
    # Add a user agent to everything
    "*": {
        "User-Agent": "Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20100101 Firefox/10.0",
    }
}

# Avoids downloading the entire page to check anchors.
linkcheck_anchors = False

# Completely ignore these regexes
linkcheck_ignore = [
    r'https://apple.stackexchange.com',
    r'https://stackoverflow.com',
    r'www.gnu.org/software',
]
