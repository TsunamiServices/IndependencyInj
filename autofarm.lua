-- Biblioteca de notificação
local Notification = loadstring(game:HttpGet("https://raw.githubusercontent.com/Jxereas/UI-Libraries/main/notification_gui_library.lua", true))()

-- Serviços
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local SpawnRemote = workspace:WaitForChild("__THINGS"):WaitForChild("__REMOTES"):WaitForChild("vehicle_spawn")
local StopRemote = workspace:WaitForChild("__THINGS"):WaitForChild("__REMOTES"):WaitForChild("vehicle_stop")

-- GUI principal
local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local Frame = Instance.new("Frame", ScreenGui)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Frame.BackgroundTransparency = 0.2
Frame.Size = UDim2.new(0, 280, 0, 140)
Frame.Position = UDim2.new(0.38, 0, 0.4, 0)

-- Cantos arredondados
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 12)

-- Borda azul neon
local UIStroke = Instance.new("UIStroke", Frame)
UIStroke.Color = Color3.fromRGB(0, 170, 255)
UIStroke.Thickness = 2

-- Título
local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, -35, 0, 28)
Title.Position = UDim2.new(0.05, 0, 0.05, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Text = "🌊 Tsunami Menu"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 17
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Botão fechar
local CloseBtn = Instance.new("TextButton", Frame)
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -28, 0.05, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "✖"
CloseBtn.TextColor3 = Color3.fromRGB(255, 90, 90)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16

-- Botão spawn manual
local MoneyBtn = Instance.new("TextButton", Frame)
MoneyBtn.Size = UDim2.new(0.6, -5, 0, 38)
MoneyBtn.Position = UDim2.new(0.05, 0, 0.4, 0)
MoneyBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 150)
MoneyBtn.BackgroundTransparency = 0.15
MoneyBtn.Text = "💰 Spawn"
MoneyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MoneyBtn.Font = Enum.Font.GothamBold
MoneyBtn.TextSize = 15
Instance.new("UICorner", MoneyBtn).CornerRadius = UDim.new(0, 8)

-- Botão toggle automático
local AutoBtn = Instance.new("TextButton", Frame)
AutoBtn.Size = UDim2.new(0.35, 0, 0, 38)
AutoBtn.Position = UDim2.new(0.63, 0, 0.4, 0)
AutoBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 200)
AutoBtn.BackgroundTransparency = 0.15
AutoBtn.Text = "🔄 OFF"
AutoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoBtn.Font = Enum.Font.GothamBold
AutoBtn.TextSize = 15
Instance.new("UICorner", AutoBtn).CornerRadius = UDim.new(0, 8)

-- Drag
local UIS = game:GetService("UserInputService")
local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
Frame.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end end)
UIS.InputChanged:Connect(function(input) if input == dragInput and dragging then update(input) end end)

-- Funções
local function spawnDinheiro()
    SpawnRemote:InvokeServer()
    task.wait(0.2)
    player.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(9000000000e9, 90000000000e9, 9000000000e9)
    task.wait(0.2)
    StopRemote:InvokeServer()
end

local function ativarDinheiro()
    Notification.new("info", "Processando", "Gerando dinheiro...")
    spawnDinheiro()
    Notification.new("success", "Concluído", "O dinheiro foi depositado!")
end

-- Toggle automático
local autoAtivo = false
local function toggleAuto()
    autoAtivo = not autoAtivo
    if autoAtivo then
        AutoBtn.Text = "🔄 ON"
        AutoBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        Notification.new("success", "Automático Ligado", "Gerando dinheiro automaticamente.")
        task.spawn(function()
            while autoAtivo do
                spawnDinheiro()
                task.wait(3)
            end
        end)
    else
        AutoBtn.Text = "🔄 OFF"
        AutoBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 200)
        Notification.new("info", "Automático Desligado", "Parou o modo automático.")
    end
end

-- Eventos
MoneyBtn.MouseButton1Click:Connect(ativarDinheiro)
AutoBtn.MouseButton1Click:Connect(toggleAuto)
CloseBtn.MouseButton1Click:Connect(function() autoAtivo = false ScreenGui:Destroy() end)

-- Animação de entrada
Frame.Size = UDim2.new(0, 0, 0, 0)
Frame:TweenSize(UDim2.new(0, 280, 0, 140), "Out", "Back", 0.4, true)
