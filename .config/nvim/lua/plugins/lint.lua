-- nvim-lint provides diagnostics from external linters.
--
-- Install configured tools with :MasonInstallConfigured (the list of tools is
-- maintained in mason.lua).
return {
  {
    "mfussenegger/nvim-lint",
    lazy = true,
    dependencies = { "williamboman/mason.nvim" },
    keys = {
      {
        "<leader>ci",
        function()
          require("lint").try_lint()
        end,
        mode = "n",
        desc = "Lint current buffer",
      },
    },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        rst = { "rstcheck" },
      }

      -- Configure linter diagnostics independently of LSP/global settings.
      for _, linters in pairs(lint.linters_by_ft) do
        for _, name in ipairs(linters) do
          vim.diagnostic.config({
            virtual_text = { source = "if_many" },
          }, lint.get_namespace(name))
        end
      end

      -- Send the current buffer, including unsaved changes, via stdin.
      local rstcheck = lint.linters.rstcheck

      rstcheck.env = {
        PYTHONPATH = "",
        PYTHONHOME = "",
        PYTHONNOUSERSITE = "1",
      }
      rstcheck.stdin = true
      rstcheck.args = { "-" }
      rstcheck.append_fname = false

      -- stdin diagnostics have a synthetic filename, not the buffer's path.
      -- Omit the filename capture so nvim-lint keeps them for this buffer.
      rstcheck.parser = require("lint.parser").from_pattern(
        "^[^:]+:(%d+): %((.+)/%d%) (.+)",
        { "lnum", "severity", "message" },
        {
          INFO = vim.diagnostic.severity.INFO,
          WARNING = vim.diagnostic.severity.WARN,
          ERROR = vim.diagnostic.severity.ERROR,
          SEVERE = vim.diagnostic.severity.ERROR,
        },
        { source = "rstcheck" }
      )

      -- Refresh on returning to Normal mode and after Normal-mode edits
      -- (diw, x, r, undo, etc.). Keep <leader>ci for manual checks.
      local group = vim.api.nvim_create_augroup("ExternalLint", { clear = true })
      local function try_lint()
        if vim.api.nvim_get_mode().mode == "n"
          and vim.bo.buftype == ""
          and lint.linters_by_ft[vim.bo.filetype]
        then
          lint.try_lint()
        end
      end

      vim.api.nvim_create_autocmd("ModeChanged", {
        group = group,
        pattern = "*:n",
        callback = try_lint,
        desc = "Lint current buffer on entering Normal mode",
      })
      vim.api.nvim_create_autocmd("TextChanged", {
        group = group,
        callback = try_lint,
        desc = "Lint current buffer after Normal-mode edits",
      })
    end,
  },
}
