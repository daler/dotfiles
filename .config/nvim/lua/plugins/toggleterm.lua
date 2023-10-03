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
