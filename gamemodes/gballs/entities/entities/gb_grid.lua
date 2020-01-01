AddCSLuaFile()
ENT.Type = 'anim'
ENT.Spawnable = true

if SERVER then
    function ENT:Initialize()
        self.size = 5
        self:SetModel("models/hunter/plates/plate6x6.mdl")
        self:SetRenderMode(RENDERMODE_TRANSALPHA)
        self:DrawShadow(false)
        self:SetMaterial(Material("gballs/icons/grid.png", "smooth"))
    end

    function ENT:SetSize(size)
        self.size = size
    end
end