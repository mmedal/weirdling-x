import 'CoreLibs/object'
import 'CoreLibs/graphics'

import '../constants'

local gfx <const> = playdate.graphics

class('FacingImage').extends()

function FacingImage:init(downImagePath, rightImagePath)
    self.downImage = gfx.image.new(downImagePath)
    self.rightImage = gfx.image.new(rightImagePath)
end

function FacingImage:imageFromFacing(facing)
    if facing == Constants.DOWN then
        return self.downImage, gfx.kImageUnflipped
    elseif facing == Constants.RIGHT then
        return self.rightImage, gfx.kImageUnflipped
    elseif facing == Constants.LEFT then
        return self.rightImage, gfx.kImageFlippedX
    elseif facing == Constants.UP then
        return self.downImage, gfx.kImageFlippedY
    else
        error('Invalid facing: ' .. facing)
    end
end
