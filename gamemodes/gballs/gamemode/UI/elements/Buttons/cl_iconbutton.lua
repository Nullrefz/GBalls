ICONBUTTON = {}

local mats = {
    EXIT = Material("gballs/icons/exit.png", "smooth")
}

function ICONBUTTON:Init()
    self.panel = vgui.Create("DButton", self)
    self.panel:SetText("")
    self.panel.selectedColor = Color(255, 50, 50)
    self.panel.unSelectedColor = Color(255, 255, 255)
    self.panel.color = self.panel.unSelectedColor
    self.panel.hovered = false

    function self.panel:Think()
        if self:IsHovered() and not self.hovered then
            self.hovered = true

            self.color = LerpColor(self.color, self.selectedColor, 0.1, function(col)
                self.color = col
            end, INTERPOLATION.SmoothStep)
        elseif not self:IsHovered() and self.hovered then
            self.hovered = false

            self.color = LerpColor(self.color, self.unSelectedColor, 0.1, function(col)
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

vgui.Register("gb_iconbutton", ICONBUTTON)