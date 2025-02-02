local character_type = require "world.character_type"
local verb_type = require "world.verb_type"
local character = require "world.character"
local room_cell = require "world.room_cell"
local room = require "world.room"
local directions = require "game.directions"
local room_cell_type = require "world.room_cell_type"
local utility = require "game.utility"
local statistic_type = require "world.statistic_type"
local feature        = require "world.feature"
local feature_type   = require "world.feature_type"

local function move_other_characters(room_id, character_id)
    local other_character_ids = {}
    for column = 1, room.get_columns(room_id) do
        for row = 1, room.get_rows(room_id) do
            local room_cell_id = room.get_room_cell(room_id, column, row)
            if room_cell.has_character(room_cell_id) then
                local other_character_id = room_cell.get_character(room_cell_id)
                if other_character_id ~= character_id then
                    table.insert(other_character_ids, other_character_id)
                end
            end
        end
    end
    for _, other_character_id in ipairs(other_character_ids) do
        character.do_verb(other_character_id, verb_type.STEP, {})
    end
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
    if room_cell.can_enter(next_room_cell_id) then
        utility.send_message("Moving "..direction_id..".")
        character.set_room_cell(character_id, next_room_cell_id)
        character.change_statistic(character_id, statistic_type.MOVES, 1)
    end
    move_other_characters(room_id, character_id)
end
local function do_energy_cost(character_id, cost)
    local energy = character.get_statistic(character_id, statistic_type.ENERGY)
    if energy < cost then 
        utility.send_message("Yer out of energy!")
        return false
    else
        utility.send_message("-"..cost.." energy")
        character.change_statistic(character_id, statistic_type.ENERGY, -cost)
        return true
    end
end
local function do_punch_air(character_id)
    if not do_energy_cost(character_id, 1) then return false end
    utility.send_message("You punch the air!")
    return true
end
local function handle_level_done(character_id)
    local room_id = character.get_room(character_id)
    for column = 1, room.get_columns(room_id) do
        for row = 1, room.get_rows(room_id) do
            local feature_id = room.get_feature(room_id, column, row)
            if feature_id ~= nil and feature.get_feature_type(feature_id) == feature_type.PINE then
                --found a tree!
                return
            end
        end
    end
    room.create_features(room_id, feature_type.PORTAL, 1)
end
local function do_punch_tree(character_id, feature_id, room_cell_id)
    if not do_energy_cost(character_id, 1) then return false end
    local punch_level = character.get_statistic(character_id, statistic_type.PUNCH_LEVEL)
    local punches_landed = character.change_statistic(character_id, statistic_type.PUNCHES_LANDED, 1)
    utility.send_message("You punched that tree!", "You have landed "..punches_landed.." punches.")

    local hit_points = feature.change_statistic(feature_id, statistic_type.HIT_POINTS, -punch_level)
    if hit_points <= 0 then
        utility.send_message("You punched that tree into oblivion.")
        room_cell.set_feature(room_cell_id, nil)
        feature.recycle(feature_id)
        character.change_statistic(character_id, statistic_type.TREES_MURDERED, 1)
        handle_level_done(character_id)
    else
        utility.send_message("The tree has "..hit_points.." HP.")
    end

    local punch_goal = character.get_statistic(character_id, statistic_type.PUNCH_GOAL)
    if punches_landed >= punch_goal then
        character.change_statistic(character_id, statistic_type.PUNCHES_LANDED, -punch_goal)
        character.change_statistic(character_id, statistic_type.PUNCH_GOAL, punch_goal)
        punch_level = character.change_statistic(character_id, statistic_type.PUNCH_LEVEL, 1)
        utility.send_message("Yer punch is now level "..punch_level.."!")
    end
    return true
end
local function do_drink_well(character_id)
    character.set_statistic(character_id, statistic_type.ENERGY, character.get_statistic(character_id, statistic_type.MAXIMUM_ENERGY))
    utility.send_message("Yer energy is refreshed!")
    return true
end
local function do_enter_portal(character_id)
    local room_id = character.get_room(character_id)
    character.set_room_cell(character_id, nil)
    --reinitialize room
    local room_cell_id, column, row
    repeat
        column, row = math.random(1, room.get_columns(room_id)), math.random(1, room.get_rows(room_id))
        room_cell_id = room.get_room_cell(room_id, column, row)
    until not room_cell.has_feature(room_cell_id) and not room_cell.has_character(room_cell_id)
    character.set_room_cell(character_id, room_cell_id)
end
local function do_feature_action(character_id, room_cell_id)
    local feature_id = room_cell.get_feature(room_cell_id)
    if feature_id == nil then
        return do_punch_air(character_id)
    end

    local feature_type_id = feature.get_feature_type(feature_id)
    if feature_type_id == feature_type.PINE then
        return do_punch_tree(character_id, feature_id, room_cell_id)
    end

    if feature_type_id == feature_type.WELL then
        return do_drink_well(character_id)
    end

    if feature_type_id == feature_type.PORTAL then
        return do_enter_portal(character_id)
    end

    return false
end
local function do_action(character_id)
    local direction_id = character.get_direction(character_id)
    if direction_id == nil then return end
    local next_column, next_row = directions.get_next_position(direction_id, character.get_position(character_id))
    local room_id = character.get_room(character_id)
    local room_cell_id = room.get_room_cell(room_id, next_column, next_row)
    if room_cell_id == nil then return end
    if not do_feature_action(character_id, room_cell_id) then return end
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
        character.set_statistic(character_id, statistic_type.TREES_MURDERED, 0)
        character.set_statistic(character_id, statistic_type.ENERGY, 10)
        character.set_statistic(character_id, statistic_type.MAXIMUM_ENERGY, 10)
    end)
return nil