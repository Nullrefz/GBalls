AddCSLuaFile()
ENT.Type = 'anim'
ENT.Base = "gb_platform_square"
ENT.Spawnable = true
ENT.Model = Model('models/gballs/square_5x2.mdl')
ENT.Size = Vector(5, 2, 0)
DEFINE_BASECLASS("gb_platform_square")

if SERVER then
    function ENT:Initialize()
        BaseClass.Initialize(self)
    end
end