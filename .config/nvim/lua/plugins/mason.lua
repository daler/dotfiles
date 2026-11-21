-- Mason manages external LSP servers, formatters, and linters.

-- Add to the `tools` list to make sure they're installed with
-- :MasonInstallConfigured or updated with :MasonUpdateConfigured.
--
-- skip_on_old_glibc=true`:
--   use this to indicate that the tool is problematic on HPC
--   with older glibc; if OLD_GLIBC env var is set, then don't use Mason to
--   install -- you'll need to install manually for your system.
local tools = {
  -- LSP servers used in nvim-lspconfig.lua
  "ansible-language-server",
  "bash-language-server",
  "lua-language-server",
  "pyright",
  "ruff",
  "yaml-language-server",

  -- Formatters used in conform.lua
  "air",
  "ansible-lint",
  "black",
  "markdownlint",
  "shfmt",
  "snakefmt",
  { "stylua", skip_on_old_glibc = true },
  { "tree-sitter-cli", skip_on_old_glibc = true },
  "yamlfmt",

  -- Linters used in lint.lua
  "rstcheck",
}

-- Mason creates Python venvs with --system-site-packages and provides no
-- setting to disable it. That can cause problems when everything on the system
-- is managed via conda envs. So this edits the venv's config file to NOT use
-- system site packages.
local function isolate_python_venv(package)
  local config = package:get_install_path() .. "/venv/pyvenv.cfg"
  if vim.fn.filereadable(config) ~= 1 then
    return
  end

  local ok, err = pcall(function()
    local lines = vim.fn.readfile(config)
    local changed = false
    for i, line in ipairs(lines) do
      if line:match("^include%-system%-site%-packages%s*=%s*true%s*$") then
        lines[i] = "include-system-site-packages = false"
        changed = true
      end
    end
    if changed then
      assert(vim.fn.writefile(lines, config) == 0, "Could not write " .. config)
    end
  end)
  if not ok then
    vim.notify("Could not isolate Mason tool " .. package.name .. ": " .. tostring(err), vim.log.levels.ERROR)
  end
end

local ensure_installed = {}
for _, tool in ipairs(tools) do
  local entry = type(tool) == "table" and tool or { tool }
  if not (vim.env.OLD_GLIBC ~= nil and entry.skip_on_old_glibc) then
    table.insert(ensure_installed, entry[1])
  end
end

-- Report anything installed but not configured in the list above.
local function report_unconfigured()
  local configured = {}
  for _, name in ipairs(ensure_installed) do
    configured[name] = true
  end

  local extra = {}
  for _, package in ipairs(require("mason-registry").get_installed_packages()) do
    if not configured[package.name] then
      table.insert(extra, package.name)
    end
  end
  table.sort(extra)
  if #extra == 0 then
    print("No unconfigured Mason tools installed")
  else
    print(
      "Mason tools installed but not configured for this system (nothing removed):\n  " .. table.concat(extra, "\n  ")
    )
    print("Run :MasonUninstall <tool> to remove\n")
  end
  print("\n")
end

-- Function to install the packages in the list above with `command`, and then
-- check if any are still missing so we can report errors.
local function run_configured(command)
  local ok, err = pcall(function()
    print(("Running %s for %d tools:\n  %s"):format(command, #ensure_installed, table.concat(ensure_installed, "\n  ")))
    vim.cmd(command)
    local registry = require("mason-registry")
    local installed, missing = {}, {}
    for _, name in ipairs(ensure_installed) do
      table.insert(registry.is_installed(name) and installed or missing, name)
    end
    print("Installed:\n  " .. table.concat(installed, "\n  "))
    report_unconfigured()
    assert(#missing == 0, "MISSING (failed to install):\n  " .. table.concat(missing, "\n  "))
  end)
  if not ok then
    vim.notify("Mason tool installation/update failed: " .. tostring(err), vim.log.levels.ERROR)
    if #vim.api.nvim_list_uis() == 0 then
      vim.cmd("cquit 1")
    end
  end
end

return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    opts = {
      -- Append rather than prepend Mason's bin dir, so tools already on the
      -- system PATH (e.g., tree-sitter compiled for an old glibc on HPC)
      -- take precedence.
      PATH = "append",
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local registry = require("mason-registry")

      -- See isolate_python_venv() above; this is triggered after installation.
      registry:on("package:install:success", vim.schedule_wrap(isolate_python_venv))

      -- And provide a command to run it manually
      vim.api.nvim_create_user_command("MasonIsolatePythonVenvs", function()
        for _, package in ipairs(registry.get_installed_packages()) do
          isolate_python_venv(package)
        end
      end, { desc = "Isolate existing Mason Python venvs from system site-packages" })
    end,
  },

  -- mason-tool-installer.nvim plugin provides list-based installation/update
  -- commands
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    lazy = true,
    cmd = { "MasonInstallConfigured", "MasonUpdateConfigured", "MasonReportUnconfigured" },
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      -- Install/update only when explicitly requested.
      run_on_start = false,

      -- Use the list defined at the top.
      ensure_installed = ensure_installed,
    },

    -- Add commands for installing from our list at the top
    config = function(_, opts)
      require("mason-tool-installer").setup(opts)
      vim.api.nvim_create_user_command("MasonReportUnconfigured", report_unconfigured, {
        desc = "Report installed Mason tools not configured for this system; remove nothing",
      })
      vim.api.nvim_create_user_command("MasonInstallConfigured", function()
        run_configured("MasonToolsInstallSync")
      end, { desc = "Install configured Mason tools; fail nonzero when headless" })
      vim.api.nvim_create_user_command("MasonUpdateConfigured", function()
        run_configured("MasonToolsUpdateSync")
      end, { desc = "Install/update configured Mason tools; fail nonzero when headless" })
    end,
  },
}
