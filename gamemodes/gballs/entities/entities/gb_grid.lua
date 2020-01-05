AddCSLuaFile()
ENT.Type = 'anim'
ENT.Spawnable = true

if SERVER then
    function ENT:Initialize()
        self.size = 5
        self:SetModel("models/gballs/grid.mdl")
        self:SetRenderMode(RENDERMODE_TRANSALPHA)
        self:DrawShadow(false)
        self:SetPos(Vector(0, 0, 0))
    end

    function ENT:SetSize(size)
        self.size = size
    end
end