# minimal-narrow-region.nvim
Opinionated minimal implementation of Emacs' [narrowing](https://www.gnu.org/software/emacs/manual/html_node/emacs/Narrowing.html) feature.

## Why?
The [NrrwRgn](https://github.com/chrisbra/NrrwRgn) plugin is nice, but tends to have unpredictable behaviour in Neovim, at least for me.  
Also at > 1500 lines of Vimscript, it's overkill for my needs.  
So I decided to create a lua implementation of the minimal version that's suitable for my workflow.

## Usage
No mappings by default, create them explicitly:
```lua
vim.keymap.set('x', '<Leader><Leader>nr', '<Plug>(minimal-narrow-region-open)')
vim.keymap.set('n', '<Leader><Leader>NR', '<Plug>(minimal-narrow-region-close)')
```
1. Use visual mode to select the text to narrow on.
2. Use `<Plug>(minimal-narrow-region-open)` to copy the selected text into a newly opened scratch buffer with the same filetype that is created with `vertical botright` in the same tab.
3. Optionally, use `CTRL-W CTRL-O` or `CTRL-W T` if the opened window is too small.
4. Edit the text.
5. Use `<Plug>(minimal-narrow-region-close)` to copy the selected text into the clipboard, close the scratch buffer, and go back to the original buffer and reselect the original visual selection.
6. Press `p` to paste the text and see the change.

There are basic sanity checks, but it's probably not totally foolproof. In particular, the original buffer is not made read-only.  
Except for the mappings no configuration is possible. if the above description almost (but not quite) fits your workflow, consider copying and adapting the code.  
Otherwise, consider picking one of the other numerous existing narrow region plugins.

## Related Plugins
* [yode-nvim](https://github.com/hoschi/yode-nvim) Ambitious lua-based narrow-region plugin with a focus on multiple narrow regions.
* [NrrwRgn](https://github.com/chrisbra/NrrwRgn) Famous narrow-region plugin in Vim-land. I used this before creating this plugin.

## Requirements
Developed and tested on Neovim `0.8.2`.
