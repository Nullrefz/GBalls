function GB:StartNewLevel()
    if (self:CheckIfPropsChanged()) then
        self:ShowConfirmationPopup("You have unsaved changes. Would \n you like to discard?", "Yes", function()
            self:ClearLevel()
        end, "No", function() end)
    else
        self:ClearLevel()
    end
end