local Tree = require("tasklists.tree")
local log = require("tasklists.log")
local ts = vim.treesitter

local group = vim.api.nvim_create_augroup("tasklists.nvim", { clear = true })

local M = {}

---@param buf number
---@return TSNode?
local function parse_buf(buf)
  local lang = ts.language.get_lang(vim.bo[buf].filetype)
  if lang ~= "markdown" then
    return
  end

  local parser = ts.get_parser(buf, lang)
  if not parser then
    log.error("No parser available for markdown")
    return
  end

  local _tree = parser:parse()[1]
  if not _tree then
    log.error("Failed to parser buffer")
    return
  end

  return _tree:root()
end

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

      local root = parse_buf(buf)
      if not root then
        return
      end

      local tree = Tree:from_root(root, buf)
    end,
  })
end

return M
