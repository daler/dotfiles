-- Integration with a running R interpreter
return {
  "R-nvim/R.nvim",

  -- Only load the plugin if we can find an executable for R.
  cond = function()
    return vim.fn.executable("R") == 1
  end,

  opts = {
    -- These support syntax highlighting in the R interpreter
    Rout_more_colors=true,
    Rout_follow_colorscheme=true,
    -- config_tmux=false,
    rconsole_width=80,


    -- by default, :RDSendLine will send the entire block (entire for-loop or entire function, for example). Disabling this sends just one line at a time.
    parenblock=false,
   min_editor_width=18,
    view_df = {
      -- open a dataframe with <localleader>rv in visidata in a new nvim terminal window.
      -- Note: using tmux as per the docs does not work when on an interactive
      -- node, so we use local terminal here.
      open_app = "terminal:vd",
    },
    r_ls = {
      -- Completion lists are created by the built-in language server per
      -- package, per version. It can take a while to build completion lists,
      -- especially when you bounce between environments. They are cached
      -- though, so it's a one-time cost. If you're OK paying that cost for
      -- convenient completion, set completion = true (which is the default)
      completion = false,
    },

    hook = {
       on_filetype = function()
         vim.api.nvim_buf_set_keymap(0, "n", "gxx", "<Plug>RDSendLine", {})
         vim.api.nvim_buf_set_keymap(0, "v", "gx", "<Plug>RSendSelection", {})
         vim.api.nvim_buf_set_keymap(0, "n", ",cd", "<Plug>RDSendChunk", {})
         vim.api.nvim_buf_set_keymap(0, "n", "<leader>k", "<Plug>RSend rmarkdown::render('%p')<CR>", {})
         vim.keymap.set("n", "<leader>k",
          function()
           local path = vim.api.nvim_buf_get_name(0)
           require("r.send").cmd('rmarkdown::render("' .. path .. '")')
          end,
          { buf = true, desc = "Render Rmarkdown" })

        -- In 0.99.4 which is used here for compatibility with older
        -- R versions, the RDSendLine command sends the entire treesitter block
        -- (entire function, entire for-loop, etc) rather than just one line.
        -- This is fixed in 0.99.5, but patching here so we can use it with 0.99.4.
        -- The behavior is still accessible with the default <localleader>d.
        vim.keymap.set("n", "gxx", function()
          local line = vim.api.nvim_get_current_line()
          require("r.send").cmd(line)
          vim.cmd("normal! j")
        end, { buf = true })
      end,
    },
  },
  lazy=false
}
