-- stickybuf prevents opening buffers in terminal buffer
return {
  {
    "stevearc/stickybuf.nvim",
    opts = {
      get_auto_pin = function(bufnr)
        return require("stickybuf").should_auto_pin(bufnr)
      end,
    },
  },
}
