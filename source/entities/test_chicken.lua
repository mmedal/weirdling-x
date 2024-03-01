import 'CoreLibs/object'

import 'character'
import 'traits/can_move'
import '../lib/animated_image'
import '../constants'

local chickenImageTablePath <const> = "/assets/images/chicken"

class('TestChicken').extends(Character)

function TestChicken:init(level, tilePositionXY)
    self.factory_create(
        self,
        level,
        level:centerOfTile(tilePositionXY.x, tilePositionXY.y),
        {
            movedown = AnimatedImage(chickenImageTablePath, {
                delay = 100,
                sequence = { 1 },
                loop = true
            }),
            moveup = AnimatedImage(chickenImageTablePath, {
                delay = 100,
                sequence = { 1 },
                loop = true
            }),
            moveleft = AnimatedImage(chickenImageTablePath, {
                delay = 100,
                sequence = { 1 },
                loop = true
            }),
            moveright = AnimatedImage(chickenImageTablePath, {
                delay = 100,
                sequence = { 1 },
                loop = true
            }),
        },
        'idling',
        {
            { name = 'idle', from = '*', to = 'idling' },
        },
        {}
    )
    self:addTraits({ CanMove })
end

function TestChicken:update(sprite)
    if self.machine.current == 'idling' then
        self:attemptMove(Constants.randomDirection())
    else
        self:applyMove()
    end
end
