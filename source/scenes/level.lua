import 'CoreLibs/object'

import './scene'

class('Level').extends(Scene)

function Level:init()
    self.meow = 'meow'
end

function Level:load()
    print('Level:load()')
end

function Level:inputHandler()
    return {
        AButtonDown = function()
            print('AButtonDown')
        end
    }
end
