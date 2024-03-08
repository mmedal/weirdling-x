import 'CoreLibs/object'

---@class Singleton: Object
Singleton = class('Singleton').extends(Object) or Singleton

function Singleton:init()
    error('Cannot instantiate Singleton class')
end
