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
    self.panel.clicked = false
    function self.panel:Think()
        if self:IsHovered() and not self.hovered then
            self.hovered = true

            LerpColor(self.color, self.selectedColor, 0.1, function(col)
                if not IsValid(self) then return end
                self.color = col
            end, INTERPOLATION.SmoothStep)
        elseif not self:IsHovered() and self.hovered then
            self.hovered = false

            LerpColor(self.color, self.unSelectedColor, 0.1, function(col)
                if not IsValid(self) then return end
                self.color = col
            end, INTERPOLATION.SmoothStep)
        end
    end
end

function ICONBUTTON:PerformLayout(width, height)
    self.panel:SetSize(width, height)
    self.panel:Center()
end

function ICONBUTTON:SetColors(selected, unselected)
    self.panel.selectedColor = selected
    self.panel.unSelectedColor = unselected
end

function ICONBUTTON:SetMat(mat, text)
    function self.panel:Paint(width, height)
        draw.ChamferedBox(width / 2, height / 2, width, height, 2, self.unSelectedColor)

        if self.hovered and not self.clicked then
            draw.ChamferedBox(width / 2, height / 2, width, height, 360, self.color)
            draw.ChamferedBox(height / 2, height / 2, height - 8, height - 8, 360, Color(255, 255, 255))
            draw.DrawRect(8, 8, height - 16, height - 16, self.color, mat)
        else
            draw.DrawRect(8, 8, height - 16, height - 16, Color(255, 255, 255), mat)
        end

        draw.DrawText(text or "Text?", "Optimus22", width / 2 + 8, height / 5, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
    end
end

function ICONBUTTON:SetAction(action)
    self.panel.DoClick = action
end

function ICONBUTTON:SetKey(key)
    hook.Add("CreateMove", "PressControls" .. self.rand, function()
        if key == 0 then return end
        if not IsValid(self) then return end

        if input.WasKeyPressed(key) then
            if not IsValid(self) then return end

            LerpColor(self.panel.color, self.panel.selectedColor, 0.1, function(col)
                if not IsValid(self) then return end
                self.panel.color = col
            end, INTERPOLATION.SmoothStep)
        end

        if input.WasKeyReleased(key) then
            if not IsValid(self) then return end

            LerpColor(self.panel.color, self.panel.unSelectedColor, 0.1, function(col)
                if not IsValid(self) then return end
                self.panel.color = col
            end, INTERPOLATION.SmoothStep)

            if self.panel.DoClick then
                self.panel:DoClick()
            end
        end

        if input.WasMousePressed(MOUSE_LEFT) then
            self.panel.clicked = true
        elseif input.WasMouseReleased(MOUSE_LEFT) then
            self.panel.clicked = false
        end
    end)
end

vgui.Register("gb_iconbuttonwide", ICONBUTTON)