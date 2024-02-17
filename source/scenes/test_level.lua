import 'CoreLibs/object'

import './scene'
import '../lib/animated_sprite'

class('TestLevel').extends(Scene)

function TestLevel:init()
    self.meow = 'meow'
    self.sprite = AnimatedSprite({
        walkdown = AnimatedImage('/assets/images/cecilsheet', {
            delay = 100,
            sequence = { 1, 2 },
            loop = true
        }),
        walkup = AnimatedImage('/assets/images/cecilsheet', {
            delay = 100,
            sequence = { 3, 4 },
            loop = true
        }),
        walkleft = AnimatedImage('/assets/images/cecilsheet', {
            delay = 100,
            sequence = { 7, 8 },
            loop = true
        }),
        walkright = AnimatedImage('/assets/images/cecilsheet', {
            delay = 100,
            sequence = { 5, 6 },
            loop = true
        }),
    })
end

function TestLevel:load()
    print('TestLevel:load()')
    playdate.inputHandlers.push(self:inputHandler())
end

function TestLevel:inputHandler()
    return {
        downButtonDown = function()
            self.sprite:trigger_walkdown_ani()
        end,
        upButtonDown = function()
            self.sprite:trigger_walkup_ani()
        end,
        leftButtonDown = function()
            self.sprite:trigger_walkleft_ani()
        end,
        rightButtonDown = function()
            self.sprite:trigger_walkright_ani()
        end,
        AButtonDown = function()
            self.sprite:trigger_idle_ani()
        end,
    }
end
