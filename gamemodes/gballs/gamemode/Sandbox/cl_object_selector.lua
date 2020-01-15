GB.selectedObject = nil
GB.highLightedObject = nil
local gizmoSelected = false

hook.Add("PreDrawHalos", "AddPropHalos", function()
    if IsValid(GB.selectedObject) then
        halo.Add({GB.selectedObject}, Color(0, 255, 50), 1, 1, 4)
    end

    if IsValid(GB.highLightedObject) and GB.highLightedObject ~= GB.selectedObject then
        halo.Add({GB.highLightedObject}, Color(255, 255, 0), 1, 1, 4)
    end
end)

hook.Add("CreateMove", "SelectObject", function(cmd)
    if (GB.UIHovered) then return end

    if input.WasMousePressed(MOUSE_RIGHT) and IsValid(GB.selectedObject) then
        GB.selectedObject = nil
        GB.highLightedObject = nil
    end

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
    print(ent)

    if not IsValid(ent) or ent:GetClass() == "gb_grid" then
        GB.highLightedObject = nil

        return
    end

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