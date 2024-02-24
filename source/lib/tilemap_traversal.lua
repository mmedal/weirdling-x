import 'CoreLibs/object'

class('TilemapTraversal').extends()

-- tile_bounds is a table of tables containing wall data of tiles, in
-- the order of { top, right, bottom, left }
-- i.e. {
--     { 1, 0, 0, 1 },
-- }
-- would be a tile with a wall on the top and left sides. The indexes of
-- the table should match the tiles in the tile_image_table.
function TilemapTraversal:init(tilemap, tile_bounds)
    -- assert(tilemap:getTiles()[2] == #tile_bounds,
    --     "TilemapTraversal: tilemap and tile_bounds must be the same length")
    self.tilemap = tilemap
    self.tile_bounds = tile_bounds
end

function TilemapTraversal:canTraverse(x1, y1, x2, y2, direction)
    local tile1 = self.tile_bounds[self.tilemap:getTileAtPosition(x1, y1)]
    local tile2 = self.tile_bounds[self.tilemap:getTileAtPosition(x2, y2)]

    if direction == 'up' then
        return tile1[1] == 0 and tile2[3] == 0
    elseif direction == 'right' then
        return tile1[2] == 0 and tile2[4] == 0
    elseif direction == 'down' then
        return tile1[3] == 0 and tile2[1] == 0
    elseif direction == 'left' then
        return tile1[4] == 0 and tile2[2] == 0
    else
        error("TilemapTraversal: invalid direction")
    end
end
