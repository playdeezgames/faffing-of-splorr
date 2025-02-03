local M = {}
local romfont = require "romfont"
local TOOL_TIP_COLUMNS = 80
local TOOL_TIP_ROWS = 1
local TOOL_TIP_OFFSET_X = 0
local TOOL_TIP_OFFSET_Y = 640
local TOOL_TIP_SCALE_X = 2
local TOOL_TIP_SCALE_Y = 2

local tool_tip_text = ""
local tool_tip_canvas = nil

function M.set_up()
    tool_tip_canvas = love.graphics.newCanvas(TOOL_TIP_COLUMNS * romfont.ROMFONT_CELL_WIDTH, TOOL_TIP_ROWS * romfont.ROMFONT_CELL_HEIGHT)
    tool_tip_canvas:setFilter("nearest","nearest")
end

function M.set_text(text)
    tool_tip_text = text
end

local COLOR_WHITE = {1,1,1}

function M.update()
end

function M.draw()
    love.graphics.setCanvas(tool_tip_canvas)
    love.graphics.clear()
    local r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(COLOR_WHITE)
    local plot_x = (TOOL_TIP_COLUMNS - #tool_tip_text) * romfont.ROMFONT_CELL_WIDTH / 2
    local plot_y = 0
    for index = 1, #tool_tip_text do
        local character = string.byte(tool_tip_text, index) + 1
        love.graphics.draw(romfont.romfont_tileset_image, romfont.romfont_tile_quads[character], plot_x, plot_y)
        plot_x = plot_x + romfont.ROMFONT_CELL_WIDTH
    end
    love.graphics.setColor(r, g, b, a)
    love.graphics.setCanvas()
    love.graphics.draw(tool_tip_canvas, TOOL_TIP_OFFSET_X, TOOL_TIP_OFFSET_Y, 0, TOOL_TIP_SCALE_X, TOOL_TIP_SCALE_Y)
end

return M