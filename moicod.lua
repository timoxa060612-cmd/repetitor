-- language: Lua, target: Roblox (ANON Premium UI - Part 1)
-- script: Core, Theme, Animations & Window Creation

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- Очистка предыдущих версий
if CoreGui:FindFirstChild("ANON_Premium_UI") then CoreGui.ANON_Premium_UI:Destroy() end
if LocalPlayer:FindFirstChild("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("ANON_Premium_UI") then LocalPlayer.PlayerGui.ANON_Premium_UI:Destroy() end

-- ================= ТЕМА (Glassmorphism Dark) =================
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

-- ================= СОСТОЯНИЯ (Настройки) =================
local Settings = {
    -- ESP
    esp_enabled = false,
    team_check = true,
    
    -- Box
    box_enabled = true,
    box_color = Color3.fromRGB(255, 255, 255),
    box_thickness = 1,
    box_transparency = 0,
    
    -- Fill
    fill_enabled = false,
    fill_color = Color3.fromRGB(140, 100, 255),
    fill_transparency = 0.5,
    
    -- Info
    name_enabled = true,
    name_color = Color3.fromRGB(255, 255, 255),
    distance_enabled = true,
    distance_color = Color3.fromRGB(200, 200, 200),
    
    -- Health
    health_enabled = true,
    
    -- Tracers
    tracer_enabled = false,
    tracer_color = Color3.fromRGB(140, 100, 255),
    tracer_thickness = 1,
    tracer_origin = "Bottom", -- Bottom / Mouse
    
    -- Skeleton
    skeleton_enabled = false,
    skeleton_color = Color3.fromRGB(255, 255, 255),
    
    -- Local
    fov = 70
}

-- ================= ОСНОВА UI =================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ANON_Premium_UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- Кнопка открытия (Красивая, с градиентом и тенью)
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

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(1, 0)
btnCorner.Parent = ToggleBtn

local btnGradient = Instance.new("UIGradient")
btnGradient.Color = ColorSequence.new(Theme.Accent, Theme.AccentDark)
btnGradient.Rotation = 45
btnGradient.Parent = ToggleBtn

local btnStroke = Instance.new("UIStroke")
btnStroke.Color = Theme.Stroke
btnStroke.Thickness = 2
btnStroke.Parent = ToggleBtn

-- Главное окно
local MainWindow = Instance.new("Frame")
MainWindow.Parent = ScreenGui
MainWindow.Size = UDim2.new(0, 550, 0, 380)
MainWindow.Position = UDim2.new(0.5, -275, 0.5, -190)
MainWindow.BackgroundColor3 = Theme.Main
MainWindow.BorderSizePixel = 0
MainWindow.Visible = false
MainWindow.ClipsDescendants = true

local winCorner = Instance.new("UICorner")
winCorner.CornerRadius = UDim.new(0, 14)
winCorner.Parent = MainWindow

local winStroke = Instance.new("UIStroke")
winStroke.Color = Theme.Stroke
winStroke.Thickness = 1.5
winStroke.Parent = MainWindow

-- Верхняя панель для перетаскивания
local TopBar = Instance.new("Frame")
TopBar.Parent = MainWindow
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundTransparency = 1
TopBar.Active = true
TopBar.Draggable = true

-- Sidebar (Левая панель)
local Sidebar = Instance.new("Frame")
Sidebar.Parent = MainWindow
Sidebar.Size = UDim2.new(0, 160, 1, 0)
Sidebar.BackgroundColor3 = Theme.Sidebar
Sidebar.BorderSizePixel = 0

local sideCorner = Instance.new("UICorner")
sideCorner.CornerRadius = UDim.new(0, 14)
sideCorner.Parent = Sidebar

-- Заголовок в сайдбаре
local Logo = Instance.new("TextLabel")
Logo.Parent = Sidebar
Logo.Size = UDim2.new(1, -20, 0, 50)
Logo.Position = UDim2.new(0, 20, 0, 15)
Logo.BackgroundTransparency = 1
Logo.Text = "ANON"
Logo.TextColor3 = Theme.Text
Logo.Font = Enum.Font.GothamBlack
Logo.TextSize = 22
Logo.TextXAlignment = Enum.TextXAlignment.Left

local LogoSub = Instance.new("TextLabel")
LogoSub.Parent = Sidebar
LogoSub.Size = UDim2.new(1, -20, 0, 20)
LogoSub.Position = UDim2.new(0, 20, 0, 40)
LogoSub.BackgroundTransparency = 1
LogoSub.Text = "PREMIUM UI"
LogoSub.TextColor3 = Theme.Accent
LogoSub.Font = Enum.Font.GothamBold
LogoSub.TextSize = 10
LogoSub.TextXAlignment = Enum.TextXAlignment.Left

-- Контейнер вкладок
local TabContainer = Instance.new("Frame")
TabContainer.Parent = Sidebar
TabContainer.Size = UDim2.new(1, -20, 1, -100)
TabContainer.Position = UDim2.new(0, 10, 0, 70)
TabContainer.BackgroundTransparency = 1

local TabLayout = Instance.new("UIListLayout")
TabLayout.Parent = TabContainer
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Padding = UDim.new(0, 5)

-- Контентная зона (Правая панель)
local ContentArea = Instance.new("Frame")
ContentArea.Parent = MainWindow
ContentArea.Size = UDim2.new(1, -160, 1, 0)
ContentArea.Position = UDim2.new(0, 160, 0, 0)
ContentArea.BackgroundTransparency = 1

-- Кнопка закрытия UI
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = Sidebar
CloseBtn.Size = UDim2.new(1, -20, 0, 35)
CloseBtn.Position = UDim2.new(0, 10, 1, -45)
CloseBtn.BackgroundColor3 = Color3.fromRGB(40, 20, 20)
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "Unload UI"
CloseBtn.TextColor3 = Theme.Red
CloseBtn.Font = Enum.Font.GothamMedium
CloseBtn.TextSize = 13

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Логика перетаскивания кнопки "A" (с защитой от свайпа)
local dragging = false
local dragStart, startPos
local hasMoved = false

ToggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        hasMoved = false
        dragStart = input.Position
        startPos = ToggleBtn.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

ToggleBtn.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        if math.abs(delta.X) > 5 or math.abs(delta.Y) > 5 then
            hasMoved = true
        end
        if hasMoved then
            ToggleBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
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

-- Функция создания вкладок
local ActiveTab = nil
local Tabs = {}

local function CreateTab(name)
    local btn = Instance.new("TextButton")
    btn.Parent = TabContainer
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.BackgroundColor3 = Theme.Sidebar
    btn.BorderSizePixel = 0
    btn.Text = "  " .. name
    btn.TextColor3 = Theme.SubText
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 13
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    local indicator = Instance.new("Frame")
    indicator.Parent = btn
    indicator.Size = UDim2.new(0, 3, 0.6, 0)
    indicator.Position = UDim2.new(0, 0, 0.2, 0)
    indicator.BackgroundColor3 = Theme.Accent
    indicator.BorderSizePixel = 0
    indicator.Visible = false
    local indCorner = Instance.new("UICorner") indCorner.CornerRadius = UDim.new(1, 0) indCorner.Parent = indicator

    -- Скролл-страница для контента
    local page = Instance.new("ScrollingFrame")
    page.Parent = ContentArea
    page.Size = UDim2.new(1, -20, 1, -20)
    page.Position = UDim2.new(0, 10, 0, 10)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = Theme.Accent
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Visible = false
    
    local layout = Instance.new("UIListLayout")
    layout.Parent = page
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)
    
    local padding = Instance.new("UIPadding")
    padding.Parent = page
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

print("[ANON] Part 1 loaded: Core & Theme Ready.")
-- language: Lua, target: Roblox (ANON Premium UI - Part 2)
-- script: UI Elements (Toggle, Slider, ColorPicker, TextBox)

-- ================= ЭЛЕМЕНТЫ УПРАВЛЕНИЯ =================

-- 1. Карточка (базовая обертка для всех элементов)
local function CreateCard(parent, height)
    local card = Instance.new("Frame")
    card.Parent = parent
    card.Size = UDim2.new(1, -10, 0, height or 42)
    card.BackgroundColor3 = Theme.Card
    card.BorderSizePixel = 0
    card.ZIndex = 1
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = card
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Theme.Stroke
    stroke.Thickness = 1
    stroke.Parent = card
    
    return card
end

-- 2. Заголовок секции (чтобы группировать настройки)
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
    
    -- Фон переключателя
    local toggleBg = Instance.new("Frame")
    toggleBg.Parent = card
    toggleBg.AnchorPoint = Vector2.new(1, 0.5)
    toggleBg.Position = UDim2.new(1, -12, 0.5, 0)
    toggleBg.Size = UDim2.new(0, 36, 0, 20)
    toggleBg.BackgroundColor3 = state and Theme.Accent or Theme.Main
    toggleBg.BorderSizePixel = 0
    toggleBg.ZIndex = 2
    local bgCorner = Instance.new("UICorner") bgCorner.CornerRadius = UDim.new(1, 0) bgCorner.Parent = toggleBg
    local bgStroke = Instance.new("UIStroke") bgStroke.Color = Theme.Stroke bgStroke.Parent = toggleBg
    
    -- Кружок
    local knob = Instance.new("Frame")
    knob.Parent = toggleBg
    knob.AnchorPoint = Vector2.new(0, 0.5)
    knob.Position = state and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.BackgroundColor3 = Theme.Text
    knob.BorderSizePixel = 0
    knob.ZIndex = 3
    local knobCorner = Instance.new("UICorner") knobCorner.CornerRadius = UDim.new(1, 0) knobCorner.Parent = knob
    
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
    local trackCorner = Instance.new("UICorner") trackCorner.CornerRadius = UDim.new(1, 0) trackCorner.Parent = track
    
    local fill = Instance.new("Frame")
    fill.Parent = track
    fill.Size = UDim2.new((initial - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Theme.Accent
    fill.BorderSizePixel = 0
    fill.ZIndex = 3
    local fillCorner = Instance.new("UICorner") fillCorner.CornerRadius = UDim.new(1, 0) fillCorner.Parent = fill
    
    local knob = Instance.new("Frame")
    knob.Parent = track
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new((initial - min) / (max - min), 0, 0.5, 0)
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.BackgroundColor3 = Theme.Text
    knob.BorderSizePixel = 0
    knob.ZIndex = 4
    local knobCorner = Instance.new("UICorner") knobCorner.CornerRadius = UDim.new(1, 0) knobCorner.Parent = knob

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

-- 5. ColorPicker (Палитра цветов)
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
    local prevCorner = Instance.new("UICorner") prevCorner.CornerRadius = UDim.new(1, 0) prevCorner.Parent = preview
    local prevStroke = Instance.new("UIStroke") prevStroke.Color = Theme.Stroke prevStroke.Parent = preview
    
    -- Сама палитра (появляется по клику)
    local palette = Instance.new("Frame")
    palette.Parent = card
    palette.Size = UDim2.new(0, 170, 0, 110)
    palette.Position = UDim2.new(1, -180, 0, 40)
    palette.BackgroundColor3 = Theme.Main
    palette.BorderSizePixel = 0
    palette.Visible = false
    palette.ZIndex = 50
    local palCorner = Instance.new("UICorner") palCorner.CornerRadius = UDim.new(0, 8) palCorner.Parent = palette
    local palStroke = Instance.new("UIStroke") palStroke.Color = Theme.Stroke palStroke.Parent = palette
    
    local grid = Instance.new("UIGridLayout")
    grid.Parent = palette
    grid.CellSize = UDim2.new(0, 24, 0, 24)
    grid.CellPadding = UDim2.new(0, 6, 0, 6)
    grid.SortOrder = Enum.SortOrder.LayoutOrder
    
    local palPad = Instance.new("UIPadding")
    palPad.Parent = palette
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
        local cBtn = Instance.new("TextButton")
        cBtn.Parent = palette
        cBtn.BackgroundColor3 = c
        cBtn.Text = ""
        cBtn.BorderSizePixel = 0
        cBtn.ZIndex = 51
        local cCorner = Instance.new("UICorner") cCorner.CornerRadius = UDim.new(1, 0) cCorner.Parent = cBtn
        
        cBtn.MouseButton1Click:Connect(function()
            preview.BackgroundColor3 = c
            palette.Visible = false
            if callback then callback(c) end
        end)
    end
    
    local btn = Instance.new("TextButton")
    btn.Parent = card
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.ZIndex = 5
    
    btn.MouseButton1Click:Connect(function()
        palette.Visible = not palette.Visible
    end)
    
    return card
end

print("[ANON] Part 2 loaded: UI Elements Ready.")
-- language: Lua, target: Roblox (ANON Premium UI - Part 3)
-- script: Menu Assembly & Advanced ESP Render

-- ================= СБОРКА ИНТЕРФЕЙСА =================

-- Вкладка 1: ESP
local visualPage = CreateTab("Visuals")
CreateSection(visualPage, "Основные настройки")
CreateToggle(visualPage, "Включить ESP", Settings.esp_enabled, function(s) Settings.esp_enabled = s end)
CreateToggle(visualPage, "Team Check (Игнор союзников)", Settings.team_check, function(s) Settings.team_check = s end)

CreateSection(visualPage, "Боксы и Заливка")
CreateToggle(visualPage, "Боксы (Box)", Settings.box_enabled, function(s) Settings.box_enabled = s end)
CreateColorPicker(visualPage, "Цвет боксов", Settings.box_color, function(c) Settings.box_color = c end)
CreateToggle(visualPage, "Заливка (Fill)", Settings.fill_enabled, function(s) Settings.fill_enabled = s end)
CreateColorPicker(visualPage, "Цвет заливки", Settings.fill_color, function(c) Settings.fill_color = c end)

CreateSection(visualPage, "Информация")
CreateToggle(visualPage, "Никнейм", Settings.name_enabled, function(s) Settings.name_enabled = s end)
CreateToggle(visualPage, "Дистанция", Settings.distance_enabled, function(s) Settings.distance_enabled = s end)
CreateToggle(visualPage, "Health Bar", Settings.health_enabled, function(s) Settings.health_enabled = s end)

CreateSection(visualPage, "Продвинутое")
CreateToggle(visualPage, "Tracers (Линии)", Settings.tracer_enabled, function(s) Settings.tracer_enabled = s end)
CreateColorPicker(visualPage, "Цвет Tracers", Settings.tracer_color, function(c) Settings.tracer_color = c end)

CreateToggle(visualPage, "Skeleton (Скелет)", Settings.skeleton_enabled, function(s) Settings.skeleton_enabled = s end)
CreateColorPicker(visualPage, "Цвет скелета", Settings.skeleton_color, function(c) Settings.skeleton_color = c end)

-- Вкладка 2: Local
local localPage = CreateTab("Local")
CreateSection(localPage, "Камера")
CreateSlider(localPage, "Field of View (FOV)", 30, 120, Settings.fov, function(v) 
    Settings.fov = v
    if Workspace.CurrentCamera then Workspace.CurrentCamera.FieldOfView = v end
end)

-- Автоматически открываем первую вкладку
if Tabs["Visuals"] then
    Tabs["Visuals"].Button.MouseButton1Click:Fire()
end

-- ================= ПРОДВИНУТАЯ ЛОГИКА ESP =================

local Drawing = Drawing
local hasDrawing = pcall(function() return Drawing.new("Square") end)
if not hasDrawing then
    warn("[ANON] Твой экзекутор не поддерживает Drawing API. ESP не будет работать.")
    return
end

local ESP_Cache = {}

-- Создаем пул объектов для каждого игрока
local function CreateESPObjects()
    return {
        Box = Drawing.new("Square"),
        Fill = Drawing.new("Square"),
        Name = Drawing.new("Text"),
        Distance = Drawing.new("Text"),
        HealthBg = Drawing.new("Square"),
        HealthBar = Drawing.new("Square"),
        Tracer = Drawing.new("Line"),
        -- Скелет (6 линий: торс, левая рука, правая рука, левая нога, правая нога, голова)
        Skel1 = Drawing.new("Line"),
        Skel2 = Drawing.new("Line"),
        Skel3 = Drawing.new("Line"),
        Skel4 = Drawing.new("Line"),
        Skel5 = Drawing.new("Line"),
        Skel6 = Drawing.new("Line")
    }
end

local function UpdateESP()
    local camera = Workspace.CurrentCamera
    if not camera then return end

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            local head = char:FindFirstChild("Head")
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChildOfClass("Humanoid")
            
            -- Проверка, стоит ли рисовать
            local isValid = head and hrp and hum and hum.Health > 0
            if isValid and Settings.team_check and player.Team == LocalPlayer.Team then
                isValid = false
            end

            if isValid then
                if not ESP_Cache[player] then
                    ESP_Cache[player] = CreateESPObjects()
                end
                
                local esp = ESP_Cache[player]
                
                -- Перевод 3D координат в 2D экран
                local headPos, onScreenHead = camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                local rootPos, onScreenRoot = camera:WorldToViewportPoint(hrp.Position)
                local feetPos, onScreenFeet = camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 2.8, 0))
                
                if onScreenHead and onScreenRoot and onScreenFeet then
                    -- Вычисляем размеры бокса
                    local height = math.abs(headPos.Y - feetPos.Y)
                    local width = height / 2
                    local x = headPos.X - width / 2
                    local y = headPos.Y
                    
                    -- Дистанция до игрока
                    local dist = 0
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude)
                    end
                    
                    -- 1. Боксы
                    esp.Box.Visible = Settings.box_enabled
                    if Settings.box_enabled then
                        esp.Box.Size = Vector2.new(width, height)
                        esp.Box.Position = Vector2.new(x, y)
                        esp.Box.Color = Settings.box_color
                        esp.Box.Thickness = Settings.box_thickness
                        esp.Box.Filled = false
                    end
                    
                    -- 2. Заливка
                    esp.Fill.Visible = Settings.fill_enabled
                    if Settings.fill_enabled then
                        esp.Fill.Size = Vector2.new(width, height)
                        esp.Fill.Position = Vector2.new(x, y)
                        esp.Fill.Color = Settings.fill_color
                        esp.Fill.Transparency = Settings.fill_transparency
                        esp.Fill.Filled = true
                    end
                    
                    -- 3. Имя
                    esp.Name.Visible = Settings.name_enabled
                    if Settings.name_enabled then
                        esp.Name.Text = player.Name
                        esp.Name.Size = 14
                        esp.Name.Center = true
                        esp.Name.Outline = true
                        esp.Name.Color = Settings.name_color
                        esp.Name.Position = Vector2.new(x + width / 2, y - 16)
                    end
                    
                    -- 4. Дистанция
                    esp.Distance.Visible = Settings.distance_enabled
                    if Settings.distance_enabled then
                        esp.Distance.Text = "[" .. dist .. "m]"
                        esp.Distance.Size = 12
                        esp.Distance.Center = true
                        esp.Distance.Outline = true
                        esp.Distance.Color = Settings.distance_color
                        esp.Distance.Position = Vector2.new(x + width / 2, y + height + 2)
                    end
                    
                    -- 5. Health Bar
                    esp.HealthBg.Visible = Settings.health_enabled
                    esp.HealthBar.Visible = Settings.health_enabled
                    if Settings.health_enabled then
                        local hpPerc = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                        local barW = 3
                        local barH = height
                        
                        esp.HealthBg.Size = Vector2.new(barW, barH)
                        esp.HealthBg.Position = Vector2.new(x - 6, y)
                        esp.HealthBg.Color = Color3.fromRGB(20, 20, 20)
                        esp.HealthBg.Filled = true
                        
                        esp.HealthBar.Size = Vector2.new(barW, barH * hpPerc)
                        esp.HealthBar.Position = Vector2.new(x - 6, y + (barH - barH * hpPerc))
                        esp.HealthBar.Color = Color3.fromRGB(0, 255, 0):Lerp(Color3.fromRGB(255, 0, 0), 1 - hpPerc)
                        esp.HealthBar.Filled = true
                    end
                    
                    -- 6. Tracers (Линии)
                    esp.Tracer.Visible = Settings.tracer_enabled
                    if Settings.tracer_enabled then
                        esp.Tracer.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                        esp.Tracer.To = Vector2.new(rootPos.X, rootPos.Y)
                        esp.Tracer.Color = Settings.tracer_color
                        esp.Tracer.Thickness = Settings.tracer_thickness
                    end
                    
                    -- 7. Skeleton (Скелет)
                    local skels = {esp.Skel1, esp.Skel2, esp.Skel3, esp.Skel4, esp.Skel5, esp.Skel6}
                    for _, line in pairs(skels) do line.Visible = Settings.skeleton_enabled end
                    
                    if Settings.skeleton_enabled then
                        -- Ищем части тела (R15 или R6)
                        local upperTorso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
                        local lowerTorso = char:FindFirstChild("LowerTorso")
                        local leftArm = char:FindFirstChild("LeftUpperArm") or char:FindFirstChild("Left Arm")
                        local rightArm = char:FindFirstChild("RightUpperArm") or char:FindFirstChild("Right Arm")
                        local leftLeg = char:FindFirstChild("LeftUpperLeg") or char:FindFirstChild("Left Leg")
                        local rightLeg = char:FindFirstChild("RightUpperLeg") or char:FindFirstChild("Right Leg")
                        
                        if upperTorso and leftArm and rightArm and leftLeg and rightLeg then
                            local utPos = camera:WorldToViewportPoint(upperTorso.Position)
                            local laPos = camera:WorldToViewportPoint(leftArm.Position)
                            local raPos = camera:WorldToViewportPoint(rightArm.Position)
                            local llPos = camera:WorldToViewportPoint(leftLeg.Position)
                            local rlPos = camera:WorldToViewportPoint(rightLeg.Position)
                            
                            -- Голова к торсу
                            esp.Skel1.From = Vector2.new(headPos.X, headPos.Y)
                            esp.Skel1.To = Vector2.new(utPos.X, utPos.Y)
                            -- Торс к рукам
                            esp.Skel2.From = Vector2.new(utPos.X, utPos.Y)
                            esp.Skel2.To = Vector2.new(laPos.X, laPos.Y)
                            esp.Skel3.From = Vector2.new(utPos.X, utPos.Y)
                            esp.Skel3.To = Vector2.new(raPos.X, raPos.Y)
                            -- Торс к ногам
                            esp.Skel4.From = Vector2.new(utPos.X, utPos.Y)
                            esp.Skel4.To = Vector2.new(llPos.X, llPos.Y)
                            esp.Skel5.From = Vector2.new(utPos.X, utPos.Y)
                            esp.Skel5.To = Vector2.new(rlPos.X, rlPos.Y)
                            
                            for _, line in pairs(skels) do
                                line.Color = Settings.skeleton_color
                                line.Thickness = 1
                            end
                        end
                    end
                    
                else
                    -- Если цель за экраном, скрываем отрисовку
                    for _, obj in pairs(esp) do obj.Visible = false end
                end
            else
                -- Если игрок мертв
                if ESP_Cache[player] then
                    for _, obj in pairs(ESP_Cache[player]) do obj.Visible = false end
                end
            end
        end
    end
end

-- Очистка при выходе игрока
Players.PlayerRemoving:Connect(function(player)
    if ESP_Cache[player] then
        for _, obj in pairs(ESP_Cache[player]) do
            if obj then obj:Remove() end
        end
        ESP_Cache[player] = nil
    end
end)

-- Главный цикл отрисовки (оптимизация)
RunService.RenderStepped:Connect(function()
    if not Settings.esp_enabled then
        for _, esp in pairs(ESP_Cache) do
            for _, obj in pairs(esp) do obj.Visible = false end
        end
        return
    end
    UpdateESP()
end)

print("[ANON] Part 3 loaded: Full UI & ESP Online.")
print("Script successfully executed. Press 'A' to toggle menu.")
