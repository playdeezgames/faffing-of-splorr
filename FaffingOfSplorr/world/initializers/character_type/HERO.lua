local character_type = require "world.character_type"
local verb_type = require "world.verb_type"
local character = require "world.character"
local room_cell = require "world.room_cell"
local room = require "world.room"
local directions = require "game.directions"
local room_cell_type = require "world.room_cell_type"

local function can_enter(room_cell_id)
    if room_cell_id == nil then return false end
    local room_cell_type_id = room_cell.get_room_cell_type(room_cell_id)
    if room_cell_type.get_blocking(room_cell_type_id) then return false end
    return true
end

local function do_move(character_id, direction_id)
    local room_cell_id = character.get_room_cell(character_id)
    local column, row = room_cell.get_position(room_cell_id)
    local next_column, next_row = directions.get_next_position(direction_id, column, row)
    local room_id = room_cell.get_room(room_cell_id)
    local next_room_cell_id = room.get_room_cell(room_id, next_column, next_row)
    if can_enter(next_room_cell_id) then
        character.set_room_cell(character_id, next_room_cell_id)
    end
end
character_type.set_verb_doer(
    character_type.HERO,
    function(character_id, verb_type_id, context)
        if verb_type_id == verb_type.MOVE then
            do_move(character_id, context.direction_id)
        else
            print(verb_type_id)
        end
    end)
return nil