-- nvim-tree is a file browser that opens on the left side
return {
  {
    "nvim-tree/nvim-tree.lua",

    -- don't lazy load; otherwise, opening a directory as first buffer doesn't trigger it.
    lazy = false,

    config = function()
      require("nvim-tree").setup({
        on_attach = function(bufnr)
          local api = require("nvim-tree.api")

          api.config.mappings.default_on_attach(bufnr)

          local function git_add()
            local node = api.tree.get_node_under_cursor()
            if node and node.absolute_path then
              vim.cmd("Git add " .. vim.fn.fnameescape(node.absolute_path))
              api.tree.reload()
            end
          end
            local function git_unstage()
          local node = api.tree.get_node_under_cursor()
          if node and node.absolute_path then
              vim.cmd("Git restore --staged " .. vim.fn.fnameescape(node.absolute_path))
            api.tree.reload()
          end
        end
        vim.keymap.set("n", "ga", git_add, { buffer = bufnr, desc = "Git Add" })
        vim.keymap.set("n", "gu", git_unstage, { buffer = bufnr, desc = "Git Unstage" })
        end,
        })
    end,
    keys = {
      { "<leader>fb", "<cmd>NvimTreeToggle<CR>", desc = "[f]ile [b]rowser toggle" },
    },
  },
}
