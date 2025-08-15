-- Keymappings.
-- These are general keymappings. For keymappings related to plugins, see
-- lua/plugins/*.lua. Many keymappings will have descriptions which will show
-- up in which-key.
--
-- In general, see the `desc` fields for the keymap description.


-- Set up labeled groupings in which-key
local wk = require('which-key')
wk.register( { ["<leader>c"] = { name = "+code" } } )
wk.register( { ["<leader>f"] = { name = "+file or +find" } } )
wk.register( { ["<leader>o"] = { name = "+obsidian" } } )

vim.keymap.set("t", "<Esc>", "<C-\\><C-n>") -- Fix <Esc> in terminal buffer
vim.keymap.set("n", "<Leader>H", ":set hlsearch!<CR>", { desc = "Toggle search highlight" })
vim.keymap.set("n", "<leader>W", ":%s/\\s\\+$//<cr>:let @/=''<CR>", { desc = "Clean trailing whitespace" })
vim.keymap.set({ "n", "i" }, "<leader>R", "<Esc>:syntax sync fromstart<CR>", { desc = "Refresh syntax highlighting" })
vim.keymap.set(
  { "n", "i" },
  "<leader>ts",
  '<Esc>o<Esc>:r! date "+\\%Y-\\%m-\\%d \\%H:\\%M "<CR>A',
  { desc = "Insert timestamp" }
)
vim.keymap.set("n", "<leader>-", "80A-<Esc>d80<bar>", { desc = "Fill rest of line with -" })
vim.keymap.set("n", "<leader><tab>", ":set nowrap tabstop=", { desc = "Prepare for viewing TSV" })

-- Buffer navigation keymappings
vim.keymap.set("n", "<leader>1", ":bfirst<CR>", { desc = "First buffer" })
vim.keymap.set("n", "<leader>2", ":blast<CR>", { desc = "Last buffer" })
vim.keymap.set("n", "[b", ":bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "]b", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "H", ":bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "L", ":bnext<CR>", { desc = "Next buffer" })

-- In preparation for copying, turn off various symbols and text that shouldn't
-- be copied, such as indent-blankline vertical lines, indicators of git
-- changes, and various virtual text and symbols. Also toggle line numbers.
--
-- In all cases, only disable things if the plugin is loaded in the first
-- place.
vim.keymap.set("n", "<leader>cp",
  function()
    if package.loaded["ibl"] ~= nil then
      vim.cmd("IBLToggle")
    end
    if package.loaded["gitsigns"] ~= nil then
      vim.cmd("Gitsigns toggle_signs")
    end
    if package.loaded["render-markdown"] ~= nil then
      vim.cmd(":RenderMarkdown toggle")
    end
    vim.cmd("set nu!")
  end,
  { desc = "Prepare for copying text to another program"}
)

-- Keymappings for navigating terminals.
-- <leader>q and <leader>w move to left and right windows respectively. Useful
-- when working with a terminal, or to aerial panels or nvim-tree panels. Works
-- even in insert mode; to enter a literal ',w' type more slowly after the
-- leader.
vim.keymap.set({ "n", "i" }, "<leader>w", "<Esc>:wincmd l<CR>", { desc = "Move to right window" })
vim.keymap.set({ "n", "i" }, "<leader>q", "<Esc>:wincmd h<CR>", { desc = "Move to left window" })
vim.keymap.set("t", "<leader>q", "<C-\\><C-n>:wincmd h<CR>", { desc = "Move to left window" })

-- Registers
vim.fn.setreg("l", "I'A',j") -- "listify": wrap with quotes and add trailing comma
