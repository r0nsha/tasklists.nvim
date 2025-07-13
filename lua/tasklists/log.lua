---@class tasklists.log.Config
---@field filepath string
---@field use_file boolean
---@field use_notify boolean
local config = {}

local M = {}

local levels = {
  [vim.log.levels.TRACE] = "TRACE",
  [vim.log.levels.DEBUG] = "DEBUG",
  [vim.log.levels.INFO] = "INFO",
  [vim.log.levels.WARN] = "WARN",
  [vim.log.levels.ERROR] = "ERROR",
}

---@type file*?
local file = nil

---@param msg string
---@param level vim.log.levels
local function format_log(msg, level)
  local parts = {
    os.date("%Y-%m-%d %H:%M:%S"),
    string.format("[%5s]", levels[level]),
  }

  if type(msg) == "table" then
    local inspected = vim.inspect(msg)
    inspected = inspected:gsub("\n", " "):gsub("%s+", " ")
    table.insert(parts, inspected)
  else
    table.insert(parts, tostring(msg))
  end

  return table.concat(parts, " ")
end

---@param _config? tasklists.log.Config
function M.setup(_config)
  config = vim.deepcopy(_config or require("tasklists.config").defaults.log)

  if config.use_file then
    local ok, f = pcall(io.open, config.filepath, "a")

    if ok then
      file = f
      M.trace("Log file opened: " .. config.filepath)
    else
      M.error("Failed to open log file: " .. config.filepath)
    end
  end

  M.trace("Logger initialized")
end

---@param msg string
---@param level? vim.log.levels
function M.log(msg, level)
  level = level or vim.log.levels.INFO

  if config.use_notify and level >= vim.log.levels.DEBUG then
    vim.notify(msg, level, { title = "tasklists.nvim" })
  end

  if config.use_file and file then
    file:write(format_log(msg, level) .. "\n")
    file:flush()
  end
end

---@param msg string
function M.trace(msg)
  M.log(msg, vim.log.levels.TRACE)
end

---@param msg string
function M.debug(msg)
  M.log(msg, vim.log.levels.DEBUG)
end

---@param msg string
function M.info(msg)
  M.log(msg, vim.log.levels.INFO)
end

---@param msg string
function M.warn(msg)
  M.log(msg, vim.log.levels.WARN)
end

---@param msg string
function M.error(msg)
  M.log(msg, vim.log.levels.ERROR)
end

function M.open()
  if not config.filepath or not config.use_file then
    return
  end

  vim.cmd("tabfind " .. config.filepath)
end

return M
