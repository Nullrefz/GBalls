function GB:ExitSandbox()
    if (self:CheckIfPropsChanged()) then
        self:ShowConfirmationPopup("You have unsaved changes. Would \n you like to discard and go back?", "Yes", function()
            self:GoBackToMenu()
        end, "No", function() end)
    else
        self:GoBackToMenu()
    end
end

function GB:GoBackToMenu()
    net.Start("SetGame")
    net.WriteInt(4, 16)
    net.SendToServer()
end

