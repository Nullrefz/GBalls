GB.messageType = {
    MESSAGE = 1,
    WARNING = 2,
    ERROR = 3
}

function GB:DrawNotification(notify)
    self:StartNotification(notify.TIME, notify.COLOR, notify.TEXT, notify.TEXTCOLOR, notify.CALLBACK, notify.TYPE)
end

function GB:StartNotification(time, color, text, textColor, callback, type)
    local notification = vgui.Create("gb_sidepopup")
    notification:SetTime(time or 3)
    notification:SetColor(color or Color(255, 255, 255))
    notification:SetText(text or "Notification")
    notification:SetTextColor(textColor or Color(255, 255, 255))
    notification:SetCallBack(callback)
    notification:SetType(type)
    local len = notification.text:GetWide() + toHRatio(72)
    notification:SetSize(len, 32)
    notification:SetPos(w - len, h - 512)
end

local SIDEPOPUP = {}

function SIDEPOPUP:Init()
    self.panel = vgui.Create("Panel", self)
    self.panel.progress = 0
    self.panel.activeProgress = 0
    self.panel.devisions = 1
    self.panel.padding = toHRatio(10)
    self.panel.color = Color(255, 255, 255, 255)
    self.panel.typeColor = Color(255, 255, 255)
    self.panel.text = ""
    self.panel.textColor = Color(0, 0, 0)
    self.time = 3
    self.text = vgui.Create("DLabel", self.panel)
    self.text:SetFont("Optimus32")

    function self.panel:Paint(width, height)
        local wid = 0
        local widPos = width * (1 - self.progress)

        for i = 1, self.devisions do
            draw.DrawRect(widPos + wid, 0, toHRatio(8), height, self.typeColor)
            wid = wid + toHRatio(9) + toHRatio(self.padding) * self.activeProgress
        end

        draw.DrawRect(widPos + 4, 0, width, height, Color(0, 0, 0))
        draw.DrawRect(widPos + 4, 1, width, height - 2, self.color)
        self:GetParent().text:SetPos(widPos + 10, height / 4)
    end

    self:DoEntryAnimation()
end

function SIDEPOPUP:PerformLayout(width, height)
    self.panel:Dock(FILL)
    self.panel:SetWide(self.text:GetWide() / 2)
end

function SIDEPOPUP:DoEntryAnimation()
    LerpFloat(0, 1, 0.2, function(prog)
        if self:IsValid() then
            self.panel.progress = prog
        end
    end, INTERPOLATION.SinLerp, function()
        if not self:IsValid() then return end
        self:DoActiveAnimation()
    end)
end

function SIDEPOPUP:DoActiveAnimation()
    LerpFloat(0, 1, self.time * 0.8, function(activeProg)
        if not self:IsValid() then return end
        self.panel.activeProgress = activeProg
    end, INTERPOLATION.SinLerp, function()
        if not self:IsValid() then return end
        self:DoEndingAnimation()
    end)
end

function SIDEPOPUP:DoEndingAnimation()
    LerpFloat(1, 0, self.time * 0.2, function(activeProg)
        if not self:IsValid() then return end
        self.panel.activeProgress = activeProg
    end, INTERPOLATION.CosLerp, function()
        if not self:IsValid() then return end
        self:DoExitAnimation()
    end)
end

function SIDEPOPUP:DoExitAnimation()
    LerpFloat(1, 0, 0.2, function(prog)
        if not self:IsValid() then return end
        self.panel.progress = prog
    end, INTERPOLATION.CosLerp, function()
        if not self:IsValid() then return end

        if self.panel.callback then
            self.panel.callback()
        end

        self:Clear()
        self:Remove()
    end)
end

function SIDEPOPUP:SetColor(color)
    self.panel.color = color
end

function SIDEPOPUP:SetTime(time)
    self.time = time

    timer.Simple(time + 1, function()
        if not self.panel then return end
        self:Clear()
        self:Remove()
    end)
end

function SIDEPOPUP:SetType(type)
    if type == GB.messageType.MESSAGE then
        self.panel.typeColor = gb.addButton
    elseif type == GB.messageType.WARNING then
        self.panel.typeColor = Color(255, 175, 0, 255)
    elseif type == GB.messageType.ERROR then
        self.panel.typeColor = Color(255, 0, 0, 255)
    end
end

function SIDEPOPUP:SetText(text)
    self.text:SetText(text)
    self.text:SizeToContentsX(6)
end

function SIDEPOPUP:SetTextColor(color)
    self.text:SetTextColor(color)
end

function SIDEPOPUP:SetCallBack(callback)
    self.panel.callback = callback
end

vgui.Register("gb_sidepopup", SIDEPOPUP)