local grimoire = require "game.grimoire"
local M = {}

function M.send_message(...)
    local args = {...}
    for _, line in ipairs(args) do
        msg.post(grimoire.MESSAGE_URL, grimoire.MSG_ADD_MESSAGE, {text = line})
    end
end


return M