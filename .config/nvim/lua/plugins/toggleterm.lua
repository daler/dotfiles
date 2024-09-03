-- terminal in vim you can send code to
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
    end,

    keys = {
      { "gxx", ":ToggleTermSendCurrentLine<CR><CR>", desc = "Send current line to terminal" },
      { "gx", ":ToggleTermSendVisualSelection<CR>'><CR>", desc = "Send selection to terminal", mode = "x" },
      {
        "<leader>cd",
        "/```{r<CR>NjV/```<CR>k<Esc>:ToggleTermSendVisualSelection<CR>/```{r<CR>",
        desc = "Send RMarkdown chunk to R",
      },
      -- Immiedately after creating the terminal, disable the cursorline.
      -- This otherwise looks confusing with a single, differently-colored line at
      -- the bottom of the terminal when commands are running.
      { "<leader>t", ":ToggleTerm direction=vertical<CR><C-\\><C-n>:set nocul<CR>i", desc = "New terminal on right" },
    },
  },
}
