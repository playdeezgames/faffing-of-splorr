local room_cell_type = require "world.room_cell_type"
local world = require "world.world"
local M = {}
world.data.room_cells = {}
local function get_room_cell_data(room_cell_id)
    return world.data.room_cells[room_cell_id]
end
function M.create(room_cell_type_id, room_id, column, row)
    local room_cell_id = #world.data.room_cells + 1
    world.data.room_cells[room_cell_id] = {
        room_cell_type_id = room_cell_type_id,
        room_id = room_id,
        column = column,
        row = row
    }
    local initializer = room_cell_type.get_initializer(room_cell_type_id)
    if initializer ~= nil then
        initializer(room_cell_id)
    end
    return room_cell_id
end
function M.get_room_cell_type(room_cell_id)
    return get_room_cell_data(room_cell_id).room_cell_type_id
end
function M.set_room_cell_type(room_cell_id, room_cell_type_id)
    get_room_cell_data(room_cell_id).room_cell_type_id = room_cell_type_id
end
function M.get_room(room_cell_id)
    return get_room_cell_data(room_cell_id).room_id
end
function M.get_column(room_cell_id)
    return get_room_cell_data(room_cell_id).column
end
function M.get_row(room_cell_id)
    return get_room_cell_data(room_cell_id).row
end
function M.get_position(room_cell_id)
    local room_cell_data = get_room_cell_data(room_cell_id)
    return room_cell_data.column, room_cell_data.row
end
function M.get_character(room_cell_id)
    return get_room_cell_data(room_cell_id).character_id
end
function M.set_character(room_cell_id, character_id)
    get_room_cell_data(room_cell_id).character_id = character_id
end
function M.has_character(room_cell_id)
    return get_room_cell_data(room_cell_id).character_id ~= nil
end
return M