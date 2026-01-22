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

--// BIG BANG - BOLINHAS VERMELHAS
local bolinhas = {}
local center = UDim2.fromScale(0.5,0.5)
local cx, cy = cam.ViewportSize.X/2, cam.ViewportSize.Y/2

-- Criar bolinhas vermelhas
for i = 1, 180 do
    local b = Instance.new("Frame", gui)
    local s = math.random(6, 12)
    b.Size = UDim2.fromOffset(s,s)
    b.AnchorPoint = Vector2.new(0.5,0.5)
    b.Position = center
    b.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    b.BorderSizePixel = 0
    b.ZIndex = 1020
    b.BackgroundTransparency = 0.3
    Instance.new("UICorner", b).CornerRadius = UDim.new(1,0)
    table.insert(bolinhas, b)

    local ang = math.rad(math.random(0,360))
    local dist = math.random(300, 650)

    TweenService:Create(b, TweenInfo.new(1.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Position = UDim2.fromOffset(
            cx + math.cos(ang)*dist,
            cy + math.sin(ang)*dist
        ),
        BackgroundTransparency = 0
    }):Play()
end

faixa.Visible = false

task.wait(1.2)

--// ANIMAÇÃO DE MOVIMENTO CAÓTICO ANTES DE FORMAR LETRAS
-- Primeiro, trazer todas as bolinhas para área central com movimento aleatório
for i, b in ipairs(bolinhas) do
    local targetX = cx + math.random(-200, 200)
    local targetY = cy + math.random(-150, 150)
    
    TweenService:Create(b, TweenInfo.new(1, Enum.EasingStyle.Quad), {
        Position = UDim2.fromOffset(targetX, targetY),
        BackgroundTransparency = 0.2,
        Size = UDim2.fromOffset(8, 8)
    }):Play()
end

task.wait(1)

--// MOVIMENTO DINÂMICO - BOLINHAS SE MOVENDO ALEATORIAMENTE
local movimentoAtivo = true
local tempoMovimento = 0

-- Função para movimento contínuo das bolinhas
local function iniciarMovimentoDinamico()
    while movimentoAtivo do
        tempoMovimento = tempoMovimento + 0.1
        
        for i, b in ipairs(bolinhas) do
            if b.Parent then
                -- Movimento senoidal para efeito de "vibração"
                local offsetX = math.sin(tempoMovimento + i * 0.1) * 15
                local offsetY = math.cos(tempoMovimento + i * 0.05) * 10
                
                -- Mover suavemente
                local currentPos = b.Position
                b.Position = UDim2.fromOffset(
                    currentPos.X.Offset + offsetX * 0.1,
                    currentPos.Y.Offset + offsetY * 0.1
                )
                
                -- Leve mudança de tamanho
                if math.random(1, 30) == 1 then
                    TweenService:Create(b, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {
                        Size = UDim2.fromOffset(math.random(6, 10), math.random(6, 10))
                    }):Play()
                end
            end
        end
        
        task.wait(0.05)
    end
end

-- Iniciar movimento dinâmico
task.spawn(iniciarMovimentoDinamico)

-- Mantém o movimento por 2 segundos
task.wait(2)

--// DEFINIR POSIÇÕES DAS LETRAS "CAI"
local function criarPosicoesCAI()
    local posicoes = {}
    local escala = 1.8
    local espacamento = 140
    
    -- Letra C
    local baseXC = cx - espacamento
    -- Arco externo da letra C
    for ang = 45, 315, 10 do
        local rad = math.rad(ang)
        local raio = 50 * escala
        table.insert(posicoes, {
            x = baseXC + math.cos(rad) * raio,
            y = cy + math.sin(rad) * raio,
            letra = "C",
            delay = (ang - 45) / 270 * 0.5
        })
    end
    
    -- Letra A
    local baseXA = cx
    -- Triângulo superior do A
    for ponto = 1, 3 do
        local x, y
        if ponto == 1 then -- Ponto esquerdo
            x = baseXA - 40 * escala
            y = cy - 40 * escala
        elseif ponto == 2 then -- Ponto direito
            x = baseXA + 40 * escala
            y = cy - 40 * escala
        else -- Ponto inferior central
            x = baseXA
            y = cy + 40 * escala
        end
        
        table.insert(posicoes, {
            x = x,
            y = y,
            letra = "A",
            delay = (ponto-1) * 0.1
        })
    end
    
    -- Linha horizontal do A
    for x = -20 * escala, 20 * escala, 10 * escala do
        table.insert(posicoes, {
            x = baseXA + x,
            y = cy,
            letra = "A",
            delay = 0.3
        })
    end
    
    -- Letra I
    local baseXI = cx + espacamento
    -- Linha vertical do I
    for y = -50 * escala, 50 * escala, 15 * escala do
        table.insert(posicoes, {
            x = baseXI,
            y = cy + y,
            letra = "I",
            delay = math.abs(y) / 100 * 0.3
        })
    end
    
    -- Pontos superior e inferior do I
    table.insert(posicoes, {x = baseXI, y = cy - 60 * escala, letra = "I", delay = 0})
    table.insert(posicoes, {x = baseXI, y = cy + 60 * escala, letra = "I", delay = 0.3})
    
    return posicoes
end

local posicoesCAI = criarPosicoesCAI()

-- Parar movimento dinâmico
movimentoAtivo = false

-- Pequeno delay para transição
task.wait(0.3)

--// ANIMAÇÃO DE FORMAÇÃO DAS LETRAS COM MOVIMENTO
-- Primeiro, agrupar bolinhas em áreas gerais das letras
for i, b in ipairs(bolinhas) do
    local letraIndex = math.floor((i-1) / (#bolinhas/3)) + 1
    local letra = {"C", "A", "I"}[letraIndex]
    
    local areaX = cx
    if letra == "C" then
        areaX = cx - 140
    elseif letra == "A" then
        areaX = cx
    else -- I
        areaX = cx + 140
    end
    
    -- Mover para área geral da letra
    TweenService:Create(b, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.fromOffset(
            areaX + math.random(-60, 60),
            cy + math.random(-60, 60)
        ),
        BackgroundTransparency = 0,
        Size = UDim2.fromOffset(10, 10)
    }):Play()
end

task.wait(0.8)

--// FORMAÇÃO FINAL DAS LETRAS
-- Agora posicionar cada bolinha em sua posição exata na letra
local bolinhaIndex = 1
for _, pos in ipairs(posicoesCAI) do
    if bolinhaIndex <= #bolinhas then
        local b = bolinhas[bolinhaIndex]
        
        -- Delay baseado na posição na letra
        task.spawn(function()
            task.wait(pos.delay or 0)
            
            -- Cor baseada na letra
            local cor
            if pos.letra == "C" then
                cor = Color3.fromRGB(255, 80, 80)  -- Vermelho escuro
            elseif pos.letra == "A" then
                cor = Color3.fromRGB(255, 120, 80) -- Laranja avermelhado
            else -- I
                cor = Color3.fromRGB(255, 160, 80) -- Laranja claro
            end
            
            -- Efeito de "snap" para posição final
            TweenService:Create(b, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Position = UDim2.fromOffset(pos.x, pos.y),
                BackgroundColor3 = cor,
                Size = UDim2.fromOffset(12, 12)
            }):Play()
        end)
        
        bolinhaIndex = bolinhaIndex + 1
    end
end

task.wait(1)

--// ANIMAÇÃO DAS LETRAS FORMADAS
-- Efeito de pulsação nas letras
for pulse = 1, 3 do
    for i, b in ipairs(bolinhas) do
        local currentColor = b.BackgroundColor3
        local brilhoColor = Color3.new(
            math.min(currentColor.r * 1.3, 1),
            math.min(currentColor.g * 1.3, 1),
            math.min(currentColor.b * 1.3, 1)
        )
        
        TweenService:Create(b, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {
            BackgroundColor3 = brilhoColor,
            Size = UDim2.fromOffset(14, 14)
        }):Play()
    end
    
    task.wait(0.4)
    
    for i, b in ipairs(bolinhas) do
        -- Voltar para cor original baseada na posição
        local posX, posY = b.Position.X.Offset, b.Position.Y.Offset
        
        local corOriginal
        if posX < cx - 70 then  -- Letra C
            corOriginal = Color3.fromRGB(255, 80, 80)
        elseif posX > cx + 70 then  -- Letra I
            corOriginal = Color3.fromRGB(255, 160, 80)
        else  -- Letra A
            corOriginal = Color3.fromRGB(255, 120, 80)
        end
        
        TweenService:Create(b, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {
            BackgroundColor3 = corOriginal,
            Size = UDim2.fromOffset(12, 12)
        }):Play()
    end
    
    task.wait(0.4)
end

--// EFEITO DE "ENERGIA" PERCORRENDO AS LETRAS
local function ondaEnergia(letraInicial)
    local sequencia = {"C", "A", "I"}
    
    for _, letra in ipairs(sequencia) do
        for i, b in ipairs(bolinhas) do
            local posX = b.Position.X.Offset
            local letraBolinha
            
            if posX < cx - 70 then
                letraBolinha = "C"
            elseif posX > cx + 70 then
                letraBolinha = "I"
            else
                letraBolinha = "A"
            end
            
            if letraBolinha == letra then
                local delay = math.random() * 0.1
                
                task.spawn(function()
                    task.wait(delay)
                    
                    TweenService:Create(b, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {
                        BackgroundColor3 = Color3.fromRGB(255, 255, 200),
                        Size = UDim2.fromOffset(14, 14)
                    }):Play()
                    
                    task.wait(0.15)
                    
                    local corOriginal
                    if letra == "C" then
                        corOriginal = Color3.fromRGB(255, 80, 80)
                    elseif letra == "A" then
                        corOriginal = Color3.fromRGB(255, 120, 80)
                    else
                        corOriginal = Color3.fromRGB(255, 160, 80)
                    end
                    
                    TweenService:Create(b, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {
                        BackgroundColor3 = corOriginal,
                        Size = UDim2.fromOffset(12, 12)
                    }):Play()
                end)
            end
        end
        
        task.wait(0.3)
    end
end

-- Executar onda de energia 2 vezes
for i = 1, 2 do
    ondaEnergia("C")
    task.wait(0.5)
end

task.wait(1)

--// DESMONTAGEM DINÂMICA DAS LETRAS
-- Começar a desmontar das bordas para o centro
local function desmontarPorCamadas()
    -- Ordenar bolinhas pela distância do centro
    local bolinhasOrdenadas = {}
    for i, b in ipairs(bolinhas) do
        local dist = math.sqrt(
            (b.Position.X.Offset - cx)^2 + 
            (b.Position.Y.Offset - cy)^2
        )
        table.insert(bolinhasOrdenadas, {frame = b, distancia = dist})
    end
    
    -- Ordenar por distância (mais longe primeiro)
    table.sort(bolinhasOrdenadas, function(a, b)
        return a.distancia > b.distancia
    end)
    
    -- Animar desaparecimento
    for i, data in ipairs(bolinhasOrdenadas) do
        local b = data.frame
        local delay = (i / #bolinhasOrdenadas) * 0.3
        
        task.spawn(function()
            task.wait(delay)
            
            -- Direção oposta ao centro
            local ang = math.atan2(
                b.Position.Y.Offset - cy,
                b.Position.X.Offset - cx
            )
            local dist = 300 + math.random(0, 100)
            
            TweenService:Create(b, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.fromOffset(
                    b.Position.X.Offset + math.cos(ang) * dist,
                    b.Position.Y.Offset + math.sin(ang) * dist
                ),
                BackgroundTransparency = 0.7,
                Size = UDim2.fromOffset(8, 8)
            }):Play()
        end)
    end
end

desmontarPorCamadas()
task.wait(1)

--// FASE FINAL - DESAPARECIMENTO
-- Todas as bolinhas desaparecem completamente
for i, b in ipairs(bolinhas) do
    if b.Parent then
        local ang = math.rad(math.random(0,360))
        local dist = math.random(400, 600)
        
        TweenService:Create(b, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.fromOffset(
                b.Position.X.Offset + math.cos(ang) * dist,
                b.Position.Y.Offset + math.sin(ang) * dist
            ),
            BackgroundTransparency = 1,
            Size = UDim2.fromOffset(0, 0)
        }):Play()
    end
end

--// FADE OUT LENTO DA TELA PRETA
local fadeTime = 4
local startTime = tick()

-- Criar partículas finais durante o fade
for i = 1, 40 do
    task.spawn(function()
        task.wait(i * 0.1)
        
        local dot = Instance.new("Frame", gui)
        dot.Size = UDim2.fromOffset(4, 4)
        dot.AnchorPoint = Vector2.new(0.5,0.5)
        dot.Position = UDim2.fromOffset(
            math.random(50, cam.ViewportSize.X - 50),
            math.random(50, cam.ViewportSize.Y - 50)
        )
        dot.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
        dot.ZIndex = 2000
        dot.BackgroundTransparency = 0.4
        dot.BorderSizePixel = 0
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1,0)
        
        -- Movimento aleatório
        TweenService:Create(dot, TweenInfo.new(1, Enum.EasingStyle.Quad), {
            Position = UDim2.fromOffset(
                dot.Position.X.Offset + math.random(-50, 50),
                dot.Position.Y.Offset + math.random(-50, 50)
            ),
            BackgroundTransparency = 0.8
        }):Play()
        
        task.wait(1)
        
        if dot.Parent then
            TweenService:Create(dot, TweenInfo.new(1, Enum.EasingStyle.Quad), {
                BackgroundTransparency = 1,
                Size = UDim2.fromOffset(0, 0)
            }):Play()
        end
    end)
end

-- Animar fade do fundo
local function updateFade()
    local elapsed = tick() - startTime
    local progress = math.min(elapsed / fadeTime, 1)
    
    fundo.BackgroundTransparency = progress
    
    return progress < 1
end

-- Atualizar fade
local fadeConnection
fadeConnection = RunService.RenderStepped:Connect(function()
    if not updateFade() then
        fadeConnection:Disconnect()
    end
end)

task.wait(fadeTime)

-- Limpar tudo
gui:Destroy()