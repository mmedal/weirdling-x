import 'CoreLibs/object'

class('PlayerInput').extends()

function PlayerInput.handle(player)
    return {
        downButtonDown = function()
            print("downButtonDown")
            player.machine:walkdown()
        end,
        downButtonUp = function()
            print("downButtonUp")
            if player.machine.current == 'walkingdown' then
                player.machine:idle()
            end
        end,
        upButtonDown = function()
            print("upButtonDown")
            player.machine:walkup()
        end,
        upButtonUp = function()
            print("upButtonUp")
            if player.machine.current == 'walkingup' then
                player.machine:idle()
            end
        end,
        leftButtonDown = function()
            print("leftButtonDown")
            player.machine:walkleft()
        end,
        leftButtonUp = function()
            print("leftButtonUp")
            if player.machine.current == 'walkingleft' then
                player.machine:idle()
            end
        end,
        rightButtonDown = function()
            print("rightButtonDown")
            player.machine:walkright()
        end,
        rightButtonUp = function()
            print("rightButtonUp")
            if player.machine.current == 'walkingright' then
                player.machine:idle()
            end
        end,
    }
end
