import 'CoreLibs/object'
import 'CoreLibs/graphics'

import '../constants'

local gfx <const> = playdate.graphics

---@class FacingImage: Object
---@field downImage _Image
---@field rightImage _Image
---@overload fun(downImagePath: string, rightImagePath: string): FacingImage
FacingImage = class('FacingImage').extends() or FacingImage

function FacingImage:init(downImagePath, rightImagePath)
    self.downImage, err = gfx.image.new(downImagePath) or error('Could not load image: ' .. downImagePath .. err)
    self.rightImage = gfx.image.new(rightImagePath)
end

--- Creates an image based on the given facing.
--- @param facing string The facing direction.
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
