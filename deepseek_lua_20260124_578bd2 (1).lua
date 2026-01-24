local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

print("[CAI HUB] Iniciando...")

-- 1. VALORES E BYPASS APRIMORADO
local currentSpeed = 16
local currentJump = 50
local lastHealth = 100
local originalWalkSpeed = 16
local originalJumpPower = 50
local antiDamageEnabled = true

-- Sistema de proteção contra dano de anti-cheat
local function SetupAntiDamageProtection(char)
    if not char or not char:FindFirstChild("Humanoid") then return end
    
    local hum = char:WaitForChild("Humanoid")
    local root = char:WaitFirstChild("HumanoidRootPart")
    
    hum.HealthChanged:Connect(function()
        if not antiDamageEnabled then return end
        
        if hum.Health < lastHealth then
            local damageTaken = lastHealth - hum.Health
            
            -- Verifica se o dano ocorreu durante movimento/pulo
            if root then
                local velocity = root.Velocity
                local horizontalSpeed = Vector3.new(velocity.X, 0, velocity.Z).Magnitude
                local verticalSpeed = math.abs(velocity.Y)
                
                -- Se a velocidade estiver alta e tomar dano, provavelmente é anti-cheat
                if (horizontalSpeed > 50 or verticalSpeed > 100) and damageTaken > 0 then
                    -- Recupera a saúde perdida
                    hum.Health = lastHealth
                    
                    -- Log do evento
                    warn("[CAI HUB] Anti-cheat de dano detectado e neutralizado!")
                    warn(string.format("Velocidade: %.1f | Pulo: %.1f | Dano: %.1f", 
                        horizontalSpeed, verticalSpeed, damageTaken))
                end
            end
        end
        lastHealth = hum.Health
    end)
end

-- BYPASS MELHORADO para evitar detecção de anti-cheat
local function ApplyBypass(char)
    local hum = char:WaitForChild("Humanoid")
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    
    local oldIndex = mt.__index
    mt.__index = newcclosure(function(t, k)
        if not checkcaller() and t == hum then
            if k == "WalkSpeed" then
                return originalWalkSpeed
            elseif k == "JumpPower" then
                return originalJumpPower
            elseif k == "Health" then
                -- Mantém a saúde inalterada para scripts externos
                return lastHealth
            end
        end
        return oldIndex(t, k)
    end)
    
    -- Previne alterações de velocidade por outros scripts
    local oldNewIndex = mt.__newindex
    mt.__newindex = newcclosure(function(t, k, v)
        if not checkcaller() and t == hum then
            if k == "WalkSpeed" and v ~= originalWalkSpeed then
                return nil -- Bloqueia alterações
            elseif k == "JumpPower" and v ~= originalJumpPower then
                return nil -- Bloqueia alterações
            elseif k == "Health" and v < lastHealth then
                -- Bloqueia danos quando a velocidade está alta
                if t.Parent and t.Parent:FindFirstChild("HumanoidRootPart") then
                    local root = t.Parent.HumanoidRootPart
                    local velocity = root.Velocity
                    local horizontalSpeed = Vector3.new(velocity.X, 0, velocity.Z).Magnitude
                    local verticalSpeed = math.abs(velocity.Y)
                    
                    if horizontalSpeed > 50 or verticalSpeed > 100 then
                        warn("[CAI HUB] Dano por anti-cheat bloqueado!")
                        return nil
                    end
                end
            end
        end
        return oldNewIndex(t, k, v)
    end)
    
    setreadonly(mt, true)
end

-- Remove GUI antiga se existir
if PlayerGui:FindFirstChild("CaiHub_Ultimate_V9") then 
    PlayerGui.CaiHub_Ultimate_V9:Destroy() 
    print("[CAI HUB] GUI antiga removida.")
end

-- 2. ESTRUTURA PRINCIPAL
print("[CAI HUB] Criando GUI...")
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CaiHub_Ultimate_V9"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.Size = UDim2.new(0, 460, 0, 280)
MainFrame.Visible = false
MainFrame.ZIndex = 1
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Thickness = 2
MainStroke.Color = Color3.fromRGB(0, 255, 255)

local DragBar = Instance.new("Frame", MainFrame)
DragBar.Size = UDim2.new(1, 0, 0, 40)
DragBar.BackgroundTransparency = 1
DragBar.ZIndex = 10

-- 3. DECORAÇÃO
local Title = Instance.new("TextLabel", MainFrame)
Title.Text = "CAI HUB"
Title.Position = UDim2.new(0, 48, 0, 8)
Title.Size = UDim2.new(0, 150, 0, 28)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.BackgroundTransparency = 1
Title.ZIndex = 3
Title.TextXAlignment = 0

local Logo = Instance.new("Frame", MainFrame)
Logo.Size = UDim2.new(0, 28, 0, 28)
Logo.Position = UDim2.new(0, 12, 0, 8)
Logo.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
Logo.ZIndex = 3
Instance.new("UICorner", Logo).CornerRadius = UDim.new(1, 0)

local LT = Instance.new("TextLabel", Logo)
LT.Text = "C"
LT.Size = UDim2.new(1,0,1,0)
LT.BackgroundTransparency = 1
LT.TextColor3 = Color3.fromRGB(0,0,0)
LT.Font = Enum.Font.GothamBold
LT.ZIndex = 4

local LineH = Instance.new("Frame", MainFrame)
LineH.Position = UDim2.new(0, 10, 0, 42)
LineH.Size = UDim2.new(0, 440, 0, 2)
LineH.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
LineH.ZIndex = 2
LineH.BorderSizePixel = 0

local LineV = Instance.new("Frame", MainFrame)
LineV.Position = UDim2.new(0, 135, 0, 50)
LineV.Size = UDim2.new(0, 2, 0, 215)
LineV.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
LineV.ZIndex = 2
LineV.BorderSizePixel = 0

-- 4. SISTEMA DE ABAS (BORDAS AJUSTADAS)
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Position = UDim2.new(0, 8, 0, 55)
Sidebar.Size = UDim2.new(0, 120, 0, 215)
Sidebar.BackgroundTransparency = 1
Sidebar.ZIndex = 4

Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 5)

local PageContainer = Instance.new("Frame", MainFrame)
PageContainer.Position = UDim2.new(0, 145, 0, 55)
PageContainer.Size = UDim2.new(0, 305, 0, 215)
PageContainer.BackgroundTransparency = 1
PageContainer.ZIndex = 4

local Pages = {}
local SidebarButtons = {}
local lastOpenPage = "Configurar"

local function createPage(name)
    local p = Instance.new("ScrollingFrame", PageContainer)
    p.Name = name
    p.Size = UDim2.new(1, 0, 1, 0)
    p.BackgroundTransparency = 1
    p.Visible = false
    p.ScrollBarThickness = 0
    p.ZIndex = 5
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 8)
    Pages[name] = p
    return p
end

local function addTab(name, isFirst)
    local b = Instance.new("TextButton", Sidebar)
    b.Size = UDim2.new(1, 0, 0, 35)
    b.BackgroundColor3 = Color3.fromRGB(22, 22, 25)
    b.Text = name
    b.TextColor3 = Color3.fromRGB(150, 150, 150)
    b.Font = Enum.Font.GothamMedium
    b.ZIndex = 6
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    
    local s = Instance.new("UIStroke", b)
    s.Color = Color3.fromRGB(0, 255, 255)
    s.Thickness = 1.2
    s.Transparency = (isFirst and 0 or 1)
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    
    if isFirst then 
        b.TextColor3 = Color3.fromRGB(255, 255, 255) 
    end
    
    b.MouseButton1Click:Connect(function()
        for n, pg in pairs(Pages) do 
            pg.Visible = (n == name) 
        end
        for _, btn in pairs(SidebarButtons) do 
            btn.TextColor3 = Color3.fromRGB(150, 150, 150)
            btn.UIStroke.Transparency = 1 
        end
        b.TextColor3 = Color3.fromRGB(255, 255, 255)
        s.Transparency = 0
        lastOpenPage = name
    end)
    
    SidebarButtons[name] = b
    return b
end

-- 5. ABA CONFIGURAR + SCANNER COMPLETO E DETALHADO
addTab("Configurar", true)
local pConfig = createPage("Configurar")

local function addBtn(page, txt, call)
    local b = Instance.new("TextButton", page)
    b.Size = UDim2.new(0, 280, 0, 32)
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    b.Text = "  "..txt
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.GothamMedium
    b.TextSize = 13
    b.TextXAlignment = 0
    b.ZIndex = 7
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(call)
    return b
end

addBtn(pConfig, "Rejoin Server", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, Player)
end)

-- Botão para alternar proteção contra dano
local protectionBtn = addBtn(pConfig, "✅ Proteção Anti-Dano: ATIVADA", function()
    antiDamageEnabled = not antiDamageEnabled
    protectionBtn.Text = antiDamageEnabled and "  ✅ Proteção Anti-Dano: ATIVADA" or "  ❌ Proteção Anti-Dano: DESATIVADA"
    if antiDamageEnabled then
        warn("[CAI HUB] Proteção contra dano ativada!")
    else
        warn("[CAI HUB] Proteção contra dano desativada!")
    end
end)

-- TELA DO CONSOLE MELHORADA
local Console = Instance.new("ScrollingFrame", pConfig)
Console.Size = UDim2.new(0, 280, 0, 140)
Console.BackgroundColor3 = Color3.fromRGB(5, 5, 8)
Console.ZIndex = 7
Console.AutomaticCanvasSize = Enum.AutomaticSize.Y
Console.ScrollBarThickness = 2
Console.CanvasSize = UDim2.new(0, 0, 0, 0)
Instance.new("UICorner", Console)

local LogLayout = Instance.new("UIListLayout", Console)
LogLayout.Padding = UDim.new(0, 2)
LogLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Console.CanvasSize = UDim2.new(0, 0, 0, LogLayout.AbsoluteContentSize.Y)
end)

local function logScan(txt, col)
    local l = Instance.new("TextLabel", Console)
    l.Size = UDim2.new(1, -10, 0, 16)
    l.BackgroundTransparency = 1
    l.Text = "["..os.date("%H:%M:%S").."] "..txt
    l.TextColor3 = col or Color3.fromRGB(180, 180, 180)
    l.Font = Enum.Font.Code
    l.TextSize = 10
    l.TextXAlignment = 0
    l.TextYAlignment = Enum.TextYAlignment.Top
    l.ZIndex = 8
    l.TextWrapped = true
    l.AutomaticSize = Enum.AutomaticSize.Y
end

local StatusF = Instance.new("Frame", pConfig)
StatusF.Size = UDim2.new(0, 280, 0, 25)
StatusF.BackgroundTransparency = 1
StatusF.ZIndex = 7

local Ball = Instance.new("Frame", StatusF)
Ball.Size = UDim2.new(0, 12, 0, 12)
Ball.Position = UDim2.new(0, 5, 0, 6)
Ball.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
Ball.ZIndex = 8
Instance.new("UICorner", Ball).CornerRadius = UDim.new(1, 0)

local StatusT = Instance.new("TextLabel", StatusF)
StatusT.Size = UDim2.new(0, 250, 1, 0)
StatusT.Position = UDim2.new(0, 25, 0, 0)
StatusT.BackgroundTransparency = 1
StatusT.Text = "Aguardando Varredura..."
StatusT.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusT.ZIndex = 8
StatusT.TextXAlignment = 0
StatusT.Font = Enum.Font.Gotham
StatusT.TextSize = 12

-- DETECTOR ESPECIALIZADO EM ANTI-CHEATS DE DANO
local function detectDamageAntiCheats()
    local damageScripts = {}
    
    -- Verifica scripts no ReplicatedStorage
    local repStorage = game:GetService("ReplicatedStorage")
    for _, obj in pairs(repStorage:GetDescendants()) do
        if obj:IsA("Script") or obj:IsA("LocalScript") or obj:IsA("ModuleScript") then
            local success, source = pcall(function() return obj.Source end)
            if success and source then
                local lowerSource = source:lower()
                
                -- Padrões comuns de anti-cheat de dano
                local patterns = {
                    "health.*damage.*speed",
                    "speed.*damage.*health",
                    "jump.*damage.*health",
                    "walkspeed.*damage",
                    "jumppower.*damage",
                    "velocity.*damage",
                    "antiexploit.*damage",
                    "if.*speed.*>.*then.*damage",
                    "if.*walkspeed.*>.*then",
                    "if.*jumppower.*>.*then",
                    "hum%.health.*=",
                    "humanoid%.health.*="
                }
                
                for _, pattern in pairs(patterns) do
                    if string.find(lowerSource, pattern) then
                        table.insert(damageScripts, {
                            Name = obj.Name,
                            Path = obj:GetFullName(),
                            Type = obj.ClassName,
                            Pattern = pattern
                        })
                        break
                    end
                end
            end
        end
    end
    
    -- Verifica no ServerScriptService
    local serverScripts = game:GetService("ServerScriptService")
    for _, obj in pairs(serverScripts:GetDescendants()) do
        if obj:IsA("Script") or obj:IsA("LocalScript") or obj:IsA("ModuleScript") then
            local success, source = pcall(function() return obj.Source end)
            if success and source then
                local lowerSource = source:lower()
                
                if string.find(lowerSource, "damage") and (string.find(lowerSource, "speed") or string.find(lowerSource, "jump") or string.find(lowerSource, "walkspeed") or string.find(lowerSource, "jumppower")) then
                    table.insert(damageScripts, {
                        Name = obj.Name,
                        Path = obj:GetFullName(),
                        Type = obj.ClassName,
                        Reason = "Combinou 'damage' com 'speed/jump'"
                    })
                end
            end
        end
    end
    
    return damageScripts
end

-- SCANNER COMPLETO QUE ANALISA TUDO
local function deepScan(obj, depth, path)
    local results = {}
    local antiCheats = {}
    local remotes = {}
    local errors = {}
    
    if depth > 10 then return results, antiCheats, remotes, errors end
    
    local function safeGetChildren(obj)
        local success, children = pcall(function()
            return obj:GetChildren()
        end)
        if success then
            return children
        else
            table.insert(errors, "Erro ao acessar: "..path)
            return {}
        end
    end
    
    local children = safeGetChildren(obj)
    
    for _, child in ipairs(children) do
        local newPath = path.."/"..child.Name
        
        -- Verifica por Anti-Cheats
        local nameLower = child.Name:lower()
        if string.find(nameLower, "anti") or 
           string.find(nameLower, "ac_") or 
           string.find(nameLower, "cheat") or 
           string.find(nameLower, "hack") or 
           string.find(nameLower, "shield") or 
           string.find(nameLower, "guard") or 
           string.find(nameLower, "protect") or
           string.find(nameLower, "detect") or
           string.find(nameLower, "security") or
           string.find(nameLower, "damage") then
            table.insert(antiCheats, {
                Name = child.Name,
                Path = newPath,
                Class = child.ClassName
            })
        end
        
        -- Coleta Remotes
        if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") or 
           child:IsA("BindableEvent") or child:IsA("BindableFunction") then
            table.insert(remotes, {
                Name = child.Name,
                Path = newPath,
                Type = child.ClassName
            })
        end
        
        -- Procura por scripts suspeitos
        if child:IsA("Script") or child:IsA("LocalScript") or child:IsA("ModuleScript") then
            local success, source = pcall(function()
                return child.Source
            end)
            
            if success and source then
                local sourceLower = source:lower()
                local suspiciousWords = {
                    "kick", "ban", "punish", "detect", "cheat", "hack",
                    "antiexploit", "ac_", "anticheat", "exploit", "inject",
                    "damage", "health", "speed", "jump", "walk", "run", "velocity"
                }
                
                for _, word in ipairs(suspiciousWords) do
                    if string.find(sourceLower, word) then
                        table.insert(antiCheats, {
                            Name = child.Name,
                            Path = newPath,
                            Class = child.ClassName,
                            Reason = "Contém palavra: "..word
                        })
                        break
                    end
                end
            else
                table.insert(errors, "Script inacessível: "..newPath)
            end
        end
        
        -- Continua varredura recursiva
        local subResults, subAntiCheats, subRemotes, subErrors = deepScan(child, depth + 1, newPath)
        
        for _, item in ipairs(subAntiCheats) do
            table.insert(antiCheats, item)
        end
        
        for _, item in ipairs(subRemotes) do
            table.insert(remotes, item)
        end
        
        for _, item in ipairs(subErrors) do
            table.insert(errors, item)
        end
    end
    
    return results, antiCheats, remotes, errors
end

-- LÓGICA DO SCANNER COMPLETO
task.spawn(function()
    wait(2)
    
    logScan("=== INICIANDO VARREDURA COMPLETA DO JOGO ===", Color3.fromRGB(0, 255, 255))
    StatusT.Text = "Preparando análise..."
    
    -- Detecção ESPECIAL de anti-cheats de dano
    logScan("🔍 Procurando por Anti-Cheats de Dano...", Color3.fromRGB(255, 100, 100))
    local damageAntiCheats = detectDamageAntiCheats()
    
    if #damageAntiCheats > 0 then
        logScan("⚠️ ENCONTRADO: "..#damageAntiCheats.." Anti-Cheats de Dano!", Color3.fromRGB(255, 50, 50))
        for _, ac in ipairs(damageAntiCheats) do
            logScan("   ⚡ "..ac.Name.." em "..ac.Path, Color3.fromRGB(255, 100, 100))
            if ac.Pattern then
                logScan("   Padrão detectado: "..ac.Pattern, Color3.fromRGB(255, 150, 150))
            end
        end
        logScan("💡 Sistema de proteção será ativado automaticamente!", Color3.fromRGB(255, 200, 50))
    else
        logScan("✅ Nenhum anti-cheat de dano encontrado!", Color3.fromRGB(100, 255, 100))
    end
    
    -- Lista de todos os serviços importantes para analisar
    local servicesToScan = {
        {Name = "Workspace", Service = game:GetService("Workspace")},
        {Name = "ReplicatedStorage", Service = game:GetService("ReplicatedStorage")},
        {Name = "ServerScriptService", Service = game:GetService("ServerScriptService")},
        {Name = "ServerStorage", Service = game:GetService("ServerStorage")},
        {Name = "StarterGui", Service = game:GetService("StarterGui")},
        {Name = "StarterPack", Service = game:GetService("StarterPack")},
        {Name = "Lighting", Service = game:GetService("Lighting")},
        {Name = "SoundService", Service = game:GetService("SoundService")},
        {Name = "ReplicatedFirst", Service = game:GetService("ReplicatedFirst")},
        {Name = "Players", Service = game:GetService("Players")}
    }
    
    local totalAntiCheats = #damageAntiCheats
    local totalRemotes = 0
    local totalErrors = 0
    
    -- Analisar cada serviço
    for _, serviceInfo in ipairs(servicesToScan) do
        StatusT.Text = "Analisando: "..serviceInfo.Name
        logScan("🔍 Varrendo: "..serviceInfo.Name, Color3.fromRGB(150, 200, 255))
        wait(0.1)
        
        local _, antiCheats, remotes, errors = deepScan(serviceInfo.Service, 0, serviceInfo.Name)
        
        -- Log dos resultados deste serviço
        if #remotes > 0 then
            logScan("📡 "..#remotes.." remotos encontrados em "..serviceInfo.Name, Color3.fromRGB(100, 255, 100))
            for _, remote in ipairs(remotes) do
                logScan("   └ "..remote.Type..": "..remote.Name, Color3.fromRGB(150, 255, 150))
            end
        end
        
        if #antiCheats > 0 then
            logScan("⚠️ "..#antiCheats.." possíveis anti-cheats em "..serviceInfo.Name, Color3.fromRGB(255, 100, 100))
            for _, ac in ipairs(antiCheats) do
                logScan("   └ "..ac.Class..": "..ac.Name.. (ac.Reason and " ("..ac.Reason..")" or ""), Color3.fromRGB(255, 150, 150))
            end
        end
        
        if #errors > 0 then
            logScan("❌ "..#errors.." erros em "..serviceInfo.Name, Color3.fromRGB(255, 100, 255))
            for _, err in ipairs(errors) do
                logScan("   └ "..err, Color3.fromRGB(255, 150, 255))
            end
        end
        
        if #remotes == 0 and #antiCheats == 0 and #errors == 0 then
            logScan("✅ "..serviceInfo.Name.. " limpo", Color3.fromRGB(100, 255, 100))
        end
        
        totalAntiCheats = totalAntiCheats + #antiCheats
        totalRemotes = totalRemotes + #remotes
        totalErrors = totalErrors + #errors
        
        wait(0.2)
    end
    
    -- Analisar LocalPlayer
    StatusT.Text = "Analisando LocalPlayer..."
    logScan("🔍 Varrendo: LocalPlayer", Color3.fromRGB(150, 200, 255))
    
    local playerServices = {
        {Name = "PlayerGui", Object = Player:FindFirstChild("PlayerGui")},
        {Name = "Backpack", Object = Player:FindFirstChild("Backpack")},
        {Name = "Character", Object = Player.Character}
    }
    
    for _, ps in ipairs(playerServices) do
        if ps.Object then
            local _, antiCheats, remotes, errors = deepScan(ps.Object, 0, "Player/"..ps.Name)
            
            if #antiCheats > 0 then
                totalAntiCheats = totalAntiCheats + #antiCheats
                for _, ac in ipairs(antiCheats) do
                    logScan("⚠️ Anti-cheat local: "..ac.Name.. " em "..ps.Name, Color3.fromRGB(255, 100, 100))
                end
            end
        end
    end
    
    -- Resumo final
    logScan("=== RESUMO DA VARREDURA ===", Color3.fromRGB(0, 255, 255))
    logScan("📡 Remotos encontrados: "..totalRemotes, Color3.fromRGB(100, 255, 100))
    logScan("⚠️ Total de anti-cheats: "..totalAntiCheats, totalAntiCheats > 0 and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(100, 255, 100))
    logScan("🎯 Anti-cheats de dano: "..#damageAntiCheats, #damageAntiCheats > 0 and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(100, 255, 100))
    logScan("❌ Erros encontrados: "..totalErrors, totalErrors > 0 and Color3.fromRGB(255, 100, 255) or Color3.fromRGB(100, 255, 100))
    
    -- Dicas de proteção
    if #damageAntiCheats > 0 then
        logScan("=== DICAS DE PROTEÇÃO ===", Color3.fromRGB(255, 200, 50))
        logScan("1. Mantenha a 'Proteção Anti-Dano' ATIVADA", Color3.fromRGB(255, 255, 100))
        logScan("2. Aumente velocidade/pulo gradualmente", Color3.fromRGB(255, 255, 100))
        logScan("3. Evite valores extremos (acima de 200)", Color3.fromRGB(255, 255, 100))
        logScan("4. Se tomar dano, reduza os valores temporariamente", Color3.fromRGB(255, 255, 100))
    end
    
    -- Determinar status final
    if totalAntiCheats > 0 then
        Ball.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        StatusT.Text = "Status: ⚠️ "..totalAntiCheats.." Anti-Cheats Detectados!"
        logScan("⚠️ ALERTA: Foram detectados "..totalAntiCheats.." possíveis anti-cheats!", Color3.fromRGB(255, 50, 50))
        logScan("💡 Sistema de proteção ativado automaticamente!", Color3.fromRGB(255, 200, 50))
    else
        Ball.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        StatusT.Text = "Status: ✅ Servidor Seguro"
        logScan("✅ Nenhum anti-cheat crítico detectado!", Color3.fromRGB(50, 255, 50))
        logScan("🎮 Você pode usar as funções normalmente!", Color3.fromRGB(50, 255, 50))
    end
    
    logScan("=== VARREDURA CONCLUÍDA ===", Color3.fromRGB(0, 255, 255))
end)

-- 6. ABA JOGADORES
addTab("Jogadores", false)
local pPlayers = createPage("Jogadores")

-- Adicionar alerta sobre anti-cheats de dano
local warningLabel = Instance.new("TextLabel", pPlayers)
warningLabel.Size = UDim2.new(0, 280, 0, 40)
warningLabel.BackgroundColor3 = Color3.fromRGB(40, 20, 20)
warningLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
warningLabel.Text = "⚠️ ALERTA: Alguns servidores aplicam dano\nquando velocidade/pulo estão muito altos!"
warningLabel.Font = Enum.Font.GothamMedium
warningLabel.TextSize = 11
warningLabel.TextWrapped = true
warningLabel.ZIndex = 7
Instance.new("UICorner", warningLabel)

local function createSlider(page, text, min, max, default, callback)
    local container = Instance.new("Frame", page)
    container.Size = UDim2.new(0, 280, 0, 50)
    container.BackgroundTransparency = 1
    container.ZIndex = 6
    
    local label = Instance.new("TextLabel", container)
    label.Size = UDim2.new(0, 180, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.ZIndex = 7
    label.TextXAlignment = 0
    label.Font = Enum.Font.GothamMedium
    
    local valLab = Instance.new("TextLabel", container)
    valLab.Size = UDim2.new(0, 50, 0, 20)
    valLab.Position = UDim2.new(1, -50, 0, 0)
    valLab.BackgroundTransparency = 1
    valLab.Text = tostring(default)
    valLab.TextColor3 = Color3.fromRGB(0, 255, 255)
    valLab.ZIndex = 7
    valLab.Font = Enum.Font.GothamBold
    
    local sliderBg = Instance.new("Frame", container)
    sliderBg.Size = UDim2.new(1, 0, 0, 12)
    sliderBg.Position = UDim2.new(0, 0, 0, 25)
    sliderBg.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
    sliderBg.ZIndex = 7
    Instance.new("UICorner", sliderBg)
    
    local sliderFill = Instance.new("Frame", sliderBg)
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
    sliderFill.ZIndex = 8
    Instance.new("UICorner", sliderFill)
    
    local btn = Instance.new("TextButton", sliderBg)
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.ZIndex = 9

    local dragging = false
    btn.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)
    
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    RunService.RenderStepped:Connect(function()
        if dragging then
            local mousePos = UserInputService:GetMouseLocation()
            local sliderAbsPos = sliderBg.AbsolutePosition
            local sliderAbsSize = sliderBg.AbsoluteSize
            local relX = math.clamp((mousePos.X - sliderAbsPos.X) / sliderAbsSize.X, 0, 1)
            local val = math.floor(min + (max - min) * relX)
            sliderFill.Size = UDim2.new(relX, 0, 1, 0)
            valLab.Text = tostring(val)
            callback(val)
        end
    end)
end

createSlider(pPlayers, "Velocidade", 16, 500, 16, function(v)
    currentSpeed = v
    
    -- Ajusta gradualmente para evitar detecção
    if v > 100 then
        warn("[CAI HUB] Velocidade alta detectada! Sistema de proteção ativado.")
    end
end)

createSlider(pPlayers, "Pulo", 50, 500, 50, function(v)
    currentJump = v
    
    -- Ajusta gradualmente para evitar detecção
    if v > 150 then
        warn("[CAI HUB] Pulo alto detectado! Sistema de proteção ativado.")
    end
end)

-- BOTÃO ESP ADICIONADO AQUI
local espEnabled = false
local espObjects = {}

local function createESP(player)
    if not player.Character then return end
    
    local character = player.Character
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso")
    
    if not rootPart then return end
    
    -- Criar caixa de ESP
    local box = Instance.new("BoxHandleAdornment")
    box.Name = "ESP_" .. player.Name
    box.Adornee = rootPart
    box.AlwaysOnTop = true
    box.ZIndex = 0
    box.Size = Vector3.new(4, 5, 1) -- Tamanho ajustável
    box.Transparency = 0.7
    box.Color3 = player.Team and player.TeamColor.Color or Color3.fromRGB(255, 0, 0)
    box.Parent = game:GetService("CoreGui")
    
    -- Criar label com nome
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_Label_" .. player.Name
    billboard.Adornee = rootPart
    billboard.Size = UDim2.new(0, 100, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = player.Name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    label.TextStrokeTransparency = 0.5
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.Parent = billboard
    
    billboard.Parent = game:GetService("CoreGui")
    
    -- Armazenar referências
    espObjects[player] = {Box = box, Billboard = billboard}
end

local function removeESP(player)
    if espObjects[player] then
        if espObjects[player].Box then
            espObjects[player].Box:Destroy()
        end
        if espObjects[player].Billboard then
            espObjects[player].Billboard:Destroy()
        end
        espObjects[player] = nil
    end
end

local function updateESP()
    for player, objects in pairs(espObjects) do
        if player and player.Character and objects.Box then
            local character = player.Character
            local humanoid = character:FindFirstChild("Humanoid")
            local rootPart = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso")
            
            if humanoid and humanoid.Health > 0 and rootPart then
                objects.Box.Adornee = rootPart
                if objects.Billboard then
                    objects.Billboard.Adornee = rootPart
                    
                    -- Atualizar cor baseado no time
                    objects.Box.Color3 = player.Team and player.TeamColor.Color or Color3.fromRGB(255, 0, 0)
                    
                    -- Mostrar saúde se disponível
                    local healthText = player.Name
                    if humanoid then
                        healthText = string.format("%s [%d♥]", player.Name, math.floor(humanoid.Health))
                    end
                    objects.Billboard.TextLabel.Text = healthText
                end
            else
                removeESP(player)
            end
        end
    end
end

local function toggleESP()
    espEnabled = not espEnabled
    
    if espEnabled then
        -- Ativar ESP para todos os jogadores (exceto local)
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= Player then
                createESP(player)
            end
        end
        
        -- Conectar eventos para novos jogadores
        Players.PlayerAdded:Connect(function(player)
            if espEnabled then
                player.CharacterAdded:Connect(function()
                    if espEnabled then
                        wait(0.5)
                        createESP(player)
                    end
                end)
                if player.Character then
                    createESP(player)
                end
            end
        end)
        
        -- Limpar quando jogador sair
        Players.PlayerRemoving:Connect(function(player)
            removeESP(player)
        end)
        
        -- Loop de atualização
        local espLoop
        espLoop = RunService.RenderStepped:Connect(function()
            if not espEnabled then
                espLoop:Disconnect()
                return
            end
            updateESP()
        end)
        
        espBtn.Text = "  ✅ ESP: ATIVADO"
        warn("[CAI HUB] ESP ativado!")
    else
        -- Desativar ESP
        for player, _ in pairs(espObjects) do
            removeESP(player)
        end
        espObjects = {}
        
        espBtn.Text = "  ❌ ESP: DESATIVADO"
        warn("[CAI HUB] ESP desativado!")
    end
end

-- Criar botão ESP (usando a função addBtn existente)
local espBtn = addBtn(pPlayers, "❌ ESP: DESATIVADO", toggleESP)

-- Limpar ESP quando GUI for fechada
ScreenGui.Destroying:Connect(function()
    espEnabled = false
    for player, _ in pairs(espObjects) do
        removeESP(player)
    end
end)

-- 7. TOGGLE E DRAG
local Toggle = Instance.new("Frame", ScreenGui)
Toggle.Size = UDim2.new(0, 50, 0, 50)
Toggle.Position = UDim2.new(0.05, 0, 0.2, 0)
Toggle.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
Toggle.ZIndex = 100
Instance.new("UICorner", Toggle).CornerRadius = UDim.new(1, 0)

local tS = Instance.new("UIStroke", Toggle)
tS.Color = Color3.fromRGB(0, 255, 255)
tS.Thickness = 1.5

local TBtn = Instance.new("TextButton", Toggle)
TBtn.Size = UDim2.new(1, 0, 1, 0)
TBtn.BackgroundTransparency = 1
TBtn.Text = "C"
TBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
TBtn.Font = Enum.Font.GothamBold
TBtn.TextSize = 22
TBtn.ZIndex = 101

local function makeDraggable(obj, handle)
    local dragging, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = obj.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            obj.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

makeDraggable(MainFrame, DragBar)
makeDraggable(Toggle, TBtn)

TBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    if MainFrame.Visible then
        Pages[lastOpenPage].Visible = true
    end
end)

-- SISTEMA DE MOVIMENTO SEGURO (evita detecção)
local lastSpeedAdjustment = tick()
local safeSpeed = 16
local safeJump = 50

RunService.RenderStepped:Connect(function()
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        local hum = Player.Character.Humanoid
        
        -- Ajusta gradualmente para evitar picos de detecção
        local now = tick()
        if now - lastSpeedAdjustment > 0.1 then
            lastSpeedAdjustment = now
            
            -- Aumenta/diminui gradualmente
            if math.abs(safeSpeed - currentSpeed) > 5 then
                safeSpeed = safeSpeed + (currentSpeed > safeSpeed and 5 or -5)
            else
                safeSpeed = currentSpeed
            end
            
            if math.abs(safeJump - currentJump) > 10 then
                safeJump = safeJump + (currentJump > safeJump and 10 or -10)
            else
                safeJump = currentJump
            end
            
            hum.WalkSpeed = safeSpeed
            hum.JumpPower = safeJump
            hum.UseJumpPower = true
            
            -- Monitora para detectar danos
            if hum.Health < lastHealth and antiDamageEnabled then
                warn("[CAI HUB] Dano detectado! Reduzindo velocidade temporariamente...")
                currentSpeed = math.max(16, currentSpeed * 0.7)
                currentJump = math.max(50, currentJump * 0.7)
            end
            
            lastHealth = hum.Health
        end
    end
end)

-- Inicializa proteção
Player.CharacterAdded:Connect(function(char)
    ApplyBypass(char)
    SetupAntiDamageProtection(char)
    lastHealth = char:WaitForChild("Humanoid").Health
end)

if Player.Character then
    ApplyBypass(Player.Character)
    SetupAntiDamageProtection(Player.Character)
    lastHealth = Player.Character:WaitForChild("Humanoid").Health
end

Pages["Configurar"].Visible = true

-- Mensagem inicial
warn("[CAI HUB] Carregado com sucesso!")
warn("[CAI HUB] Sistema de proteção contra dano: ATIVADO")
warn("[CAI HUB] Use valores moderados para evitar detecção!")

print("[CAI HUB] GUI criada com sucesso!")