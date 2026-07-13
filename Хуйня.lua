-- MM2 By WgRo — Полная версия
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local ESPAll = false
local ESPGun = false
local ShotMurderer = false
local AutoPickup = false
local CrosshairEnabled = false

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Главное меню
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 420)
MainFrame.Position = UDim2.new(0.5, -125, 0.25, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
MainFrame.BackgroundTransparency = 0.3
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,50)
Title.Text = "MM2 MENU"
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(0, 255, 200)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.Parent = MainFrame

local Credit = Instance.new("TextLabel")
Credit.Size = UDim2.new(1,0,0,30)
Credit.Position = UDim2.new(0,0,0,25)
Credit.Text = "By WgRo"
Credit.BackgroundTransparency = 1
Credit.TextColor3 = Color3.fromRGB(120, 220, 255)
Credit.Font = Enum.Font.GothamSemibold
Credit.TextSize = 17
Credit.Parent = MainFrame

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0,35,0,35)
CloseBtn.Position = UDim2.new(1,-40,0,5)
CloseBtn.Text = "✕"
CloseBtn.BackgroundColor3 = Color3.fromRGB(220,40,40)
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 20
CloseBtn.Parent = MainFrame
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0,8)

-- Кнопка открытия (By WgRo сверху в центре)
local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0,170,0,45)
OpenBtn.Position = UDim2.new(0.5,-85,0,10)
OpenBtn.Text = "By WgRo"
OpenBtn.BackgroundColor3 = Color3.fromRGB(0,170,130)
OpenBtn.TextColor3 = Color3.new(1,1,1)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 18
OpenBtn.Visible = false
OpenBtn.Parent = ScreenGui
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0,12)

local Container = Instance.new("Frame")
Container.Size = UDim2.new(1,-20,1,-80)
Container.Position = UDim2.new(0,10,0,60)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

local List = Instance.new("UIListLayout")
List.Padding = UDim.new(0,10)
List.Parent = Container

local function createBtn(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,0,0,50)
    btn.BackgroundColor3 = Color3.fromRGB(40,40,55)
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 16
    btn.Parent = Container
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local bESP = createBtn("ESP All: OFF", function() ESPAll = not ESPAll; bESP.Text = "ESP All: " .. (ESPAll and "ON ✅" or "OFF") end)
local bGun = createBtn("ESP Gun: OFF", function() ESPGun = not ESPGun; bGun.Text = "ESP Gun: " .. (ESPGun and "ON ✅" or "OFF") end)
local bShot = createBtn("Shot Murderer: OFF", function() ShotMurderer = not ShotMurderer; bShot.Text = "Shot Murderer: " .. (ShotMurderer and "ON ✅" or "OFF") end)
local bPickup = createBtn("Auto Pickup Gun: OFF", function() AutoPickup = not AutoPickup; bPickup.Text = "Auto Pickup Gun: " .. (AutoPickup and "ON ✅" or "OFF") end)
local bCross = createBtn("Crosshair: OFF", function() CrosshairEnabled = not CrosshairEnabled; bCross.Text = "Crosshair: " .. (CrosshairEnabled and "ON ✅" or "OFF") end)

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenBtn.Visible = true
end)

OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    OpenBtn.Visible = false
end)

-- ==================== ФУНКЦИИ ====================
local ESPObjects = {}
local GunObjects = {}
local ShotBigBtn = nil

local function getRole(p)
    if not p.Character then return "Innocent" end
    if p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife") then return "Murderer" end
    if p.Character:FindFirstChild("Gun") or p.Backpack:FindFirstChild("Gun") then return "Sheriff" end
    return "Innocent"
end

RunService.RenderStepped:Connect(function()
    -- ESP All
    for _, p in ipairs(Players:GetPlayers()) do
        if p == LocalPlayer or not p.Character then continue end
        local root = p.Character:FindFirstChild("HumanoidRootPart")
        if not root then continue end
        local role = getRole(p)
        local col = role == "Murderer" and Color3.fromRGB(255,0,0) or (role == "Sheriff" and Color3.fromRGB(0,100,255) or Color3.fromRGB(0,255,0))
        
        if not ESPObjects[p] then
            local box = Drawing.new("Square")
            box.Thickness = 2
            box.Filled = false
            ESPObjects[p] = box
        end
        local box = ESPObjects[p]
        local pos, vis = Camera:WorldToViewportPoint(root.Position + Vector3.new(0,3,0))
        if ESPAll and vis then
            box.Size = Vector2.new(1600/pos.Z, 2400/pos.Z)
            box.Position = Vector2.new(pos.X - box.Size.X/2, pos.Y - box.Size.Y/2)
            box.Color = col
            box.Visible = true
        else
            box.Visible = false
        end
    end

    -- ESP Gun (жёлтая рамка)
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("Handle") and string.find(obj.Name:lower(), "gun") then
            if not GunObjects[obj] then
                local box = Drawing.new("Square")
                box.Thickness = 2
                box.Color = Color3.fromRGB(255, 215, 0)
                box.Filled = false
                GunObjects[obj] = box
            end
            local box = GunObjects[obj]
            local pos, vis = Camera:WorldToViewportPoint(obj.Handle.Position)
            if ESPGun and vis then
                box.Size = Vector2.new(60, 40)
                box.Position = Vector2.new(pos.X - 30, pos.Y - 20)
                box.Visible = true
            else
                box.Visible = false
            end
        end
    end

    -- Большая кнопка Shot Murderer
    if ShotMurderer and not ShotBigBtn then
        ShotBigBtn = Instance.new("TextButton")
        ShotBigBtn.Size = UDim2.new(0, 150, 0, 80)
        ShotBigBtn.Position = UDim2.new(0.75, 0, 0.55, 0)
        ShotBigBtn.BackgroundColor3 = Color3.fromRGB(200, 20, 20)
        ShotBigBtn.Text = "SHOT\nMURDERER"
        ShotBigBtn.TextColor3 = Color3.new(1,1,1)
        ShotBigBtn.Font = Enum.Font.GothamBold
        ShotBigBtn.TextSize = 16
        ShotBigBtn.Parent = ScreenGui
        Instance.new("UICorner", ShotBigBtn).CornerRadius = UDim.new(0, 14)

        -- Drag
        local dragging = false
        ShotBigBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                ShotBigBtn.Position = ShotBigBtn.Position + UDim2.new(0, input.Position.X - ShotBigBtn.Position.X.Offset - 75, 0, input.Position.Y - ShotBigBtn.Position.Y.Offset - 40)
            end
        end)
        UserInputService.InputEnded:Connect(function() dragging = false end)

        ShotBigBtn.MouseButton1Click:Connect(function()
            if not ShotMurderer then return end
            for _, p in ipairs(Players:GetPlayers()) do
                if p \~= LocalPlayer and getRole(p) == "Murderer" and p.Character then
                    local root = p.Character:FindFirstChild("HumanoidRootPart")
                    if root then
                        Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, root.Position)
                        mouse1click()
                    end
                end
            end
        end)
    end

    -- Auto Pickup Gun
    if AutoPickup then
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and obj:FindFirstChild("Handle") and string.find(obj.Name:lower(), "gun") then
                local handle = obj.Handle
                if (handle.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 10 then
                    firetouchinterest(LocalPlayer.Character.HumanoidRootPart, handle, 0)
                    firetouchinterest(LocalPlayer.Character.HumanoidRootPart, handle, 1)
                end
            end
        end
    end
end)

print("✅ Полная версия с By WgRo и Shot Murderer загружена!")
