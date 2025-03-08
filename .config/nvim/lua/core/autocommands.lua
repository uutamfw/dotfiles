local api = vim.api

-- Copy path name
api.nvim_create_user_command("CpPath", function()
    local path = vim.fn.expand("%:p:.")
    vim.fn.setreg("+", path)
    vim.notify('Copied "' .. path .. '" to the clipboard!')
end, {})

-- Copy file name
api.nvim_create_user_command("CpFileName", function()
    local path = vim.fn.expand("%:t:r")
    vim.fn.setreg("+", path)
    vim.notify('Copied "' .. path .. '" to the clipboard!')
end, {})

-- Clipboard substitution
api.nvim_create_user_command("SubClipboard", function()
    local text = vim.fn.input("Input replacing text:")
    local clipboard = vim.fn.getreg("*")
    vim.fn.execute(":%s/" .. clipboard .. "/" .. text .. "/g")
    vim.notify('Substituted with "' .. text .. '"!')
end, {})

-- Store the cursor point at last
api.nvim_create_autocmd({ "BufReadPost" }, {
    pattern = { "*" },
    callback = function()
        -- 非推奨の nvim_exec を nvim_exec2 に置き換え
        vim.api.nvim_exec2('silent! normal! g`"zv', {})
    end,
})

-- To stop beginning from insert mode
-- https://github.com/nvim-telescope/telescope.nvim/issues/2027#issuecomment-1561836585
api.nvim_create_autocmd("WinLeave", {
    callback = function()
        if vim.bo.ft == "TelescopePrompt" and vim.fn.mode() == "i" then
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "i", false)
        end
    end,
})

-- local target_paths = {
--     vim.fn.expand("~/dotfiles/.config/nvim"),
--     vim.fn.expand("~/rohto-dev"),
-- }

-- Automatically run npx repomix when saving a file
-- local current_dir = vim.fn.getcwd()
-- for _, path in ipairs(target_paths) do
--     if current_dir:find(path, 1, true) then
--         api.nvim_create_autocmd("BufWritePost", {
--             pattern = "*",
--             callback = function()
--                 local cmd = "npx repomix"
--                 local output = vim.fn.system(cmd)
--                 if vim.v.shell_error ~= 0 then
--                     vim.notify("Error running 'npx repomix': " .. output, vim.log.levels.ERROR)
--                 else
--                     vim.notify("npx repomix executed successfully!", vim.log.levels.INFO)
--                 end
--             end,
--         })
--         break
--     end
-- end
