return {
  "R-nvim/R.nvim",

  -- Still in experimental mode.
  -- enabled = false,

  lazy = false,
  config = function()
    local opts = {

      -- Disable highlighting of R in the terminal
      hl_term = false,

      -- Use default pdf viewer (or none)
      pdfviewer = "",

      -- This is intended to be used with tmux. Viewing a dataframe with
      -- <localleader>rv will save the dataframe to file, open a new tmux
      -- pane, and run visidata on that file. Quitting visidata will close that
      -- pane.
      view_df = {
        open_app = "tmux split-window -v vd", 
      },

      -- Override some of the built-in commands to match historical commands in
      -- these dotfiles.
      hook = {
        on_filetype = function()
          vim.api.nvim_buf_set_keymap(0, "n", "gxx", "<Plug>RDSendLine", {})
          vim.api.nvim_buf_set_keymap(0, "v", "gx", "<Plug>RSendSelection", {})
          vim.api.nvim_buf_set_keymap(0, "n", "<leader>k", "<Plug>RMakeHTML", {})
          vim.api.nvim_buf_set_keymap(0, "n", "<leader>cd", "<Plug>RSendChunk<CR><Plug>RNextRChunk", {})
        end,
        -- Optional notification of which nvimcom is being used
        -- after_R_start = function()
        --   require('r.send').cmd('paste("r.nvim plugin is using this nvimcom:", system.file(package="nvimcom"))')
        -- end, 
      },
      R_args = { "--no-save" },
    }
    require("r").setup(opts)
  end,
}
