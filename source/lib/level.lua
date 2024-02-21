import 'CoreLibs/object'

class('Level').extends()

function Level:init(tilemap, tilemap_traversal, player_spawn)
    self.tilemap = tilemap
    self.tilemap_traversal = tilemap_traversal
    self.player_spawn = player_spawn
end
