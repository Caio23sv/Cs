-- SERVIÇOS
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ContentProvider = game:GetService("ContentProvider")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- PRÉ-CARREGAR ASSETS
local assets = {
    6073747271, -- Partícula base
    6031302938, -- Faísca 1
    6031303718, -- Faísca 2
    7733765391, -- Efeito de impacto
    3926307971  -- Ícone
}

for _, id in ipairs(assets) do
    ContentProvider:PreloadAsync({game:GetService("ContentProvider"):CreateContentId("rbxassetid://"..tostring(id))})
end

-- LIMPEZA
if PlayerGui:FindFirstChild("CaiHub_Anime_Final") then 
    PlayerGui.CaiHub_Anime_Final:Destroy() 
end

-- 1. EFEITOS DE CÂMERA (AURA CINEMATOGRÁFICA)
local Aura = Instance.new("ColorCorrectionEffect", Lighting)
Aura.Name = "CaiHub_Aura"
Aura.Enabled = false
Aura.Brightness = 0
Aura.Contrast = 0
Aura.Saturation = 0
Aura.TintColor = Color3.new(1, 1, 1)

local Bloom = Instance.new("BloomEffect", Lighting)
Bloom.Intensity = 0
Bloom.Size = 24
Bloom.Threshold = 0.9
Bloom.Enabled = false

local SunRays = Instance.new("SunRaysEffect", Lighting)
SunRays.Intensity = 0
SunRays.Spread = 1
SunRays.Enabled = false

-- 2. ESTRUTURA PRINCIPAL
local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.Name = "CaiHub_Anime_Final"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- 3. BACKGROUND COM PARTICULAS DINÂMICAS
local BackgroundParticles = Instance.new("Frame", ScreenGui)
BackgroundParticles.Size = UDim2.new(1, 0, 1, 0)
BackgroundParticles.BackgroundTransparency = 1
BackgroundParticles.ZIndex = 0

-- Sistema de partículas melhorado
local function spawnAnimeParticle(position)
    local particle = Instance.new("ImageLabel", BackgroundParticles)
    particle.BackgroundTransparency = 1
    particle.Image = "rbxassetid://6073747271"
    particle.ImageColor3 = Color3.fromHSV(math.random(), 0.8, 1)
    particle.Size = UDim2.new(0, math.random(10, 25), 0, math.random(10, 25))
    particle.Position = position
    particle.AnchorPoint = Vector2.new(0.5, 0.5)
    particle.ZIndex = 0
    
    -- Animação de entrada
    particle.ImageTransparency = 1
    particle.Rotation = math.random(-180, 180)
    
    local angle = math.rad(math.random(0, 360))
    local distance = math.random(50, 150) / 100
    local targetPos = position + UDim2.new(
        math.cos(angle) * distance, 0,
        math.sin(angle) * distance, 0
    )
    
    -- Sequência de animação
    local sequence = {
        TweenService:Create(particle, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            ImageTransparency = 0.3,
            Rotation = particle.Rotation + 45
        }),
        TweenService:Create(particle, TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
            Position = targetPos,
            ImageColor3 = Color3.fromRGB(0, 255, 255),
            Rotation = particle.Rotation + 180
        }),
        TweenService:Create(particle, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            ImageTransparency = 1,
            Size = UDim2.new(0, 5, 0, 5)
        })
    }
    
    -- Executar sequência
    sequence[1]:Play()
    sequence[1].Completed:Connect(function()
        sequence[2]:Play()
        sequence[2].Completed:Connect(function()
            sequence[3]:Play()
            sequence[3].Completed:Connect(function()
                particle:Destroy()
            end)
        end)
    end)
    
    return particle
end

-- Efeito de faíscas
local function spawnSparkEffect(position, intensity)
    for i = 1, intensity do
        task.spawn(function()
            local spark = Instance.new("ImageLabel", BackgroundParticles)
            spark.Image = "rbxassetid://"..tostring(math.random(6031302938, 6031303718))
            spark.BackgroundTransparency = 1
            spark.Size = UDim2.new(0, math.random(8, 15), 0, math.random(8, 15))
            spark.Position = position
            spark.ImageColor3 = Color3.fromRGB(255, math.random(200, 255), 100)
            spark.ZIndex = 0
            
            local angle = math.rad(math.random(0, 360))
            local speed = math.random(100, 200) / 100
            local target = position + UDim2.new(
                math.cos(angle) * speed, 0,
                math.sin(angle) * speed, 0
            )
            
            local tween = TweenService:Create(spark, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = target,
                ImageTransparency = 1,
                Rotation = math.random(-180, 180),
                Size = UDim2.new(0, 3, 0, 3)
            })
            
            tween:Play()
            tween.Completed:Connect(function()
                spark:Destroy()
            end)
        end)
        task.wait(0.02)
    end
end

-- 4. PAINEL PRINCIPAL COM ANIMAÇÕES ESTILO ANIME
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Size = UDim2.new(0, 0, 0, 0) -- Começa do centro
MainFrame.ClipsDescendants = true
MainFrame.Visible = false
MainFrame.ZIndex = 2

-- Corner com animação
local corner = Instance.new("UICorner", MainFrame)
corner.CornerRadius = UDim.new(0, 15)

-- Stroke pulsante
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Thickness = 4
MainStroke.Color = Color3.fromRGB(0, 255, 255)
MainStroke.Transparency = 0

-- Animação de pulsação do stroke
task.spawn(function()
    while true do
        TweenService:Create(MainStroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Thickness = 5,
            Color = Color3.fromRGB(100, 255, 255)
        }):Play()
        task.wait(1.5)
        TweenService:Create(MainStroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Thickness = 4,
            Color = Color3.fromRGB(0, 255, 255)
        }):Play()
        task.wait(1.5)
    end
end)

-- LINHAS NEON DINÂMICAS
local function createNeonLine(pos, size, rotation)
    local line = Instance.new("Frame", MainFrame)
    line.Position = pos
    line.Size = size
    line.BorderSizePixel = 0
    line.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
    line.BackgroundTransparency = 0.3
    line.Rotation = rotation
    line.ZIndex = 1
    
    -- Animação de onda
    task.spawn(function()
        while line.Parent do
            local wave = TweenService:Create(line, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                BackgroundTransparency = 0.7,
                BackgroundColor3 = Color3.fromRGB(0, 150, 255)
            })
            wave:Play()
            task.wait(2)
            wave = TweenService:Create(line, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                BackgroundTransparency = 0.3,
                BackgroundColor3 = Color3.fromRGB(0, 255, 255)
            })
            wave:Play()
            task.wait(2)
        end
    end)
    
    return line
end

-- Criar padrão de linhas
createNeonLine(UDim2.new(0, 10, 0, 42), UDim2.new(1, -20, 0, 2), 0)
createNeonLine(UDim2.new(0, 135, 0, 50), UDim2.new(0, 2, 1, -65), 0)
createNeonLine(UDim2.new(1, -10, 0, 50), UDim2.new(0, 2, 1, -65), 0)

-- TÍTULO COM EFEITO DE DIGITAÇÃO
local Title = Instance.new("TextLabel", MainFrame)
Title.Text = ""
Title.Size = UDim2.new(1, 0, 0, 42)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.PaddingLeft = UDim.new(0, 15)
Title.ZIndex = 3

-- Efeito de digitação
local titleText = "  cai hub"
local typingSpeed = 0.05
task.spawn(function()
    for i = 1, #titleText do
        Title.Text = string.sub(titleText, 1, i)
        task.wait(typingSpeed)
    end
end)

-- 5. SIDEBAR E CONTAINER DE PÁGINAS
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Position = UDim2.new(0, 15, 0, 50)
Sidebar.Size = UDim2.new(0, 125, 1, -70)
Sidebar.BackgroundTransparency = 1
Sidebar.ZIndex = 3

local sidebarLayout = Instance.new("UIListLayout", Sidebar)
sidebarLayout.Padding = UDim.new(0, 8)

local PageContainer = Instance.new("Frame", MainFrame)
PageContainer.Position = UDim2.new(0, 155, 0, 55)
PageContainer.Size = UDim2.new(1, -165, 1, -65)
PageContainer.BackgroundTransparency = 1
PageContainer.ZIndex = 3

-- Sistema de páginas
local Pages = {}
local SidebarBtns = {}

local function createPage(name)
    local page = Instance.new("ScrollingFrame", PageContainer)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.ScrollBarThickness = 0
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.ZIndex = 3
    
    local layout = Instance.new("UIListLayout", page)
    layout.Padding = UDim.new(0, 10)
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
    end)
    
    Pages[name] = page
    return page
end

-- Conteúdo das páginas
local p1 = createPage("Overview")
local p2 = createPage("Sliders")
local p3 = createPage("Settings")

local function addSection(page, text, icon)
    local section = Instance.new("Frame", page)
    section.Size = UDim2.new(1, -10, 0, 40)
    section.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    section.BackgroundTransparency = 0.5
    section.ZIndex = 4
    
    local corner = Instance.new("UICorner", section)
    corner.CornerRadius = UDim.new(0, 8)
    
    local stroke = Instance.new("UIStroke", section)
    stroke.Color = Color3.fromRGB(0, 255, 255)
    stroke.Thickness = 1
    stroke.Transparency = 0.5
    
    local label = Instance.new("TextLabel", section)
    label.Text = "  " .. text
    label.Size = UDim2.new(1, 0, 1, 0)
    label.TextColor3 = Color3.fromRGB(200, 200, 255)
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 14
    label.ZIndex = 5
    
    -- Animação de hover
    section.MouseEnter:Connect(function()
        TweenService:Create(section, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.3,
            BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        }):Play()
        TweenService:Create(stroke, TweenInfo.new(0.2), {
            Transparency = 0
        }):Play()
    end)
    
    section.MouseLeave:Connect(function()
        TweenService:Create(section, TweenInfo.new(0.3), {
            BackgroundTransparency = 0.5
        }):Play()
        TweenService:Create(stroke, TweenInfo.new(0.3), {
            Transparency = 0.5
        }):Play()
    end)
    
    return section
end

-- Adicionar conteúdo
addSection(p1, "🌟 Seja bem-vindo ao Cai Hub!")
addSection(p1, "✅ Status: Online & Funcional")
addSection(p1, "⚡ Desempenho: Máximo")
addSection(p1, "🛡️ Segurança: Ativa")

addSection(p2, "🎯 Velocidade [Avançado]")
addSection(p2, "🚀 Pulo [Dinâmico]")
addSection(p2, "👁️ Campo de Visão")
addSection(p2, "🎨 Efeitos Visuais")

addSection(p3, "💾 Salvar Configurações")
addSection(p3, "🔄 Rejoin Automático")
addSection(p3, "🎚️ Qualidade Gráfica")
addSection(p3, "🔔 Notificações")

-- Botões da sidebar com animações
local function addTab(name)
    local button = Instance.new("TextButton", Sidebar)
    button.Size = UDim2.new(1, 0, 0, 38)
    button.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    button.Text = name
    button.TextColor3 = Color3.fromRGB(150, 150, 180)
    button.Font = Enum.Font.GothamMedium
    button.TextSize = 14
    button.AutoButtonColor = false
    button.ZIndex = 4
    
    local corner = Instance.new("UICorner", button)
    corner.CornerRadius = UDim.new(0, 8)
    
    local stroke = Instance.new("UIStroke", button)
    stroke.Color = Color3.fromRGB(0, 255, 255)
    stroke.Thickness = 2
    stroke.Transparency = 1
    
    local highlight = Instance.new("Frame", button)
    highlight.Size = UDim2.new(0, 4, 1, -10)
    highlight.Position = UDim2.new(0, -8, 0.5, 0)
    highlight.AnchorPoint = Vector2.new(0, 0.5)
    highlight.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
    highlight.BackgroundTransparency = 0.8
    highlight.Visible = false
    Instance.new("UICorner", highlight).CornerRadius = UDim.new(1, 0)
    
    -- Animação de hover
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(35, 35, 45),
            TextColor3 = Color3.fromRGB(220, 220, 255)
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        if Pages[name].Visible == false then
            TweenService:Create(button, TweenInfo.new(0.3), {
                BackgroundColor3 = Color3.fromRGB(25, 25, 30),
                TextColor3 = Color3.fromRGB(150, 150, 180)
            }):Play()
        end
    end)
    
    button.MouseButton1Click:Connect(function()
        -- Esconder todas as páginas
        for _, page in pairs(Pages) do
            page.Visible = false
        end
        
        -- Resetar todos os botões
        for _, btn in pairs(SidebarBtns) do
            TweenService:Create(btn, TweenInfo.new(0.3), {
                BackgroundColor3 = Color3.fromRGB(25, 25, 30),
                TextColor3 = Color3.fromRGB(150, 150, 180)
            }):Play()
            TweenService:Create(btn.UIStroke, TweenInfo.new(0.3), {
                Transparency = 1
            }):Play()
            btn.Highlight.Visible = false
        end
        
        -- Ativar página atual
        Pages[name].Visible = true
        
        -- Animar botão atual
        TweenService:Create(button, TweenInfo.new(0.3), {
            BackgroundColor3 = Color3.fromRGB(40, 40, 50),
            TextColor3 = Color3.fromRGB(255, 255, 255)
        }):Play()
        TweenService:Create(stroke, TweenInfo.new(0.3), {
            Transparency = 0
        }):Play()
        
        -- Mostrar highlight com animação
        highlight.Visible = true
        highlight.Size = UDim2.new(0, 0, 1, -10)
        TweenService:Create(highlight, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 4, 1, -10)
        }):Play()
        
        -- Efeito de partículas na transição
        spawnAnimeParticle(UDim2.new(0.5, 0, 0.5, 0))
    end)
    
    button.Highlight = highlight
    button.UIStroke = stroke
    SidebarBtns[name] = button
    
    return button
end

addTab("Overview")
addTab("Sliders")
addTab("Settings")

-- 6. BOTÃO TOGGLE COM ANIMAÇÃO CINEMATOGRÁFICA
local Toggle = Instance.new("ImageButton", ScreenGui)
Toggle.Size = UDim2.new(0, 60, 0, 60)
Toggle.Position = UDim2.new(0.02, 0, 0.85, 0)
Toggle.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Toggle.Image = "rbxassetid://3926307971"
Toggle.ImageRectOffset = Vector2.new(764, 244)
Toggle.ImageRectSize = Vector2.new(36, 36)
Toggle.ImageColor3 = Color3.fromRGB(0, 255, 255)
Toggle.ZIndex = 10

local toggleCorner = Instance.new("UICorner", Toggle)
toggleCorner.CornerRadius = UDim.new(1, 0)

local toggleStroke = Instance.new("UIStroke", Toggle)
toggleStroke.Color = Color3.fromRGB(0, 255, 255)
toggleStroke.Thickness = 3

-- Efeito de brilho no toggle
local toggleGlow = Instance.new("ImageLabel", Toggle)
toggleGlow.Size = UDim2.new(1.4, 0, 1.4, 0)
toggleGlow.Position = UDim2.new(-0.2, 0, -0.2, 0)
toggleGlow.Image = "rbxassetid://8992230673"
toggleGlow.ImageColor3 = Color3.fromRGB(0, 100, 255)
toggleGlow.BackgroundTransparency = 1
toggleGlow.ImageTransparency = 0.8
toggleGlow.ZIndex = 9

-- Animação de pulsação no toggle
task.spawn(function()
    while true do
        TweenService:Create(toggleGlow, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            ImageTransparency = 0.6,
            Rotation = toggleGlow.Rotation + 45
        }):Play()
        task.wait(1.5)
        TweenService:Create(toggleGlow, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            ImageTransparency = 0.8,
            Rotation = toggleGlow.Rotation + 45
        }):Play()
        task.wait(1.5)
    end
end)

-- 7. LÓGICA DE ANIMAÇÃO ANIME CINEMATOGRÁFICA
local isOpen = false
local animationInProgress = false

local function openGUI()
    if animationInProgress then return end
    animationInProgress = true
    
    -- Ativar efeitos de câmera
    Aura.Enabled = true
    Bloom.Enabled = true
    SunRays.Enabled = true
    
    -- Mostrar painel
    MainFrame.Visible = true
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.Rotation = 0
    
    -- EFEITO DE EXPLOSÃO DE PARTÍCULAS
    spawnSparkEffect(UDim2.new(0.5, 0, 0.5, 0), 20)
    
    -- Animação de abertura tipo anime
    local sequence = {
        -- Fase 1: Expansão rápida com overshoot
        TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, 0.5), {
            Size = UDim2.new(0, 500, 0, 320)
        }),
        
        -- Fase 2: Ajuste fino
        TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 480, 0, 300)
        }),
        
        -- Fase 3: Rotação dinâmica
        TweenService:Create(MainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out, 0, false, 0.3), {
            Rotation = 360
        })
    }
    
    -- Animação de efeitos visuais
    local effectsSequence = {
        TweenService:Create(Aura, TweenInfo.new(0.8, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Brightness = 0.2,
            Contrast = 0.1,
            Saturation = 0.3,
            TintColor = Color3.fromRGB(180, 220, 255)
        }),
        
        TweenService:Create(Bloom, TweenInfo.new(0.8, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Intensity = 1.2,
            Size = 32
        }),
        
        TweenService:Create(SunRays, TweenInfo.new(0.8, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Intensity = 0.3,
            Spread = 0.8
        })
    }
    
    -- Executar sequências
    sequence[1]:Play()
    effectsSequence[1]:Play()
    effectsSequence[2]:Play()
    effectsSequence[3]:Play()
    
    sequence[1].Completed:Connect(function()
        sequence[2]:Play()
        sequence[2].Completed:Connect(function()
            sequence[3]:Play()
            
            -- Efeito de impacto visual
            spawnSparkEffect(UDim2.new(0.5, 0, 0.5, 0), 15)
            
            -- Pequeno shake no final
            local shakeIntensity = 5
            local originalPos = MainFrame.Position
            for i = 1, 3 do
                MainFrame.Position = originalPos + UDim2.new(0, math.random(-shakeIntensity, shakeIntensity), 0, math.random(-shakeIntensity, shakeIntensity))
                task.wait(0.05)
            end
            MainFrame.Position = originalPos
            
            -- Ativar primeira página
            Pages["Overview"].Visible = true
            SidebarBtns["Overview"].BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            SidebarBtns["Overview"].TextColor3 = Color3.fromRGB(255, 255, 255)
            SidebarBtns["Overview"].UIStroke.Transparency = 0
            SidebarBtns["Overview"].Highlight.Visible = true
            SidebarBtns["Overview"].Highlight.Size = UDim2.new(0, 4, 1, -10)
            
            -- Iniciar partículas de fundo
            task.spawn(function()
                while isOpen do
                    spawnAnimeParticle(UDim2.new(math.random(0.3, 0.7), 0, math.random(0.3, 0.7), 0))
                    task.wait(0.08)
                end
            end)
            
            animationInProgress = false
        end)
    end)
end

local function closeGUI()
    if animationInProgress then return end
    animationInProgress = true
    
    -- Efeito de implosão de partículas
    spawnSparkEffect(UDim2.new(0.5, 0, 0.5, 0), 15)
    
    -- Animação de fechamento
    local closeSequence = {
        -- Rotação de saída
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Rotation = -180,
            Size = UDim2.new(0, 100, 0, 100)
        }),
        
        -- Encolhimento final
        TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.6, 0)
        })
    }
    
    -- Animação de efeitos visuais (reversa)
    local effectsClose = {
        TweenService:Create(Aura, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Brightness = 0,
            Contrast = 0,
            Saturation = 0,
            TintColor = Color3.new(1, 1, 1)
        }),
        
        TweenService:Create(Bloom, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Intensity = 0,
            Size = 24
        }),
        
        TweenService:Create(SunRays, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Intensity = 0,
            Spread = 1
        })
    }
    
    -- Executar sequências
    closeSequence[1]:Play()
    effectsClose[1]:Play()
    effectsClose[2]:Play()
    effectsClose[3]:Play()
    
    closeSequence[1].Completed:Connect(function()
        closeSequence[2]:Play()
        closeSequence[2].Completed:Connect(function()
            MainFrame.Visible = false
            Aura.Enabled = false
            Bloom.Enabled = false
            SunRays.Enabled = false
            
            -- Efeito final de faíscas
            spawnSparkEffect(UDim2.new(0.5, 0, 0.6, 0), 10)
            
            animationInProgress = false
        end)
    end)
end

-- Controle do toggle
Toggle.MouseButton1Click:Connect(function()
    if animationInProgress then return end
    
    -- Animação do botão
    TweenService:Create(Toggle, TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 55, 0, 55)
    }):Play()
    
    task.wait(0.1)
    
    TweenService:Create(Toggle, TweenInfo.new(0.2, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 60, 0, 60)
    }):Play()
    
    if isOpen then
        closeGUI()
    else
        openGUI()
    end
    
    isOpen = not isOpen
end)

-- 8. SISTEMA DE ARRASTO SUAVE
local dragging, dragInput, dragStart, startPos

local function updateInput(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        updateInput(input)
    end
end)

-- 9. EFEITO DE VIBRAÇÃO AO ARRASTAR
MainFrame.Changed:Connect(function(property)
    if property == "Position" and dragging then
        local shake = math.random(-1, 1)
        MainFrame.Rotation = shake * 0.5
    elseif property == "Position" and not dragging then
        TweenService:Create(MainFrame, TweenInfo.new(0.3), {
            Rotation = 0
        }):Play()
    end
end)

-- 10. ANIMAÇÃO DE ENTRADA INICIAL (OPCIONAL)
task.wait(1)
Toggle.Visible = true
Toggle.Position = UDim2.new(-0.1, 0, 0.85, 0)
TweenService:Create(Toggle, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Position = UDim2.new(0.02, 0, 0.85, 0)
}):Play()

-- Mensagem de inicialização
print("🎬 Cai Hub Anime Edition - Carregado com Sucesso!")
print("✨ Efeitos Cinematográficos Ativos")
print("🎨 Animações Estilo Anime Prontas")