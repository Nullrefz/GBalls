local SIDENOTIFICATION = {}
local activeNotification = {}
local totalHeight = 0

function SIDENOTIFICATION:Init()
    net.Receive("SendNotification", function()
        self:AddNotification(net.ReadFloat(), net.ReadColor(), net.ReadString(), net.ReadColor(), net.ReadInt(32))
    end)
    hook.Add("SendNotification", "SendNotification", function(time, color, text, textColor, type)
        self:AddNotification(time, color, text, textColor, type)
    end)
end

function SIDENOTIFICATION:PerformLayout(width, height)
end

function SIDENOTIFICATION:AddNotification(time, color, text, textColor, type)
    local notification = vgui.Create("gb_sidepopup", self)
    notification:SetTime(time or 3)
    notification:SetColor(color or Color(255, 255, 255))
    notification:SetText(text or "Notification")
    notification:SetTextColor(textColor or Color(255, 255, 255))

    notification:SetCallBack(function()
        table.RemoveByValue(activeNotification, notification)
        totalHeight =  #activeNotification * 45
        self:SetTall(totalHeight)
    end)

    notification:SetType(type)
    local len = notification.text:GetWide() + toHRatio(72)
    notification:SetSize(len, 42)
    table.insert(activeNotification, notification)
end

function SIDENOTIFICATION:Think()
    totalHeight = Lerp(FrameTime() * 5, totalHeight, #activeNotification * 45)
    self:SetTall(totalHeight)

    for i = 1, #activeNotification do
        if (IsValid(activeNotification[i])) then
            activeNotification[i]:SetPos(self:GetWide() - activeNotification[i]:GetWide(), (i - 1) * 45)
        end
    end
end

vgui.Register("gb_sidenotification", SIDENOTIFICATION)