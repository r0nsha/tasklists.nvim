local ts = vim.treesitter

---@class tasklists.Pos
---@field row integer
---@field col integer

---@class tasklists.Task
---@field node TSNode
---@field start tasklists.Pos
---@field end_ tasklists.Pos

---@class tasklists.Tree
---@field buf number
local Tree = {}

local query = ts.query.parse(
  "markdown",
  [[
    (list_item (paragraph) @paragraph) @item
    (list_marker_minus) @marker
    (list_marker_plus) @marker  
    (list_marker_star) @marker
    (list_marker_dot) @marker.ordered
    (list_marker_parenthesis) @marker.ordered
  ]]
)

---@param tree tasklists.Tree
---@param root TSNode
local function build_from_root(tree, root)
  local nodes = {
    ---@type TSNode[]
    items = {},
    ---@type table<integer, TSNode[]>
    item_markers = {},
    ---@type table<integer, TSNode[]>
    item_paragraphs = {},
  }

  for id, node, _ in query:iter_captures(root, tree.buf, 0, -1) do
    local capture = query.captures[id]

    if capture == "item" then
      table.insert(nodes.items, node)
    elseif capture == "marker" then
      local parent = node:parent()
      if parent then
        local parent_id = parent:id()
        nodes.item_markers[parent_id] = nodes.item_markers[parent_id] or {}
        table.insert(nodes.item_markers[parent_id], node)
      end
    elseif capture == "paragraph" then
      local parent = node:parent()
      if parent then
        local parent_id = parent:id()
        nodes.item_paragraphs[parent_id] = nodes.item_paragraphs[parent_id] or {}
        table.insert(nodes.item_paragraphs[parent_id], node)
      end
    end
  end
end

---@param root TSNode
---@param buf number
---@return tasklists.Tree
function Tree:from_root(root, buf)
  local t = { buf = buf }
  setmetatable(t, self)
  self.__index = self
  build_from_root(t, root)
  return t
end

return Tree
