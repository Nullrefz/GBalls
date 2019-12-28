local ply = FindMetaTable("Player")

function ply:SetBall(ball)
    self:DestroyBall()
    self.ball = ball
    self.ball:SetOwner(self)
    self.ball:Spawn()
    self:Spectate(OBS_MODE_CHASE)
    self:SpectateEntity(ball)
end

function ply:GetBall()
    return self.ball
end

function ply:CreateBall()
    local ball = ents.Create("gb_ball")
    self:SetBall(ball)
end

function ply:DestroyBall()
    if IsValid(self:GetBall()) then
        self:GetBall():Remove()
    end
end

