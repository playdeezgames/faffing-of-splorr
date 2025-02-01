require "world.initializers.character_types"
local grimoire = require "game.grimoire"
local room_type = require "world.room_type"
local room = require "world.room"
local character = require "world.character"
local character_type = require "world.character_type"
local avatar = require "world.avatar"
local room_cell_type = require "world.room_cell_type"
local room_cell = require "world.room_cell"
local utility = require "game.utility"
local feature = require "world.feature"
local feature_type = require "world.feature_type"
local M = {}

math.randomseed(100000 * (socket.gettime() % 1))

local terrain_table = {
    [room_cell_type.BLANK] = 5,
    [room_cell_type.GRAVEL] = 1
}
local TREE_COUNT = 10

local function can_spawn_avatar(room_cell_id)
    local room_cell_type_id = room_cell.get_room_cell_type(room_cell_id)
    return not room_cell_type.get_blocking(room_cell_type_id)
end

local function get_avatar_spawn_cell(room_id)
    local room_cell_id
    repeat
        local column, row = math.random(1, room.get_columns(room_id)), math.random(room.get_rows(room_id))
        room_cell_id = room.get_room_cell(room_id, column, row)
    until can_spawn_avatar(room_cell_id)
    return room_cell_id
end

local function spawn_avatar(room_id)
    local room_cell_id = get_avatar_spawn_cell(room_id)
    local character_id=character.create(character_type.HERO, room_cell_id)
    avatar.set_character(character_id)
end

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

local function initialize_trees(room_id, tree_count)
    local columns, rows = room.get_size(room_id)
    while tree_count > 0 do
        local room_cell_id = room.get_room_cell(room_id, math.random(1, columns), math.random(1, rows))
        if not room_cell.has_feature(room_cell_id) then
            room_cell.set_feature(room_cell_id, feature.create(feature_type.PINE))
            tree_count = tree_count - 1
        end
    end
end

local function create_room(columns, rows)
    local room_id = room.create(room_type.START, columns, rows)
    initialize_terrain(room_id)
    initialize_trees(room_id, TREE_COUNT)
    spawn_avatar(room_id)
    return room_id
end

function M.initialize()
    create_room(grimoire.BOARD_COLUMNS, grimoire.BOARD_ROWS)
    utility.send_message(
        "Welcome to Tree Punchers of SPLORR!!",
        "<ARROWS> move | <SPACE> action | <ESC> game menu")
end

return M