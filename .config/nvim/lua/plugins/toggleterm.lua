return  {
  -- Terminal within nvim
  'akinsho/toggleterm.nvim',
  lazy = false,
  priority=999,
  config = function()
    require("toggleterm").setup{
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.5
        end
      end
    }

    vim.keymap.set('n', 'gxx', ':ToggleTermSendCurrentLine<CR><CR>',
      { desc = "Send current line to terminal" })

    vim.keymap.set('x', 'gx', ':ToggleTermSendVisualSelection<CR><CR>',
      { desc = "Send selection to terminal" })

    -- " <leader>cd sends RMarkdown code chunk and move to the next one.
    -- "
    -- " Breaking this down...
    -- "
    -- " /```{<CR>                                 -> search for chunk delimiter (recall <CR> is Enter)
    -- " N                                         -> find the *previous* match to ```{
    -- " j                                         -> move down one line from the previous match
    -- " V                                         -> enter visual line-select mode
    -- " /^```\n<CR>                               -> select until the next chunk delimiter by itself on the line (which should be the end)
    -- " k                                         -> go up one line from that match so we don't include that line
    -- " <Esc>:ToggleTermSendVisualSelection<CR>   -> send the selection to the terminal
    -- " /```{r<CR>                                -> go to the start of the next chunk
    vim.keymap.set('n', '<leader>cd', '/```{<CR>NjV/```\n<CR>k<Esc>:ToggleTermSendVisualSelection<CR>/```{r<CR>',
      { desc = "Send RMarkdown chunk to R"})

    vim.keymap.set('n', '<leader>t', ':ToggleTerm direction=vertical<CR>',
      { desc = "New terminal on right"})

    -- Render RMarkdown to HTML
    vim.api.nvim_create_autocmd('FileType', { pattern = "rmarkdown",
    callback = function()
      vim.keymap.set('n', '<leader>k', ':TermExec cmd=\'rmarkdown::render("%:p")\'<CR>',
        { desc = "Render RMarkdown to HTML" })
      end,
    })

    -- Run Python file in IPython
    vim.api.nvim_create_autocmd('FileType', { pattern = "python",
    callback = function()
      vim.keymap.set('n', '<leader>k', ':TermExec cmd=\'run %:p\'<CR>',
        { desc = "Run Python file in IPython" })
      end,
    })
  end,
}
