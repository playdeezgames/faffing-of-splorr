local M = {}

M.BOARD_COLUMNS = 20
M.BOARD_CENTER_COLUMN = math.floor((M.BOARD_COLUMNS + 1) / 2)
M.BOARD_ROWS = 20
M.BOARD_CENTER_ROW = math.floor((M.BOARD_ROWS + 1) / 2)
M.BOARD_CELL_WIDTH = 8
M.BOARD_CELL_HEIGHT = 8
M.BOARD_WIDTH = M.BOARD_CELL_WIDTH * M.BOARD_COLUMNS
M.BOARD_HEIGHT = M.BOARD_CELL_HEIGHT * M.BOARD_ROWS

M.TEXT_COLUMNS = 20
M.TEXT_ROWS = 20
M.TEXT_CELL_WIDTH = 8
M.TEXT_CELL_HEIGHT = 8
M.TEXT_WIDTH = M.TEXT_CELL_WIDTH * M.TEXT_COLUMNS
M.TEXT_HEIGHT = M.TEXT_CELL_HEIGHT * M.TEXT_ROWS

M.TILE_HERO = 5
M.TILE_BLANK = 18
M.TILE_PINE = 85
M.TILE_CURSOR = 161
M.TILE_PUNCHED_PINE = 162
M.TILE_GRAVEL = 69
M.TILE_WELL = 108
M.TILE_PORTAL = 130
M.TILE_WOOD_BUYER = 6

M.SCENE_TILEMAP_URL = "/scene#scene"
M.MESSAGE_TILEMAP_URL = "/message#message"
M.MESSAGE_URL = "/message"

M.LAYER_TERRAIN = "terrain"
M.LAYER_CHARACTER = "character"
M.LAYER_FEATURE = "feature"
M.LAYER_TEXT = "text"
M.LAYER_EFFECT = "effect"

M.ACTION_UP = "UP"
M.ACTION_DOWN = "DOWN"
M.ACTION_LEFT = "LEFT"
M.ACTION_RIGHT = "RIGHT"
M.ACTION_GREEN = "GREEN"
M.ACTION_RED = "RED"

M.MSG_ADD_MESSAGE = "ADD_MESSAGE"
M.MSG_CLEAR_MESSAGES = "CLEAR_MESSAGES"

return M