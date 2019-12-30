local selectedObject
local highLightedObject

hook.Add("PreDrawHalos", "AddPropHalos", function()
    if IsValid(selectedObject) then
        halo.Add({selectedObject}, Color(0, 255, 50), 0, 0, 20)
    end

    if IsValid(highLightedObject) and highLightedObject ~= selectedObject then
        halo.Add({highLightedObject}, Color(150, 200, 255), 0, 0, 20)
    end
end)

hook.Add("CreateMove", "SelectObject", function(cmd)
    local ent = GB.sandboxCamera:GetHoveredEntity()
    if not IsValid(ent) then return end
    highLightedObject = ent

    if input.WasMousePressed(MOUSE_LEFT) then
        GB.sandboxCamera:SetTarget(ent)
        selectedObject = ent
        hook.Run("OnObjectSelected", ent)
    end
end)