-- render-markdown nicely renders markdown callouts, tables, heading symbols, and code blocks
return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    opts = {
      heading = {

        -- don't indent subsequent headers
        position = "inline",

        -- don't replace ### with icons
        icons = {},

        -- don't add a sign column indicator (it gets distracting when enter/exit insert mode)
        sign = false,
      },
      code = {

        -- don't add a sign column indicator
        sign = false,
      },
      bullet = {

        -- make bullets of all indentations the same
        icons = { "•" },
      },
      link = {

        -- internal links get a symbol in front of them; regular (web) links do not
        custom = {
          web = { pattern = "^http[s]?://", icon = "", highlight = "RenderMarkdownLink" },
          internal = { pattern = ".*", icon = "⛬ ", highlight = "RenderMarkdownLink" },
        },
      },
    },
  },
}
