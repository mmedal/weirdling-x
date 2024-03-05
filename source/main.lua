import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/animator"
import "CoreLibs/easing"
import "CoreLibs/timer"
import "CoreLibs/ui"

import "./game"
import './importer'

local gfx <const> = playdate.graphics
playdate.display.setRefreshRate(40)
Game.machine:boot()

function playdate.update()
    gfx.sprite.update()
    playdate.timer.updateTimers()
    playdate.drawFPS(380, 0)
end
