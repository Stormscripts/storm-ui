-- Conkers Hub UI Library | by Conker'Sx

-- Serviços
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Tema
local Theme = {
    Background = Color3.fromRGB(0, 0, 0),
    Element = Color3.fromRGB(58, 58, 58),
    ElementHover = Color3.fromRGB(72, 72, 72),
    ElementPress = Color3.fromRGB(42, 42, 42),
    Section = Color3.fromRGB(28, 28, 28),
    SectionHeader = Color3.fromRGB(44, 44, 44),
    Accent = Color3.fromRGB(137, 6, 255),
    AccentDark = Color3.fromRGB(100, 4, 190),
    AccentLight = Color3.fromRGB(170, 60, 255),
    TabActive = Color3.fromRGB(137, 6, 255),
    TabInactive = Color3.fromRGB(48, 48, 48),
    ToggleOn = Color3.fromRGB(137, 6, 255),
    ToggleOff = Color3.fromRGB(123, 123, 123),
    SliderFill = Color3.fromRGB(137, 6, 255),
    SliderBg = Color3.fromRGB(100, 100, 100),
    TextPrimary = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(200, 200, 200),
    TextMuted = Color3.fromRGB(150, 150, 150),
    TextAccent = Color3.fromRGB(180, 80, 255),
    Divider = Color3.fromRGB(255, 255, 255),
    Stroke = Color3.fromRGB(75, 75, 75),
    StrokeAccent = Color3.fromRGB(137, 6, 255),
}

-- Temas
local Themes = {
    Purple = {
        Accent = Color3.fromRGB(137, 6, 255), AccentDark = Color3.fromRGB(100, 4, 190),
        AccentLight = Color3.fromRGB(170, 60, 255), TabActive = Color3.fromRGB(137, 6, 255),
        ToggleOn = Color3.fromRGB(137, 6, 255), SliderFill = Color3.fromRGB(137, 6, 255),
        StrokeAccent = Color3.fromRGB(137, 6, 255), TextAccent = Color3.fromRGB(180, 80, 255),
    },
    Dark = {
        Accent = Color3.fromRGB(90, 90, 90), AccentDark = Color3.fromRGB(60, 60, 60),
        AccentLight = Color3.fromRGB(130, 130, 130), TabActive = Color3.fromRGB(90, 90, 90),
        ToggleOn = Color3.fromRGB(90, 90, 90), SliderFill = Color3.fromRGB(90, 90, 90),
        StrokeAccent = Color3.fromRGB(80, 80, 80), TextAccent = Color3.fromRGB(160, 160, 160),
    },
    Green = {
        Accent = Color3.fromRGB(40, 180, 70), AccentDark = Color3.fromRGB(28, 130, 50),
        AccentLight = Color3.fromRGB(80, 220, 110), TabActive = Color3.fromRGB(40, 180, 70),
        ToggleOn = Color3.fromRGB(40, 180, 70), SliderFill = Color3.fromRGB(40, 180, 70),
        StrokeAccent = Color3.fromRGB(40, 180, 70), TextAccent = Color3.fromRGB(90, 220, 110),
    },
    Blue = {
        Accent = Color3.fromRGB(30, 120, 255), AccentDark = Color3.fromRGB(20, 80, 200),
        AccentLight = Color3.fromRGB(80, 160, 255), TabActive = Color3.fromRGB(30, 120, 255),
        ToggleOn = Color3.fromRGB(30, 120, 255), SliderFill = Color3.fromRGB(30, 120, 255),
        StrokeAccent = Color3.fromRGB(30, 120, 255), TextAccent = Color3.fromRGB(100, 180, 255),
    },
    Red = {
        Accent = Color3.fromRGB(220, 40, 40), AccentDark = Color3.fromRGB(160, 20, 20),
        AccentLight = Color3.fromRGB(255, 80, 80), TabActive = Color3.fromRGB(220, 40, 40),
        ToggleOn = Color3.fromRGB(220, 40, 40), SliderFill = Color3.fromRGB(220, 40, 40),
        StrokeAccent = Color3.fromRGB(220, 40, 40), TextAccent = Color3.fromRGB(255, 100, 100),
    },
    Orange = {
        Accent = Color3.fromRGB(255, 130, 20), AccentDark = Color3.fromRGB(200, 90, 10),
        AccentLight = Color3.fromRGB(255, 175, 80), TabActive = Color3.fromRGB(255, 130, 20),
        ToggleOn = Color3.fromRGB(255, 130, 20), SliderFill = Color3.fromRGB(255, 130, 20),
        StrokeAccent = Color3.fromRGB(255, 130, 20), TextAccent = Color3.fromRGB(255, 180, 100),
    },
    Pink = {
        Accent = Color3.fromRGB(230, 60, 160), AccentDark = Color3.fromRGB(180, 30, 120),
        AccentLight = Color3.fromRGB(255, 110, 200), TabActive = Color3.fromRGB(230, 60, 160),
        ToggleOn = Color3.fromRGB(230, 60, 160), SliderFill = Color3.fromRGB(230, 60, 160),
        StrokeAccent = Color3.fromRGB(230, 60, 160), TextAccent = Color3.fromRGB(255, 140, 210),
    },
    Cyan = {
        Accent = Color3.fromRGB(0, 200, 220), AccentDark = Color3.fromRGB(0, 150, 170),
        AccentLight = Color3.fromRGB(60, 230, 245), TabActive = Color3.fromRGB(0, 200, 220),
        ToggleOn = Color3.fromRGB(0, 200, 220), SliderFill = Color3.fromRGB(0, 200, 220),
        StrokeAccent = Color3.fromRGB(0, 200, 220), TextAccent = Color3.fromRGB(80, 240, 255),
    },
    White = {
        Accent = Color3.fromRGB(230, 230, 230), AccentDark = Color3.fromRGB(180, 180, 180),
        AccentLight = Color3.fromRGB(255, 255, 255), TabActive = Color3.fromRGB(210, 210, 210),
        ToggleOn = Color3.fromRGB(220, 220, 220), SliderFill = Color3.fromRGB(220, 220, 220),
        StrokeAccent = Color3.fromRGB(200, 200, 200), TextAccent = Color3.fromRGB(255, 255, 255),
    },
    Gray = {
        Accent = Color3.fromRGB(160, 160, 160), AccentDark = Color3.fromRGB(110, 110, 110),
        AccentLight = Color3.fromRGB(200, 200, 200), TabActive = Color3.fromRGB(160, 160, 160),
        ToggleOn = Color3.fromRGB(160, 160, 160), SliderFill = Color3.fromRGB(160, 160, 160),
        StrokeAccent = Color3.fromRGB(150, 150, 150), TextAccent = Color3.fromRGB(210, 210, 210),
    },
}

-- Fontes originais do Storm Hub
local FontLucky = Font.new("rbxasset://fonts/families/LuckiestGuy.json")
local FontFredoka = Font.new("rbxasset://fonts/families/FredokaOne.json")
local FontZekton = Font.new("rbxasset://fonts/families/Zekton.json")
local FontDenk = Font.new("rbxasset://fonts/families/DenkOne.json")

-- Utilitários
local function Create(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do
        pcall(function() inst[k] = v end)
    end
    return inst
end

local function Tween(inst, t, props, style, dir)
    TweenService:Create(inst, TweenInfo.new(
        t or 0.2, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out
    ), props):Play()
end

local function Corner(parent, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 6)
    c.Parent = parent
    return c
end

local function Stroke(parent, color, thick)
    local s = Instance.new("UIStroke")
    s.Color = color or Theme.Stroke
    s.Thickness = thick or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
    return s
end

local function Padding(parent, top, bottom, left, right)
    local p = Instance.new("UIPadding")
    p.PaddingTop = UDim.new(0, top or 6)
    p.PaddingBottom = UDim.new(0, bottom or 6)
    p.PaddingLeft = UDim.new(0, left or 8)
    p.PaddingRight = UDim.new(0, right or 8)
    p.Parent = parent
end

local function ListLayout(parent, dir, gap, halign)
    local l = Instance.new("UIListLayout")
    l.FillDirection = dir or Enum.FillDirection.Vertical
    l.SortOrder = Enum.SortOrder.LayoutOrder
    l.Padding = UDim.new(0, gap or 4)
    l.HorizontalAlignment = halign or Enum.HorizontalAlignment.Center
    l.Parent = parent
    return l
end

-- Sistema de Drag
-- DragStart: input.Position no momento do clique (Vector3, Z=0).
-- StartPosition: frame.Position (UDim2) no momento do clique.
-- Delta: input.Position atual - DragStart.
-- Nova posição: preserva Scale do StartPosition e soma delta no Offset.
-- Usa input.Position em todos os pontos (InputBegan e InputChanged),
-- garantindo consistência total entre mouse e touch sem conversões.
local function MakeDraggable(handle, frame)
    local dragInput = nil
    local dragStart = nil
    local startPosition = nil

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
            dragStart = input.Position
            startPosition = frame.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input ~= dragInput then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPosition.X.Scale,
                startPosition.X.Offset + delta.X,
                startPosition.Y.Scale,
                startPosition.Y.Offset + delta.Y
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input == dragInput then
            dragInput = nil
        end
    end)
end

-- Fechar popup ao clicar fora
local function CloseOnOutsideClick(getOpen, popup, trigger, closeFn)
    UserInputService.InputBegan:Connect(function(input)
        if not getOpen() then return end
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
        and input.UserInputType ~= Enum.UserInputType.Touch then return end
        local mp = input.Position
        local function inside(f)
            if not f or not f.Visible then return false end
            local ap, as = f.AbsolutePosition, f.AbsoluteSize
            return mp.X >= ap.X and mp.X <= ap.X + as.X
               and mp.Y >= ap.Y and mp.Y <= ap.Y + as.Y
        end
        if not inside(popup) and not inside(trigger) then closeFn() end
    end)
end

-- Biblioteca
local ConkersHub = {}
ConkersHub.__index = ConkersHub
ConkersHub.Flags = {}
ConkersHub.Theme = Theme
ConkersHub.Themes = Themes

-- Registro de elementos temáticos para troca dinâmica em runtime.
-- Cada entry: { inst = Instance, prop = "BackgroundColor3", key = "Accent" }
local ThemeRegistry = {}

local function RegisterTheme(inst, prop, key)
    table.insert(ThemeRegistry, {inst = inst, prop = prop, key = key})
end

-- Aplica o tema atual em todos os elementos registrados.
-- Suporta dois formatos de entry:
--   { inst, prop, key }       → atribui Theme[key] na prop do inst
--   { callback = function }   → executa a função (para elementos dinâmicos)
local function ApplyThemeAll()
    for _, entry in ipairs(ThemeRegistry) do
        if entry.callback then
            pcall(entry.callback)
        elseif entry.inst and entry.inst.Parent then
            pcall(function() entry.inst[entry.prop] = Theme[entry.key] end)
        end
    end
end

-- Registra um callback de tema (para listas abertas dinamicamente)
local function RegisterThemeCallback(fn)
    table.insert(ThemeRegistry, {callback = fn})
end

-- Versão de Create que aceita registro temático.
-- props normais são aplicadas direto; themeProps é tabela { prop = "ThemeKey" }.
local function CreateThemed(class, props, themeProps)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do
        pcall(function() inst[k] = v end)
    end
    for prop, key in pairs(themeProps or {}) do
        pcall(function() inst[prop] = Theme[key] end)
        RegisterTheme(inst, prop, key)
    end
    return inst
end

-- ================================================================
-- SetThemeComp: único sistema de tema — afeta todos os elementos registrados.
-- SetTheme é alias de SetThemeComp para compatibilidade retroativa.
-- ================================================================
function ConkersHub:SetThemeComp(name)
    local p = Themes[name]
    if not p then
        warn("ConkersHub: Tema '" .. tostring(name) .. "' inválido. Use: Dark, Purple, Green, Blue, Red, Orange, Pink, Cyan, White, Gray")
        return
    end
    for k, v in pairs(p) do Theme[k] = v end
    ApplyThemeAll()
end

-- Alias de compatibilidade retroativa
function ConkersHub:SetTheme(name)
    return self:SetThemeComp(name)
end

-- RegisterThemeAll: alias de RegisterTheme (mantém compatibilidade de código existente)
local function RegisterThemeAll(inst, prop, key)
    RegisterTheme(inst, prop, key)
end

-- RegisterThemeAllCallback: alias de RegisterThemeCallback
local function RegisterThemeAllCallback(fn)
    RegisterThemeCallback(fn)
end

-- CreateWindow
function ConkersHub:CreateWindow(config)
    config = config or {}
    local hubTitle = config.Title or "Conkers Hub"
    local hubBy = config.By or "By SeuNome"
    local hubGame = config.Game or "Jogo"
    local width = config.Width or 460
    local height = config.Height or 330
    local startPos = config.Position or UDim2.new(0.5, -(width / 2), 0.5, -(height / 2))

    local sidebarW = 140
    local topbarH = 60
    local divPx = 1
    local RADIUS = 10 -- raio de UICorner usado em toda a janela

    -- ScreenGui
    local ScreenGui = Create("ScreenGui", {
        Name = "ConkersHub",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 999,
        IgnoreGuiInset = true,
    })
    if not pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end) then
        ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end

    -- Overlay para dropdowns/colorpicker (sem clipping)
    local Overlay = Create("Frame", {
        Name = "ConkersOverlay",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ZIndex = 500,
        Parent = ScreenGui,
    })

    -- [Fix 1] Janela principal
    -- ClipsDescendants = FALSE.
    -- Com ClipsDescendants = true, o clip é RETANGULAR (ignora UICorner).
    -- A solução correta: UICorner em Main + UICorner nos filhos que ocupam
    -- os cantos externos, de forma que os cantos do FILHO casem com os de Main.
    local Main = Create("Frame", {
        Name = "ConkersMain",
        Position = startPos,
        Size = UDim2.new(0, width, 0, height),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        ClipsDescendants = false,
        Parent = ScreenGui,
    })
    Corner(Main, RADIUS)
    local MainStroke = Stroke(Main, Theme.Stroke, 1)
    RegisterTheme(MainStroke, "Color", "Stroke")
    RegisterThemeAll(MainStroke, "Color", "Stroke")
    RegisterTheme(Main, "BackgroundColor3", "Background")
    RegisterThemeAll(Main, "BackgroundColor3", "Background")

    -- Sombra: referenciada para ocultar quando minimizado
    local ShadowImg = Create("ImageLabel", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 5),
        Size = UDim2.new(1, 34, 1, 34),
        BackgroundTransparency = 1,
        Image = "rbxassetid://6015897843",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.42,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49, 49, 450, 450),
        ZIndex = 0,
        Parent = Main,
    })

    -- TopBar
    -- Corner(TopBar, RADIUS): arredonda os cantos SUPERIORES (coincidem com Main).
    -- Fix-frame no fundo: preenche os cantos inferiores com preto → ficam retos,
    -- garantindo transição limpa entre TopBar e o conteúdo abaixo.
    local TopBar = Create("Frame", {
        Name = "TopBar",
        Size = UDim2.new(1, 0, 0, topbarH),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        ZIndex = 2,
        Parent = Main,
    })
    Corner(TopBar, RADIUS)
    RegisterTheme(TopBar, "BackgroundColor3", "Background")
    RegisterThemeAll(TopBar, "BackgroundColor3", "Background")

    local TopBarBottomFill = Create("Frame", {
        Position = UDim2.new(0, 0, 0.5, 0),
        Size = UDim2.new(1, 0, 0.5, 0),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        ZIndex = 2,
        Parent = TopBar,
    })
    RegisterTheme(TopBarBottomFill, "BackgroundColor3", "Background")
    RegisterThemeAll(TopBarBottomFill, "BackgroundColor3", "Background")

    local TitleLabel = Create("TextLabel", {
        Position = UDim2.new(0, 14, 0, 10),
        Size = UDim2.new(0.55, 0, 0, 28),
        BackgroundTransparency = 1,
        Text = hubTitle,
        TextColor3 = Theme.Accent,
        TextSize = 22,
        FontFace = FontLucky,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 3,
        Parent = TopBar,
    })
    RegisterTheme(TitleLabel, "TextColor3", "Accent")
    RegisterThemeAll(TitleLabel, "TextColor3", "Accent")

    local ByLabel = Create("TextLabel", {
        Position = UDim2.new(0, 16, 0, 38),
        Size = UDim2.new(0.4, 0, 0, 16),
        BackgroundTransparency = 1,
        Text = hubBy,
        TextColor3 = Theme.TextMuted,
        TextSize = 16,
        FontFace = FontFredoka,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 3,
        Parent = TopBar,
    })
    RegisterTheme(ByLabel, "TextColor3", "TextMuted")
    RegisterThemeAll(ByLabel, "TextColor3", "TextMuted")

    local GameLabel = Create("TextLabel", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -42, 0.5, 0),
        Size = UDim2.new(0.28, 0, 1, -10),
        BackgroundTransparency = 1,
        Text = hubGame,
        TextColor3 = Theme.Accent,
        TextSize = 15,
        FontFace = FontZekton,
        TextXAlignment = Enum.TextXAlignment.Right,
        TextWrapped = true,
        ZIndex = 3,
        Parent = TopBar,
    })
    RegisterTheme(GameLabel, "TextColor3", "Accent")
    RegisterThemeAll(GameLabel, "TextColor3", "Accent")

    local MinBtn = Create("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -8, 0.5, 0),
        Size = UDim2.new(0, 26, 0, 26),
        BackgroundColor3 = Theme.Element,
        BorderSizePixel = 0,
        Text = "─",
        TextColor3 = Theme.TextSecondary,
        TextSize = 13,
        Font = Enum.Font.GothamBold,
        ZIndex = 4,
        Parent = TopBar,
    })
    Corner(MinBtn, 6)
    RegisterTheme(MinBtn, "BackgroundColor3", "Element")
    RegisterTheme(MinBtn, "TextColor3", "TextSecondary")
    RegisterThemeAll(MinBtn, "BackgroundColor3", "Element")
    RegisterThemeAll(MinBtn, "TextColor3", "TextSecondary")
    MinBtn.MouseEnter:Connect(function()
        Tween(MinBtn, 0.15, {BackgroundColor3 = Theme.Accent, TextColor3 = Theme.TextPrimary})
    end)
    MinBtn.MouseLeave:Connect(function()
        Tween(MinBtn, 0.15, {BackgroundColor3 = Theme.Element, TextColor3 = Theme.TextSecondary})
    end)

    -- Divisor horizontal
    local TopDivider = Create("Frame", {
        Position = UDim2.new(0, 0, 0, topbarH),
        Size = UDim2.new(1, 0, 0, divPx),
        BackgroundColor3 = Theme.Divider,
        BorderSizePixel = 0,
        ZIndex = 2,
        Parent = Main,
    })

    -- Body
    local Body = Create("Frame", {
        Name = "Body",
        Position = UDim2.new(0, 0, 0, topbarH + divPx),
        Size = UDim2.new(1, 0, 1, -(topbarH + divPx)),
        BackgroundTransparency = 1,
        ClipsDescendants = false,
        ZIndex = 2,
        Parent = Main,
    })

    -- Sidebar
    -- Corner(Sidebar, RADIUS): cantos superiores do Sidebar são INTERNOS à janela
    -- → mostram o fundo preto de Main → invisíveis.
    -- Canto inferior-esquerdo coincide com o canto inferior-esquerdo de Main
    -- → game world aparece → visualmente arredondado ✓
    local Sidebar = Create("ScrollingFrame", {
        Name = "Sidebar",
        Size = UDim2.new(0, sidebarW, 1, 0),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        ScrollBarThickness = 0,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ZIndex = 3,
        Parent = Body,
    })
    Corner(Sidebar, RADIUS)
    RegisterTheme(Sidebar, "BackgroundColor3", "Background")
    RegisterThemeAll(Sidebar, "BackgroundColor3", "Background")

    local SLy = ListLayout(Sidebar, Enum.FillDirection.Vertical, 5)
    SLy.HorizontalAlignment = Enum.HorizontalAlignment.Center
    Padding(Sidebar, 7, 7, 7, 7)
    SLy:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Sidebar.CanvasSize = UDim2.new(0, 0, 0, SLy.AbsoluteContentSize.Y + 14)
    end)

    -- Divisor vertical
    local SideDiv = Create("Frame", {
        Position = UDim2.new(0, sidebarW, 0, 0),
        Size = UDim2.new(0, divPx, 1, 0),
        BackgroundColor3 = Theme.Divider,
        BorderSizePixel = 0,
        ZIndex = 2,
        Parent = Body,
    })
    RegisterTheme(SideDiv, "BackgroundColor3", "Divider")
    RegisterThemeAll(SideDiv, "BackgroundColor3", "Divider")

    -- ContentArea
    local ContentArea = Create("Frame", {
        Name = "ContentArea",
        Position = UDim2.new(0, sidebarW + divPx, 0, 0),
        Size = UDim2.new(1, -(sidebarW + divPx), 1, 0),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        ZIndex = 2,
        Parent = Body,
    })
    Corner(ContentArea, RADIUS)
    RegisterTheme(ContentArea, "BackgroundColor3", "Background")
    RegisterThemeAll(ContentArea, "BackgroundColor3", "Background")

    -- Central Overlay: usado por Dropdown, MultiDropdown, ColorPicker.
    -- Frame fill do Main → tudo posicionado relativo à janela, sem usar AbsolutePosition global.
    -- ZIndex 490 → abaixo do DialogOverlay (80→) mas acima de todo conteúdo (3).
    local CentralOverlay = Create("Frame", {
        Name = "CentralOverlay",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ZIndex = 490,
        Visible = false,
        Parent = Main,
    })
    -- Fecha o CentralOverlay quando clica no fundo (fora do panel ativo)
    -- centralDragActive: sinaliza que um drag interno está em curso (não fechar)
    local centralCloseFn = nil
    local centralDragActive = false
    Create("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1, Text = "",
        ZIndex = 491, Parent = CentralOverlay,
    }).MouseButton1Click:Connect(function()
        if centralDragActive then return end
        if centralCloseFn then centralCloseFn() end
    end)

    -- Dialog overlay
    -- Corner coincide com Main → bordas arredondadas quando semi-opaco ✓
    local DialogOverlay = Create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 1,
        ZIndex = 80,
        Visible = false,
        Parent = Main,
    })
    Corner(DialogOverlay, RADIUS)

    local DialogBox = Create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.65, 0),
        Size = UDim2.new(1, -40, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Color3.fromRGB(32, 32, 32),
        BorderSizePixel = 0,
        ZIndex = 81,
        Parent = DialogOverlay,
    })
    Corner(DialogBox, 8)
    local DialogBoxStroke = Stroke(DialogBox, Theme.StrokeAccent, 1.5)
    RegisterTheme(DialogBoxStroke, "Color", "StrokeAccent")
    RegisterThemeAll(DialogBoxStroke, "Color", "StrokeAccent")

    local DInner = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        ZIndex = 81,
        Parent = DialogBox,
    })
    local DLy = ListLayout(DInner, Enum.FillDirection.Vertical, 10)
    DLy.HorizontalAlignment = Enum.HorizontalAlignment.Center
    Padding(DInner, 16, 16, 14, 14)

    local DWarnLbl = Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 26),
        BackgroundTransparency = 1,
        Text = "⚠",
        TextColor3 = Theme.Accent,
        TextSize = 24,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex = 82,
        Parent = DInner,
    })
    RegisterTheme(DWarnLbl, "TextColor3", "Accent")
    RegisterThemeAll(DWarnLbl, "TextColor3", "Accent")

    local DialogText = Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        TextColor3 = Theme.TextSecondary,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex = 82,
        Parent = DInner,
    })

    Create("Frame", {
        Size = UDim2.new(1, 0, 0, 1),
        BackgroundColor3 = Theme.Stroke,
        BorderSizePixel = 0,
        ZIndex = 82,
        Parent = DInner,
    })

    local DBtnRow = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        ZIndex = 81,
        Parent = DInner,
    })
    local DBLy = ListLayout(DBtnRow, Enum.FillDirection.Horizontal, 8)
    DBLy.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local DialogNoBtn = Create("TextButton", {
        Size = UDim2.new(0.5, -4, 1, 0),
        BackgroundColor3 = Theme.Element,
        BorderSizePixel = 0,
        Text = "Não",
        TextColor3 = Theme.TextSecondary,
        TextSize = 12,
        Font = Enum.Font.GothamSemibold,
        ZIndex = 82,
        Parent = DBtnRow,
    })
    Corner(DialogNoBtn, 6)
    local DialogNoBtnStroke = Stroke(DialogNoBtn, Theme.Stroke, 1)
    RegisterTheme(DialogNoBtnStroke, "Color", "Stroke")
    RegisterThemeAll(DialogNoBtnStroke, "Color", "Stroke")
    RegisterTheme(DialogNoBtn, "BackgroundColor3", "Element")
    RegisterThemeAll(DialogNoBtn, "BackgroundColor3", "Element")

    local DialogYesBtn = Create("TextButton", {
        Size = UDim2.new(0.5, -4, 1, 0),
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
        Text = "Sim",
        TextColor3 = Theme.TextPrimary,
        TextSize = 12,
        Font = Enum.Font.GothamSemibold,
        ZIndex = 82,
        Parent = DBtnRow,
    })
    Corner(DialogYesBtn, 6)
    local DialogYesBtnStroke = Stroke(DialogYesBtn, Theme.StrokeAccent, 1)
    RegisterTheme(DialogYesBtnStroke, "Color", "StrokeAccent")
    RegisterThemeAll(DialogYesBtnStroke, "Color", "StrokeAccent")
    RegisterTheme(DialogYesBtn, "BackgroundColor3", "Accent")
    RegisterThemeAll(DialogYesBtn, "BackgroundColor3", "Accent")

    local dialogCb = nil

    local function CloseDialog()
        Tween(DialogOverlay, 0.22, {BackgroundTransparency = 1})
        Tween(DialogBox, 0.22, {Position = UDim2.new(0.5, 0, 0.65, 0)},
            Enum.EasingStyle.Quart, Enum.EasingDirection.In)
        task.delay(0.22, function() DialogOverlay.Visible = false end)
    end

    local function OpenDialog(cfg)
        DialogText.Text = cfg.GuiText or "Tem certeza?"
        DialogNoBtn.Text = cfg.NoBtn or "Não"
        DialogYesBtn.Text = cfg.YesBtn or "Sim"
        dialogCb = cfg.Callback or nil
        DialogBox.Position = UDim2.new(0.5, 0, 0.65, 0)
        DialogOverlay.BackgroundTransparency = 1
        DialogOverlay.Visible = true
        Tween(DialogOverlay, 0.25, {BackgroundTransparency = 0.5})
        Tween(DialogBox, 0.28, {Position = UDim2.new(0.5, 0, 0.5, 0)},
            Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    end

    DialogNoBtn.MouseButton1Click:Connect(CloseDialog)
    DialogNoBtn.MouseEnter:Connect(function()
        Tween(DialogNoBtn, 0.15, {BackgroundColor3 = Theme.ElementHover})
    end)
    DialogNoBtn.MouseLeave:Connect(function()
        Tween(DialogNoBtn, 0.15, {BackgroundColor3 = Theme.Element})
    end)
    DialogYesBtn.MouseButton1Click:Connect(function()
        CloseDialog()
        if dialogCb then dialogCb() end
    end)
    DialogYesBtn.MouseEnter:Connect(function()
        Tween(DialogYesBtn, 0.15, {BackgroundColor3 = Theme.AccentLight})
    end)
    DialogYesBtn.MouseLeave:Connect(function()
        Tween(DialogYesBtn, 0.15, {BackgroundColor3 = Theme.Accent})
        -- re-sync stroke
        pcall(function() DialogYesBtnStroke.Color = Theme.StrokeAccent end)
    end)
    Create("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        ZIndex = 80,
        Parent = DialogOverlay,
    }).MouseButton1Click:Connect(function()
        local mp = UserInputService:GetMouseLocation()
        local ap, as = DialogBox.AbsolutePosition, DialogBox.AbsoluteSize
        if not (mp.X >= ap.X and mp.X <= ap.X + as.X
            and mp.Y >= ap.Y and mp.Y <= ap.Y + as.Y) then
            CloseDialog()
        end
    end)

    -- Minimizar
    -- Estratégia: ClipsDescendants corta TUDO dentro do Main de uma vez.
    -- Não há visibilidade individual por elemento — tudo some e volta junto.
    local minimized = false
    local fullSize = UDim2.new(0, width, 0, height)
    local miniSize = UDim2.new(0, width, 0, topbarH)

    MakeDraggable(TopBar, Main)

    MinBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            Main.ClipsDescendants = true
            ShadowImg.Visible = false        -- remove sombra quadrada nos cantos
            Tween(Main, 0.28, {Size = miniSize}, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
            MinBtn.Text = "+"
            TopBarBottomFill.Visible = false
        else
            Tween(Main, 0.28, {Size = fullSize}, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
            MinBtn.Text = "─"
            TopBarBottomFill.Visible = true
            task.delay(0.28, function()
                if not minimized then
                    Main.ClipsDescendants = false
                    ShadowImg.Visible = true  -- restaura sombra após expansão completa
                end
            end)
        end
    end)

    -- Fábrica de componentes
    local function MakeComponents(container)
        local obj = {}
        local order = 0
        local function N() order = order + 1; return order end

        local function TextArea(parent, name, desc, rightPad)
            local area = Create("Frame", {
                Position = UDim2.new(0, 8, 0, 0),
                Size = UDim2.new(1, -(rightPad or 50), 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                ZIndex = 4,
                Parent = parent,
            })
            local ly = ListLayout(area, Enum.FillDirection.Vertical, 2)
            ly.HorizontalAlignment = Enum.HorizontalAlignment.Left
            Padding(area, 6, 6, 0, 0)
            Create("TextLabel", {
                Size = UDim2.new(1, 0, 0, 14),
                BackgroundTransparency = 1,
                Text = name,
                TextColor3 = Theme.TextPrimary,
                TextSize = 13,
                Font = Enum.Font.GothamSemibold,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 4,
                Parent = area,
            })
            if desc ~= "" then
                Create("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1,
                    Text = desc,
                    TextColor3 = Theme.TextMuted,
                    TextSize = 11,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextWrapped = true,
                    ZIndex = 4,
                    Parent = area,
                })
            end
        end

        -- Button
        function obj:AddButton(cfg)
            cfg = cfg or {}
            local name = cfg.Name or "Button"
            local desc = cfg.Desc or cfg.Description or ""
            local callback = cfg.Callback or function() end

            local Btn = Create("TextButton", {
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = Theme.Element,
                BorderSizePixel = 0,
                Text = "",
                LayoutOrder = N(),
                ZIndex = 3,
                Parent = container,
            })
            Corner(Btn, 6)
            Create("Frame", {Size = UDim2.new(1, 0, 0, 28), BackgroundTransparency = 1, ZIndex = 1, Parent = Btn})

            local IcoBox = Create("Frame", {
                AnchorPoint = Vector2.new(1, 0),
                Position = UDim2.new(1, -6, 0, 3),
                Size = UDim2.new(0, 22, 0, 22),
                BackgroundColor3 = Theme.Accent,
                BorderSizePixel = 0,
                ZIndex = 4,
                Parent = Btn,
            })
            Corner(IcoBox, 5)
            RegisterTheme(IcoBox, "BackgroundColor3", "Accent")
            RegisterThemeAll(IcoBox, "BackgroundColor3", "Accent")
            Create("TextLabel", {
                Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
                Text = "👆", TextColor3 = Theme.TextPrimary, TextSize = 11,
                Font = Enum.Font.GothamBold, ZIndex = 5, Parent = IcoBox,
            })
            TextArea(Btn, name, desc, 38)

            Btn.MouseEnter:Connect(function() Tween(Btn, 0.15, {BackgroundColor3 = Theme.ElementHover}) end)
            Btn.MouseLeave:Connect(function() Tween(Btn, 0.15, {BackgroundColor3 = Theme.Element}) end)
            Btn.MouseButton1Down:Connect(function() Tween(Btn, 0.08, {BackgroundColor3 = Theme.ElementPress}) end)
            Btn.MouseButton1Up:Connect(function() Tween(Btn, 0.1, {BackgroundColor3 = Theme.ElementHover}) end)
            Btn.MouseButton1Click:Connect(callback)
        end

        -- Toggle
        function obj:AddToggle(cfg)
            cfg = cfg or {}
            local name = cfg.Name or "Toggle"
            local default = cfg.Default or false
            local flag = cfg.Flag
            local callback = cfg.Callback or function() end
            local desc = cfg.Description or ""

            local state = default
            if flag then ConkersHub.Flags[flag] = state end

            local Row = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = state and Color3.fromRGB(30, 10, 50) or Theme.Element,
                BorderSizePixel = 0,
                LayoutOrder = N(),
                ZIndex = 3,
                Parent = container,
            })
            Corner(Row, 6)
            -- Row OFF registrado; quando ON usa cor fixa, mas ao trocar tema e toggle OFF ele atualiza
            RegisterTheme(Row, "BackgroundColor3", "Element")
            RegisterThemeAll(Row, "BackgroundColor3", "Element")
            Create("Frame", {Size = UDim2.new(1, 0, 0, 28), BackgroundTransparency = 1, ZIndex = 1, Parent = Row})

            local SwitchBg = Create("Frame", {
                AnchorPoint = Vector2.new(1, 0),
                Position = UDim2.new(1, -8, 0, 4),
                Size = UDim2.new(0, 40, 0, 20),
                BackgroundColor3 = state and Theme.ToggleOn or Theme.ToggleOff,
                BorderSizePixel = 0,
                ZIndex = 4,
                Parent = Row,
            })
            Corner(SwitchBg, 10)
            RegisterTheme(SwitchBg, "BackgroundColor3", "ToggleOff")
            RegisterThemeAll(SwitchBg, "BackgroundColor3", "ToggleOff")

            local Knob = Create("Frame", {
                AnchorPoint = Vector2.new(0, 0.5),
                Position = state and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0),
                Size = UDim2.new(0, 16, 0, 16),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BorderSizePixel = 0,
                ZIndex = 5,
                Parent = SwitchBg,
            })
            Corner(Knob, 8)
            TextArea(Row, name, desc, 58)

            local function DoToggle()
                state = not state
                if flag then ConkersHub.Flags[flag] = state end
                Tween(SwitchBg, 0.2, {BackgroundColor3 = state and Theme.ToggleOn or Theme.ToggleOff})
                Tween(Knob, 0.2, {Position = state and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)})
                if state then
                    Tween(Row, 0.2, {BackgroundColor3 = Color3.fromRGB(30, 10, 50)})
                else
                    Tween(Row, 0.2, {BackgroundColor3 = Theme.Element})
                end
                callback(state)
            end

            local CBtn = Create("TextButton", {
                Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", ZIndex = 6, Parent = Row,
            })
            CBtn.MouseButton1Click:Connect(DoToggle)
            CBtn.MouseEnter:Connect(function()
                if not state then Tween(Row, 0.15, {BackgroundColor3 = Theme.ElementHover}) end
            end)
            CBtn.MouseLeave:Connect(function()
                if not state then Tween(Row, 0.15, {BackgroundColor3 = Theme.Element}) end
            end)

            local T = {}
            function T:Set(v) if v ~= state then DoToggle() end end
            function T:Get() return state end
            return T
        end

        -- Slider
        function obj:AddSlider(cfg)
            cfg = cfg or {}
            local name = cfg.Name or "Slider"
            local min = cfg.Min or 0
            local max = cfg.Max or 100
            local default = cfg.Default or min
            local increment = cfg.Increment or 1
            local suffix = cfg.Suffix or ""
            local flag = cfg.Flag
            local callback = cfg.Callback or function() end
            local desc = cfg.Description or ""
            local hasDesc = desc ~= ""

            local value = math.clamp(default, min, max)
            if flag then ConkersHub.Flags[flag] = value end

            local Container = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = Theme.Element, BorderSizePixel = 0,
                LayoutOrder = N(), ZIndex = 3, Parent = container,
            })
            Corner(Container, 6)
            local CLy = ListLayout(Container, Enum.FillDirection.Vertical, 0)
            CLy.HorizontalAlignment = Enum.HorizontalAlignment.Center

            local TopRow = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1, ZIndex = 3, Parent = Container,
            })
            Create("TextLabel", {
                Position = UDim2.new(0, 8, 0.5, -7), Size = UDim2.new(0.58, 0, 0, 14),
                BackgroundTransparency = 1, Text = name, TextColor3 = Theme.TextPrimary,
                TextSize = 13, Font = Enum.Font.GothamSemibold,
                TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 4, Parent = TopRow,
            })
            -- ValBox: tamanho automático limitado a 45% da largura do topRow
            -- O label usa TextTruncate.AtEnd como fallback de segurança
            local ValBox = Create("Frame", {
                AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -8, 0.5, 0),
                Size = UDim2.new(0, 52, 0, 15),
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundColor3 = Color3.fromRGB(78, 78, 78),
                BorderSizePixel = 0, ZIndex = 4, Parent = TopRow,
            })
            Corner(ValBox, 4)
            local ValLabel = Create("TextLabel", {
                Size = UDim2.new(0, 0, 1, 0),
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundTransparency = 1,
                Text = tostring(value) .. suffix, TextColor3 = Theme.TextPrimary,
                TextSize = 11, Font = Enum.Font.GothamBold,
                TextTruncate = Enum.TextTruncate.AtEnd,
                ZIndex = 5, Parent = ValBox,
            })
            Padding(ValLabel, 0, 0, 4, 4)
            -- Garante que ValBox nunca ultrapasse 45% do TopRow
            ValBox:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
                local maxW = math.floor(TopRow.AbsoluteSize.X * 0.45)
                if ValBox.AbsoluteSize.X > maxW then
                    ValBox.AutomaticSize = Enum.AutomaticSize.None
                    ValBox.Size = UDim2.new(0, maxW, 0, 15)
                    ValLabel.Size = UDim2.new(1, 0, 1, 0)
                    ValLabel.AutomaticSize = Enum.AutomaticSize.None
                end
            end)

            if hasDesc then
                local DR = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1, ZIndex = 3, Parent = Container,
                })
                Padding(DR, 0, 3, 8, 8)
                Create("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1, Text = desc, TextColor3 = Theme.TextMuted,
                    TextSize = 11, Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true,
                    ZIndex = 4, Parent = DR,
                })
            end

            local TrackRow = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 14), BackgroundTransparency = 1, ZIndex = 3, Parent = Container,
            })
            local Track = Create("Frame", {
                AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0),
                Size = UDim2.new(1, -16, 0, 6), BackgroundColor3 = Theme.SliderBg,
                BorderSizePixel = 0, ZIndex = 4, Parent = TrackRow,
            })
            Corner(Track, 3)

            local pct0 = (value-min) / (max-min)
            local Fill = Create("Frame", {
                Size = UDim2.new(pct0, 0, 1, 0), BackgroundColor3 = Theme.SliderFill,
                BorderSizePixel = 0, ZIndex = 5, Parent = Track,
            })
            Corner(Fill, 3)
            RegisterTheme(Fill, "BackgroundColor3", "SliderFill")
            RegisterThemeAll(Fill, "BackgroundColor3", "SliderFill")

            local TKnob = Create("Frame", {
                AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(pct0, 0, 0.5, 0),
                Size = UDim2.new(0, 12, 0, 12), BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BorderSizePixel = 0, ZIndex = 6, Parent = Track,
            })
            Corner(TKnob, 6)
            local TKnobStroke = Stroke(TKnob, Theme.Accent, 1.5)
            RegisterTheme(TKnobStroke, "Color", "Accent")
            RegisterThemeAll(TKnobStroke, "Color", "Accent")

            local sliding = false
            local function Update(ix)
                local ts = Track.AbsoluteSize.X
                if ts == 0 then return end
                local rel = math.clamp((ix-Track.AbsolutePosition.X) / ts, 0, 1)
                value = math.clamp(math.floor((min + (max-min) * rel) / increment + 0.5) * increment, min, max)
                local pct = (value-min) / (max-min)
                if flag then ConkersHub.Flags[flag] = value end
                Fill.Size = UDim2.new(pct, 0, 1, 0); TKnob.Position = UDim2.new(pct, 0, 0.5, 0)
                ValLabel.Text = tostring(value).. suffix; callback(value)
            end
            Track.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    sliding = true; Update(i.Position.X)
                end
            end)
            UserInputService.InputChanged:Connect(function(i)
                if not sliding then return end
                if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
                    Update(i.Position.X)
                end
            end)
            UserInputService.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    sliding = false
                end
            end)

            local S = {}
            function S:Set(v)
                value = math.clamp(v, min, max)
                local pct = (value-min) / (max-min)
                if flag then ConkersHub.Flags[flag] = value end
                Fill.Size = UDim2.new(pct, 0, 1, 0); TKnob.Position = UDim2.new(pct, 0, 0.5, 0)
                ValLabel.Text = tostring(value).. suffix; callback(value)
            end
            function S:Get() return value end
            return S
        end

        -- Dropdown
        function obj:AddDropdown(cfg)
            cfg = cfg or {}
            local name = cfg.Name or "Dropdown"
            local options = cfg.Options or {}
            local default = cfg.Default or options[1] or "None"
            local flag = cfg.Flag
            local callback = cfg.Callback or function() end
            local desc = cfg.Description or ""

            local selected = default
            if flag then ConkersHub.Flags[flag] = selected end

            local Container = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = Theme.Element, BorderSizePixel = 0,
                LayoutOrder = N(), ZIndex = 3, Parent = container,
            })
            Corner(Container, 6)
            RegisterTheme(Container, "BackgroundColor3", "Element")
            RegisterThemeAll(Container, "BackgroundColor3", "Element")
            local DDContainerStroke = Stroke(Container, Theme.StrokeAccent, 1)
            RegisterTheme(DDContainerStroke, "Color", "StrokeAccent")
            RegisterThemeAll(DDContainerStroke, "Color", "StrokeAccent")
            Create("Frame", {Size = UDim2.new(1, 0, 0, 28), BackgroundTransparency = 1, ZIndex = 1, Parent = Container})

            local ArrowLbl = Create("TextLabel", {
                AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -6, 0, 6),
                Size = UDim2.new(0, 16, 0, 16), BackgroundTransparency = 1,
                Text = "v", TextColor3 = Theme.TextMuted, TextSize = 14,
                Font = Enum.Font.GothamBold, ZIndex = 4, Parent = Container,
            })
            RegisterTheme(ArrowLbl, "TextColor3", "TextMuted")
            RegisterThemeAll(ArrowLbl, "TextColor3", "TextMuted")
            local SelLabel = Create("TextLabel", {
                AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -24, 0, 7),
                Size = UDim2.new(0.42, 0, 0, 14), BackgroundTransparency = 1,
                Text = tostring(selected), TextColor3 = Theme.TextAccent, TextSize = 11,
                Font = Enum.Font.GothamSemibold, TextXAlignment = Enum.TextXAlignment.Right,
                TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 4, Parent = Container,
            })
            RegisterTheme(SelLabel, "TextColor3", "TextAccent")
            RegisterThemeAll(SelLabel, "TextColor3", "TextAccent")
            TextArea(Container, name, desc, 76)

            local List = Create("ScrollingFrame", {
                Size = UDim2.new(0, 0, 0, 0), BackgroundColor3 = Color3.fromRGB(28, 28, 28),
                BorderSizePixel = 0, ZIndex = 501, ScrollBarThickness = 2,
                ScrollBarImageColor3 = Theme.Accent, CanvasSize = UDim2.new(0, 0, 0, 0),
                ClipsDescendants = true, Visible = false, Parent = Overlay,
            })
            RegisterTheme(List, "ScrollBarImageColor3", "Accent")
            RegisterThemeAll(List, "ScrollBarImageColor3", "Accent")
            Corner(List, 6)
            local ListStroke = Stroke(List, Theme.StrokeAccent, 1)
            RegisterTheme(ListStroke, "Color", "StrokeAccent")
            RegisterThemeAll(ListStroke, "Color", "StrokeAccent")
            local LI = ListLayout(List, Enum.FillDirection.Vertical, 2)
            Padding(List, 4, 4, 4, 4)
            LI:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                List.CanvasSize = UDim2.new(0, 0, 0, LI.AbsoluteContentSize.Y + 8)
            end)

            local listOpen = false
            local function CloseList()
                listOpen = false
                centralCloseFn = nil
                CentralOverlay.Visible = false
                Tween(List, 0.2, {Size = UDim2.new(0, List.AbsoluteSize.X, 0, 0)},
                    Enum.EasingStyle.Quart, Enum.EasingDirection.In)
                Tween(ArrowLbl, 0.2, {Rotation = 0})
                task.delay(0.21, function() if not listOpen then List.Visible = false end end)
            end
            local function BuildList()
                -- Destrói TextButton e Frame (opções antigas)
                for _, c in ipairs(List:GetChildren()) do
                    if c:IsA("TextButton") or c:IsA("Frame") then c:Destroy() end
                end
                for _, opt in ipairs(options) do
                    local isA = tostring(opt) == tostring(selected)
                    local Opt = Create("TextButton", {
                        Size = UDim2.new(1, 0, 0, 26),
                        BackgroundColor3 = isA and Theme.AccentDark or Color3.fromRGB(50, 50, 50),
                        BorderSizePixel = 0, Text = tostring(opt),
                        TextColor3 = isA and Theme.TextPrimary or Theme.TextSecondary,
                        TextSize = 12, Font = Enum.Font.Gotham, ZIndex = 502, Parent = List,
                    })
                    Corner(Opt, 5)
                    if isA then Stroke(Opt, Theme.Accent, 1) end
                    Opt.MouseEnter:Connect(function() if not isA then Tween(Opt, 0.1, {BackgroundColor3 = Color3.fromRGB(68, 68, 68)}) end end)
                    Opt.MouseLeave:Connect(function() if not isA then Tween(Opt, 0.1, {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}) end end)
                    Opt.MouseButton1Click:Connect(function()
                        selected = opt; if flag then ConkersHub.Flags[flag] = selected end
                        SelLabel.Text = tostring(selected); BuildList(); CloseList(); callback(selected)
                    end)
                end
            end
            BuildList()
            -- Callback de tema: reconstrói lista se estiver aberta ao trocar tema
            RegisterThemeCallback(function()
                if listOpen then BuildList() end
            end)
            RegisterThemeAllCallback(function()
                if listOpen then BuildList() end
            end)
            local function OpenList()
                listOpen = true
                local listH = math.min(#options * 30 + 8, 180)
                local ap    = Container.AbsolutePosition
                local as    = Container.AbsoluteSize
                local vp    = workspace.CurrentCamera.ViewportSize
                local listW = as.X
                -- Posição X: alinhado à esquerda do componente, clampado à tela
                local posX = math.clamp(ap.X, 4, vp.X - listW - 4)
                -- Posição Y: abaixo do componente; se não couber, abre acima
                local posYBelow = ap.Y + as.Y + 4
                local posYAbove = ap.Y - listH - 4
                local posY = (posYBelow + listH <= vp.Y) and posYBelow or posYAbove
                List.Parent = Overlay
                List.Position = UDim2.new(0, posX, 0, posY)
                List.Size = UDim2.new(0, listW, 0, 0)
                List.Visible = true
                CentralOverlay.Visible = true
                centralCloseFn = CloseList
                Tween(List, 0.22, {Size = UDim2.new(0, listW, 0, listH)},
                    Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
                Tween(ArrowLbl, 0.2, {Rotation = 180})
            end
            -- CentralOverlay usado só como backdrop invisível para fechar ao clicar fora
            local CBtn = Create("TextButton", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", ZIndex = 5, Parent = Container})
            CBtn.MouseButton1Click:Connect(function() if listOpen then CloseList() else OpenList() end end)
            CBtn.MouseEnter:Connect(function() Tween(Container, 0.15, {BackgroundColor3 = Theme.ElementHover}) end)
            CBtn.MouseLeave:Connect(function() Tween(Container, 0.15, {BackgroundColor3 = Theme.Element}) end)
            local D = {}
            function D:Set(v) selected = v; if flag then ConkersHub.Flags[flag] = v end; SelLabel.Text = tostring(v); BuildList(); callback(v) end
            function D:SetOptions(o) options = o; BuildList() end
            function D:Get() return selected end
            return D
        end

        -- MultiDropdown
        function obj:AddMultiDropdown(cfg)
            cfg = cfg or {}
            local name = cfg.Name or "Multi Select"
            local options = cfg.Options or {}
            local defaults = cfg.Default or {}
            local flag = cfg.Flag
            local callback = cfg.Callback or function() end
            local desc = cfg.Description or ""

            local selected = {}
            for _, v in ipairs(defaults) do selected[v] = true end
            if flag then ConkersHub.Flags[flag] = selected end

            local function Disp()
                local n = 0
                for _, v in pairs(selected) do
                    if v == true then n = n + 1 end
                end
                return n == 0 and "Nenhum" or (n .. " sel.")
            end

            local Container = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = Theme.Element, BorderSizePixel = 0,
                LayoutOrder = N(), ZIndex = 3, Parent = container,
            })
            Corner(Container, 6)
            RegisterTheme(Container, "BackgroundColor3", "Element")
            RegisterThemeAll(Container, "BackgroundColor3", "Element")
            local MultiContainerStroke = Stroke(Container, Theme.StrokeAccent, 1)
            RegisterTheme(MultiContainerStroke, "Color", "StrokeAccent")
            RegisterThemeAll(MultiContainerStroke, "Color", "StrokeAccent")
            Create("Frame", {Size = UDim2.new(1, 0, 0, 28), BackgroundTransparency = 1, ZIndex = 1, Parent = Container})

            local ArrowLbl = Create("TextLabel", {
                AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -6, 0, 6),
                Size = UDim2.new(0, 16, 0, 16), BackgroundTransparency = 1,
                Text = "v", TextColor3 = Theme.TextMuted, TextSize = 14,
                Font = Enum.Font.GothamBold, ZIndex = 4, Parent = Container,
            })
            RegisterTheme(ArrowLbl, "TextColor3", "TextMuted")
            RegisterThemeAll(ArrowLbl, "TextColor3", "TextMuted")
            local SelLabel = Create("TextLabel", {
                AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -24, 0, 7),
                Size = UDim2.new(0.4, 0, 0, 14), BackgroundTransparency = 1,
                Text = Disp(), TextColor3 = Theme.TextAccent, TextSize = 11,
                Font = Enum.Font.GothamSemibold, TextXAlignment = Enum.TextXAlignment.Right,
                ZIndex = 4, Parent = Container,
            })
            RegisterTheme(SelLabel, "TextColor3", "TextAccent")
            RegisterThemeAll(SelLabel, "TextColor3", "TextAccent")
            TextArea(Container, name, desc, 76)

            local List = Create("ScrollingFrame", {
                Size = UDim2.new(0, 0, 0, 0), BackgroundColor3 = Color3.fromRGB(28, 28, 28),
                BorderSizePixel = 0, ZIndex = 501, ScrollBarThickness = 2,
                ScrollBarImageColor3 = Theme.Accent, CanvasSize = UDim2.new(0, 0, 0, 0),
                ClipsDescendants = true, Visible = false, Parent = Overlay,
            })
            RegisterTheme(List, "ScrollBarImageColor3", "Accent")
            RegisterThemeAll(List, "ScrollBarImageColor3", "Accent")
            Corner(List, 6)
            local MultiListStroke = Stroke(List, Theme.StrokeAccent, 1)
            RegisterTheme(MultiListStroke, "Color", "StrokeAccent")
            RegisterThemeAll(MultiListStroke, "Color", "StrokeAccent")
            local LL = ListLayout(List, Enum.FillDirection.Vertical, 2)
            Padding(List, 4, 4, 4, 4)
            LL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                List.CanvasSize = UDim2.new(0, 0, 0, LL.AbsoluteContentSize.Y + 8)
            end)

            local listOpen = false
            local function CloseMulti()
                listOpen = false
                centralCloseFn = nil
                CentralOverlay.Visible = false   -- FIX: desativa overlay ou UI fica morta
                Tween(List, 0.2, {Size = UDim2.new(0, List.AbsoluteSize.X, 0, 0)},
                    Enum.EasingStyle.Quart, Enum.EasingDirection.In)
                Tween(ArrowLbl, 0.2, {Rotation = 0})
                task.delay(0.21, function() if not listOpen then List.Visible = false end end)
            end
            local function BuildMulti()
                for _, c in ipairs(List:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
                for _, opt in ipairs(options) do
                    local isSel = selected[opt] == true
                    local Row = Create("Frame", {
                        Size = UDim2.new(1, 0, 0, 26),
                        BackgroundColor3 = isSel and Theme.AccentDark or Color3.fromRGB(50, 50, 50),
                        BorderSizePixel = 0, ZIndex = 502, Parent = List,
                    })
                    Corner(Row, 5); if isSel then Stroke(Row, Theme.Accent, 1) end
                    local Chk = Create("Frame", {
                        AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 5, 0.5, 0),
                        Size = UDim2.new(0, 14, 0, 14),
                        BackgroundColor3 = isSel and Theme.Accent or Color3.fromRGB(80, 80, 80),
                        BorderSizePixel = 0, ZIndex = 503, Parent = Row,
                    })
                    Corner(Chk, 3)
                    if isSel then
                        Create("TextLabel", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
                            Text = "✓", TextColor3 = Color3.fromRGB(255, 255, 255),
                            TextSize = 10, Font = Enum.Font.GothamBold, ZIndex = 504, Parent = Chk})
                    end
                    Create("TextLabel", {
                        AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 24, 0.5, 0),
                        Size = UDim2.new(1, -30, 1, 0), BackgroundTransparency = 1,
                        Text = tostring(opt),
                        TextColor3 = isSel and Theme.TextPrimary or Theme.TextSecondary,
                        TextSize = 12, Font = Enum.Font.Gotham,
                        TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 503, Parent = Row,
                    })
                    Create("TextButton", {
                        Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
                        Text = "", ZIndex = 504, Parent = Row,
                    }).MouseButton1Click:Connect(function()
                        selected[opt] = not selected[opt]
                        if flag then ConkersHub.Flags[flag] = selected end
                        SelLabel.Text = Disp(); BuildMulti(); callback(selected)
                    end)
                end
            end
            BuildMulti()
            -- Callback de tema: reconstrói lista multi se estiver aberta ao trocar tema
            RegisterThemeCallback(function()
                if listOpen then BuildMulti() end
            end)
            RegisterThemeAllCallback(function()
                if listOpen then BuildMulti() end
            end)
            local function OpenMulti()
                listOpen = true
                local nOpts = type(options) == "table" and #options or 0
                local listH = math.min(nOpts * 30 + 8, 180)
                local ap    = Container.AbsolutePosition
                local as    = Container.AbsoluteSize
                local vp    = workspace.CurrentCamera.ViewportSize
                local listW = as.X
                local posX  = math.clamp(ap.X, 4, vp.X - listW - 4)
                local posYBelow = ap.Y + as.Y + 4
                local posYAbove = ap.Y - listH - 4
                local posY = (posYBelow + listH <= vp.Y) and posYBelow or posYAbove
                List.Parent = Overlay
                List.Position = UDim2.new(0, posX, 0, posY)
                List.Size = UDim2.new(0, listW, 0, 0); List.Visible = true
                CentralOverlay.Visible = true
                centralCloseFn = CloseMulti
                Tween(List, 0.22, {Size = UDim2.new(0, listW, 0, listH)},
                    Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
                Tween(ArrowLbl, 0.2, {Rotation = 180})
            end
            -- CentralOverlay backdrop já fecha ao clicar fora. Não usar CloseOnOutsideClick
            -- (criaria listener global permanente que bloqueia inputs após fechar).
            local MCBtn = Create("TextButton", {
                Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
                Text = "", ZIndex = 5, Parent = Container,
            })
            MCBtn.MouseButton1Click:Connect(function()
                if listOpen then CloseMulti() else OpenMulti() end
            end)
            MCBtn.MouseEnter:Connect(function() Tween(Container, 0.15, {BackgroundColor3 = Theme.ElementHover}) end)
            MCBtn.MouseLeave:Connect(function() Tween(Container, 0.15, {BackgroundColor3 = Theme.Element}) end)
            local M = {}
            function M:GetSelected()
                local out = {}; for k, v in pairs(selected) do if v then table.insert(out, k) end end; return out
            end
            function M:SetSelected(tbl)
                selected = {}; for _, v in ipairs(tbl) do selected[v] = true end
                if flag then ConkersHub.Flags[flag] = selected end
                SelLabel.Text = Disp(); BuildMulti()
            end
            return M
        end

        -- Keybind
        function obj:AddKeybind(cfg)
            cfg = cfg or {}
            local name = cfg.Name or "Keybind"; local default = cfg.Default or Enum.KeyCode.Unknown
            local flag = cfg.Flag; local callback = cfg.Callback or function() end
            local curKey = default; local listening = false
            if flag then ConkersHub.Flags[flag] = curKey end
            local abbr = {LeftControl = "LCtrl", RightControl = "RCtrl", LeftShift = "LShift",
                RightShift = "RShift", LeftAlt = "LAlt", RightAlt = "RAlt", Return = "Enter", BackSpace = "Backsp"}
            local function KStr(k)
                if k == Enum.KeyCode.Unknown then return "Nenhum" end
                local s = tostring(k):gsub("Enum%.KeyCode%.", ""); return abbr[s] or s
            end
            local Row = Create("Frame", {Size = UDim2.new(1, 0, 0, 28), BackgroundColor3 = Theme.Element,
                BorderSizePixel = 0, LayoutOrder = N(), ZIndex = 3, Parent = container})
            Corner(Row, 6)
            Create("TextLabel", {AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 8, 0.5, 0),
                Size = UDim2.new(1, -90, 1, 0), BackgroundTransparency = 1, Text = name,
                TextColor3 = Theme.TextPrimary, TextSize = 13, Font = Enum.Font.GothamSemibold,
                TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 4, Parent = Row})
            local Badge = Create("Frame", {AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -6, 0.5, 0),
                Size = UDim2.new(0, 72, 0, 20), BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                BorderSizePixel = 0, ZIndex = 4, Parent = Row})
            Corner(Badge, 5)
            local BadgeStroke = Stroke(Badge, Theme.StrokeAccent, 1)
            RegisterTheme(BadgeStroke, "Color", "StrokeAccent")
            RegisterThemeAll(BadgeStroke, "Color", "StrokeAccent")
            local KeyLbl = Create("TextLabel", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
                Text = KStr(curKey), TextColor3 = Theme.TextAccent, TextSize = 11,
                Font = Enum.Font.GothamSemibold, ZIndex = 5, Parent = Badge})
            RegisterTheme(KeyLbl, "TextColor3", "TextAccent")
            RegisterThemeAll(KeyLbl, "TextColor3", "TextAccent")
            local function SetL(v)
                listening = v
                if listening then KeyLbl.Text = "..."; Tween(Badge, 0.2, {BackgroundColor3 = Theme.AccentDark}); Tween(KeyLbl, 0.2, {TextColor3 = Theme.TextPrimary})
                else KeyLbl.Text = KStr(curKey); Tween(Badge, 0.2, {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}); Tween(KeyLbl, 0.2, {TextColor3 = Theme.TextAccent}) end
            end
            local CB = Create("TextButton", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", ZIndex = 6, Parent = Row})
            CB.MouseButton1Click:Connect(function() SetL(not listening) end)
            CB.MouseEnter:Connect(function() Tween(Row, 0.15, {BackgroundColor3 = Theme.ElementHover}) end)
            CB.MouseLeave:Connect(function() Tween(Row, 0.15, {BackgroundColor3 = Theme.Element}) end)
            UserInputService.InputBegan:Connect(function(input, gpe)
                if gpe then return end
                if listening then
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        curKey = input.KeyCode; if flag then ConkersHub.Flags[flag] = curKey end; SetL(false); callback(curKey)
                    end
                else if input.KeyCode == curKey then callback(curKey) end end
            end)
            local K = {}
            function K:Set(k) curKey = k; if flag then ConkersHub.Flags[flag] = k end; KeyLbl.Text = KStr(k) end
            function K:Get() return curKey end
            return K
        end

        -- TextBox
        function obj:AddTextBox(cfg)
            cfg = cfg or {}
            local name = cfg.Name or "TextBox"; local holder = cfg.Placeholder or "Digite aqui..."
            local default = cfg.Default or ""; local numeric = cfg.Numeric or false
            local flag = cfg.Flag; local callback = cfg.Callback or function() end
            local desc = cfg.Description or ""; local hasDesc = desc ~= ""
            if flag then ConkersHub.Flags[flag] = default end
            local Container = Create("Frame", {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = Theme.Element, BorderSizePixel = 0, LayoutOrder = N(), ZIndex = 3, Parent = container})
            Corner(Container, 6)
            local CLy = ListLayout(Container, Enum.FillDirection.Vertical, 0); CLy.HorizontalAlignment = Enum.HorizontalAlignment.Center
            local NRow = Create("Frame", {Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1, ZIndex = 3, Parent = Container})
            Create("TextLabel", {Position = UDim2.new(0, 8, 0.5, -7), Size = UDim2.new(1, -16, 0, 14),
                BackgroundTransparency = 1, Text = name, TextColor3 = Theme.TextPrimary, TextSize = 13,
                Font = Enum.Font.GothamSemibold, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 4, Parent = NRow})
            if hasDesc then
                local DR = Create("Frame", {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1, ZIndex = 3, Parent = Container})
                Padding(DR, 0, 3, 8, 8)
                Create("TextLabel", {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1, Text = desc, TextColor3 = Theme.TextMuted, TextSize = 11,
                    Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true, ZIndex = 4, Parent = DR})
            end
            local IRow = Create("Frame", {Size = UDim2.new(1, 0, 0, 28), BackgroundTransparency = 1, ZIndex = 3, Parent = Container})
            local IBg = Create("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0),
                Size = UDim2.new(1, -14, 0, 20), BackgroundColor3 = Color3.fromRGB(78, 78, 78),
                BorderSizePixel = 0, ClipsDescendants = true, ZIndex = 4, Parent = IRow})
            Corner(IBg, 5)
            local IStroke = Stroke(IBg, Theme.Stroke, 1)
            local TB = Create("TextBox", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
                PlaceholderText = holder, PlaceholderColor3 = Theme.TextMuted, Text = default,
                TextColor3 = Theme.TextPrimary, TextSize = 12, Font = Enum.Font.Gotham,
                ClearTextOnFocus = false, TextWrapped = false,
                TextTruncate = Enum.TextTruncate.None,
                ClipsDescendants = true, ZIndex = 5, Parent = IBg})
            Padding(TB, 0, 0, 6, 6)
            TB.Focused:Connect(function() Tween(IStroke, 0.2, {Color = Theme.Accent}); Tween(IBg, 0.2, {BackgroundColor3 = Color3.fromRGB(55, 28, 80)}) end)
            TB.FocusLost:Connect(function(enter)
                Tween(IStroke, 0.2, {Color = Theme.Stroke}); Tween(IBg, 0.2, {BackgroundColor3 = Color3.fromRGB(78, 78, 78)})
                local val = TB.Text
                if numeric then val = tonumber(val) or tonumber(default) or 0; TB.Text = tostring(val) end
                if flag then ConkersHub.Flags[flag] = val end; callback(val, enter)
            end)
            local TB2 = {}
            function TB2:Set(v) TB.Text = tostring(v); if flag then ConkersHub.Flags[flag] = v end end
            function TB2:Get() return TB.Text end
            return TB2
        end

        -- ColorPicker (refatorado: ColorBox 2D + HueSlider + Preview + Hex + RGB)
        function obj:AddColorPicker(cfg)
            cfg = cfg or {}
            local name     = cfg.Name    or "Color"
            local default  = cfg.Default or Color3.fromRGB(137, 6, 255)
            local flag     = cfg.Flag
            local callback = cfg.Callback or function() end

            local h, s, v = Color3.toHSV(default)
            local curColor = default
            if flag then ConkersHub.Flags[flag] = curColor end

            -- ── Utilitários internos ──────────────────────────────────────
            local function clamp01(x) return math.clamp(x, 0, 1) end
            local function clamp255(x) return math.clamp(math.floor(x + 0.5), 0, 255) end
            local function toHex(c)
                return string.format("%02X%02X%02X",
                    clamp255(c.R * 255), clamp255(c.G * 255), clamp255(c.B * 255))
            end
            local function fromHex(str)
                str = str:gsub("^#", ""):upper()
                if #str ~= 6 then return nil end
                local r = tonumber(str:sub(1,2), 16)
                local g = tonumber(str:sub(3,4), 16)
                local b = tonumber(str:sub(5,6), 16)
                if not (r and g and b) then return nil end
                return Color3.fromRGB(r, g, b)
            end

            -- ── Row de entrada no container principal ─────────────────────
            local Container = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 28),
                BackgroundColor3 = Theme.Element,
                BorderSizePixel = 0, LayoutOrder = N(), ZIndex = 3, Parent = container,
            })
            Corner(Container, 6)
            RegisterTheme(Container, "BackgroundColor3", "Element")
            RegisterThemeAll(Container, "BackgroundColor3", "Element")
            Create("TextLabel", {
                AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 8, 0.5, 0),
                Size = UDim2.new(1, -50, 1, 0), BackgroundTransparency = 1,
                Text = name, TextColor3 = Theme.TextPrimary, TextSize = 13,
                Font = Enum.Font.GothamSemibold, TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 4, Parent = Container,
            })
            -- Minipreview no header
            local HeaderPrev = Create("Frame", {
                AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -6, 0.5, 0),
                Size = UDim2.new(0, 22, 0, 22),
                BackgroundColor3 = curColor, BorderSizePixel = 0, ZIndex = 4, Parent = Container,
            })
            Corner(HeaderPrev, 5)
            Stroke(HeaderPrev, Theme.Stroke, 1)

            -- ── Popup ─────────────────────────────────────────────────────
            local POPUP_H = 226   -- altura final animada
            local Popup = Create("Frame", {
                Size = UDim2.new(0, 0, 0, 0),
                BackgroundColor3 = Color3.fromRGB(24, 24, 24),
                BorderSizePixel = 0, ZIndex = 501,
                ClipsDescendants = false, Visible = false, Parent = Overlay,
            })
            Corner(Popup, 8)
            local PopupStroke = Stroke(Popup, Theme.StrokeAccent, 1)
            RegisterTheme(PopupStroke, "Color", "StrokeAccent")
            RegisterThemeAll(PopupStroke, "Color", "StrokeAccent")

            -- inner com padding
            local PC = Create("Frame", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1, ZIndex = 502, Parent = Popup,
            })
            Padding(PC, 8, 8, 8, 8)

            -- ── 1. ColorBox 2D ────────────────────────────────────────────
            -- Fundo: cor pura do hue atual
            local BoxBg = Create("Frame", {
                Position = UDim2.new(0, 0, 0, 0),
                Size = UDim2.new(1, 0, 0, 110),
                BorderSizePixel = 0, ZIndex = 503, Parent = PC,
            })
            Corner(BoxBg, 5)
            -- Camada 1: branco → transparente (horizontal = saturation)
            local BoxSat = Create("Frame", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 0, BorderSizePixel = 0, ZIndex = 504, Parent = BoxBg,
            })
            Corner(BoxSat, 5)
            local SatGrad = Instance.new("UIGradient")
            SatGrad.Color = ColorSequence.new(Color3.fromRGB(255,255,255), Color3.fromRGB(255,255,255))
            SatGrad.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(1, 1),
            })
            SatGrad.Parent = BoxSat
            -- Camada 2: transparente → preto (vertical = value invertido)
            local BoxVal = Create("Frame", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 0, BorderSizePixel = 0, ZIndex = 505, Parent = BoxBg,
            })
            Corner(BoxVal, 5)
            local ValGrad = Instance.new("UIGradient")
            ValGrad.Color = ColorSequence.new(Color3.fromRGB(0,0,0), Color3.fromRGB(0,0,0))
            ValGrad.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(1, 0),
            })
            ValGrad.Rotation = 90
            ValGrad.Parent = BoxVal
            -- Bolinha do ColorBox
            local BoxKnob = Create("Frame", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(s, 0, 1 - v, 0),
                Size = UDim2.new(0, 12, 0, 12),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BorderSizePixel = 0, ZIndex = 507, Parent = BoxBg,
            })
            Corner(BoxKnob, 6)
            Stroke(BoxKnob, Color3.fromRGB(0, 0, 0), 1.5)
            -- Botão transparente sobre o box para capturar input
            local BoxBtn = Create("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1, Text = "", ZIndex = 508, Parent = BoxBg,
            })

            -- ── 2. Hue Slider ─────────────────────────────────────────────
            local HueRow = Create("Frame", {
                Position = UDim2.new(0, 0, 0, 118),
                Size = UDim2.new(1, 0, 0, 20),
                BackgroundTransparency = 1, ZIndex = 503, Parent = PC,
            })
            local HueTrack = Create("Frame", {
                AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 0, 0.5, 0),
                Size = UDim2.new(1, 0, 0, 10),
                BorderSizePixel = 0, ZIndex = 504, Parent = HueRow,
            })
            Corner(HueTrack, 5)
            local HueGrad = Instance.new("UIGradient")
            HueGrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0,     Color3.fromHSV(0,     1, 1)),
                ColorSequenceKeypoint.new(0.167, Color3.fromHSV(0.167, 1, 1)),
                ColorSequenceKeypoint.new(0.333, Color3.fromHSV(0.333, 1, 1)),
                ColorSequenceKeypoint.new(0.500, Color3.fromHSV(0.500, 1, 1)),
                ColorSequenceKeypoint.new(0.667, Color3.fromHSV(0.667, 1, 1)),
                ColorSequenceKeypoint.new(0.833, Color3.fromHSV(0.833, 1, 1)),
                ColorSequenceKeypoint.new(1,     Color3.fromHSV(1,     1, 1)),
            })
            HueGrad.Parent = HueTrack
            local HueKnob = Create("Frame", {
                AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(h, 0, 0.5, 0),
                Size = UDim2.new(0, 14, 0, 14),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BorderSizePixel = 0, ZIndex = 506, Parent = HueRow,
            })
            Corner(HueKnob, 7)
            Stroke(HueKnob, Color3.fromRGB(0, 0, 0), 1.5)
            local HueBtn = Create("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1, Text = "", ZIndex = 507, Parent = HueRow,
            })

            -- ── 3. Preview + Hex ──────────────────────────────────────────
            local PrevRow = Create("Frame", {
                Position = UDim2.new(0, 0, 0, 146),
                Size = UDim2.new(1, 0, 0, 24),
                BackgroundTransparency = 1, ZIndex = 503, Parent = PC,
            })
            local PrevBox = Create("Frame", {
                AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 0, 0.5, 0),
                Size = UDim2.new(0, 24, 0, 24),
                BackgroundColor3 = curColor, BorderSizePixel = 0, ZIndex = 504, Parent = PrevRow,
            })
            Corner(PrevBox, 5)
            Stroke(PrevBox, Color3.fromRGB(80, 80, 80), 1)
            local HexLabel = Create("TextLabel", {
                AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 30, 0.5, 0),
                Size = UDim2.new(0, 16, 0, 14),
                BackgroundTransparency = 1, Text = "#",
                TextColor3 = Theme.TextMuted, TextSize = 11,
                Font = Enum.Font.GothamBold, ZIndex = 504, Parent = PrevRow,
            })
            local HexBg = Create("Frame", {
                AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 44, 0.5, 0),
                Size = UDim2.new(1, -44, 0, 20),
                BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                BorderSizePixel = 0, ZIndex = 504, Parent = PrevRow,
            })
            Corner(HexBg, 4)
            Stroke(HexBg, Color3.fromRGB(70, 70, 70), 1)
            local HexBox = Create("TextBox", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1, Text = toHex(curColor),
                TextColor3 = Color3.fromRGB(220, 220, 220), TextSize = 11,
                Font = Enum.Font.GothamBold, PlaceholderText = "RRGGBB",
                PlaceholderColor3 = Color3.fromRGB(100, 100, 100),
                ClearTextOnFocus = false, ZIndex = 505, Parent = HexBg,
            })
            Padding(HexBox, 0, 0, 5, 5)

            -- ── 4. RGB Inputs ─────────────────────────────────────────────
            local RGBRow = Create("Frame", {
                Position = UDim2.new(0, 0, 0, 178),
                Size = UDim2.new(1, 0, 0, 24),
                BackgroundTransparency = 1, ZIndex = 503, Parent = PC,
            })
            local RGBLy = ListLayout(RGBRow, Enum.FillDirection.Horizontal, 4)
            RGBLy.HorizontalAlignment = Enum.HorizontalAlignment.Center
            RGBLy.VerticalAlignment   = Enum.VerticalAlignment.Center

            local function MkRGBInput(label, initVal)
                local Wrap = Create("Frame", {
                    Size = UDim2.new(0.333, -3, 1, 0),
                    BackgroundTransparency = 1, ZIndex = 503, Parent = RGBRow,
                })
                local Bg = Create("Frame", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                    BorderSizePixel = 0, ZIndex = 504, Parent = Wrap,
                })
                Corner(Bg, 4)
                Stroke(Bg, Color3.fromRGB(70, 70, 70), 1)
                local Lbl = Create("TextLabel", {
                    AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 4, 0.5, 0),
                    Size = UDim2.new(0, 10, 1, 0),
                    BackgroundTransparency = 1,
                    Text = label, TextColor3 = Theme.TextMuted, TextSize = 10,
                    Font = Enum.Font.GothamBold, ZIndex = 505, Parent = Bg,
                })
                local TB = Create("TextBox", {
                    AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -3, 0.5, 0),
                    Size = UDim2.new(1, -16, 1, 0),
                    BackgroundTransparency = 1,
                    Text = tostring(clamp255(initVal * 255)),
                    TextColor3 = Color3.fromRGB(220, 220, 220), TextSize = 11,
                    Font = Enum.Font.Gotham, PlaceholderText = "0",
                    ClearTextOnFocus = false, ZIndex = 505, Parent = Bg,
                })
                return TB
            end

            local rR = curColor.R * 255
            local rG = curColor.G * 255
            local rB = curColor.B * 255
            local TBr = MkRGBInput("R", curColor.R)
            local TBg = MkRGBInput("G", curColor.G)
            local TBb = MkRGBInput("B", curColor.B)

            -- ── Sincronização central ─────────────────────────────────────
            -- Fonte da verdade: h, s, v (HSV).
            -- Apply() recalcula curColor e atualiza TODOS os visuais.
            local blockInputSync = false  -- evita loops ao setar programaticamente

            local function Apply()
                curColor = Color3.fromHSV(h, s, v)
                -- Cor pura do hue (para o fundo do ColorBox)
                BoxBg.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                -- Bolinha na posição correta (S = X, 1-V = Y)
                BoxKnob.Position = UDim2.new(s, 0, 1 - v, 0)
                -- Knob do hue slider
                HueKnob.Position = UDim2.new(h, 0, 0.5, 0)
                -- Previews
                PrevBox.BackgroundColor3 = curColor
                HeaderPrev.BackgroundColor3 = curColor
                -- Inputs (sem disparar FocusLost)
                if not blockInputSync then
                    blockInputSync = true
                    HexBox.Text = toHex(curColor)
                    TBr.Text = tostring(clamp255(curColor.R * 255))
                    TBg.Text = tostring(clamp255(curColor.G * 255))
                    TBb.Text = tostring(clamp255(curColor.B * 255))
                    blockInputSync = false
                end
                if flag then ConkersHub.Flags[flag] = curColor end
                callback(curColor)
            end

            -- ── Drag do ColorBox ──────────────────────────────────────────
            local boxDrag = false
            local anyDragging = false
            local function updateBoxFromInput(px, py)
                local ap = BoxBg.AbsolutePosition
                local as = BoxBg.AbsoluteSize
                s = clamp01((px - ap.X) / as.X)
                v = clamp01(1 - (py - ap.Y) / as.Y)
                Apply()
            end
            BoxBtn.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1
                or i.UserInputType == Enum.UserInputType.Touch then
                    boxDrag = true; anyDragging = true; centralDragActive = true
                    updateBoxFromInput(i.Position.X, i.Position.Y)
                end
            end)
            UserInputService.InputChanged:Connect(function(i)
                if not boxDrag then return end
                if i.UserInputType == Enum.UserInputType.MouseMovement
                or i.UserInputType == Enum.UserInputType.Touch then
                    updateBoxFromInput(i.Position.X, i.Position.Y)
                end
            end)
            UserInputService.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1
                or i.UserInputType == Enum.UserInputType.Touch then
                    boxDrag = false
                    task.defer(function() anyDragging = false; centralDragActive = false end)
                end
            end)

            -- ── Drag do Hue Slider ────────────────────────────────────────
            local hueDrag = false
            local function updateHueFromInput(px)
                local ap = HueTrack.AbsolutePosition
                local as = HueTrack.AbsoluteSize
                h = clamp01((px - ap.X) / as.X)
                Apply()
            end
            HueBtn.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1
                or i.UserInputType == Enum.UserInputType.Touch then
                    hueDrag = true; anyDragging = true; centralDragActive = true
                    updateHueFromInput(i.Position.X)
                end
            end)
            UserInputService.InputChanged:Connect(function(i)
                if not hueDrag then return end
                if i.UserInputType == Enum.UserInputType.MouseMovement
                or i.UserInputType == Enum.UserInputType.Touch then
                    updateHueFromInput(i.Position.X)
                end
            end)
            UserInputService.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1
                or i.UserInputType == Enum.UserInputType.Touch then
                    hueDrag = false
                    task.defer(function() anyDragging = false; centralDragActive = false end)
                end
            end)

            -- ── Input Hex ─────────────────────────────────────────────────
            HexBox.FocusLost:Connect(function()
                if blockInputSync then return end
                local c = fromHex(HexBox.Text)
                if c then
                    h, s, v = Color3.toHSV(c)
                    Apply()
                else
                    HexBox.Text = toHex(curColor)
                end
            end)

            -- ── Inputs RGB ────────────────────────────────────────────────
            local function onRGBChange()
                if blockInputSync then return end
                local r = clamp255(tonumber(TBr.Text) or 0)
                local g = clamp255(tonumber(TBg.Text) or 0)
                local b = clamp255(tonumber(TBb.Text) or 0)
                -- clamp e corrigir texto
                TBr.Text = tostring(r)
                TBg.Text = tostring(g)
                TBb.Text = tostring(b)
                h, s, v = Color3.toHSV(Color3.fromRGB(r, g, b))
                Apply()
            end
            TBr.FocusLost:Connect(onRGBChange)
            TBg.FocusLost:Connect(onRGBChange)
            TBb.FocusLost:Connect(onRGBChange)

            -- ── Abrir / Fechar popup ──────────────────────────────────────
            local popOpen = false
            local popupW  = 0

            local function ClosePopup()
                popOpen = false
                centralCloseFn = nil
                CentralOverlay.Visible = false
                Tween(Popup, 0.22, {Size = UDim2.new(0, popupW, 0, 0)},
                    Enum.EasingStyle.Quart, Enum.EasingDirection.In)
                task.delay(0.23, function() if Popup then Popup.Visible = false end end)
            end

            -- Fechar ao arrastar: o CentralOverlay backdrop chama ClosePopup
            -- Mas se estiver arrastando, bloqueamos o backdrop via anyDragging
            -- O CentralOverlay TextButton só dispara se not anyDragging (checado externamente)

            local CBtn = Create("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1, Text = "", ZIndex = 5, Parent = Container,
            })
            CBtn.MouseButton1Click:Connect(function()
                if popOpen then ClosePopup(); return end
                popOpen = true
                local ap = Container.AbsolutePosition
                local as = Container.AbsoluteSize
                local vp = workspace.CurrentCamera.ViewportSize
                popupW = math.min(as.X, 280)
                -- Ancoragem contextual: abaixo do componente, ou acima se não couber
                local posX = math.clamp(ap.X, 4, vp.X - popupW - 4)
                local posYBelow = ap.Y + as.Y + 4
                local posYAbove = ap.Y - POPUP_H - 4
                local posY = (posYBelow + POPUP_H <= vp.Y) and posYBelow or posYAbove
                Popup.Parent = Overlay
                Popup.Position = UDim2.new(0, posX, 0, posY)
                Popup.Size = UDim2.new(0, popupW, 0, 0)
                Popup.Visible = true
                CentralOverlay.Visible = true
                centralCloseFn = ClosePopup
                Tween(Popup, 0.25, {Size = UDim2.new(0, popupW, 0, POPUP_H)},
                    Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
                Apply()
            end)
            CBtn.MouseEnter:Connect(function() Tween(Container, 0.15, {BackgroundColor3 = Theme.ElementHover}) end)
            CBtn.MouseLeave:Connect(function() Tween(Container, 0.15, {BackgroundColor3 = Theme.Element}) end)

            -- Aplica estado inicial
            Apply()

            -- ── API pública ───────────────────────────────────────────────
            local CP = {}
            function CP:Set(color)
                h, s, v = Color3.toHSV(color)
                curColor = color
                if flag then ConkersHub.Flags[flag] = color end
                Apply()
            end
            function CP:Get() return curColor end
            return CP
        end

        -- Label
        function obj:AddLabel(cfg)
            cfg = cfg or {}
            local Lbl = Create("TextLabel", {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1, Text = cfg.Text or cfg.Name or "Label",
                TextColor3 = cfg.Color or Theme.TextSecondary, TextSize = cfg.TextSize or 12,
                Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true,
                LayoutOrder = N(), ZIndex = 3, Parent = container})
            Padding(Lbl, 2, 2, 6, 6)
            local L = {}
            function L:Set(t) Lbl.Text = tostring(t) end
            function L:SetColor(c) Lbl.TextColor3 = c end
            return L
        end

        -- Separator
        function obj:AddSeparator()
            Create("Frame", {Size = UDim2.new(1, -12, 0, 1), BackgroundColor3 = Theme.Stroke,
                BorderSizePixel = 0, LayoutOrder = N(), ZIndex = 3, Parent = container})
        end

        -- Dialog
        function obj:AddDialog(cfg)
            cfg = cfg or {}
            local name = cfg.Name or "Abrir Dialog"; local guiText = cfg.GuiText or "Tem certeza?"
            local yesBtn = cfg.YesBtn or "Sim"; local noBtn = cfg.NoBtn or "Não"
            local callback = cfg.Callback or function() end
            local Btn = Create("TextButton", {Size = UDim2.new(1, 0, 0, 28), BackgroundColor3 = Theme.Element,
                BorderSizePixel = 0, Text = "", LayoutOrder = N(), ZIndex = 3, Parent = container})
            Corner(Btn, 6)
            local BtnDialogStroke = Stroke(Btn, Theme.StrokeAccent, 1)
            RegisterTheme(BtnDialogStroke, "Color", "StrokeAccent")
            RegisterThemeAll(BtnDialogStroke, "Color", "StrokeAccent")
            RegisterTheme(Btn, "BackgroundColor3", "Element")
            RegisterThemeAll(Btn, "BackgroundColor3", "Element")
            local BtnWarnLbl = Create("TextLabel", {AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 8, 0.5, 0),
                Size = UDim2.new(0, 16, 0, 16), BackgroundTransparency = 1, Text = "⚠",
                TextColor3 = Theme.Accent, TextSize = 13, Font = Enum.Font.GothamBold, ZIndex = 4, Parent = Btn})
            RegisterTheme(BtnWarnLbl, "TextColor3", "Accent")
            RegisterThemeAll(BtnWarnLbl, "TextColor3", "Accent")
            Create("TextLabel", {AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 28, 0.5, 0),
                Size = UDim2.new(1, -36, 1, 0), BackgroundTransparency = 1, Text = name,
                TextColor3 = Theme.TextPrimary, TextSize = 12, Font = Enum.Font.GothamSemibold,
                TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 4, Parent = Btn})
            Btn.MouseEnter:Connect(function() Tween(Btn, 0.15, {BackgroundColor3 = Theme.ElementHover}) end)
            Btn.MouseLeave:Connect(function() Tween(Btn, 0.15, {BackgroundColor3 = Theme.Element}) end)
            Btn.MouseButton1Down:Connect(function() Tween(Btn, 0.08, {BackgroundColor3 = Theme.ElementPress}) end)
            Btn.MouseButton1Up:Connect(function() Tween(Btn, 0.1, {BackgroundColor3 = Theme.ElementHover}) end)
            Btn.MouseButton1Click:Connect(function()
                OpenDialog({GuiText = guiText, YesBtn = yesBtn, NoBtn = noBtn, Callback = callback})
            end)
        end

        -- ThemeSelector
        -- Exibe os temas disponíveis como botões de cor clicáveis.
        -- Ao selecionar, chama ConkersHub:SetTheme() que aciona ApplyThemeAll().
        -- Troca instantânea sem recriar janela.
        function obj:AddThemeCompSelector(cfg)
            cfg = cfg or {}
            local name = cfg.Name or "Theme"
            local default = cfg.Default or "Purple"
            local callback = cfg.Callback or function() end
            local themeNames = {"Purple", "Blue", "Green", "Red", "Orange", "Pink", "Cyan", "White", "Dark", "Gray"}
            -- Cores de amostra para cada tema (Accent color)
            local themeAccents = {
                Purple = Color3.fromRGB(137, 6, 255), Blue = Color3.fromRGB(30, 120, 255),
                Green = Color3.fromRGB(40, 180, 70), Red = Color3.fromRGB(220, 40, 40),
                Orange = Color3.fromRGB(255, 130, 20), Pink = Color3.fromRGB(230, 60, 160),
                Cyan = Color3.fromRGB(0, 200, 220), White = Color3.fromRGB(220, 220, 220),
                Dark = Color3.fromRGB(90, 90, 90), Gray = Color3.fromRGB(160, 160, 160),
            }

            local Container = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = Theme.Element, BorderSizePixel = 0,
                LayoutOrder = N(), ZIndex = 3, Parent = container,
            })
            Corner(Container, 6)
            RegisterTheme(Container, "BackgroundColor3", "Element")
            RegisterThemeAll(Container, "BackgroundColor3", "Element")

            local CLy = ListLayout(Container, Enum.FillDirection.Vertical, 0)
            CLy.HorizontalAlignment = Enum.HorizontalAlignment.Center

            -- Linha do título
            local TRow = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 26), BackgroundTransparency = 1, ZIndex = 3, Parent = Container,
            })
            Create("TextLabel", {
                AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 8, 0.5, 0),
                Size = UDim2.new(1, -16, 0, 14), BackgroundTransparency = 1,
                Text = name, TextColor3 = Theme.TextPrimary, TextSize = 13,
                Font = Enum.Font.GothamSemibold, TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 4, Parent = TRow,
            })

            -- Grid de bolinhas de cor
            local Grid = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 36), BackgroundTransparency = 1, ZIndex = 3, Parent = Container,
            })
            Padding(Grid, 0, 8, 10, 10)
            local GLy = ListLayout(Grid, Enum.FillDirection.Horizontal, 6)
            GLy.HorizontalAlignment = Enum.HorizontalAlignment.Left
            GLy.VerticalAlignment = Enum.VerticalAlignment.Center

            local currentTheme = default
            local dots = {}

            local function refreshDots()
                for tname, dot in pairs(dots) do
                    local isActive = tname == currentTheme
                    Tween(dot, 0.15, {
                        Size = isActive and UDim2.new(0, 22, 0, 22) or UDim2.new(0, 18, 0, 18),
                        BackgroundColor3 = themeAccents[tname],
                    })
                    -- Borda branca no ativo
                    local stroke = dot:FindFirstChildOfClass("UIStroke")
                    if stroke then
                        stroke.Thickness = isActive and 2 or 0
                    end
                end
            end

            for _, tname in ipairs(themeNames) do
                local Dot = Create("Frame", {
                    Size = UDim2.new(0, 18, 0, 18),
                    BackgroundColor3 = themeAccents[tname],
                    BorderSizePixel = 0, ZIndex = 4, Parent = Grid,
                })
                Corner(Dot, 9)
                local DotStroke = Stroke(Dot, Color3.fromRGB(255, 255, 255), 0)
                dots[tname] = Dot

                local DotBtn = Create("TextButton", {
                    Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
                    Text = "", ZIndex = 5, Parent = Dot,
                })
                DotBtn.MouseButton1Click:Connect(function()
                    currentTheme = tname
                    ConkersHub:SetThemeComp(tname)
                    refreshDots()
                    callback(tname)
                end)
                DotBtn.MouseEnter:Connect(function()
                    if tname ~= currentTheme then
                        Tween(Dot, 0.12, {Size = UDim2.new(0, 21, 0, 21)})
                    end
                end)
                DotBtn.MouseLeave:Connect(function()
                    if tname ~= currentTheme then
                        Tween(Dot, 0.12, {Size = UDim2.new(0, 18, 0, 18)})
                    end
                end)
            end

            -- Aplica visual inicial
            if default and Themes[default] then
                ConkersHub:SetThemeComp(default)
            end
            refreshDots()

            local TS = {}
            function TS:Set(tname)
                if Themes[tname] then
                    currentTheme = tname
                    ConkersHub:SetThemeComp(tname)
                    refreshDots()
                end
            end
            function TS:Get() return currentTheme end
            return TS
        end


        -- Socials: painel social premium com cards de plataformas
        function obj:AddSocials(cfg)
            cfg = cfg or {}

            local PLATFORM_ORDER = {"Discord", "Youtube", "TikTok", "Linktree", "ScriptBlox"}
            local PLATFORM_META = {
                Discord   = {icon = "💬", color = Color3.fromRGB(88, 101, 242)},
                Youtube   = {icon = "▶",  color = Color3.fromRGB(255, 0, 0)},
                TikTok    = {icon = "♪",  color = Color3.fromRGB(255, 255, 255)},
                Linktree  = {icon = "🌿", color = Color3.fromRGB(67, 198, 120)},
                ScriptBlox= {icon = "📜", color = Color3.fromRGB(255, 165, 0)},
            }

            local active = {}
            for _, pname in ipairs(PLATFORM_ORDER) do
                if cfg[pname] then
                    table.insert(active, {name = pname, data = cfg[pname], meta = PLATFORM_META[pname]})
                end
            end
            if #active == 0 then return end

            local Outer = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                LayoutOrder = N(),
                ZIndex = 3,
                Parent = container,
            })

            local useGrid = (#active >= 3)
            local CARD_H  = useGrid and 72 or 82
            local CARD_GAP = 6

            local Grid = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                ZIndex = 3,
                Parent = Outer,
            })

            local GLy
            if useGrid then
                GLy = Create("UIGridLayout", {
                    CellSize = UDim2.new(0.5, -CARD_GAP / 2, 0, CARD_H),
                    CellPadding = UDim2.new(0, CARD_GAP, 0, CARD_GAP),
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Left,
                    VerticalAlignment = Enum.VerticalAlignment.Top,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Parent = Grid,
                })
                GLy:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    Grid.Size = UDim2.new(1, 0, 0, GLy.AbsoluteContentSize.Y)
                end)
            else
                GLy = ListLayout(Grid, Enum.FillDirection.Vertical, CARD_GAP)
                GLy:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    Grid.Size = UDim2.new(1, 0, 0, GLy.AbsoluteContentSize.Y)
                end)
            end

            for idx, entry in ipairs(active) do
                local pname    = entry.name
                local data     = entry.data
                local meta     = entry.meta
                local link     = data.Link or ""
                local dname    = data.Name or pname
                local user     = data.User or ""
                local image    = data.Image or ""
                local icoColor = meta.color

                local Card = Create("Frame", {
                    Size = useGrid and UDim2.new(1, 0, 1, 0) or UDim2.new(1, 0, 0, CARD_H),
                    BackgroundColor3 = Theme.Element,
                    BorderSizePixel = 0,
                    LayoutOrder = idx,
                    ZIndex = 4,
                    Parent = Grid,
                })
                Corner(Card, 8)
                local CardStroke = Stroke(Card, Theme.StrokeAccent, 1)
                RegisterTheme(Card, "BackgroundColor3", "Element")
                RegisterTheme(CardStroke, "Color", "StrokeAccent")

                local AccentBar = Create("Frame", {
                    Size = UDim2.new(0, 3, 1, -16),
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, 6, 0.5, 0),
                    BackgroundColor3 = icoColor,
                    BorderSizePixel = 0,
                    ZIndex = 5,
                    Parent = Card,
                })
                Corner(AccentBar, 2)

                local AvatarBg = Create("Frame", {
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, 14, 0.5, 0),
                    Size = UDim2.new(0, 36, 0, 36),
                    BackgroundColor3 = icoColor,
                    BorderSizePixel = 0,
                    ZIndex = 5,
                    Parent = Card,
                })
                Corner(AvatarBg, 8)

                if image ~= "" and image ~= "rbxassetid://0" then
                    Create("ImageLabel", {
                        Size = UDim2.new(1, 0, 1, 0),
                        BackgroundTransparency = 1,
                        Image = image,
                        ZIndex = 6,
                        Parent = AvatarBg,
                    })
                else
                    Create("TextLabel", {
                        Size = UDim2.new(1, 0, 1, 0),
                        BackgroundTransparency = 1,
                        Text = meta.icon,
                        TextSize = 18,
                        Font = Enum.Font.GothamBold,
                        TextColor3 = Color3.fromRGB(255, 255, 255),
                        ZIndex = 6,
                        Parent = AvatarBg,
                    })
                end

                local InfoArea = Create("Frame", {
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, 58, 0.5, 0),
                    Size = UDim2.new(1, -118, 1, -12),
                    BackgroundTransparency = 1,
                    ZIndex = 5,
                    Parent = Card,
                })
                local InfoLy = ListLayout(InfoArea, Enum.FillDirection.Vertical, 1)
                InfoLy.VerticalAlignment = Enum.VerticalAlignment.Center

                Create("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 14),
                    BackgroundTransparency = 1,
                    Text = dname,
                    TextColor3 = Theme.TextPrimary,
                    TextSize = 12,
                    Font = Enum.Font.GothamBold,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    ZIndex = 6,
                    Parent = InfoArea,
                })

                if user ~= "" then
                    Create("TextLabel", {
                        Size = UDim2.new(1, 0, 0, 12),
                        BackgroundTransparency = 1,
                        Text = user,
                        TextColor3 = Theme.TextMuted,
                        TextSize = 10,
                        Font = Enum.Font.Gotham,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        TextTruncate = Enum.TextTruncate.AtEnd,
                        ZIndex = 6,
                        Parent = InfoArea,
                    })
                end

                if link ~= "" then
                    Create("TextLabel", {
                        Size = UDim2.new(1, 0, 0, 11),
                        BackgroundTransparency = 1,
                        Text = link,
                        TextColor3 = icoColor,
                        TextSize = 9,
                        Font = Enum.Font.Gotham,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        TextTruncate = Enum.TextTruncate.AtEnd,
                        ZIndex = 6,
                        Parent = InfoArea,
                    })
                end

                -- Botão Copy com compatibilidade máxima de executores
                local CopyBtn = Create("TextButton", {
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, -8, 0.5, 0),
                    Size = UDim2.new(0, 44, 0, 22),
                    BackgroundColor3 = Theme.Element,
                    BorderSizePixel = 0,
                    Text = "Copy",
                    TextColor3 = icoColor,
                    TextSize = 10,
                    Font = Enum.Font.GothamBold,
                    ZIndex = 8,
                    Parent = Card,
                })
                Corner(CopyBtn, 5)
                Stroke(CopyBtn, icoColor, 1)
                RegisterTheme(CopyBtn, "BackgroundColor3", "Element")

                local CardHover = Create("TextButton", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = "", ZIndex = 7,
                    Parent = Card,
                })
                CardHover.MouseEnter:Connect(function()
                    Tween(Card, 0.15, {BackgroundColor3 = Theme.ElementHover})
                end)
                CardHover.MouseLeave:Connect(function()
                    Tween(Card, 0.15, {BackgroundColor3 = Theme.Element})
                end)

                CopyBtn.MouseEnter:Connect(function()
                    Tween(CopyBtn, 0.12, {BackgroundColor3 = icoColor, TextColor3 = Color3.fromRGB(255,255,255)})
                end)
                CopyBtn.MouseLeave:Connect(function()
                    Tween(CopyBtn, 0.12, {BackgroundColor3 = Theme.Element, TextColor3 = icoColor})
                end)

                -- Copy com fallback para múltiplos executores (PC e mobile)
                CopyBtn.MouseButton1Click:Connect(function()
                    if link ~= "" then
                        -- 1. setclipboard: Synapse, Script-Ware, Delta, Fluxus, etc.
                        if type(setclipboard) == "function" then
                            pcall(setclipboard, link)
                        -- 2. syn.clipboard.set: Synapse X legacy
                        elseif type(syn) == "table" and syn.clipboard and type(syn.clipboard.set) == "function" then
                            pcall(syn.clipboard.set, link)
                        -- 3. writefile como fallback (armazena em arquivo, alguns mobile)
                        elseif type(writefile) == "function" then
                            pcall(writefile, "_clipboard.txt", link)
                        end
                        -- 4. GuiService.Clipboard (Studio/internal, best-effort)
                        pcall(function()
                            local gs = game:GetService("GuiService")
                            if gs then gs.Clipboard = link end
                        end)
                    end
                    -- Feedback visual: sempre executa independente do executor
                    CopyBtn.Text = "✓"
                    Tween(CopyBtn, 0.1, {BackgroundColor3 = icoColor, TextColor3 = Color3.fromRGB(255,255,255)})
                    task.delay(1.2, function()
                        if CopyBtn and CopyBtn.Parent then
                            CopyBtn.Text = "Copy"
                            Tween(CopyBtn, 0.2, {BackgroundColor3 = Theme.Element, TextColor3 = icoColor})
                        end
                    end)
                end)
            end
        end

        return obj
    end -- MakeComponents

    -- Window
    local Window = {}
    local tabs = {}
    local activeTab = nil

    function Window:Destroy() ScreenGui:Destroy() end

    -- Sistema de Notify
    -- Cada notify tem seu próprio slot vertical: empilha de baixo para cima.
    -- Sem sobreposição, sem barrinha lateral.
    local notifySlots = {}
    local NOTIFY_W = 260
    local NOTIFY_GAP = 8
    local NOTIFY_BOTTOM = 20

    local NotifyContainer = Create("Frame", {
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -16, 1, -NOTIFY_BOTTOM),
        Size = UDim2.new(0, NOTIFY_W, 1, 0),
        BackgroundTransparency = 1,
        ZIndex = 900,
        Parent = ScreenGui,
    })
    local NotifyLy = Instance.new("UIListLayout")
    NotifyLy.FillDirection = Enum.FillDirection.Vertical
    NotifyLy.SortOrder = Enum.SortOrder.LayoutOrder
    NotifyLy.VerticalAlignment = Enum.VerticalAlignment.Bottom
    NotifyLy.Padding = UDim.new(0, NOTIFY_GAP)
    NotifyLy.Parent = NotifyContainer

    function Window:Notify(cfg)
        cfg = cfg or {}
        local title = cfg.Title or "Notificação"
        local message = cfg.Message or cfg.Text or ""
        local duration = cfg.Duration or 3

        -- Estratégia de animação:
        -- Wrapper: ocupa espaço no UIListLayout (tamanho real), clipsa o Card.
        -- Card: posicionado relativo ao Wrapper.
        -- Entrada: Card desliza de Position(1,20,0,0) → (0,0,0,0) + fade in Wrapper.
        -- Saída:   Card desliza de volta + fade out Wrapper, depois Destroy.
        -- ClipsDescendants=true no Wrapper garante que o slide não vaze para fora.

        -- Wrapper: SEM ClipsDescendants para não cortar o UIStroke do Card.
        -- O UIStroke renderiza ao redor do Card (fora dos bounds),
        -- ClipsDescendants=true cortaria ele e o stroke sumia por trás.
        local Wrapper = Create("Frame", {
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            ClipsDescendants = false,
            ZIndex = 900,
            Parent = NotifyContainer,
        })

        local Card = Create("Frame", {
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = Color3.fromRGB(22, 22, 22),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ClipsDescendants = false,
            ZIndex = 901,
            Parent = Wrapper,
        })
        Corner(Card, 8)
        local CardStroke = Stroke(Card, Theme.StrokeAccent, 1.5)
        CardStroke.ZIndex = 902    -- garante stroke acima do Card
        RegisterThemeAll(CardStroke, "Color", "StrokeAccent")

        local Inner = Create("Frame", {
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            ZIndex = 902,
            Parent = Card,
        })
        local ILy = ListLayout(Inner, Enum.FillDirection.Vertical, 4)
        ILy.HorizontalAlignment = Enum.HorizontalAlignment.Left
        Padding(Inner, 10, 10, 12, 12)

        Create("TextLabel", {
            Size = UDim2.new(1, 0, 0, 14),
            BackgroundTransparency = 1,
            Text = title,
            TextColor3 = Theme.Accent,
            TextSize = 13,
            Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 903,
            Parent = Inner,
        })

        if message ~= "" then
            Create("TextLabel", {
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                Text = message,
                TextColor3 = Theme.TextSecondary,
                TextSize = 12,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true,
                ZIndex = 903,
                Parent = Inner,
            })
        end

        local BarBg = Create("Frame", {
            Size = UDim2.new(1, 0, 0, 3),
            BackgroundColor3 = Color3.fromRGB(50, 50, 50),
            BorderSizePixel = 0,
            ZIndex = 903,
            Parent = Inner,
        })
        Corner(BarBg, 2)
        local Bar = Create("Frame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundColor3 = Theme.Accent,
            BorderSizePixel = 0,
            ZIndex = 904,
            Parent = BarBg,
        })
        RegisterThemeAll(Bar, "BackgroundColor3", "Accent")
        Corner(Bar, 2)

        -- ENTRADA: slide da direita + fade in
        Card.Position = UDim2.new(1, 20, 0, 0)
        Tween(Card, 0.32, {
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 0,
        }, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

        -- Barra de progresso
        Tween(Bar, duration, {Size = UDim2.new(0, 0, 1, 0)}, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)

        -- SAÍDA: slide para direita + fade out, depois destrói
        task.delay(duration, function()
            if not Wrapper or not Wrapper.Parent then return end
            Tween(Card, 0.28, {
                Position = UDim2.new(1, 20, 0, 0),
                BackgroundTransparency = 1,
            }, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
            task.delay(0.30, function()
                if Wrapper and Wrapper.Parent then Wrapper:Destroy() end
            end)
        end)
    end

    -- ================================================================
    -- SetTransparency — invisibilidade real da interface
    -- ================================================================
    -- AFETA (dentro de Main, excluindo zonas proibidas):
    --   Frame/ScrollingFrame  → BackgroundTransparency
    --   ImageLabel/ImageButton → BackgroundTransparency + ImageTransparency
    --   TextButton            → BackgroundTransparency (NÃO texto)
    --   UIStroke              → Transparency
    --
    -- NÃO AFETA:
    --   TextLabel, TextBox    → nenhuma propriedade
    --   DialogOverlay e filhos → zona proibida
    --   NotifyContainer e filhos → zona proibida (notify independente)
    --   FloatBtn              → fica fora de Main, ignorado automaticamente
    --
    -- FÓRMULA: result = base + (1 - base) * alpha
    --   alpha=0  → result = base  (original exato, sem nenhuma mudança)
    --   alpha=0.5 → resultado no meio caminho entre base e 1
    --   alpha=1  → result = 1     (totalmente invisível)
    --   Lê sempre do base salvo → sem acúmulo de erro, funciona infinitamente.
    -- ================================================================

    -- Snapshot: { [inst] = { bg = val, img = val/nil, stroke = val/nil } }
    -- Cada instância tem seus valores base salvos uma única vez.
    local tSnap = nil

    -- Verifica se inst é descendente de uma zona proibida
    local function inForbiddenZone(inst)
        local cur = inst.Parent
        while cur and cur ~= Main do
            if cur == DialogOverlay or cur == NotifyContainer then
                return true
            end
            cur = cur.Parent
        end
        return false
    end

    local function snapInst(inst)
        -- Registra um único inst no snapshot conforme seu tipo
        if inst:IsA("UIStroke") then
            tSnap[inst] = { stroke = inst.Transparency }
        elseif inst:IsA("ImageLabel") or inst:IsA("ImageButton") then
            tSnap[inst] = { bg = inst.BackgroundTransparency, img = inst.ImageTransparency }
        elseif inst:IsA("Frame") or inst:IsA("ScrollingFrame") or inst:IsA("TextButton") then
            tSnap[inst] = { bg = inst.BackgroundTransparency }
        end
        -- TextLabel, TextBox e outros: ignorados
    end

    local function buildTSnap()
        tSnap = {}
        -- Main em si: deve ser afetado (é a janela principal)
        snapInst(Main)
        -- Todos os descendentes de Main
        for _, inst in ipairs(Main:GetDescendants()) do
            -- Pula zonas proibidas (Dialog, Notify) e textos
            if inForbiddenZone(inst) then
                -- skip
            elseif inst:IsA("TextLabel") or inst:IsA("TextBox") then
                -- skip
            else
                snapInst(inst)
            end
        end
    end

    function Window:SetTransparency(alpha)
        alpha = math.clamp(alpha or 0, 0, 1)
        -- Constrói snapshot na primeira chamada
        if not tSnap then buildTSnap() end

        for inst, bases in pairs(tSnap) do
            if inst and inst.Parent then
                -- Fórmula: result = base + (1 - base) * alpha
                if bases.bg ~= nil then
                    pcall(function()
                        inst.BackgroundTransparency = bases.bg + (1 - bases.bg) * alpha
                    end)
                end
                if bases.img ~= nil then
                    pcall(function()
                        inst.ImageTransparency = bases.img + (1 - bases.img) * alpha
                    end)
                end
                if bases.stroke ~= nil then
                    pcall(function()
                        inst.Transparency = bases.stroke + (1 - bases.stroke) * alpha
                    end)
                end
            end
        end
    end

    -- Força reconstrução do snapshot (chamar após trocar tema ou criar novos elementos)
    function Window:ResetTransparencySnapshot()
        tSnap = nil
    end

    -- [Fix 3+4] AddFloatButton
    -- Drag corrigido: AbsolutePosition lido UMA VEZ no início.
    -- Clique vs Drag detectados por threshold de pixels.
    -- [Fix 4] Sombra removida: sem ImageLabel shadow.
    function Window:AddFloatButton(cfg)
        cfg = cfg or {}
        local btnCfg = cfg.Button or {}
        local cornerCfg = cfg.Corner or {}

        local img = btnCfg.Image or ""
        local bgT = btnCfg.BackgroundTransparency or 0
        local bgColor = btnCfg.BackgroundColor3 or Theme.Accent
        local radius = cornerCfg.CornerRadius or UDim.new(0, 24)

        -- FadeFrame dentro do Main para animação
        local FadeFrame = Create("Frame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundColor3 = Theme.Background,
            BackgroundTransparency = 1,
            ZIndex = 200,
            Visible = false,
            Parent = Main,
        })
        Corner(FadeFrame, RADIUS)

        -- Botão flutuante (sem sombra)
        local FloatBtn = Create("ImageButton", {
            Name = "ConkersHubFloat",
            Position = UDim2.new(0, 14, 0.8, -24),
            Size = UDim2.new(0, 48, 0, 48),
            BackgroundColor3 = bgColor,
            BackgroundTransparency = bgT,
            Image = img,
            BorderSizePixel = 0,
            ZIndex = 100,
            Parent = ScreenGui,
        })
        local fCorner = Instance.new("UICorner")
        fCorner.CornerRadius = radius
        fCorner.Parent = FloatBtn

        -- Drag da bolinha: mesma lógica do MakeDraggable.
        -- DragStart e StartPosition capturados no InputBegan.
        -- Delta aplicado sobre StartPosition (UDim2) sem conversões.
        local fDragInput = nil
        local fDragStart = nil
        local fStartPosition = nil
        local fWasDragged = false
        local DRAG_THRESHOLD = 8

        FloatBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
                fDragInput = input
                fWasDragged = false
                fDragStart = input.Position
                fStartPosition = FloatBtn.Position
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if input ~= fDragInput then return end
            if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then
                local delta = input.Position - fDragStart
                if delta.Magnitude > DRAG_THRESHOLD then
                    fWasDragged = true
                end
                FloatBtn.Position = UDim2.new(
                    fStartPosition.X.Scale,
                    fStartPosition.X.Offset + delta.X,
                    fStartPosition.Y.Scale,
                    fStartPosition.Y.Offset + delta.Y
                )
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input == fDragInput then
                fDragInput = nil
            end
        end)

        -- Toggle visibilidade (só se foi clique, não arrasto)
        local uiVisible = true
        FloatBtn.MouseButton1Click:Connect(function()
            if fWasDragged then
                fWasDragged = false
                return
            end
            uiVisible = not uiVisible
            if uiVisible then
                Main.Visible = true
                FadeFrame.BackgroundTransparency = 0
                FadeFrame.Visible = true
                Tween(FadeFrame, 0.3, {BackgroundTransparency = 1})
                task.delay(0.3, function() FadeFrame.Visible = false end)
            else
                FadeFrame.BackgroundTransparency = 1
                FadeFrame.Visible = true
                Tween(FadeFrame, 0.3, {BackgroundTransparency = 0})
                task.delay(0.3, function()
                    if not uiVisible then
                        Main.Visible = false
                        FadeFrame.Visible = false
                        FadeFrame.BackgroundTransparency = 1
                    end
                end)
            end
        end)

        return FloatBtn
    end

    -- AddTab
    function Window:AddTab(tabConfig)
        tabConfig = tabConfig or {}
        local tabName = tabConfig.Name or ("Tab " .. (#tabs + 1))

        local TabBtn = Create("TextButton", {
            Name = tabName, Size = UDim2.new(1, 0, 0, 30),
            BackgroundColor3 = Theme.TabInactive, BorderSizePixel = 0,
            Text = tabName, TextColor3 = Theme.TextPrimary,
            TextSize = 13, FontFace = FontDenk, ZIndex = 4, Parent = Sidebar,
        })
        Corner(TabBtn, 6)
        RegisterTheme(TabBtn, "BackgroundColor3", "TabInactive")
        RegisterTheme(TabBtn, "TextColor3", "TextPrimary")
        RegisterThemeAll(TabBtn, "BackgroundColor3", "TabInactive")
        RegisterThemeAll(TabBtn, "TextColor3", "TextPrimary")
        -- Callback para recolorir o TabBtn ativo ao trocar ThemeAll
        RegisterThemeAllCallback(function()
            if activeTab and activeTab.btn == TabBtn then
                pcall(function() TabBtn.BackgroundColor3 = Theme.TabActive end)
            else
                pcall(function() TabBtn.BackgroundColor3 = Theme.TabInactive end)
            end
        end)

        local TabPage = Create("ScrollingFrame", {
            Name = tabName.. "Page", Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1, BorderSizePixel = 0,
            ScrollBarThickness = 3, ScrollBarImageColor3 = Theme.Accent,
            CanvasSize = UDim2.new(0, 0, 0, 0), Visible = false, ZIndex = 2, Parent = ContentArea,
        })
        RegisterTheme(TabPage, "ScrollBarImageColor3", "Accent")
        RegisterThemeAll(TabPage, "ScrollBarImageColor3", "Accent")
        local PLy = ListLayout(TabPage, Enum.FillDirection.Vertical, 5)
        PLy.HorizontalAlignment = Enum.HorizontalAlignment.Center
        Padding(TabPage, 7, 7, 5, 5)
        PLy:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabPage.CanvasSize = UDim2.new(0, 0, 0, PLy.AbsoluteContentSize.Y + 14)
        end)

        local function ActivateTab()
            if activeTab then
                Tween(activeTab.btn, 0.2, {BackgroundColor3 = Theme.TabInactive})
                activeTab.page.Visible = false
            end
            activeTab = {btn = TabBtn, page = TabPage}
            Tween(TabBtn, 0.2, {BackgroundColor3 = Theme.TabActive})
            TabPage.Visible = true
        end

        TabBtn.MouseButton1Click:Connect(ActivateTab)
        TabBtn.MouseEnter:Connect(function()
            if activeTab and activeTab.btn ~= TabBtn then
                Tween(TabBtn, 0.15, {BackgroundColor3 = Theme.ElementHover})
            end
        end)
        TabBtn.MouseLeave:Connect(function()
            if activeTab and activeTab.btn ~= TabBtn then
                Tween(TabBtn, 0.15, {BackgroundColor3 = Theme.TabInactive})
            end
        end)
        if #tabs == 0 then ActivateTab() end

        local Tab = MakeComponents(TabPage)
        table.insert(tabs, Tab)

        -- Aliases novos nomes da API Conkers Hub
        Tab.Switch = Tab.AddToggle
        Tab.Action = Tab.AddButton
        Tab.Choice = Tab.AddDropdown
        Tab.MultiChoice = Tab.AddMultiDropdown
        Tab.Range = Tab.AddSlider
        Tab.Input = Tab.AddTextBox
        Tab.Palette = Tab.AddColorPicker
        Tab.Bind = Tab.AddKeybind
        Tab.Divider = Tab.AddSeparator
        Tab.Popup = Tab.AddDialog
        Tab.Label = Tab.AddLabel
        Tab.ThemeSelector = Tab.AddThemeCompSelector     -- alias retroativo
        Tab.ThemeCompSelector = Tab.AddThemeCompSelector
        Tab.Socials = Tab.AddSocials

        function Tab:Select() ActivateTab() end

        -- AddDivider é o novo nome de AddSection
        Tab.AddDivider = Tab.AddSection

        function Tab:AddSection(sectionConfig)
            sectionConfig = sectionConfig or {}
            local secName = sectionConfig.Name or "Section"

            local SF = Create("Frame", {
                Name = secName, Size = UDim2.new(1, -4, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = Theme.Section, BorderSizePixel = 0,
                LayoutOrder = #TabPage:GetChildren(), ZIndex = 2, Parent = TabPage,
            })
            Corner(SF, 8)

            local SH = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 28), BackgroundColor3 = Theme.SectionHeader,
                BorderSizePixel = 0, ZIndex = 3, Parent = SF,
            })
            Corner(SH, 8)
            -- Preenche cantos inferiores do header para ficarem retos
            Create("Frame", {
                Position = UDim2.new(0, 0, 0.5, 0), Size = UDim2.new(1, 0, 0.5, 0),
                BackgroundColor3 = Theme.SectionHeader, BorderSizePixel = 0, ZIndex = 3, Parent = SH,
            })

            Create("TextLabel", {
                AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0),
                Size = UDim2.new(1, -16, 1, 0), BackgroundTransparency = 1, Text = secName,
                TextColor3 = Theme.TextPrimary, TextSize = 12, Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 4, Parent = SH,
            })

            local SC = Create("Frame", {
                Name = "Content", Position = UDim2.new(0, 0, 0, 28),
                Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1, ZIndex = 2, Parent = SF,
            })
            local SLy2 = ListLayout(SC, Enum.FillDirection.Vertical, 4)
            SLy2.HorizontalAlignment = Enum.HorizontalAlignment.Center
            Padding(SC, 5, 7, 5, 5)

            local sec = MakeComponents(SC)

            -- Alias novos nomes
            sec.Switch = sec.AddToggle
            sec.Action = sec.AddButton
            sec.Choice = sec.AddDropdown
            sec.MultiChoice = sec.AddMultiDropdown
            sec.Range = sec.AddSlider
            sec.Input = sec.AddTextBox
            sec.Palette = sec.AddColorPicker
            sec.Bind = sec.AddKeybind
            sec.Divider = sec.AddSeparator
            sec.Popup = sec.AddDialog
            sec.Label = sec.AddLabel
            sec.ThemeSelector = sec.AddThemeCompSelector     -- alias retroativo
            sec.ThemeCompSelector = sec.AddThemeCompSelector
            sec.Socials = sec.AddSocials

            return sec
        end

        return Tab
    end

    -- Expõe Notify e SetTransparency via Window
    -- Uso: Window:Notify({...}) ou Window:SetTransparency(0.4)

    return Window
end

-- API pública
function ConkersHub:GetFlag(flag)
    return ConkersHub.Flags[flag]
end

return ConkersHub
