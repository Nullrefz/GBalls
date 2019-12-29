GB.GameState = {
    RACE = 1,
    ARENA = 2,
    SANDBOX = 3,
    MENU = 4
}

currentGame = GB.GameState.MENU
util.AddNetworkString("SetGame")
util.AddNetworkString("OnGameSet")

function GB:SetGame(gameType)
    currentGame = gameType
    net.Start("OnGameSet")
    net.WriteInt(currentGame, 16)
    net.Broadcast()
    hook.Run("OnGameSet", gameType)
end

net.Receive("SetGame", function(len, ply)
    if (ply:IsListenServerHost()) then
        GB:SetGame(net.ReadInt(16))
    end
end)