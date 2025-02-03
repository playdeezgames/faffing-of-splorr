local message_panel = require "message_panel"
local M = {}

function M.send_message(...)
    local args = {...}
    for _, line in ipairs(args) do
      message_panel.write_line({1,1,1},line)
    end
end


return M