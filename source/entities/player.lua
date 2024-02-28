import "CoreLibs/object"
import "CoreLibs/sprites"

import "../constants"
import "../lib/animated_image"
import "../lib/animated_sprite"
import "../lib/machine"

local playerImageTablePath <const> = "/assets/images/cecilsheet"

class('Player').extends()

function Player:init()
    self.animated_sprite = AnimatedSprite(
        { x = 0, y = 0 },
        {
            walkdown = AnimatedImage(playerImageTablePath, {
                delay = 100,
                sequence = { 1, 2 },
                loop = true
            }),
            walkup = AnimatedImage(playerImageTablePath, {
                delay = 100,
                sequence = { 3, 4 },
                loop = true
            }),
            walkleft = AnimatedImage(playerImageTablePath, {
                delay = 100,
                sequence = { 7, 8 },
                loop = true
            }),
            walkright = AnimatedImage(playerImageTablePath, {
                delay = 100,
                sequence = { 5, 6 },
                loop = true
            }),
        },
        self
    )

    self.machine = Machine({
        initial = 'idling',
        events = {
            { name = 'walkdown',  from = '*', to = 'walkingdown' },
            { name = 'walkup',    from = '*', to = 'walkingup' },
            { name = 'walkleft',  from = '*', to = 'walkingleft' },
            { name = 'walkright', from = '*', to = 'walkingright' },
            { name = 'idle',      from = '*', to = 'idling' },
        },
        player = self,
        callbacks = {
            onwalkingdown = function(self, event, from, to)
                -- self.options.player.animated_sprite:trigger_walkdown_ani()
                self.options.player.velocity.y = self.options.player.speed
                self.options.player.velocity.x = 0
            end,
            onwalkingup = function(self, event, from, to)
                -- self.options.player.animated_sprite:trigger_walkup_ani()
                self.options.player.velocity.y = -self.options.player.speed
                self.options.player.velocity.x = 0
            end,
            onwalkingleft = function(self, event, from, to)
                -- self.options.player.animated_sprite:trigger_walkleft_ani()
                self.options.player.velocity.x = -self.options.player.speed
                self.options.player.velocity.y = 0
            end,
            onwalkingright = function(self, event, from, to)
                -- self.options.player.animated_sprite:trigger_walkright_ani()
                self.options.player.velocity.x = self.options.player.speed
                self.options.player.velocity.y = 0
            end,
            onidling = function(self, event, from, to)
                self.options.player.animated_sprite:trigger_idle_ani()
                self.options.player.velocity.x = 0
                self.options.player.velocity.y = 0
            end,
        }
    })
    self.facing = Constants.DOWN
    self.position = { x = 0, y = 0 }
    self.velocity = { x = 0, y = 0 }
    self.speed = 3
    self.level = nil
end

function Player:setLevel(level)
    self.level = level
end

function Player:update(sprite)
    -- TODO: need to add support for saving state of which buttons are being hend
    -- and the order, so that we can resume movement after part of a chord is released
    if self.machine.current == 'idling' then
        sprite:moveTo(self.position.x, self.position.y)
    else
        -- We have to set the animation here because the fudge corner
        -- allows the player to be moving in a direction that is not
        -- the direction the player is holding on the dpad
        local new_position = self.level:pixelTraverse(self.position, self.velocity)
        if new_position.x < self.position.x then
            self.animated_sprite:trigger_walkleft_ani()
            self.facing = Constants.LEFT
        elseif new_position.x > self.position.x then
            self.animated_sprite:trigger_walkright_ani()
            self.facing = Constants.RIGHT
        elseif new_position.y < self.position.y then
            self.animated_sprite:trigger_walkup_ani()
            self.facing = Constants.UP
        elseif new_position.y > self.position.y then
            self.animated_sprite:trigger_walkdown_ani()
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

function Player:spawn()
    assert(self.level, "Player:update() - level not set")
    self.position = self.level:playerPixelSpawnPosition()
    self.animated_sprite:show()
end

function Player:die()
    assert(self.level, "Player:update() - level not set")
    self.animated_sprite:hide()
end
