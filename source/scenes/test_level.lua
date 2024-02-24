import 'CoreLibs/object'

import './scene'
import '../entities/player'
import '../lib/level'
import '../lib/tilemap_traversal'
import '../input/player_input'

local gfx <const> = playdate.graphics

class('TestLevel').extends(Scene)

function TestLevel:init()
    local tileset = gfx.imagetable.new('/assets/images/testterrain')
    local tilemap = gfx.tilemap.new()
    tilemap:setImageTable(tileset)
    tilemap:setTiles(
        {
            8, 5, 1, 9, 1, 1, 9, 1, 8, 5,
            10, 3, 4, 8, 4, 3, 5, 3, 4, 10,
            7, 6, 10, 7, 4, 3, 6, 10, 7, 6,
            8, 5, 3, 1, 4, 3, 1, 4, 8, 5, 7,
            2, 6, 13, 7, 6, 13, 7, 2, 6
        },
        10)
    local tilemap_traversal = TilemapTraversal(tilemap, {
        { 1, 0, 0, 0 },
        { 0, 0, 1, 0 },
        { 0, 0, 0, 1 },
        { 0, 1, 0, 0 },
        { 1, 1, 0, 0 },
        { 0, 1, 1, 0 },
        { 0, 0, 1, 1 },
        { 1, 0, 0, 1 },
        { 1, 0, 1, 0 },
        { 0, 1, 0, 1 },
        { 1, 1, 1, 0 },
        { 1, 0, 1, 1 },
        { 0, 1, 1, 1 },
        { 1, 1, 0, 1 },
    })
    gfx.sprite.setBackgroundDrawingCallback(
        function(x, y, width, height)
            tilemap:draw(0, 0)
        end
    )
    self.player = Player()
    self.level = Level(tilemap, tilemap_traversal, { x = 1, y = 1 })
    self.player:setLevel(self.level)
end

function TestLevel:load()
    print('TestLevel:load()')
    self.player:spawn()
    playdate.inputHandlers.push(PlayerInput.handle(self.player))
end
