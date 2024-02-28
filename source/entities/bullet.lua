import "CoreLibs/object"
import "CoreLibs/animator"
import "CoreLibs/easing"
import "CoreLibs/graphics"
import "CoreLibs/sprites"

import "../constants"
import "../lib/animated_sprite"
import "../lib/simple_sprite"

local gfx <const> = playdate.graphics

local bulletImagePath <const> = "/assets/images/hunter-shot"
local bulletImage = gfx.image.new(bulletImagePath)

class('Bullet').extends()

function Bullet:init(player)
    self.position = player.position
    self.speed = 4
    self.velocity = Constants.velocityFromFacing(player.facing, self.speed)
    self.sprite = SimpleSprite(
        self.spawnXY,
        bulletImage,
        self
    )
end

function Bullet:update()
    self.position = self.sprite:move(self.velocity)
end
