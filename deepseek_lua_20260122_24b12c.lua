--// SERVIÇOS
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

--// CONFIGURAÇÕES
local SCREEN_SAFE_ZONE = 20 -- Margem segura para telas de celular
local GUI_WIDTH = 450
local GUI_HEIGHT = 650
local ANIMATION_SPEED = 0.3

--// GUI PRINCIPAL
local mainGui = Instance.new("ScreenGui", player.PlayerGui)
mainGui.Name = "CaioHubGUI"
mainGui.ResetOnSpawn = false
mainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

--// FUNDO SEMITRANSPARENTE
local overlay = Instance.new("Frame", mainGui)
overlay.Size = UDim2.fromScale(1, 1)
overlay.BackgroundColor3 = Color3.new(0, 0, 0)
overlay.BackgroundTransparency = 0.6
overlay.ZIndex = 1
overlay.Visible = false

--// JANELA PRINCIPAL (3D EFFECT)
local mainWindow = Instance.new("Frame", mainGui)
mainWindow.Size = UDim2.fromOffset(GUI_WIDTH, GUI_HEIGHT)
mainWindow.AnchorPoint = Vector2.new(0.5, 0.5)
mainWindow.Position = UDim2.fromScale(0.5, 0.5)
mainWindow.BackgroundColor3 = Color3.new(0.05, 0.05, 0.05)
mainWindow.BorderSizePixel = 0
mainWindow.ZIndex = 10
mainWindow.ClipsDescendants = true
mainWindow.Visible = false

-- Efeito 3D com sombras múltiplas
local shadows = {}
for i = 1, 3 do
    local shadow = Instance.new("Frame", mainGui)
    shadow.Size = mainWindow.Size
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.Position = mainWindow.Position + UDim2.fromOffset(i*2, i*2)
    shadow.BackgroundColor3 = Color3.new(1, 0, 0)
    shadow.BackgroundTransparency = 0.8 - (i * 0.2)
    shadow.BorderSizePixel = 0
    shadow.ZIndex = 9 - i
    shadow.Visible = false
    table.insert(shadows, shadow)
end

-- Borda vermelha brilhante
local borderGlow = Instance.new("Frame", mainWindow)
borderGlow.Size = UDim2.fromScale(1, 1)
borderGlow.BackgroundTransparency = 1
borderGlow.ZIndex = 11

local borderTop = Instance.new("Frame", borderGlow)
borderTop.Size = UDim2.new(1, 0, 0, 3)
borderTop.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
borderTop.BorderSizePixel = 0

local borderBottom = Instance.new("Frame", borderGlow)
borderBottom.Size = UDim2.new(1, 0, 0, 3)
borderBottom.Position = UDim2.new(0, 0, 1, -3)
borderBottom.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
borderBottom.BorderSizePixel = 0

local borderLeft = Instance.new("Frame", borderGlow)
borderLeft.Size = UDim2.new(0, 3, 1, 0)
borderLeft.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
borderLeft.BorderSizePixel = 0

local borderRight = Instance.new("Frame", borderGlow)
borderRight.Size = UDim2.new(0, 3, 1, 0)
borderRight.Position = UDim2.new(1, -3, 0, 0)
borderRight.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
borderRight.BorderSizePixel = 0

-- Efeito de brilho pulsante nas bordas
task.spawn(function()
    while borderGlow.Parent do
        TweenService:Create(borderTop, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            BackgroundTransparency = 0.2
        }):Play()
        TweenService:Create(borderBottom, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            BackgroundTransparency = 0.2
        }):Play()
        TweenService:Create(borderLeft, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            BackgroundTransparency = 0.2
        }):Play()
        TweenService:Create(borderRight, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            BackgroundTransparency = 0.2
        }):Play()
        task.wait(1.5)
        
        TweenService:Create(borderTop, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            BackgroundTransparency = 0
        }):Play()
        TweenService:Create(borderBottom, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            BackgroundTransparency = 0
        }):Play()
        TweenService:Create(borderLeft, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            BackgroundTransparency = 0
        }):Play()
        TweenService:Create(borderRight, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            BackgroundTransparency = 0
        }):Play()
        task.wait(1.5)
    end
end)

--// CABEÇALHO DA JANELA
local header = Instance.new("Frame", mainWindow)
header.Size = UDim2.new(1, 0, 0, 50)
header.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
header.BorderSizePixel = 0
header.ZIndex = 12

-- Logo no cabeçalho
local logoContainer = Instance.new("Frame", header)
logoContainer.Size = UDim2.new(0, 120, 1, 0)
logoContainer.BackgroundTransparency = 1

local logoText = Instance.new("TextLabel", logoContainer)
logoText.Size = UDim2.fromScale(1, 1)
logoText.BackgroundTransparency = 1
logoText.Text = "CAIO HUB"
logoText.Font = Enum.Font.GothamBlack
logoText.TextSize = 22
logoText.TextColor3 = Color3.fromRGB(255, 50, 50)
logoText.TextXAlignment = Enum.TextXAlignment.Left
logoText.Position = UDim2.new(0, 15, 0, 0)

-- Efeito de brilho no logo
local logoGlow = Instance.new("UIGradient", logoText)
logoGlow.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 100)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 100, 100))
}

task.spawn(function()
    while logoGlow.Parent do
        logoGlow.Offset = Vector2.new(-0.5, 0)
        TweenService:Create(logoGlow, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Offset = Vector2.new(0.5, 0)
        }):Play()
        task.wait(2.2)
    end
end)

-- Botão Fechar (X)
local closeButton = Instance.new("TextButton", header)
closeButton.Size = UDim2.fromOffset(40, 40)
closeButton.Position = UDim2.new(1, -45, 0.5, -20)
closeButton.AnchorPoint = Vector2.new(0, 0.5)
closeButton.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
closeButton.Text = "X"
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 20
closeButton.TextColor3 = Color3.fromRGB(255, 100, 100)
closeButton.BorderSizePixel = 0
closeButton.ZIndex = 13

-- Arredondar botão fechar
local closeCorner = Instance.new("UICorner", closeButton)
closeCorner.CornerRadius = UDim.new(0, 8)

-- Animações do botão fechar
closeButton.MouseEnter:Connect(function()
    TweenService:Create(closeButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(255, 50, 50),
        TextColor3 = Color3.new(1, 1, 1),
        Size = UDim2.fromOffset(42, 42)
    }):Play()
end)

closeButton.MouseLeave:Connect(function()
    TweenService:Create(closeButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.new(0.15, 0.15, 0.15),
        TextColor3 = Color3.fromRGB(255, 100, 100),
        Size = UDim2.fromOffset(40, 40)
    }):Play()
end)

--// ÁREA DE CONTEÚDO (DIVIDIDA EM 2 PARTES)
local contentArea = Instance.new("Frame", mainWindow)
contentArea.Size = UDim2.new(1, 0, 1, -50)
contentArea.Position = UDim2.new(0, 0, 0, 50)
contentArea.BackgroundTransparency = 1

-- Divisor central
local divider = Instance.new("Frame", contentArea)
divider.Size = UDim2.new(0, 3, 1, -20)
divider.Position = UDim2.new(0.3, 0, 0, 10)
divider.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
divider.BorderSizePixel = 0

-- Efeito de brilho no divisor
local dividerGlow = Instance.new("UIGradient", divider)
dividerGlow.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 100)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 100, 100))
}
dividerGlow.Rotation = 90

-- SEÇÃO ESQUERDA (BOTÕES)
local leftSection = Instance.new("Frame", contentArea)
leftSection.Size = UDim2.new(0.3, -5, 1, -20)
leftSection.Position = UDim2.new(0, 10, 0, 10)
leftSection.BackgroundTransparency = 1

-- Título seção botões
local buttonsTitle = Instance.new("TextLabel", leftSection)
buttonsTitle.Size = UDim2.new(1, 0, 0, 40)
buttonsTitle.BackgroundTransparency = 1
buttonsTitle.Text = "MENU"
buttonsTitle.Font = Enum.Font.GothamBold
buttonsTitle.TextSize = 18
buttonsTitle.TextColor3 = Color3.fromRGB(255, 100, 100)
buttonsTitle.TextXAlignment = Enum.TextXAlignment.Left

-- Lista de botões
local buttonsContainer = Instance.new("ScrollingFrame", leftSection)
buttonsContainer.Size = UDim2.new(1, 0, 1, -50)
buttonsContainer.Position = UDim2.new(0, 0, 0, 50)
buttonsContainer.BackgroundTransparency = 1
buttonsContainer.BorderSizePixel = 0
buttonsContainer.ScrollBarThickness = 4
buttonsContainer.ScrollBarImageColor3 = Color3.fromRGB(255, 50, 50)

local buttonsList = Instance.new("UIListLayout", buttonsContainer)
buttonsList.Padding = UDim.new(0, 10)
buttonsList.SortOrder = Enum.SortOrder.LayoutOrder

-- SEÇÃO DIREITA (RESULTADOS)
local rightSection = Instance.new("Frame", contentArea)
rightSection.Size = UDim2.new(0.7, -25, 1, -20)
rightSection.Position = UDim2.new(0.3, 15, 0, 10)
rightSection.BackgroundTransparency = 1

-- Título seção resultados
local resultsTitle = Instance.new("TextLabel", rightSection)
resultsTitle.Size = UDim2.new(1, 0, 0, 40)
resultsTitle.BackgroundTransparency = 1
resultsTitle.Text = "RESULTADO"
resultsTitle.Font = Enum.Font.GothamBold
resultsTitle.TextSize = 18
resultsTitle.TextColor3 = Color3.fromRGB(255, 100, 100)
resultsTitle.TextXAlignment = Enum.TextXAlignment.Left

-- Área de resultados
local resultsContainer = Instance.new("Frame", rightSection)
resultsContainer.Size = UDim2.new(1, 0, 1, -50)
resultsContainer.Position = UDim2.new(0, 0, 0, 50)
resultsContainer.BackgroundColor3 = Color3.new(0.08, 0.08, 0.08)
resultsContainer.BorderSizePixel = 0

-- Arredondar resultados
local resultsCorner = Instance.new("UICorner", resultsContainer)
resultsCorner.CornerRadius = UDim.new(0, 8)

-- Texto de resultado padrão
local defaultResult = Instance.new("TextLabel", resultsContainer)
defaultResult.Size = UDim2.fromScale(1, 1)
defaultResult.BackgroundTransparency = 1
defaultResult.Text = "Selecione uma opção no menu"
defaultResult.Font = Enum.Font.Gotham
defaultResult.TextSize = 16
defaultResult.TextColor3 = Color3.fromRGB(200, 200, 200)
defaultResult.TextWrapped = true

--// FUNÇÃO PARA CRIAR BOTÕES
local function createButton(text, icon)
    local button = Instance.new("TextButton", buttonsContainer)
    button.Size = UDim2.new(1, 0, 0, 50)
    button.BackgroundColor3 = Color3.new(0.12, 0.12, 0.12)
    button.Text = ""
    button.BorderSizePixel = 0
    button.AutoButtonColor = false
    
    -- Arredondar botão
    local buttonCorner = Instance.new("UICorner", button)
    buttonCorner.CornerRadius = UDim.new(0, 6)
    
    -- Borda vermelha sutil
    local buttonBorder = Instance.new("Frame", button)
    buttonBorder.Size = UDim2.fromScale(1, 1)
    buttonBorder.BackgroundTransparency = 1
    buttonBorder.BorderSizePixel = 2
    buttonBorder.BorderColor3 = Color3.fromRGB(255, 0, 0)
    buttonBorder.BorderMode = Enum.BorderMode.Inset
    
    local borderCorner = Instance.new("UICorner", buttonBorder)
    borderCorner.CornerRadius = UDim.new(0, 6)
    
    -- Container do conteúdo
    local content = Instance.new("Frame", button)
    content.Size = UDim2.fromScale(1, 1)
    content.BackgroundTransparency = 1
    
    -- Ícone (se fornecido)
    if icon then
        local iconLabel = Instance.new("TextLabel", content)
        iconLabel.Size = UDim2.fromOffset(30, 30)
        iconLabel.Position = UDim2.new(0, 15, 0.5, -15)
        iconLabel.AnchorPoint = Vector2.new(0, 0.5)
        iconLabel.BackgroundTransparency = 1
        iconLabel.Text = icon
        iconLabel.Font = Enum.Font.GothamBold
        iconLabel.TextSize = 18
        iconLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
    
    -- Texto do botão
    local textLabel = Instance.new("TextLabel", content)
    textLabel.Size = UDim2.new(1, -60, 1, 0)
    textLabel.Position = UDim2.new(0, 60, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.Font = Enum.Font.Gotham
    textLabel.TextSize = 16
    textLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Seta indicadora
    local arrow = Instance.new("TextLabel", content)
    arrow.Size = UDim2.fromOffset(20, 20)
    arrow.Position = UDim2.new(1, -25, 0.5, -10)
    arrow.AnchorPoint = Vector2.new(1, 0.5)
    arrow.BackgroundTransparency = 1
    arrow.Text = ">"
    arrow.Font = Enum.Font.GothamBold
    arrow.TextSize = 16
    arrow.TextColor3 = Color3.fromRGB(255, 100, 100)
    
    -- Animações do botão
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.new(0.18, 0.18, 0.18)
        }):Play()
        TweenService:Create(arrow, TweenInfo.new(0.2), {
            TextColor3 = Color3.fromRGB(255, 50, 50),
            Position = UDim2.new(1, -20, 0.5, -10)
        }):Play()
        TweenService:Create(buttonBorder, TweenInfo.new(0.2), {
            BorderColor3 = Color3.fromRGB(255, 100, 100)
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.new(0.12, 0.12, 0.12)
        }):Play()
        TweenService:Create(arrow, TweenInfo.new(0.2), {
            TextColor3 = Color3.fromRGB(255, 100, 100),
            Position = UDim2.new(1, -25, 0.5, -10)
        }):Play()
        TweenService:Create(buttonBorder, TweenInfo.new(0.2), {
            BorderColor3 = Color3.fromRGB(255, 0, 0)
        }):Play()
    end)
    
    button.MouseButton1Down:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.new(0.08, 0.08, 0.08)
        }):Play()
    end)
    
    button.MouseButton1Up:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.new(0.18, 0.18, 0.18)
        }):Play()
    end)
    
    return button
end

--// EXEMPLOS DE BOTÕES
local buttons = {
    {text = "OPÇÃO 1", icon = "①", result = "Resultado da Opção 1\n\nEsta é a descrição detalhada do que acontece quando você seleciona esta opção."},
    {text = "OPÇÃO 2", icon = "②", result = "Resultado da Opção 2\n\nEste é outro exemplo de resultado que pode ser exibido na área de resultados."},
    {text = "OPÇÃO 3", icon = "③", result = "Resultado da Opção 3\n\nMais informações sobre esta funcionalidade específica do hub."},
    {text = "OPÇÃO 4", icon = "④", result = "Resultado da Opção 4\n\nDescrição completa da quarta opção disponível no menu."},
    {text = "OPÇÃO 5", icon = "⑤", result = "Resultado da Opção 5\n\nÚltima opção de exemplo para demonstração da interface."},
}

for i, btnData in ipairs(buttons) do
    local button = createButton(btnData.text, btnData.icon)
    
    button.MouseButton1Click:Connect(function()
        -- Animação de clique
        TweenService:Create(button, TweenInfo.new(0.15), {
            BackgroundColor3 = Color3.fromRGB(40, 10, 10)
        }):Play()
        
        task.wait(0.15)
        
        TweenService:Create(button, TweenInfo.new(0.15), {
            BackgroundColor3 = Color3.new(0.18, 0.18, 0.18)
        }):Play()
        
        -- Atualizar resultado
        defaultResult.Text = btnData.result
        
        -- Efeito de transição no resultado
        resultsContainer.BackgroundTransparency = 0.5
        TweenService:Create(resultsContainer, TweenInfo.new(0.3), {
            BackgroundTransparency = 0
        }):Play()
    end)
end

--// SISTEMA DE ARRASTAR A JANELA
local dragging = false
local dragStartPos
local windowStartPos

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStartPos = input.Position
        windowStartPos = mainWindow.Position
        
        -- Efeito visual ao segurar
        TweenService:Create(header, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
        }):Play()
    end
end)

header.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
        
        TweenService:Create(header, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
        }):Play()
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStartPos
        local newPos = UDim2.new(
            windowStartPos.X.Scale,
            windowStartPos.X.Offset + delta.X,
            windowStartPos.Y.Scale,
            windowStartPos.Y.Offset + delta.Y
        )
        
        -- Limitar movimento dentro da tela
        local viewportSize = workspace.CurrentCamera.ViewportSize
        local windowSize = mainWindow.AbsoluteSize
        
        local minX = SCREEN_SAFE_ZONE
        local maxX = viewportSize.X - windowSize.X - SCREEN_SAFE_ZONE
        local minY = SCREEN_SAFE_ZONE
        local maxY = viewportSize.Y - windowSize.Y - SCREEN_SAFE_ZONE
        
        local absX = newPos.X.Offset
        local absY = newPos.Y.Offset
        
        absX = math.clamp(absX, minX, maxX)
        absY = math.clamp(absY, minY, maxY)
        
        newPos = UDim2.new(newPos.X.Scale, absX, newPos.Y.Scale, absY)
        
        mainWindow.Position = newPos
        
        -- Atualizar sombras
        for i, shadow in ipairs(shadows) do
            shadow.Position = newPos + UDim2.fromOffset(i*2, i*2)
        end
    end
end)

--// FUNÇÃO PARA MOSTRAR A GUI
local function showGUI()
    -- Mostrar overlay
    overlay.Visible = true
    overlay.BackgroundTransparency = 1
    TweenService:Create(overlay, TweenInfo.new(0.5), {
        BackgroundTransparency = 0.6
    }):Play()
    
    -- Mostrar sombras
    for _, shadow in ipairs(shadows) do
        shadow.Visible = true
        shadow.BackgroundTransparency = 1
        TweenService:Create(shadow, TweenInfo.new(0.5), {
            BackgroundTransparency = 0.8
        }):Play()
    end
    
    -- Animação de entrada da janela
    mainWindow.Visible = true
    mainWindow.Position = UDim2.new(0.5, 0, 0.5, 50)
    mainWindow.BackgroundTransparency = 1
    
    TweenService:Create(mainWindow, TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.fromScale(0.5, 0.5),
        BackgroundTransparency = 0
    }):Play()
    
    -- Animação dos elementos internos
    task.wait(0.3)
    
    -- Animar botões um por um
    for i, button in ipairs(buttonsContainer:GetChildren()) do
        if button:IsA("TextButton") then
            button.BackgroundTransparency = 1
            button.Position = UDim2.new(-0.5, 0, 0, button.Position.Y.Offset)
            
            TweenService:Create(button, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                BackgroundTransparency = 0,
                Position = UDim2.new(0, 0, 0, button.Position.Y.Offset)
            }):Play()
            
            task.wait(0.05)
        end
    end
    
    -- Animar área de resultados
    resultsContainer.BackgroundTransparency = 1
    defaultResult.TextTransparency = 1
    
    TweenService:Create(resultsContainer, TweenInfo.new(0.4), {
        BackgroundTransparency = 0
    }):Play()
    
    TweenService:Create(defaultResult, TweenInfo.new(0.4), {
        TextTransparency = 0
    }):Play()
end

--// FUNÇÃO PARA FECHAR A GUI
local function closeGUI()
    -- Animação de saída
    TweenService:Create(overlay, TweenInfo.new(0.4), {
        BackgroundTransparency = 1
    }):Play()
    
    for _, shadow in ipairs(shadows) do
        TweenService:Create(shadow, TweenInfo.new(0.4), {
            BackgroundTransparency = 1
        }):Play()
    end
    
    TweenService:Create(mainWindow, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Position = UDim2.new(0.5, 0, 0.5, 100),
        BackgroundTransparency = 1
    }):Play()
    
    task.wait(0.5)
    
    mainGui:Destroy()
end

--// CONFIGURAR BOTÃO FECHAR
closeButton.MouseButton1Click:Connect(function()
    closeGUI()
end)

-- Fechar ao clicar fora (no overlay)
overlay.MouseButton1Click:Connect(function()
    closeGUI()
end)

--// INICIAR A GUI APÓS UM PEQUENO DELAY
-- (Isso seria chamado após a animação de entrada terminar)
task.wait(0.5)  -- Pequeno delay para transição suave
showGUI()

--// CONFIGURAÇÃO PARA TELAS MÓVEIS
-- Ajustar tamanho baseado na tela
local viewportSize = workspace.CurrentCamera.ViewportSize
local isMobile = viewportSize.X < 800 or viewportSize.Y < 500

if isMobile then
    -- Ajustar para telas menores
    GUI_WIDTH = math.min(viewportSize.X - SCREEN_SAFE_ZONE * 2, 400)
    GUI_HEIGHT = math.min(viewportSize.Y - SCREEN_SAFE_ZONE * 2, 550)
    
    mainWindow.Size = UDim2.fromOffset(GUI_WIDTH, GUI_HEIGHT)
    
    for _, shadow in ipairs(shadows) do
        shadow.Size = mainWindow.Size
    end
end