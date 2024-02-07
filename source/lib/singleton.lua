import 'CoreLibs/object'

class('Singleton').extends(Object)

function Singleton:init()
    error('Cannot instantiate Singleton class')
end
