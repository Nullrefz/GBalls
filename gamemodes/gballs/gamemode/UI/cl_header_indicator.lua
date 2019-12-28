INDICATOR = {}

function INDICATOR:Init()
    self.inidicatorSize = toVRatio(4)
end

function INDICATOR:Paint(width, height)
    if not self.color then return end
    draw.DrawRect(0, 0, width, height, self.color)
end

function INDICATOR:SetColor(color)
    if not self.color then
        self.color = color
    else
        LerpColor(self.color, color, 0.1, function(col)
            if self.color then
                self.color = col
            end
        end, INTERPOLATION.SmoothStep)
    end

    self:SetTall(self.inidicatorSize)
    self:SetWide(self.inidicatorSize)
end

vgui.Register("gb_indicator", INDICATOR)