AddCSLuaFile()
ENT.Type = 'anim'
ENT.Spawnable = true

if SERVER then
    function ENT:Initialize()
        self:SetModel("models/gballs/grid.mdl")
        self:SetRenderMode(RENDERMODE_TRANSALPHA)
        self:DrawShadow(false)
        self:SetPos(Vector(0, 0, 0))
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
    end
end