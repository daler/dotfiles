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
    end,
}
