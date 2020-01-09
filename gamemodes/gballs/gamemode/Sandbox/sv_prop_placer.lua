GB.placedProps = {}
GB.heldProp = nil
util.AddNetworkString("OnPropSelected")
util.AddNetworkString("OnMoveToggled")

function GB:PlaceEntity(ent, pos, isHeld)
    ent:SetPos(pos)
    table.insert(self.placedProps, ent)

    if isHeld then
        self:ClearHeldProp()
        self.heldProp = ent
    end
end

function GB:SnapToGrid(ent)
    ent:SetPos(self:GetTile(ent:GetPos()))
end

function GB:CreateProp(propClass)
    local tempPos = self.heldProp:GetPos() or Vector(0, 0, 0)
    self:ClearHeldProp()
    self.heldProp = ents.Create(propClass)
    self.heldProp:Spawn()
    self.heldProp:SetPos(tempPos)
end

function GB:MoveProp()
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
        local arrow = ents.Create("prop_dynamic")
        arrow:SetModel("models/gballs/arrow.mdl")
        arrow:Spawn()
        arrow:SetAngles(Angle(0, i * 90, 0))
        arrow:SetPos(Vector(midPoint.x, midPoint.y, 0) + arrow:GetAngles():Forward() * midPoint * 1.1)
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