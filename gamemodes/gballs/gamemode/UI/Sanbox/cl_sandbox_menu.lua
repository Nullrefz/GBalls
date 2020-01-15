SANDBOXMENU = {}
function SANDBOXMENU:Init()
    function self:Paint(width, height)
        draw.DrawRect(0, 0, width, height, gb.blackNotch2)
    end

    self.headerIndicator = vgui.Create("gb_indicator", self)
    self.headerIndicator:Dock(TOP)
    self.headerIndicator:SetColor(gb.sandboxColor)
    self.grid = vgui.Create("Panel", self)
    self.grid:Dock(FILL)
    self.categoryList = vgui.Create("gb_panellist", self)
    self.categoryList:Dock(LEFT)
    self.categoryList:SetSpacing(2)
    self.categoryList:SetVertical()
    self.categoryList:SetWide(toHRatio(256))
    self.categoryList:Align(1)

    function self.categoryList:Paint(width, height)
        draw.DrawRect(0, 0, width, height, gb.blackNotch1)
    end

    for k, v in pairs(GB.platformType) do
        local tab = vgui.Create("gb_listtab", nil, "sandboxCatergory")

        tab:SetBinding(self.grid, function()
            local grid = vgui.Create("gb_panelgrid", self.grid)
            grid:Dock(FILL)
            grid:SetItemSize(72)
            grid:SetSpacing(2)

            for i = 1, #GB.platforms[v] do
                local slot = vgui.Create("gb_itemslot")
                slot:SetEntity(GB.platforms[v][i])

                slot:SetBinding(function()
                    net.Start("OnPropSelected")
                    net.WriteString(GB.platforms[v][i])
                    net.SendToServer()
                    hook.Add("ObjectPlaced", "Deselect", function()
                        slot:SetInactive()
                    end)
                end)

                grid:Add(slot, "SandboxSlots")
            end
        end)

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
    self.inspector = vgui.Create("gb_inspector", self)
    self.inspector:Dock(RIGHT)
    self.inspector:SetWide(toHRatio(300))
    self.tools = vgui.Create("gb_sandboxtools", self)
    self.tools:Dock(TOP)
    self.tools:SetTall(toVRatio(62))
end
function SANDBOXMENU:Think()
    GB.UIHovered = self:IsChildHovered()
end

vgui.Register("gb_sandboxmenu", SANDBOXMENU)