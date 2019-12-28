GBSANDBOXTOOLS = {}

function GBSANDBOXTOOLS:Init()
    function self:Paint(width, height)
        draw.DrawRect(0, 0, width, height, gb.blackNotch2)
    end

    self.container = vgui.Create("gb_panellist", self)
    self.container:Dock(FILL)
    self.container:SetSpacing(toHRatio(128))
    self.container:Add(self:MakeUndoButton())
    self.container:Add(self:MakeRedoButton())
    self.container:Add(self:MakePlaceButton())
    self.container:Add(self:MakeDeleteButton())
    self.container:Add(self:MakeColorButton())

    self.indicator = vgui.Create("gb_indicator", self)
    self.indicator:Dock(BOTTOM)
    self.indicator:SetColor(gb.blackNotch1)
    self.indicator:SetTall(1)
end

function GBSANDBOXTOOLS:MakeUndoButton()
    local undoButton = vgui.Create("DButton")
    undoButton:SetText("Undo")

    return undoButton
end

function GBSANDBOXTOOLS:MakeRedoButton()
    local redoButton = vgui.Create("DButton")
    redoButton:SetText("Redo")

    return redoButton
end

function GBSANDBOXTOOLS:MakePlaceButton()
    local placeButton = vgui.Create("DButton")
    placeButton:SetText("Place")

    return placeButton
end

function GBSANDBOXTOOLS:MakeDeleteButton()
    local deleteButton = vgui.Create("DButton")
    deleteButton:SetText("Delete")

    return deleteButton
end

function GBSANDBOXTOOLS:MakeColorButton()
    local colorButton = vgui.Create("DButton")
    colorButton:SetText("Color")

    return colorButton
end

vgui.Register("gb_sandboxtools", GBSANDBOXTOOLS)