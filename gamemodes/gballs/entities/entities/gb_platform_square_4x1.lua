AddCSLuaFile()
ENT.Type = 'anim'
ENT.Base = "gb_platform_square"
ENT.Spawnable = true
ENT.Model = Model('models/gballs/square_4x1.mdl')
if SERVER then
    function ENT:Initialize()
        self:SetModel('models/gballs/square_4x1.mdl')
    end
end