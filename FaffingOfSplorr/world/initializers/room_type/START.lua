local room_type = require "world.room_type"
local feature_type = require "world.feature_type"
local room = require "world.room"
local room_cell = require "world.room_cell"
local feature = require "world.feature"
local room_cell_type = require "world.room_cell_type"
local statistic_type = require "world.statistic_type"

local terrain_table = {
    [room_cell_type.BLANK] = 5,
    [room_cell_type.GRAVEL] = 1
}

local function generate_room_cell_type()
    local total = 0
    for _, v in pairs(terrain_table) do
        total = total + v
    end
    local generated = math.random(1, total)
    for k, v in pairs(terrain_table) do
        if generated <= v then
            return k
        else
            generated = generated - v
        end
    end
end

local function initialize_terrain(room_id)
    for column = 1, room.get_columns(room_id) do
        for row = 1, room.get_rows(room_id) do
            local room_cell_id = room.get_room_cell(room_id, column, row)
            room_cell.set_room_cell_type(room_cell_id, generate_room_cell_type())
        end
    end
end

room_type.set_initializer(
    room_type.START,
    function(room_id)
        if room.get_statistic(room_id, statistic_type.TREE_COUNT) == nil then
            room.set_statistic(room_id, statistic_type.TREE_COUNT, 1)
        end
        if room.get_statistic(room_id, statistic_type.WELL_COUNT) == nil then
            room.set_statistic(room_id, statistic_type.WELL_COUNT, 1)
        end
        initialize_terrain(room_id)
        room.create_features(room_id, feature_type.PINE, room.get_statistic(room_id, statistic_type.TREE_COUNT))
        room.create_features(room_id, feature_type.WELL, room.get_statistic(room_id, statistic_type.WELL_COUNT))
    end)
return nil