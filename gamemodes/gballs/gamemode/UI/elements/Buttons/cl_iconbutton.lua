ICONBUTTON = {}

local mats = {
    EXIT = Material("gballs/icons/exit.png", "smooth")
}

function ICONBUTTON:Init()
    self.rand = math.random(0, 9999)
    self.panel = vgui.Create("DButton", self)
    self.panel:SetText("")
    self.panel.selectedColor = Color(255, 50, 50)
    self.panel.unSelectedColor = Color(255, 255, 255)
    self.panel.color = self.panel.unSelectedColor
    self.panel.hovered = false
    self.panel.isToggle = false

    function self.panel:Think()
        if self:IsHovered() and not self.hovered then
            self.hovered = true

            LerpColor(self.color, self.selectedColor, 0.1, function(col)
                self.color = col
            end, INTERPOLATION.SmoothStep)
        elseif not self:IsHovered() and self.hovered then
            self.hovered = false

            LerpColor(self.color, self.unSelectedColor, 0.1, function(col)
                self.color = col
            end, INTERPOLATION.SmoothStep)
        end
    end
end

function ICONBUTTON:PerformLayout(width, height)
    self.panel:SetSize(height, height)
    self.panel:Center()
end

function ICONBUTTON:SetColors(selected, unselected)
    self.panel.selectedColor = selected
    self.panel.unSelectedColor = unselected
end

function ICONBUTTON:SetMat(mat)
    function self.panel:Paint(width, height)
        draw.DrawRect(0, 0, width, height, self.color, mat)
    end
end

function ICONBUTTON:SetAction(action)
    self.panel.DoClick = action
end

function ICONBUTTON:SetToggle(enabled)
    self.panel.isToggle = enabled
end

function ICONBUTTON:SetKey(key)
    hook.Add("CreateMove", "PressControls" .. self.rand, function()
        if key == 0 then return end

        if input.WasKeyPressed(key) then
            LerpColor(self.panel.color, self.panel.selectedColor, 0.1, function(col)
                self.panel.color = col
            end, INTERPOLATION.SmoothStep)
        end

        if input.WasKeyReleased(key) then
            LerpColor(self.panel.color, self.panel.unSelectedColor, 0.1, function(col)
                self.panel.color = col
            end, INTERPOLATION.SmoothStep)

            if self.panel.DoClick then
                self.panel:DoClick()
            end
        end
    end)
end

vgui.Register("gb_iconbutton", ICONBUTTON)