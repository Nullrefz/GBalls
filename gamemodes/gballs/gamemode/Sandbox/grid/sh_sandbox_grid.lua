GB.tileSize = 64
GB.GridSquareSize = 128

function GB:GetTile(ent)
    local pos = ent:GetPos()
    local tile = Vector(math.floor(pos.x / self.tileSize), math.floor(pos.y / self.tileSize), 0, 0)

    return tile
end

function GB:SetTile(ent, tile)
    ent:SetPos(Vector(tile.x, tile.y, 0) * self.tileSize)
end