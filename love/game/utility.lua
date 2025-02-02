local grimoire = require "game.grimoire"
local M = {}

function M.send_message(...)
    local args = {...}
    for _, line in ipairs(args) do
      print(line)
    end
end


return M