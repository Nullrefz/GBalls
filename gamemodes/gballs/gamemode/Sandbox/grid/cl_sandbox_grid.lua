function GB:CreateTile(sizeX, sizeY)
    self.tile = ents.CreateClientProp()
    self.tile:SetModel("models/gballs/gridtile.mdl")
    self.tile:SetPos(Vector(0, 0, 0))
    self.tile:Spawn()

    hook.Add("Think", "PlaceTile", function()
        self.tile:SetPos(self.sandboxCamera:GetMouseTrace(5000).HitPos)
        local tile = self:GetTile(self.tile)
        self:SetTile(self.tile, tile)
        self.tile:SetPos(self.tile:GetPos() + Vector(self.tileSize, self.tileSize, 0) / 2)
    end)
end

net.Receive("CreateTile", function()
    GB:CreateTile()
end)