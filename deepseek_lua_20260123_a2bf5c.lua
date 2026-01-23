local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local PhysicsService = game:GetService("PhysicsService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- LIMPEZA DE VERSÕES ANTERIORES
if PlayerGui:FindFirstChild("CaiHub_Ultimate_V9") then PlayerGui.CaiHub_Ultimate_V9:Destroy() end

-- 1. ESTRUTURA PRINCIPAL
local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.Name = "CaiHub_Ultimate_V9"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

-- 2. PAINEL PRINCIPAL
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.Size = UDim2.new(0, 0, 0, 280)
MainFrame.ClipsDescendants = true
MainFrame.Visible = false
MainFrame.ZIndex = 5
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Thickness = 3; MainStroke.Color = Color3.fromRGB(0, 255, 255)

-- Barra de Arrastar (Área do Título)
local DragBar = Instance.new("Frame", MainFrame)
DragBar.Name = "DragBar"; DragBar.Size = UDim2.new(1, 0, 0, 40); DragBar.BackgroundTransparency = 1; DragBar.ZIndex = 15

-- 3. CABEÇALHO E LINHAS NEON
local Title = Instance.new("TextLabel", MainFrame)
Title.Text = "CAI HUB"; Title.Position = UDim2.new(0, 48, 0, 8); Title.Size = UDim2.new(0, 150, 0, 28)
Title.TextColor3 = Color3.fromRGB(255, 255, 255); Title.Font = Enum.Font.GothamBold; Title.TextSize = 18; Title.BackgroundTransparency = 1; Title.ZIndex = 10; Title.TextXAlignment = 0

local Logo = Instance.new("Frame", MainFrame)
Logo.Size = UDim2.new(0, 28, 0, 28); Logo.Position = UDim2.new(0, 12, 0, 8); Logo.BackgroundColor3 = Color3.fromRGB(0, 255, 255); Logo.ZIndex = 10; Instance.new("UICorner", Logo).CornerRadius = UDim.new(1, 0)
local LT = Instance.new("TextLabel", Logo); LT.Text = "C"; LT.Size = UDim2.new(1,0,1,0); LT.BackgroundTransparency = 1; LT.TextColor3 = Color3.fromRGB(0,0,0); LT.Font = Enum.Font.GothamBold; LT.ZIndex = 11

local LineH = Instance.new("Frame", MainFrame); LineH.Position = UDim2.new(0, 10, 0, 42); LineH.Size = UDim2.new(0, 440, 0, 2); LineH.BackgroundColor3 = Color3.fromRGB(0, 255, 255); LineH.ZIndex = 8
local LineV = Instance.new("Frame", MainFrame); LineV.Position = UDim2.new(0, 135, 0, 50); LineV.Size = UDim2.new(0, 2, 0, 215); LineV.BackgroundColor3 = Color3.fromRGB(0, 255, 255); LineV.ZIndex = 8

-- 4. SISTEMA DE ABAS
local Sidebar = Instance.new("Frame", MainFrame); Sidebar.Position = UDim2.new(0, 8, 0, 55); Sidebar.Size = UDim2.new(0, 120, 0, 215); Sidebar.BackgroundTransparency = 1; Sidebar.ZIndex = 10
Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 5)
local PageContainer = Instance.new("Frame", MainFrame); PageContainer.Position = UDim2.new(0, 145, 0, 55); PageContainer.Size = UDim2.new(0, 305, 0, 215); PageContainer.BackgroundTransparency = 1; PageContainer.ZIndex = 10

local Pages = {}
local SidebarButtons = {}
local firstPageOpened = false
local lastOpenPage = "Configurar"

local function createPage(name)
    local p = Instance.new("ScrollingFrame", PageContainer); p.Name = name; p.Size = UDim2.new(1, 0, 1, 0); p.BackgroundTransparency = 1; p.Visible = false; p.ScrollBarThickness = 0; p.ZIndex = 10
    local layout = Instance.new("UIListLayout", p)
    layout.Padding = UDim.new(0, 6)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    Pages[name] = p; return p
end

local function addTab(name, isFirstPage)
    local b = Instance.new("TextButton", Sidebar); b.Size = UDim2.new(1, 0, 0, 35); b.BackgroundColor3 = Color3.fromRGB(25, 25, 28); b.Text = name; b.TextColor3 = Color3.fromRGB(150, 150, 150); b.Font = Enum.Font.GothamMedium; b.ZIndex = 11; Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    local s = Instance.new("UIStroke", b); s.Color = Color3.fromRGB(0, 255, 255); s.Transparency = 1; b.Name = name
    b.MouseButton1Click:Connect(function()
        for n, pg in pairs(Pages) do pg.Visible = (n == name) end
        for n, btn in pairs(SidebarButtons) do btn.TextColor3 = Color3.fromRGB(150, 150, 150); btn.UIStroke.Transparency = 1 end
        b.TextColor3 = Color3.fromRGB(255, 255, 255); s.Transparency = 0
        lastOpenPage = name
    end)
    SidebarButtons[name] = b
    
    if isFirstPage and not firstPageOpened then
        firstPageOpened = true
        b.TextColor3 = Color3.fromRGB(255, 255, 255)
        s.Transparency = 0
        lastOpenPage = name
    end
    
    return b
end

local function addFunction(page, text, callback)
    local rb = Instance.new("TextButton", page); rb.Size = UDim2.new(0, 280, 0, 35); rb.BackgroundColor3 = Color3.fromRGB(30, 30, 35); rb.Text = "  " .. text; rb.TextColor3 = Color3.fromRGB(255, 255, 255); rb.Font = Enum.Font.GothamMedium; rb.TextSize = 13; rb.TextXAlignment = 0; rb.ZIndex = 12; Instance.new("UICorner", rb).CornerRadius = UDim.new(0, 6)
    rb.MouseButton1Click:Connect(callback)
    return rb
end

-- 5. LÓGICA ESP (AURA + TAGS)
local espEnabled = false

local function createEspTag(char, player)
    local head = char:WaitForChild("Head", 5)
    if not head then return end
    
    local billboard = Instance.new("BillboardGui", head)
    billboard.Name = "CaiTag"
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.Adornee = head
    billboard.AlwaysOnTop = true
    billboard.ExtentsOffset = Vector3.new(0, 3, 0)

    local label = Instance.new("TextLabel", billboard)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(0, 255, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.TextStrokeTransparency = 0

    RunService.RenderStepped:Connect(function()
        if char and char:FindFirstChild("HumanoidRootPart") and player then
            local dist = math.floor((Player.Character.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude)
            local health = math.floor(char.Humanoid.Health)
            label.Text = string.format("%s\n[%d m] HP: %d", player.Name, dist, health)
            billboard.Enabled = espEnabled
        else
            billboard:Destroy()
        end
    end)
end

local function applyESP(v)
    if v ~= Player then
        v.CharacterAdded:Connect(function(char)
            task.wait(0.5)
            createEspTag(char, v)
        end)
        if v.Character then createEspTag(v.Character, v) end
    end
end

for _, v in pairs(Players:GetPlayers()) do applyESP(v) end
Players.PlayerAdded:Connect(applyESP)

RunService.RenderStepped:Connect(function()
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= Player and v.Character then
            local high = v.Character:FindFirstChild("CaiAura")
            if espEnabled then
                if not high then
                    high = Instance.new("Highlight", v.Character)
                    high.Name = "CaiAura"; high.FillColor = Color3.fromRGB(0, 255, 255); high.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                end
            elseif high then high:Destroy() end
        end
    end
end)

local function createSlider(page, text, min, max, default, callback)
    local container = Instance.new("Frame", page)
    container.Size = UDim2.new(0, 280, 0, 50)
    container.BackgroundTransparency = 1
    container.ZIndex = 12
    
    local label = Instance.new("TextLabel", container)
    label.Size = UDim2.new(0, 180, 0, 20)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 12
    
    local valueLabel = Instance.new("TextLabel", container)
    valueLabel.Size = UDim2.new(0, 50, 0, 20)
    valueLabel.Position = UDim2.new(1, -50, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 14
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.ZIndex = 12
    
    local sliderBg = Instance.new("Frame", container)
    sliderBg.Size = UDim2.new(1, 0, 0, 18)
    sliderBg.Position = UDim2.new(0, 0, 0, 28)
    sliderBg.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
    sliderBg.ZIndex = 12
    Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(0, 6)
    
    local sliderFill = Instance.new("Frame", sliderBg)
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
    sliderFill.ZIndex = 13
    Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(0, 6)
    
    local sliderButton = Instance.new("TextButton", sliderBg)
    sliderButton.Size = UDim2.new(1, 0, 1, 0)
    sliderButton.BackgroundTransparency = 1
    sliderButton.Text = ""
    sliderButton.ZIndex = 14
    
    local isDragging = false
    local function updateSlider(input)
        local relativeX = (input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X
        relativeX = math.clamp(relativeX, 0, 1)
        
        local value = math.floor(min + (max - min) * relativeX)
        sliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
        valueLabel.Text = tostring(value)
        
        callback(value)
    end
    
    sliderButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            updateSlider(input)
        end
    end)
    
    sliderButton.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)
    
    sliderButton.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
        end
    end)
    
    return container
end

local currentSpeed = 16
local currentJump = 50

-- Loop para aplicar velocidade continuamente
RunService.RenderStepped:Connect(function()
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        pcall(function()
            Player.Character.Humanoid.WalkSpeed = currentSpeed
        end)
        
        pcall(function()
            Player.Character.Humanoid.JumpPower = currentJump
            Player.Character.Humanoid.UseJumpPower = true
        end)
    end
end)

-- 6. SISTEMA DE NOCOLLIDE (SEM COLISÃO)
local noCollideEnabled = false
local originalCollisionGroups = {}
local noCollideGroupName = "CaiNoCollide"

-- Criar grupo de colisão personalizado
if not PhysicsService:IsCollisionGroupRegistered(noCollideGroupName) then
    PhysicsService:RegisterCollisionGroup(noCollideGroupName)
end

-- Configurar para não colidir com o grupo padrão
PhysicsService:CollisionGroupSetCollidable(noCollideGroupName, "Default", false)
PhysicsService:CollisionGroupSetCollidable(noCollideGroupName, noCollideGroupName, false)

-- Função para aplicar noCollide ao personagem
local function applyNoCollide(character)
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            -- Salvar grupo original
            originalCollisionGroups[part] = part.CollisionGroupId
            -- Aplicar novo grupo
            part.CollisionGroup = noCollideGroupName
        end
    end
end

-- Função para remover noCollide do personagem
local function removeNoCollide(character)
    for part, originalGroupId in pairs(originalCollisionGroups) do
        if part.Parent then
            local originalGroupName = PhysicsService:GetCollisionGroupName(originalGroupId)
            if originalGroupName then
                part.CollisionGroup = originalGroupName
            else
                part.CollisionGroup = "Default"
            end
        end
    end
    originalCollisionGroups = {}
end

-- Loop para manter noCollide ativo
RunService.RenderStepped:Connect(function()
    if noCollideEnabled and Player.Character then
        -- Verificar se todas as partes estão no grupo correto
        for _, part in pairs(Player.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CollisionGroup ~= noCollideGroupName then
                if not originalCollisionGroups[part] then
                    originalCollisionGroups[part] = part.CollisionGroupId
                end
                part.CollisionGroup = noCollideGroupName
            end
        end
    end
end)

-- 7. CONFIGURAÇÃO DAS ABAS
addTab("Configurar", true)
local pConfig = createPage("Configurar")

addFunction(pConfig, "Rejoin", function() 
    game:GetService("TeleportService"):Teleport(game.PlaceId, Player) 
end)

addFunction(pConfig, "Fechar Hub", function() 
    ScreenGui:Destroy() 
end)

addTab("Jogadores", false)
local pPlayers = createPage("Jogadores")

local espButton = addFunction(pPlayers, "Ativar ESP (Aura + Nomes)", function() 
    espEnabled = not espEnabled
    if espEnabled then
        espButton.Text = "  Desativar ESP (Aura + Nomes)"
    else
        espButton.Text = "  Ativar ESP (Aura + Nomes)"
    end
end)

-- Botão para ativar/desativar NoCollide
local noCollideButton = addFunction(pPlayers, "Ativar NoCollide (Sem Colisão)", function() 
    noCollideEnabled = not noCollideEnabled
    
    if noCollideEnabled then
        noCollideButton.Text = "  Desativar NoCollide (Sem Colisão)"
        if Player.Character then
            applyNoCollide(Player.Character)
        end
    else
        noCollideButton.Text = "  Ativar NoCollide (Sem Colisão)"
        if Player.Character then
            removeNoCollide(Player.Character)
        end
    end
end)

createSlider(pPlayers, "Velocidade", 0, 1000, 16, function(value)
    currentSpeed = value
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        pcall(function()
            Player.Character.Humanoid.WalkSpeed = value
        end)
    end
end)

createSlider(pPlayers, "Pulo", 0, 1000, 50, function(value)
    currentJump = value
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        pcall(function()
            Player.Character.Humanoid.JumpPower = value
            Player.Character.Humanoid.UseJumpPower = true
        end)
    end
end)

-- Aplicar quando o personagem spawnar
Player.CharacterAdded:Connect(function(character)
    character:WaitForChild("Humanoid")
    task.wait(0.5)
    
    pcall(function()
        character.Humanoid.WalkSpeed = currentSpeed
    end)
    
    pcall(function()
        character.Humanoid.JumpPower = currentJump
        character.Humanoid.UseJumpPower = true
    end)
    
    -- Aplicar noCollide se estiver ativado
    if noCollideEnabled then
        applyNoCollide(character)
    end
end)

-- Aplicar se já tiver personagem
if Player.Character and Player.Character:FindFirstChild("Humanoid") then
    pcall(function()
        Player.Character.Humanoid.WalkSpeed = currentSpeed
    end)
    
    pcall(function()
        Player.Character.Humanoid.JumpPower = currentJump
        Player.Character.Humanoid.UseJumpPower = true
    end)
    
    -- Aplicar noCollide se estiver ativado
    if noCollideEnabled then
        applyNoCollide(Player.Character)
    end
end

-- 8. TOGGLE DO GUI
local Toggle = Instance.new("Frame", ScreenGui); Toggle.Size = UDim2.new(0, 55, 0, 55); Toggle.Position = UDim2.new(0.05, 0, 0.2, 0); Toggle.BackgroundColor3 = Color3.fromRGB(15, 15, 18); Toggle.ZIndex = 20; Instance.new("UICorner", Toggle).CornerRadius = UDim.new(1, 0); Instance.new("UIStroke", Toggle).Color = Color3.fromRGB(0, 255, 255)
local TBtn = Instance.new("TextButton", Toggle); TBtn.Size = UDim2.new(1,0,1,0); TBtn.BackgroundTransparency = 1; TBtn.Text = "C"; TBtn.TextColor3 = Color3.fromRGB(0,255,255); TBtn.Font = Enum.Font.GothamBold; TBtn.TextSize = 25; TBtn.ZIndex = 25

local function makeDraggable(obj, handle)
    local dragging, dragInput, dragStart, startPos
    handle.InputBegan:Connect(function(input) 
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
            dragging = true; 
            dragStart = input.Position; 
            startPos = obj.Position 
        end 
    end)
    handle.InputChanged:Connect(function(input) 
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then 
            local delta = input.Position - dragStart; 
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) 
        end 
    end)
    UserInputService.InputEnded:Connect(function() 
        dragging = false 
    end)
end

makeDraggable(MainFrame, DragBar)
makeDraggable(Toggle, TBtn)

local isOpen = false
TBtn.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    if isOpen then
        MainFrame.Visible = true
        MainFrame:TweenSize(UDim2.new(0, 460, 0, 280), "Out", "Quart", 0.5, true)
        
        for n, pg in pairs(Pages) do 
            pg.Visible = (n == lastOpenPage)
        end
        
        for n, btn in pairs(SidebarButtons) do 
            if n == lastOpenPage then
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                if btn:FindFirstChild("UIStroke") then
                    btn.UIStroke.Transparency = 0
                end
            else
                btn.TextColor3 = Color3.fromRGB(150, 150, 150)
                if btn:FindFirstChild("UIStroke") then
                    btn.UIStroke.Transparency = 1
                end
            end
        end
    else
        MainFrame:TweenSize(UDim2.new(0, 0, 0, 280), "In", "Quart", 0.4, true)
        task.wait(0.4)
        MainFrame.Visible = false
    end
end)