local M = {}

local log_file = vim.fn.expand("~/.nvim_log.log")

function M.dlog(msg)
    local file = io.open(log_file, "a") -- "a" で追記モード
    if file then
        file:write(os.date("[%Y-%m-%d %H:%M:%S] [DEBUG]") .. msg .. "\n") --  write with timestamp
        file:close()
    end
end

return M
