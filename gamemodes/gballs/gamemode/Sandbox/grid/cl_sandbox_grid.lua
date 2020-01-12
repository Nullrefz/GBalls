function GB:CreateTile(sizeX, sizeY)
    self:RemoveTiles()
    self.tiles = {}

    for i = 1, sizeY do
        for j = 1, sizeX do
            local tile = ents.CreateClientProp()
            tile:SetModel("models/gballs/gridtile.mdl")
            tile:Spawn()
            tile:SetColor(Color(0, 255, 0, 230))
            tile:SetRenderMode(RENDERMODE_TRANSALPHA)
            table.insert(self.tiles, tile)
        end
    end

    self:SetTilePos(self.tiles, sizeX, sizeY)

    hook.Add("CreateMove", "PlaceTile", function()
        self:SetTilePos(self.tiles, sizeX, sizeY)
        if input.WasMousePressed(MOUSE_LEFT) and self:ValidatePos() then
            self:RemoveTiles()
            hook.Remove("CreateMove", "PlaceTile")
            hook.Run("ObjectPlaced")

        end
    end)
end

function GB:ValidatePos()
    return true
end

function GB:RemoveTiles()
    if self.tiles and self.tiles ~= {} then
        for k, v in pairs(self.tiles) do
            if IsValid(v) then
                v:Remove()
            end
        end
    end
end
local lastTile = Vector(0, 0, 0)

function GB:SetTilePos(tiles, sizeX, sizeY)
    local tracePos = self.sandboxCamera:GetMouseTrace(5000).HitPos
    local mousePos = self:GetTile(tracePos)
    if mousePos == lastTile then return end
    mousePos = lastTile
    local index = 1

    for i = 1, sizeY do
        for j = 1, sizeX do
            tiles[index]:SetPos(tracePos + Vector(self.tileSize * (j - 1), self.tileSize * (i - 1), 0))
            local tile = self:GetTile(tiles[index])
            self:SetTile(tiles[index], tile)
            tiles[index]:SetPos(tiles[index]:GetPos() + Vector(self.tileSize, self.tileSize, 0) / 2)
            index = index + 1
        end
    end
    net.Start("ObjectMoved")
    net.WriteVector(tiles[1]:GetPos())
    net.SendToServer()
end

net.Receive("CreateTile", function()
    local size = net.ReadVector()
    GB:CreateTile(size.x, size.y)
end)