import 'CoreLibs/object'

import '../constants'

class('PlayerInput').extends()

PlayerInput.dpad = {
    up = false,
    down = false,
    left = false,
    right = false,
}

function PlayerInput.dpadHeld()
    return PlayerInput.dpad.up or PlayerInput.dpad.down or PlayerInput.dpad.left or PlayerInput.dpad.right
end

function PlayerInput.handle(player)
    return {
        downButtonDown = function()
            PlayerInput.dpad.down = true
            player.machine:attemptmove(Constants.DOWN)
        end,
        downButtonUp = function()
            PlayerInput.dpad.down = false
            if not PlayerInput.dpadHeld() then
                player.machine:idle()
            end
        end,
        upButtonDown = function()
            PlayerInput.dpad.up = true
            player.machine:attemptmove(Constants.UP)
        end,
        upButtonUp = function()
            PlayerInput.dpad.up = false
            if not PlayerInput.dpadHeld() then
                player.machine:idle()
            end
        end,
        leftButtonDown = function()
            PlayerInput.dpad.left = true
            player.machine:attemptmove(Constants.LEFT)
        end,
        leftButtonUp = function()
            PlayerInput.dpad.left = false
            if not PlayerInput.dpadHeld() then
                player.machine:idle()
            end
        end,
        rightButtonDown = function()
            PlayerInput.dpad.right = true
            player.machine:attemptmove(Constants.RIGHT)
        end,
        rightButtonUp = function()
            PlayerInput.dpad.right = false
            if not PlayerInput.dpadHeld() then
                player.machine:idle()
            end
        end,
        BButtonDown = function()
            player.machine:shoot()
        end,
    }
end
