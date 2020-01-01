
function GB:InitSanbox()
    -- local spawn = ents.Create("prop_physics")
    -- if not IsValid(spawn) then return end
    -- spawn:SetModel("models/gballs/square_4x4.mdl")
    -- spawn:SetPos(Vector(0, 0, 0))
    -- spawn:Spawn()
end

hook.Add("OnGameSet", "SetSandbox", function(gameType)
    if gameType == GB.GameState.SANDBOX then
        GB:InitSanbox()
    end
end)