-- toggleterm provides a terminal in vim you can send code to
return {
  {
    "akinsho/toggleterm.nvim",

    -- later versions break sending visual selection with gxx
    commit = "c80844fd52ba76f48fabf83e2b9f9b93273f418d",

    config = function()
      -- tweak the sizes of the new terminal
      require("toggleterm").setup({
        size = function(term)
          if term.direction == "horizontal" then
            return 15
          elseif term.direction == "vertical" then
            return vim.o.columns * 0.5
          end
        end,
      })

      -- Always use insert mode when entering a terminal buffer, even with mouse click.
      -- NOTE: Clicking with a mouse a second time enters visual select mode, just like in a text buffer.
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "*",
        callback = function()
          vim.cmd("if &buftype == 'terminal' | startinsert | endif")
        end,
      })

      -- Patch toggleterm to use bracketed paste (special escape codes before
      -- and after the text to be pasted)
      -- https://en.wikipedia.org/wiki/Bracketed-paste
      -- https://cirw.in/blog/bracketed-paste
      vim.api.nvim_create_user_command(
        "ToggleTermSendBracketedPaste",
        function(args)
          require("toggleterm").exec("\x1b[200~", 1)
          require("toggleterm").send_lines_to_terminal("visual_selection", false, args)
          require("toggleterm").exec("\x1b[201~", 1)
        end,
        { range = true, nargs = "?" }
      )
    end,

    keys = {
      { "gxx", ":ToggleTermSendCurrentLine<CR><CR>", desc = "Send current line to terminal" },
      { "gx", ":ToggleTermSendBracketedPaste<CR><CR>", desc = "Send selection to terminal", mode = "x" },

      {
        "<leader>cd",
        "/```{r<CR>NjV/```<CR>k<Esc>:ToggleTermSendBracketedPaste<CR>/```{r<CR>",
        desc = "Send RMarkdown chunk to R",
      },
      -- Immiedately after creating the terminal, disable the cursorline.
      -- This otherwise looks confusing with a single, differently-colored line at
      -- the bottom of the terminal when commands are running.
      { "<leader>t", ":ToggleTerm direction=vertical<CR><C-\\><C-n>:set nocul<CR>i", desc = "New terminal on right" },
    },
  },
}
