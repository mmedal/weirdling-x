import "CoreLibs/object"
import "CoreLibs/sprites"

import "../lib/animated_image"
import "../lib/machine"

local playerImageTablePath <const> = "/assets/images/cecil_sheet.png"

class('Player').extends()

function Player.init()
    self.image = AnimatedImage()
    self.fsm = Machine()
    self.position = { x = 0, y = 0 }
    self.velocity = { x = 0, y = 0 }
end
