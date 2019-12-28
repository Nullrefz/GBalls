AddCSLuaFile()
ENT.Base = "base_nextbot"
ENT.Spawnable = true

function ENT:Initialize()
	self.botBall = ents.Create("gb_ball")
	self.botBall:owner(self)
	self.botBall:Spawn()
	self.LoseDist = 1000
	self.FindDist = 500
end

--set enemy
function ENT:SetEnemy(ent)
	self.Enemy = ent
end

-- get enemy
function ENT:GetEnemy()
	return self.Enemy
end

function ENT:HaveEnemy()
	if (self:GetEnemy() and IsValid(self:GetEnemy())) then
		if (self:GetRangeTo(self:GetEnemy():GetPos()) > self.LoseDist) then
			return self:FindEnemy()
		elseif (self:GetEnemy():GetClass() == "gb_ball") then
			return self:FindEnemy()
		end

		return true
	else
		return self:FindEnemy()
	end
end

function ENT:FindEnemy()
	local _ents = ents.FindInSphere(self:GetPos(), self.FindDist)

	for k, v in ipairs(_ents) do
		if (v ~= self and v:GetClass() == "gb_ball") then
			self:SetEnemy(v)

			return true
		end
	end

	self:SetEnemy(nil)

	return false
end

function ENT:RunBehaviour()
	if self.owner:IsBot() then
		while true do
			if self:HaveEnemy() then
				self:ChaseEnemy(self:GetEnemy():GetPos())
				--local pos = self:GetEnemy():GetPos() - self:GetPos()
				--self:AddSpeed(math.Clamp(pos:Length2DSqr(), 0, GetConVar('gb_max_acceleration'):GetInt()), pos:Angle())
				coroutine.wait(0.1)
			end

			coroutine.yield()
		end
	else
		return
	end
end

function ENT:ChaseEnemy(pos, options)
	local options = options or {}
	local path = Path("Chase")
	path:SetMinLookAheadDistance(options.lookahead or 300)
	path:SetGoalTolerance(options.tolerance or 20)
	path:Compute(self, self:GetEnemy():GetPos())
	if not path:IsValid() then
		return "failed"
	end

	while (path:IsValid() and self:HaveEnemy()) do
		path:Draw()
		path:Compute(self, self:GetEnemy():GetPos())

		if (path:GetAge() > 0.1) then
			path:Compute(self, pos)
		end

		path:Update(self)

		if self.loco:IsStuck() then
			self:HandleStuck()

			return "stuck"
		end

		local pos = (path:GetCurrentGoal().pos - self:GetPos())
		self:AddSpeed(math.Clamp(pos:Length2DSqr(), 0, GetConVar("gb_max_acceleration"):GetInt()), pos:Angle())
		--self:AddSpeed(path:GetCurrentGoal().pos * 10)
		coroutine.wait(0.1)
		--coroutine.yield()
	end

	return "ok"
end
