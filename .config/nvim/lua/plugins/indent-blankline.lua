-- show vertical lines at tabstops
return {
  {
    "lukas-reineke/indent-blankline.nvim",
    lazy = false,
    main = "ibl",
    opts = {
      -- make the character a little less dense
      indent = { char = "┊" },
      exclude = { filetypes = { "markdown", "rst" } },
    },
  },
}
