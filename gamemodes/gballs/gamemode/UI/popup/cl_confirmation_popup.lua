local popup = nil

local mats = {
    Aprove = Material("gballs/icons/tick.png", "smooth"),
    Disaprove = Material("gballs/icons/exit.png", "smooth")
}

function GB:ShowConfirmationPopup(title, aproveText, aproveCallback, disaproveText, disaproveCallback)
    local popup = vgui.Create("gb_confirmationpopup")
    popup:Dock(FILL)
    popup:SetTexts(title, aproveText, disaproveText)

    popup:SetActions(function()
        aproveCallback()
        popup:Remove()
    end, function()
        disaproveCallback()
        popup:Remove()
    end)
end

CONFIRMATIONPOPUP = {}

function CONFIRMATIONPOPUP:Init()
    self:MoveToFront()
    self:MakePopup()
    self.background = vgui.Create("Panel", self)
    self.aproveText = "Yes"
    self.disaproveText = "No"

    function self.background:Paint(width, height)
        draw.DrawRect(0, 0, width, height, Color(0, 0, 0, 180))
    end

    self.panel = vgui.Create("Panel", self)

    function self.panel:Paint(width, height)
        draw.ChamferedBox(width / 2, height / 2, width, height, 24, Color(255,255,255))
    end

    self.titleText = vgui.Create("Panel", self.panel)
    self.titleText:Dock(FILL)
    self.titleText.title = ""

    function self.titleText:Paint(width, height)
        draw.DrawText(self.title, "Optimus36", width / 2, toVRatio(32), gb.blackNotch2, TEXT_ALIGN_CENTER)
    end

    self.buttonHolder = vgui.Create("Panel", self.panel)
    self.aproveButton = vgui.Create("gb_iconbutton", self.buttonHolder)
    self.aproveButton:SetColors(gb.aproveButton, gb.blackNotch2, gb.aproveButton)
    self.disaproveButton = vgui.Create("gb_iconbutton", self.buttonHolder)
    self.disaproveButton:SetColors(gb.disaproveButton, gb.blackNotch2, gb.disaproveButton)
end

function CONFIRMATIONPOPUP:PerformLayout(width, height)
    self.background:Dock(FILL)
    self.panel:SetSize(toHRatio(512), toVRatio(200))
    self.panel:Center()
    self.buttonHolder:Dock(BOTTOM)
    self.buttonHolder:DockMargin(0, 0, 0, toVRatio(16))
    self.buttonHolder:SetTall(toVRatio(40))
    self.aproveButton:Dock(LEFT)
    self.disaproveButton:Dock(RIGHT)
    self.disaproveButton:SetWide(self.buttonHolder:GetWide() / 4)
    self.aproveButton:SetWide(self.buttonHolder:GetWide() / 4)
    self.aproveButton:DockMargin(self.buttonHolder:GetWide() / 4, 0, self.buttonHolder:GetWide() / 4, 0)
    self.disaproveButton:DockMargin(self.buttonHolder:GetWide() / 4, 0, self.buttonHolder:GetWide() / 4, 0)
end

function CONFIRMATIONPOPUP:SetTexts(title, aproveText, disaproveText)
    self.titleText.title = title
    self.aproveText = aproveText
    self.aproveButton:SetMat(mats.Aprove, self.aproveText)
    self.disaproveText = disaproveText
    self.disaproveButton:SetMat(mats.Disaprove, self.disaproveText)
end

function CONFIRMATIONPOPUP:SetActions(aproveAction, disaproveAction)
    self.aproveButton:SetAction(aproveAction)
    self.disaproveButton:SetAction(disaproveAction)
end

vgui.Register("gb_confirmationpopup", CONFIRMATIONPOPUP)