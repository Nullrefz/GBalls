GB.grid = nil
GB.tileSize = 64
GB.GridSquareSize = 128

function GB:InitGrid()
    self.grid = ents.Create("gb_grid")
    if not IsValid(self.grid) then return end
    self.grid:Spawn()

    LerpFloat(500, 0, 1, function(pos)
        self.grid:SetPos(Vector(0, 0, pos))
    end, INTERPOLATION.SinLerp)
end

function GB:ClearGrid()
    if not self.grid then return end
    self.grid:Remove()
end

function GB:GetTile(pos)
    local tile = Vector(math.floor(pos.x / self.tileSize), math.floor(pos.y / self.tileSize), 0) * self.tileSize + Vector(self.tileSize / 2, self.tileSize / 2, 0)
    return tile
end

