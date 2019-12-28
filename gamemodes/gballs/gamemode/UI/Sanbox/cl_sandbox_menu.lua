SANDBOXMENU = {}

local Categories = {
    Spawn = 1,
    BasicSquare = 2,
    BasicCircle = 3,
    Goal = 4
}

function SANDBOXMENU:Init()
    function self:Paint(width, height)
        draw.DrawRect(0, 0, width, height, gb.blackNotch2)
    end

    self.headerIndicator = vgui.Create("gb_indicator", self)
    self.headerIndicator:Dock(TOP)
    self.headerIndicator:SetColor(gb.sandboxColor)
    self.categoryList = vgui.Create("gb_panellist", self)
    self.categoryList:Dock(LEFT)
    self.categoryList:SetSpacing(2)
    self.categoryList:SetVertical()
    self.categoryList:SetWide(toHRatio(256))
    self.categoryList:Align(1)

    function self.categoryList:Paint(width, height)
        draw.DrawRect(0, 0, width, height, gb.blackNotch1)
    end

    for k, v in pairs(Categories) do
        local tab = vgui.Create("gb_listtab", nil, "sandboxCatergory")

        if v == 3 then
            tab:SetActive()
        end

        tab:SetSize(toHRatio(256), toVRatio(61))
        self.categoryList:Add(tab)
    end

    self.categoryListIndicator = vgui.Create("gb_indicator", self)
    self.categoryListIndicator:Dock(LEFT)
    self.categoryListIndicator:SetColor(gb.blackNotch0)
    self.categoryListIndicator:SetWide(2)
    self.tools = vgui.Create("gb_sandboxtools", self)
    self.tools:Dock(TOP)
    self.tools:SetTall(toVRatio(64))
end

vgui.Register("gb_sandboxmenu", SANDBOXMENU)