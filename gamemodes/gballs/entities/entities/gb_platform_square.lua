AddCSLuaFile()
ENT.Type = 'anim'
ENT.Spawnable = true
ENT.Model = Model('models/gballs/square_1x1.mdl')
ENT.Size = Vector(1, 1, 0)
if SERVER then
    function ENT:Initialize()
        self:SetModel(self.Model)
        self:DrawShadow(true)
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetPos(Vector(0, 0, 0))
    end
end