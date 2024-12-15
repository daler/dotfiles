return {
  'claydugo/browsher.nvim',
  event = "VeryLazy",
  config = function()
    require('browsher').setup({
      -- Copy URL to OS clipboard
      open_cmd = "+",
      providers = {
        ["github.com"] = {
            url_template = "%s/blob/%s/%s",
            single_line_format = "#L%d",
            multi_line_format = "#L%d-L%d",
        },
        ["gitlab.com"] = {
            url_template = "%s/-/blob/%s/%s",
            single_line_format = "#L%d",
            multi_line_format = "#L%d-%d",
        },

      },
    })
  end
}
