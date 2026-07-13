-- MM2 Красивое Меню By WgRo (Исправленная версия)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local ESPAll = false
local ESPGun = false
local ShotMurderer = false
local CrosshairEnabled = false

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2WgRoMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Главное окно (выше)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 240, 0, 380)  -- Сделали выше
MainFrame.Position = UDim2.new(0.5, -120, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
MainFrame.BackgroundTransparency = 0.3
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 14)
UICorner.Parent = MainFrame

-- Заголовок
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 50)
TitleBar.BackgroundTransparency = 1
TitleBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.6, 0, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "MM2 MENU"
Title.TextColor3 = Color3.fromRGB(0, 255, 180)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

local Credit = Instance.new("TextLabel")
Credit.Size = UDim2.new(0.4, 0, 1, 0)
Credit.Position = UDim2.new(0.55, 0, 0, 0)
Credit.BackgroundTransparency = 1
Credit.Text = "By WgRo"
Credit.TextColor3 = Color3.fromRGB(120, 220, 255)
Credit.Font = Enum.Font.GothamSemibold
Credit.TextSize = 17
Credit.TextXAlignment = Enum.TextXAlignment.Right
Credit.Parent = TitleBar

-- Кнопка закрытия
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 36, 0, 36)
CloseButton.Position = UDim2.new(1, -42, 0, 7)
CloseButton.BackgroundColor3 = Color3.fromRGB(230, 50, 50)
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.new(1,1,1)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 22
CloseButton.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 9)
CloseCorner.Parent = CloseButton

-- Кнопка открытия (By WgRo сверху)
local OpenButton = Instance.new("TextButton")
OpenButton.Size = UDim2.new(0, 160, 0, 45)
OpenButton.Position = UDim2.new(0.5, -80, 0, 8)
OpenButton.BackgroundColor3 = Color3.fromRGB(0, 180, 140)
OpenButton.BackgroundTransparency = 0.15
OpenButton.Text = "By WgRo"
OpenButton.TextColor3 = Color3.new(1,1,1)
OpenButton.Font = Enum.Font.GothamBold
OpenButton.TextSize = 19
OpenButton.Visible = false
OpenButton.Parent = ScreenGui

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(0, 12)
OpenCorner.Parent = OpenButton

-- Контейнер кнопок (вертикальный)
local ButtonContainer = Instance.new("Frame")
ButtonContainer.Size = UDim2.new(1, -24, 1, -80)
ButtonContainer.Position = UDim2.new(0, 12, 0, 60)
ButtonContainer.BackgroundTransparency = 1
ButtonContainer.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 12)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = ButtonContainer

local function createStyledButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 55)  -- Выше кнопки
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
    btn.BackgroundTransparency = 0.3
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 17
    btn.Parent = ButtonContainer
    
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 12)
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Кнопки
local btnESPAll = createStyledButton("ESP All: OFF", function(self)
    ESPAll = not ESPAll
    self.Text = "ESP All: " .. (ESPAll and "ON ✅" or "OFF")
end)

local btnESPGun = createStyledButton("ESP Gun: OFF", function(self)
    ESPGun = not ESPGun
    self.Text = "ESP Gun: " .. (ESPGun and "ON ✅" or "OFF")
end)

local btnShot = createStyledButton("Shot Murderer: OFF", function(self)
    ShotMurderer = not ShotMurderer
    self.Text = "Shot Murderer: " .. (ShotMurderer and "ON ✅" or "OFF")
end)

local btnCross = createStyledButton("Crosshair: OFF", function(self)
    CrosshairEnabled = not CrosshairEnabled
    self.Text = "Crosshair: " .. (CrosshairEnabled and "ON ✅" or "OFF")
end)

-- Логика открытия/закрытия
CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenButton.Visible = true
end)

OpenButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    OpenButton.Visible = false
end)

-- ==================== ОСНОВНАЯ ЛОГИКА ====================
local ESPObjects = {}
local GunESPObjects = {}
local ShotButton = nil
local crosshair = Drawing.new("Text")
crosshair.Color = Color3.fromRGB(0, 255, 200)
crosshair.Size = 22
crosshair.Center = true
crosshair.Outline = true

local function getRole(player)
    if not player.Character then return "Innocent" end
    local bp = player:FindFirstChild("Backpack")
    local char = player.Character
    if bp and (bp:FindFirstChild("Knife") or bp:FindFirstChildWhichIsA("Tool")) and char:FindFirstChild("Knife") then return "Murderer" end
    if bp and bp:FindFirstChild("Gun") or char:FindFirstChild("Gun") then return "Sheriff" end
    return "Innocent"
end

local function updateESP()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer or not plr.Character then continue end
        local root = plr.Character:FindFirstChild("HumanoidRootPart")
        if not root then continue end
        
        local role = getRole(plr)
        local color = role == "Murderer" and Color3.fromRGB(255,0,0) or (role == "Sheriff" and Color3.fromRGB(0,100,255) or Color3.fromRGB(0,255,0))
        
        if not ESPObjects[plr] then
            local box = Drawing.new("Square")
            box.Thickness = 2
            box.Filled = false
            box.Transparency = 1
            ESPObjects[plr] = box
        end
        
        local box = ESPObjects[plr]
        local pos, onScreen = Camera:WorldToViewportPoint(root.Position + Vector3.new(0,3,0))
        
        if ESPAll and onScreen then
            box.Size = Vector2.new(1800 / pos.Z, 2800 / pos.Z)
            box.Position = Vector2.new(pos.X - box.Size.X/2, pos.Y - box.Size.Y/2)
            box.Color = color
            box.Visible = true
        else
            box.Visible = false
        end
    end
end

local function updateGunESP()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and string.find(obj.Name:lower(), "gun") then
            local part = obj:FindFirstChild("Handle") or obj:FindFirstChildWhichIsA("BasePart")
            if part then
                if not GunESPObjects[obj] then
                    local t = Drawing.new("Text")
                    t.Text = "🔫 GUN"
                    t.Color = Color3.fromRGB(255, 215, 0)
                    t.Size = 18
                    GunESPObjects[obj] = t
                end
                local t = GunESPObjects[obj]
                local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if ESPGun and onScreen then
                    t.Position = Vector2.new(pos.X, pos.Y)
                    t.Visible = true
                else
                    t.Visible = false
                end
            end
        end
    end
end

-- Создание большой кнопки Shot
local function createShotButton()
    if ShotButton then return end
    ShotButton = Instance.new("TextButton")
    ShotButton.Size = UDim2.new(0, 150, 0, 75)
    ShotButton.Position = UDim2.new(0.78, 0, 0.6, 0)
    ShotButton.BackgroundColor3 = Color3.fromRGB(200, 20, 20)
    ShotButton.BackgroundTransparency = 0.1
    ShotButton.Text = "🔫 SHOT\nMURDERER"
    ShotButton.TextColor3 = Color3.new(1,1,1)
    ShotButton.Font = Enum.Font.GothamBold
    ShotButton.TextSize = 16
    ShotButton.Parent = ScreenGui
    
    local sc = Instance.new("UICorner", ShotButton)
    sc.CornerRadius = UDim.new(0, 14)
    
    ShotButton.MouseButton1Click:Connect(function()
        if not ShotMurderer then return end
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr \~= LocalPlayer and getRole(plr) == "Murderer" and plr.Character then
                local root = plr.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, root.Position)
                    mouse1click()
                    print("Выстрел в убийцу!")
                end
            end
        end
    end)
end

-- Crosshair
RunService.RenderStepped:Connect(function()
    updateESP()
    updateGunESP()
    
    if CrosshairEnabled then
        crosshair.Visible = true
        crosshair.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
        crosshair.Text = "•"
    else
        crosshair.Visible = false
    end
end)

print("✅ Меню By WgRo полностью исправлено и загружено!")
