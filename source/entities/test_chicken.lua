import 'CoreLibs/object'

import 'enemy'
import '../lib/animated_image'
import '../constants'

local chickenImageTablePath <const> = "/assets/images/chicken"

class('TestChicken').extends(Enemy)

function TestChicken:init(level, tilePositionXY)
    self.factory_create(
        self,
        level,
        level:centerOfTile(tilePositionXY.x, tilePositionXY.y),
        Constants.DOWN,
        4,
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
            { name = 'movedown',  from = '*', to = 'movingdown' },
            { name = 'moveup',    from = '*', to = 'movingup' },
            { name = 'moveleft',  from = '*', to = 'movingleft' },
            { name = 'moveright', from = '*', to = 'movingright' },
            { name = 'idle',      from = '*', to = 'idling' },
        },
        {
            onmovingdown = function(self, event, from, to)
                self.options.parent.velocity.y = self.options.parent.speed
                self.options.parent.velocity.x = 0
            end,
            onmovingup = function(self, event, from, to)
                self.options.parent.velocity.y = -self.options.parent.speed
                self.options.parent.velocity.x = 0
            end,
            onmovingleft = function(self, event, from, to)
                self.options.parent.velocity.y = 0
                self.options.parent.velocity.x = -self.options.parent.speed
            end,
            onmovingright = function(self, event, from, to)
                self.options.parent.velocity.y = 0
                self.options.parent.velocity.x = self.options.parent.speed
            end,
            onidling = function(self, event, from, to)
                self.options.parent.sprite:trigger_idle_ani()
                self.options.parent.velocity.y = 0
                self.options.parent.velocity.x = 0
            end,
        }
    )
end

function TestChicken:update(sprite)
    if self.machine.current == 'idling' then
        local direction = math.random(1, 4)
        if direction == Constants.UP then
            self.machine:moveup()
        elseif direction == Constants.DOWN then
            self.machine:movedown()
        elseif direction == Constants.LEFT then
            self.machine:moveleft()
        elseif direction == Constants.RIGHT then
            self.machine:moveright()
        end
    else
        local new_position = self.level:pixelTraverse(
            self.position,
            self.velocity
        )
        if new_position.x < self.position.x then
            self.sprite:trigger_moveleft_ani()
            self.facing = Constants.LEFT
        elseif new_position.x > self.position.x then
            self.sprite:trigger_moveright_ani()
            self.facing = Constants.RIGHT
        elseif new_position.y < self.position.y then
            self.sprite:trigger_moveup_ani()
            self.facing = Constants.UP
        elseif new_position.y > self.position.y then
            self.sprite:trigger_movedown_ani()
            self.facing = Constants.DOWN
        else
        end
        if self.position == new_position then
            self.machine:idle()
        end
        self.position = new_position
        sprite:moveTo(new_position.x, new_position.y)
    end
end
