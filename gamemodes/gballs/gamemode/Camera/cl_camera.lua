CreateConVar("gb_camera_distance", 64, FCVAR_USERINFO)
CreateConVar("gb_camera_z", 30, FCVAR_USERINFO)
CreateConVar("gb_angle", 45, FCVAR_USERINFO)

local FollowMode = {
    SINGLE = 1,
    COLLECTIVE = 2
}

local currentMode = FollowMode.COLLECTIVE
local ballList = {}
local lastPos = Vector(0, 0, 0)
local playerBall
local cameraDistance = 0
local cameraAngle = 0
local cameraZ = 0

local function ViewThink(ply, pos, angles, fov)
    RefreshballList()
    view = {}

    if not IsValid(view.target) then
        view.target = lastPos or Vector(0, 0, 0)
    end

    if #ballList == 0 then
        view.target = Vector(0, 0, 0)
    end

    cameraAngle = Lerp(0.03, cameraAngle, -math.rad(GetConVar("gb_angle"):GetFloat()))
    cameraDistance = Lerp(0.03, cameraDistance, GetConVar("gb_camera_distance"):GetFloat())
    cameraZ = Lerp(0.03, cameraZ, math.Clamp(math.sin(math.rad(GetConVar("gb_camera_z"):GetFloat())), 0, 90))
    view.cameraDistance = Vector(math.cos(cameraAngle), math.sin(cameraAngle), -cameraZ) * cameraDistance
    local ang

    if currentMode == FollowMode.SINGLE then
        ang = GetPlayerPos() - view.target
    elseif currentMode == FollowMode.COLLECTIVE then
        ang = GetAveragePos() - view.target
    end

    view.target = view.target + Vector(ang.x * FrameTime() * 3, ang.y * FrameTime() * 3, ang.z)
    view.origin = view.target - view.cameraDistance
    view.angles = (view.target - view.origin):Angle()
    view.fov = fov
    view.drawviewer = false
    lastPos = view.target

    return view
end

function RefreshballList()
    ballList = ents.FindByClass("gb_ball")
end

function GetAveragePos()
    local pos = Vector(0, 0, 0)
    if #ballList == 0 then return Vector(0, 0, 0) end
    local highest = ballList[1]:GetPos().z

    for k, v in pairs(ballList) do
        if IsValid(v) then
            if v:GetPos().z > highest then
                highest = v:GetPos().z
            end

            pos = pos + Vector(v:GetPos().x, v:GetPos().y, highest)
        else
            handlePos()
        end
    end

    return pos / #ballList
end

function GetPlayerPos()
    if not playerBall or not IsValid(playerBall) then
        for k, v in pairs(ents.FindByClass("gb_ball")) do
            if v.owner == LocalPlayer() then
                playerBall = v

                return playerBall:GetPos()
            end
        end
    elseif playerBall then
        return playerBall:GetPos()
    end

    return lastPos
end

hook.Add("CalcView", "TopView", ViewThink)

-- control the camera
function cameraControl(ply, mv, cmd)
    local camera = GetConVar("gb_camera_distance")
    local zPos = GetConVar("gb_camera_z")
    local angle = GetConVar("gb_angle")

    if (cmd:KeyDown(IN_ATTACK)) then
        zPos:SetInt(math.Clamp(zPos:GetInt() + (cmd:GetMouseWheel() * 10), 0, 90))
    else
        camera:SetInt(math.Clamp(camera:GetInt() - (cmd:GetMouseWheel() * 10), 64, 600))
    end

    if (cmd:KeyDown(IN_RELOAD)) then
        camera:SetInt(300)
        zPos:SetInt(90)
        angle:SetInt(0)
    end

    if (cmd:KeyDown(IN_DUCK) and cmd:GetMouseX() ~= 0) then
        if angle:GetInt() > 359 then
            angle:SetInt(0)
        end

        angle:SetInt(angle:GetInt() + cmd:GetMouseX() / 20)
    end
end

hook.Add("SetupMove", "camera controls", cameraControl)