local M = {}

local group = vim.api.nvim_create_augroup("tasklists.nvim", { clear = true })

---@param config? tasklists.Config
function M.setup(config) end

return M
