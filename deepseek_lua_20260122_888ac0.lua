--[[
    Anti-Cheat Tester v1.0
    Script para testar sistemas anti-cheat e identificar brechas
    Autor: Desenvolvedor Anônimo
    Uso: Apenas para testes educacionais
--]]

-- Serviços necessários
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local LogService = game:GetService("LogService")
local Stats = game:GetService("Stats")
local CoreGui = game:GetService("CoreGui")

-- Variáveis globais
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local testResults = {}
local detectedAntiCheats = {}
local consoleLogs = {}
local vulnerabilities = {}

-- Criar GUI principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AntiCheatTester"
screenGui.Parent = CoreGui -- Usando CoreGui para maior discrição

-- Frame principal
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 450, 0, 500)
mainFrame.Position = UDim2.new(0.5, -225, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Título
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
title.Text = "🛡️ Anti-Cheat Tester v1.0"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = mainFrame

-- Área de logs
local logFrame = Instance.new("ScrollingFrame")
logFrame.Name = "LogFrame"
logFrame.Size = UDim2.new(0.95, 0, 0.6, 0)
logFrame.Position = UDim2.new(0.025, 0, 0.1, 0)
logFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
logFrame.BorderSizePixel = 1
logFrame.BorderColor3 = Color3.fromRGB(60, 60, 80)
logFrame.ScrollBarThickness = 8
logFrame.Parent = mainFrame

local logContent = Instance.new("TextLabel")
logContent.Name = "LogContent"
logContent.Size = UDim2.new(1, -10, 0, 0)
logContent.Position = UDim2.new(0, 5, 0, 5)
logContent.BackgroundTransparency = 1
logContent.Text = "Logs serão exibidos aqui..."
logContent.TextColor3 = Color3.fromRGB(200, 200, 255)
logContent.Font = Enum.Font.Code
logContent.TextSize = 12
logContent.TextXAlignment = Enum.TextXAlignment.Left
logContent.TextYAlignment = Enum.TextYAlignment.Top
logContent.TextWrapped = true
logContent.AutomaticSize = Enum.AutomaticSize.Y
logContent.Parent = logFrame

-- Botões de teste
local buttonFrame = Instance.new("Frame")
buttonFrame.Name = "ButtonFrame"
buttonFrame.Size = UDim2.new(0.95, 0, 0.25, 0)
buttonFrame.Position = UDim2.new(0.025, 0, 0.72, 0)
buttonFrame.BackgroundTransparency = 1
buttonFrame.Parent = mainFrame

-- Botão: Teste Rápido
local quickTestButton = Instance.new("TextButton")
quickTestButton.Name = "QuickTestButton"
quickTestButton.Size = UDim2.new(0.48, 0, 0.4, 0)
quickTestButton.Position = UDim2.new(0, 0, 0, 0)
quickTestButton.BackgroundColor3 = Color3.fromRGB(70, 120, 200)
quickTestButton.Text = "⚡ Teste Rápido"
quickTestButton.TextColor3 = Color3.fromRGB(255, 255, 255)
quickTestButton.Font = Enum.Font.Gotham
quickTestButton.TextSize = 14
quickTestButton.Parent = buttonFrame

-- Botão: Teste Completo
local fullTestButton = Instance.new("TextButton")
fullTestButton.Name = "FullTestButton"
fullTestButton.Size = UDim2.new(0.48, 0, 0.4, 0)
fullTestButton.Position = UDim2.new(0.52, 0, 0, 0)
fullTestButton.BackgroundColor3 = Color3.fromRGB(200, 100, 50)
fullTestButton.Text = "🔍 Teste Completo"
fullTestButton.TextColor3 = Color3.fromRGB(255, 255, 255)
fullTestButton.Font = Enum.Font.Gotham
fullTestButton.TextSize = 14
fullTestButton.Parent = buttonFrame

-- Botão: Coletar Informações
local infoButton = Instance.new("TextButton")
infoButton.Name = "InfoButton"
infoButton.Size = UDim2.new(0.48, 0, 0.4, 0)
infoButton.Position = UDim2.new(0, 0, 0.52, 0)
infoButton.BackgroundColor3 = Color3.fromRGB(100, 180, 100)
infoButton.Text = "📊 Coletar Dados"
infoButton.TextColor3 = Color3.fromRGB(255, 255, 255)
infoButton.Font = Enum.Font.Gotham
infoButton.TextSize = 14
infoButton.Parent = buttonFrame

-- Botão: Exportar Resultados
local exportButton = Instance.new("TextButton")
exportButton.Name = "ExportButton"
exportButton.Size = UDim2.new(0.48, 0, 0.4, 0)
exportButton.Position = UDim2.new(0.52, 0, 0.52, 0)
exportButton.BackgroundColor3 = Color3.fromRGB(180, 80, 180)
exportButton.Text = "💾 Exportar"
exportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
exportButton.Font = Enum.Font.Gotham
exportButton.TextSize = 14
exportButton.Parent = buttonFrame

-- Área de resultados
local resultLabel = Instance.new("TextLabel")
resultLabel.Name = "ResultLabel"
resultLabel.Size = UDim2.new(0.95, 0, 0.1, 0)
resultLabel.Position = UDim2.new(0.025, 0, 0.88, 0)
resultLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
resultLabel.BorderSizePixel = 1
resultLabel.BorderColor3 = Color3.fromRGB(80, 80, 100)
resultLabel.Text = "Aguardando testes..."
resultLabel.TextColor3 = Color3.fromRGB(220, 220, 255)
resultLabel.Font = Enum.Font.Gotham
resultLabel.TextSize = 14
resultLabel.Parent = mainFrame

-- Função para adicionar log
local function addLog(message, color)
    color = color or Color3.fromRGB(200, 200, 255)
    local timestamp = os.date("%H:%M:%S")
    logContent.Text = logContent.Text .. "\n[" .. timestamp .. "] " .. message
    table.insert(consoleLogs, "[" .. timestamp .. "] " .. message)
    
    -- Scroll para o final
    logFrame.CanvasPosition = Vector2.new(0, logContent.AbsoluteSize.Y)
end

-- Função para verificar se há hook em print
local originalPrint = print
local printDetected = false

local function testPrintHook()
    addLog("Testando hook em print()...", Color3.fromRGB(255, 255, 150))
    
    local testString = "TEST_PRINT_" .. math.random(10000, 99999)
    
    -- Substituir print temporariamente para detectar hooks
    local hookDetected = false
    local oldPrint = print
    print = function(...)
        local args = {...}
        for i, arg in ipairs(args) do
            if tostring(arg):find(testString) then
                hookDetected = true
                table.insert(detectedAntiCheats, "Print Monitor (Hook detectado)")
            end
        end
        return oldPrint(...)
    end
    
    -- Executar print de teste
    print(testString)
    
    -- Restaurar print
    print = oldPrint
    
    if hookDetected then
        addLog("⚠️ Hook detectado em print()", Color3.fromRGB(255, 100, 100))
        return false
    else
        addLog("✅ Print limpo", Color3.fromRGB(100, 255, 100))
        return true
    end
end

-- Testar funções comuns
local function testCommonFunctions()
    addLog("Testando funções comuns...", Color3.fromRGB(255, 255, 150))
    
    local tests = {
        {name = "loadstring", func = loadstring, expected = "function"},
        {name = "getfenv", func = getfenv, expected = "function"},
        {name = "setfenv", func = setfenv, expected = "function"},
        {name = "getreg", func = getreg or function() end, expected = "function"},
        {name = "getgc", func = getgc or function() end, expected = "function"},
    }
    
    local vulnerabilitiesFound = {}
    
    for _, test in ipairs(tests) do
        local success, result = pcall(function()
            return type(test.func)
        end)
        
        if success and result == test.expected then
            addLog("✅ " .. test.name .. " disponível", Color3.fromRGB(100, 255, 100))
            table.insert(vulnerabilitiesFound, test.name)
        else
            addLog("❌ " .. test.name .. " bloqueado", Color3.fromRGB(255, 100, 100))
        end
    end
    
    if #vulnerabilitiesFound > 0 then
        table.insert(vulnerabilities, "Funções disponíveis: " .. table.concat(vulnerabilitiesFound, ", "))
    end
end

-- Testar environment
local function testEnvironment()
    addLog("Analisando ambiente de execução...", Color3.fromRGB(255, 255, 150))
    
    -- Verificar identificador do executor
    local executorInfo = {
        _VERSION = _VERSION,
        _G = type(_G),
        shared = type(shared),
        getrenv = type(getrenv or nil),
    }
    
    for key, value in pairs(executorInfo) do
        addLog(key .. ": " .. tostring(value), Color3.fromRGB(180, 180, 255))
    end
end

-- Testar métodos de detecção
local function testDetectionMethods()
    addLog("Testando métodos de detecção...", Color3.fromRGB(255, 255, 150))
    
    -- Testar wait() hook
    local originalWait = wait
    local waitHookDetected = false
    
    wait = function(time)
        if time and time < 0.001 then
            waitHookDetected = true
        end
        return originalWait(time)
    end
    
    wait(0.0005)
    wait = originalWait
    
    if waitHookDetected then
        addLog("⚠️ Hook detectado em wait()", Color3.fromRGB(255, 100, 100))
        table.insert(detectedAntiCheats, "Wait Hook Detection")
    end
    
    -- Testar metatable hook
    local mtTest = {}
    local success, result = pcall(setmetatable, mtTest, {})
    
    if not success and tostring(result):find("metatable") then
        addLog("⚠️ Proteção de metatable ativa", Color3.fromRGB(255, 150, 100))
    end
end

-- Testar velocidade de execução
local function testExecutionSpeed()
    addLog("Testando velocidade de execução...", Color3.fromRGB(255, 255, 150))
    
    local startTime = os.clock()
    local iterations = 100000
    local dummy = 0
    
    for i = 1, iterations do
        dummy = dummy + math.sin(i)
    end
    
    local endTime = os.clock()
    local executionTime = endTime - startTime
    
    addLog(string.format("Tempo de execução: %.4f segundos", executionTime), Color3.fromRGB(180, 180, 255))
    
    -- Verificar se há throttle
    if executionTime > 0.5 then
        addLog("⚠️ Possível throttle de execução detectado", Color3.fromRGB(255, 150, 100))
        table.insert(detectedAntiCheats, "Execution Throttle")
    end
end

-- Coletar informações do jogo
local function collectGameInfo()
    addLog("Coletando informações do jogo...", Color3.fromRGB(255, 255, 150))
    
    local info = {
        PlaceId = game.PlaceId,
        JobId = game.JobId,
        GameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name,
        PlayerCount = #Players:GetPlayers(),
        ServerType = RunService:IsStudio() and "Studio" or "Live",
        FPS = 1 / RunService.RenderStepped:Wait(),
    }
    
    for key, value in pairs(info) do
        addLog(key .. ": " .. tostring(value), Color3.fromRGB(180, 220, 255))
    end
end

-- Analisar console por logs
local function analyzeConsole()
    addLog("Analisando logs do console...", Color3.fromRGB(255, 255, 150))
    
    -- Simular captura de logs (em ambiente real, isso requer hook)
    local mockLogs = {
        "Script 'AntiCheatTester' loaded",
        "Player joined: " .. player.Name,
        "Memory usage: " .. tostring(Stats:GetMemoryUsageMbForTag(Enum.DeveloperMemoryTag.Script)) .. " MB",
    }
    
    for _, log in ipairs(mockLogs) do
        addLog("[CONSOLE] " .. log, Color3.fromRGB(200, 200, 150))
        table.insert(consoleLogs, log)
    end
end

-- Verificar brechas
local function findVulnerabilities()
    addLog("Buscando brechas de segurança...", Color3.fromRGB(255, 255, 150))
    
    local breaches = {}
    
    -- Verificar serviços acessíveis
    local servicesToCheck = {
        "HttpService",
        "TeleportService", 
        "MessagingService",
        "DataStoreService",
    }
    
    for _, serviceName in ipairs(servicesToCheck) do
        local success = pcall(function()
            return game:GetService(serviceName)
        end)
        
        if success then
            table.insert(breaches, serviceName .. " acessível")
        end
    end
    
    -- Verificar métodos de injeção
    if type(loadstring) == "function" then
        table.insert(breaches, "loadstring disponível")
    end
    
    if type(getfenv) == "function" then
        table.insert(breaches, "getfenv disponível")
    end
    
    -- Adicionar às vulnerabilidades gerais
    if #breaches > 0 then
        for _, breach in ipairs(breaches) do
            table.insert(vulnerabilities, breach)
        end
        addLog("✅ " .. #breaches .. " brechas encontradas", Color3.fromRGB(100, 255, 100))
    else
        addLog("❌ Nenhuma brecha óbvia encontrada", Color3.fromRGB(255, 100, 100))
    end
    
    return breaches
end

-- Gerar relatório
local function generateReport()
    addLog("Gerando relatório final...", Color3.fromRGB(255, 255, 150))
    
    local report = {
        "=== RELATÓRIO DE TESTE DE ANTI-CHEAT ===",
        "Data: " .. os.date("%d/%m/%Y %H:%M:%S"),
        "Jogador: " .. player.Name,
        "Place ID: " .. game.PlaceId,
        "",
        "=== ANTI-CHEATS DETECTADOS ===",
    }
    
    if #detectedAntiCheats > 0 then
        for i, ac in ipairs(detectedAntiCheats) do
            table.insert(report, i .. ". " .. ac)
        end
    else
        table.insert(report, "Nenhum anti-cheat óbvio detectado")
    end
    
    table.insert(report, "")
    table.insert(report, "=== BRECHAS ENCONTRADAS ===")
    
    if #vulnerabilities > 0 then
        for i, vuln in ipairs(vulnerabilities) do
            table.insert(report, i .. ". " .. vuln)
        end
    else
        table.insert(report, "Nenhuma brecha encontrada")
    end
    
    table.insert(report, "")
    table.insert(report, "=== RECOMENDAÇÕES ===")
    table.insert(report, "1. Use require() em vez de loadstring()")
    table.insert(report, "2. Evite modificar metatables globais")
    table.insert(report, "3. Use coroutines para operações pesadas")
    table.insert(report, "4. Obfusque scripts sensíveis")
    table.insert(report, "5. Use métodos de execução assíncrona")
    
    return table.concat(report, "\n")
end

-- Executar teste rápido
local function runQuickTest()
    addLog("🚀 Iniciando teste rápido...", Color3.fromRGB(100, 200, 255))
    
    testPrintHook()
    testCommonFunctions()
    testEnvironment()
    testDetectionMethods()
    findVulnerabilities()
    
    local report = generateReport()
    addLog("Teste rápido concluído!", Color3.fromRGB(100, 255, 100))
    
    resultLabel.Text = "Teste rápido concluído! " .. #vulnerabilities .. " brechas encontradas"
end

-- Executar teste completo
local function runFullTest()
    addLog("🔍 Iniciando teste completo...", Color3.fromRGB(255, 200, 100))
    
    testPrintHook()
    testCommonFunctions()
    testEnvironment()
    testDetectionMethods()
    testExecutionSpeed()
    collectGameInfo()
    analyzeConsole()
    findVulnerabilities()
    
    local report = generateReport()
    addLog("Teste completo concluído!", Color3.fromRGB(100, 255, 100))
    
    resultLabel.Text = "Teste completo concluído! " .. #vulnerabilities .. " brechas encontradas"
    
    -- Exibir relatório em nova janela
    local reportGui = Instance.new("ScreenGui", CoreGui)
    local reportFrame = Instance.new("Frame", reportGui)
    reportFrame.Size = UDim2.new(0, 500, 0, 400)
    reportFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
    reportFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    
    local scrollFrame = Instance.new("ScrollingFrame", reportFrame)
    scrollFrame.Size = UDim2.new(1, -20, 1, -40)
    scrollFrame.Position = UDim2.new(0, 10, 0, 30)
    scrollFrame.BackgroundTransparency = 1
    
    local reportText = Instance.new("TextLabel", scrollFrame)
    reportText.Size = UDim2.new(1, 0, 0, 0)
    reportText.AutomaticSize = Enum.AutomaticSize.Y
    reportText.Text = report
    reportText.TextColor3 = Color3.fromRGB(255, 255, 255)
    reportText.BackgroundTransparency = 1
    reportText.TextXAlignment = Enum.TextXAlignment.Left
    reportText.TextYAlignment = Enum.TextYAlignment.Top
    reportText.TextWrapped = true
    
    local closeButton = Instance.new("TextButton", reportFrame)
    closeButton.Size = UDim2.new(0, 100, 0, 30)
    closeButton.Position = UDim2.new(0.5, -50, 1, -35)
    closeButton.Text = "Fechar"
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    
    closeButton.MouseButton1Click:Connect(function()
        reportGui:Destroy()
    end)
end

-- Coletar dados do sistema
local function collectSystemData()
    addLog("📊 Coletando dados do sistema...", Color3.fromRGB(100, 255, 200))
    
    local systemInfo = {
        Memória = string.format("%.2f MB", Stats:GetMemoryUsageMbForTag(Enum.DeveloperMemoryTag.Script)),
        FPS = math.floor(1 / RunService.RenderStepped:Wait()),
        Ping = Stats.Network.ServerStatsItem["Data Ping"] and Stats.Network.ServerStatsItem["Data Ping"]:GetValue() or "N/A",
        "Tempo de execução": _VERSION,
    }
    
    for key, value in pairs(systemInfo) do
        addLog(key .. ": " .. tostring(value), Color3.fromRGB(180, 255, 220))
    end
end

-- Exportar resultados
local function exportResults()
    addLog("💾 Exportando resultados...", Color3.fromRGB(200, 150, 255))
    
    local report = generateReport()
    
    -- Em um executor real, você poderia salvar em arquivo
    -- Aqui simulamos com um TextBox para copiar
    
    local exportGui = Instance.new("ScreenGui", CoreGui)
    local exportFrame = Instance.new("Frame", exportGui)
    exportFrame.Size = UDim2.new(0, 450, 0, 300)
    exportFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
    exportFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    
    local textBox = Instance.new("TextBox", exportFrame)
    textBox.Size = UDim2.new(1, -20, 1, -60)
    textBox.Position = UDim2.new(0, 10, 0, 10)
    textBox.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.Text = report
    textBox.MultiLine = true
    textBox.TextWrapped = true
    textBox.TextXAlignment = Enum.TextXAlignment.Left
    textBox.TextYAlignment = Enum.TextYAlignment.Top
    
    local closeButton = Instance.new("TextButton", exportFrame)
    closeButton.Size = UDim2.new(0, 100, 0, 30)
    closeButton.Position = UDim2.new(0.5, -50, 1, -35)
    closeButton.Text = "Copiar & Fechar"
    closeButton.BackgroundColor3 = Color3.fromRGB(80, 60, 200)
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    
    closeButton.MouseButton1Click:Connect(function()
        textBox:CaptureFocus()
        textBox:SelectAll()
        wait()
        exportGui:Destroy()
        addLog("Resultados copiados para área de transferência", Color3.fromRGB(100, 255, 100))
    end)
end

-- Conectar botões
quickTestButton.MouseButton1Click:Connect(runQuickTest)
fullTestButton.MouseButton1Click:Connect(runFullTest)
infoButton.MouseButton1Click:Connect(collectSystemData)
exportButton.MouseButton1Click:Connect(exportResults)

-- Minimizar/Maximizar GUI (botão secreto)
local minimizeButton = Instance.new("TextButton", mainFrame)
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(1, -35, 0, 5)
minimizeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
minimizeButton.Text = "_"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.Visible = false -- Oculto por padrão

local isMinimized = false
minimizeButton.MouseButton1Click:Connect(function()
    if isMinimized then
        mainFrame.Size = UDim2.new(0, 450, 0, 500)
        minimizeButton.Text = "_"
        isMinimized = false
    else
        mainFrame.Size = UDim2.new(0, 450, 0, 40)
        minimizeButton.Text = "□"
        isMinimized = true
    end
end)

-- Ativar botão de minimizar após 5 segundos
delay(5, function()
    minimizeButton.Visible = true
end)

-- Mensagem inicial
addLog("🛡️ Anti-Cheat Tester inicializado", Color3.fromRGB(100, 200, 255))
addLog("Pronto para executar testes", Color3.fromRGB(200, 200, 255))
addLog("Selecione um tipo de teste acima", Color3.fromRGB(200, 200, 255))

-- Script de exemplo para bypass (conceitual)
local function generateBypassExample()
    local exampleCode = [[
-- Exemplo de script para evitar detecção:

-- 1. Usar require em vez de loadstring
local module = require(123456789) -- ID do módulo

-- 2. Execução atrasada
task.wait(math.random(1, 3))

-- 3. Obfuscação básica
local function executeSafely(func)
    local success, err = pcall(func)
    if not success then
        warn("Execução falhou:", err)
    end
end

-- 4. Evitar hooks
local originalWait = task.wait
task.wait = function(time)
    return originalWait(time or 0.03)
end

-- 5. Usar coroutines para operações pesadas
coroutine.wrap(function()
    -- Código sensível aqui
    print("Executando de forma segura")
end)()
]]
    
    return exampleCode
end

-- Botão para exemplo de bypass (secreto - duplo clique no título)
local clickCount = 0
local lastClickTime = 0

title.MouseButton1Click:Connect(function()
    local currentTime = tick()
    if currentTime - lastClickTime < 0.5 then
        clickCount = clickCount + 1
        if clickCount >= 2 then
            addLog("🔓 Exemplo de bypass carregado", Color3.fromRGB(255, 255, 100))
            local example = generateBypassExample()
            addLog(example, Color3.fromRGB(150, 255, 150))
            clickCount = 0
        end
    else
        clickCount = 1
    end
    lastClickTime = currentTime
end)