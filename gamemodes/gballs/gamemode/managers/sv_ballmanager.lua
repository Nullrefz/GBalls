util.AddNetworkString("HostJoined")

-- clean up and spawns the ball
function GB:SpawnBall(ply)
    ply:CreateBall()
end

-- player disconnects
function GB:PlayerDisconnected(ply)
    ply:DestroyBall()
end

hook.Add("PlayerDisconnected", "OnPlayerDisconnect", function(ply)
    GB:PlayerDisconnected(ply)
end)

function GB:PlayerInitialSpawn(ply)
    ply:SetTeam(1002)
    ply:KillSilent()

    if ply:IsListenServerHost() then
        net.Start("HostJoined")
        net.Send(ply)
    end
    -- hook.Add("PlayerSpawn", "HookSpawnToBall", function(pl)
    --     pl:CreateBall()
    -- end)
end

hook.Add("PlayerInitialSpawn", "InitPlayer", function(ply)
    GB:PlayerInitialSpawn(ply)
end)

function GB:PlayerDeath(ply)
    ply:DestroyBall()
end

hook.Add("PlayerDeath", "RemoveBall", function(ply)
    GB:PlayerDeath(ply)
end)

function GM:PlayerDeathThink()
    if currentGame == GameState.SANDBOX then return false end
end