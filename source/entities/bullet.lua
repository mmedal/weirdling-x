import "CoreLibs/object"
import "CoreLibs/animator"
import "CoreLibs/easing"
import "CoreLibs/graphics"
import "CoreLibs/sprites"

import "../constants"
import "../lib/animated_sprite"
import '../lib/facing_image'
import "../lib/simple_sprite"

local bulletDownImagePath <const> = "/assets/images/hunter-shot-down"
local bulletRightImagePath <const> = "/assets/images/hunter-shot-right"
local bulletImage = FacingImage(bulletDownImagePath, bulletRightImagePath)

class('Bullet').extends()

function Bullet:init(player)
    self.position = player.position
    self.speed = 4
    self.velocity = Constants.velocityFromFacing(player.facing, self.speed)
    local image, flip = bulletImage:imageFromFacing(player.facing)
    self.sprite = SimpleSprite(
        self.position,
        image,
        self,
        { flip = flip }
    )
end

function Bullet:update()
    self.position = self.sprite:move(self.velocity)
end
