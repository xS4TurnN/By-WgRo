-- =============================================
-- 💎 FAKE TRADE UI v2.0
-- Клиентская симуляция трейда
-- Библиотека: Rayfield
-- =============================================

local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/xsh46/Rayfield/main/source.lua"))()
local Player = game.Players.LocalPlayer

-- Создаём окно
local Window = Rayfield:CreateWindow({
    Name = "💎 Trade Scam UI",
    Icon = "rbxassetid://1234567890",
    Theme = "Dark",
    ConfigurationSaving = { Enabled = false }
})

local MainTab = Window:CreateTab("Trade")

-- Переменные состояния
local freezeMode = false
local fakeItems = {"🔪 Godly Knife", "🔫 Luger", "🎯 Sniper", "🔥 Chroma"}
local selectedItem = fakeItems[1]

-- Выпадающий список для выбора предмета
local Dropdown = MainTab:CreateDropdown({
    Name = "Выбери предмет для показа",
    Options = fakeItems,
    CurrentOption = selectedItem,
    Callback = function(opt)
        selectedItem = opt
    end
})

-- Кнопка "Freeze" — замораживает отображение предмета
local FreezeBtn = MainTab:CreateButton({
    Name = "❄️ FREEZE (зафиксировать предмет)",
    Callback = function()
        freezeMode = not freezeMode
        if freezeMode then
            -- Создаём GUI с фейковым предметом в окне трейда
            local screenGui = Instance.new("ScreenGui")
            screenGui.Name = "FakeTrade"
            screenGui.Parent = Player.PlayerGui
            
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(0, 300, 0, 200)
            frame.Position = UDim2.new(0.5, -150, 0.5, -100)
            frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
            frame.BackgroundTransparency = 0.2
            frame.Parent = screenGui
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 12)
            corner.Parent = frame
            
            local title = Instance.new("TextLabel")
            title.Size = UDim2.new(1, 0, 0, 40)
            title.Text = "💎 Фейковый трейд (заморожен)"
            title.BackgroundTransparency = 1
            title.TextColor3 = Color3.fromRGB(255, 255, 255)
            title.Font = Enum.Font.GothamBold
            title.TextSize = 18
            title.Parent = frame
            
            local itemLabel = Instance.new("TextLabel")
            itemLabel.Size = UDim2.new(0.9, 0, 0.4, 0)
            itemLabel.Position = UDim2.new(0.05, 0, 0.25, 0)
            itemLabel.Text = "📦 " .. selectedItem
            itemLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            itemLabel.TextSize = 24
            itemLabel.Font = Enum.Font.GothamBold
            itemLabel.BackgroundTransparency = 1
            itemLabel.Parent = frame
            
            -- Кнопка "Подтвердить" (имитация)
            local confirmBtn = Instance.new("TextButton")
            confirmBtn.Size = UDim2.new(0, 100, 0, 40)
            confirmBtn.Position = UDim2.new(0.5, -50, 0.75, 0)
            confirmBtn.Text = "✅ Принять"
            confirmBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
            confirmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            confirmBtn.Font = Enum.Font.Gotham
            confirmBtn.TextSize = 16
            confirmBtn.Parent = frame
            
            confirmBtn.MouseButton1Click:Connect(function()
                -- Просто закрываем окно (ничего не отправляем на сервер)
                screenGui:Destroy()
                freezeMode = false
                print("🔒 Фейковый трейд завершён (без отправки)")
            end)
            
            -- При повторном нажатии Freeze удаляем окно
            while freezeMode do
                wait(0.5)
            end
            screenGui:Destroy()
            
        else
            -- Если выключили freeze, удаляем GUI (если есть)
            local gui = Player.PlayerGui:FindFirstChild("FakeTrade")
            if gui then gui:Destroy() end
            print("❄️ Freeze отключён")
        end
    end
})

-- Информационная кнопка
MainTab:CreateParagraph({
    Name = "Инструкция",
    Content = "1. Выбери предмет в выпадающем списке\n2. Нажми FREEZE — появится окно с предметом\n3. Убери свой реальный предмет из трейда\n4. Нажми 'Принять' в фейковом окне\n5. Другой игрок увидит только картинку (ему ничего не придёт)"
})

print("✅ Trade Scam UI загружен. Удачи!")
-- BZ
