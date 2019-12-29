INSPECTOR = {}

function INSPECTOR:Init()
    function self:Paint(width, height)
    draw.DrawRect(0,0,width, height, gb.blackNotch1)
    end
end

vgui.Register("gb_inspector", INSPECTOR)