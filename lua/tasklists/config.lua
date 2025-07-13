---@class tasklists.Config
---@field log tasklists.log.Config

local M = {}

---@type tasklists.Config
M.defaults = {
  log = {
    filepath = vim.fn.stdpath("data") .. "/tasklists.log",
    use_file = true,
    use_notify = true,
  },
}

return M
