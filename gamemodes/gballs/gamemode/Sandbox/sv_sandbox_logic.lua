function GB:InitSanbox()
    self:InitGrid()
    -- local spawn = ents.Create("gb_platform_square_1x1")
    -- if not IsValid(spawn) then return end
    -- spawn:Spawn()
    -- self:PlaceEntity(spawn, Vector(0, 0, 0), true)
end

function GB:ClearSandbox()
    self:ClearGrid()
    self:ClearProps()
end

hook.Add("OnGameSet", "SetSandbox", function(gameType)
    if gameType == GB.GameState.SANDBOX then
        GB:InitSanbox()
    else
        GB:ClearSandbox()
    end
end)