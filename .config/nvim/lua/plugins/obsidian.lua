-- obsidian provides convenient highlighting for markdown, and obsidian-like notetaking
return {
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {

      -- don't add yaml frontmatter automatically to markdown
      disable_frontmatter = true,

      -- disable the icons and highlighting, since this is taken care of by render-markdown plugin
      ui = { enable = false },

      mappings = {
        -- Default <CR> mapping will convert a line into a checkbox if not in
        -- a link or follow it if in a link. This makes it only follow a link.
        ["<CR>"] = {
          action = function()
            if require("obsidian").util.cursor_on_markdown_link(nil, nil, true) then
              return "<cmd>ObsidianFollowLink<CR>"
            end
          end,
          opts = { buffer = true, expr = true },
        },
      },

      -- Default is to add a unique id to the beginning of a note filename;
      -- this disables it
      note_id_func = function(title)
        return title
      end,

      -- Default is "wiki"; this keeps it regular markdown
      preferred_link_style = "markdown",

      -- The following allows obsidian.nvim to work on general markdown files
      -- outside of obsidian vaults.
      workspaces = {
        {
          name = "no-vault",
          path = function()
            return assert(vim.fs.dirname(vim.api.nvim_buf_get_name(0)))
          end,
          overrides = {
            notes_subdir = vim.NIL,
            new_notes_location = "current_dir",
            templates = { folder = vim.NIL },
            disable_frontmatter = true,
          },
        },
      },

      -- Open URL under cursor in browser (uses `open` for MacOS).
      follow_url_func = function(url)
        vim.inspect(vim.system({ "open", url }))
      end,
    },

    keys = {
      { "<leader>os", "<cmd>ObsidianSearch<cr>", desc = "[o]bsidian [s]earch" },
      { "<leader>on", "<cmd>ObsidianLinkNew<cr>", mode = { "v" }, desc = "[o]bsidian [n]ew link" },
      { "<leader>ol", "<cmd>ObsidianLink<cr>", mode = { "v" }, desc = "[o]bsidian [l]ink to existing" },
      { "<leader>od", "<cmd>ObsidianDailies -999 0<cr>", desc = "[o]bsidian [d]ailies" },
      { "<leader>ot", "<cmd>ObsidianTags<cr>", desc = "[o]bsidian [t]ags" },
    },
  },
}
