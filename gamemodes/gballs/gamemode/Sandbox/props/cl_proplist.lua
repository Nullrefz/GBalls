GB.propList = {}
GB.savedProps = {}

function GB:CheckIfPropsChanged()
    if #self.propList ~= #self.savedProps then
        return true
    else
        for k, v in pairs(self.propList) do
            if v ~= self.savedProps[k] then return true end
        end
    end

    return false
end

function GB:ClearLevel()
    self.propList = {}
    self:UpdatePropsOnServer()
end

function GB:UpdatePropsOnServer()
    net.Start("PropReceived")
    net.WriteTable(self.propList)
    net.SendToServer()
end

function GB:ReceiveFromServer(props)
    self.propList = props
end

net.Receive("PropChanged", function()
    local props = net.ReadTable()
    GB:ReceiveFromServer(props)
end)