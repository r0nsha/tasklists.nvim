local log = require("tasklists.log")

local M = {}

function M.setup()
  -- Define the handler function for the Tasklists command
  local function command(opts)
    local args = opts.fargs -- opts.fargs is a table of arguments passed to the command

    if #args == 0 then
      print([[
Usage: Tasklists <subcommand> [args...]"
Available subcommands: log, new, list
      ]])
      return
    end

    local subcommand = args[1]
    if subcommand == "log" then
      log.open()
    else
      log.error("Unknown subcommand: " .. subcommand)
    end
  end

  ---@diagnostic disable-next-line: unused-local
  local function complete(arg_lead, cmd_line, cursor_pos)
    local subcommands = { "log" }
    local matches = {}
    for _, subcmd in ipairs(subcommands) do
      if subcmd:find("^" .. arg_lead) then
        table.insert(matches, subcmd)
      end
    end
    return matches
  end

  vim.api.nvim_create_user_command("Tasklists", command, { nargs = "*", complete = complete, desc = "Tasklists" })
end

return M
