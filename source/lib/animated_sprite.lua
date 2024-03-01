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
--
-- updater is an object that implements the update method and accepts the sprite as an argument
-- it can be used to let parent objects update the sprite
function AnimatedSprite:init(position, animations, updater)
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
                self.animation:setPaused(false)
            else
                self.lastAnimation = self.currentAnimation
                self.animation = animation
                self.currentAnimation = name
                self.animation:reset()
                self.animation:setPaused(false)
            end
        end
    end

    -- allow a parent object to update the sprite easily
    self.sprite.animated_sprite = self
    self.sprite.updater = updater
    self.sprite.update = function(self)
        updater:update(self)
        self:setImage(self.animated_sprite.animation:getImage())
    end

    -- set the starting position of the sprite, likely overridden quickly by update
    self.sprite:moveTo(position.x, position.y)
end

function AnimatedSprite:addAnimations(animations)
    for name, animation in pairs(animations) do
        self.animations[name] = animation
        self['trigger_' .. name .. '_ani'] = function(self)
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
end

function AnimatedSprite:moveTo(x, y)
    self.sprite:moveTo(x, y)
end

function AnimatedSprite:show()
    self.sprite:add()
end

function AnimatedSprite:hide()
    self.sprite:remove()
end
