-- Поворот камеры (вместо подмены ShootGun)
local RunService = game:GetService("RunService")
local target = nil

-- Обновляем цель постоянно
RunService.RenderStepped:Connect(function()
    target = getTarget() -- функция из прошлого скрипта
end)

-- Хукаем клик мыши или стрельбу для поворота
UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and target then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Gun") then
            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, target.Position)
        end
    end
end)
