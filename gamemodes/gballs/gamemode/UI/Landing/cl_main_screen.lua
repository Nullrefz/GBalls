MAINSCREEN = {}

local mats = {
    Exit = Material("gballs/icons/exit.png", "smooth"),
    Back = Material("gballs/icons/back.png", "smooth"),
    Circle = Material("gballs/icons/circle.png", "smooth")
}

function MAINSCREEN:Init()
    net.Receive("OnGameSet", function()
        self.headerBody:Clear()
        self.body:Clear()
        local response = net.ReadInt(16)

        if response == 1 then
            self:SetRace()
        elseif response == 2 then
            self:SetArena()
        elseif response == 3 then
            self:SetSandbox()
        elseif response == 4 then
            self:SetMainMenu()
        end
    end)

    self:MakePopup()

    function self:Paint(width, height)
        draw.DrawRect(0, 0, width, height, Color(54, 54, 54, 50))
    end

    self.header = vgui.Create("DPanel", self)
    self.header:Dock(TOP)
    self.header:SetTall(toVRatio(72))

    function self.header:Paint(width, height)
        draw.DrawRect(0, 0, width, height, Color(54, 54, 54, 255))
    end

    self.headerIndicator = vgui.Create("gb_indicator", self.header)
    self.headerIndicator:Dock(BOTTOM)
    self.headerBody = vgui.Create("Panel", self.header)
    self.headerBody:Dock(FILL)
    self.body = vgui.Create("Panel", self)
    self.body:Dock(FILL)
    self:SetMainMenu()
end

function MAINSCREEN:SetMainMenu()
    self.headerIndicator:SetColor(gb.menuColor)
    self.exitButton = vgui.Create("gb_iconbutton", self.headerBody)
    self.exitButton:SetMat(mats.Exit)
    self.exitButton:SetColors(Color(255, 50, 50), Color(255, 255, 255))
    self.exitButton:Dock(RIGHT)

    function self.PerformLayout(width, height)
        self.exitButton:SetWide(self.exitButton:GetTall())
    end

    self.exitButton:DockMargin(10, 10, 10, 10)

    self.exitButton:SetAction(function()
        RunConsoleCommand("reload")
    end)

    self.categoryList = vgui.Create("gb_panellist", self.body)
    self.categoryList:Dock(FILL)
    self.categoryList:SetSpacing(toHRatio(64))

    for i = 1, 3 do
        local category = vgui.Create("gb_categoryslot")
        category:SetSize(toHRatio(420), toHRatio(420))
        category:SetGameType(i)
        self.categoryList:Add(category)
    end
end

function MAINSCREEN:SetRace()
end

function MAINSCREEN:SetArena()
end

function MAINSCREEN:SetSandbox()
    self.headerIndicator:SetColor(gb.sandboxColor)
    self.createButton = vgui.Create("gb_iconbutton", self.headerBody)
    self.createButton:SetMat(mats.Circle)

    self.createButton:SetAction(function()
        self:Remove()
        GB.sandboxMenu:Show()
    end)

    self.createButton:Dock(LEFT)
    self.createButton:DockMargin(10, 10, 10, 10)
    self.loadButton = vgui.Create("gb_iconbutton", self.headerBody)
    self.loadButton:SetMat(mats.Circle)

    self.loadButton:SetAction(function()
        self:Remove()
        GB.sandboxMenu:Show()
    end)

    self.loadButton:Dock(LEFT)
    self.loadButton:DockMargin(10, 10, 10, 10)
    self.saveButton = vgui.Create("gb_iconbutton", self.headerBody)
    self.saveButton:SetMat(mats.Circle)

    self.saveButton:SetAction(function()
        self:Remove()
        GB.sandboxMenu:Show()
    end)

    self.saveButton:Dock(LEFT)
    self.saveButton:DockMargin(10, 10, 10, 10)
    self.backButton = vgui.Create("gb_iconbutton", self.headerBody)
    self.backButton:SetMat(mats.Back)
    self.backButton:SetKey(KEY_ESCAPE)
    self.backButton:SetColors(gb.red, gb.white)

    self.backButton:SetAction(function()
        net.Start("SetGame")
        net.WriteInt(4, 16)
        net.SendToServer()
    end)

    self.backButton:Dock(RIGHT)
    self.backButton:DockMargin(10, 10, 10, 10)
    self.editMode = vgui.Create("gb_iconbutton", self.headerBody)
    self.editMode:SetMat(mats.Circle)

    self.editMode:SetAction(function()
        self:Remove()
        GB.sandboxMenu:Show()
    end)

    self.editMode:Dock(RIGHT)
    self.editMode:DockMargin(10, 10, 10, 10)
    self.editMenu = vgui.Create("gb_sandboxmenu", self.body)
    self.editMenu:Dock(BOTTOM)
    self.editMenu:SetTall(256)
end

vgui.Register("gb_mainscreen", MAINSCREEN)
GB.landing = {}

function GB.landing:Show()
    self.landingPanel = vgui.Create("gb_mainscreen")
    self.landingPanel:SetSize(w, h)
    self.landingPanel:SetPos(0, 0)

    GB.landing.hide = function()
        if not self.landingPanel and self.landingPanel:IsValid() then return end
        self.landingPanel:Clear()
        self.landingPanel:Remove()
    end
end

net.Receive("HostJoined", function()
    GB.landing:Show()
end)