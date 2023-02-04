vim.keymap.set('x', '<Plug>(minimal-narrow-region-open)', function() require('minimal-narrow-region').NarrowRegionOpen() end)
vim.keymap.set('n', '<Plug>(minimal-narrow-region-close)', function() require('minimal-narrow-region').NarrowRegionClose() end)
