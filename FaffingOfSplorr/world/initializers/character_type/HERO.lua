local character_type = require "world.character_type"
local verb_type = require "world.verb_type"
local character = require "world.character"
local room_cell = require "world.room_cell"
local room = require "world.room"
local directions = require "game.directions"
local room_cell_type = require "world.room_cell_type"
local utility = require "game.utility"
local statistic_type = require "world.statistic_type"

local function can_enter(room_cell_id)
    if room_cell_id == nil then return false end
    local room_cell_type_id = room_cell.get_room_cell_type(room_cell_id)
    if room_cell_type.get_blocking(room_cell_type_id) then return false end
    return true
end

local function do_move(character_id, direction_id)
    local old_direction_id = character.get_direction(character_id)
    if direction_id ~= old_direction_id then
        character.set_direction(character_id, direction_id)
        utility.send_message("Turning to face "..direction_id..".")
        return
    end
    local room_cell_id = character.get_room_cell(character_id)
    local column, row = room_cell.get_position(room_cell_id)
    local next_column, next_row = directions.get_next_position(direction_id, column, row)
    local room_id = room_cell.get_room(room_cell_id)
    local next_room_cell_id = room.get_room_cell(room_id, next_column, next_row)
    if can_enter(next_room_cell_id) then
        utility.send_message("Moving "..direction_id..".")
        character.set_room_cell(character_id, next_room_cell_id)
        character.change_statistic(character_id, statistic_type.MOVES, 1)
    else
    end
end
local function do_action(character_id)
    local direction_id = character.get_direction(character_id)
    if direction_id == nil then return end
    local next_column, next_row = directions.get_next_position(direction_id, character.get_position(character_id))
    local room_id = character.get_room(character_id)
    local next_room_cell_id = room.get_room_cell(room_id, next_column, next_row)
    local next_room_cell_type_id = room_cell.get_room_cell_type(next_room_cell_id)
    if next_room_cell_type_id == room_cell_type.PINE then
        local punches_landed = character.change_statistic(character_id, statistic_type.PUNCHES_LANDED, 1)
        utility.send_message("You punched that tree!", "You have landed "..punches_landed.." punches.")
        room_cell.set_room_cell_type(next_room_cell_id, room_cell_type.PUNCHED_PINE)
        local punch_goal = character.get_statistic(character_id, statistic_type.PUNCH_GOAL)
        if punches_landed >= punch_goal then
            local punch_level = character.change_statistic(character_id, statistic_type.PUNCH_LEVEL, 1)
            character.change_statistic(character_id, statistic_type.PUNCHES_LANDED, -punch_goal)
            character.change_statistic(character_id, statistic_type.PUNCH_GOAL, punch_goal)
            utility.send_message("Yer punch is now level "..punch_level.."!")
        end
    elseif next_room_cell_type_id == room_cell_type.PUNCHED_PINE then
        utility.send_message("That tree was already punched!")
    else
        utility.send_message("You punch the air!")
    end
end
local function do_cancel(character_id)
    print("show me a game menu!")
end
character_type.set_verb_doer(
    character_type.HERO,
    function(character_id, verb_type_id, context)
        if verb_type_id == verb_type.MOVE then
            do_move(character_id, context.direction_id)
        elseif verb_type_id == verb_type.ACTION then
            do_action(character_id)
        elseif verb_type_id == verb_type.CANCEL then
            do_cancel(character_id)
        else
            print(verb_type_id)
        end
    end)
character_type.set_initializer(
    character_type.HERO, 
    function(character_id) 
        character.set_statistic(character_id, statistic_type.PUNCHES_LANDED, 0)
        character.set_statistic(character_id, statistic_type.PUNCH_GOAL, 10)
        character.set_statistic(character_id, statistic_type.PUNCH_LEVEL, 0)
        character.set_statistic(character_id, statistic_type.MOVES, 0)
    end)
return nil