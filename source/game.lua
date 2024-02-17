import "CoreLibs/object"

import "./lib/machine"
import "./lib/singleton"

-- TODO temp test
import "scenes/test_level"

local systemMenu = playdate.getSystemMenu()

class('Game').extends(Singleton)

Game.machine = Machine({
    initial = Machine.NONE,
    events = {
        { name = 'boot',  from = 'none',      to = 'main_menu' },
        { name = 'start', from = 'main_menu', to = 'playing' },
        { name = 'quit',  from = 'playing',   to = 'main_menu' }
    },
    callbacks = {
        onboot = function(self, event, from, to)
            print("booting game")
            -- TODO anything during boot?
            self:start()
        end,
        onstart = function(self, event, from, to)
            print("starting game")
            local l = TestLevel()
            l:load()
        end,
        onquit = function(self, event, from, to)
            print("quitting game")
        end
    }
})

function Game.addMenuOptions()
    systemMenu:addMenuItem("menu", function()
        Game.machine:quit()
    end)
end

function Game.removeMenuOptions()
    systemMenu:removeAllMenuItems()
end
