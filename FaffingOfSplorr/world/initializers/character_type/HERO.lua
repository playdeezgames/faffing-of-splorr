local character_type = require "world.character_type"
local verb_type = require "world.verb_type"
local character = require "world.character"
local room_cell = require "world.room_cell"
local room = require "world.room"
local directions = require "game.directions"
local function do_move(character_id, direction_id)
    local room_cell_id = character.get_room_cell(character_id)
    local column, row = room_cell.get_position(room_cell_id)
    local next_column, next_row = directions.get_next_position(direction_id, column, row)
    local room_id = room_cell.get_room(room_cell_id)
    local next_room_cell_id = room.get_room_cell(room_id, next_column, next_row)
    if next_room_cell_id ~= nil then
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