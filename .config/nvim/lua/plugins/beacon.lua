-- flash a beacon to show where you are
return {
  {
    "danilamihailov/beacon.nvim",

    -- later versions are lua-only and not as nice to configure
    commit = "5ab668c4123bc51269bf6f0a34828e68c142e764",

    -- don't lazy load -- otherwise, on first KJ you get a double-flash
    lazy = false,
    config = function()

      -- Disable the beacon globally; only the commands below will activate it.
      vim.cmd("let g:beacon_enable=0")

    end,
    keys = {
      { "<S-k><S-j>", ":Beacon<CR>", desc = "Flash beacon" },
      { "N", "N:Beacon<CR>", desc = "Prev search hit and flash beacon" },
      { "n", "n:Beacon<CR>", desc = "Next search hit and flash beacon" },
      { "%", "%:Beacon<CR>", desc = "Go to matching bracket and flash beacon" },
      { "*", "*:Beacon<CR>", desc = "Go to next word occurrence and flash beacon" },
    },
  },
}
