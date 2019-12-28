GameState = {
    SANDBOX = 1,
    RACE = 2,
    ARENA = 3,
    MENU = 4
}

currentGame = GameState.MENU
util.AddNetworkString("SetGame")
util.AddNetworkString("OnGameSet")

function GB:SetGame(gameType)
    currentGame = gameType
    net.Start("OnGameSet")
    net.WriteInt(currentGame, 16)
    net.Broadcast()
end

net.Receive("SetGame", function(len, ply)
    if (ply:IsListenServerHost()) then
        GB:SetGame(net.ReadInt(16))
    end
end)