import 'CoreLibs/object'

class('Level').extends()

function Level:init(tilemap, tilemap_traversal, player_spawn_xy)
    self.tilemap = tilemap
    -- TODO: this method isn't working as stated in sdk docs, it only returns width
    local size = tilemap:getSize()
    -- TODO: same here
    local pixel_size = tilemap:getPixelSize()
    -- TODO: don't set these manually
    self.tile_width = 10
    self.tile_height = 5
    self.tile_pixel_width = 40
    self.tile_pixel_height = 40
    self.half_tile_pixel_width = self.tile_pixel_width / 2
    self.half_tile_pixel_height = self.tile_pixel_height / 2
    self.tilemap_traversal = tilemap_traversal
    self.player_spawn_xy = player_spawn_xy

    -- Precalculate the center pixel x, y of each tile.
    self.tile_centers = {}
    for y = 0, self.tile_height - 1 do
        local y_value = y * self.tile_pixel_height + self.half_tile_pixel_height
        for x = 0, self.tile_width - 1 do
            local x_value = x * self.tile_pixel_width + self.half_tile_pixel_width
            self.tile_centers[y * self.tile_width + x] = {
                x = x_value,
                y = y_value
            }
        end
    end
end

function Level:playerPixelSpawnPosition()
    return self:centerOfTile(self.player_spawn_xy.x, self.player_spawn_xy.y)
end

function Level:pixelXYToTileXY(x, y)
    tileXY = { x = math.floor(x / self.tile_pixel_width) + 1, y = math.floor(y / self.tile_pixel_height) + 1 }
    return tileXY
end

function Level:centerOfTile(tile_x, tile_y)
    return self.tile_centers[(tile_y - 1) * self.tile_width + (tile_x - 1)]
end

function Level:canTraverse(tile1_x, tile1_y, tile2_x, tile2_y, direction)
    return self.tilemap_traversal:canTraverse(tile1_x, tile1_y, tile2_x, tile2_y, direction)
end

function Level:pixelTraverse(position, velocity)
    local tilepos = self:pixelXYToTileXY(position.x, position.y)
    local tile_x = tilepos.x
    local tile_y = tilepos.y
    local fudgeCorner = 5
    local center = self:centerOfTile(tile_x, tile_y)
    local new_position = { x = position.x, y = position.y }
    -- Moving up
    if velocity.y < 0 then
        local speed = velocity.y
        assert(speed < self.half_tile_pixel_height, "Level:pixelTraverse: speed is too large")
        new_position.y = new_position.y + speed
        if position.x == center.x then
            if (position.y >= center.y) and (new_position.y < center.y) then
                if self:canTraverse(tile_x, tile_y, tile_x, tile_y - 1, 'up') then
                    return new_position
                else
                    return center
                end
            else
                return new_position
            end
        else
            return position
        end
        -- Moving right
    elseif velocity.x > 0 then
        local speed = velocity.x
        assert(speed < self.half_tile_pixel_width, "Level:pixelTraverse: speed is too large")
        new_position.x = new_position.x + speed
        if position.y == center.y then
            if (position.x <= center.x) and (new_position.x > center.x) then
                if self:canTraverse(tile_x, tile_y, tile_x + 1, tile_y, 'right') then
                    return new_position
                else
                    return center
                end
            else
                return new_position
            end
        else
            return position
        end
        -- Moving down
    elseif velocity.y > 0 then
        local speed = velocity.y
        assert(speed < self.half_tile_pixel_height, "Level:pixelTraverse: speed is too large")
        new_position.y = new_position.y + speed
        if position.x == center.x then
            if (position.y <= center.y) and (new_position.y > center.y) then
                if self:canTraverse(tile_x, tile_y, tile_x, tile_y + 1, 'down') then
                    return new_position
                else
                    return center
                end
            else
                return new_position
            end
        else
            return position
        end
        -- Moving left
    elseif velocity.x < 0 then
        local speed = velocity.x
        assert(speed < self.half_tile_pixel_width, "Level:pixelTraverse: speed is too large")
        new_position.x = new_position.x + speed
        if position.y == center.y then
            if (position.x >= center.x) and (new_position.x < center.x) then
                if self:canTraverse(tile_x, tile_y, tile_x - 1, tile_y, 'left') then
                    return new_position
                else
                    return center
                end
            else
                return new_position
            end
        else
            return position
        end
    end
end
