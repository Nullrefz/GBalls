GB.grid = nil
util.AddNetworkString("CreateTile")

function GB:InitGrid()
    self.grid = ents.Create("gb_grid")
    if not IsValid(self.grid) then return end
    self.grid:Spawn()

    LerpFloat(500, -.1, 1, function(pos)
        self.grid:SetPos(Vector(0, 0, pos))
    end, INTERPOLATION.SinLerp)

    net.Start("CreateTile")
    net.Broadcast()
end

function GB:ClearGrid()
    if not self.grid then return end
    self.grid:Remove()
end