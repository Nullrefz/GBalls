GB.selectedObject = nil
GB.highLightedObject = nil
local gizmoSelected = false

hook.Add("PreDrawHalos", "AddPropHalos", function()
    if IsValid(GB.selectedObject) then
        halo.Add({GB.selectedObject}, Color(0, 255, 50), 0, 0, 1)
    end

    if IsValid(GB.highLightedObject) and GB.highLightedObject ~= GB.selectedObject then
        halo.Add({GB.highLightedObject}, Color(150, 200, 255), 0, 0, 1)
    end
end)

hook.Add("CreateMove", "SelectObject", function(cmd)
    if input.WasMouseReleased(MOUSE_LEFT) then
        if gizmoSelected then
            gizmoSelected = false
            net.Start("OnMoving")
            net.WriteBool(gizmoSelected)
            net.SendToServer()
        else
        end
    end

    local ent = GB.sandboxCamera:GetHoveredEntity(ents.FindByClass("gb_grid"))
    if not IsValid(ent) or ent:GetClass() == "gb_grid" then return end
    GB.highLightedObject = ent

    if input.WasMousePressed(MOUSE_LEFT) then
        if ent.Base == "gb_platform_square" then
            GB.selectedObject = ent
            hook.Run("OnObjectSelected", ent)
        elseif ent:GetClass("gb_gizmo") and not gizmoSelected then
            gizmoSelected = true
            net.Start("OnMoving")
            net.WriteBool(gizmoSelected)
            net.SendToServer()
        end
    end
end)