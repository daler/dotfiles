return {
  'claydugo/browsher.nvim',
  event = "VeryLazy",
  config = function()

    function get_custom_providers(filename)
      -- You may have custom providers that you don't want to publish in
      -- a dotfiles repo. If so, store them in `filename`.
      --
      -- If `filename` doesn't exist, just return an empty table, which will
      -- give the default browsher behavior (i.e., providers for just
      -- github.com and gitlab.com).
      --
      -- For example, the file ~/.browsher.lua might contain the following:
      --
      -- return {
      --   ["gitlab.private.com"] = {
      --     url_template = "%s/-/blob/%s/%s",
      --     single_line_format = "#L%d",
      --     multi_line_format = "#L%d-%d",
      --   },
      -- }
      local f = io.open(filename, "r")
      if f ~= nil and io.close(f) then
        return dofile(filename)
      else
        return {}
      end
    end

    require('browsher').setup({
      -- Copy URL to OS clipboard. If you want a browser to open automatically,
      -- don't specify open_cmd here.
      open_cmd = "+",

      -- Default location of custom providers is ~/.browsher.lua, but it's OK
      -- if it doesn't exist.
      providers = get_custom_providers(vim.env.HOME .. '/.browsher.lua'),
    })
  end
}
