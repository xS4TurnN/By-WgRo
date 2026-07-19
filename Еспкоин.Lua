-- Облегченный ESP: синяя звездочка над монетой
task.spawn(function()
    while task.wait(2) do 
        for _, v in pairs(workspace:GetChildren()) do
            -- Ищем объекты монеток
            if v.Name == "Coin" or v.Name == "Coin_Server" then
                if not v:FindFirstChild("ESPTag") then
                    
                    local b = Instance.new("BillboardGui", v)
                    b.Name = "ESPTag"
                    b.Size = UDim2.new(0, 40, 0, 40)
                    b.StudsOffset = Vector3.new(0, 2, 0)
                    b.AlwaysOnTop = true
                    
                    local l = Instance.new("TextLabel", b)
                    l.Size = UDim2.new(1, 0, 1, 0)
                    l.Text = "★" -- Маленькая звездочка
                    l.TextColor3 = Color3.fromRGB(0, 150, 255) -- Ярко-синий цвет
                    l.Font = Enum.Font.SourceSansBold
                    l.TextScaled = true
                    l.BackgroundTransparency = 1
                    l.TextStrokeColor3 = Color3.fromRGB(255, 255, 255) -- Белая обводка для четкости
                    l.TextStrokeTransparency = 0
                end
            end
        end
    end
end)
