GB.placedProps = {}
GB.heldProp = nil
util.AddNetworkString("OnPropSelected")
util.AddNetworkString("OnMoveToggled")
util.AddNetworkString("OnMoving")
local moveDistance = 0

function GB:PlaceEntity(ent, pos, isHeld)
    ent:SetPos(pos)
    table.insert(self.placedProps, ent)

    if isHeld then
        self:ClearHeldProp()
        self.heldProp = ent
    end

    self:SnapToGrid(ent)
end

function GB:SnapToGrid(ent)
    if not IsValid(ent) then return end
    local min, max = ent:GetModelBounds()
    local midPoint = (Vector(max.x, max.y, 0) - Vector(min.x, min.y, 0)) / 2
    local tile = self:GetTile(ent:GetPos() - Vector(midPoint.x, midPoint.y, 0) / 2)
    ent:SetPos(tile * self.tileSize + Vector(midPoint.x, midPoint.y, 0))
end

function GB:CreateProp(propClass)
    local tempPos = self.heldProp:GetPos() or Vector(0, 0, 0)
    self:ClearHeldProp()
    self.heldProp = ents.Create(propClass)
    self.heldProp:Spawn()
    self.heldProp:SetPos(tempPos)
    self:SnapToGrid(self.heldProp)
end

function GB:MoveProp(x, y)
    moveDistance = moveDistance + 1 * FrameTime()
    self.heldProp:SetPos(self.heldProp:GetPos() + Vector(64, 0, 0) * moveDistance)
    self:SnapToGrid(self.heldProp)
    print(moveDistance)
end

function GB:DrawGizmo(show)
    if not self.heldProp then return end
    local min, max = self.heldProp:GetModelBounds()
    local midPoint = (max - min) / 2

    if self.arrows then
        for k, v in pairs(self.arrows) do
            if IsValid(v) then
                v:Remove()
            end
        end
    end

    if not show then return end
    self.arrows = {}

    for i = 0, 3 do
        local arrow = ents.Create("gb_gizmo")
        arrow:Spawn()
        arrow:SetModel("models/gballs/Arrow_gizmo.mdl")
        arrow:SetAngles(Angle(0, i * 90, 0))
        arrow:SetPos(self.heldProp:GetPos() + arrow:GetAngles():Forward() * midPoint * 1.2)
        table.insert(self.arrows, arrow)
    end
end

function GB:ClearProps()
    for k, v in pairs(self.placedProps) do
        if IsValid(v) then
            v:Remove()
        end
    end

    self:ClearHeldProp()
end

function GB:ClearHeldProp()
    if self.heldProp and IsValid(self.heldProp) then
        self.heldProp:Remove()
    end
end

net.Receive("OnPropSelected", function()
    GB:CreateProp(net.ReadString())
end)

net.Receive("OnMoveToggled", function()
    GB:DrawGizmo(net.ReadBool())
end)

net.Receive("OnMoving", function()
    local enabled = net.ReadBool()

    if enabled then
        moveDistance = 0

        hook.Add("Think", "MoveObject", function()
            GB:MoveProp()
        end)
    else
        hook.Remove("Think", "MoveObject")
    end
end)