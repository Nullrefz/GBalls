CreateConVar("gb_sandboxcamera_distance", 64, FCVAR_USERINFO)
CreateConVar("gb_sandboxcamera_z", 45, FCVAR_USERINFO)
CreateConVar("gb_sandboxangle", 0, FCVAR_USERINFO)
local lastPos = Vector(0, 0, 0)
local cameraDistance = 10
local cameraAngle = 0
local cameraZ = 0
local target = Vector(0, 0, 0)
local view = {}

function GB:CalcEditModeView(ply, pos, angles, fov)
    if not IsValid(view.target) then
        view.target = lastPos or Vector(0, 0, 0)
    end

    cameraAngle = Lerp(0.03, cameraAngle, -math.rad(GetConVar("gb_sandboxangle"):GetFloat()))
    cameraDistance = Lerp(0.03, cameraDistance, GetConVar("gb_sandboxcamera_distance"):GetFloat())
    cameraZ = Lerp(0.03, cameraZ, math.Clamp(math.sin(math.rad(GetConVar("gb_sandboxcamera_z"):GetFloat())), 0, 90))
    view.cameraDistance = Vector(math.cos(cameraAngle), math.sin(cameraAngle), -cameraZ) * cameraDistance
    view.target = LerpVector(0.03, view.target, target)
    view.origin = view.target - view.cameraDistance
    view.angles = (view.target - view.origin):Angle()
    view.fov = fov
    view.drawviewer = false
    lastPos = view.target

    return view
end

function GB:SetTarget(tr)
    target = tr
end

hook.Add("CalcView", "EditModeView", function(ply, pos, angles, fov) return GB:CalcEditModeView(ply, pos, angles, fov) end)

-- control the camera
function GB:SandboxCameraControls(ply, mv, cmd)
end

local middlePressed = false
local initalPos = Vector(0, 0, 0)
local lastTargetPos = Vector(0, 0, 0)
local moveDistance = Vector(0, 0, 0)

hook.Add("CreateMove", "SandboxCameraControls", function(cmd)
    if input.WasMousePressed(MOUSE_MIDDLE) and not middlePressed then
        middlePressed = true
        initalPos = Vector(gui.MouseY(), gui.MouseX(), 0)
        lastTargetPos = Vector(0, 0, 0)
    elseif input.IsMouseDown(MOUSE_MIDDLE) and middlePressed then
        moveDistance = initalPos - Vector(gui.MouseY(), gui.MouseX(), 0)
        target = target - (lastTargetPos + moveDistance) * FrameTime()
    end

    if input.WasMouseReleased(MOUSE_MIDDLE) then
        middlePressed = false
    end

    local camera = GetConVar("gb_sandboxcamera_distance")
    local zPos = GetConVar("gb_sandboxcamera_z")
    local angle = GetConVar("gb_sandboxangle")

    if input.WasMousePressed(MOUSE_WHEEL_UP) and input.IsButtonDown(KEY_LCONTROL) then
        zPos:SetInt(math.Clamp(zPos:GetInt() + 10, 0, 90))
    elseif input.WasMousePressed(MOUSE_WHEEL_DOWN) and input.IsButtonDown(KEY_LCONTROL) then
        zPos:SetInt(math.Clamp(zPos:GetInt() - 10, 0, 90))
    elseif input.WasMousePressed(MOUSE_WHEEL_UP) then
        camera:SetInt(math.Clamp(camera:GetInt() - 40, 64, 600))
    elseif input.WasMousePressed(MOUSE_WHEEL_DOWN) then
        camera:SetInt(math.Clamp(camera:GetInt() + 40, 64, 600))
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
end)

hook.Add("PreDrawHalos", "AddPropHalos", function()
    local tr = util.QuickTrace(view.origin, (view.angles:Forward() + 500 * gui.ScreenToVector(gui.MousePos())) * 1000, LocalPlayer())

    if (IsValid(tr.Entity)) then
        halo.Add({tr.Entity}, Color(0, 255, 0), 0, 0, 20)
        GB:SetTarget(tr.Entity:GetPos())
    end
end)
-- if (gui.InternalMousePressed(MOUSE_MIDDLE)) then
--     -- print(gui.MouseX() .. " " .. gui.MouseY())
--     --zPos:SetInt(math.Clamp(zPos:GetInt() + (cmd:GetMouseWheel() * 10), 0, 90))
-- else
--     --camera:SetInt(math.Clamp(camera:GetInt() - (cmd:GetMouseWheel() * 10), 64, 600))
-- end
-- if (cmd:KeyDown(IN_RELOAD)) then
--     camera:SetInt(300)
--     zPos:SetInt(90)
--     angle:SetInt(0)
-- end
-- if (cmd:KeyDown(IN_DUCK) and cmd:GetMouseX() ~= 0) then
--     if angle:GetInt() > 359 then
--         angle:SetInt(0)
--     end
--     angle:SetInt(angle:GetInt() + cmd:GetMouseX() / 20)
-- end