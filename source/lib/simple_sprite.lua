import "CoreLibs/object"
import "Corelibs/sprites"

local gfx <const> = playdate.graphics

class('SimpleSprite').extends()

-- options.flip can be specified as a gfx.flip value
function SimpleSprite:init(position, image, updater, options)
    self.image = image
    self.sprite = gfx.sprite.new(image)
    if options and options.flip then
        self.sprite:setImageFlip(options.flip)
    end
    self.sprite:moveTo(position.x, position.y)
    self.sprite:add()

    self.updater = updater
    self.sprite.simple_sprite = self
    self.sprite.updater = updater
    self.sprite.update = function(self)
        updater:update(self)
    end
end

function SimpleSprite:move(velocity)
    local newX = self.sprite.x + velocity.x
    local newY = self.sprite.y + velocity.y
    self.sprite:moveTo(newX, newY)
    return { x = newX, y = newY }
end

function SimpleSprite:show()
    self.sprite:add()
end

function SimpleSprite:hide()
    self.sprite:remove()
end
