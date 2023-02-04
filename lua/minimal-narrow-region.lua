local narrow_region_original_window_id = nil
local narrow_region_original_buffer_id = nil
local narrow_region_type = nil
local narrow_region_buffer_id = nil

local function NarrowRegionOpen()
    narrow_region_original_window_id = vim.fn.win_getid()
    narrow_region_original_buffer_id = vim.fn.bufnr('%')
    local filetype = vim.bo.filetype
    local save_z = vim.fn.getreg('z', 1, true)
    local save_z_type = vim.fn.getregtype('z')
    vim.cmd('normal! "zy') -- needs to be called in visual mode
    local selected_text = vim.fn.getreg('z', 1, true)
    narrow_region_type = vim.fn.getregtype('z')
    vim.fn.setreg('z', save_z, save_z_type)
    vim.cmd('vertical botright new')
    vim.cmd('setlocal nobuflisted noswapfile buftype=nofile bufhidden=delete')
    vim.bo.filetype = filetype
    vim.fn.setline(1, selected_text)
    if narrow_region_buffer_id ~= nil then vim.cmd('echom "Warning: a NarrowRegion buffer already exists, but is now overridden!"') end
    narrow_region_buffer_id = vim.fn.bufnr('%')
end

local function NarrowRegionClose()
    if narrow_region_buffer_id ~= vim.fn.bufnr('%') then
        vim.cmd('echom "Warning: Invoked NarrowRegionWriteBack() from wrong buffer, do nothing!"')
        return
    end
    if vim.fn.bufexists(narrow_region_original_buffer_id) ~= 1 then
        vim.cmd('echom "Warning: Invoked NarrowRegionWriteBack() but original buffer was closed, do nothing!"')
        return
    end
    if narrow_region_type == 'v' then
        vim.cmd('normal! gg0vGg$y')
    elseif narrow_region_type == 'V' then
        vim.cmd('normal! gg0VGy')
    else -- "\<C-v>", hard to check in lua
        vim.cmd([[execute "normal! gg0\<C-v>G$" .. 'y']])
    end
    local original_window_tab_and_nr = vim.fn.win_id2tabwin(narrow_region_original_window_id)
    if original_window_tab_and_nr[1] == 0 and original_window_tab_and_nr[2] == 0 then
        vim.cmd('echom "Did not find original window, will replace current window with existing buffer!"')
        vim.cmd('buffer ' .. narrow_region_original_buffer_id)
    else
        vim.cmd('echom "Found original window, will close current window and jump to existing one!"')
        vim.cmd('quit')
        vim.fn.win_gotoid(narrow_region_original_window_id) -- this call should succeed because existence of this window was checked above
    end
    narrow_region_buffer_id = nil
    narrow_region_original_window_id = nil
    narrow_region_original_buffer_id = nil
    vim.cmd('normal! gv')
end
