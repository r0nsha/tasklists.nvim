local ts = vim.treesitter
local Task = require("tasklists.task")

---@class tasklists.Tree
---@field buf number
---@field tasks tasklists.Task[]
---@field id_to_task tasklists.Task[]
local Tree = {}

-- TODO: search task by range using some higher level mapping, since searching node by node is VERY slow

local query = ts.query.parse(
  "markdown",
  [[
    (list_item 
        (task_list_marker_checked) @checked
        (paragraph) @paragraph) @item
    ; (list_marker_minus) @marker
    ; (list_marker_plus) @marker  
    ; (list_marker_star) @marker
    ; (list_marker_dot) @marker.ordered
    ; (list_marker_parenthesis) @marker.ordered
  ]]
)

---@param tree tasklists.Tree
---@param root TSNode
local function build_from_root(tree, root)
  for id, node, _ in query:iter_captures(root, tree.buf, 0, -1) do
    local capture = query.captures[id]

    if capture == "item" then
      local task = Task:new(node)
      table.insert(tree.tasks, task)
      tree.id_to_task[id] = tree.id_to_task[id] or {}
      table.insert(tree.id_to_task[id], task)
      local text = ts.get_node_text(node, tree.buf)
      vim.notify(vim.inspect(text))
      -- elseif capture == "marker" then
      --   local parent = node:parent()
      --   if parent then
      --     local parent_id = parent:id()
      --     nodes.item_markers[parent_id] = nodes.item_markers[parent_id] or {}
      --     table.insert(nodes.item_markers[parent_id], node)
      --   end
      -- elseif capture == "paragraph" then
      --   local parent = node:parent()
      --   if parent then
      --     local parent_id = parent:id()
      --     local text = ts.get_node_text(node, tree.buf)
      --     vim.notify(vim.inspect(text))
      --   end
    end
  end
end

---@param root TSNode
---@param buf number
---@return tasklists.Tree
function Tree:new(root, buf)
  local t = {
    buf = buf,
    tasks = {},
    id_to_task = {},
  }

  setmetatable(t, self)
  self.__index = self

  build_from_root(t, root)

  return t
end

return Tree
