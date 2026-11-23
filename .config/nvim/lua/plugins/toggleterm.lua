-- toggleterm provides a terminal in vim you can send code to
return {
  {
    "akinsho/toggleterm.nvim",

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
        -- Always enter insert mode when switching (or clicking) into the
        -- terminal. With persist_mode = true (the default), toggleterm instead
        -- restores whatever mode the terminal was last in, which is usually
        -- normal mode after leaving it with <C-\><C-n> or a mouse click.
        start_in_insert = true,
        persist_mode = false,
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

      -- Send the current line with its indentation intact. IPython
      -- auto-indents after a block opener, so toggleterm's trimmed send can't
      -- dedent (e.g. a `return` after a loop body). Instead, Ctrl-U (the \x15
      -- part) first clears whatever indentation IPython inserted, then the
      -- line's own indentation is used.
      vim.api.nvim_create_user_command(
        "ToggleTermSendCurrentLineIndented",
        function(args)
          local id = tonumber(args.args) or 1
          require("toggleterm").exec("\x15" .. vim.api.nvim_get_current_line(), id)
        end,
        { nargs = "?" }
      )
    end,

    keys = {
      {
        "gxx",
        function()
          if vim.bo.filetype == "python" then
            return ":ToggleTermSendCurrentLineIndented<CR><CR>"
          end
          return ":ToggleTermSendCurrentLine<CR><CR>"
        end,
        expr = true,
        desc = "Send current line to terminal",
      },
      {
        "gx",
        function()
          -- Bracketed paste keeps indented Python blocks intact in IPython,
          -- but other shells (macOS's bash 3.2, plain R in a terminal) don't
          -- always support it. So everywhere else use toggleterm's plain
          -- line-by-line send (which trims whitespace).
          if vim.bo.filetype == "python" then
            return ":ToggleTermSendBracketedPaste<CR><CR>"
          end
          return ":ToggleTermSendVisualSelection<CR><CR>"
        end,
        expr = true,
        desc = "Send selection to terminal",
        mode = "x",
      },

      {
        "<leader>cd",
        "/```{r<CR>NjV/```<CR>k<Esc>:ToggleTermSendVisualLines<CR>/```{r<CR>",
        desc = "Send RMarkdown chunk to terminal",
      },
      -- Immiedately after creating the terminal, disable the cursorline.
      -- This otherwise looks confusing with a single, differently-colored line at
      -- the bottom of the terminal when commands are running.
      { "<leader>t", ":ToggleTerm direction=vertical<CR><C-\\><C-n>:set nocul<CR>i", desc = "New terminal on right" },
    },
  },
}
