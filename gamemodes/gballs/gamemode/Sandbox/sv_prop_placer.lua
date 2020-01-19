GB.heldProp = nil
util.AddNetworkString("OnPropSelected")
util.AddNetworkString("PropSelection")
util.AddNetworkString("OnMoveToggled")
util.AddNetworkString("OnMoving")
util.AddNetworkString("ObjectMoved")
util.AddNetworkString("ObjectPlaced")
util.AddNetworkString("ObjectHeld")
GB.currentGizmo = GB.GizmoMode.None

function GB:PlaceEntity(ent, pos, isHeld)
    ent:SetPos(pos)

    if isHeld then
        self:ClearHeldProp()
        self.heldProp = ent
    end

    self:SnapToGrid(ent)
end

function GB:SnapToGrid(ent)
    if not IsValid(ent) then return end
    local tile = self:GetTile(ent)
    self:SetTile(ent, tile)
    self:PositionGizmos()
end

function GB:CreateProp(propClass)
    local tempPos = IsValid(self.heldProp) and self.heldProp:GetPos() or Vector(0, 0, 0)
    self:ClearHeldProp()
    self.heldProp = ents.Create(propClass)
    self.heldProp:Spawn()
    self.heldProp:SetPos(tempPos)
    self:SnapToGrid(self.heldProp)
    self:SelectProp(self.heldProp)
end

function GB:SelectProp(prop)
    net.Start("PropSelection", true)
    net.WriteEntity(prop)
    net.Broadcast()
end

function GB:TranslateProp(ent)
    if not IsValid(ent) then return end
    self.heldProp = ent
    self:CreateTile(ent)
end

function GB:CreateTile(ent)
    net.Start("CreateTile")
    net.WriteVector(self.heldProp.Size)
    net.WriteEntity(ent)
    net.Broadcast()
end

function GB:MoveProp(pos)
    if not IsValid(self.heldProp) then return end
    self.heldProp:SetColor(Color(255, 255, 255, 50))
    self.heldProp:SetRenderMode(RENDERMODE_TRANSALPHA)
    self.heldProp:SetPos(pos - Vector(self.tileSize, self.tileSize, 0) / 2)
end

function GB:PlaceProp(placed)
    if not self.heldProp then return end
    self.heldProp:SetColor(Color(255, 255, 255, 255))

    if placed then
        self:UpdateProp(self.heldProp)
    else
        self:DeleteProp(self.heldProp)
    end

    self:SelectProp()
end

function GB:DrawGizmo(show)
    if not self.heldProp then return end

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
        table.insert(self.arrows, arrow)
    end

    self:PositionGizmos()
end

function GB:PositionGizmos()
    if not self.arrows or self.arrows == {} then return end
    local min, max = self.heldProp:GetModelBounds()
    local midPoint = (Vector(max.x, max.y, 0) - Vector(min.x, min.y, 0)) / 2

    for i = 1, 4 do
        self.arrows[i]:SetAngles(Angle(0, (i - 1) * 90, 0))
        self.arrows[i]:SetPos(self.heldProp:GetPos() + midPoint + self.arrows[i]:GetAngles():Forward() * midPoint * 1.2)
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

    self.heldProp = nil
end

net.Receive("OnPropSelected", function()
    GB:CreateProp(net.ReadString())
end)

net.Receive("OnMoveToggled", function()
    local enabled = net.ReadBool()
    GB.currentGizmo = enabled and GB.GizmoMode.Translate or GB.GizmoMode.None

    if enabled then
        GB:TranslateProp(GB.heldProp)
    end
end)

net.Receive("ObjectMoved", function()
    GB:MoveProp(net.ReadVector())
end)

net.Receive("ObjectPlaced", function()
    local placed = net.ReadBool()
    GB:PlaceProp(placed)
end)

net.Receive("ObjectHeld", function()
    GB.heldProp = net.ReadEntity()

    if GB.currentGizmo == GB.GizmoMode.Translate then
        GB:TranslateProp(GB.heldProp)
    end

    hook.Run("OnObjectSelected", GB.heldProp)
end)