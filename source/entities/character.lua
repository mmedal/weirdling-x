import 'CoreLibs/object'

import "../lib/animated_sprite"
import "../lib/machine"

class('Character').extends()

function Character.factory_create(
    character,
    level,
    position,
    animations,
    initial_state,
    state_events,
    state_callbacks
)
    character.level = level
    character.position = position
    character.speed = speed
    character.sprite = AnimatedSprite(
        character.position,
        animations,
        character
    )
    character.machine = Machine({
        initial = initial_state,
        events = state_events,
        parent = character,
        callbacks = state_callbacks
    })
end

function Character:show()
    self.sprite:show()
end

function Character:hide()
    self.sprite:hide()
end

function Character:update()
    error('Character:update() must be implemented')
end

function Character:addTraits(traits)
    for _, trait in ipairs(traits) do
        for p, property in pairs(trait.properties()) do
            self[p] = property
        end
        for m, method in pairs(trait.methods()) do
            self[m] = method
        end
        self.machine:add_events(trait.machineEvents())
        self.machine:add_callbacks(trait.machineCallbacks())
        trait.verify(self)
    end
end
