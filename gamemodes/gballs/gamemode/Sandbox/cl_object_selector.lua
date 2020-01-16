GB.selectedObject = nil
GB.highLightedObject = nil

local enabled = true

hook.Add("PreDrawHalos", "AddPropHalos", function()
    if IsValid(GB.selectedObject) then
        halo.Add({GB.selectedObject}, Color(0, 255, 50), 1, 1, 4)
    end
    
    if IsValid(GB.highLightedObject) and GB.highLightedObject ~= GB.selectedObject then
        halo.Add({GB.highLightedObject}, Color(255, 255, 0), 1, 1, 4)
    end
end)

hook.Add("CreateMove", "SelectObject", function(cmd)
    if (GB.UIHovered) or not enabled then return end
    
    if input.WasMousePressed(MOUSE_RIGHT) and IsValid(GB.selectedObject) then
        GB:SelectProp()
    end
    
    local ent = GB.sandboxCamera:GetHoveredEntity(ents.FindByClass("gb_grid"))
    
    if not IsValid(ent) or ent:GetClass() == "gb_grid" then
        GB.highLightedObject = nil
        
        return
    end
    
    GB.highLightedObject = ent
    
    if input.WasMousePressed(MOUSE_LEFT) and ent.Base == "gb_platform_square" then
        GB.selectedObject = ent
        GB:SelectProp(ent)
    end
end)


function GB:SelectProp(ent)
    self.selectedObject = ent
    self.highLightedObject = ent
    hook.Run("OnObjectSelected", ent)
    net.Start("ObjectHeld")
    net.WriteEntity(ent)
    net.SendToServer()
end

net.Receive("PropSelection", function()
    local prop = net.ReadEntity()
    GB:SelectProp(prop)
end)
