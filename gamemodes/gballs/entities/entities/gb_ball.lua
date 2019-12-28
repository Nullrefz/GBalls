AddCSLuaFile()
ENT.Type = 'anim'
ENT.Base = 'base_nextbot'
ENT.Spawnable = true

if SERVER then
    function ENT:ChooseSpawn()
        local spawnsCT = ents.FindByClass('info_player_counterterrorist')
        local spawnsT = ents.FindByClass('info_player_terrorist')
        local spawnsR = ents.FindByClass('info_player_rebel')
        local spawnsC = ents.FindByClass('info_player_combine')
        local spawns = ents.FindByClass('info_player_start')
        table.Merge(spawnsCT, spawnsT, spawnsR, spawnsC, spawns)
        local randomSpawn = math.random(#spawns)
        local designatedSpawn = spawns[randomSpawn]

        return designatedSpawn:GetPos()
    end

    function ENT:Initialize()
        --Declaration
        self.angle = 0
        self.force = Vector(0, 0, 0)
        self.rotAngles = Vector(0, 0, 0)
        --Render Properties
        self:SetRenderMode(RENDERMODE_TRANSALPHA)
        self:SetModel('models/dav0r/hoverball.mdl')
        self:DrawShadow(true)
        --Physical properties
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetMoveCollide(MOVECOLLIDE_FLY_BOUNCE)
        self.phys = self:GetPhysicsObject()
        local radius = self:GetModelRadius()
        self:PhysicsInitSphere(radius, self.phys:GetMaterial())
        self.phys = self:GetPhysicsObject()
        self.maxSpeed = GetConVar('gb_max_speed'):GetInt()
        self.damping = GetConVar('gb_interia_dampening'):GetFloat()
        self.gravity = (GetConVar('gb_gravity'):GetInt() / 100) * self.phys:GetMass()
        self.phys:SetMass(GetConVar('gb_ball_mass'):GetInt())
        self.phys:EnableGravity(true)
        self.phys:EnableDrag(true)

        if not self.phys:IsAsleep() then
            self.phys:Wake()
        end

        self.phys:AddAngleVelocity(Vector(10, 10, 10))
        self.phys:AddVelocity(Vector(0, 0, 10))
        self:SetPos(self:ChooseSpawn() + Vector(0, 0, radius))
        self.owner = self:GetOwner()
    end

    function ENT:AddSpeed(dir, mag)
        -- Calculates Velocity
        if IsValid(self.phys) then
            self.angle = self.owner:GetInfoNum('gb_angle', 0) -- Gets the player current eye angle
            -- Disables movement if ball is not touching the ground
            self.force = self.rotAngles.x == self.phys:GetAngleVelocity().x and Vector(0, 0, 0) or dir
            self.force:Normalize() -- We normalize vectors so we can have the same length no matter what is its orientation
            self.force:Rotate(Angle(0, -self.angle, 0))
            -- Check if the new velocity is repecting the rules
            local vel = self.phys:GetVelocity()
            local newVel = vel + self.force

            if (newVel:Length2D() > self.maxSpeed) then
                self.phys:SetVelocity(self.phys:GetVelocity() * 0.9) -- Slows the ball down a notch so it doesn't cross the limit
                self.force:Mul(0) -- No more adding velocity after speed limit is reached
            else
                self.force:Mul(mag / self.phys:GetMass()) -- add the acceleration value
            end

            local acc = Vector(self.force.x, self.force.y, -self.gravity)
            local friction = vel:GetNormalized()
            friction:Mul(-1)
            friction:Mul(self.damping) -- friction
            self.phys:AddVelocity(acc) -- acceleration

            if (vel.z >= -10) then
                local limit = 0.2

                if (vel.x <= limit and vel.x >= -limit and vel.x ~= 0 and vel.y >= -limit and vel.y <= limit and vel.y ~= 0) then
                    self.phys:AddAngleVelocity(-self.phys:GetAngleVelocity())
                else
                    self.phys:AddVelocity(friction)
                end
            end

            self.rotAngles = self.phys:GetAngleVelocity()
        end
    end

    function ENT:Think()
        -- Updates
        if self.maxSpeed ~= GetConVar('gb_max_speed'):GetInt() then
            self.maxSpeed = GetConVar('gb_max_speed'):GetInt()
        end

        if self.damping ~= GetConVar('gb_interia_dampening'):GetFloat() then
            self.damping = GetConVar('gb_interia_dampening'):GetFloat()
        end

        if IsValid(self.phys) then
            if self.phys:GetMass() ~= GetConVar('gb_ball_mass'):GetInt() then
                self.phys:SetMass(GetConVar('gb_ball_mass'):GetInt())
            end

            if self.gravity ~= (GetConVar('gb_gravity'):GetInt() / 100) * self.phys:GetMass() then
                self.gravity = (GetConVar('gb_gravity'):GetInt() / 100) * self.phys:GetMass()
            end
        end
    end

    function ENT:PhysicsCollide(data, phys)
        if IsValid(self.phys) then
            if (data.Speed > GetConVar('gb_breakspeed'):GetInt() and data.HitNormal.z <= -0.9) then
                --self.phys:Sleep()
                --self:SetSolid(SOLID_NONE)
                self.phys:SetVelocity(Vector(0, 0, 0))
                --self.phys = nil
                self:Break()
            end

            if data.HitEntity:GetClass() == 'gb_ball' then
                local velocity = data.TheirOldVelocity - data.OurOldVelocity
                local dot = velocity:Dot(data.HitNormal)

                if dot > 0 then
                    local mass1 = self.phys:GetMass() or GetConVar('gb_ball_mass'):GetInt()
                    local mass2

                    if IsValid(data.HitEntity.phys) then
                        mass2 = data.HitEntity.phys:GetMass() or GetConVar('gb_ball_mass'):GetInt()
                    else
                        mass2 = 1
                    end

                    local coefficient = 0
                    local strength = (1 + coefficient) * dot * (1 / mass1 + 1 / mass2)
                    local impulse = (strength * data.HitNormal) * GetConVar('gb_hit_multiplier'):GetFloat()
                    self.phys:AddVelocity(impulse / mass1 / 2)

                    if IsValid(data.HitEntity.phys) then
                        data.HitEntity.phys:AddVelocity(-impulse / mass2 / 2)
                    end
                end
                --local vel =	(data.OurOldVelocity * (mass1 - mass2) + (2 * mass2 * data.TheirOldVelocity) / (mass1 + mass2))
                --vel:Rotate(-vel:Angle() + impulse:Angle())
                --self.phys:SetVelocity(vel)
            end
        end
    end

    function ENT:Make()
        self:SetSolid(SOLID_VPHYSICS)
        self.phys = self:GetPhysicsObject()
        self.phys:Wake()
    end

    function ENT:Break()
        self.phys:AddAngleVelocity(-self.phys:GetAngleVelocity())
        self.phys = nil
        self.owner:Kill()
    end

    function ENT:SetOwner(owner)
        self.owner = owner
    end
end