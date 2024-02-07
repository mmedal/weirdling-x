import 'CoreLibs/object'

class('MainMenu').extends()

function MainMenu:init()
    self.meow = 'meow'
end

function MainMenu:load()
    print('MainMenu:load()')
end

function MainMenu:inputHandler()
    return {
        AButtonDown = function()
            print('AButtonDown')
        end
    }
end
