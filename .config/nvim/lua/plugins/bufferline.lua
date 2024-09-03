-- tabs for buffers along the top
return {
  {
    "akinsho/bufferline.nvim",
    config = true,
    lazy = false,
    keys = {
      { "<leader>b", "<cmd>BufferLinePick<CR>", desc = "Pick buffer" },
    },
    opts = {
      options = {
        diagnostics = "nvim_lsp", -- buffer label will indicate errors
        custom_filter = function(buf_number, buf_numbers) -- don't show tabs for fugitive
          if vim.bo[buf_number].filetype ~= "fugitive" then
            return true
          end
        end,

        -- Disable the filetype icons in tabs
        show_buffer_icons = false,

        -- When using aerial or file tree, shift the tab so it's over the
        -- actual file.
        offsets = {
          {
            filetype = "NvimTree",
            highlight = "Directory",
            separator = true,
          },
          {
            filetype = "aerial",
            highlight = "Directory",
            separator = true,
          },
        },
      },
    },
  },
}
