-- Integration with a running R interpreter

-- Figure out if R.nvim's R session is ready to send lines to, otherwise send
-- to toggleterm instead
local function r_or_toggleterm(r_fn, toggleterm_keys)
  -- R.nvim sets R_Nvim_status to 7 once its session is ready, and resets it
  -- when the session exits.
  if vim.g.R_Nvim_status == 7 then
    r_fn()
  else
    require("toggleterm")
    vim.api.nvim_feedkeys(vim.keycode(toggleterm_keys), "n", false)
  end
end

return {
  "R-nvim/R.nvim",

  -- Only load the plugin if we can find an executable for R.
  cond = function()
    return vim.fn.executable("R") == 1
  end,

  opts = {
    -- These support syntax highlighting in the R interpreter
    Rout_more_colors = true,
    Rout_follow_colorscheme = true,
    -- config_tmux=false,
    rconsole_width = 80,

    -- By default, :RDSendLine will send the entire block (entire for-loop or
    -- entire function, for example). Disabling this sends just one line at
    -- a time.
    parenblock = false,
    min_editor_width = 18,
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

    disable_cmds = { "RDSendParagraph" },
    hook = {
      on_filetype = function()
        -- Send to R.nvim when its R session is ready, otherwise fall back to
        -- the same toggleterm commands used for other filetypes.

        -- With parenblock disabled, RDSendLine sends just the current line.
        vim.keymap.set("n", "gxx", function()
          r_or_toggleterm(function()
            vim.api.nvim_feedkeys(vim.keycode("<Plug>RDSendLine"), "m", false)
          end, ":ToggleTermSendCurrentLine<CR><CR>")
        end, { buffer = 0, desc = "Send current line to R.nvim or toggleterm" })

        vim.keymap.set("x", "gx", function()
          r_or_toggleterm(function()
            vim.api.nvim_feedkeys(vim.keycode("<Plug>RSendSelection"), "m", false)
          end, ":ToggleTermSendVisualSelection<CR><CR>")
        end, { buffer = 0, desc = "Send selection to R.nvim or toggleterm" })

        vim.keymap.set("n", "<leader>cd", function()
          r_or_toggleterm(function()
            require("r.rmd").send_current_chunk(true)
          end, "/```{r<CR>NjV/```<CR>k<Esc>:ToggleTermSendVisualLines<CR>/```{r<CR>")
        end, { buffer = 0, desc = "Send RMarkdown chunk to R.nvim or toggleterm" })

        vim.api.nvim_buf_set_keymap(0, "n", "<leader>k", "<Plug>RSend rmarkdown::render('%p')<CR>", {})
        vim.keymap.set("n", "<leader>k", function()
          local path = vim.api.nvim_buf_get_name(0)
          require("r.send").cmd('rmarkdown::render("' .. path .. '")')
        end, { buf = 0, desc = "Render Rmarkdown" })

        -- Avoid clobbering the punchlist <localleader>pd keymap
        pcall(vim.keymap.del, { "n", "v" }, "<LocalLeader>pd", { buffer = 0 })
      end,
    },
  },
  lazy = false,
}
