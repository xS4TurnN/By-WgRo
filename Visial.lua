-- =============================================
-- 📌 TRADE HELPER (рисование поверх экрана)
-- Без ScreenGui, только Drawing API
-- =============================================

local Player = game.Players.LocalPlayer
local Mouse = Player:GetMouse()
local Camera = workspace.CurrentCamera

-- Список предметов для отображения
local items = {"🔪 Knife", "🔫 Gun", "🎯 Sniper", "💎 Chroma"}
local selectedItem = items[1]
local active = false
local overlayObjects = {}

-- Функция создания текста на экране
local function createText(text, pos)
    local txt = Drawing.new("Text")
    txt.Text = text
    txt.Position = pos
    txt.Size = 24
    txt.Color = Color3.fromRGB(255, 255, 255)
    txt.Outline = true
    txt.OutlineColor = Color3.fromRGB(0, 0, 0)
    txt.Center = true
    txt.Transparency = 0.8
    return txt
end

-- Главное меню выбора (рисуется в углу)
local menuActive = false
local menuItems = {}

local function drawMenu()
    -- Очищаем старые объекты
    for _, obj in pairs(overlayObjects) do
        obj:Remove()
    end
    overlayObjects = {}
    if not menuActive then return end
    
    local startX = 20
    local startY = 100
    for i, item in ipairs(items) do
        local txt = createText(item, Vector2.new(startX, startY + (i-1)*35))
        overlayObjects[#overlayObjects+1] = txt
    end
    -- Подсказка
    local hint = createText("Нажми 1-4 для выбора, F для фиксации", Vector2.new(startX, startY + #items*35 + 20))
    hint.Size = 16
    overlayObjects[#overlayObjects+1] = hint
end

-- Функция отображения фейкового предмета (рисуется в центре)
local function showFakeItem()
    -- Очищаем старые объекты
    for _, obj in pairs(overlayObjects) do
        obj:Remove()
    end
    overlayObjects = {}
    
    local center = Camera.ViewportSize / 2
    local bigText = createText("📦 " .. selectedItem, center + Vector2.new(0, -30))
    bigText.Size = 48
    bigText.Color = Color3.fromRGB(100, 255, 100)
    overlayObjects[#overlayObjects+1] = bigText
    
    local subText = createText("(фейковый предмет, только для тебя)", center + Vector2.new(0, 30))
    subText.Size = 18
    subText.Color = Color3.fromRGB(200, 200, 200)
    overlayObjects[#overlayObjects+1] = subText
    
    -- Кнопка подтверждения (через горячие клавиши)
    local hint2 = createText("Нажми ENTER, чтобы убрать", center + Vector2.new(0, 70))
    hint2.Size = 16
    hint2.Color = Color3.fromRGB(255, 255, 100)
    overlayObjects[#overlayObjects+1] = hint2
end

-- Очистка
local function clearOverlay()
    for _, obj in pairs(overlayObjects) do
        obj:Remove()
    end
    overlayObjects = {}
    menuActive = false
    active = false
end

-- Обработка клавиш (используем InputBegan)
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F then
        -- Включаем/выключаем режим показа
        if not active then
            active = true
            showFakeItem()
            print("✅ Фейковый предмет зафиксирован: " .. selectedItem)
        else
            clearOverlay()
            print("❌ Отменено")
        end
    elseif input.KeyCode == Enum.KeyCode.Enter and active then
        -- Имитация подтверждения (просто убираем)
        clearOverlay()
        print("✅ Подтверждено (ничего не отправлено)")
    elseif input.KeyCode == Enum.KeyCode.One then
        selectedItem = items[1]
        print("Выбран: " .. selectedItem)
    elseif input.KeyCode == Enum.KeyCode.Two then
        selectedItem = items[2]
        print("Выбран: " .. selectedItem)
    elseif input.KeyCode == Enum.KeyCode.Three then
        selectedItem = items[3]
        print("Выбран: " .. selectedItem)
    elseif input.KeyCode == Enum.KeyCode.Four then
        selectedItem = items[4]
        print("Выбран: " .. selectedItem)
    elseif input.KeyCode == Enum.KeyCode.M then
        -- Показать меню выбора
        menuActive = not menuActive
        if menuActive then
            drawMenu()
        else
            clearOverlay()
        end
    end
end)

-- Автоматическое обновление при изменении размера экрана
game:GetService("RunService").RenderStepped:Connect(function()
    if active then
        -- Обновляем позицию текста, если нужно (но Drawing сам не двигается, поэтому перерисовываем)
        -- Для простоты оставим как есть, текст будет статичен
    end
end)

print("✅ Trade Overlay загружен. Клавиши:")
print("M - открыть/закрыть меню выбора предмета")
print("1-4 - выбрать предмет")
print("F - зафиксировать предмет (показать на экране)")
print("ENTER - убрать (подтвердить)")
print("Скрипт работает в обход Delta блокировок")
-- BZ
