import "CoreLibs/object"
import "CoreLibs/sprites"

import "./animated_image"
import "./machine"

local gfx <const> = playdate.graphics

class('AnimatedSprite').extends()

-- animations is a table of AnimatedImage objects
-- {
--     walk = AnimatedImage("/assets/images/sheet.png", {
--         delay = 10,
--         paused = true,
--         sequence = { 1, 2, 3 },
--         loop = true
--     }),
-- }
function AnimatedSprite:init(animations)
    -- self.static_image = gfx.image.new(static_image_path)
    self.sprite = gfx.sprite.new()
    self.animations = animations
    self.hasIdle = self.animations.idle ~= nil
    if not self.hasIdle then
        self['trigger_idle_ani'] = function(self)
            self.animation:setPaused(true)
            self.lastAnimation = self.currentAnimation
            self.currentAnimation = 'idle'
        end
        -- TODO need a better way to set a static idle image if no idle animation
        local _, yolo = next(self.animations)
        self.animation = yolo
        self.animation:setPaused(true)
    else
        self.animation = self.animations.idle
    end
    self.currentAnimation = 'idle'
    self.lastAnimation = 'idle'
    for name, animation in pairs(animations) do
        self['trigger_' .. name .. '_ani'] = function(self)
            if not self.hasIdle then
                if self.currentAnimation == 'idle' and self.lastAnimation == name then
                    self.animation:setPaused(false)
                    self.currentAnimation = name
                    self.lastAnimation = 'idle'
                    return
                end
            end
            if self.currentAnimation == name then
                return
            else
                self.lastAnimation = self.currentAnimation
                self.animation = animation
                self.currentAnimation = name
                self.animation:reset()
                self.animation:setPaused(false)
            end
        end
    end

    self.sprite.animated_sprite = self
    self.sprite.update = function(self)
        self:setImage(self.animated_sprite.animation:getImage())
        self.animated_sprite.position.x = self.animated_sprite.position.x + self.animated_sprite.velocity.x
        self.animated_sprite.position.y = self.animated_sprite.position.y + self.animated_sprite.velocity.y
        self:moveTo(self.animated_sprite.position.x, self.animated_sprite.position.y)
    end

    self.position = { x = 50, y = 50 }
    self.velocity = { x = 0, y = 0 }
    self.speed = 3
    self.sprite:moveTo(self.position.x, self.position.y)
    self.sprite:add()
end

function AnimatedSprite:moveLeft()
    self.velocity.x = -self.speed
end

function AnimatedSprite:moveRight()
    self.velocity.x = self.speed
end

function AnimatedSprite:moveUp()
    self.velocity.y = -self.speed
end

function AnimatedSprite:moveDown()
    self.velocity.y = self.speed
end

function AnimatedSprite:stopMoving()
    self.velocity.x = 0
    self.velocity.y = 0
end
