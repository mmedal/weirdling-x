import "CoreLibs/object"

import 'lib/singleton'

class('Constants').extends(Singleton)

Constants.UP = 1
Constants.DOWN = 2
Constants.LEFT = 3
Constants.RIGHT = 4

Constants.SCREEN_WIDTH = 400
Constants.SCREEN_HEIGHT = 240

function Constants.velocityFromFacing(facing, speed)
    if facing == Constants.UP then
        return { x = 0, y = -speed }
    elseif facing == Constants.DOWN then
        return { x = 0, y = speed }
    elseif facing == Constants.LEFT then
        return { x = -speed, y = 0 }
    elseif facing == Constants.RIGHT then
        return { x = speed, y = 0 }
    end
end

function Constants.randomDirection()
    return math.random(1, 4)
end
