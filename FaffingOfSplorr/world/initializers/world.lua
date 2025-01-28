require "world.initializers.character_types"
local grimoire = require "game.grimoire"
local room_type = require "world.room_type"
local room = require "world.room"
local character = require "world.character"
local character_type = require "world.character_type"
local avatar = require "world.avatar"
local M = {}

function M.initialize()
    local room_id = room.create(room_type.START, grimoire.BOARD_COLUMNS, grimoire.BOARD_ROWS)
    local room_cell_id = room.get_room_cell(room_id, math.floor(grimoire.BOARD_COLUMNS / 2), math.floor(grimoire.BOARD_ROWS / 2))
    local character_id=character.create(character_type.HERO, room_cell_id)
    avatar.set_character(character_id)
end

return M