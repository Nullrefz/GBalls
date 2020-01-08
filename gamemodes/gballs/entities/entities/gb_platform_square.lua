AddCSLuaFile()
ENT.Type = 'anim'
ENT.Spawnable = true

if SERVER then
    function ENT:Initialize()
        self:SetModel('models/gballs/square_2x2.mdl')
        self:DrawShadow(true)
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetPos(Vector(0, 0, 0))
        self:SnapToGrid()
    end
end

function ENT:SetGrid(grid)
    self.grid = grid
end

ENT.cellSize = 64

function ENT:SnapToGrid()
    if not self.grid then return end
    --TODO: Implement Snap to grid logic
end