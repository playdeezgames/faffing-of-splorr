local character = require "world.character"
local room      = require "world.room"
local room_cell = require "world.room_cell"
local room_cell_type = require "world.room_cell_type"
local feature        = require "world.feature"
local feature_type   = require "world.feature_type"
local character_type = require "world.character_type"
local verb_type      = require "world.verb_type"
local directions     = require "game.directions"
local grimoire       = require "game.grimoire"
local statistic_type = require "world.statistic_type"
if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
  require("lldebugger").start()
end
local world_initializer = require "world.initializers.world"
local avatar = require "world.avatar"

local GRID_CELL_WIDTH = 8
local GRID_CELL_HEIGHT = 8
local GRID_COLUMNS = 20
local GRID_ROWS = 20
local GRID_OFFSET_X = 320
local GRID_OFFSET_Y = 0
local GRID_SCALE_X = 4
local GRID_SCALE_Y = 4
local GRID_TILESET_FILENAME = "assets/images/colored_tilemap_packed.png"

local ROMFONT_TILESET_FILENAME = "assets/images/romfont8x8.png"
local ROMFONT_CELL_WIDTH = 8
local ROMFONT_CELL_HEIGHT = 8

local STATUS_PANEL_COLUMNS = 40
local STATUS_PANEL_ROWS = 40
local STATUS_PANEL_OFFSET_X = 0
local STATUS_PANEL_OFFSET_Y = 0
local STATUS_PANEL_SCALE_X = 1
local STATUS_PANEL_SCALE_Y = 2

local grid_tile_quads = {}
local grid_tileset_image
local grid_canvas

local romfont_tile_quads = {}
local romfont_tileset_image

local status_panel_cells
local status_panel_canvas

local function set_up_romfont()
  romfont_tileset_image = love.graphics.newImage(ROMFONT_TILESET_FILENAME)
  local image_width = romfont_tileset_image:getWidth()
  local image_height = romfont_tileset_image:getHeight()
  local tile_columns = image_width / ROMFONT_CELL_WIDTH
  local tile_rows = image_height / ROMFONT_CELL_HEIGHT
  for row = 1, tile_rows do
    for column = 1, tile_columns do
      local source_x = column * ROMFONT_CELL_WIDTH - ROMFONT_CELL_WIDTH
      local source_y = row * ROMFONT_CELL_HEIGHT - ROMFONT_CELL_HEIGHT
      local quad = love.graphics.newQuad(source_x, source_y, ROMFONT_CELL_WIDTH, ROMFONT_CELL_HEIGHT, romfont_tileset_image)
      table.insert(romfont_tile_quads, quad)
    end
  end
end

local function set_up_grid()
  grid_tileset_image = love.graphics.newImage(GRID_TILESET_FILENAME)
  grid_canvas = love.graphics.newCanvas(GRID_COLUMNS * GRID_CELL_WIDTH, GRID_ROWS * GRID_CELL_HEIGHT)
  grid_canvas:setFilter("nearest","nearest")
  local image_width = grid_tileset_image:getWidth()
  local image_height = grid_tileset_image:getHeight()
  local tile_columns = image_width / GRID_CELL_WIDTH
  local tile_rows = image_height / GRID_CELL_HEIGHT
  for row = 1, tile_rows do
    for column = 1, tile_columns do
      local source_x = column * GRID_CELL_WIDTH - GRID_CELL_WIDTH
      local source_y = row * GRID_CELL_HEIGHT - GRID_CELL_HEIGHT
      local quad = love.graphics.newQuad(source_x, source_y, GRID_CELL_WIDTH, GRID_CELL_HEIGHT, grid_tileset_image)
      table.insert(grid_tile_quads, quad)
    end
  end
end

local function set_up_status_panel()
  status_panel_canvas = love.graphics.newCanvas(STATUS_PANEL_COLUMNS * ROMFONT_CELL_WIDTH, STATUS_PANEL_ROWS * ROMFONT_CELL_HEIGHT)
  status_panel_canvas:setFilter("nearest","nearest")
  status_panel_cells = {}
  while #status_panel_cells < STATUS_PANEL_ROWS do
    local line = {}
    table.insert(status_panel_cells, line)
    while #line < STATUS_PANEL_COLUMNS do
      local cell = {color={1,1,1},character=1}
      table.insert(line, cell)
    end
  end
end

function love.load(arg)
    set_up_romfont()
    set_up_grid()
    set_up_status_panel()
    world_initializer.initialize()
end

local function get_cursor_position(character_id)
	local direction_id = character.get_direction(character_id)
	if direction_id == nil then return end
	local room_cell_id = character.get_room_cell(character_id)
	local column, row = room_cell.get_position(room_cell_id)
	return directions.get_next_position(direction_id, column, row)
end

local function draw_grid_tile(tile, x, y)
  love.graphics.draw(grid_tileset_image, grid_tile_quads[tile], x, y)
end

local function draw_grid()
  love.graphics.setCanvas(grid_canvas)
  local avatar_character_id = avatar.get_character()
  local cursor_column, cursor_row = get_cursor_position(avatar_character_id)
  local room_id = character.get_room(avatar_character_id)
  for column = 1, room.get_columns(room_id) do
    local plot_x = column * GRID_CELL_WIDTH - GRID_CELL_WIDTH
    for row = 1, room.get_rows(room_id) do
      local plot_y = row * GRID_CELL_HEIGHT - GRID_CELL_HEIGHT
      local room_cell_id = room.get_room_cell(room_id, column, row)
      local room_cell_type_id = room_cell.get_room_cell_type(room_cell_id)
      local tile = room_cell_type.get_tile(room_cell_type_id)
      draw_grid_tile(tile, plot_x, plot_y)

      local feature_id = room_cell.get_feature(room_cell_id)
      if feature_id ~= nil then
        local feature_type_id = feature.get_feature_type(feature_id)
        tile = feature_type.get_tile(feature_type_id)
        love.graphics.draw(grid_tileset_image, grid_tile_quads[tile], plot_x, plot_y)
      end

      local character_id = room_cell.get_character(room_cell_id)
      if character_id ~= nil then
        local character_type_id = character.get_character_type(character_id)
        tile = character_type.get_tile(character_type_id)
        draw_grid_tile(tile, plot_x, plot_y)
      end

      if column == cursor_column and row == cursor_row then
        draw_grid_tile(grimoire.TILE_CURSOR, plot_x, plot_y)
      end
    end
  end
  love.graphics.setCanvas()
end

local function draw_status_panel()
  love.graphics.setCanvas(status_panel_canvas)
  love.graphics.clear()
  local r,g,b,a = love.graphics.getColor()
  for row = 1, STATUS_PANEL_ROWS do
    local plot_y = row * ROMFONT_CELL_HEIGHT - ROMFONT_CELL_HEIGHT
    for column = 1, STATUS_PANEL_COLUMNS do
      local plot_x = column * ROMFONT_CELL_WIDTH - ROMFONT_CELL_WIDTH
      local cell = status_panel_cells[row][column]
      love.graphics.setColor(cell.color)
      love.graphics.draw(romfont_tileset_image, romfont_tile_quads[cell.character], plot_x, plot_y)
    end
  end
  love.graphics.setColor(r,g,b,a)
  love.graphics.setCanvas()
end

local function clear_status_panel()
  for row = 1, STATUS_PANEL_ROWS do
    for column = 1, STATUS_PANEL_COLUMNS do
      status_panel_cells[row][column].character = 1
    end
  end
end

local function write_status_panel(column, row, color, text)
  for index = 1, #text do
    local cell = status_panel_cells[row][column]
    cell.color = color
    cell.character = string.byte(text, index) + 1
    column = column + 1
  end
end

local COLOR_LIGHT_GRAY = {2/3,2/3,2/3}
local COLOR_WHITE = {1,1,1}

local function update_status_panel()
  local character_id = avatar.get_character()
  clear_status_panel()
  local row = 1
  local xp = character.get_statistic(character_id, statistic_type.PUNCHES_LANDED)
  local xp_goal = character.get_statistic(character_id, statistic_type.PUNCH_GOAL)
  write_status_panel(1, row, COLOR_LIGHT_GRAY, "    XP: "..xp.."/"..xp_goal)
  row = row + 1
  
  local xp_level = character.get_statistic(character_id, statistic_type.PUNCH_LEVEL)
  write_status_panel(1, row, COLOR_LIGHT_GRAY, " Level: "..xp_level)
  row = row + 1
  
  local moves = character.get_statistic(character_id, statistic_type.MOVES)
  write_status_panel(1, row, COLOR_LIGHT_GRAY, " Moves: "..moves)
  row = row + 1
  
  local trees = character.get_statistic(character_id, statistic_type.TREES_MURDERED)
  write_status_panel(1, row, COLOR_LIGHT_GRAY, " Trees: "..trees)
  row = row + 1

  local energy = character.get_statistic(character_id, statistic_type.ENERGY)
  local maximum_energy = character.get_statistic(character_id, statistic_type.MAXIMUM_ENERGY)
  write_status_panel(1, row, COLOR_LIGHT_GRAY, "Energy: "..energy.."/"..maximum_energy)
  row = row + 1

  local wood = character.get_statistic(character_id, statistic_type.WOOD)
  write_status_panel(1, row, COLOR_LIGHT_GRAY, "  Wood: "..wood)
  row = row + 1

  local jools = character.get_statistic(character_id, statistic_type.JOOLS)
  write_status_panel(1, row, COLOR_LIGHT_GRAY, " Jools: "..jools)
  row = row + 1
end

function love.update()
  update_status_panel()
end

function love.draw()
  draw_grid()
  draw_status_panel()
  love.graphics.draw(grid_canvas, GRID_OFFSET_X, GRID_OFFSET_Y, 0, GRID_SCALE_X, GRID_SCALE_Y)
  love.graphics.draw(status_panel_canvas, STATUS_PANEL_OFFSET_X, STATUS_PANEL_OFFSET_Y, 0, STATUS_PANEL_SCALE_X, STATUS_PANEL_SCALE_Y)
end

function love.keypressed(key, scancode, isrepeat)
  if key == "up" then
    character.do_verb(avatar.get_character(), verb_type.MOVE, {direction_id = directions.NORTH})
  elseif key == "down" then
    character.do_verb(avatar.get_character(), verb_type.MOVE, {direction_id = directions.SOUTH})
  elseif key == "left" then
    character.do_verb(avatar.get_character(), verb_type.MOVE, {direction_id = directions.WEST})
  elseif key == "right" then
    character.do_verb(avatar.get_character(), verb_type.MOVE, {direction_id = directions.EAST})
  elseif key == "space" then
    character.do_verb(avatar.get_character(), verb_type.ACTION, {})
  end
end