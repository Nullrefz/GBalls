GB.placedProps = {}
util.AddNetworkString("PropChanged")
util.AddNetworkString("PropReceived")

function GB:UpdateProp(prop)
    if table.HasValue(self.placedProps, prop) then
        self.placedProps[table.KeyFromValue(self.placedProps, prop)] = prop
    else
        table.insert(self.placedProps, prop)
    end

    self:SendToClient()
end

function GB:DeleteProp(prop)
    if table.HasValue(self.placedProps, prop) then
        table.remove(self.placedProp, prop)
    end

    prop:Remove()
    self:SendToClient()
end

function GB:SendToClient()
    net.Start("PropChanged")
    net.WriteTable(self.placedProps)
    net.Broadcast()
end

function GB:UpdateProps(props)
    for k, v in pairs(props) do
        if table.HasValue(self.placedProps, v) then
            self.placedProps[table.KeyFromValue(self.placedProps, prop)] = v
        else
            table.insert(self.placedProps, prop)
        end
    end

    local propToRemove = {}

    for k, v in pairs(self.placedProps) do
        if not table.HasValue(props, v) then
            table.insert(propToRemove, v)
        end
    end

    for k, v in pairs(propToRemove) do
        if table.HasValue(self.placedProps, prop) then
            table.remove(self.placedProp, prop)
        end

        if IsValid(v) then
            v:Remove()
        end
    end
end

return net.Receive("PropReceived", function()
    local props = net.ReadTable()
    GB:UpdateProps(props)
end)