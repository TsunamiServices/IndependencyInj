-- Carregar biblioteca de notificação
local Notification = loadstring(game:HttpGet("https://raw.githubusercontent.com/Jxereas/UI-Libraries/main/notification_gui_library.lua", true))()

-- Serviços
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SpawnRemote = workspace:WaitForChild("__THINGS"):WaitForChild("__REMOTES"):WaitForChild("vehicle_spawn")
local StopRemote = workspace:WaitForChild("__THINGS"):WaitForChild("__REMOTES"):WaitForChild("vehicle_stop")

-- Criar GUI principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BackgroundTransparency = 0.15
Frame.Position = UDim2.new(0.35, 0, 0.3, 0)
Frame.Size = UDim2.new(0, 340, 0, 210)

-- Cantos arredondados
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = Frame

-- Sombra
local UIStroke = Instance.new("UIStroke")
UIStroke.Parent = Frame
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(0, 200, 150)

-- Título
local Title = Instance.new("TextLabel")
Title.Parent = Frame
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.GothamBold
Title.Text = "🌊 Tsunami Menu"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20

-- Botão Dinheiro
local MoneyBtn = Instance.new("TextButton")
MoneyBtn.Parent = Frame
MoneyBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 127)
MoneyBtn.BackgroundTransparency = 0.1
MoneyBtn.Position = UDim2.new(0.1, 0, 0.3, 0)
MoneyBtn.Size = UDim2.new(0.8, 0, 0.25, 0)
MoneyBtn.Font = Enum.Font.GothamBold
MoneyBtn.Text = "💰 Ativar Dinheiro Infinito"
MoneyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MoneyBtn.TextSize = 16

local MoneyCorner = Instance.new("UICorner")
MoneyCorner.CornerRadius = UDim.new(0, 10)
MoneyCorner.Parent = MoneyBtn

-- Botão Fechar
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = Frame
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.BackgroundTransparency = 0.1
CloseBtn.Position = UDim2.new(0.1, 0, 0.65, 0)
CloseBtn.Size = UDim2.new(0.8, 0, 0.25, 0)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "❌ Fechar Menu"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 16

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 10)
CloseCorner.Parent = CloseBtn

-- Função: Drag do menu
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
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Função: Ativar dinheiro infinito
local function ativarDinheiro()
    Notification.new("info", "Processando", "Aguarde enquanto ativamos o dinheiro infinito...")
    SpawnRemote:InvokeServer()
    task.wait(0.2)
    player.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(9000000000e9, 90000000000e9, 9000000000e9)
    task.wait(0.2)
    StopRemote:InvokeServer()
    Notification.new("success", "Concluído", "O dinheiro foi depositado com sucesso!")
end

-- Eventos
MoneyBtn.MouseButton1Click:Connect(ativarDinheiro)
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Animação de entrada
Frame.Size = UDim2.new(0, 0, 0, 0)
Frame:TweenSize(UDim2.new(0, 340, 0, 210), "Out", "Back", 0.5, true)
