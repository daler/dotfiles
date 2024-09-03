-- Autocommands.
-- Autocommands are triggered by an action, like opening a particular filetype.

-- Display nonprinting characters (tab characters and trailing spaces).
vim.cmd(":autocmd InsertEnter * set listchars=tab:>•")

-- Also show trailing spaces after exiting insert mode
vim.cmd(":autocmd InsertLeave * set listchars=tab:>•,trail:∙,nbsp:•,extends:⟩,precedes:⟨")

-- Set the working directory to that of the opened file
vim.cmd("autocmd BufEnter * silent! lcd %:p:h") 

-- <leader>d inserts a header for today's date. Different commands depending on
-- the format of the filetype (ReStructured Text or Markdown)
vim.api.nvim_create_autocmd("Filetype", {
  pattern = "rst",
  callback = function()
    vim.keymap.set(
      { "n", "i" },
      "<leader>d",
      '<Esc>:r! date "+\\%Y-\\%m-\\%d"<CR>A<CR>----------<CR>',
      { desc = "Insert date as section title" }
    )
    vim.keymap.set(
      "n",
      "<leader>p",
      'i` <>`__<Esc>F<"+pF`a',
      { desc = "Paste a ReST-formatted link from system clipboard" }
    )
  end,
})

vim.api.nvim_create_autocmd("Filetype", {
  pattern = { "markdown", "rmd" },
  callback = function()
    vim.keymap.set(
      { "n", "i" },
      "<leader>d",
      '<Esc>:r! date "+\\# \\%Y-\\%m-\\%d"<CR>A',
      { desc = "Insert date as section title" }
    )

    vim.keymap.set(
      "n",
      "<leader>p",
      'i[]()<Esc>h"+pF]i',
      { desc = "Paste a Markdown-formatted link from system clipboard" }
    )
  end,
})

-- Tell nvim about the snakemake filetype
vim.filetype.add({
  filename = {
    ["Snakefile"] = "snakemake",
  },
  pattern = {
    ["*.smk"] = "snakemake",
    ["*.snakefile"] = "snakemake",
    ["*.snakemake"] = "snakemake",
    ["Snakefile*"] = "snakemake",
  },
})

-- Set commentstring for snakemake, which is needed for vim-commentary
vim.api.nvim_create_autocmd("FileType", {
  pattern = "snakemake",
  callback = function() vim.cmd("set commentstring=#\\ %s") end,
})


-- Render RMarkdown in R running in terminal
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "rmarkdown", "rmd" },
  callback = function()
    vim.keymap.set(
      "n",
      "<leader>k",
      ":TermExec cmd='rmarkdown::render(\"%:p\")'<CR>",
      { desc = "Render RMar[k]down to HTML" }
    )
    -- Don't conceal for Rmd, which otherwise would conceal both links *and* code chunks.
    -- It's currently all or nothing (we can't just conceal links, for example), so we turn it off completely.
    -- vim.opt.conceallevel = 0
    vim.keymap.set(
      "n",
      "<leader>rm",
      function ()
        ft = vim.opt.ft:get()
        if ft == "rmarkdown" or ft == "rmd" then
          vim.cmd("set ft=markdown")
          vim.cmd("RenderMarkdown enable")
        end
        if ft == "markdown" then
          vim.cmd("set ft=rmarkdown")
          vim.cmd("RenderMarkdown disable")
        end
      end
      -- { desc = "enable render-markdown on an RMa
      -- rkdown file" }
    )
  end,
})

-- Run Python code in IPython running in terminal
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.keymap.set("n", "<leader>k", ":TermExec cmd='run %:p'<CR>", { desc = "Run Python file in IPython" })
  end,
})

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank{higroup = "IncSearch", timeout=100}
  end,
  pattern = "*",
})

-- Modified from https://github.com/nvim-tree/nvim-tree.lua/wiki/Auto-Close.
-- If the last buffer(s) open are nvim-tree or trouble.nvim or aerial, then close them all and quit.
vim.api.nvim_create_autocmd("QuitPre", {
  callback = function()
    local close_wins = {}
    local floating_wins = {}
    local wins = vim.api.nvim_list_wins()
    for _, w in ipairs(wins) do
      local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
      if bufname:match("NvimTree_") ~= nil then  -- nvim-tree buffer
        table.insert(close_wins, w)
      end
      if bufname:match("Trouble") ~= nil then    -- trouble.nvim buffer
        table.insert(close_wins, w)
      end
      if bufname:match("Scratch") ~= nil then    -- aerial buffer
        table.insert(close_wins, w)
      end
      if vim.api.nvim_win_get_config(w).relative ~= "" then -- floating windows
        table.insert(floating_wins, w)
      end
    end

    -- If the buffer we are closing during this QuitPre action is the only one
    -- that does not match the above patterns, then consider it the last text buffer,
    -- and close all other buffers.
    if 1 == #wins - #floating_wins - #close_wins then
      for _, w in ipairs(close_wins) do
        vim.api.nvim_win_close(w, true)
      end
    end
  end,
})
