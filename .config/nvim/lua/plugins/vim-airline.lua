return {
    -- Fancy line along bottom and tablines along top
    'vim-airline/vim-airline',

    dependencies = {'vim-airline/vim-airline-themes'},

    init = function ()
      -- theme that looks good with zenburn
      vim.cmd("let g:airline_theme='ayu_dark'")

      -- use powerline fonts; set to 0 if you don't have them installed
      vim.cmd("let g:airline_powerline_fonts = 1")

      -- use the tabline extension
      vim.cmd("let g:airline_extensions = ['tabline']")
      vim.cmd("let g:airline#extensions#tabline#enabled = 1")

      -- just show the basename of the open file
      vim.cmd("let g:airline#extensions#tabline#fnamemod = ':t'")

      -- Show a buffer number for easier switching
      vim.cmd("let g:airline#extensions#tabline#buffer_nr_show = 1")
    end,
}
