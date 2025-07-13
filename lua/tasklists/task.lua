---@enum tasklists.Status
---| '"incomplete"'
---| '"complete"'
local Status = {
  incomplete = "incomplete",
  complete = "complete",
}

---@class tasklists.Pos
---@field row integer
---@field col integer

---@class tasklists.Range
---@field start tasklists.Pos
---@field end_ tasklists.Pos

---@class tasklists.Task
---@field node TSNode
---@field status tasklists.Status
---@field range tasklists.Range
local Task = {}

---@param node TSNode
---@return tasklists.Task
function Task:new(node)
  local start_row, start_col, end_row, end_col = node:range()

  local t = {
    node = node,
    status = Status.incomplete,
    range = {
      start = { row = start_row, col = start_col },
      end_ = { row = end_row, col = end_col },
    },
  }

  setmetatable(t, self)
  self.__index = self

  return t
end

return Task
