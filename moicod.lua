-- language: Lua, target: Roblox (ANON Ultimate WH - Part 1)
-- script: Core, Theme, Window Creation

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

if CoreGui:FindFirstChild("ANON_Ultimate_UI") then CoreGui.ANON_Ultimate_UI:Destroy() end
if LocalPlayer:FindFirstChild("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("ANON_Ultimate_UI") then LocalPlayer.PlayerGui.ANON_Ultimate_UI:Destroy() end

local Theme = {
    Main = Color3.fromRGB(14, 14, 18),
    Sidebar = Color3.fromRGB(20, 20, 26),
    Card = Color3.fromRGB(28, 28, 36),
    CardHover = Color3.fromRGB(35, 35, 45),
    Accent = Color3.fromRGB(140, 100, 255),
    AccentDark = Color3.fromRGB(100, 60, 200),
    Text = Color3.fromRGB(240, 240, 240),
    SubText = Color3.fromRGB(150, 150, 160),
    Stroke = Color3.fromRGB(45, 45, 55),
    Green = Color3.fromRGB(80, 250, 123),
    Red = Color3.fromRGB(255, 85, 85)
}

local Tween = function(obj, props, time, style)
    local info = TweenInfo.new(time or 0.25, style or Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local tw = TweenService:Create(obj, info, props)
    tw:Play()
    return tw
end

-- Глобальная таблица настроек
local Settings = {
    esp_enabled = false,
    team_check = true,
    box_enabled = false,
    box_color = Color3.fromRGB(255, 255, 255),
    fill_enabled = false,
    fill_color = Color3.fromRGB(140, 100, 255),
    fill_transparency = 0.5,
    name_enabled = true,
    name_color = Color3.fromRGB(255, 255, 255),
    distance_enabled = true,
    health_enabled = true,
    tracer_enabled = false,
    tracer_color = Color3.fromRGB(140, 100, 255),
    fov = 70
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ANON_Ultimate_UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- Кнопка
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Parent = ScreenGui
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0, 20, 0.5, -25)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Text = "A"
ToggleBtn.TextColor3 = Theme.Text
ToggleBtn.Font = Enum.Font.GothamBlack
ToggleBtn.TextSize = 22
ToggleBtn.BorderSizePixel = 0
ToggleBtn.AutoButtonColor = false
ToggleBtn.ClipsDescendants = true

Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
local btnGradient = Instance.new("UIGradient", ToggleBtn)
btnGradient.Color = ColorSequence.new(Theme.Accent, Theme.AccentDark)
btnGradient.Rotation = 45
local btnStroke = Instance.new("UIStroke", ToggleBtn)
btnStroke.Color = Theme.Stroke
btnStroke.Thickness = 2

-- Окно
local MainWindow = Instance.new("Frame")
MainWindow.Parent = ScreenGui
MainWindow.Size = UDim2.new(0, 550, 0, 380)
MainWindow.Position = UDim2.new(0.5, -275, 0.5, -190)
MainWindow.BackgroundColor3 = Theme.Main
MainWindow.BorderSizePixel = 0
MainWindow.Visible = false
MainWindow.ClipsDescendants = true

Instance.new("UICorner", MainWindow).CornerRadius = UDim.new(0, 14)
local winStroke = Instance.new("UIStroke", MainWindow)
winStroke.Color = Theme.Stroke
winStroke.Thickness = 1.5

local TopBar = Instance.new("Frame", MainWindow)
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundTransparency = 1
TopBar.Active = true
TopBar.Draggable = true

local Sidebar = Instance.new("Frame", MainWindow)
Sidebar.Size = UDim2.new(0, 160, 1, 0)
Sidebar.BackgroundColor3 = Theme.Sidebar
Sidebar.BorderSizePixel = 0
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 14)

local Logo = Instance.new("TextLabel", Sidebar)
Logo.Size = UDim2.new(1, -20, 0, 50)
Logo.Position = UDim2.new(0, 20, 0, 15)
Logo.BackgroundTransparency = 1
Logo.Text = "ANON"
Logo.TextColor3 = Theme.Text
Logo.Font = Enum.Font.GothamBlack
Logo.TextSize = 22
Logo.TextXAlignment = Enum.TextXAlignment.Left

local TabContainer = Instance.new("Frame", Sidebar)
TabContainer.Size = UDim2.new(1, -20, 1, -100)
TabContainer.Position = UDim2.new(0, 10, 0, 70)
TabContainer.BackgroundTransparency = 1
local TabLayout = Instance.new("UIListLayout", TabContainer)
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Padding = UDim.new(0, 5)

local ContentArea = Instance.new("Frame", MainWindow)
ContentArea.Size = UDim2.new(1, -160, 1, 0)
ContentArea.Position = UDim2.new(0, 160, 0, 0)
ContentArea.BackgroundTransparency = 1

local CloseBtn = Instance.new("TextButton", Sidebar)
CloseBtn.Size = UDim2.new(1, -20, 0, 35)
CloseBtn.Position = UDim2.new(0, 10, 1, -45)
CloseBtn.BackgroundColor3 = Color3.fromRGB(40, 20, 20)
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "Unload UI"
CloseBtn.TextColor3 = Theme.Red
CloseBtn.Font = Enum.Font.GothamMedium
CloseBtn.TextSize = 13
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 8)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Логика перетаскивания кнопки
local dragging, dragStart, startPos, hasMoved = false, nil, nil, false
ToggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        hasMoved = false
        dragStart = input.Position
        startPos = ToggleBtn.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
ToggleBtn.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        if math.abs(delta.X) > 5 or math.abs(delta.Y) > 5 then hasMoved = true end
        if hasMoved then ToggleBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end
    end
end)
ToggleBtn.MouseButton1Click:Connect(function()
    if not hasMoved then
        MainWindow.Visible = not MainWindow.Visible
        if MainWindow.Visible then
            MainWindow.Size = UDim2.new(0, 200, 0, 100)
            Tween(MainWindow, {Size = UDim2.new(0, 550, 0, 380)}, 0.3)
        end
    end
end)

-- Создание вкладок
local ActiveTab = nil
local Tabs = {}
local function CreateTab(name)
    local btn = Instance.new("TextButton", TabContainer)
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.BackgroundColor3 = Theme.Sidebar
    btn.BorderSizePixel = 0
    btn.Text = "  " .. name
    btn.TextColor3 = Theme.SubText
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 13
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    local indicator = Instance.new("Frame", btn)
    indicator.Size = UDim2.new(0, 3, 0.6, 0)
    indicator.Position = UDim2.new(0, 0, 0.2, 0)
    indicator.BackgroundColor3 = Theme.Accent
    indicator.BorderSizePixel = 0
    indicator.Visible = false
    Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)

    local page = Instance.new("ScrollingFrame", ContentArea)
    page.Size = UDim2.new(1, -20, 1, -20)
    page.Position = UDim2.new(0, 10, 0, 10)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = Theme.Accent
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Visible = false
    
    local layout = Instance.new("UIListLayout", page)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)
    
    local padding = Instance.new("UIPadding", page)
    padding.PaddingTop = UDim.new(0, 5)
    padding.PaddingLeft = UDim.new(0, 5)

    Tabs[name] = {Button = btn, Page = page, Indicator = indicator}
    
    btn.MouseButton1Click:Connect(function()
        if ActiveTab == name then return end
        for tName, tData in pairs(Tabs) do
            tData.Page.Visible = false
            tData.Indicator.Visible = false
            Tween(tData.Button, {BackgroundColor3 = Theme.Sidebar, TextColor3 = Theme.SubText}, 0.2)
        end
        ActiveTab = name
        page.Visible = true
        indicator.Visible = true
        Tween(btn, {BackgroundColor3 = Theme.Card, TextColor3 = Theme.Text}, 0.2)
    end)
    return page
end
-- language: Lua, target: Roblox (ANON Ultimate WH - Part 2)
-- script: UI Elements Library

-- 1. Карточка (базовая обертка)
local function CreateCard(parent, height)
    local card = Instance.new("Frame")
    card.Parent = parent
    card.Size = UDim2.new(1, -10, 0, height or 42)
    card.BackgroundColor3 = Theme.Card
    card.BorderSizePixel = 0
    card.ZIndex = 1
    card.ClipsDescendants = false
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = card
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Theme.Stroke
    stroke.Thickness = 1
    stroke.Parent = card
    
    -- Эффект при наведении (для ПК и мобилок)
    card.MouseEnter:Connect(function()
        Tween(card, {BackgroundColor3 = Theme.CardHover}, 0.15)
        Tween(stroke, {Color = Theme.Accent}, 0.15)
    end)
    card.MouseLeave:Connect(function()
        Tween(card, {BackgroundColor3 = Theme.Card}, 0.15)
        Tween(stroke, {Color = Theme.Stroke}, 0.15)
    end)
    
    return card, stroke
end

-- 2. Заголовок секции
local function CreateSection(parent, text)
    local lbl = Instance.new("TextLabel")
    lbl.Parent = parent
    lbl.Size = UDim2.new(1, -10, 0, 24)
    lbl.BackgroundTransparency = 1
    lbl.Text = string.upper(text)
    lbl.TextColor3 = Theme.SubText
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 2
    
    local padding = Instance.new("UIPadding")
    padding.Parent = lbl
    padding.PaddingLeft = UDim.new(0, 4)
    padding.PaddingTop = UDim.new(0, 4)
    
    return lbl
end

-- 3. Toggle (Переключатель)
local function CreateToggle(parent, text, state, callback)
    local card = CreateCard(parent, 38)
    
    local title = Instance.new("TextLabel")
    title.Parent = card
    title.Size = UDim2.new(1, -60, 1, 0)
    title.Position = UDim2.new(0, 12, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = text
    title.TextColor3 = Theme.Text
    title.Font = Enum.Font.GothamMedium
    title.TextSize = 13
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 2
    
    local toggleBg = Instance.new("Frame")
    toggleBg.Parent = card
    toggleBg.AnchorPoint = Vector2.new(1, 0.5)
    toggleBg.Position = UDim2.new(1, -12, 0.5, 0)
    toggleBg.Size = UDim2.new(0, 36, 0, 20)
    toggleBg.BackgroundColor3 = state and Theme.Accent or Theme.Main
    toggleBg.BorderSizePixel = 0
    toggleBg.ZIndex = 2
    Instance.new("UICorner", toggleBg).CornerRadius = UDim.new(1, 0)
    local bgStroke = Instance.new("UIStroke", toggleBg)
    bgStroke.Color = Theme.Stroke
    bgStroke.Parent = toggleBg
    
    local knob = Instance.new("Frame")
    knob.Parent = toggleBg
    knob.AnchorPoint = Vector2.new(0, 0.5)
    knob.Position = state and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.BackgroundColor3 = Theme.Text
    knob.BorderSizePixel = 0
    knob.ZIndex = 3
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
    
    local btn = Instance.new("TextButton")
    btn.Parent = card
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.ZIndex = 4
    
    btn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            Tween(toggleBg, {BackgroundColor3 = Theme.Accent}, 0.2)
            Tween(knob, {Position = UDim2.new(1, -18, 0.5, 0)}, 0.2)
        else
            Tween(toggleBg, {BackgroundColor3 = Theme.Main}, 0.2)
            Tween(knob, {Position = UDim2.new(0, 2, 0.5, 0)}, 0.2)
        end
        if callback then callback(state) end
    end)
    
    return card
end

-- 4. Slider (Ползунок)
local function CreateSlider(parent, text, min, max, initial, callback)
    local card = CreateCard(parent, 52)
    
    local title = Instance.new("TextLabel")
    title.Parent = card
    title.Size = UDim2.new(1, -60, 0, 20)
    title.Position = UDim2.new(0, 12, 0, 5)
    title.BackgroundTransparency = 1
    title.Text = text
    title.TextColor3 = Theme.Text
    title.Font = Enum.Font.GothamMedium
    title.TextSize = 12
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 2
    
    local valueLbl = Instance.new("TextLabel")
    valueLbl.Parent = card
    valueLbl.Size = UDim2.new(0, 50, 0, 20)
    valueLbl.Position = UDim2.new(1, -60, 0, 5)
    valueLbl.BackgroundTransparency = 1
    valueLbl.Text = tostring(initial)
    valueLbl.TextColor3 = Theme.Accent
    valueLbl.Font = Enum.Font.GothamBold
    valueLbl.TextSize = 12
    valueLbl.TextXAlignment = Enum.TextXAlignment.Right
    valueLbl.ZIndex = 2
    
    local track = Instance.new("Frame")
    track.Parent = card
    track.Size = UDim2.new(1, -24, 0, 4)
    track.Position = UDim2.new(0, 12, 1, -16)
    track.BackgroundColor3 = Theme.Main
    track.BorderSizePixel = 0
    track.ZIndex = 2
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
    
    local fill = Instance.new("Frame")
    fill.Parent = track
    fill.Size = UDim2.new((initial - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Theme.Accent
    fill.BorderSizePixel = 0
    fill.ZIndex = 3
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    
    local fillGradient = Instance.new("UIGradient")
    fillGradient.Color = ColorSequence.new(Theme.AccentDark, Theme.Accent)
    fillGradient.Parent = fill
    
    local knob = Instance.new("Frame")
    knob.Parent = track
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new((initial - min) / (max - min), 0, 0.5, 0)
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.BackgroundColor3 = Theme.Text
    knob.BorderSizePixel = 0
    knob.ZIndex = 4
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
    local knobStroke = Instance.new("UIStroke", knob)
    knobStroke.Color = Theme.Accent
    knobStroke.Thickness = 2

    local dragging = false
    local function update(input)
        local relX = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        local rawVal = min + relX * (max - min)
        local val = math.floor(rawVal * 10 + 0.5) / 10
        val = math.clamp(val, min, max)
        
        valueLbl.Text = tostring(val)
        fill.Size = UDim2.new(relX, 0, 1, 0)
        knob.Position = UDim2.new(relX, 0, 0.5, 0)
        
        if callback then callback(val) end
    end

    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            update(input)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    return card
end

-- 5. Color Picker (Палитра)
local function CreateColorPicker(parent, text, initialColor, callback)
    local card = CreateCard(parent, 38)
    
    local title = Instance.new("TextLabel")
    title.Parent = card
    title.Size = UDim2.new(1, -60, 1, 0)
    title.Position = UDim2.new(0, 12, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = text
    title.TextColor3 = Theme.Text
    title.Font = Enum.Font.GothamMedium
    title.TextSize = 13
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 2
    
    local preview = Instance.new("Frame")
    preview.Parent = card
    preview.AnchorPoint = Vector2.new(1, 0.5)
    preview.Position = UDim2.new(1, -12, 0.5, 0)
    preview.Size = UDim2.new(0, 20, 0, 20)
    preview.BackgroundColor3 = initialColor
    preview.BorderSizePixel = 0
    preview.ZIndex = 2
    Instance.new("UICorner", preview).CornerRadius = UDim.new(1, 0)
    local prevStroke = Instance.new("UIStroke", preview)
    prevStroke.Color = Theme.Stroke
    
    local palette = Instance.new("Frame")
    palette.Parent = card
    palette.Size = UDim2.new(0, 170, 0, 110)
    palette.Position = UDim2.new(1, -180, 0, 40)
    palette.BackgroundColor3 = Theme.Main
    palette.BorderSizePixel = 0
    palette.Visible = false
    palette.ZIndex = 50
    Instance.new("UICorner", palette).CornerRadius = UDim.new(0, 8)
    local palStroke = Instance.new("UIStroke", palette)
    palStroke.Color = Theme.Stroke
    
    local grid = Instance.new("UIGridLayout", palette)
    grid.CellSize = UDim2.new(0, 24, 0, 24)
    grid.CellPadding = UDim2.new(0, 6, 0, 6)
    grid.SortOrder = Enum.SortOrder.LayoutOrder
    local palPad = Instance.new("UIPadding", palette)
    palPad.PaddingTop = UDim.new(0, 10)
    palPad.PaddingLeft = UDim.new(0, 10)
    
    local colors = {
        Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 85, 85), 
        Color3.fromRGB(255, 170, 0), Color3.fromRGB(80, 250, 123), 
        Color3.fromRGB(0, 200, 255), Color3.fromRGB(140, 100, 255),
        Color3.fromRGB(255, 100, 200), Color3.fromRGB(200, 200, 200), 
        Color3.fromRGB(100, 100, 100)
    }
    
    for _, c in ipairs(colors) do
        local cBtn = Instance.new("TextButton", palette)
        cBtn.BackgroundColor3 = c
        cBtn.Text = ""
        cBtn.BorderSizePixel = 0
        cBtn.ZIndex = 51
        Instance.new("UICorner", cBtn).CornerRadius = UDim.new(1, 0)
        cBtn.MouseButton1Click:Connect(function()
            preview.BackgroundColor3 = c
            palette.Visible = false
            if callback then callback(c) end
        end)
    end
    
    local btn = Instance.new("TextButton", card)
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.ZIndex = 5
    btn.MouseButton1Click:Connect(function()
        palette.Visible = not palette.Visible
    end)
    
    return card
end
-- language: Lua, target: Roblox (ANON Ultimate WH - Part 3)
-- script: Menu Assembly & Core ESP Logic

-- ================= СБОРКА ИНТЕРФЕЙСА =================
local visualPage = CreateTab("Visuals")
CreateSection(visualPage, "Основные настройки")
CreateToggle(visualPage, "Включить ESP", Settings.esp_enabled, function(s) Settings.esp_enabled = s end)
CreateToggle(visualPage, "Team Check", Settings.team_check, function(s) Settings.team_check = s end)

CreateSection(visualPage, "Боксы и Заливка")
CreateToggle(visualPage, "Боксы (Highlight)", Settings.box_enabled, function(s) Settings.box_enabled = s end)
CreateColorPicker(visualPage, "Цвет контура", Settings.box_color, function(c) Settings.box_color = c end)

CreateToggle(visualPage, "Заливка (Fill)", Settings.fill_enabled, function(s) Settings.fill_enabled = s end)
CreateColorPicker(visualPage, "Цвет заливки", Settings.fill_color, function(c) Settings.fill_color = c end)
CreateSlider(visualPage, "Прозрачность", 0, 1, 0.5, function(v) Settings.fill_transparency = v end)

CreateSection(visualPage, "Информация")
CreateToggle(visualPage, "Никнейм", Settings.name_enabled, function(s) Settings.name_enabled = s end)
CreateColorPicker(visualPage, "Цвет Ника", Settings.name_color, function(c) Settings.name_color = c end)
CreateToggle(visualPage, "Дистанция", Settings.distance_enabled, function(s) Settings.distance_enabled = s end)

local localPage = CreateTab("Local")
CreateSection(localPage, "Камера")
CreateSlider(localPage, "Field of View", 30, 120, Settings.fov, function(v) 
    Settings.fov = v
    if Workspace.CurrentCamera then Workspace.CurrentCamera.FieldOfView = v end
end)

-- Автоматически открываем первую вкладку
if Tabs["Visuals"] then Tabs["Visuals"].Button.MouseButton1Click:Fire() end

-- ================= ЛОГИКА ESP (CORE) =================
local ESP_Cache = {}

-- Функция создания визуальных элементов
local function CreateESP(player)
    local char = player.Character
    if not char then return end

    -- 1. Highlight (Боксы и заливка)
    local highlight = Instance.new("Highlight")
    highlight.Name = "ANON_HL"
    highlight.Adornee = char
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Enabled = false
    highlight.Parent = char

    -- 2. BillboardGui (Текст над головой)
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ANON_BB"
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Enabled = false
    billboard.Parent = char

    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.TextStrokeTransparency = 0
    text.Font = Enum.Font.GothamBold
    text.TextSize = 14
    text.Parent = billboard

    ESP_Cache[player] = { Highlight = highlight, Billboard = billboard, Text = text }
end

-- Единый цикл обновления (без костылей и лишних потоков)
RunService.RenderStepped:Connect(function()
    -- Если ESP выключен, скрываем всё
    if not Settings.esp_enabled then
        for _, esp in pairs(ESP_Cache) do
            if esp.Highlight then esp.Highlight.Enabled = false end
            if esp.Billboard then esp.Billboard.Enabled = false end
        end
        return
    end

    -- Если включен, пробегаемся по игрокам
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChildOfClass("Humanoid")
            local head = char:FindFirstChild("Head")

            local isValid = hrp and hum and hum.Health > 0 and head
            
            if isValid and Settings.team_check and player.Team == LocalPlayer.Team then
                isValid = false
            end

            if isValid then
                -- Если объекта нет, создаем
                if not ESP_Cache[player] or not char:FindFirstChild("ANON_HL") then
                    CreateESP(player)
                end
                
                local esp = ESP_Cache[player]
                if esp and esp.Highlight then
                    -- Настройки Highlight
                    esp.Highlight.Enabled = Settings.box_enabled or Settings.fill_enabled
                    esp.Highlight.OutlineColor = Settings.box_color
                    esp.Highlight.OutlineTransparency = not Settings.box_enabled and 1 or 0
                    esp.Highlight.FillColor = Settings.fill_color
                    esp.Highlight.FillTransparency = not Settings.fill_enabled and 1 or Settings.fill_transparency

                    -- Настройки текста (Ник и Дистанция)
                    if esp.Billboard and esp.Text then
                        esp.Billboard.Enabled = Settings.name_enabled or Settings.distance_enabled
                        
                        local dist = 0
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude)
                        end
                        
                        if Settings.name_enabled and Settings.distance_enabled then
                            esp.Text.Text = player.Name .. " [" .. dist .. "m]"
                        elseif Settings.name_enabled then
                            esp.Text.Text = player.Name
                        elseif Settings.distance_enabled then
                            esp.Text.Text = "[" .. dist .. "m]"
                        else
                            esp.Text.Text = ""
                        end
                        
                        esp.Text.TextColor3 = Settings.name_color
                    end
                end
            else
                -- Скрываем, если мертв
                if ESP_Cache[player] then
                    if ESP_Cache[player].Highlight then ESP_Cache[player].Highlight.Enabled = false end
                    if ESP_Cache[player].Billboard then ESP_Cache[player].Billboard.Enabled = false end
                end
            end
        end
    end
end)

-- Очистка при выходе игрока
Players.PlayerRemoving:Connect(function(player)
    if ESP_Cache[player] then
        if ESP_Cache[player].Highlight then ESP_Cache[player].Highlight:Destroy() end
        if ESP_Cache[player].Billboard then ESP_Cache[player].Billboard:Destroy() end
        ESP_Cache[player] = nil
    end
end)
-- language: Lua, target: Roblox (ANON Ultimate WH - Part 4)
-- script: Advanced Visuals (Health Bar & Body Parts)

-- ================= ДОБАВЛЯЕМ НОВЫЕ НАСТРОЙКИ =================
-- Мы просто дописываем их в существующую таблицу Settings
Settings.health_enabled = true
Settings.hl_body_part = "Весь персонаж"
Settings.hl_depth = "AlwaysOnTop"

-- ================= ДОБАВЛЯЕМ ЭЛЕМЕНТЫ В МЕНЮ =================
if Tabs["Visuals"] then
    local vPage = Tabs["Visuals"].Page
    CreateSection(vPage, "Здоровье и Настройки")
    
    CreateToggle(vPage, "Health Bar (Полоска HP)", Settings.health_enabled, function(s) Settings.health_enabled = s end)
    
    -- Кнопка смены части тела для Highlight
    local partCard = CreateCard(vPage, 38)
    local partText = Instance.new("TextLabel", partCard)
    partText.Size = UDim2.new(1, -100, 1, 0)
    partText.Position = UDim2.new(0, 12, 0, 0)
    partText.BackgroundTransparency = 1
    partText.Text = "Цель: " .. Settings.hl_body_part
    partText.TextColor3 = Theme.Text
    partText.Font = Enum.Font.GothamMedium
    partText.TextSize = 13
    partText.TextXAlignment = Enum.TextXAlignment.Left
    
    local partBtn = Instance.new("TextButton", partCard)
    partBtn.Size = UDim2.new(0, 80, 1, 0)
    partBtn.Position = UDim2.new(1, -80, 0, 0)
    partBtn.BackgroundTransparency = 1
    partBtn.Text = "Сменить"
    partBtn.TextColor3 = Theme.Accent
    partBtn.Font = Enum.Font.GothamBold
    
    local parts = {"Весь персонаж", "Только голова", "Только торс"}
    local partIndex = 1
    partBtn.MouseButton1Click:Connect(function()
        partIndex = partIndex + 1
        if partIndex > #parts then partIndex = 1 end
        Settings.hl_body_part = parts[partIndex]
        partText.Text = "Цель: " .. Settings.hl_body_part
    end)
end

-- ================= ОБНОВЛЯЕМ CreateESP (Добавляем Health Bar) =================
-- Перехватываем создание, чтобы добавить Health Bar в кэш
local oldCreateESP = CreateESP
CreateESP = function(player)
    oldCreateESP(player) -- Вызываем базовую функцию (Highlight и Ник)
    
    local char = player.Character
    if not char or not ESP_Cache[player] then return end
    
    -- Создаем Health Bar (BillboardGui)
    local healthGui = Instance.new("BillboardGui")
    healthGui.Name = "ANON_HB"
    healthGui.Size = UDim2.new(0, 50, 0, 6)
    healthGui.StudsOffset = Vector3.new(0, 2.2, 0) -- Чуть ниже ника
    healthGui.AlwaysOnTop = true
    healthGui.Enabled = false
    healthGui.Parent = char
    
    local bg = Instance.new("Frame", healthGui)
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    bg.BorderSizePixel = 0
    Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)
    
    local fill = Instance.new("Frame", bg)
    fill.Size = UDim2.new(1, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    fill.BorderSizePixel = 0
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    
    ESP_Cache[player].HealthGui = healthGui
    ESP_Cache[player].HealthFill = fill
end

-- ================= ОБНОВЛЯЕМ ЦИКЛ RENDER STEPPED =================
-- Перехватываем старый цикл, чтобы обновлять новые элементы
local oldRenderStepped = RunService.RenderStepped
RunService.RenderStepped:Connect(function()
    if not Settings.esp_enabled then return end
    
    for player, esp in pairs(ESP_Cache) do
        local char = player.Character
        if char and char:FindFirstChild("Head") then
            local head = char:FindFirstChild("Head")
            local hum = char:FindFirstChildOfClass("Humanoid")
            
            -- 1. Обновляем Highlight (Части тела и Глубина)
            if esp.Highlight then
                if Settings.hl_depth == "AlwaysOnTop" then
                    esp.Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                else
                    esp.Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
                end
                
                if Settings.hl_body_part == "Только голова" then
                    esp.Highlight.Adornee = head
                elseif Settings.hl_body_part == "Только торс" then
                    esp.Highlight.Adornee = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char
                else
                    esp.Highlight.Adornee = char
                end
            end
            
            -- 2. Обновляем Health Bar
            if esp.HealthGui and esp.HealthFill and hum then
                esp.HealthGui.Enabled = Settings.health_enabled
                esp.HealthGui.Adornee = head
                
                local hpPerc = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                esp.HealthFill.Size = UDim2.new(hpPerc, 0, 1, 0)
                -- Цвет от красного к зеленому
                esp.HealthFill.BackgroundColor3 = Color3.fromRGB(255, 0, 0):Lerp(Color3.fromRGB(0, 255, 0), hpPerc)
            end
        else
            -- Если персонажа нет (умер/вышел), скрываем
            if esp.HealthGui then esp.HealthGui.Enabled = false end
        end
    end
end)

-- Очистка при выходе
Players.PlayerRemoving:Connect(function(player)
    if ESP_Cache[player] then
        if ESP_Cache[player].HealthGui then ESP_Cache[player].HealthGui:Destroy() end
    end
end)
-- language: Lua, target: Roblox (ANON Ultimate WH - Part 5)
-- script: Tracers (Lines) & Final Polish

-- ================= ДОБАВЛЯЕМ НАСТРОЙКИ ДЛЯ ТРАССЕРОВ =================
Settings.tracer_enabled = false
Settings.tracer_color = Color3.fromRGB(140, 100, 255)
Settings.tracer_thickness = 2

-- ================= ДОБАВЛЯЕМ В МЕНЮ =================
if Tabs["Visuals"] then
    local vPage = Tabs["Visuals"].Page
    CreateSection(vPage, "Линии (Tracers)")
    CreateToggle(vPage, "Включить Tracers", Settings.tracer_enabled, function(s) Settings.tracer_enabled = s end)
    CreateColorPicker(vPage, "Цвет линий", Settings.tracer_color, function(c) Settings.tracer_color = c end)
    CreateSlider(vPage, "Толщина линий", 1, 5, Settings.tracer_thickness, function(v) Settings.tracer_thickness = v end)
end

-- ================= ОБНОВЛЯЕМ CreateESP (Добавляем линии) =================
-- Перехватываем создание объектов для игрока
local oldCreateESP_Part5 = CreateESP
CreateESP = function(player)
    oldCreateESP_Part5(player) -- Создаем Highlight, Ник и Health Bar
    
    local char = player.Character
    if not char or not ESP_Cache[player] then return end
    
    -- Создаем линию (Tracer)
    local tracer = Instance.new("Frame")
    tracer.Name = "ANON_Tracer"
    tracer.AnchorPoint = Vector2.new(0, 0.5)
    tracer.BackgroundColor3 = Settings.tracer_color
    tracer.BorderSizePixel = 0
    tracer.ZIndex = 10
    tracer.Visible = false
    
    -- Добавляем линию в ScreenGui, чтобы она рисовалась поверх всего
    tracer.Parent = ScreenGui
    
    ESP_Cache[player].Tracer = tracer
end

-- ================= ОБНОВЛЯЕМ ЦИКЛ (Рисуем линии) =================
RunService.RenderStepped:Connect(function()
    if not Settings.esp_enabled then return end
    
    local camera = Workspace.CurrentCamera
    if not camera then return end
    
    for player, esp in pairs(ESP_Cache) do
        local char = player.Character
        if char and char:FindFirstChild("Head") and esp.Tracer then
            
            if Settings.tracer_enabled then
                local headPos, onScreen = camera:WorldToViewportPoint(char.Head.Position)
                
                if onScreen then
                    -- Стартовая точка: Низ экрана по центру
                    local startX = camera.ViewportSize.X / 2
                    local startY = camera.ViewportSize.Y
                    
                    -- Конечная точка: Голова врага
                    local endX = headPos.X
                    local endY = headPos.Y
                    
                    -- Вычисляем расстояние и угол
                    local dx = endX - startX
                    local dy = endY - startY
                    local distance = math.sqrt(dx * dx + dy * dy)
                    local angle = math.deg(math.atan2(dy, dx))
                    
                    -- Настраиваем рамку (линию)
                    esp.Tracer.Position = UDim2.new(0, startX, 0, startY)
                    esp.Tracer.Size = UDim2.new(0, distance, 0, Settings.tracer_thickness)
                    esp.Tracer.Rotation = angle
                    esp.Tracer.BackgroundColor3 = Settings.tracer_color
                    esp.Tracer.Visible = true
                else
                    esp.Tracer.Visible = false
                end
            else
                esp.Tracer.Visible = false
            end
        else
            if esp.Tracer then esp.Tracer.Visible = false end
        end
    end
end)

-- Очистка при выходе
Players.PlayerRemoving:Connect(function(player)
    if ESP_Cache[player] then
        if ESP_Cache[player].Tracer then ESP_Cache[player].Tracer:Destroy() end
    end
end)

print("[ANON] Ultimate WH Loaded. 100% Mobile Ready.")
-- language: Lua, target: Roblox (ANON Ultimate WH - Part 6)
-- script: Skeleton & Chams (Pure Visuals)

-- ================= НОВЫЕ НАСТРОЙКИ =================
Settings.skeleton_enabled = false
Settings.skeleton_color = Color3.fromRGB(255, 255, 255)
Settings.chams_enabled = false
Settings.chams_color = Color3.fromRGB(255, 0, 0)
Settings.vis_check_enabled = false
Settings.vis_color = Color3.fromRGB(255, 0, 0) -- Цвет, если за стеной

-- ================= ДОБАВЛЯЕМ В МЕНЮ =================
if Tabs["Visuals"] then
    local vPage = Tabs["Visuals"].Page
    CreateSection(vPage, "Продвинутый Визуал")
    
    CreateToggle(vPage, "Skeleton (Скелет)", Settings.skeleton_enabled, function(s) Settings.skeleton_enabled = s end)
    CreateColorPicker(vPage, "Цвет скелета", Settings.skeleton_color, function(c) Settings.skeleton_color = c end)
    
    CreateToggle(vPage, "Chams (Свечение тела)", Settings.chams_enabled, function(s) Settings.chams_enabled = s end)
    CreateColorPicker(vPage, "Цвет Chams", Settings.chams_color, function(c) Settings.chams_color = c end)

    CreateToggle(vPage, "Visible Check (Цвет за стеной)", Settings.vis_check_enabled, function(s) Settings.vis_check_enabled = s end)
    CreateColorPicker(vPage, "Цвет за стеной", Settings.vis_color, function(c) Settings.vis_color = c end)
end

-- ================= ОБНОВЛЯЕМ CreateESP =================
local oldCreateESP_Part6 = CreateESP
CreateESP = function(player)
    oldCreateESP_Part6(player)
    
    local char = player.Character
    if not char or not ESP_Cache[player] then return end
    
    -- 1. Скелет (Создаем линии внутри BillboardGui)
    local skelGui = Instance.new("BillboardGui")
    skelGui.Name = "ANON_SKEL"
    skelGui.Size = UDim2.new(0, 100, 0, 100) -- Размер под скелет
    skelGui.Adornee = char:FindFirstChild("HumanoidRootPart") or char
    skelGui.AlwaysOnTop = true
    skelGui.Enabled = false
    skelGui.Parent = char
    
    local lines = {}
    for i = 1, 6 do
        local line = Instance.new("Frame")
        line.BackgroundColor3 = Settings.skeleton_color
        line.BorderSizePixel = 0
        line.Visible = false
        line.Parent = skelGui
        table.insert(lines, line)
    end
    
    ESP_Cache[player].SkelGui = skelGui
    ESP_Cache[player].SkelLines = lines

    -- 2. Chams (через Highlight с заливкой)
    -- Мы просто будем использовать второй Highlight, чтобы перекрыть старый
    local chams = Instance.new("Highlight")
    chams.Name = "ANON_CHAMS"
    chams.Adornee = char
    chams.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    chams.FillTransparency = 0 -- Полностью залитый
    chams.OutlineTransparency = 1 -- Без контура
    chams.Enabled = false
    chams.Parent = char
    
    ESP_Cache[player].Chams = chams
end

-- ================= ОБНОВЛЯЕМ ЦИКЛ RENDER STEPPED =================
RunService.RenderStepped:Connect(function()
    if not Settings.esp_enabled then return end
    local camera = Workspace.CurrentCamera
    
    for player, esp in pairs(ESP_Cache) do
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            
            -- 1. Логика Visible Check (меняем цвет контура, если за стеной)
            if esp.Highlight and Settings.vis_check_enabled then
                local head = char:FindFirstChild("Head")
                if head then
                    -- Луч от камеры к голове (если пересекает стену, значит не видно)
                    local rayParams = RaycastParams.new()
                    rayParams.FilterDescendantsInstances = {LocalPlayer.Character, char}
                    rayParams.FilterType = Enum.RaycastFilterType.Exclude
                    
                    local rayResult = Workspace:Raycast(camera.CFrame.Position, head.Position - camera.CFrame.Position, rayParams)
                    
                    if rayResult then
                        -- Враг за стеной
                        esp.Highlight.OutlineColor = Settings.vis_color
                        esp.Highlight.FillColor = Settings.vis_color
                    else
                        -- Враг в прямой видимости
                        esp.Highlight.OutlineColor = Settings.box_color
                        esp.Highlight.FillColor = Settings.fill_color
                    end
                end
            end

            -- 2. Логика Chams
            if esp.Chams then
                esp.Chams.Enabled = Settings.chams_enabled
                if Settings.chams_enabled then
                    esp.Chams.FillColor = Settings.chams_color
                end
            end
            
            -- 3. Логика Скелета
            if esp.SkelGui and esp.SkelLines then
                esp.SkelGui.Enabled = Settings.skeleton_enabled
                if Settings.skeleton_enabled then
                    local function getPos(part)
                        if part then
                            local screenPos, onScreen = camera:WorldToViewportPoint(part.Position)
                            if onScreen then
                                return Vector2.new(screenPos.X, screenPos.Y)
                            end
                        end
                        return nil
                    end
                    
                    -- Ищем части тела (R15)
                    local head = char:FindFirstChild("Head")
                    local ut = char:FindFirstChild("UpperTorso")
                    local lt = char:FindFirstChild("LowerTorso")
                    local la = char:FindFirstChild("LeftUpperArm")
                    local ra = char:FindFirstChild("RightUpperArm")
                    local ll = char:FindFirstChild("LeftUpperLeg")
                    local rl = char:FindFirstChild("RightUpperLeg")
                    
                    if head and ut and lt and la and ra and ll and rl then
                        local hP = getPos(head); local utP = getPos(ut); local ltP = getPos(lt)
                        local laP = getPos(la); local raP = getPos(ra); local llP = getPos(ll); local rlP = getPos(rl)
                        
                        if hP and utP and ltP and laP and raP and llP and rlP then
                            -- Настраиваем линии (берем координаты с экрана и переводим в локальные)
                            local guiPos = esp.SkelGui.AbsolutePosition
                            local center = utP 
                            
                            local function drawLine(line, p1, p2, color)
                                local v1 = p1 - center
                                local v2 = p2 - center
                                local dist = (v2 - v1).Magnitude
                                local angle = math.deg(math.atan2(v2.Y - v1.Y, v2.X - v1.X))
                                
                                line.Position = UDim2.new(0.5, v1.X, 0.5, v1.Y)
                                line.Size = UDim2.new(0, dist, 0, 1)
                                line.Rotation = angle
                                line.BackgroundColor3 = color
                                line.Visible = true
                            end
                            
                            drawLine(esp.SkelLines[1], hP, utP, Settings.skeleton_color)
                            drawLine(esp.SkelLines[2], utP, ltP, Settings.skeleton_color)
                            drawLine(esp.SkelLines[3], utP, laP, Settings.skeleton_color)
                            drawLine(esp.SkelLines[4], utP, raP, Settings.skeleton_color)
                            drawLine(esp.SkelLines[5], ltP, llP, Settings.skeleton_color)
                            drawLine(esp.SkelLines[6], ltP, rlP, Settings.skeleton_color)
                        else
                            for _, l in pairs(esp.SkelLines) do l.Visible = false end
                        end
                    else
                        for _, l in pairs(esp.SkelLines) do l.Visible = false end
                    end
                else
                    for _, l in pairs(esp.SkelLines) do l.Visible = false end
                end
            end
        else
            if esp.Chams then esp.Chams.Enabled = false end
            if esp.SkelGui then esp.SkelGui.Enabled = false end
        end
    end
end)

-- Очистка
Players.PlayerRemoving:Connect(function(player)
    if ESP_Cache[player] then
        if ESP_Cache[player].Chams then ESP_Cache[player].Chams:Destroy() end
        if ESP_Cache[player].SkelGui then ESP_Cache[player].SkelGui:Destroy() end
    end
end)

print("[ANON] Part 6 (Visuals Only) Loaded.")
