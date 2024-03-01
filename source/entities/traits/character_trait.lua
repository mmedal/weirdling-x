import 'CoreLibs/object'

class('CharacterTrait').extends()

function CharacterTrait.verify(character)
    error('CharacterTrait.verify() must be implemented')
end

function CharacterTrait.machineEvents()
    error('CharacterTrait.machineEvents() must be implemented')
end

function CharacterTrait.machineCallbacks()
    error('CharacterTrait.machineCallbacks() must be implemented')
end

function CharacterTrait.properties()
    error('CharacterTrait.properties() must be implemented')
end

function CharacterTrait.methods()
    error('CharacterTrait.methods() must be implemented')
end
