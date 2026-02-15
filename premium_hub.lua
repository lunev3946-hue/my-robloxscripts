--[[ 
    👑 PREMIUM HUB v7.0 - С РАБОЧИМ ESP
    ESP показывает игроков, убран Aimbot
]]

-- Сервисы
local players = game:GetService("Players")
local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local tweenService = game:GetService("TweenService")
local lighting = game:GetService("Lighting")

local player = players.LocalPlayer
local mouse = player:GetMouse()

-- =============================================
-- СОЗДАНИЕ GUI
-- =============================================

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PremiumHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Главное окно
local mainWindow = Instance.new("Frame")
mainWindow.Parent = screenGui
mainWindow.BackgroundColor3 = Color3.fromRGB(20, 15, 30)
mainWindow.BorderSizePixel = 2
mainWindow.BorderColor3 = Color3.fromRGB(255, 215, 0)
mainWindow.Position = UDim2.new(0.5, -275, 0.5, -250)
mainWindow.Size = UDim2.new(0, 550, 0, 500)
mainWindow.Active = true
mainWindow.Draggable = true

-- Скругленные углы
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 15)
mainCorner.Parent = mainWindow

-- Заголовок
local titleBar = Instance.new("Frame")
titleBar.Parent = mainWindow
titleBar.BackgroundColor3 = Color3.fromRGB(30, 20, 40)
titleBar.BorderSizePixel = 0
titleBar.Size = UDim2.new(1, 0, 0, 60)

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 15)
titleCorner.Parent = titleBar

local titleText = Instance.new("TextLabel")
titleText.Parent = titleBar
titleText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
titleText.BackgroundTransparency = 1
titleText.Size = UDim2.new(1, -50, 1, 0)
titleText.Font = Enum.Font.GothamBold
titleText.Text = "👑 PREMIUM HUB v7.0"
titleText.TextColor3 = Color3.fromRGB(255, 215, 0)
titleText.TextSize = 24
titleText.TextXAlignment = Enum.TextXAlignment.Left

-- Кнопка закрытия
local closeBtn = Instance.new("TextButton")
closeBtn.Parent = titleBar
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
closeBtn.Position = UDim2.new(1, -45, 0.5, -15)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 18
closeBtn.Font = Enum.Font.GothamBold

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
    -- Удаляем все ESP при закрытии
    if espEnabled then
        for _, esp in ipairs(espObjects) do
            if esp and esp.Parent then
                esp:Destroy()
            end
        end
    end
end)

-- =============================================
-- СИСТЕМА УВЕДОМЛЕНИЙ
-- =============================================

local notificationFrame = Instance.new("Frame")
notificationFrame.Parent = screenGui
notificationFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
notificationFrame.BorderSizePixel = 2
notificationFrame.BorderColor3 = Color3.fromRGB(255, 215, 0)
notificationFrame.Position = UDim2.new(0.5, -150, 0, -50)
notificationFrame.Size = UDim2.new(0, 300, 0, 50)
notificationFrame.Visible = false
notificationFrame.ZIndex = 10

local notifCorner = Instance.new("UICorner")
notifCorner.CornerRadius = UDim.new(0, 8)
notifCorner.Parent = notificationFrame

local notifIcon = Instance.new("TextLabel")
notifIcon.Parent = notificationFrame
notifIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
notifIcon.BackgroundTransparency = 1
notifIcon.Position = UDim2.new(0, 10, 0, 10)
notifIcon.Size = UDim2.new(0, 30, 0, 30)
notifIcon.Font = Enum.Font.GothamBold
notifIcon.Text = "✅"
notifIcon.TextColor3 = Color3.fromRGB(0, 255, 0)
notifIcon.TextSize = 24
notifIcon.ZIndex = 11

local notifText = Instance.new("TextLabel")
notifText.Parent = notificationFrame
notifText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
notifText.BackgroundTransparency = 1
notifText.Position = UDim2.new(0, 50, 0, 8)
notifText.Size = UDim2.new(1, -60, 0, 34)
notifText.Font = Enum.Font.GothamBold
notifText.Text = "Функция включена"
notifText.TextColor3 = Color3.fromRGB(255, 255, 255)
notifText.TextSize = 16
notifText.TextWrapped = true
notifText.TextXAlignment = Enum.TextXAlignment.Left
notifText.ZIndex = 11

local function showNotification(message, isOn)
    notificationFrame.Visible = true
    
    if isOn then
        notifIcon.Text = "✅"
        notifIcon.TextColor3 = Color3.fromRGB(0, 255, 0)
        notificationFrame.BorderColor3 = Color3.fromRGB(0, 255, 0)
    else
        notifIcon.Text = "❌"
        notifIcon.TextColor3 = Color3.fromRGB(255, 70, 70)
        notificationFrame.BorderColor3 = Color3.fromRGB(255, 70, 70)
    end
    
    notifText.Text = message
    
    notificationFrame.Position = UDim2.new(0.5, -150, 0, -50)
    tweenService:Create(notificationFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
        Position = UDim2.new(0.5, -150, 0, 20)
    }):Play()
    
    wait(2)
    tweenService:Create(notificationFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
        Position = UDim2.new(0.5, -150, 0, -50)
    }):Play()
    
    wait(0.5)
    notificationFrame.Visible = false
end

-- =============================================
-- ВКЛАДКИ
-- =============================================

local tabFrame = Instance.new("Frame")
tabFrame.Parent = mainWindow
tabFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
tabFrame.BackgroundTransparency = 1
tabFrame.Position = UDim2.new(0, 20, 0, 70)
tabFrame.Size = UDim2.new(1, -40, 0, 40)

-- Контейнер для страниц
local pageContainer = Instance.new("Frame")
pageContainer.Parent = mainWindow
pageContainer.BackgroundColor3 = Color3.fromRGB(30, 25, 40)
pageContainer.BackgroundTransparency = 0.2
pageContainer.Position = UDim2.new(0, 20, 0, 120)
pageContainer.Size = UDim2.new(1, -40, 1, -140)

local pageCorner = Instance.new("UICorner")
pageCorner.CornerRadius = UDim.new(0, 10)
pageCorner.Parent = pageContainer

-- Страницы
local page1 = Instance.new("Frame")
page1.Parent = pageContainer
page1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
page1.BackgroundTransparency = 1
page1.Size = UDim2.new(1, 0, 1, 0)
page1.Visible = true

local page2 = Instance.new("Frame")
page2.Parent = pageContainer
page2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
page2.BackgroundTransparency = 1
page2.Size = UDim2.new(1, 0, 1, 0)
page2.Visible = false

local page3 = Instance.new("Frame")
page3.Parent = pageContainer
page3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
page3.BackgroundTransparency = 1
page3.Size = UDim2.new(1, 0, 1, 0)
page3.Visible = false

-- Функция создания кнопки вкладки
local function createTabButton(name, xPos, pageNum)
    local btn = Instance.new("TextButton")
    btn.Parent = tabFrame
    btn.BackgroundColor3 = pageNum == 1 and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(50, 45, 60)
    btn.Position = UDim2.new(xPos, 0, 0, 0)
    btn.Size = UDim2.new(0.3, -5, 1, -5)
    btn.Text = name
    btn.TextColor3 = pageNum == 1 and Color3.fromRGB(20, 15, 30) or Color3.fromRGB(255, 255, 255)
    btn.TextSize = 16
    btn.Font = Enum.Font.GothamBold
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        if pageNum == 1 then
            page1.Visible = true
            page2.Visible = false
            page3.Visible = false
        elseif pageNum == 2 then
            page1.Visible = false
            page2.Visible = true
            page3.Visible = false
        else
            page1.Visible = false
            page2.Visible = false
            page3.Visible = true
        end
        
        for i, child in ipairs(tabFrame:GetChildren()) do
            if child:IsA("TextButton") then
                if i == pageNum then
                    child.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
                    child.TextColor3 = Color3.fromRGB(20, 15, 30)
                else
                    child.BackgroundColor3 = Color3.fromRGB(50, 45, 60)
                    child.TextColor3 = Color3.fromRGB(255, 255, 255)
                end
            end
        end
    end)
    
    return btn
end

-- Создаем кнопки вкладок
local tab1 = createTabButton("⚡ ОСНОВНЫЕ", 0, 1)
local tab2 = createTabButton("✨ ВИЗУАЛ", 0.35, 2)
local tab3 = createTabButton("🎯 ЭКСТРА", 0.7, 3)

-- =============================================
-- ПЕРЕМЕННЫЕ ДЛЯ ФУНКЦИЙ
-- =============================================

-- Основные функции
local flying = false
local speedEnabled = false
local jumpEnabled = false
local noclipEnabled = false
local godMode = false

-- Визуальные функции
local fullbrightEnabled = false
local noFogEnabled = false
local fovEnabled = false
local rainbowEnabled = false

-- Экстра функции
local infiniteJumpEnabled = false
local teleportEnabled = false
local espEnabled = false

-- Значения
local flySpeed = 75
local speedMultiplier = 2.5
local jumpMultiplier = 2.5
local fovValue = 90

-- Подключения
local flyConnection = nil
local noclipConnection = nil
local godConnections = {}
local rainbowConnection = nil
local infiniteJumpConnection = nil
local espConnection = nil
local espObjects = {}

-- Сохраняем оригинальные настройки
local originalAmbient = lighting.Ambient
local originalBrightness = lighting.Brightness
local originalFogEnd = lighting.FogEnd

-- =============================================
-- ФУНКЦИЯ СОЗДАНИЯ КНОПКИ
-- =============================================

local function createButton(parent, name, yPos, color, description, callback)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.BackgroundColor3 = Color3.fromRGB(40, 35, 50)
    frame.BackgroundTransparency = 0.2
    frame.Position = UDim2.new(0, 15, 0, yPos)
    frame.Size = UDim2.new(1, -30, 0, 55)
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 8)
    frameCorner.Parent = frame
    
    local btn = Instance.new("TextButton")
    btn.Parent = frame
    btn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    btn.Position = UDim2.new(0, 15, 0.5, -15)
    btn.Size = UDim2.new(0, 70, 0, 30)
    btn.Text = "OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamBold
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    local title = Instance.new("TextLabel")
    title.Parent = frame
    title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0, 100, 0, 8)
    title.Size = UDim2.new(1, -120, 0, 20)
    title.Font = Enum.Font.GothamBold
    title.Text = name
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 16
    title.TextXAlignment = Enum.TextXAlignment.Left
    
    local desc = Instance.new("TextLabel")
    desc.Parent = frame
    desc.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    desc.BackgroundTransparency = 1
    desc.Position = UDim2.new(0, 100, 0, 28)
    desc.Size = UDim2.new(1, -120, 0, 16)
    desc.Font = Enum.Font.Gotham
    desc.Text = description
    desc.TextColor3 = Color3.fromRGB(180, 180, 180)
    desc.TextSize = 11
    desc.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Премиум бейдж
    local badge = Instance.new("Frame")
    badge.Parent = frame
    badge.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    badge.Position = UDim2.new(1, -35, 0.5, -10)
    badge.Size = UDim2.new(0, 20, 0, 20)
    
    local badgeCorner = Instance.new("UICorner")
    badgeCorner.CornerRadius = UDim.new(1, 0)
    badgeCorner.Parent = badge
    
    local badgeIcon = Instance.new("TextLabel")
    badgeIcon.Parent = badge
    badgeIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    badgeIcon.BackgroundTransparency = 1
    badgeIcon.Size = UDim2.new(1, 0, 1, 0)
    badgeIcon.Font = Enum.Font.GothamBold
    badgeIcon.Text = "👑"
    badgeIcon.TextColor3 = Color3.fromRGB(30, 20, 40)
    badgeIcon.TextSize = 12
    
    btn.MouseButton1Click:Connect(function()
        callback(btn)
    end)
    
    return btn
end

-- =============================================
-- ФУНКЦИЯ СОЗДАНИЯ СЛАЙДЕРА
-- =============================================

local function createSlider(parent, name, yPos, min, max, default, unit, callback)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.BackgroundColor3 = Color3.fromRGB(40, 35, 50)
    frame.BackgroundTransparency = 0.2
    frame.Position = UDim2.new(0, 15, 0, yPos)
    frame.Size = UDim2.new(1, -30, 0, 55)
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 8)
    frameCorner.Parent = frame
    
    local title = Instance.new("TextLabel")
    title.Parent = frame
    title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0, 15, 0, 8)
    title.Size = UDim2.new(1, -30, 0, 20)
    title.Font = Enum.Font.GothamBold
    title.Text = name
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 16
    title.TextXAlignment = Enum.TextXAlignment.Left
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Parent = frame
    valueLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Position = UDim2.new(1, -70, 0, 8)
    valueLabel.Size = UDim2.new(0, 60, 0, 20)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.Text = tostring(default) .. unit
    valueLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    valueLabel.TextSize = 16
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    
    local bar = Instance.new("Frame")
    bar.Parent = frame
    bar.BackgroundColor3 = Color3.fromRGB(60, 55, 70)
    bar.Position = UDim2.new(0, 15, 0, 35)
    bar.Size = UDim2.new(1, -30, 0, 8)
    
    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(1, 0)
    barCorner.Parent = bar
    
    local fill = Instance.new("Frame")
    fill.Parent = bar
    fill.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill
    
    local button = Instance.new("TextButton")
    button.Parent = bar
    button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    button.Position = UDim2.new((default - min) / (max - min), -10, 0.5, -10)
    button.Size = UDim2.new(0, 20, 0, 20)
    button.Text = ""
    button.AutoButtonColor = false
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(1, 0)
    buttonCorner.Parent = button
    
    -- Премиум бейдж
    local badge = Instance.new("Frame")
    badge.Parent = frame
    badge.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    badge.Position = UDim2.new(1, -35, 0.5, -10)
    badge.Size = UDim2.new(0, 20, 0, 20)
    
    local badgeCorner = Instance.new("UICorner")
    badgeCorner.CornerRadius = UDim.new(1, 0)
    badgeCorner.Parent = badge
    
    local badgeIcon = Instance.new("TextLabel")
    badgeIcon.Parent = badge
    badgeIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    badgeIcon.BackgroundTransparency = 1
    badgeIcon.Size = UDim2.new(1, 0, 1, 0)
    badgeIcon.Font = Enum.Font.GothamBold
    badgeIcon.Text = "👑"
    badgeIcon.TextColor3 = Color3.fromRGB(30, 20, 40)
    badgeIcon.TextSize = 12
    
    local dragging = false
    local currentValue = default
    
    button.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    userInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    userInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = userInputService:GetMouseLocation()
            local barPos = bar.AbsolutePosition
            local barSize = bar.AbsoluteSize
            
            local relativeX = math.clamp(mousePos.X - barPos.X, 0, barSize.X)
            local percent = relativeX / barSize.X
            currentValue = math.floor(min + (max - min) * percent)
            
            fill.Size = UDim2.new(percent, 0, 1, 0)
            button.Position = UDim2.new(percent, -10, 0.5, -10)
            valueLabel.Text = tostring(currentValue) .. unit
            callback(currentValue)
        end
    end)
    
    return frame
end

-- =============================================
-- ОСНОВНЫЕ ФУНКЦИИ
-- =============================================

-- ПОЛЕТ
local function toggleFly(btn)
    flying = not flying
    
    if flying then
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            
            if humanoid and rootPart then
                local bodyGyro = Instance.new("BodyGyro")
                bodyGyro.Parent = rootPart
                bodyGyro.MaxTorque = Vector3.new(4000, 4000, 4000)
                bodyGyro.P = 2000
                bodyGyro.D = 500
                
                local bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.Parent = rootPart
                bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
                
                humanoid.PlatformStand = true
                
                flyConnection = runService.RenderStepped:Connect(function()
                    if not flying or not character or not character.Parent then
                        return
                    end
                    
                    local camera = workspace.CurrentCamera
                    local moveDir = Vector3.new()
                    
                    if userInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDir = moveDir + camera.CFrame.LookVector
                    end
                    if userInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDir = moveDir - camera.CFrame.LookVector
                    end
                    if userInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDir = moveDir - camera.CFrame.RightVector
                    end
                    if userInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDir = moveDir + camera.CFrame.RightVector
                    end
                    if userInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDir = moveDir + Vector3.new(0, 1, 0)
                    end
                    if userInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                        moveDir = moveDir + Vector3.new(0, -1, 0)
                    end
                    
                    if moveDir.Magnitude > 0 then
                        bodyVelocity.Velocity = moveDir.Unit * flySpeed
                    else
                        bodyVelocity.Velocity = Vector3.new()
                    end
                    
                    bodyGyro.CFrame = CFrame.new(rootPart.Position, rootPart.Position + camera.CFrame.LookVector * 10)
                end)
                
                btn.Text = "ON"
                btn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                showNotification("✅ Полет включен", true)
            end
        end
    else
        if flyConnection then
            flyConnection:Disconnect()
            flyConnection = nil
        end
        
        local character = player.Character
        if character then
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                for _, child in ipairs(rootPart:GetChildren()) do
                    if child:IsA("BodyGyro") or child:IsA("BodyVelocity") then
                        child:Destroy()
                    end
                end
            end
            
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.PlatformStand = false
            end
        end
        
        btn.Text = "OFF"
        btn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        showNotification("❌ Полет выключен", false)
    end
end

-- СПИД ХАК
local function toggleSpeed(btn)
    speedEnabled = not speedEnabled
    
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            if speedEnabled then
                humanoid.WalkSpeed = 16 * speedMultiplier
                btn.Text = "ON"
                btn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                showNotification("✅ Спид хак x" .. speedMultiplier .. " включен", true)
            else
                humanoid.WalkSpeed = 16
                btn.Text = "OFF"
                btn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
                showNotification("❌ Спид хак выключен", false)
            end
        end
    end
end

-- ДЖАМП ХАК
local function toggleJump(btn)
    jumpEnabled = not jumpEnabled
    
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            if jumpEnabled then
                humanoid.JumpPower = 50 * jumpMultiplier
                btn.Text = "ON"
                btn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                showNotification("✅ Джамп хак x" .. jumpMultiplier .. " включен", true)
            else
                humanoid.JumpPower = 50
                btn.Text = "OFF"
                btn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
                showNotification("❌ Джамп хак выключен", false)
            end
        end
    end
end

-- НОУКЛИП
local function toggleNoClip(btn)
    noclipEnabled = not noclipEnabled
    
    if noclipEnabled then
        if noclipConnection then noclipConnection:Disconnect() end
        
        noclipConnection = runService.Stepped:Connect(function()
            if noclipEnabled and player.Character then
                for _, part in ipairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
        
        btn.Text = "ON"
        btn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        showNotification("✅ Ноуклип включен", true)
    else
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        
        if player.Character then
            for _, part in ipairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
        
        btn.Text = "OFF"
        btn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        showNotification("❌ Ноуклип выключен", false)
    end
end

-- БЕССМЕРТИЕ
local function toggleGod(btn)
    godMode = not godMode
    
    if godMode then
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.MaxHealth = math.huge
                humanoid.Health = humanoid.MaxHealth
            end
        end
        
        btn.Text = "ON"
        btn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        showNotification("👑 Бессмертие включено", true)
    else
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.MaxHealth = 100
                humanoid.Health = 100
            end
        end
        
        btn.Text = "OFF"
        btn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        showNotification("👑 Бессмертие выключено", false)
    end
end

-- =============================================
-- ВИЗУАЛЬНЫЕ ФУНКЦИИ
-- =============================================

-- FULLBRIGHT
local function toggleFullbright(btn)
    fullbrightEnabled = not fullbrightEnabled
    
    if fullbrightEnabled then
        lighting.Ambient = Color3.fromRGB(255, 255, 255)
        lighting.Brightness = 2
        lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        
        btn.Text = "ON"
        btn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        showNotification("👑 Fullbright включен", true)
    else
        lighting.Ambient = originalAmbient
        lighting.Brightness = originalBrightness
        lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        
        btn.Text = "OFF"
        btn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        showNotification("👑 Fullbright выключен", false)
    end
end

-- NO FOG
local function toggleNoFog(btn)
    noFogEnabled = not noFogEnabled
    
    if noFogEnabled then
        lighting.FogEnd = 100000
        
        btn.Text = "ON"
        btn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        showNotification("👑 No Fog включен", true)
    else
        lighting.FogEnd = originalFogEnd
        
        btn.Text = "OFF"
        btn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        showNotification("👑 No Fog выключен", false)
    end
end

-- FOV
local function updateFOV(value)
    fovValue = value
    if fovEnabled then
        workspace.CurrentCamera.FieldOfView = fovValue
    end
end

local function toggleFOV(btn)
    fovEnabled = not fovEnabled
    
    if fovEnabled then
        workspace.CurrentCamera.FieldOfView = fovValue
        btn.Text = "ON"
        btn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        showNotification("👑 FOV Control включен", true)
    else
        workspace.CurrentCamera.FieldOfView = 70
        btn.Text = "OFF"
        btn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        showNotification("👑 FOV Control выключен", false)
    end
end

-- RAINBOW
local function toggleRainbow(btn)
    rainbowEnabled = not rainbowEnabled
    
    if rainbowEnabled then
        local hue = 0
        rainbowConnection = runService.RenderStepped:Connect(function()
            if not rainbowEnabled then return end
            hue = hue + 0.005
            if hue > 1 then hue = 0 end
            mainWindow.BorderColor3 = Color3.fromHSV(hue, 1, 1)
        end)
        
        btn.Text = "ON"
        btn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        showNotification("👑 Rainbow эффект включен", true)
    else
        if rainbowConnection then
            rainbowConnection:Disconnect()
            rainbowConnection = nil
        end
        mainWindow.BorderColor3 = Color3.fromRGB(255, 215, 0)
        
        btn.Text = "OFF"
        btn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        showNotification("👑 Rainbow эффект выключен", false)
    end
end

-- =============================================
-- ЭКСТРА ФУНКЦИИ (С ИСПРАВЛЕННЫМ ESP)
-- =============================================

-- INFINITE JUMP
local function toggleInfiniteJump(btn)
    infiniteJumpEnabled = not infiniteJumpEnabled
    
    if infiniteJumpEnabled then
        if infiniteJumpConnection then infiniteJumpConnection:Disconnect() end
        
        infiniteJumpConnection = userInputService.JumpRequest:Connect(function()
            if infiniteJumpEnabled and player.Character then
                local humanoid = player.Character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end)
        
        btn.Text = "ON"
        btn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        showNotification("👑 Infinite Jump включен", true)
    else
        if infiniteJumpConnection then
            infiniteJumpConnection:Disconnect()
            infiniteJumpConnection = nil
        end
        
        btn.Text = "OFF"
        btn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        showNotification("👑 Infinite Jump выключен", false)
    end
end

-- TELEPORT
local function toggleTeleport(btn)
    teleportEnabled = not teleportEnabled
    
    if teleportEnabled then
        local connection
        connection = userInputService.InputBegan:Connect(function(input)
            if teleportEnabled and input.KeyCode == Enum.KeyCode.T then
                local character = player.Character
                if character and mouse then
                    local rootPart = character:FindFirstChild("HumanoidRootPart")
                    if rootPart then
                        rootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
                        showNotification("👑 Телепорт выполнен", true)
                    end
                end
            end
        end)
        
        table.insert(godConnections, connection)
        
        btn.Text = "ON"
        btn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        showNotification("👑 Teleport включен (нажми T)", true)
    else
        btn.Text = "OFF"
        btn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        showNotification("👑 Teleport выключен", false)
    end
end

-- =============================================
-- ИСПРАВЛЕННЫЙ ESP
-- =============================================

local function createESPForPlayer(targetPlayer)
    if targetPlayer == player then return end
    if not targetPlayer.Character then return end
    
    local head = targetPlayer.Character:FindFirstChild("Head")
    if not head then return end
    
    -- Создаем BillboardGui для ESP
    local espGui = Instance.new("BillboardGui")
    espGui.Name = "PlayerESP_" .. targetPlayer.Name
    espGui.Parent = head
    espGui.AlwaysOnTop = true
    espGui.Size = UDim2.new(0, 100, 0, 50)
    espGui.StudsOffset = Vector3.new(0, 3, 0)
    
    -- Фон
    local background = Instance.new("Frame")
    background.Parent = espGui
    background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    background.BackgroundTransparency = 0.3
    background.Size = UDim2.new(1, 0, 1, 0)
    
    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(0, 4)
    bgCorner.Parent = background
    
    -- Имя игрока
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Parent = espGui
    nameLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Position = UDim2.new(0, 0, 0, 2)
    nameLabel.Size = UDim2.new(1, 0, 0, 20)
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Text = targetPlayer.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextSize = 14
    nameLabel.TextScaled = true
    
    -- Здоровье
    local healthLabel = Instance.new("TextLabel")
    healthLabel.Parent = espGui
    healthLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    healthLabel.BackgroundTransparency = 1
    healthLabel.Position = UDim2.new(0, 0, 0, 22)
    healthLabel.Size = UDim2.new(1, 0, 0, 16)
    healthLabel.Font = Enum.Font.Gotham
    healthLabel.Text = "❤️ 100"
    healthLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    healthLabel.TextSize = 12
    healthLabel.TextScaled = true
    
    -- Дистанция
    local distLabel = Instance.new("TextLabel")
    distLabel.Parent = espGui
    distLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    distLabel.BackgroundTransparency = 1
    distLabel.Position = UDim2.new(0, 0, 0, 38)
    distLabel.Size = UDim2.new(1, 0, 0, 12)
    distLabel.Font = Enum.Font.Gotham
    distLabel.Text = "0m"
    distLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    distLabel.TextSize = 10
    distLabel.TextScaled = true
    
    -- Обновление здоровья и дистанции
    local updateConnection
    updateConnection = runService.RenderStepped:Connect(function()
        if not espEnabled or not targetPlayer.Character or not targetPlayer.Character.Parent then
            if espGui then espGui:Destroy() end
            if updateConnection then updateConnection:Disconnect() end
            return
        end
        
        local humanoid = targetPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            healthLabel.Text = "❤️ " .. math.floor(humanoid.Health)
        end
        
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local myPos = player.Character.HumanoidRootPart.Position
            local targetPos = targetPlayer.Character.HumanoidRootPart.Position
            local dist = (myPos - targetPos).Magnitude
            distLabel.Text = math.floor(dist) .. "m"
        end
    end)
    
    table.insert(espObjects, espGui)
    table.insert(espObjects, updateConnection)
end

local function toggleESP(btn)
    espEnabled = not espEnabled
    
    if espEnabled then
        -- Очищаем старые ESP объекты
        for _, obj in ipairs(espObjects) do
            if obj and obj.Parent then
                obj:Destroy()
            end
        end
        espObjects = {}
        
        -- Создаем ESP для всех игроков
        for _, targetPlayer in ipairs(players:GetPlayers()) do
            createESPForPlayer(targetPlayer)
        end
        
        -- Следим за новыми игроками
        local playerAddedConn = players.PlayerAdded:Connect(function(newPlayer)
            if espEnabled then
                newPlayer.CharacterAdded:Connect(function()
                    wait(0.5)
                    createESPForPlayer(newPlayer)
                end)
            end
        end)
        table.insert(espObjects, playerAddedConn)
        
        -- Следим за персонажами существующих игроков
        for _, targetPlayer in ipairs(players:GetPlayers()) do
            if targetPlayer ~= player then
                targetPlayer.CharacterAdded:Connect(function()
                    wait(0.5)
                    createESPForPlayer(targetPlayer)
                end)
            end
        end
        
        btn.Text = "ON"
        btn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        showNotification("👑 ESP включен", true)
    else
        -- Удаляем все ESP
        for _, obj in ipairs(espObjects) do
            if obj and obj.Parent then
                obj:Destroy()
            end
        end
        espObjects = {}
        
        btn.Text = "OFF"
        btn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        showNotification("👑 ESP выключен", false)
    end
end

-- =============================================
-- СТРАНИЦА 1 (ОСНОВНЫЕ)
-- =============================================

local y1 = 10

local flyBtn = createButton(page1, "ПОЛЕТ (F)", y1, Color3.fromRGB(0, 200, 255), "Свободный полет по воздуху", toggleFly)
y1 = y1 + 60

local speedBtn = createButton(page1, "СПИД ХАК x" .. speedMultiplier, y1, Color3.fromRGB(255, 200, 0), "Увеличение скорости бега", toggleSpeed)
y1 = y1 + 60

local jumpBtn = createButton(page1, "ДЖАМП ХАК x" .. jumpMultiplier, y1, Color3.fromRGB(255, 150, 0), "Увеличение высоты прыжка", toggleJump)
y1 = y1 + 60

local noclipBtn = createButton(page1, "НОУКЛИП", y1, Color3.fromRGB(150, 100, 255), "Прохождение сквозь стены", toggleNoClip)
y1 = y1 + 60

local godBtn = createButton(page1, "БЕССМЕРТИЕ", y1, Color3.fromRGB(255, 50, 255), "Полная неуязвимость", toggleGod)

-- =============================================
-- СТРАНИЦА 2 (ВИЗУАЛ)
-- =============================================

local y2 = 10

local fullbrightBtn = createButton(page2, "FULLBRIGHT", y2, Color3.fromRGB(255, 255, 255), "Максимальная яркость", toggleFullbright)
y2 = y2 + 60

local noFogBtn = createButton(page2, "NO FOG", y2, Color3.fromRGB(200, 200, 255), "Убирает туман", toggleNoFog)
y2 = y2 + 60

local fovBtn = createButton(page2, "FOV CONTROL", y2, Color3.fromRGB(100, 255, 100), "Изменение угла обзора", toggleFOV)
y2 = y2 + 60

local fovSlider = createSlider(page2, "Угол обзора", y2, 70, 120, fovValue, "°", updateFOV)
y2 = y2 + 60

local rainbowBtn = createButton(page2, "RAINBOW", y2, Color3.fromRGB(255, 0, 255), "Радужные эффекты", toggleRainbow)

-- =============================================
-- СТРАНИЦА 3 (ЭКСТРА)
-- =============================================

local y3 = 10

local infiniteJumpBtn = createButton(page3, "INFINITE JUMP", y3, Color3.fromRGB(0, 255, 200), "Бесконечные прыжки", toggleInfiniteJump)
y3 = y3 + 60

local teleportBtn = createButton(page3, "TELEPORT (T)", y3, Color3.fromRGB(255, 100, 100), "Телепорт к курсору", toggleTeleport)
y3 = y3 + 60

local espBtn = createButton(page3, "ESP", y3, Color3.fromRGB(100, 255, 100), "Подсветка игроков (имя, здоровье, дистанция)", toggleESP)

-- =============================================
-- ГОРЯЧИЕ КЛАВИШИ
-- =============================================

userInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F then
        toggleFly(flyBtn)
    end
end)

-- =============================================
-- СЛЕДИМ ЗА ПЕРСОНАЖЕМ
-- =============================================

player.CharacterAdded:Connect(function(newChar)
    wait(1)
    
    if speedEnabled then
        local humanoid = newChar:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 16 * speedMultiplier
        end
    end
    
    if jumpEnabled then
        local humanoid = newChar:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.JumpPower = 50 * jumpMultiplier
        end
    end
    
    if godMode then
        local humanoid = newChar:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.MaxHealth = math.huge
            humanoid.Health = humanoid.MaxHealth
        end
    end
end)

print("=" .. string.rep("=", 50) .. "=")
print("👑 PREMIUM HUB v7.0 - С ИСПРАВЛЕННЫМ ESP")
print("=" .. string.rep("=", 50) .. "=")
print("✅ ОСНОВНЫЕ ФУНКЦИИ:")
print("   • Полет (клавиша F)")
print("   • Спид Хак x2.5")
print("   • Джамп Хак x2.5")
print("   • Ноуклип")
print("   • Бессмертие")
print("=" .. string.rep("=", 50) .. "=")
print("✨ ВИЗУАЛЬНЫЕ ФУНКЦИИ:")
print("   • Fullbright")
print("   • No Fog")
print("   • FOV Control")
print("   • Rainbow")
print("=" .. string.rep("=", 50) .. "=")
print("🎯 ЭКСТРА ФУНКЦИИ:")
print("   • Infinite Jump")
print("   • Teleport (клавиша T)")
print("   • ESP - показывает игроков ✓")
print("=" .. string.rep("=", 50) .. "=")
