import 'CoreLibs/object'

import "../lib/animated_sprite"
import "../lib/machine"

class('Enemy').extends()

function Enemy.factory_create(
    enemy,
    level,
    position,
    facing,
    speed,
    animations,
    initial_state,
    state_events,
    state_callbacks
)
    enemy.level = level
    enemy.position = position
    enemy.facing = facing
    enemy.velocity = { x = 0, y = 0 }
    enemy.speed = speed
    enemy.sprite = AnimatedSprite(
        enemy.position,
        animations,
        enemy
    )
    enemy.machine = Machine({
        initial = initial_state,
        events = state_events,
        parent = enemy,
        callbacks = state_callbacks
    })
end

function Enemy:show()
    self.sprite:show()
end

function Enemy:hide()
    self.sprite:hide()
end

function Enemy:update()
    error('Enemy:update() must be implemented')
end
