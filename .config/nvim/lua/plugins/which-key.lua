-- pop up a window showing possible keybindings
return {
  {
    "folke/which-key.nvim",
    lazy = false,
    config = true,
    -- later versions raise errors on conflicting keybindings
    commit = "0539da005b98b02cf730c1d9da82b8e8edb1c2d2",
  },
}
