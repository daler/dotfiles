-- indent-blankline shows vertical lines at tabstops
return {
  {
    "lukas-reineke/indent-blankline.nvim",
    lazy = false,
    main = "ibl",
    opts = {
      -- make the character a little less dense
      indent = { char = "┊" },
      exclude = { filetypes = { "markdown", "rst" } },

      -- don't underline beginning and end (I think it adds too much visual
      -- clutter)
      scope = {
        show_start = false,
        show_end = false,
      },
    },
  },
}
