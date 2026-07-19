-- Создаем UI вместо Drawing (работает везде)
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Circle = Instance.new("Frame", ScreenGui)
Circle.Size = UDim2.new(0, 120, 0, 120)
Circle.Position = UDim2.new(0.5, -60, 0.5, -60)
Circle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Circle.BackgroundTransparency = 0.5
Circle.BorderSizePixel = 0
local UICorner = Instance.new("UICorner", Circle)
UICorner.CornerRadius = UDim.new(1, 0)

-- Основная логика Аима
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local function getTarget()
    local closest, dist = nil, 100
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Knife") then
            local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
            if onScreen then
                local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if mag < dist then closest = v.Character.HumanoidRootPart dist = mag end
            end
        end
    end
    return closest
end

-- Хук стрельбы (самый стабильный)
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    if getnamecallmethod() == "FireServer" and self.Name == "ShootGun" then
        local target = getTarget()
        if target then
            args[1] = (target.Position - LocalPlayer.Character.Gun.Handle.Position).Unit
            return self.FireServer(self, unpack(args))
        end
    end
    return old(self, ...)
end)
setreadonly(mt, true)
