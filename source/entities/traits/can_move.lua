import 'CoreLibs/object'

import 'character_trait'
import '../../constants'

class('CanMove').extends(CharacterTrait)

function CanMove.verify(character)
    assert(type(character.sprite.trigger_movedown_ani) == 'function',
        "CanMove requires the character sprite to define a movedown animation")
    assert(type(character.sprite.trigger_moveup_ani) == 'function',
        "CanMove requires the character sprite to define a moveup animation")
    assert(type(character.sprite.trigger_moveleft_ani) == 'function',
        "CanMove requires the character sprite to define a moveleft animation")
    assert(type(character.sprite.trigger_moveright_ani) == 'function',
        "CanMove requires the character sprite to define a moveright animation")
end

function CanMove.machineEvents()
    return {
        { name = 'movedown',  from = '*', to = 'movingdown' },
        { name = 'moveup',    from = '*', to = 'movingup' },
        { name = 'moveleft',  from = '*', to = 'movingleft' },
        { name = 'moveright', from = '*', to = 'movingright' },
    }
end

function CanMove.machineCallbacks()
    return {
        onmovingdown = function(self, event, from, to)
            self.options.parent.facing = Constants.DOWN
            self.options.parent.velocity.y = self.options.parent.speed
            self.options.parent.velocity.x = 0
            self.options.parent.sprite:trigger_movedown_ani()
        end,
        onmovingup = function(self, event, from, to)
            self.options.parent.facing = Constants.UP
            self.options.parent.velocity.y = -self.options.parent.speed
            self.options.parent.velocity.x = 0
            self.options.parent.sprite:trigger_moveup_ani()
        end,
        onmovingleft = function(self, event, from, to)
            self.options.parent.facing = Constants.LEFT
            self.options.parent.velocity.y = 0
            self.options.parent.velocity.x = -self.options.parent.speed
            self.options.parent.sprite:trigger_moveleft_ani()
        end,
        onmovingright = function(self, event, from, to)
            self.options.parent.facing = Constants.RIGHT
            self.options.parent.velocity.y = 0
            self.options.parent.velocity.x = self.options.parent.speed
            self.options.parent.sprite:trigger_moveright_ani()
        end,
        onidling = function(self, event, from, to)
            self.options.parent.sprite:trigger_idle_ani()
            self.options.parent.velocity.y = 0
            self.options.parent.velocity.x = 0
        end,
    }
end

function CanMove.properties()
    return {
        velocity = { x = 0, y = 0 },
        speed = 1,
        facing = Constants.DOWN,
    }
end

function CanMove.methods()
    return {
        attemptMove = function(self, direction)
            if direction == Constants.UP then
                self.sprite:trigger_moveup_ani()
            elseif direction == Constants.DOWN then
                self.sprite:trigger_movedown_ani()
            elseif direction == Constants.LEFT then
                self.sprite:trigger_moveleft_ani()
            elseif direction == Constants.RIGHT then
                self.sprite:trigger_moveright_ani()
            end
            self.sprite.animation:setPaused(true)
            if self.level:canMove(self.position, direction) then
                if direction == Constants.UP then
                    self.machine:moveup()
                elseif direction == Constants.DOWN then
                    self.machine:movedown()
                elseif direction == Constants.LEFT then
                    self.machine:moveleft()
                elseif direction == Constants.RIGHT then
                    self.machine:moveright()
                end
            else
            end
        end,
        applyMove = function(self)
            local new_position = self.level:pixelTraverse(self.position, self.velocity)
            if new_position == self.position then
                self.machine:idle()
            end
            self.position = new_position
            self.sprite:moveTo(new_position.x, new_position.y)
        end,
    }
end
