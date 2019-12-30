GBSANDBOXTOOLS = {}

local mats = {
    Undo = Material("gballs/icons/undo.png", "smooth"),
    Redo = Material("gballs/icons/redo.png", "smooth"),
    Move = Material("gballs/icons/move.png", "smooth"),
    Rotate = Material("gballs/icons/rotate.png", "smooth"),
    Scale = Material("gballs/icons/scale.png", "smooth"),
    Color = Material("gballs/icons/color.png", "smooth"),
    Delete = Material("gballs/icons/delete.png", "smooth")
}

function GBSANDBOXTOOLS:Init()
    function self:Paint(width, height)
        draw.DrawRect(0, 0, width, height, gb.blackNotch2)
    end

    self.container = vgui.Create("gb_panellist", self)
    self.container:SetSpacing(toHRatio(16))
    self.container:Add(self:MakeUndoButton())
    self.container:Add(self:MakeRedoButton())
    self.container:Add(self:MakePlaceButton())
    self.container:Add(self:MakeRotateButton())
    self.container:Add(self:MakeScaleButton())
    self.container:Add(self:MakeColorButton())
    self.container:Add(self:MakeDeleteButton())
    self.indicator = vgui.Create("gb_indicator", self)
    self.indicator:Dock(BOTTOM)
    self.indicator:SetColor(gb.blackNotch1)
    self.indicator:SetTall(1)
end

function GBSANDBOXTOOLS:PerformLayout(width, height)
    self.container:Dock(FILL)
end

function GBSANDBOXTOOLS:MakeUndoButton()
    local undoButton = vgui.Create("gb_iconbutton")
    undoButton:SetMat(mats.Undo)
    undoButton:SetColors(gb.cyan, gb.white)
    undoButton:SetKey(KEY_Z)

    return undoButton
end

function GBSANDBOXTOOLS:MakeRedoButton()
    local redoButton = vgui.Create("gb_iconbutton")
    redoButton:SetMat(mats.Redo)
    redoButton:SetColors(gb.orange, gb.white)
    redoButton:SetKey(KEY_Y)

    return redoButton
end

function GBSANDBOXTOOLS:MakePlaceButton()
    local placeButton = vgui.Create("gb_iconbutton")
    placeButton:SetMat(mats.Move)
    placeButton:SetColors(gb.redwhite, gb.white)
    placeButton:SetKey(KEY_W)

    return placeButton
end

function GBSANDBOXTOOLS:MakeRotateButton()
    local rotateButton = vgui.Create("gb_iconbutton")
    rotateButton:SetMat(mats.Rotate)
    rotateButton:SetColors(gb.blue, gb.white)
    rotateButton:SetKey(KEY_E)

    return rotateButton
end

function GBSANDBOXTOOLS:MakeScaleButton()
    local scaleButton = vgui.Create("gb_iconbutton")
    scaleButton:SetMat(mats.Scale)
    scaleButton:SetColors(gb.yellow, gb.white)
    scaleButton:SetKey(KEY_R)

    return scaleButton
end

function GBSANDBOXTOOLS:MakeDeleteButton()
    local deleteButton = vgui.Create("gb_iconbutton")
    deleteButton:SetMat(mats.Delete)
    deleteButton:SetColors(gb.red, gb.white)
    deleteButton:SetKey(KEY_DELETE)

    return deleteButton
end

function GBSANDBOXTOOLS:MakeColorButton()
    local colorButton = vgui.Create("gb_iconbutton")
    colorButton:SetMat(mats.Color)
    colorButton:SetColors(gb.purple, gb.white)
    colorButton:SetKey(KEY_C)

    return colorButton
end

vgui.Register("gb_sandboxtools", GBSANDBOXTOOLS)