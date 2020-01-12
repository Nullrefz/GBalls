AddCSLuaFile()
ENT.Type = 'anim'
ENT.Base = "gb_platform_square"
ENT.Spawnable = true
ENT.Model = Model('models/gballs/square_4x3.mdl')
ENT.Size = Vector(4, 3, 0)
DEFINE_BASECLASS("gb_platform_square")

if SERVER then
    function ENT:Initialize()
        BaseClass.Initialize(self)
    end
end