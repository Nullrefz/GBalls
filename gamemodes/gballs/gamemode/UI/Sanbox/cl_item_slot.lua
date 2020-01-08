ITEMSLOT = {}

function ITEMSLOT:Init()
    self.border = 4
    self.indicatorColor = gb.tabInactive
    self.randomNumber = math.random(1, 9999)
    self.selected = false

    hook.Add("SlotSelected", "DisableSlots" .. self.randomNumber, function(name)
        if not IsValid(self) then return end

        if self:GetName() == name then
            self:SetInactive()
        end
    end)

    function self:Paint(width, height)
        draw.DrawRect(0, 0, width, height, self.indicatorColor)
        draw.DrawRect(self.border / 2, self.border / 2, width - self.border, height - self.border, gb.blackNotch2)
    end

    self.button = vgui.Create("DButton", self)
    self.button:SetText("")

    function self.button:Think()
        if self:GetParent().selected then return end

        if self:IsHovered() then
            self:GetParent().indicatorColor = gb.slotHoverd
        else
            self:GetParent().indicatorColor = self:GetParent().selected and gb.slotActive or gb.slotInactive
        end
    end

    function self.button:Paint()
    end

    self.button.DoClick = function()
        hook.Run("SlotSelected", self:GetName())
        self:SetActive()

        timer.Simple(0.01, function()
            self:SetActive()
        end)
    end
end

function ITEMSLOT:PerformLayout(width, height)
    self.button:SetSize(width, height)

    if self.modelPanel then
        self.modelPanel:SetSize(width - self.border, height - self.border)
        self.modelPanel:SetPos(self.border / 2, self.border / 2)
    end

    self.button:MoveToFront()
end

function ITEMSLOT:SetContent(content)
end

function ITEMSLOT:SetActive()
    self.indicatorColor = gb.tabActive
    self.selected = true

    if self.bind then
        self.bind()
    end
end

function ITEMSLOT:SetInactive()
    self.indicatorColor = gb.tabInactive
    self.selected = false
end

function ITEMSLOT:SetBinding(instructions)
    self.bind = instructions
end

function ITEMSLOT:SetEntity(class)
    if not class or class == "" then return end
    self.modelPanel = vgui.Create("DModelPanel", self)
    local ent = ents.CreateClientside(class)
    if not IsValid(ent) then return end
    self.modelPanel:SetModel(ent.Model)
    self.modelPanel:SetLookAt(Vector(0, 0, 0))
    function self.modelPanel:LayoutEntity( Entity ) return end -- disables default rotation
    self.modelPanel:SetCamPos(Vector(0,0, -self.modelPanel:GetEntity():GetModelBounds().x * 2))
    ent:Remove()
end

vgui.Register("gb_itemslot", ITEMSLOT)