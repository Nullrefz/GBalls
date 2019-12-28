GM.Name = "GBalls"
GM.Author = "Nullrefz"
GM.Email = "davidmoussa@outlook.com"
GM.Website = "N/A"
GB = {}

team.SetUp(1, "balls", Color(255, 255, 255))

local gmDir = "gballs/gamemode"

--[[---------------------------------------------------------
    Name: jailbreak:AutoInclude()
    Desc: Includes server, client, and shared files
-----------------------------------------------------------]]

function GB:AutoInclude(dir)
    if not dir then
        dir = gmDir
    end

    local files, directories = file.Find(dir .. "/*", "LUA")

    for k, v in pairs(directories) do
        self:AutoInclude(dir .. "/" .. v)
    end

    if (dir ~= gmDir) then
        for k, v in pairs(files) do
            local path = string.gsub(dir, gmDir .. "/", "", 2) .. "/" .. v

            if string.StartWith(v, "cl_") then
                if SERVER then
                    AddCSLuaFile(path)
                elseif CLIENT then
                    include(path)
                end
            elseif string.StartWith(v, "sv_") then
                if SERVER then
                    include(path)
                end
            else
                if SERVER then
                    AddCSLuaFile(path)
                    include(path)
                elseif CLIENT then
                    include(path)
                end
            end
        end
    else
        hook.Run("JB_Initialize")
    end
end

GB:AutoInclude()