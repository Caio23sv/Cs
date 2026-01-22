-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

-- Player setup
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Criar ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "IntroGui"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true

-- Criar container para partículas
local particlesContainer = Instance.new("Frame")
particlesContainer.Name = "ParticlesContainer"
particlesContainer.Size = UDim2.new(1, 0, 1, 0)
particlesContainer.BackgroundTransparency = 1
particlesContainer.Parent = screenGui

-- Armazenar todas as partículas para efeito reverso
local allParticles = {}
local particleCount = 0

-- Criar faixa vermelha com gradiente
local stripe = Instance.new("Frame")
stripe.Name = "Stripe"
stripe.Size = UDim2.new(0, 0, 0.12, 0)
stripe.Position = UDim2.new(0, 0, 0.44, 0)
stripe.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
stripe.BorderSizePixel = 0

-- Adicionar gradiente à faixa
local stripeGradient = Instance.new("UIGradient")
stripeGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 30, 30)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 0, 0)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 0, 0))
})
stripeGradient.Rotation = 45
stripeGradient.Parent = stripe

stripe.Parent = screenGui

-- Função para criar texto 3D dourado com faíscas
local function createGolden3DText(parent)
	local textDepth = 5 -- Mais camadas para melhor 3D
	local baseText = "CAI_GR1"
	
	-- Cores do degradê dourado
	local goldenColors = {
		Color3.fromRGB(255, 215, 0),   -- Dourado claro
		Color3.fromRGB(255, 195, 0),   -- Dourado médio
		Color3.fromRGB(218, 165, 32),  -- Dourado
		Color3.fromRGB(184, 134, 11),  -- Dourado escuro
		Color3.fromRGB(153, 101, 21)   -- Dourado bronze
	}
	
	-- Criar camadas 3D (parte de trás primeiro)
	for i = textDepth, 1, -1 do
		local textLayer = Instance.new("TextLabel")
		textLayer.Name = "TextLayer" .. i
		textLayer.Size = UDim2.new(1, 0, 1, 0)
		textLayer.Position = UDim2.new(0, i * 3, 0, i * 3) -- Deslocamento maior para efeito 3D mais pronunciado
		textLayer.BackgroundTransparency = 1
		textLayer.Text = baseText
		textLayer.Font = Enum.Font.GothamBlack
		textLayer.TextSize = 46 - (i * 2)
		
		-- Cor dourada baseada na profundidade
		local colorIndex = math.min(i, #goldenColors)
		textLayer.TextColor3 = goldenColors[colorIndex]
		
		-- Efeito 3D com transparência
		textLayer.TextTransparency = 0.2 + (i * 0.12)
		textLayer.TextStrokeTransparency = 0.6
		textLayer.TextStrokeColor3 = Color3.fromRGB(101, 84, 0)
		textLayer.TextStrokeThickness = 2
		textLayer.ZIndex = i
		textLayer.Visible = false
		textLayer.Parent = parent
	end
	
	-- Camada frontal principal
	local mainText = Instance.new("TextLabel")
	mainText.Name = "MainText"
	mainText.Size = UDim2.new(1, 0, 1, 0)
	mainText.BackgroundTransparency = 1
	mainText.Text = baseText
	mainText.Font = Enum.Font.GothamBlack
	mainText.TextSize = 46
	mainText.TextTransparency = 1
	mainText.TextStrokeTransparency = 0.5
	mainText.TextStrokeColor3 = Color3.fromRGB(101, 84, 0)
	mainText.TextStrokeThickness = 3
	mainText.ZIndex = textDepth + 1
	mainText.Visible = true
	mainText.Parent = parent
	
	-- Degradê dourado principal
	local textGradient = Instance.new("UIGradient")
	textGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 150)), -- Dourado brilhante
		ColorSequenceKeypoint.new(0.3, Color3.fromRGB(255, 215, 0)),  -- Dourado claro
		ColorSequenceKeypoint.new(0.7, Color3.fromRGB(218, 165, 32)), -- Dourado
		ColorSequenceKeypoint.new(1, Color3.fromRGB(184, 134, 11))    -- Dourado escuro
	})
	textGradient.Rotation = 0
	textGradient.Parent = mainText
	
	-- Criar faíscas douradas ao redor do texto
	local function createSparkle(sparkleParent, offsetX, offsetY)
		local sparkle = Instance.new("Frame")
		sparkle.Size = UDim2.new(0, 6, 0, 6)
		sparkle.Position = UDim2.new(0.5, offsetX, 0.5, offsetY)
		sparkle.BackgroundColor3 = Color3.fromRGB(255, 255, 200)
		sparkle.BorderSizePixel = 0
		sparkle.ZIndex = textDepth + 2
		
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(1, 0)
		corner.Parent = sparkle
		
		-- Brilho da faísca
		local glow = Instance.new("Frame")
		glow.Size = UDim2.new(2, 0, 2, 0)
		glow.Position = UDim2.new(-0.5, 0, -0.5, 0)
		glow.BackgroundColor3 = Color3.fromRGB(255, 255, 150)
		glow.BackgroundTransparency = 0.7
		glow.BorderSizePixel = 0
		
		local glowCorner = Instance.new("UICorner")
		glowCorner.CornerRadius = UDim.new(1, 0)
		glowCorner.Parent = glow
		glow.Parent = sparkle
		
		sparkle.Parent = sparkleParent
		return sparkle
	end
	
	-- Adicionar faíscas ao redor do texto
	local sparklesContainer = Instance.new("Frame")
	sparklesContainer.Name = "SparklesContainer"
	sparklesContainer.Size = UDim2.new(1, 0, 1, 0)
	sparklesContainer.BackgroundTransparency = 1
	sparklesContainer.ZIndex = textDepth + 1
	sparklesContainer.Parent = parent
	
	-- Posições das faíscas
	local sparklePositions = {
		{-80, -25}, {-60, 15}, {-40, -15}, {-20, 25},
		{20, -25}, {40, 15}, {60, -15}, {80, 25}
	}
	
	local sparkles = {}
	for _, pos in ipairs(sparklePositions) do
		local sparkle = createSparkle(sparklesContainer, pos[1], pos[2])
		sparkle.Visible = false
		table.insert(sparkles, sparkle)
	end
	
	return mainText, sparkles
end

-- Criar container para texto 3D
local textContainer = Instance.new("Frame")
textContainer.Name = "TextContainer"
textContainer.Size = UDim2.new(1, 0, 1, 0)
textContainer.BackgroundTransparency = 1
textContainer.Parent = stripe

-- Criar texto 3D dourado com faíscas
local mainText, sparkles = createGolden3DText(textContainer)

-- Função para criar partículas vermelhas fortes
local function createParticle(position, sizeMultiplier)
	particleCount += 1
	
	-- Tamanho das bolinhas
	local baseSize = math.random(10, 22) * sizeMultiplier
	local particle = Instance.new("Frame")
	particle.Name = "Particle_" .. particleCount
	particle.Size = UDim2.new(0, baseSize, 0, baseSize)
	particle.Position = position
	particle.BackgroundColor3 = Color3.fromRGB(255, 30, 30) -- Vermelho forte
	particle.BorderSizePixel = 0
	particle.ZIndex = 10
	
	-- Tornar circular
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(1, 0)
	corner.Parent = particle
	
	-- Efeito de luz/brilho interno
	local innerGlow = Instance.new("Frame")
	innerGlow.Size = UDim2.new(0.7, 0, 0.7, 0)
	innerGlow.Position = UDim2.new(0.15, 0, 0.15, 0)
	innerGlow.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
	innerGlow.BorderSizePixel = 0
	innerGlow.BackgroundTransparency = 0.1
	
	local innerCorner = Instance.new("UICorner")
	innerCorner.CornerRadius = UDim.new(1, 0)
	innerCorner.Parent = innerGlow
	innerGlow.Parent = particle
	
	-- Brilho externo (halo) vermelho forte
	local outerGlow = Instance.new("Frame")
	outerGlow.Size = UDim2.new(3, 0, 3, 0)
	outerGlow.Position = UDim2.new(-1, 0, -1, 0)
	outerGlow.BackgroundColor3 = Color3.fromRGB(255, 30, 30)
	outerGlow.BorderSizePixel = 0
	outerGlow.BackgroundTransparency = 0.8
	outerGlow.ZIndex = 9
	
	local outerCorner = Instance.new("UICorner")
	outerCorner.CornerRadius = UDim.new(1, 0)
	outerCorner.Parent = outerGlow
	outerGlow.Parent = particle
	
	-- Gradiente vermelho forte
	local glowGradient = Instance.new("UIGradient")
	glowGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 100)),
		ColorSequenceKeypoint.new(0.3, Color3.fromRGB(255, 30, 30)),
		ColorSequenceKeypoint.new(0.7, Color3.fromRGB(200, 0, 0)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 0, 0))
	})
	glowGradient.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0),
		NumberSequenceKeypoint.new(0.5, 0.4),
		NumberSequenceKeypoint.new(1, 0.9)
	})
	glowGradient.Parent = particle
	
	-- Armazenar informação da partícula
	local particleInfo = {
		Instance = particle,
		StartPos = position,
		StartSize = particle.Size,
		Id = particleCount
	}
	
	table.insert(allParticles, particleInfo)
	
	return particle, particleInfo
end

-- Função para animar faíscas
local function animateSparkles(sparklesList)
	for _, sparkle in ipairs(sparklesList) do
		sparkle.Visible = true
		sparkle.Size = UDim2.new(0, 0, 0, 0)
		
		-- Animar aparecimento
		local appearTween = TweenService:Create(
			sparkle,
			TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
			{Size = UDim2.new(0, 6, 0, 6)}
		)
		
		appearTween:Play()
		
		-- Efeito de pulsação nas faíscas
		spawn(function()
			while sparkle.Parent do
				wait(math.random(2, 4) / 10)
				
				-- Brilhar intensamente
				local glowTween = TweenService:Create(
					sparkle,
					TweenInfo.new(0.2, Enum.EasingStyle.Quad),
					{
						Size = UDim2.new(0, 10, 0, 10),
						BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					}
				)
				
				glowTween:Play()
				glowTween.Completed:Wait()
				
				-- Voltar ao normal
				local unglowTween = TweenService:Create(
					sparkle,
					TweenInfo.new(0.2, Enum.EasingStyle.Quad),
					{
						Size = UDim2.new(0, 6, 0, 6),
						BackgroundColor3 = Color3.fromRGB(255, 255, 200)
					}
				)
				
				unglowTween:Play()
			end
		end)
	end
end

-- Função para explodir bolinhas vermelhas fortes
local function explodeParticles()
	local centerPos = UDim2.new(0.5, 0, 0.44, 0)
	local numParticles = 250 -- Mais bolinhas
	
	for i = 1, numParticles do
		spawn(function()
			-- Delay escalonado para efeito de explosão
			local delay = math.random(0, 400) / 1000
			wait(delay)
			
			-- Criar partícula vermelha forte
			local sizeMultiplier = 0.9 + math.random() * 0.8
			local particle, particleInfo = createParticle(centerPos, sizeMultiplier)
			particle.Parent = particlesContainer
			
			-- Calcular direção aleatória
			local angle = math.random() * 2 * math.pi
			local distance = math.random(350, 800)
			
			-- Posição final aleatória
			local targetX = math.cos(angle) * distance + math.random(-150, 150)
			local targetY = math.sin(angle) * distance + math.random(-150, 150)
			
			-- Tamanho final
			local finalSize = particle.Size.X.Offset * 0.85
			
			-- Animar partícula
			local tweenInfo = TweenInfo.new(
				math.random(1.3, 2),
				Enum.EasingStyle.Quad,
				Enum.EasingDirection.Out,
				0,
				false,
				0
			)
			
			local particleTween = TweenService:Create(
				particle,
				tweenInfo,
				{
					Position = UDim2.new(0.5, targetX, 0.44, targetY),
					Size = UDim2.new(0, finalSize, 0, finalSize),
					Rotation = math.random(0, 360),
					BackgroundTransparency = 0
				}
			)
			
			particleTween:Play()
			
			-- Efeito de pulsação vermelha forte
			spawn(function()
				while particle.Parent do
					local pulseTween = TweenService:Create(
						particle,
						TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
						{
							Size = UDim2.new(0, finalSize * 1.4, 0, finalSize * 1.4),
							BackgroundColor3 = Color3.fromRGB(255, 80, 80),
							BackgroundTransparency = 0
						}
					)
					
					pulseTween:Play()
					pulseTween.Completed:Wait()
					
					local reversePulse = TweenService:Create(
						particle,
						TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
						{
							Size = UDim2.new(0, finalSize, 0, finalSize),
							BackgroundColor3 = Color3.fromRGB(255, 30, 30),
							BackgroundTransparency = 0
						}
					)
					
					reversePulse:Play()
					reversePulse.Completed:Wait()
				end
			end)
			
			-- Armazenar posição final para reverso
			particleInfo.FinalPos = UDim2.new(0.5, targetX, 0.44, targetY)
			particleInfo.FinalSize = UDim2.new(0, finalSize, 0, finalSize)
		end)
	end
	
	-- Adicionar mais partículas
	wait(0.3)
	
	for i = 1, 150 do
		spawn(function()
			local delay = math.random(0, 300) / 1000
			wait(delay)
			
			-- Posição inicial aleatória
			local startPos = UDim2.new(
				math.random(5, 95) / 100,
				math.random(-200, 200),
				math.random(5, 95) / 100,
				math.random(-200, 200)
			)
			
			-- Criar partícula
			local sizeMultiplier = 0.8 + math.random() * 0.7
			local particle, particleInfo = createParticle(startPos, sizeMultiplier)
			particle.Parent = particlesContainer
			
			-- Animar para fora
			local angle = math.atan2(
				startPos.Y.Offset,
				startPos.X.Offset
			) + (math.random() - 0.5) * 2
			
			local distance = math.random(300, 700)
			local targetX = math.cos(angle) * distance
			local targetY = math.sin(angle) * distance
			
			local finalSize = particle.Size.X.Offset * 0.8
			
			local tweenInfo = TweenInfo.new(
				math.random(1.5, 2.2),
				Enum.EasingStyle.Quad,
				Enum.EasingDirection.Out,
				0,
				false,
				0
			)
			
			local particleTween = TweenService:Create(
				particle,
				tweenInfo,
				{
					Position = UDim2.new(
						startPos.X.Scale,
						targetX,
						startPos.Y.Scale,
						targetY
					),
					Size = UDim2.new(0, finalSize, 0, finalSize),
					Rotation = math.random(0, 360)
				}
			)
			
			particleTween:Play()
			
			particleInfo.FinalPos = UDim2.new(startPos.X.Scale, targetX, startPos.Y.Scale, targetY)
			particleInfo.FinalSize = UDim2.new(0, finalSize, 0, finalSize)
		end)
	end
end

-- Função para reverso das bolinhas
local function reverseParticles()
	local centerPos = UDim2.new(0.5, 0, 0.44, 0)
	local reversed = 0
	
	-- Animar todas as partículas de volta ao centro
	for _, particleInfo in ipairs(allParticles) do
		if particleInfo.Instance and particleInfo.Instance.Parent then
			spawn(function()
				-- Delay escalonado
				local delay = math.random(0, 250) / 1000
				wait(delay)
				
				-- Animar de volta ao centro
				local reverseTween = TweenService:Create(
					particleInfo.Instance,
					TweenInfo.new(
						math.random(0.9, 1.3),
						Enum.EasingStyle.Quad,
						Enum.EasingDirection.In
					),
					{
						Position = centerPos,
						Size = UDim2.new(0, 0, 0, 0),
						BackgroundTransparency = 1,
						Rotation = 0
					}
				)
				
				reverseTween:Play()
				reverseTween.Completed:Wait()
				
				-- Destruir partícula
				particleInfo.Instance:Destroy()
				reversed += 1
				
				-- Se todas as partículas foram revertidas, remover GUI
				if reversed >= #allParticles then
					wait(0.5)
					screenGui:Destroy()
				end
			end)
		end
	end
	
	-- Segurança
	wait(3)
	if screenGui.Parent then
		screenGui:Destroy()
	end
end

-- Animação principal
local function playAnimation()
	-- Primeira fase: faixa expande
	local expandTween = TweenService:Create(
		stripe,
		TweenInfo.new(1.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
		{Size = UDim2.new(1, 0, 0.12, 0)}
	)
	
	expandTween:Play()
	expandTween.Completed:Wait()
	
	-- Mostrar camadas 3D do texto dourado
	for _, child in ipairs(textContainer:GetChildren()) do
		if child:IsA("TextLabel") then
			child.Visible = true
			if child.Name == "MainText" then
				-- Animar fade in do texto principal dourado
				local textFadeIn = TweenService:Create(
					child,
					TweenInfo.new(1, Enum.EasingStyle.Quad),
					{TextTransparency = 0}
				)
				textFadeIn:Play()
				
				-- Efeito de brilho no texto dourado
				spawn(function()
					wait(0.5)
					for i = 1, 2 do
						local glowOut = TweenService:Create(
							child,
							TweenInfo.new(0.4, Enum.EasingStyle.Quad),
							{
								TextSize = 50,
								TextStrokeTransparency = 0.2,
								TextColor3 = Color3.fromRGB(255, 255, 200)
							}
						)
						
						glowOut:Play()
						glowOut.Completed:Wait()
						
						local glowIn = TweenService:Create(
							child,
							TweenInfo.new(0.4, Enum.EasingStyle.Quad),
							{
								TextSize = 46,
								TextStrokeTransparency = 0.5,
								TextColor3 = Color3.fromRGB(255, 215, 0)
							}
						)
						
						glowIn:Play()
						glowIn.Completed:Wait()
					end
				end)
				
				-- Animar faíscas
				animateSparkles(sparkles)
			else
				-- Animar fade in das camadas 3D
				local layerFadeIn = TweenService:Create(
					child,
					TweenInfo.new(1, Enum.EasingStyle.Quad),
					{TextTransparency = child.TextTransparency}
				)
				layerFadeIn:Play()
			end
		end
	end
	
	-- Esperar um pouco
	wait(0.8)
	
	-- Segunda fase: recolher faixa
	local shrinkTween = TweenService:Create(
		stripe,
		TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
		{Size = UDim2.new(0, 0, 0.12, 0), Position = UDim2.new(0.5, 0, 0.44, 0)}
	)
	
	shrinkTween:Play()
	shrinkTween.Completed:Connect(function()
		-- Esconder faixa e texto
		stripe.Visible = false
		
		-- Explodir bolinhas vermelhas fortes
		explodeParticles()
		
		-- Esperar e depois fazer reverso
		wait(2.8)
		reverseParticles()
	end)
end

-- Iniciar animação
wait(0.5)
playAnimation()