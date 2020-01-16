ICONTOGGLE = {}

local mats = {
    EXIT = Material("gballs/icons/exit.png", "smooth")
}

function ICONTOGGLE:Init()
    self.rand = math.random(0, 9999)
    self.panel = vgui.Create("DButton", self)

    self.panel.DoClick = function()
        if self.action then
            self.action()
        end
    end

    self.panel:SetText("")
    self.panel.selectedColor = Color(255, 50, 50)
    self.panel.unSelectedColor = Color(255, 255, 255)
    self.panel.color = self.panel.unSelectedColor
    self.panel.pressed = false
    self.panel.hovered = false
    self.panel.active = false
    self:SetActions(function() end, function() end)

    function self.panel:Think()
        if self:IsHovered() and not self.hovered then
            self.hovered = true

            LerpColor(self.color, self.selectedColor, 0.1, function(col)
                self.color = col
            end, INTERPOLATION.SmoothStep)
        elseif not self:IsHovered() and self.hovered then
            self.hovered = false

            LerpColor(self.color, self.active and self.selectedColor or self.unSelectedColor, 0.1, function(col)
                self.color = col
            end, INTERPOLATION.SmoothStep)
        end
    end
end

function ICONTOGGLE:PerformLayout(width, height)
    self.panel:SetSize(height, height)
    self.panel:Center()
end

function ICONTOGGLE:SetColors(selected, unselected)
    self.panel.selectedColor = selected
    self.panel.unSelectedColor = unselected
end

function ICONTOGGLE:SetMat(mat)
    function self.panel:Paint(width, height)
        draw.DrawRect(0, 0, width, height, self.color, mat)

        if (self.hovered or self.pressed) and not self.active then
            draw.DrawRect(0, 0, width, height, Color(255, 255, 255, 50), mat)
        end
    end
end

function ICONTOGGLE:SetActions(onAction, offAction)
    self.action = function(enabled)
        if enabled ~= nil then
            self.panel.active = enabled

            if onAction and enabled then
                onAction()
            elseif offAction and not enabled then
                offAction()
            end
        else
            if onAction and not self.panel.active then
                onAction()
            elseif offAction and self.panel.active then
                offAction()
            end

            self.panel.active = not self.panel.active
        end

        LerpColor(self.panel.color, self.panel.active and self.panel.selectedColor or self.panel.unSelectedColor, 0.1, function(col)
            self.panel.color = col
        end, INTERPOLATION.SmoothStep)
    end
end

function ICONTOGGLE:SetKey(key)
    hook.Add("CreateMove", "PressControls" .. self.rand, function()
        if key == 0 then return end
        if not IsValid(self) then return end

        if input.WasKeyPressed(key) then
            self.panel.pressed = true

            LerpColor(self.panel.color, self.panel.selectedColor, 0.1, function(col)
                self.color = col
            end, INTERPOLATION.SmoothStep)
        end

        if input.WasKeyReleased(key) then
            self.panel.pressed = false

            if self.action then
                self.action()
            end
        end
    end)
end

vgui.Register("gb_icontoggle", ICONTOGGLE)