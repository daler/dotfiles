require("which-key").setup{}

-- Make escape work in terminal
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')

vim.keymap.set('n', '<Leader>H', ':set hlsearch!<CR>',
  { desc = 'Toggle search highlight' })

vim.keymap.set('n', '<leader>W', ":%s/\\s\\+$//<cr>:let @/=''<CR>",
  { desc = "Clean trailing whitespace" })

vim.keymap.set({'n', 'i'}, '<leader>R', '<Esc>:syntax sync fromstart<CR>',
  { desc = 'Refresh syntax highlighting' })

vim.keymap.set({'n', 'i'}, '<leader>`', 'i```{r}<CR>```<Esc>O',
  { desc = "New fenced RMarkdown code block" })

vim.keymap.set({'n', 'i'}, '<leader>ts', '<Esc>o<Esc>:r! date "+[\\%Y-\\%m-\\%d \\%H:\\%M] "<CR>A',
  { desc = "Insert timestamp" })

vim.keymap.set('n', '<leader>-', '80A-<Esc>d80<bar>',
  { desc = "Fill rest of line with -"})

vim.keymap.set('n', '<leader><tab>', ':set nowrap tabstop=',
  { desc = "Prepare for viewing TSV" })

vim.keymap.set('n', '<leader>1', ':bfirst<CR>',
  { desc = "First buffer" })

vim.keymap.set('n', '<leader>2', ':blast<CR>',
  { desc = "Last buffer" })

vim.keymap.set('n', '[b', ':bprevious<CR>',
  { desc = "Previous buffer" })

vim.keymap.set('n', ']b', ':bnext<CR>',
  { desc = "Next buffer" })

vim.keymap.set('n', 'H', ':bprevious<CR>',
  { desc = "Previous buffer" })

vim.keymap.set('n', 'L', ':bnext<CR>',
  { desc = "Next buffer" })

vim.keymap.set('n', '<leader>b', ':buffers<CR>:buffer<Space>',
  { desc = "Select buffer" })

-- <leader>q and <leader>w move to left and right windows respectively. Useful
-- when working with a terminal. Works even in insert mode; to enter a literal
-- ',w' type more slowly after the leader.
vim.keymap.set({'n', 'i'}, '<leader>w', '<Esc>:wincmd l<CR>',
  { desc = 'Move to right window' })

vim.keymap.set({'n', 'i'}, '<leader>q', '<Esc>:wincmd h<CR>',
  { desc = 'Move to left window'})

vim.keymap.set('t', '<leader>q', '<C-\\><C-n>:wincmd h<CR>',
  { desc = 'Move to left window'})

vim.fn.setreg('l', "I'A',j") -- "listify": wrap with quotes and add trailing comma
