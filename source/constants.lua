import "CoreLibs/object"

import 'lib/singleton'

class('Constants').extends(Singleton)

function Constants.screen_width()
    return 400
end

function Constants.screen_height()
    return 240
end
