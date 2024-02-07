import 'CoreLibs/object'

class('Scene').extends()

function Scene:init()
    error('Scene:init() must be overridden')
end

function Scene:load()
    error('Scene:load() must be overridden')
end

function Scene:inputHandler()
    error('Scene:inputHandler() must be overridden')
end
