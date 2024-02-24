import 'CoreLibs/object'

class('PlayerInput').extends()

function PlayerInput.handle(player)
    return {
        downButtonDown = function()
            player.machine:walkdown()
        end,
        downButtonUp = function()
            if player.machine.current == 'walkingdown' then
                player.machine:idle()
            end
        end,
        upButtonDown = function()
            player.machine:walkup()
        end,
        upButtonUp = function()
            if player.machine.current == 'walkingup' then
                player.machine:idle()
            end
        end,
        leftButtonDown = function()
            player.machine:walkleft()
        end,
        leftButtonUp = function()
            if player.machine.current == 'walkingleft' then
                player.machine:idle()
            end
        end,
        rightButtonDown = function()
            player.machine:walkright()
        end,
        rightButtonUp = function()
            if player.machine.current == 'walkingright' then
                player.machine:idle()
            end
        end,
    }
end
