import 'CoreLibs/object'

class('TilemapTraversal').extends()

-- tile_bounds is a table of tables containing wall data of tiles, in
-- the order of { top, right, bottom, left }
-- i.e. {
--     { 1, 0, 0, 1 },
-- }
-- would be a tile with a wall on the top and left sides. The indexes of
-- the table should match the tiles in the tile_image_table.
function TilemapTraversal:init(tile_image_table, tile_bounds, tile_width, tile_height)
    self.image_table = tile_image_table
    self.tile_bounds = tile_bounds
    self.tile_width = tile_width
    self.tile_height = tile_height
end

function TilemapTraversal:canTraverse(tile1i, tile2i, direction)
    local tile1 = self.tile_bounds[tile1i]
    local tile2 = self.tile_bounds[tile2i]

    if direction == 'up' then
        return tile1[1] == 0 and tile2[3] == 0
    elseif direction == 'right' then
        return tile1[2] == 0 and tile2[4] == 0
    elseif direction == 'down' then
        return tile1[3] == 0 and tile2[1] == 0
    elseif direction == 'left' then
        return tile1[4] == 0 and tile2[2] == 0
    end
end
