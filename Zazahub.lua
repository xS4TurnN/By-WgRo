-- Zaza Hub | Deagle Arena (v2)
-- Меню + Aimbot + ESP + Bhop + Auto Reload

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Linoria.lua"))()
local Window = Library:CreateWindow({
    Title = "Zaza Hub | Deagle",
    Center = true,
    AutoShow = true,
    Theme = "Dark",
    Accent = Color3.fromRGB(255, 255, 255)
})

local CombatTab = Window:CreateTab("Бой")
local EspTab = Window:CreateTab("Визуал")
local MovementTab = Window:CreateTab("Движение")

local Settings = {
    Aimbot = false,
    EspBox = false,
    EspLines = false,
    EspNames = false,
    Bhop = false,
    AutoReload = false
}

-- ============================
-- 1. АИМБОТ (Кружок 80x80)
-- ============================
local FOVCircle = Instance.new("Frame")
FOVCircle.Size = UDim2.new(0, 80, 0, 80)
FOVCircle.Position = UDim2.new(0.5, -40, 0.5, -40)
FOVCircle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
FOVCircle.BackgroundTransparency = 1
FOVCircle.BorderSizePixel = 2
FOVCircle.BorderColor3 = Color3.fromRGB(255, 255, 255)
FOVCircle.Parent = game.CoreGui

local function Aimbot()
    game:GetService("RunService").RenderStepped:Connect(function()
        if Settings.Aimbot then
            local Camera = workspace.CurrentCamera
            local Target = nil
            local ShortestDist = 80

            for _, Player in pairs(game.Players:GetPlayers()) do
                if Player ~= game.Players.LocalPlayer then
                    local HRP = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
                    if HRP then
                        local ScreenPos, OnScreen = Camera:WorldToViewportPoint(HRP.Position)
                        if OnScreen then
                            local DistX = math.abs(ScreenPos.X - FOVCircle.AbsolutePosition.X - 40)
                            local DistY = math.abs(ScreenPos.Y - FOVCircle.AbsolutePosition.Y - 40)
                            if DistX < 40 and DistY < 40 then
                                Target = HRP
                                ShortestDist = math.min(ShortestDist, DistX + DistY)
                            end
                        end
                    end
                end
            end

            if Target then
                local PHRP = game.Players.LocalPlayer.Character.HumanoidRootPart
                PHRP.CFrame = CFrame.lookAt(PHRP.Position, Target.Position)
            end
        end
    end)
end

-- ============================
-- 2. ESP (Квадраты, Линии, Ники)
-- ============================
local ESPFolder = Instance.new("Folder", game.CoreGui)

local function DrawESP()
    game:GetService("RunService").RenderStepped:Connect(function()
        local Camera = workspace.CurrentCamera
        local P = game.Players.LocalPlayer

        for _, Player in pairs(game.Players:GetPlayers()) do
            if Player ~= P and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                local HRP = Player.Character.HumanoidRootPart
                local ScreenPos, OnScreen = Camera:WorldToViewportPoint(HRP.Position)

                if OnScreen then
                    if Settings.EspBox then
                        local H = Player.Character:GetExtentsSize().Y
                        local W = H / 2
                        local Box = Instance.new("Frame", ESPFolder)
                        Box.Size = UDim2.new(0, W * 2, 0, H)
                        Box.Position = UDim2.new(0, ScreenPos.X - W, 0, ScreenPos.Y - H)
                        Box.BackgroundTransparency = 1
                        Box.BorderSizePixel = 1
                        Box.BorderColor3 = Color3.fromRGB(255, 255, 255)
                        Box:Destroy()
                    end

                    if Settings.EspLines then
                        local Line = Instance.new("Frame", ESPFolder)
                        Line.Size = UDim2.new(0, 2, 0, 5)
                        Line.Position = UDim2.new(0, ScreenPos.X, 0, ScreenPos.Y)
                        Line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                        Line:Destroy()
                    end

                    if Settings.EspNames then
                        local NameTag = Instance.new("TextLabel", ESPFolder)
                        NameTag.Text = Player.Name
                        NameTag.Size = UDim2.new(0, 100, 0, 20)
                        NameTag.Position = UDim2.new(0, ScreenPos.X - 50, 0, ScreenPos.Y - 80)
                        NameTag.BackgroundTransparency = 1
                        NameTag.TextColor3 = Color3.fromRGB(255, 255, 255)
                        NameTag:Destroy()
                    end
                end
            end
        end
    end)
end

-- ============================
-- 3. БАНИХОП (Bhop)
-- ============================
local function Bhop()
    game:GetService("RunService").RenderStepped:Connect(function()
        if Settings.Bhop then
            local Character = game.Players.LocalPlayer.Character
            if Character then
                local Humanoid = Character:FindFirstChildOfClass("Humanoid")
                if Humanoid and Humanoid.MoveDirection.Magnitude > 0 then
                    if Humanoid:GetState() ~= Enum.HumanoidStateType.Jumping then
                        Humanoid.Jump = true
                    end
                end
            end
        end
    end)
end

-- ============================
-- 4. АВТО ПЕРЕЗАРЯДКА
-- ============================
local function AutoReload()
    game:GetService("RunService").RenderStepped:Connect(function()
        if Settings.AutoReload then
            local Character = game.Players.LocalPlayer.Character
            if Character then
                local Tool = Character:FindFirstChildOfClass("Tool")
                if Tool then
                    -- Пытаемся найти оружие и эмулировать перезарядку
                    -- В большинстве игр это делается через нажатие клавиши R
                    -- Но если игра использует RemoteEvents, это может не сработать
                    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
                    if Humanoid then
                        -- Эмуляция нажатия R через виртуальный ввод
                        game:GetService("VirtualInputManager"):SendKeyEvent(true, "R", false, game)
                        wait(0.1)
                        game:GetService("VirtualInputManager"):SendKeyEvent(false, "R", false, game)
                    end
                end
            end
        end
    end)
end

-- ============================
-- 5. Кнопки меню
-- ============================
CombatTab:CreateToggle({
    Name = "Aimbot (80x80)",
    CurrentValue = false,
    Callback = function(v) Settings.Aimbot = v end
})

EspTab:CreateToggle({
    Name = "ESP Квадраты",
    CurrentValue = false,
    Callback = function(v) Settings.EspBox = v end
})
EspTab:CreateToggle({
    Name = "ESP Линии",
    CurrentValue = false,
    Callback = function(v) Settings.EspLines = v end
})
EspTab:CreateToggle({
    Name = "ESP Ники",
    CurrentValue = false,
    Callback = function(v) Settings.EspNames = v end
})

MovementTab:CreateToggle({
    Name = "Банихоп (Bhop)",
    CurrentValue = false,
    Callback = function(v) Settings.Bhop = v end
})

MovementTab:CreateToggle({
    Name = "Авто перезарядка",
    CurrentValue = false,
    Callback = function(v) Settings.AutoReload = v end
})

-- Развернуть меню
Library:CreateToggle({
    Name = "Развернуть/Свернуть",
    CurrentValue = true,
    Callback = function(v) Library:Toggle() end
})

-- Запуск функций
Aimbot()
DrawESP()
Bhop()
AutoReload()
