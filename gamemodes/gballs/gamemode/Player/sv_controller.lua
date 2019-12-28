function ApplyControl(ply, mv, cmd)
    if (IsValid(ply:GetBall())) then
        local ball = ply:GetBall()
        local maxAcceleration = GetConVar("gb_max_acceleration"):GetInt()

        if (cmd:GetMouseY() ~= 0 or cmd:GetMouseX() ~= 0 and not cmd:KeyDown(IN_DUCK)) then
            local temp = Vector(-cmd:GetMouseX(), cmd:GetMouseY(), 0)
            local magnitude = math.Clamp(temp:Length2D(), 0, maxAcceleration)
            temp:Rotate(Angle(0, 90, 0))
            ball:AddSpeed(temp, magnitude)

            return
        end

        if (not ply:IsBot() or (GetConVar("bot_mimic"):GetInt() > 0 and ply:IsBot())) then
            ply:SetObserverMode(OBS_MODE_CHASE)
            local temp = Vector(0, 0, 0)

            if (cmd:KeyDown(IN_FORWARD)) then
                temp:Add(Vector(maxAcceleration, 0, 0))
            end

            if (cmd:KeyDown(IN_BACK)) then
                temp:Add(Vector(-maxAcceleration, 0, 0))
            end

            if (cmd:KeyDown(IN_MOVELEFT)) then
                temp:Add(Vector(0, maxAcceleration, 0))
            end

            if (cmd:KeyDown(IN_MOVERIGHT)) then
                temp:Add(Vector(0, -maxAcceleration, 0))
            end

            ball:AddSpeed(temp, maxAcceleration)
        end
    end
end

hook.Add("SetupMove", "camera controls", ApplyControl)