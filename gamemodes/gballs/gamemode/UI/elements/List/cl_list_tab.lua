LISTTAB = {}

function LISTTAB:Init()
    self.currentColor = gb.tabDiselected
    self.indicatorColor = gb.tabInactive
    self.randomNumber = math.random(1, 9999)
    self.active = false

    hook.Add("TabSelected", "DisableTab" .. self.randomNumber, function(name)
        if not IsValid(self) then return end

        if self:GetName() == name then
            self:SetInactive()
        end
    end)

    function self:Paint(width, height)
        draw.DrawRect(0, 0, width, height, self.currentColor)
    end

    self.indicator = vgui.Create("gb_indicator", self)
    self.indicator:Dock(LEFT)
    self.indicator:SetColor(self.indicatorColor)
    self.button = vgui.Create("DButton", self)
    self.button:SetText("")

    function self.button:Think()
        if self:IsHovered() then
            self:GetParent().currentColor = gb.tabSelected
        else
            self:GetParent().currentColor = gb.tabDiselected
        end
    end

    function self.button:Paint()
    end

    self.button.DoClick = function()
        hook.Run("TabSelected", self:GetName())
        self:SetActive()

        timer.Simple(0.01, function()
            self:SetActive()
        end)
    end
end

function LISTTAB:PerformLayout(width, height)
    self.button:SetSize(width, height)
end

function LISTTAB:SetCategory(category)
end

function LISTTAB:SetActive()
    if self.active then return end
    self.active = true
    self.indicatorColor = gb.tabActive
    self.indicator:SetColor(self.indicatorColor)

    if self.bind then
        self.boundPanel:Clear()
        self.bind()
    end
end

function LISTTAB:SetInactive()
    if not self.active then return end
    self.active = false
    self.indicatorColor = gb.tabInactive
    self.indicator:SetColor(self.indicatorColor)
end

function LISTTAB:SetBinding(panel, instructions)
    self.boundPanel = panel
    self.bind = instructions
end

vgui.Register("gb_listtab", LISTTAB)