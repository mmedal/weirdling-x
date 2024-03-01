import "CoreLibs/object"
import "CoreLibs/sprites"

import 'character'
import "../constants"
import "../entities/bullet"
import 'traits/can_move'
import "../lib/animated_image"
import "../lib/animated_sprite"
import "../lib/machine"

local playerImageTablePath <const> = "/assets/images/cecilsheet"

class('Player').extends(Character)

function Player:init(level, tilePositionXY)
    self.factory_create(
        self,
        level,
        level:centerOfTile(tilePositionXY.x, tilePositionXY.y),
        {
            movedown = AnimatedImage(playerImageTablePath, {
                delay = 100,
                sequence = { 1, 2 },
                loop = true
            }),
            moveup = AnimatedImage(playerImageTablePath, {
                delay = 100,
                sequence = { 3, 4 },
                loop = true
            }),
            moveleft = AnimatedImage(playerImageTablePath, {
                delay = 100,
                sequence = { 7, 8 },
                loop = true
            }),
            moveright = AnimatedImage(playerImageTablePath, {
                delay = 100,
                sequence = { 5, 6 },
                loop = true
            }),
        },
        'idling',
        {
            { name = 'idle',  from = '*', to = 'idling' },
            { name = 'shoot', from = '*', to = 'shooting' },
        },
        {
            onshooting = function(self, event, from, to)
                Bullet(self.options.parent)
                self:idle()
            end,
        }
    )
    self:addTraits({ CanMove })
    self.speed = 3
end

function Player:update(sprite)
    -- TODO: need to add support for saving state of which buttons are being hend
    -- and the order, so that we can resume movement after part of a chord is released
    if self.machine.current == 'idling' then
    else
        self:applyMove()
    end
end

function Player:spawn()
    assert(self.level, "Player:update() - level not set")
    self.position = self.level:playerPixelSpawnPosition()
    self.sprite:show()
end

function Player:die()
    assert(self.level, "Player:update() - level not set")
    self.animated_sprite:hide()
end
