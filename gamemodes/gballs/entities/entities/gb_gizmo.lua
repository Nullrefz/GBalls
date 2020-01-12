AddCSLuaFile()
ENT.Type = 'anim'
ENT.Model = Model('models/gballs/Center_Gizmo.mdl')
if SERVER then
    function ENT:Initialize()
        self:SetModel(self.Model)
        self:DrawShadow(false)
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
    end
end