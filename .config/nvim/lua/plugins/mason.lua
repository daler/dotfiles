if vim.fn.has('nvim-0.11') == 0 then
  -- mason allows convenient installation of LSP clients
  return {
    {
      "williamboman/mason.nvim",
      lazy = false,
      config = true,
    },
  }
else
  return {}
end
