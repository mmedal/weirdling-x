import 'CoreLibs/object'

import './scene'
import '../lib/animated_sprite'
import '../lib/level'

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
    gfx.sprite.setBackgroundDrawingCallback(
        function(x, y, width, height)
            tilemap:draw(0, 0)
        end
    )
    self.sprite = AnimatedSprite({
        walkdown = AnimatedImage('/assets/images/cecilsheet', {
            delay = 100,
            sequence = { 1, 2 },
            loop = true
        }),
        walkup = AnimatedImage('/assets/images/cecilsheet', {
            delay = 100,
            sequence = { 3, 4 },
            loop = true
        }),
        walkleft = AnimatedImage('/assets/images/cecilsheet', {
            delay = 100,
            sequence = { 7, 8 },
            loop = true
        }),
        walkright = AnimatedImage('/assets/images/cecilsheet', {
            delay = 100,
            sequence = { 5, 6 },
            loop = true
        }),
    })
end

function TestLevel:load()
    print('TestLevel:load()')
    playdate.inputHandlers.push(self:inputHandler())
end

function TestLevel:inputHandler()
    return {
        downButtonDown = function()
            self.sprite:trigger_walkdown_ani()
            self.sprite:moveDown()
        end,
        downButtonUp = function()
            self.sprite:trigger_idle_ani()
            self.sprite:stopMoving()
        end,
        upButtonDown = function()
            self.sprite:trigger_walkup_ani()
            self.sprite:moveUp()
        end,
        upButtonUp = function()
            self.sprite:trigger_idle_ani()
            self.sprite:stopMoving()
        end,
        leftButtonDown = function()
            self.sprite:trigger_walkleft_ani()
            self.sprite:moveLeft()
        end,
        leftButtonUp = function()
            self.sprite:trigger_idle_ani()
            self.sprite:stopMoving()
        end,
        rightButtonDown = function()
            self.sprite:trigger_walkright_ani()
            self.sprite:moveRight()
        end,
        rightButtonUp = function()
            self.sprite:trigger_idle_ani()
            self.sprite:stopMoving()
        end,
    }
end
