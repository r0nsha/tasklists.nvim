local log = require("tasklists.log")
local ts = vim.treesitter

local group = vim.api.nvim_create_augroup("tasklists.nvim", { clear = true })

local M = {}

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

---@param config? tasklists.Config
function M.setup(config)
  config = vim.tbl_deep_extend("force", require("tasklists.config").defaults, config or {})
  log.setup(config.log)

  require("nvim-treesitter.install").ensure_installed({ "markdown" })

  require("tasklists.cmd").setup()

  vim.api.nvim_create_autocmd({ "FileType" }, {
    group = group,
    callback = function(args)
      local buf = args.buf

      local lang = ts.language.get_lang(vim.bo[buf].filetype)
      if lang ~= "markdown" then
        return
      end

      local parser = ts.get_parser(buf, lang)
      if not parser then
        log.error("parser not found")
      end

      local tree = parser:parse()[1]
      local root = tree:root()

      -- local results = {}

      -- for id, node, metadata in q:iter_captures(root, buf, 0, -1) do
      --   local name = q.captures[id]
      --   local range = { ts.get_node_text(node, buf)[1], ts.get_node_range(node) }
      --   table.insert(results, { type = name, node = node, range = range, metadata = metadata })
      -- end

      -- vim.notify(vim.inspect(results))
    end,
  })
end

return M
