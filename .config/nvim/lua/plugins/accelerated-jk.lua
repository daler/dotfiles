-- speeds up vertical navigation with j and k
return {
  {
    "rhysd/accelerated-jk",
    keys = {
      { "j", "<Plug>(accelerated_jk_gj)" },
      { "k", "<Plug>(accelerated_jk_gk)" },
    },
    config = function()

      -- see :help accelerated_jk_acceleration_table
      vim.cmd("let g:accelerated_jk_acceleration_table = [7, 13, 20, 33, 53, 86]")

    end,
  },
}
