local room_cell = require "world.room_cell"
local room_type = require "world.room_type"
local world = require "world.world"
local M = {}
world.data.rooms = {}

local function get_room_data(room_id)
    return world.data.rooms[room_id]
end
function M.create(room_type_id, columns, rows)
    local room_id = #world.data.rooms + 1
    world.data.rooms[room_id]={
        room_type_id = room_type_id,
        columns = columns,
        rows = rows,
        cells = {}
    }
    for column = 1, columns do
        get_room_data(room_id).cells[column] = {}
        for row = 1, rows do
            get_room_data(room_id).cells[column][row] = room_cell.create(room_type.get_room_cell_type(M.get_room_type(room_id)), room_id, column, row)
        end
    end
    local initializer = room_type.get_initializer(room_type_id)
    if initializer ~= nil then
        initializer(room_id)
    end
    return room_id
end
function M.get_room_type(room_id)
    assert(type(room_id) == "number", "room_id should be a number")
    return get_room_data(room_id).room_type_id
end
function M.get_columns(room_id)
    assert(type(room_id) == "number", "room_id should be a number")
    return get_room_data(room_id).columns
end
function M.get_rows(room_id)
    assert(type(room_id) == "number", "room_id should be a number")
    return get_room_data(room_id).rows
end
function M.get_size(room_id)
    return M.get_columns(room_id), M.get_rows(room_id)
end
function M.get_room_cell(room_id, column, row)
    assert(type(room_id) == "number", "room_id should be a number")
    assert(type(column) == "number", "column should be a number")
    assert(type(row) == "number", "row should be a number")
    local room_column = get_room_data(room_id).cells[column]
    if room_column == nil then
        return nil
    end
    return room_column[row]
end
return M