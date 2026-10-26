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
    
    -- Highlight (вместо Drawing Box)
    box_enabled = true,
    box_color = Color3.fromRGB(255, 255, 255),
    box_transparency = 0,
    
    fill_enabled = true,
    fill_color = Color3.fromRGB(140, 100, 255),
    fill_transparency = 0.5,
    
    -- Text
    name_enabled = true,
    name_color = Color3.fromRGB(255, 255, 255),
    distance_enabled = true,
    distance_color = Color3.fromRGB(200, 200, 200),
    
    -- Local
    fov = 70,
    ping = 0
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

-- Логика перетаскивания кнопки "A"
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
-- script: UI Elements (Deep Customization)

-- ================= ЭЛЕМЕНТЫ УПРАВЛЕНИЯ =================

-- 1. Карточка (базовая обертка с эффектом наведения)
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
    
    -- Анимация при наведении (на ПК) или тапе
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

-- 2. Заголовок секции (группировка)
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

-- 4. Slider (Ползунок с плавным градиентом)
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
    local knobCorner = Instance.new("UICorner") knobCorner.CornerRadius = UDim.new(1, 0) knobCorner.Parent = knob
    local knobStroke = Instance.new("UIStroke") knobStroke.Color = Theme.Accent knobStroke.Thickness = 2 knobStroke.Parent = knob

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
    
    -- Палитра
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
-- script: Menu Assembly & Mobile-Optimized ESP

-- ================= СБОРКА ИНТЕРФЕЙСА =================

-- Вкладка 1: Визуалы (ESP)
local visualPage = CreateTab("Visuals")
CreateSection(visualPage, "Основные настройки")
CreateToggle(visualPage, "Включить ESP", Settings.esp_enabled, function(s) Settings.esp_enabled = s end)
CreateToggle(visualPage, "Team Check (Игнор союзников)", Settings.team_check, function(s) Settings.team_check = s end)

CreateSection(visualPage, "Боксы и Заливка")
CreateToggle(visualPage, "Боксы (Highlight)", Settings.box_enabled, function(s) Settings.box_enabled = s end)
CreateColorPicker(visualPage, "Цвет контура", Settings.box_color, function(c) Settings.box_color = c end)

CreateToggle(visualPage, "Заливка (Fill)", Settings.fill_enabled, function(s) Settings.fill_enabled = s end)
CreateColorPicker(visualPage, "Цвет заливки", Settings.fill_color, function(c) Settings.fill_color = c end)
CreateSlider(visualPage, "Прозрачность заливки", 0, 1, 0.5, function(v) Settings.fill_transparency = v end)

CreateSection(visualPage, "Текстовая информация")
CreateToggle(visualPage, "Никнейм", Settings.name_enabled, function(s) Settings.name_enabled = s end)
CreateColorPicker(visualPage, "Цвет Ника", Settings.name_color, function(c) Settings.name_color = c end)
CreateToggle(visualPage, "Дистанция", Settings.distance_enabled, function(s) Settings.distance_enabled = s end)

-- Вкладка 2: Локальные настройки (Local)
local localPage = CreateTab("Local")
CreateSection(localPage, "Камера")
CreateSlider(localPage, "Field of View (FOV)", 30, 120, Settings.fov, function(v) 
    Settings.fov = v
    if Workspace.CurrentCamera then Workspace.CurrentCamera.FieldOfView = v end
end)

-- Автоматически открываем первую вкладку при запуске
if Tabs["Visuals"] then
    Tabs["Visuals"].Button.MouseButton1Click:Fire()
end

-- ================= ЛОГИКА ESP (BillboardGui & Highlight) =================

local ESP_Cache = {}

-- Функция создания визуальных элементов для игрока
local function CreateESP(player)
    local char = player.Character
    if not char then return end

    -- 1. Highlight (Свечение сквозь стены)
    local highlight = Instance.new("Highlight")
    highlight.Name = "ANON_HL"
    highlight.Adornee = char
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- Видно сквозь стены
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

-- Главный цикл обновления ESP
RunService.RenderStepped:Connect(function()
    -- Если ESP выключен, скрываем всё и не нагружаем процессор
    if not Settings.esp_enabled then
        for _, esp in pairs(ESP_Cache) do
            if esp.Highlight then esp.Highlight.Enabled = false end
            if esp.Billboard then esp.Billboard.Enabled = false end
        end
        return
    end

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChildOfClass("Humanoid")
            local head = char:FindFirstChild("Head")

            -- Проверка на жизнь, наличие частей и команду
            local isValid = hrp and hum and hum.Health > 0 and head
            if isValid and Settings.team_check and player.Team == LocalPlayer.Team then
                isValid = false
            end

            if isValid then
                -- Если объектов еще нет или они удалились при респавне — создаем заново
                if not ESP_Cache[player] or not char:FindFirstChild("ANON_HL") then
                    CreateESP(player)
                end
                
                local esp = ESP_Cache[player]
                if esp and esp.Highlight and esp.Billboard then
                    -- Настраиваем Highlight (Боксы/Заливка)
                    esp.Highlight.Enabled = Settings.box_enabled or Settings.fill_enabled
                    esp.Highlight.OutlineColor = Settings.box_color
                    esp.Highlight.OutlineTransparency = not Settings.box_enabled and 1 or 0
                    
                    esp.Highlight.FillColor = Settings.fill_color
                    esp.Highlight.FillTransparency = not Settings.fill_enabled and 1 or Settings.fill_transparency

                    -- Настраиваем текст (Ник и Дистанция)
                    esp.Billboard.Enabled = Settings.name_enabled or Settings.distance_enabled
                    esp.Billboard.Adornee = head
                    
                    if Settings.name_enabled or Settings.distance_enabled then
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
                        end
                        
                        esp.Text.TextColor3 = Settings.name_color
                    end
                end
            else
                -- Если игрок умер или вышел, скрываем его ESP
                if ESP_Cache[player] then
                    if ESP_Cache[player].Highlight then ESP_Cache[player].Highlight.Enabled = false end
                    if ESP_Cache[player].Billboard then ESP_Cache[player].Billboard.Enabled = false end
                end
            end
        end
    end
end)

-- Очистка памяти, когда игрок выходит с сервера
Players.PlayerRemoving:Connect(function(player)
    if ESP_Cache[player] then
        if ESP_Cache[player].Highlight then ESP_Cache[player].Highlight:Destroy() end
        if ESP_Cache[player].Billboard then ESP_Cache[player].Billboard:Destroy() end
        ESP_Cache[player] = nil
    end
end)

print("[ANON] Part 3 loaded: Mobile ESP & Menu Online.")
print("Script successfully executed.")
-- language: Lua, target: Roblox (ANON Premium UI - Part 4)
-- script: Advanced WH Features (Tracers, Health, Highlight Depth)

-- ================= ДОБАВЛЯЕМ НОВЫЕ ПЕРЕМЕННЫЕ В НАСТРОЙКИ =================
-- Так как мы не меняем прошлый код, мы просто добавляем новые ключи в таблицу Settings
Settings.tracers_enabled = false
Settings.tracers_color = Color3.fromRGB(255, 255, 255)
Settings.tracers_thickness = 1

Settings.health_enabled = true

Settings.hl_depth = "AlwaysOnTop" -- AlwaysOnTop / Occluded
Settings.hl_body_part = "Весь персонаж" -- Весь персонаж / Только голова / Только торс

-- ================= ДОБАВЛЯЕМ ЭЛЕМЕНТЫ В МЕНЮ =================
-- Находим страницу "Visuals", которую создали в части 3
if Tabs["Visuals"] then
    local vPage = Tabs["Visuals"].Page
    
    CreateSection(vPage, "Дополнительные фишки")
    
    -- 1. Трассеры
    CreateToggle(vPage, "Tracers (Линии)", Settings.tracers_enabled, function(s) Settings.tracers_enabled = s end)
    CreateColorPicker(vPage, "Цвет линий", Settings.tracers_color, function(c) Settings.tracers_color = c end)
    CreateSlider(vPage, "Толщина линий", 1, 5, Settings.tracers_thickness, function(v) Settings.tracers_thickness = v end)
    
    -- 2. Полоска здоровья
    CreateToggle(vPage, "Health Bar над головой", Settings.health_enabled, function(s) Settings.health_enabled = s end)

    -- 3. Настройки Highlight (Глубина и части)
    CreateSection(vPage, "Настройки Highlight (Боксы)")
    
    -- Выбор частей тела для подсветки
    local partCard = CreateCard(vPage, 38)
    local partText = Instance.new("TextLabel", partCard)
    partText.Size = UDim2.new(1, -100, 1, 0)
    partText.Position = UDim2.new(0, 12, 0, 0)
    partText.BackgroundTransparency = 1
    partText.Text = "Подсвечивать: " .. Settings.hl_body_part
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
        partText.Text = "Подсвечивать: " .. Settings.hl_body_part
    end)

    -- Выбор глубины (видно сквозь стены или нет)
    local depthCard = CreateCard(vPage, 38)
    local depthText = Instance.new("TextLabel", depthCard)
    depthText.Size = UDim2.new(1, -100, 1, 0)
    depthText.Position = UDim2.new(0, 12, 0, 0)
    depthText.BackgroundTransparency = 1
    depthText.Text = "Режим: " .. Settings.hl_depth
    depthText.TextColor3 = Theme.Text
    depthText.Font = Enum.Font.GothamMedium
    depthText.TextSize = 13
    depthText.TextXAlignment = Enum.TextXAlignment.Left
    
    local depthBtn = Instance.new("TextButton", depthCard)
    depthBtn.Size = UDim2.new(0, 80, 1, 0)
    depthBtn.Position = UDim2.new(1, -80, 0, 0)
    depthBtn.BackgroundTransparency = 1
    depthBtn.Text = "Сменить"
    depthBtn.TextColor3 = Theme.Accent
    depthBtn.Font = Enum.Font.GothamBold
    
    depthBtn.MouseButton1Click:Connect(function()
        if Settings.hl_depth == "AlwaysOnTop" then
            Settings.hl_depth = "Occluded"
        else
            Settings.hl_depth = "AlwaysOnTop"
        end
        depthText.Text = "Режим: " .. Settings.hl_depth
    end)
end

-- ================= ЛОГИКА ДЛЯ НОВЫХ ФИШЕК =================

-- Обновляем функцию CreateESP, чтобы добавить Health Bar и Tracers
-- Мы не перезаписываем старую, а создаем прослойку
local old_CreateESP = CreateESP
CreateESP = function(player)
    old_CreateESP(player) -- Вызываем старую логику (Highlight и Ник)
    
    local char = player.Character
    if not char or not ESP_Cache[player] then return end
    
    -- 1. Создаем Health Bar (BillboardGui)
    local healthGui = Instance.new("BillboardGui")
    healthGui.Name = "ANON_HB"
    healthGui.Size = UDim2.new(0, 50, 0, 6)
    healthGui.StudsOffset = Vector3.new(0, 2.2, 0)
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
    
    -- 2. Создаем Tracers (Lines)
    local tracer = Drawing.new("Line")
    tracer.Visible = false
    tracer.Thickness = 1
    ESP_Cache[player].Tracer = tracer
end

-- Перехватываем рендер-цикл (RunService), чтобы обновлять новые фишки
local old_RenderStepped = RunService.RenderStepped
RunService.RenderStepped:Connect(function()
    if not Settings.esp_enabled then return end
    
    local camera = Workspace.CurrentCamera
    
    for player, esp in pairs(ESP_Cache) do
        if player.Character and player.Character:FindFirstChild("Head") then
            local char = player.Character
            local head = char:FindFirstChild("Head")
            local hum = char:FindFirstChildOfClass("Humanoid")
            
            -- Обновляем Highlight (Глубина и части тела)
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
            
            -- Обновляем Health Bar
            if esp.HealthGui and esp.HealthFill and hum then
                esp.HealthGui.Enabled = Settings.health_enabled
                local hpPerc = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                esp.HealthFill.Size = UDim2.new(hpPerc, 0, 1, 0)
                -- Меняем цвет от красного к зеленому
                esp.HealthFill.BackgroundColor3 = Color3.fromRGB(255, 0, 0):Lerp(Color3.fromRGB(0, 255, 0), hpPerc)
            end
            
            -- Обновляем Tracers (Линии)
            if esp.Tracer then
                esp.Tracer.Visible = Settings.tracers_enabled
                if Settings.tracers_enabled then
                    local headPos, onScreen = camera:WorldToViewportPoint(head.Position)
                    if onScreen then
                        esp.Tracer.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                        esp.Tracer.To = Vector2.new(headPos.X, headPos.Y)
                        esp.Tracer.Color = Settings.tracers_color
                        esp.Tracer.Thickness = Settings.tracers_thickness
                        esp.Tracer.Visible = true
                    else
                        esp.Tracer.Visible = false
                    end
                end
            end
            
        else
            -- Скрываем, если персонаж умер/вышел
            if esp.HealthGui then esp.HealthGui.Enabled = false end
            if esp.Tracer then esp.Tracer.Visible = false end
        end
    end
end)

-- Очистка памяти при выходе игрока
Players.PlayerRemoving:Connect(function(player)
    if ESP_Cache[player] then
        if ESP_Cache[player].HealthGui then ESP_Cache[player].HealthGui:Destroy() end
        if ESP_Cache[player].Tracer then ESP_Cache[player].Tracer:Remove() end
    end
end)

print("[ANON] Part 4 loaded: Advanced WH Features (Tracers, Health, Highlight Parts) Online.")
