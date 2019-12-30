PANELGRID = {}

function PANELGRID:Init()
    self.spacing = 0
    self.panelList = {}
    self.itemSize = 64
    self.wide = 0
    self.container = vgui.Create("Panel", self)
    function self:Paint(width, height)
        draw.DrawRect(0, 0, width, height, gb.blackNotch2)
    end
end

function PANELGRID:PerformLayout(width, height)
    self.container:Center()
    if width ~= self.wide then
        self.wide = width
        self:Layout()
    end
end

function PANELGRID:SetItemSize(size)
    self.itemSize = size
    self:Layout()
end

function PANELGRID:Add(panel)
    table.insert(self.panelList, panel)
    panel:SetParent(self.container)
    self:Layout()
end

function PANELGRID:SetSpacing(spacing)
    self.spacing = spacing
    self:Layout()
end

function PANELGRID:Layout()
    local curPosX = self.spacing / 2
    local curPosY = self.spacing / 2
    for k, v in pairs(self.panelList) do
        v:SetSize(self.itemSize, self.itemSize)
        v:SetPos(curPosX, curPosY)

        curPosX = curPosX + self.itemSize + self.spacing
        if curPosX > self.wide - self.itemSize then
            curPosX = self.spacing / 2
            curPosY = curPosY + self.itemSize + self.spacing
        end
    end
    self.container:SizeToChildren(true, true)
end
vgui.Register("gb_panelgrid", PANELGRID)