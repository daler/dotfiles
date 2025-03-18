return {
    "R-nvim/R.nvim",
    enabled = false,
    lazy = false,
    config = function()
        local opts = {
            quarto_chunk_hl = {
                 -- highlight = false,               -- Disable the highlighting
                 -- virtual_title = false,           -- Don't add the virtual text
                 bg = "#404040",                  -- Use a different background color
                 events = "BufEnter,TextChanged", -- Update the highlighting more often
            },


            hl_term = false,
           view_df = {
              open_app = "tmux split-window -v vd",  -- open dataframes in visidata
           },
            hook = {
                on_filetype = function()
                    vim.api.nvim_buf_set_keymap(0, "n", "gxx", "<Plug>RDSendLine", {})
                    vim.api.nvim_buf_set_keymap(0, "v", "gx", "<Plug>RSendSelection", {})
                    vim.api.nvim_buf_set_keymap(0, "n", "<leader>k", "<Plug>RMakeHTML", {})
                    vim.api.nvim_buf_set_keymap(0, "n", "<leader>cd", "<Plug>RSendChunk<CR><Plug>RNextRChunk", {})
                end
            },
            R_args = {"--no-save"},
            min_editor_width = 72,
            rconsole_width = 78,
            objbr_mappings = { -- Object browser keymap
                c = 'class', -- Call R functions
                ['<localleader>gg'] = 'head({object}, n = 15)', -- Use {object} notation to write arbitrary R code.
                v = function()
                    -- Run lua functions
                    require('r.browser').toggle_view()
                end
            },
            disable_cmds = {
                "RClearConsole",
                "RCustomStart",
                "RSPlot",
                "RSaveClose",
            },
        }
        require("r").setup(opts)
    end
}
