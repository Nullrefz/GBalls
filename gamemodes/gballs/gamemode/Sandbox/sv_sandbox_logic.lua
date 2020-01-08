function GB:InitSanbox()
    local spawn = ents.Create("gb_platform_square_1x1")
    if not IsValid(spawn) then return end
    spawn:Spawn()
    spawn:SetPos(Vector(0, 0, 0))

    local grid = ents.Create("gb_grid")
    if not IsValid(grid) then return end
    grid:Spawn()
    LerpFloat(500, 0, 1, function(pos)
        grid:SetPos(Vector(0, 0, pos))
    end, INTERPOLATION.SinLerp)
end

hook.Add("OnGameSet", "SetSandbox", function(gameType)
    if gameType == GB.GameState.SANDBOX then
        GB:InitSanbox()
    end
end)