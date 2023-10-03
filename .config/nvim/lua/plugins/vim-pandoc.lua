return  {
    'vim-pandoc/vim-pandoc',
    init = function()
      vim.cmd("let g:pandoc#syntax#conceal#use = 0") -- " Disable the conversion of ``` to lambda and other fancy concealment/conversion that ends up confusing me
      vim.cmd("let g:pandoc#folding#fold_fenced_codeblocks = 1") -- " RMarkdown code blocks can be folded too
      vim.cmd("let g:pandoc#spell#enabled = 0") -- " By default, keep spell-check off. Turn on with `set spell`
    end
}
