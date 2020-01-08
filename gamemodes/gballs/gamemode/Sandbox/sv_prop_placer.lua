GB.placedProps = {}
GB.heldProp = nil
util.AddNetworkString("OnPropSelected")

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

function GB:DrawGizmo()
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