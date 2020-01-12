GB.sandboxCamera = {}
CreateConVar("gb_sandboxcamera_distance", 64, FCVAR_USERINFO)
CreateConVar("gb_sandboxcamera_z", 45, FCVAR_USERINFO)
CreateConVar("gb_sandboxangle", 0, FCVAR_USERINFO)
local lastPos = Vector(0, 0, 0)
local cameraDistance = 10
local cameraAngle = 0
local cameraZ = 0
local target = Vector(0, 0, 0)
local view = {}

function GB.sandboxCamera:CalcEditModeView(ply, pos, angles, fov)
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

function GB.sandboxCamera:SetTarget(tr)
    target = tr:GetPos()
end

function GB.sandboxCamera:GetHoveredEntity()
    if not view.angles then return end
    local trace = self:GetMouseTrace(500)

    return trace.Entity
end

function GB.sandboxCamera:GetMouseTrace(distance)
    local trace = util.QuickTrace(view.origin, view.angles:Forward() + distance * gui.ScreenToVector(gui.MousePos()), LocalPlayer())
    debugoverlay.Line(trace.StartPos, trace.HitPos)

    return trace
end

hook.Add("CalcView", "EditModeView", function(ply, pos, angles, fov) return GB.sandboxCamera:CalcEditModeView(ply, pos, angles, fov) end)
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
end)

function GB:GetTopView(position)
    local topView = 0

    return topView
end