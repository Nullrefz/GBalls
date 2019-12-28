CATEGORYSLOT = {}
local mats = {Material("gballs/icons/race.png", "smooth"), Material("gballs/icons/arena.png", "smooth"), Material("gballs/icons/sandbox.png", "smooth")}
local gameTpye = {"Race", "Arena", "Sanbox"}

function CATEGORYSLOT:Init()
    self.gameType = 1
    self.mainColor = Color(54, 54, 54, 255)
    self.selectedColor = Color(0, 150, 255, 255)
    self.currentColor = self.mainColor
end

function CATEGORYSLOT:Draw()
    function self:Paint(width, height)
        draw.ChamferedBox(width / 2, height / 2, width, height, 4, self.currentColor)
    end

    self.iconHolder = vgui.Create("DPanel", self)
    self.iconHolder:Dock(FILL)
    self.iconHolder:DockMargin(1, 1, 1, 0)

    function self.iconHolder:Paint(width, height)
        draw.ChamferedBox(width / 2, height / 2, width, height, 4, Color(255, 255, 255, 255))
        draw.DrawRect(0, height * 0.9, width, height * 0.1, Color(255, 255, 255, 255))
    end

    self.icon = vgui.Create("DPanel", self.iconHolder)
    self.icon:Dock(FILL)
    local iconSize = toHRatio(128)
    self.icon:DockMargin(self:GetWide() / 2 - iconSize, self:GetTall() / 2 - iconSize - 50, self:GetWide() / 2 - iconSize, self:GetTall() / 2 - iconSize - 50)

    function self.icon:Paint(width, height)
        draw.DrawRect(0, 0, width, height, self:GetParent():GetParent().currentColor, mats[self:GetParent():GetParent().gameType])
    end

    self.title = vgui.Create("DPanel", self)
    self.title:Dock(BOTTOM)
    self.title:SetTall(toVRatio(100))
    self.title:DockMargin(1, 0, 1, 1)

    function self.title:Paint(width, height)
        draw.ChamferedBox(width / 2, height / 2, width, height, 4, self:GetParent().currentColor)
        draw.DrawText(gameTpye[self:GetParent().gameType], "Optimus64", width / 2, height / 4, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
    end

    self.button = vgui.Create("DButton", self)
    self.button:Dock(FILL)
    self.button:SetText("")
    function self.button:Paint() end
    function self.button:Think()
        if self:IsHovered() then
            self:GetParent().currentColor =  self:GetParent().selectedColor
        else
            self:GetParent().currentColor =  self:GetParent().mainColor
        end
    end
    local gameType = self.gameType
    self.button.DoClick = function()
        net.Start("SetGame")
        net.WriteInt(gameType, 16)
        net.SendToServer()
    end
end

function CATEGORYSLOT:SetGameType(type)
    self.gameType = type
    self:Draw()
end

vgui.Register("gb_categoryslot", CATEGORYSLOT)