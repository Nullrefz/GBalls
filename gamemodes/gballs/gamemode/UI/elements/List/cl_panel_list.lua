PANELLIST = {}

function PANELLIST:Init()
    self.alignment = 0
    self.spacing = 0
    self.panelList = {}
    self.panel = vgui.Create("Panel", self)
    self.vertical = false
end

function PANELLIST:PerformLayout(width, height)
    if self.alignment == 0 then
        self.panel:Center()
    elseif self.alignment == 1 then
        self.panel:AlignTop()
    elseif self.alignment == 2 then
        self.panel:AlignBottom()
    elseif self.alignment == 3 then
        self.panel:AlignLeft()
    elseif self.alignment == 4 then
        self.panel:AlignRight()
    end
end

function PANELLIST:Align(num)
    self.alignment = num
end

function PANELLIST:Add(panel)
    table.insert(self.panelList, panel)
    panel:SetParent(self.panel)
    self:Layout()
end

function PANELLIST:SetSpacing(spacing)
    self.spacing = spacing
    self:Layout()
end

function PANELLIST:SetVertical()
    self.vertical = true
end

function PANELLIST:SetHorizontal()
    self.vertical = false
end

function PANELLIST:Layout()
    local totalWide = self.spacing / 2
    local totalTall = 0

    for k, v in pairs(self.panelList) do
        if self.vertical then
            v:SetPos(0, totalTall)
            totalTall = totalTall + v:GetTall() + self.spacing

            if v:GetWide() > totalWide then
                totalWide = v:GetWide()
            end
        else
            v:SetPos(totalWide, 0)
            totalWide = totalWide + v:GetWide() + self.spacing

            if v:GetTall() > totalTall then
                totalTall = v:GetTall()
            end
        end
    end

    self.panel:SetSize(totalWide, totalTall)
end

vgui.Register("gb_panellist", PANELLIST)