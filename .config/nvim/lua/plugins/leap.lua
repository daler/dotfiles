return {
    -- Jump around buffer easily
    'ggandor/leap.nvim',
    config = function()
      require('leap').set_default_keymaps()
    end;
}
