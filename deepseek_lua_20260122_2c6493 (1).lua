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

--// BIG BANG - BOLINHAS COLORIDAS
local bolinhasVermelhas = {}
local bolinhasAzuis = {}
local bolinhasBrancas = {}
local center = UDim2.fromScale(0.5,0.5)
local cx, cy = cam.ViewportSize.X/2, cam.ViewportSize.Y/2

-- Criar bolinhas vermelhas (para o rosto)
for i = 1, 150 do
    local b = Instance.new("Frame", gui)
    local s = math.random(10, 18)
    b.Size = UDim2.fromOffset(s,s)
    b.AnchorPoint = Vector2.new(0.5,0.5)
    b.Position = center
    b.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    b.BorderSizePixel = 0
    b.ZIndex = 1020
    b.BackgroundTransparency = 0.3
    Instance.new("UICorner", b).CornerRadius = UDim.new(1,0)
    table.insert(bolinhasVermelhas, b)

    local ang = math.rad(math.random(0,360))
    local dist = math.random(400,750)

    TweenService:Create(b, TweenInfo.new(1.7, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Position = UDim2.fromOffset(
            cx + math.cos(ang)*dist,
            cy + math.sin(ang)*dist
        ),
        BackgroundTransparency = 0
    }):Play()
end

-- Criar bolinhas azuis (para o círculo ao redor)
for i = 1, 80 do
    local b = Instance.new("Frame", gui)
    local s = math.random(8, 14)
    b.Size = UDim2.fromOffset(s,s)
    b.AnchorPoint = Vector2.new(0.5,0.5)
    b.Position = center
    b.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    b.BorderSizePixel = 0
    b.ZIndex = 1019
    b.BackgroundTransparency = 0.3
    Instance.new("UICorner", b).CornerRadius = UDim.new(1,0)
    table.insert(bolinhasAzuis, b)

    local ang = math.rad(math.random(0,360))
    local dist = math.random(500, 850)

    TweenService:Create(b, TweenInfo.new(1.7, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Position = UDim2.fromOffset(
            cx + math.cos(ang)*dist,
            cy + math.sin(ang)*dist
        ),
        BackgroundTransparency = 0
    }):Play()
end

-- Criar bolinhas brancas (para os olhos)
for i = 1, 40 do
    local b = Instance.new("Frame", gui)
    local s = math.random(6, 12)
    b.Size = UDim2.fromOffset(s,s)
    b.AnchorPoint = Vector2.new(0.5,0.5)
    b.Position = center
    b.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    b.BorderSizePixel = 0
    b.ZIndex = 1021
    b.BackgroundTransparency = 0.3
    Instance.new("UICorner", b).CornerRadius = UDim.new(1,0)
    table.insert(bolinhasBrancas, b)

    local ang = math.rad(math.random(0,360))
    local dist = math.random(300, 600)

    TweenService:Create(b, TweenInfo.new(1.7, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Position = UDim2.fromOffset(
            cx + math.cos(ang)*dist,
            cy + math.sin(ang)*dist
        ),
        BackgroundTransparency = 0
    }):Play()
end

faixa.Visible = false

task.wait(1.7)

--// FORMAR ROSTO
-- Primeiro trazer todas as bolinhas para posições intermediárias
for i, b in ipairs(bolinhasVermelhas) do
    TweenService:Create(b, TweenInfo.new(0.8, Enum.EasingStyle.Quad), {
        Position = center,
        BackgroundTransparency = 0.4,
        Size = UDim2.fromOffset(10, 10)
    }):Play()
end

for i, b in ipairs(bolinhasAzuis) do
    TweenService:Create(b, TweenInfo.new(0.8, Enum.EasingStyle.Quad), {
        Position = center,
        BackgroundTransparency = 0.4,
        Size = UDim2.fromOffset(8, 8)
    }):Play()
end

for i, b in ipairs(bolinhasBrancas) do
    TweenService:Create(b, TweenInfo.new(0.8, Enum.EasingStyle.Quad), {
        Position = center,
        BackgroundTransparency = 0.4,
        Size = UDim2.fromOffset(8, 8)
    }):Play()
end

task.wait(0.8)

-- Definir posições do rosto
local function criarPosicoesRosto()
    local posicoes = {}
    local faceRadius = 120
    local eyeRadius = 25
    local eyeSpacing = 80
    local mouthWidth = 80
    local mouthHeight = 30
    
    -- ROSTO (círculo vermelho)
    for angle = 0, 360, 8 do
        local rad = math.rad(angle)
        for r = 0, faceRadius, faceRadius/20 do
            local x = cx + math.cos(rad) * r
            local y = cy + math.sin(rad) * r
            table.insert(posicoes, {x = x, y = y, tipo = "face", cor = Color3.fromRGB(255, 100, 100)})
        end
    end
    
    -- OLHO ESQUERDO (círculo branco)
    for angle = 0, 360, 10 do
        local rad = math.rad(angle)
        for r = 0, eyeRadius, eyeRadius/8 do
            local x = cx - eyeSpacing + math.cos(rad) * r
            local y = cy - 30 + math.sin(rad) * r
            table.insert(posicoes, {x = x, y = y, tipo = "olho", cor = Color3.fromRGB(255, 255, 255)})
        end
    end
    
    -- OLHO DIREITO (círculo branco)
    for angle = 0, 360, 10 do
        local rad = math.rad(angle)
        for r = 0, eyeRadius, eyeRadius/8 do
            local x = cx + eyeSpacing + math.cos(rad) * r
            local y = cy - 30 + math.sin(rad) * r
            table.insert(posicoes, {x = x, y = y, tipo = "olho", cor = Color3.fromRGB(255, 255, 255)})
        end
    end
    
    -- BOCA (sorriso - vermelho)
    for angle = 180, 360, 6 do
        local rad = math.rad(angle)
        local x = cx + math.cos(rad) * mouthWidth/2
        local y = cy + 40 + math.sin(rad) * mouthHeight/2
        table.insert(posicoes, {x = x, y = y, tipo = "boca", cor = Color3.fromRGB(255, 50, 50)})
    end
    
    -- CÍRCULO AZUL AO REDOR (órbita)
    local orbitaRadius = 200
    for angle = 0, 360, 15 do
        local rad = math.rad(angle)
        local x = cx + math.cos(rad) * orbitaRadius
        local y = cy + math.sin(rad) * orbitaRadius
        table.insert(posicoes, {x = x, y = y, tipo = "orbita", cor = Color3.fromRGB(100, 150, 255)})
        
        -- Preencher entre pontos da órbita
        for i = 1, 3 do
            local offsetX = math.random(-15, 15)
            local offsetY = math.random(-15, 15)
            table.insert(posicoes, {x = x + offsetX, y = y + offsetY, tipo = "orbita", cor = Color3.fromRGB(100, 150, 255)})
        end
    end
    
    return posicoes
end

local posicoesRosto = criarPosicoesRosto()

-- Distribuir bolinhas vermelhas para o rosto
local vermelhaIndex = 1
for _, pos in ipairs(posicoesRosto) do
    if pos.tipo == "face" or pos.tipo == "boca" then
        if vermelhaIndex <= #bolinhasVermelhas then
            local b = bolinhasVermelhas[vermelhaIndex]
            local delay = (vermelhaIndex / #bolinhasVermelhas) * 0.3
            
            task.spawn(function()
                task.wait(delay)
                TweenService:Create(b, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Position = UDim2.fromOffset(pos.x, pos.y),
                    BackgroundColor3 = pos.cor,
                    BackgroundTransparency = 0,
                    Size = UDim2.fromOffset(12, 12)
                }):Play()
            end)
            
            vermelhaIndex = vermelhaIndex + 1
        end
    end
end

-- Distribuir bolinhas brancas para os olhos
local brancaIndex = 1
for _, pos in ipairs(posicoesRosto) do
    if pos.tipo == "olho" then
        if brancaIndex <= #bolinhasBrancas then
            local b = bolinhasBrancas[brancaIndex]
            local delay = (brancaIndex / #bolinhasBrancas) * 0.2
            
            task.spawn(function()
                task.wait(delay)
                TweenService:Create(b, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Position = UDim2.fromOffset(pos.x, pos.y),
                    BackgroundColor3 = pos.cor,
                    BackgroundTransparency = 0,
                    Size = UDim2.fromOffset(10, 10)
                }):Play()
            end)
            
            brancaIndex = brancaIndex + 1
        end
    end
end

-- Distribuir bolinhas azuis para a órbita
local azulIndex = 1
for _, pos in ipairs(posicoesRosto) do
    if pos.tipo == "orbita" then
        if azulIndex <= #bolinhasAzuis then
            local b = bolinhasAzuis[azulIndex]
            local delay = (azulIndex / #bolinhasAzuis) * 0.4
            
            task.spawn(function()
                task.wait(delay)
                TweenService:Create(b, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Position = UDim2.fromOffset(pos.x, pos.y),
                    BackgroundColor3 = pos.cor,
                    BackgroundTransparency = 0,
                    Size = UDim2.fromOffset(10, 10)
                }):Play()
            end)
            
            azulIndex = azulIndex + 1
        end
    end
end

task.wait(1.5)

--// ANIMAÇÃO: ABRIR A BOCA
local bocaAberta = false
local function animarBoca(abrir)
    local mouthBolinhas = {}
    
    -- Encontrar bolinhas da boca
    for i, b in ipairs(bolinhasVermelhas) do
        local posX, posY = b.Position.X.Offset, b.Position.Y.Offset
        if posY > cy + 20 and posY < cy + 60 then
            if posX > cx - 50 and posX < cx + 50 then
                table.insert(mouthBolinhas, b)
            end
        end
    end
    
    if abrir then
        -- Abrir boca (expandir para baixo)
        for i, b in ipairs(mouthBolinhas) do
            local offsetY = math.random(20, 40)
            TweenService:Create(b, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Position = UDim2.fromOffset(b.Position.X.Offset, b.Position.Y.Offset + offsetY),
                BackgroundColor3 = Color3.fromRGB(255, 80, 80)
            }):Play()
        end
        bocaAberta = true
    else
        -- Fechar boca (voltar à posição original)
        for i, b in ipairs(mouthBolinhas) do
            local originalPos = UDim2.fromOffset(
                b.Position.X.Offset,
                cy + 40 + math.sin(math.atan2(b.Position.X.Offset - cx, 0)) * 15
            )
            TweenService:Create(b, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Position = originalPos,
                BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            }):Play()
        end
        bocaAberta = false
    end
end

-- Animação da boca abrindo e fechando
for i = 1, 3 do
    animarBoca(true)
    task.wait(0.6)
    animarBoca(false)
    task.wait(0.6)
end

task.wait(0.5)

--// ANIMAÇÃO: PISCAR OLHOS EM SEQUÊNCIA
local function piscarOlhos()
    -- Primeiro olho esquerdo
    for i, b in ipairs(bolinhasBrancas) do
        local posX, posY = b.Position.X.Offset, b.Position.Y.Offset
        if math.sqrt((posX - (cx - 80))^2 + (posY - (cy - 30))^2) < 30 then
            TweenService:Create(b, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
                BackgroundColor3 = Color3.fromRGB(200, 200, 255),
                Size = UDim2.fromOffset(8, 8)
            }):Play()
        end
    end
    
    task.wait(0.2)
    
    -- Restaurar olho esquerdo
    for i, b in ipairs(bolinhasBrancas) do
        local posX, posY = b.Position.X.Offset, b.Position.Y.Offset
        if math.sqrt((posX - (cx - 80))^2 + (posY - (cy - 30))^2) < 30 then
            TweenService:Create(b, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Size = UDim2.fromOffset(10, 10)
            }):Play()
        end
    end
    
    task.wait(0.2)
    
    -- Depois olho direito
    for i, b in ipairs(bolinhasBrancas) do
        local posX, posY = b.Position.X.Offset, b.Position.Y.Offset
        if math.sqrt((posX - (cx + 80))^2 + (posY - (cy - 30))^2) < 30 then
            TweenService:Create(b, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
                BackgroundColor3 = Color3.fromRGB(200, 200, 255),
                Size = UDim2.fromOffset(8, 8)
            }):Play()
        end
    end
    
    task.wait(0.2)
    
    -- Restaurar olho direito
    for i, b in ipairs(bolinhasBrancas) do
        local posX, posY = b.Position.X.Offset, b.Position.Y.Offset
        if math.sqrt((posX - (cx + 80))^2 + (posY - (cy - 30))^2) < 30 then
            TweenService:Create(b, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Size = UDim2.fromOffset(10, 10)
            }):Play()
        end
    end
end

-- Executar piscar 3 vezes
for i = 1, 3 do
    piscarOlhos()
    task.wait(0.8)
end

task.wait(0.5)

--// ANIMAÇÃO: ENERGIA PASSANDO EM SEQUÊNCIA
local function ondaEnergia()
    -- Ordem: órbita -> rosto -> olhos -> boca
    local sequencia = {"orbita", "face", "olho", "boca"}
    
    for _, tipo in ipairs(sequencia) do
        -- Encontrar todas as bolinhas do tipo
        local bolinhasTipo = {}
        
        if tipo == "orbita" then
            bolinhasTipo = bolinhasAzuis
        elseif tipo == "face" then
            bolinhasTipo = bolinhasVermelhas
        elseif tipo == "olho" then
            bolinhasTipo = bolinhasBrancas
        elseif tipo == "boca" then
            -- Bolinhas vermelhas que estão na boca
            for i, b in ipairs(bolinhasVermelhas) do
                local posY = b.Position.Y.Offset
                if posY > cy + 20 and posY < cy + 60 then
                    table.insert(bolinhasTipo, b)
                end
            end
        end
        
        -- Efeito de energia passando
        for i, b in ipairs(bolinhasTipo) do
            local delay = (i / #bolinhasTipo) * 0.1
            
            task.spawn(function()
                task.wait(delay)
                
                -- Mudar para cor de energia
                local corEnergia
                if tipo == "orbita" then
                    corEnergia = Color3.fromRGB(150, 200, 255)
                elseif tipo == "face" then
                    corEnergia = Color3.fromRGB(255, 150, 150)
                elseif tipo == "olho" then
                    corEnergia = Color3.fromRGB(255, 255, 200)
                elseif tipo == "boca" then
                    corEnergia = Color3.fromRGB(255, 100, 100)
                end
                
                TweenService:Create(b, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                    BackgroundColor3 = corEnergia,
                    Size = UDim2.fromOffset(14, 14)
                }):Play()
                
                task.wait(0.1)
                
                -- Voltar à cor original
                local corOriginal
                if tipo == "orbita" then
                    corOriginal = Color3.fromRGB(100, 150, 255)
                elseif tipo == "face" then
                    corOriginal = Color3.fromRGB(255, 100, 100)
                elseif tipo == "olho" then
                    corOriginal = Color3.fromRGB(255, 255, 255)
                elseif tipo == "boca" then
                    corOriginal = Color3.fromRGB(255, 50, 50)
                end
                
                TweenService:Create(b, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                    BackgroundColor3 = corOriginal,
                    Size = UDim2.fromOffset(12, 12)
                }):Play()
            end)
        end
        
        task.wait(0.5)
    end
end

-- Executar onda de energia 2 vezes
for i = 1, 2 do
    ondaEnergia()
    task.wait(1)
end

task.wait(1)

--// ANIMAÇÃO: ÓRBITA AO REDOR DO ROSTO
-- Configurar rotação para bolinhas azuis
local tempoRotacao = 0
local connectionOrbita

connectionOrbita = RunService.RenderStepped:Connect(function(deltaTime)
    tempoRotacao = tempoRotacao + deltaTime * 0.5
    
    for i, b in ipairs(bolinhasAzuis) do
        if b.Parent then
            local posX, posY = b.Position.X.Offset, b.Position.Y.Offset
            local ang = math.atan2(posY - cy, posX - cx)
            local dist = math.sqrt((posX - cx)^2 + (posY - cy)^2)
            
            -- Adicionar movimento orbital
            local novoAng = ang + tempoRotacao
            local novaX = cx + math.cos(novoAng) * dist
            local novaY = cy + math.sin(novoAng) * dist
            
            b.Position = UDim2.fromOffset(novaX, novaY)
        end
    end
end)

-- Rodar órbita por 4 segundos
task.wait(4)

if connectionOrbita then
    connectionOrbita:Disconnect()
end

--// DESMONTAR ROSTO (DE CIMA PARA BAIIXO)
-- Função para desmontar em camadas horizontais
local function desmontarCamada(yMin, yMax, delayFactor)
    local bolinhasCamada = {}
    
    -- Coletar todas as bolinhas na camada
    for i, b in ipairs(bolinhasVermelhas) do
        if b.Parent and b.Position.Y.Offset >= yMin and b.Position.Y.Offset <= yMax then
            table.insert(bolinhasCamada, b)
        end
    end
    
    for i, b in ipairs(bolinhasBrancas) do
        if b.Parent and b.Position.Y.Offset >= yMin and b.Position.Y.Offset <= yMax then
            table.insert(bolinhasCamada, b)
        end
    end
    
    for i, b in ipairs(bolinhasAzuis) do
        if b.Parent and b.Position.Y.Offset >= yMin and b.Position.Y.Offset <= yMax then
            table.insert(bolinhasCamada, b)
        end
    end
    
    -- Animar desaparecimento
    for i, b in ipairs(bolinhasCamada) do
        local delay = (i / #bolinhasCamada) * delayFactor
        
        task.spawn(function()
            task.wait(delay)
            
            -- Efeito de desaparecimento para os lados
            local direcao = math.random() > 0.5 and 1 or -1
            local ang = math.rad(math.random(30, 150)) * direcao
            local dist = math.random(200, 400)
            
            TweenService:Create(b, TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.fromOffset(
                    b.Position.X.Offset + math.cos(ang) * dist,
                    b.Position.Y.Offset + math.sin(ang) * dist
                ),
                BackgroundTransparency = 1,
                Size = UDim2.fromOffset(0, 0)
            }):Play()
        end)
    end
    
    return #bolinhasCamada > 0
end

-- Desmontar em 5 camadas (de cima para baixo)
local alturaTotal = 300
local numCamadas = 5
local alturaCamada = alturaTotal / numCamadas

for camada = 1, numCamadas do
    local yMin = cy - alturaTotal/2 + (camada-1) * alturaCamada
    local yMax = cy - alturaTotal/2 + camada * alturaCamada
    
    if desmontarCamada(yMin, yMax, 0.2) then
        task.wait(0.8)
    end
end

-- Desmontar qualquer bolinha restante
local todasBolinhas = {}
for _, b in ipairs(bolinhasVermelhas) do table.insert(todasBolinhas, b) end
for _, b in ipairs(bolinhasBrancas) do table.insert(todasBolinhas, b) end
for _, b in ipairs(bolinhasAzuis) do table.insert(todasBolinhas, b) end

for i, b in ipairs(todasBolinhas) do
    if b.Parent then
        local ang = math.rad(math.random(0,360))
        local dist = math.random(300, 500)
        
        TweenService:Create(b, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.fromOffset(
                cx + math.cos(ang) * dist,
                cy + math.sin(ang) * dist
            ),
            BackgroundTransparency = 1,
            Size = UDim2.fromOffset(0, 0)
        }):Play()
    end
end

task.wait(1.5)

--// DESAPARECIMENTO LENTO DA TELA PRETA
local tempoFade = 4
local fadeInicio = tick()

-- Criar overlay para fade
local fadeOverlay = Instance.new("Frame", gui)
fadeOverlay.Size = UDim2.fromScale(1,1)
fadeOverlay.BackgroundColor3 = Color3.new(0,0,0)
fadeOverlay.BackgroundTransparency = 0
fadeOverlay.ZIndex = 1999

-- Animar desaparecimento gradual
local function atualizarFade()
    local tempoDecorrido = tick() - fadeInicio
    local progresso = math.min(tempoDecorrido / tempoFade, 1)
    
    local transparencia = 1 - progresso
    fundo.BackgroundTransparency = transparencia
    fadeOverlay.BackgroundTransparency = transparencia
    
    if progresso < 1 then
        return true
    end
    return false
end

-- Fazer algumas partículas finais durante o fade
for i = 1, 30 do
    local p = Instance.new("Frame", gui)
    local size = math.random(4, 10)
    p.Size = UDim2.fromOffset(size, size)
    p.AnchorPoint = Vector2.new(0.5,0.5)
    p.Position = UDim2.fromOffset(
        math.random(100, cam.ViewportSize.X - 100),
        math.random(100, cam.ViewportSize.Y - 100)
    )
    p.BackgroundColor3 = Color3.fromRGB(
        math.random(200, 255),
        math.random(200, 255),
        math.random(200, 255)
    )
    p.BorderSizePixel = 0
    p.ZIndex = 2000
    p.BackgroundTransparency = 0.3
    Instance.new("UICorner", p).CornerRadius = UDim.new(1,0)
    
    -- Animar desaparecimento
    local tempoVida = math.random(1, 3)
    TweenService:Create(p, TweenInfo.new(tempoVida, Enum.EasingStyle.Quad), {
        BackgroundTransparency = 1,
        Size = UDim2.fromOffset(0, 0)
    }):Play()
    
    task.wait(0.1)
end

-- Animar fade
local fadeConnection
fadeConnection = RunService.RenderStepped:Connect(function()
    if not atualizarFade() then
        fadeConnection:Disconnect()
    end
end)

task.wait(tempoFade)

-- Limpar tudo
gui:Destroy()