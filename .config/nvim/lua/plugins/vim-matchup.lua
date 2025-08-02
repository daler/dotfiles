-- vim-matchup highlights matching keywords of a block
return {
        "andymass/vim-matchup",
        setup = function()
    vim.g.matchup_matchparen_offscreen = { method = "popup" }
  end,
}
