-- blink.cmp provides autocompletion

-- Used below to detect if we're in a word or not
local has_words_before = function()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  if col == 0 then
    return false
  end
  local line = vim.api.nvim_get_current_line()
  return line:sub(col, col):match("%s") == nil
end

-- Only enable dictionary completion if a system word list is available
local has_dictionary = vim.uv.fs_stat('/usr/share/dict/words') ~= nil
return {
  "saghen/blink.cmp",
  dependencies = {
    "rafamadriz/friendly-snippets",
    { "Kaiser-Yang/blink-cmp-dictionary", dependencies = { "nvim-lua/plenary.nvim" } },
  },

  event = { "InsertEnter", "CmdlineEnter" },

  -- using a release tag downloads pre-built binaries
  version = "v1.*",

  opts = {
    keymap = {
      -- At any time, <C-Space> to show menu, arrows to select, Enter to accept.
      preset = 'default',

      -- Additionally, this configures tab-completion to mimic what happens in bash:
      --   * Tab shows selections if cursor is in or immediately after a word, and immediately fills in the first item
      --   * Enter to select.
      --   * Tab scrolls thru suggestions (or Shift-Tab to go back)
      --
      ['<Tab>'] = {
        'select_next',
        function(cmp)
          if has_words_before() then
            return cmp.show_and_insert()
          end
        end,
        'snippet_forward',
        'fallback',
      },
      -- Navigate to the previous suggestion or cancel completion if currently on the first one.
      ['<S-Tab>'] = { 'snippet_backward', 'insert_prev' },
      ['<CR>'] = { 'accept', 'fallback' },
    },
    sources = {
      default = function()
        local result = { 'lsp', 'path', 'snippets', 'buffer' }

        -- turn on dictionary completion in non-code files
        if has_dictionary and vim.tbl_contains({ 'markdown', 'text', 'rst' }, vim.bo.filetype) then
          table.insert(result, 'dictionary')
        end
        return result
      end,
      providers = has_dictionary and {
        dictionary = {
          module = 'blink-cmp-dictionary',
          name = 'Dict',
          min_keyword_length = 3,
          opts = {
            -- This is the location of the word list on macOS and many Linux distributions
            dictionary_files = { '/usr/share/dict/words' },
          },
        },
      } or {},
    },
    fuzzy = { implementation = "prefer_rust_with_warning" },
    cmdline = { completion = { menu = { auto_show = false }, list = { selection = { preselect = false, auto_insert = true}}}},
    completion = {
      menu = { auto_show = false },
      list = { selection = { preselect = false, auto_insert = true}},
      trigger = { show_in_snippet = false },
    },
  },
  opts_extend = { "sources.default" },
}
