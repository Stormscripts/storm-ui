--[[
    ╔══════════════════════════════════════════════╗
    ║         STORM HUB UI LIBRARY  v1.0           ║
    ║         By SeuNome — Roblox Scripts          ║
    ╠══════════════════════════════════════════════╣
    ║  Componentes:                                ║
    ║   Button · Toggle · Slider · Dropdown        ║
    ║   MultiDropdown · Keybind · TextBox          ║
    ║   ColorPicker · Label · Separator · Dialog   ║
    ╠══════════════════════════════════════════════╣
    ║  Layout: sidebar vertical de tabs (esquerda) ║
    ║  Tema: preto + roxo (137, 6, 255)            ║
    ║  Visual baseado no Storm Hub original        ║
    ╠══════════════════════════════════════════════╣
    ║  Uso:                                        ║
    ║   local H = loadstring(...)()               ║
    ║   local W = H:CreateWindow({...})            ║
    ║   local T = W:AddTab({Name="Tab 1"})         ║
    ║   local S = T:AddSection({Name="Combat"})    ║
    ║   S:AddToggle({Name="X", Callback=...})      ║
    ╚══════════════════════════════════════════════╝
--]]

-- ─── Serviços ─────────────────────────────────────────────────────────────────
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- ─── Tema (cores originais do Storm Hub) ──────────────────────────────────────
local Theme = {
    -- Fundos
    Background = Color3.fromRGB(0, 0, 0),
    Sidebar = Color3.fromRGB(0, 0, 0),
    Content = Color3.fromRGB(0, 0, 0),
    Section = Color3.fromRGB(20, 20, 20),
    SectionHeader = Color3.fromRGB(38, 38, 38),
    Element = Color3.fromRGB(58, 58, 58),
    ElementHover = Color3.fromRGB(75, 75, 75),
    ElementPress = Color3.fromRGB(40, 40, 40),

    -- Acento roxo (cor original: 137, 6, 255)
    Accent = Color3.fromRGB(137, 6, 255),
    AccentDark = Color3.fromRGB(100, 4, 190),
    AccentLight = Color3.fromRGB(170, 60, 255),

    -- Tabs
    TabActive = Color3.fromRGB(137, 6, 255),
    TabInactive = Color3.fromRGB(50, 50, 50),

    -- Toggle
    ToggleOn = Color3.fromRGB(137, 6, 255),
    ToggleOff = Color3.fromRGB(123, 123, 123),

    -- Slider
    SliderFill = Color3.fromRGB(137, 6, 255),
    SliderBg = Color3.fromRGB(100, 100, 100),

    -- Texto
    TextPrimary = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(200, 200, 200),
    TextMuted = Color3.fromRGB(140, 140, 140),
    TextAccent = Color3.fromRGB(180, 80, 255),

    -- Bordas / divisores
    Divider = Color3.fromRGB(255, 255, 255),
    Stroke = Color3.fromRGB(80, 80, 80),
    StrokeAccent = Color3.fromRGB(137, 6, 255),
}

-- ─── Fontes (originais do Storm Hub) ──────────────────────────────────────────
-- Usadas no título e nas abas, exatamente como no arquivo original.
local FontLucky  = Font.new("rbxasset://fonts/families/LuckiestGuy.json")
local FontFredoka = Font.new("rbxasset://fonts/families/FredokaOne.json")
local FontZekton = Font.new("rbxasset://fonts/families/Zekton.json")
local FontDenk   = Font.new("rbxasset://fonts/families/DenkOne.json")

-- ─── Utilitários ──────────────────────────────────────────────────────────────
local function Create(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do
        pcall(function() inst[k] = v end)
    end
    return inst
end

local function Tween(inst, t, props, style, dir)
    local info = TweenInfo.new(
        t or 0.2,
        style or Enum.EasingStyle.Quart,
        dir or Enum.EasingDirection.Out
    )
    local tw = TweenService:Create(inst, info, props)
    tw:Play()
    return tw
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
    return p
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

-- ─── Dragging (PC + Mobile) ───────────────────────────────────────────────────
local function MakeDraggable(handle, frame)
    local dragging = false
    local dragStart = nil
    local startPos = nil

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            local vp = workspace.CurrentCamera.ViewportSize
            local nx = math.clamp(startPos.X.Offset + delta.X, -frame.AbsoluteSize.X + 40, vp.X - 40)
            local ny = math.clamp(startPos.Y.Offset + delta.Y, 0, vp.Y - 40)
            frame.Position = UDim2.new(0, nx, 0, ny)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

-- ─── Fechar popup ao clicar fora ──────────────────────────────────────────────
local function CloseOnOutsideClick(getOpen, popup, trigger, closeFn)
    UserInputService.InputBegan:Connect(function(input)
        if not getOpen() then return end
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
        and input.UserInputType ~= Enum.UserInputType.Touch then return end
        local mp = input.Position
        local function inFrame(f)
            local ap = f.AbsolutePosition
            local as = f.AbsoluteSize
            return mp.X >= ap.X and mp.X <= ap.X + as.X
               and mp.Y >= ap.Y and mp.Y <= ap.Y + as.Y
        end
        if not inFrame(popup) and not inFrame(trigger) then closeFn() end
    end)
end

-- ─── Biblioteca ───────────────────────────────────────────────────────────────
local StormHub = {}
StormHub.__index = StormHub
StormHub.Flags = {}
StormHub.Theme = Theme

-- ─── CreateWindow ─────────────────────────────────────────────────────────────
function StormHub:CreateWindow(config)
    config = config or {}
    local hubTitle = config.Title or "Storm Hub"
    local hubBy = config.By or "By SeuNome"
    local hubGame = config.Game or "Jogo"
    local width = config.Width or 460
    local height = config.Height or 330
    local startPos = config.Position or UDim2.new(0.5, -(width / 2), 0.5, -(height / 2))

    -- Proporções (respeitando o layout original: sidebar + divisor + conteúdo)
    local sidebarW = 140
    local topbarH = 62
    local divPx = 1

    -- ScreenGui
    local ScreenGui = Create("ScreenGui", {
        Name = "StormHub",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 999,
        IgnoreGuiInset = true,
    })
    local ok = pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
    if not ok then
        ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end

    -- Overlay para dropdowns/colorpicker (sem clipping, acima de tudo)
    local Overlay = Create("Frame", {
        Name = "StormHubOverlay",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ZIndex = 500,
        Parent = ScreenGui,
    })

    -- Janela principal
    local Main = Create("Frame", {
        Name = "StormHubMain",
        Position = startPos,
        Size = UDim2.new(0, width, 0, height),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        ClipsDescendants = false,
        Parent = ScreenGui,
    })
    Corner(Main, 10)
    Stroke(Main, Theme.Stroke, 1)

    -- Sombra
    Create("ImageLabel", {
        Name = "Shadow",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 6),
        Size = UDim2.new(1, 40, 1, 40),
        BackgroundTransparency = 1,
        Image = "rbxassetid://6015897843",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.4,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49, 49, 450, 450),
        ZIndex = 0,
        Parent = Main,
    })

    -- ── TopBar ────────────────────────────────────────────────────────────────
    local TopBar = Create("Frame", {
        Name = "TopBar",
        Size = UDim2.new(1, 0, 0, topbarH),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        ZIndex = 2,
        Parent = Main,
    })
    Corner(TopBar, 10)

    -- FIX: frame que quadra os cantos inferiores do TopBar.
    -- Ocultado ao minimizar para cantos arredondados ficarem visíveis.
    local TopBarFix = Create("Frame", {
        Name = "CornerFix",
        Position = UDim2.new(0, 0, 0.5, 0),
        Size = UDim2.new(1, 0, 0.5, 0),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        ZIndex = 2,
        Parent = TopBar,
    })

    -- Título principal (LuckiestGuy — igual ao original)
    Create("TextLabel", {
        Name = "HubTitle",
        Position = UDim2.new(0, 14, 0, 4),
        Size = UDim2.new(0.55, 0, 0, 32),
        BackgroundTransparency = 1,
        Text = hubTitle,
        TextColor3 = Theme.Accent,
        TextSize = 26,
        FontFace = FontLucky,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 3,
        Parent = TopBar,
    })

    -- "By SeuNome" (FredokaOne — igual ao original)
    Create("TextLabel", {
        Name = "ByLabel",
        Position = UDim2.new(0, 16, 0, 38),
        Size = UDim2.new(0.4, 0, 0, 18),
        BackgroundTransparency = 1,
        Text = hubBy,
        TextColor3 = Theme.TextMuted,
        TextSize = 13,
        FontFace = FontFredoka,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 3,
        Parent = TopBar,
    })

    -- Nome do jogo (Zekton — igual ao original)
    Create("TextLabel", {
        Name = "GameLabel",
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -42, 0.5, 0),
        Size = UDim2.new(0.28, 0, 1, -10),
        BackgroundTransparency = 1,
        Text = hubGame,
        TextColor3 = Theme.Accent,
        TextSize = 17,
        FontFace = FontZekton,
        TextXAlignment = Enum.TextXAlignment.Right,
        TextWrapped = true,
        ZIndex = 3,
        Parent = TopBar,
    })

    -- Botão minimizar
    local MinBtn = Create("TextButton", {
        Name = "MinBtn",
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
    Stroke(MinBtn, Theme.Stroke, 1)

    MinBtn.MouseEnter:Connect(function()
        Tween(MinBtn, 0.15, {BackgroundColor3 = Theme.Accent, TextColor3 = Theme.TextPrimary})
    end)
    MinBtn.MouseLeave:Connect(function()
        Tween(MinBtn, 0.15, {BackgroundColor3 = Theme.Element, TextColor3 = Theme.TextSecondary})
    end)

    -- Divisor horizontal (linha branca abaixo do TopBar — igual ao original)
    local TopDivider = Create("Frame", {
        Name = "TopDivider",
        Position = UDim2.new(0, 0, 0, topbarH),
        Size = UDim2.new(1, 0, 0, divPx),
        BackgroundColor3 = Theme.Divider,
        BorderSizePixel = 0,
        ZIndex = 2,
        Parent = Main,
    })

    -- ── Body (sidebar + conteúdo) ──────────────────────────────────────────────
    local Body = Create("Frame", {
        Name = "Body",
        Position = UDim2.new(0, 0, 0, topbarH + divPx),
        Size = UDim2.new(1, 0, 1, -(topbarH + divPx)),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        ZIndex = 2,
        Parent = Main,
    })

    -- Sidebar (Frame das Abas — esquerda, igual ao original)
    local Sidebar = Create("ScrollingFrame", {
        Name = "Sidebar",
        Size = UDim2.new(0, sidebarW, 1, 0),
        BackgroundColor3 = Theme.Sidebar,
        BorderSizePixel = 0,
        ScrollBarThickness = 0,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ZIndex = 3,
        Parent = Body,
    })
    local SidebarLayout = ListLayout(Sidebar, Enum.FillDirection.Vertical, 6)
    SidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    Padding(Sidebar, 8, 8, 8, 8)

    SidebarLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Sidebar.CanvasSize = UDim2.new(0, 0, 0, SidebarLayout.AbsoluteContentSize.Y + 16)
    end)

    -- Divisor vertical (Frame do Divisor das Abas e Funções — igual ao original)
    Create("Frame", {
        Name = "SideDiv",
        Position = UDim2.new(0, sidebarW, 0, 0),
        Size = UDim2.new(0, divPx, 1, 0),
        BackgroundColor3 = Theme.Divider,
        BorderSizePixel = 0,
        ZIndex = 2,
        Parent = Body,
    })

    -- Área de conteúdo (Frame das Funções — direita, igual ao original)
    local ContentArea = Create("Frame", {
        Name = "ContentArea",
        Position = UDim2.new(0, sidebarW + divPx, 0, 0),
        Size = UDim2.new(1, -(sidebarW + divPx), 1, 0),
        BackgroundColor3 = Theme.Content,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        ZIndex = 2,
        Parent = Body,
    })

    -- ── Minimizar ─────────────────────────────────────────────────────────────
    local minimized = false
    local fullSize = UDim2.new(0, width, 0, height)
    local miniSize = UDim2.new(0, width, 0, topbarH)

    MinBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            Body.Visible = false
            TopDivider.Visible = false
            TopBarFix.Visible = false
            Tween(Main, 0.3, {Size = miniSize})
            MinBtn.Text = "+"
        else
            TopBarFix.Visible = true
            TopDivider.Visible = true
            Tween(Main, 0.3, {Size = fullSize})
            MinBtn.Text = "─"
            task.delay(0.28, function()
                if not minimized then Body.Visible = true end
            end)
        end
    end)

    MakeDraggable(TopBar, Main)

    -- ── Dialog overlay (compartilhado por toda a janela) ───────────────────────
    local DialogOverlay = Create("Frame", {
        Name = "DialogOverlay",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 1,
        ZIndex = 80,
        Visible = false,
        Parent = Main,
    })
    Corner(DialogOverlay, 10)

    local DialogBox = Create("Frame", {
        Name = "DialogBox",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.65, 0),
        Size = UDim2.new(1, -40, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        BorderSizePixel = 0,
        ZIndex = 81,
        Parent = DialogOverlay,
    })
    Corner(DialogBox, 8)
    Stroke(DialogBox, Theme.StrokeAccent, 1.5)

    -- Barra roxa no topo do dialog
    local DTopBar = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 3),
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
        ZIndex = 82,
        Parent = DialogBox,
    })
    Corner(DTopBar, 3)
    Create("Frame", {
        Position = UDim2.new(0, 0, 0.5, 0),
        Size = UDim2.new(1, 0, 0.5, 0),
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
        ZIndex = 82,
        Parent = DTopBar,
    })

    local DialogInner = Create("Frame", {
        Position = UDim2.new(0, 0, 0, 3),
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        ZIndex = 81,
        Parent = DialogBox,
    })
    local DLayout = ListLayout(DialogInner, Enum.FillDirection.Vertical, 10)
    DLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    Padding(DialogInner, 14, 14, 14, 14)

    Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 26),
        BackgroundTransparency = 1,
        Text = "⚠",
        TextColor3 = Theme.Accent,
        TextSize = 24,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex = 82,
        Parent = DialogInner,
    })

    local DialogText = Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Text = "",
        TextColor3 = Theme.TextSecondary,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex = 82,
        Parent = DialogInner,
    })

    Create("Frame", {
        Size = UDim2.new(1, 0, 0, 1),
        BackgroundColor3 = Theme.Stroke,
        BorderSizePixel = 0,
        ZIndex = 82,
        Parent = DialogInner,
    })

    local DBtnRow = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 32),
        BackgroundTransparency = 1,
        ZIndex = 81,
        Parent = DialogInner,
    })
    local DBtnLayout = ListLayout(DBtnRow, Enum.FillDirection.Horizontal, 8)
    DBtnLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

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
    Stroke(DialogNoBtn, Theme.Stroke, 1)

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

    local dialogConfirmCb = nil

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
        dialogConfirmCb = cfg.Callback or nil
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
        if dialogConfirmCb then dialogConfirmCb() end
    end)
    DialogYesBtn.MouseEnter:Connect(function()
        Tween(DialogYesBtn, 0.15, {BackgroundColor3 = Theme.AccentLight})
    end)
    DialogYesBtn.MouseLeave:Connect(function()
        Tween(DialogYesBtn, 0.15, {BackgroundColor3 = Theme.Accent})
    end)

    -- Fechar dialog ao clicar fora da box
    local DOverlayBtn = Create("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        ZIndex = 80,
        Parent = DialogOverlay,
    })
    DOverlayBtn.MouseButton1Click:Connect(function()
        local mp = UserInputService:GetMouseLocation()
        local ap = DialogBox.AbsolutePosition
        local as = DialogBox.AbsoluteSize
        local inBox = mp.X >= ap.X and mp.X <= ap.X + as.X
            and mp.Y >= ap.Y and mp.Y <= ap.Y + as.Y
        if not inBox then CloseDialog() end
    end)

    -- ── Objeto Window ─────────────────────────────────────────────────────────
    local Window = {}
    local tabs = {}
    local activeTab = nil

    function Window:Destroy()
        ScreenGui:Destroy()
    end

    -- ── AddTab ────────────────────────────────────────────────────────────────
    function Window:AddTab(tabConfig)
        tabConfig = tabConfig or {}
        local tabName = tabConfig.Name or ("Tab " .. (#tabs + 1))

        -- Botão de tab na sidebar (DenkOne — igual ao original)
        local TabBtn = Create("TextButton", {
            Name = tabName,
            Size = UDim2.new(1, 0, 0, 34),
            BackgroundColor3 = Theme.TabInactive,
            BorderSizePixel = 0,
            Text = tabName,
            TextColor3 = Theme.TextPrimary,
            TextSize = 14,
            FontFace = FontDenk,
            ZIndex = 4,
            Parent = Sidebar,
        })
        Corner(TabBtn, 6)

        -- Página scrollável (ScrollingFrame das Abas — direita)
        local TabPage = Create("ScrollingFrame", {
            Name = tabName .. "Page",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Theme.Accent,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Visible = false,
            ZIndex = 2,
            Parent = ContentArea,
        })
        local PageLayout = ListLayout(TabPage, Enum.FillDirection.Vertical, 6)
        PageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        Padding(TabPage, 8, 8, 6, 6)

        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabPage.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 14)
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

        local Tab = {}
        table.insert(tabs, Tab)

        function Tab:Select() ActivateTab() end

        -- ── AddSection ────────────────────────────────────────────────────────
        function Tab:AddSection(sectionConfig)
            sectionConfig = sectionConfig or {}
            local secName = sectionConfig.Name or "Section"

            local SectionFrame = Create("Frame", {
                Name = secName,
                Size = UDim2.new(1, -8, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = Theme.Section,
                BorderSizePixel = 0,
                LayoutOrder = #TabPage:GetChildren(),
                ZIndex = 2,
                Parent = TabPage,
            })
            Corner(SectionFrame, 8)
            Stroke(SectionFrame, Theme.Stroke, 1)

            -- Cabeçalho da seção (TextLabel da Section — como no original)
            local SecHeader = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 30),
                BackgroundColor3 = Theme.SectionHeader,
                BorderSizePixel = 0,
                ZIndex = 3,
                Parent = SectionFrame,
            })
            Corner(SecHeader, 8)
            Create("Frame", {
                Position = UDim2.new(0, 0, 0.5, 0),
                Size = UDim2.new(1, 0, 0.5, 0),
                BackgroundColor3 = Theme.SectionHeader,
                BorderSizePixel = 0,
                ZIndex = 3,
                Parent = SecHeader,
            })

            -- Barra roxa vertical (acento da seção)
            local SecAccent = Create("Frame", {
                AnchorPoint = Vector2.new(0, 0.5),
                Position = UDim2.new(0, 8, 0.5, 0),
                Size = UDim2.new(0, 3, 0, 16),
                BackgroundColor3 = Theme.Accent,
                BorderSizePixel = 0,
                ZIndex = 4,
                Parent = SecHeader,
            })
            Corner(SecAccent, 2)

            Create("TextLabel", {
                AnchorPoint = Vector2.new(0, 0.5),
                Position = UDim2.new(0, 18, 0.5, 0),
                Size = UDim2.new(1, -22, 1, 0),
                BackgroundTransparency = 1,
                Text = secName,
                TextColor3 = Theme.TextPrimary,
                TextSize = 13,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 4,
                Parent = SecHeader,
            })

            -- Conteúdo da seção
            local SecContent = Create("Frame", {
                Name = "Content",
                Position = UDim2.new(0, 0, 0, 31),
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                ZIndex = 2,
                Parent = SectionFrame,
            })
            local SecLayout = ListLayout(SecContent, Enum.FillDirection.Vertical, 4)
            SecLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            Padding(SecContent, 6, 8, 6, 6)

            local Section = {}
            local elOrder = 0
            local function NextOrder()
                elOrder = elOrder + 1
                return elOrder
            end

            -- ── Button ────────────────────────────────────────────────────────
            -- Visual: fundo cinza + ícone roxo ▶ à direita (como no original)
            function Section:AddButton(cfg)
                cfg = cfg or {}
                local name = cfg.Name or "Button"
                local desc = cfg.Desc or cfg.Description or ""
                local callback = cfg.Callback or function() end
                local hasDesc = desc ~= ""

                local Btn = Create("TextButton", {
                    Size = UDim2.new(1, 0, 0, hasDesc and 42 or 34),
                    BackgroundColor3 = Theme.Element,
                    BorderSizePixel = 0,
                    Text = "",
                    LayoutOrder = NextOrder(),
                    ZIndex = 3,
                    Parent = SecContent,
                })
                Corner(Btn, 6)
                Stroke(Btn, Theme.Stroke, 1)

                -- Ícone roxo à direita (como "ícone de mão hitbox" do original)
                local IconBox = Create("Frame", {
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, -6, 0.5, 0),
                    Size = UDim2.new(0, 26, 0, 26),
                    BackgroundColor3 = Theme.Accent,
                    BorderSizePixel = 0,
                    ZIndex = 4,
                    Parent = Btn,
                })
                Corner(IconBox, 6)
                Create("TextLabel", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = "▶",
                    TextColor3 = Theme.TextPrimary,
                    TextSize = 12,
                    Font = Enum.Font.GothamBold,
                    ZIndex = 5,
                    Parent = IconBox,
                })

                Create("TextLabel", {
                    AnchorPoint = Vector2.new(0, hasDesc and 0 or 0.5),
                    Position = UDim2.new(0, 8, hasDesc and 0 or 0.5, hasDesc and 6 or 0),
                    Size = UDim2.new(1, -44, 0, 14),
                    BackgroundTransparency = 1,
                    Text = name,
                    TextColor3 = Theme.TextPrimary,
                    TextSize = 13,
                    Font = Enum.Font.GothamSemibold,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 4,
                    Parent = Btn,
                })

                if hasDesc then
                    Create("TextLabel", {
                        Position = UDim2.new(0, 8, 0, 23),
                        Size = UDim2.new(1, -44, 0, 12),
                        BackgroundTransparency = 1,
                        Text = desc,
                        TextColor3 = Theme.TextMuted,
                        TextSize = 11,
                        Font = Enum.Font.Gotham,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        ZIndex = 4,
                        Parent = Btn,
                    })
                end

                Btn.MouseEnter:Connect(function()
                    Tween(Btn, 0.15, {BackgroundColor3 = Theme.ElementHover})
                end)
                Btn.MouseLeave:Connect(function()
                    Tween(Btn, 0.15, {BackgroundColor3 = Theme.Element})
                end)
                Btn.MouseButton1Down:Connect(function()
                    Tween(Btn, 0.1, {BackgroundColor3 = Theme.ElementPress})
                end)
                Btn.MouseButton1Up:Connect(function()
                    Tween(Btn, 0.1, {BackgroundColor3 = Theme.ElementHover})
                end)
                Btn.MouseButton1Click:Connect(function()
                    callback()
                end)
            end

            -- ── Toggle ────────────────────────────────────────────────────────
            -- Visual: "Frame do Corpinho do Toggle" + "Frame da Cabeça do Toggle"
            function Section:AddToggle(cfg)
                cfg = cfg or {}
                local name = cfg.Name or "Toggle"
                local default = cfg.Default or false
                local flag = cfg.Flag
                local callback = cfg.Callback or function() end
                local desc = cfg.Description or ""
                local hasDesc = desc ~= ""

                local state = default
                if flag then StormHub.Flags[flag] = state end

                local Row = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, hasDesc and 50 or 34),
                    BackgroundColor3 = state and Color3.fromRGB(30, 10, 50) or Theme.Element,
                    BorderSizePixel = 0,
                    LayoutOrder = NextOrder(),
                    ZIndex = 3,
                    Parent = SecContent,
                })
                Corner(Row, 6)
                Stroke(Row, Theme.Stroke, 1)

                Create("TextLabel", {
                    AnchorPoint = Vector2.new(0, hasDesc and 0 or 0.5),
                    Position = hasDesc and UDim2.new(0, 8, 0, 9) or UDim2.new(0, 8, 0.5, 0),
                    Size = UDim2.new(1, -64, 0, 14),
                    BackgroundTransparency = 1,
                    Text = name,
                    TextColor3 = Theme.TextPrimary,
                    TextSize = 13,
                    Font = Enum.Font.GothamSemibold,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 4,
                    Parent = Row,
                })

                if hasDesc then
                    Create("TextLabel", {
                        Position = UDim2.new(0, 8, 0, 26),
                        Size = UDim2.new(1, -64, 0, 13),
                        BackgroundTransparency = 1,
                        Text = desc,
                        TextColor3 = Theme.TextMuted,
                        TextSize = 11,
                        Font = Enum.Font.Gotham,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        ZIndex = 4,
                        Parent = Row,
                    })
                end

                -- Switch (corpo + cabeça, como no original)
                local SwitchBg = Create("Frame", {
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, -8, 0.5, 0),
                    Size = UDim2.new(0, 44, 0, 22),
                    BackgroundColor3 = state and Theme.ToggleOn or Theme.ToggleOff,
                    BorderSizePixel = 0,
                    ZIndex = 4,
                    Parent = Row,
                })
                Corner(SwitchBg, 11)

                local SwitchKnob = Create("Frame", {
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = state and UDim2.new(1, -20, 0.5, 0) or UDim2.new(0, 2, 0.5, 0),
                    Size = UDim2.new(0, 18, 0, 18),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BorderSizePixel = 0,
                    ZIndex = 5,
                    Parent = SwitchBg,
                })
                Corner(SwitchKnob, 9)

                local function DoToggle()
                    state = not state
                    if flag then StormHub.Flags[flag] = state end
                    Tween(SwitchBg, 0.2, {BackgroundColor3 = state and Theme.ToggleOn or Theme.ToggleOff})
                    Tween(SwitchKnob, 0.2, {
                        Position = state and UDim2.new(1, -20, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
                    })
                    Tween(Row, 0.2, {
                        BackgroundColor3 = state and Color3.fromRGB(30, 10, 50) or Theme.Element
                    })
                    callback(state)
                end

                local ClickBtn = Create("TextButton", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = "",
                    ZIndex = 6,
                    Parent = Row,
                })
                ClickBtn.MouseButton1Click:Connect(DoToggle)
                ClickBtn.MouseEnter:Connect(function()
                    if not state then Tween(Row, 0.15, {BackgroundColor3 = Theme.ElementHover}) end
                end)
                ClickBtn.MouseLeave:Connect(function()
                    if not state then Tween(Row, 0.15, {BackgroundColor3 = Theme.Element}) end
                end)

                local ToggleObj = {}
                function ToggleObj:Set(v)
                    if v ~= state then DoToggle() end
                end
                function ToggleObj:Get() return state end
                return ToggleObj
            end

            -- ── Slider ────────────────────────────────────────────────────────
            -- Visual: "Frame do Corpinho do Slider" + "Frame da Cabeça" + caixa de valor
            function Section:AddSlider(cfg)
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
                if flag then StormHub.Flags[flag] = value end

                local Container = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, hasDesc and 54 or 40),
                    BackgroundColor3 = Theme.Element,
                    BorderSizePixel = 0,
                    LayoutOrder = NextOrder(),
                    ZIndex = 3,
                    Parent = SecContent,
                })
                Corner(Container, 6)
                Stroke(Container, Theme.Stroke, 1)

                Create("TextLabel", {
                    Position = UDim2.new(0, 8, 0, 5),
                    Size = UDim2.new(0.55, 0, 0, 14),
                    BackgroundTransparency = 1,
                    Text = name,
                    TextColor3 = Theme.TextPrimary,
                    TextSize = 13,
                    Font = Enum.Font.GothamSemibold,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 4,
                    Parent = Container,
                })

                if hasDesc then
                    Create("TextLabel", {
                        Position = UDim2.new(0, 8, 0, 21),
                        Size = UDim2.new(1, -20, 0, 11),
                        BackgroundTransparency = 1,
                        Text = desc,
                        TextColor3 = Theme.TextMuted,
                        TextSize = 11,
                        Font = Enum.Font.Gotham,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        ZIndex = 4,
                        Parent = Container,
                    })
                end

                -- Caixa de valor (Frame Indicador do Valor — como no original)
                local ValBox = Create("Frame", {
                    AnchorPoint = Vector2.new(1, 0),
                    Position = UDim2.new(1, -8, 0, 4),
                    Size = UDim2.new(0, 52, 0, 16),
                    BackgroundColor3 = Color3.fromRGB(80, 80, 80),
                    BorderSizePixel = 0,
                    ZIndex = 4,
                    Parent = Container,
                })
                Corner(ValBox, 4)

                local ValLabel = Create("TextLabel", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = tostring(value) .. suffix,
                    TextColor3 = Theme.TextPrimary,
                    TextSize = 11,
                    Font = Enum.Font.GothamBold,
                    ZIndex = 5,
                    Parent = ValBox,
                })

                -- Track (Frame do Corpinho do Slider — como no original)
                local Track = Create("Frame", {
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 8, 1, -8),
                    Size = UDim2.new(1, -16, 0, 6),
                    BackgroundColor3 = Theme.SliderBg,
                    BorderSizePixel = 0,
                    ZIndex = 4,
                    Parent = Container,
                })
                Corner(Track, 3)

                local pct0 = (value - min) / (max - min)

                local Fill = Create("Frame", {
                    Size = UDim2.new(pct0, 0, 1, 0),
                    BackgroundColor3 = Theme.SliderFill,
                    BorderSizePixel = 0,
                    ZIndex = 5,
                    Parent = Track,
                })
                Corner(Fill, 3)

                -- Cabeça do slider (Frame da Cabeça do Slider — como no original)
                local Knob = Create("Frame", {
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(pct0, 0, 0.5, 0),
                    Size = UDim2.new(0, 14, 0, 14),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BorderSizePixel = 0,
                    ZIndex = 6,
                    Parent = Track,
                })
                Corner(Knob, 7)
                Stroke(Knob, Theme.Accent, 2)

                local sliding = false

                local function UpdateSlider(inputX)
                    local ts = Track.AbsoluteSize.X
                    if ts == 0 then return end
                    local rel = math.clamp((inputX - Track.AbsolutePosition.X) / ts, 0, 1)
                    local raw = min + (max - min) * rel
                    value = math.clamp(math.floor(raw / increment + 0.5) * increment, min, max)
                    local pct = (value - min) / (max - min)
                    if flag then StormHub.Flags[flag] = value end
                    Fill.Size = UDim2.new(pct, 0, 1, 0)
                    Knob.Position = UDim2.new(pct, 0, 0.5, 0)
                    ValLabel.Text = tostring(value) .. suffix
                    callback(value)
                end

                Track.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1
                    or input.UserInputType == Enum.UserInputType.Touch then
                        sliding = true
                        UpdateSlider(input.Position.X)
                    end
                end)
                UserInputService.InputChanged:Connect(function(input)
                    if not sliding then return end
                    if input.UserInputType == Enum.UserInputType.MouseMovement
                    or input.UserInputType == Enum.UserInputType.Touch then
                        UpdateSlider(input.Position.X)
                    end
                end)
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1
                    or input.UserInputType == Enum.UserInputType.Touch then
                        sliding = false
                    end
                end)

                local SliderObj = {}
                function SliderObj:Set(v)
                    value = math.clamp(v, min, max)
                    local pct = (value - min) / (max - min)
                    if flag then StormHub.Flags[flag] = value end
                    Fill.Size = UDim2.new(pct, 0, 1, 0)
                    Knob.Position = UDim2.new(pct, 0, 0.5, 0)
                    ValLabel.Text = tostring(value) .. suffix
                    callback(value)
                end
                function SliderObj:Get() return value end
                return SliderObj
            end

            -- ── Dropdown ──────────────────────────────────────────────────────
            -- Popup parented ao Overlay (não sofre clipping do ScrollingFrame)
            function Section:AddDropdown(cfg)
                cfg = cfg or {}
                local name = cfg.Name or "Dropdown"
                local options = cfg.Options or {}
                local default = cfg.Default or options[1] or "None"
                local flag = cfg.Flag
                local callback = cfg.Callback or function() end
                local desc = cfg.Description or ""
                local hasDesc = desc ~= ""

                local selected = default
                if flag then StormHub.Flags[flag] = selected end

                local Container = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, hasDesc and 50 or 34),
                    BackgroundColor3 = Theme.Element,
                    BorderSizePixel = 0,
                    LayoutOrder = NextOrder(),
                    ZIndex = 3,
                    Parent = SecContent,
                })
                Corner(Container, 6)
                Stroke(Container, Theme.Stroke, 1)

                Create("TextLabel", {
                    AnchorPoint = Vector2.new(0, hasDesc and 0 or 0.5),
                    Position = hasDesc and UDim2.new(0, 8, 0, 9) or UDim2.new(0, 8, 0.5, 0),
                    Size = UDim2.new(0.45, 0, 0, 14),
                    BackgroundTransparency = 1,
                    Text = name,
                    TextColor3 = Theme.TextPrimary,
                    TextSize = 13,
                    Font = Enum.Font.GothamSemibold,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 4,
                    Parent = Container,
                })

                if hasDesc then
                    Create("TextLabel", {
                        Position = UDim2.new(0, 8, 0, 26),
                        Size = UDim2.new(0.6, 0, 0, 12),
                        BackgroundTransparency = 1,
                        Text = desc,
                        TextColor3 = Theme.TextMuted,
                        TextSize = 11,
                        Font = Enum.Font.Gotham,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        ZIndex = 4,
                        Parent = Container,
                    })
                end

                local SelLabel = Create("TextLabel", {
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, -24, 0.5, 0),
                    Size = UDim2.new(0.5, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = tostring(selected),
                    TextColor3 = Theme.TextAccent,
                    TextSize = 12,
                    Font = Enum.Font.GothamSemibold,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    ZIndex = 4,
                    Parent = Container,
                })

                local ArrowLbl = Create("TextLabel", {
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, -6, 0.5, 0),
                    Size = UDim2.new(0, 16, 0, 16),
                    BackgroundTransparency = 1,
                    Text = "▾",
                    TextColor3 = Theme.TextMuted,
                    TextSize = 14,
                    Font = Enum.Font.GothamBold,
                    ZIndex = 4,
                    Parent = Container,
                })

                local List = Create("ScrollingFrame", {
                    Size = UDim2.new(0, 0, 0, 0),
                    BackgroundColor3 = Color3.fromRGB(25, 25, 25),
                    BorderSizePixel = 0,
                    ZIndex = 501,
                    ScrollBarThickness = 2,
                    ScrollBarImageColor3 = Theme.Accent,
                    CanvasSize = UDim2.new(0, 0, 0, 0),
                    ClipsDescendants = true,
                    Visible = false,
                    Parent = Overlay,
                })
                Corner(List, 6)
                Stroke(List, Theme.StrokeAccent, 1)

                local ListInner = ListLayout(List, Enum.FillDirection.Vertical, 2)
                Padding(List, 4, 4, 4, 4)
                ListInner:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    List.CanvasSize = UDim2.new(0, 0, 0, ListInner.AbsoluteContentSize.Y + 8)
                end)

                local listOpen = false

                local function CloseList()
                    listOpen = false
                    Tween(List, 0.2, {Size = UDim2.new(0, List.AbsoluteSize.X, 0, 0)})
                    Tween(ArrowLbl, 0.2, {Rotation = 0})
                    task.delay(0.2, function() List.Visible = false end)
                end

                local function BuildList()
                    for _, c in ipairs(List:GetChildren()) do
                        if c:IsA("TextButton") then c:Destroy() end
                    end
                    for _, opt in ipairs(options) do
                        local isActive = tostring(opt) == tostring(selected)
                        local OptBtn = Create("TextButton", {
                            Size = UDim2.new(1, 0, 0, 28),
                            BackgroundColor3 = isActive and Theme.AccentDark or Color3.fromRGB(50, 50, 50),
                            BorderSizePixel = 0,
                            Text = tostring(opt),
                            TextColor3 = isActive and Theme.TextPrimary or Theme.TextSecondary,
                            TextSize = 12,
                            Font = Enum.Font.Gotham,
                            ZIndex = 502,
                            Parent = List,
                        })
                        Corner(OptBtn, 5)
                        if isActive then Stroke(OptBtn, Theme.Accent, 1) end

                        OptBtn.MouseEnter:Connect(function()
                            if not isActive then
                                Tween(OptBtn, 0.1, {BackgroundColor3 = Color3.fromRGB(70, 70, 70)})
                            end
                        end)
                        OptBtn.MouseLeave:Connect(function()
                            if not isActive then
                                Tween(OptBtn, 0.1, {BackgroundColor3 = Color3.fromRGB(50, 50, 50)})
                            end
                        end)
                        OptBtn.MouseButton1Click:Connect(function()
                            selected = opt
                            if flag then StormHub.Flags[flag] = selected end
                            SelLabel.Text = tostring(selected)
                            BuildList()
                            CloseList()
                            callback(selected)
                        end)
                    end
                end
                BuildList()

                local function OpenList()
                    listOpen = true
                    local ap = Container.AbsolutePosition
                    local as = Container.AbsoluteSize
                    local targetH = math.min(#options * 32 + 8, 160)
                    List.Position = UDim2.new(0, ap.X, 0, ap.Y + as.Y + 4)
                    List.Size = UDim2.new(0, as.X, 0, 0)
                    List.Visible = true
                    Tween(List, 0.22, {Size = UDim2.new(0, as.X, 0, targetH)})
                    Tween(ArrowLbl, 0.2, {Rotation = 180})
                end

                CloseOnOutsideClick(function() return listOpen end, List, Container, CloseList)

                local CBtn = Create("TextButton", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = "",
                    ZIndex = 5,
                    Parent = Container,
                })
                CBtn.MouseButton1Click:Connect(function()
                    if listOpen then CloseList() else OpenList() end
                end)
                CBtn.MouseEnter:Connect(function()
                    Tween(Container, 0.15, {BackgroundColor3 = Theme.ElementHover})
                end)
                CBtn.MouseLeave:Connect(function()
                    Tween(Container, 0.15, {BackgroundColor3 = Theme.Element})
                end)

                local DropObj = {}
                function DropObj:Set(v)
                    selected = v
                    if flag then StormHub.Flags[flag] = v end
                    SelLabel.Text = tostring(v)
                    BuildList()
                    callback(v)
                end
                function DropObj:SetOptions(newOpts) options = newOpts; BuildList() end
                function DropObj:Get() return selected end
                return DropObj
            end

            -- ── MultiDropdown ─────────────────────────────────────────────────
            function Section:AddMultiDropdown(cfg)
                cfg = cfg or {}
                local name = cfg.Name or "Multi Select"
                local options = cfg.Options or {}
                local defaults = cfg.Default or {}
                local flag = cfg.Flag
                local callback = cfg.Callback or function() end
                local desc = cfg.Description or ""
                local hasDesc = desc ~= ""

                local selected = {}
                for _, v in ipairs(defaults) do selected[v] = true end
                if flag then StormHub.Flags[flag] = selected end

                local function DisplayText()
                    local n = 0
                    for _ in pairs(selected) do n = n + 1 end
                    if n == 0 then return "Nenhum" end
                    return n .. " selecionado" .. (n > 1 and "s" or "")
                end

                local Container = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, hasDesc and 50 or 34),
                    BackgroundColor3 = Theme.Element,
                    BorderSizePixel = 0,
                    LayoutOrder = NextOrder(),
                    ZIndex = 3,
                    Parent = SecContent,
                })
                Corner(Container, 6)
                Stroke(Container, Theme.Stroke, 1)

                Create("TextLabel", {
                    AnchorPoint = Vector2.new(0, hasDesc and 0 or 0.5),
                    Position = hasDesc and UDim2.new(0, 8, 0, 9) or UDim2.new(0, 8, 0.5, 0),
                    Size = UDim2.new(0.45, 0, 0, 14),
                    BackgroundTransparency = 1,
                    Text = name,
                    TextColor3 = Theme.TextPrimary,
                    TextSize = 13,
                    Font = Enum.Font.GothamSemibold,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 4,
                    Parent = Container,
                })

                if hasDesc then
                    Create("TextLabel", {
                        Position = UDim2.new(0, 8, 0, 26),
                        Size = UDim2.new(0.6, 0, 0, 12),
                        BackgroundTransparency = 1,
                        Text = desc,
                        TextColor3 = Theme.TextMuted,
                        TextSize = 11,
                        Font = Enum.Font.Gotham,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        ZIndex = 4,
                        Parent = Container,
                    })
                end

                local SelLabel = Create("TextLabel", {
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, -24, 0.5, 0),
                    Size = UDim2.new(0.5, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = DisplayText(),
                    TextColor3 = Theme.TextAccent,
                    TextSize = 11,
                    Font = Enum.Font.GothamSemibold,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    ZIndex = 4,
                    Parent = Container,
                })

                local ArrowLbl = Create("TextLabel", {
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, -6, 0.5, 0),
                    Size = UDim2.new(0, 16, 0, 16),
                    BackgroundTransparency = 1,
                    Text = "▾",
                    TextColor3 = Theme.TextMuted,
                    TextSize = 14,
                    Font = Enum.Font.GothamBold,
                    ZIndex = 4,
                    Parent = Container,
                })

                local List = Create("ScrollingFrame", {
                    Size = UDim2.new(0, 0, 0, 0),
                    BackgroundColor3 = Color3.fromRGB(25, 25, 25),
                    BorderSizePixel = 0,
                    ZIndex = 501,
                    ScrollBarThickness = 2,
                    ScrollBarImageColor3 = Theme.Accent,
                    CanvasSize = UDim2.new(0, 0, 0, 0),
                    ClipsDescendants = true,
                    Visible = false,
                    Parent = Overlay,
                })
                Corner(List, 6)
                Stroke(List, Theme.StrokeAccent, 1)

                local LL = ListLayout(List, Enum.FillDirection.Vertical, 2)
                Padding(List, 4, 4, 4, 4)
                LL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    List.CanvasSize = UDim2.new(0, 0, 0, LL.AbsoluteContentSize.Y + 8)
                end)

                local listOpen = false

                local function CloseMulti()
                    listOpen = false
                    Tween(List, 0.2, {Size = UDim2.new(0, List.AbsoluteSize.X, 0, 0)})
                    Tween(ArrowLbl, 0.2, {Rotation = 0})
                    task.delay(0.2, function() List.Visible = false end)
                end

                local function BuildMulti()
                    for _, c in ipairs(List:GetChildren()) do
                        if c:IsA("Frame") then c:Destroy() end
                    end
                    for _, opt in ipairs(options) do
                        local isSel = selected[opt] == true
                        local Row = Create("Frame", {
                            Size = UDim2.new(1, 0, 0, 28),
                            BackgroundColor3 = isSel and Theme.AccentDark or Color3.fromRGB(50, 50, 50),
                            BorderSizePixel = 0,
                            ZIndex = 502,
                            Parent = List,
                        })
                        Corner(Row, 5)
                        if isSel then Stroke(Row, Theme.Accent, 1) end

                        local CheckBg = Create("Frame", {
                            AnchorPoint = Vector2.new(0, 0.5),
                            Position = UDim2.new(0, 6, 0.5, 0),
                            Size = UDim2.new(0, 16, 0, 16),
                            BackgroundColor3 = isSel and Theme.Accent or Color3.fromRGB(80, 80, 80),
                            BorderSizePixel = 0,
                            ZIndex = 503,
                            Parent = Row,
                        })
                        Corner(CheckBg, 4)

                        if isSel then
                            Create("TextLabel", {
                                Size = UDim2.new(1, 0, 1, 0),
                                BackgroundTransparency = 1,
                                Text = "✓",
                                TextColor3 = Color3.fromRGB(255, 255, 255),
                                TextSize = 11,
                                Font = Enum.Font.GothamBold,
                                ZIndex = 504,
                                Parent = CheckBg,
                            })
                        end

                        Create("TextLabel", {
                            AnchorPoint = Vector2.new(0, 0.5),
                            Position = UDim2.new(0, 28, 0.5, 0),
                            Size = UDim2.new(1, -34, 1, 0),
                            BackgroundTransparency = 1,
                            Text = tostring(opt),
                            TextColor3 = isSel and Theme.TextPrimary or Theme.TextSecondary,
                            TextSize = 12,
                            Font = Enum.Font.Gotham,
                            TextXAlignment = Enum.TextXAlignment.Left,
                            ZIndex = 503,
                            Parent = Row,
                        })

                        local RowBtn = Create("TextButton", {
                            Size = UDim2.new(1, 0, 1, 0),
                            BackgroundTransparency = 1,
                            Text = "",
                            ZIndex = 504,
                            Parent = Row,
                        })
                        RowBtn.MouseButton1Click:Connect(function()
                            selected[opt] = not selected[opt]
                            if flag then StormHub.Flags[flag] = selected end
                            SelLabel.Text = DisplayText()
                            BuildMulti()
                            callback(selected)
                        end)
                    end
                end
                BuildMulti()

                local function OpenMulti()
                    listOpen = true
                    local ap = Container.AbsolutePosition
                    local as = Container.AbsoluteSize
                    local targetH = math.min(#options * 32 + 8, 170)
                    List.Position = UDim2.new(0, ap.X, 0, ap.Y + as.Y + 4)
                    List.Size = UDim2.new(0, as.X, 0, 0)
                    List.Visible = true
                    Tween(List, 0.22, {Size = UDim2.new(0, as.X, 0, targetH)})
                    Tween(ArrowLbl, 0.2, {Rotation = 180})
                end

                CloseOnOutsideClick(function() return listOpen end, List, Container, CloseMulti)

                local CBtn = Create("TextButton", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = "",
                    ZIndex = 5,
                    Parent = Container,
                })
                CBtn.MouseButton1Click:Connect(function()
                    if listOpen then CloseMulti() else OpenMulti() end
                end)
                CBtn.MouseEnter:Connect(function()
                    Tween(Container, 0.15, {BackgroundColor3 = Theme.ElementHover})
                end)
                CBtn.MouseLeave:Connect(function()
                    Tween(Container, 0.15, {BackgroundColor3 = Theme.Element})
                end)

                local MultiObj = {}
                function MultiObj:GetSelected()
                    local out = {}
                    for k, v in pairs(selected) do
                        if v then table.insert(out, k) end
                    end
                    return out
                end
                function MultiObj:SetSelected(tbl)
                    selected = {}
                    for _, v in ipairs(tbl) do selected[v] = true end
                    if flag then StormHub.Flags[flag] = selected end
                    SelLabel.Text = DisplayText()
                    BuildMulti()
                end
                return MultiObj
            end

            -- ── Keybind ───────────────────────────────────────────────────────
            function Section:AddKeybind(cfg)
                cfg = cfg or {}
                local name = cfg.Name or "Keybind"
                local default = cfg.Default or Enum.KeyCode.Unknown
                local flag = cfg.Flag
                local callback = cfg.Callback or function() end

                local currentKey = default
                local listening = false
                if flag then StormHub.Flags[flag] = currentKey end

                local abbr = {
                    LeftControl = "LCtrl", RightControl = "RCtrl",
                    LeftShift = "LShift", RightShift = "RShift",
                    LeftAlt = "LAlt", RightAlt = "RAlt",
                    Return = "Enter", BackSpace = "Backsp",
                }
                local function KeyStr(k)
                    if k == Enum.KeyCode.Unknown then return "Nenhum" end
                    local s = tostring(k):gsub("Enum%.KeyCode%.", "")
                    return abbr[s] or s
                end

                local Row = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 34),
                    BackgroundColor3 = Theme.Element,
                    BorderSizePixel = 0,
                    LayoutOrder = NextOrder(),
                    ZIndex = 3,
                    Parent = SecContent,
                })
                Corner(Row, 6)
                Stroke(Row, Theme.Stroke, 1)

                Create("TextLabel", {
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, 8, 0.5, 0),
                    Size = UDim2.new(1, -86, 1, 0),
                    BackgroundTransparency = 1,
                    Text = name,
                    TextColor3 = Theme.TextPrimary,
                    TextSize = 13,
                    Font = Enum.Font.GothamSemibold,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 4,
                    Parent = Row,
                })

                local Badge = Create("Frame", {
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, -6, 0.5, 0),
                    Size = UDim2.new(0, 72, 0, 22),
                    BackgroundColor3 = Color3.fromRGB(38, 38, 38),
                    BorderSizePixel = 0,
                    ZIndex = 4,
                    Parent = Row,
                })
                Corner(Badge, 5)
                Stroke(Badge, Theme.Stroke, 1)

                local KeyLbl = Create("TextLabel", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = KeyStr(currentKey),
                    TextColor3 = Theme.TextAccent,
                    TextSize = 11,
                    Font = Enum.Font.GothamSemibold,
                    ZIndex = 5,
                    Parent = Badge,
                })

                local function SetListening(v)
                    listening = v
                    if listening then
                        KeyLbl.Text = "..."
                        Tween(Badge, 0.2, {BackgroundColor3 = Theme.AccentDark})
                        Tween(KeyLbl, 0.2, {TextColor3 = Theme.TextPrimary})
                    else
                        KeyLbl.Text = KeyStr(currentKey)
                        Tween(Badge, 0.2, {BackgroundColor3 = Color3.fromRGB(38, 38, 38)})
                        Tween(KeyLbl, 0.2, {TextColor3 = Theme.TextAccent})
                    end
                end

                local CBtn = Create("TextButton", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = "",
                    ZIndex = 6,
                    Parent = Row,
                })
                CBtn.MouseButton1Click:Connect(function()
                    SetListening(not listening)
                end)
                CBtn.MouseEnter:Connect(function()
                    Tween(Row, 0.15, {BackgroundColor3 = Theme.ElementHover})
                end)
                CBtn.MouseLeave:Connect(function()
                    Tween(Row, 0.15, {BackgroundColor3 = Theme.Element})
                end)

                UserInputService.InputBegan:Connect(function(input, gpe)
                    if gpe then return end
                    if listening then
                        if input.UserInputType == Enum.UserInputType.Keyboard then
                            currentKey = input.KeyCode
                            if flag then StormHub.Flags[flag] = currentKey end
                            SetListening(false)
                            callback(currentKey)
                        end
                    else
                        if input.KeyCode == currentKey then
                            callback(currentKey)
                        end
                    end
                end)

                local KeyObj = {}
                function KeyObj:Set(key)
                    currentKey = key
                    if flag then StormHub.Flags[flag] = key end
                    KeyLbl.Text = KeyStr(key)
                end
                function KeyObj:Get() return currentKey end
                return KeyObj
            end

            -- ── TextBox ───────────────────────────────────────────────────────
            -- Visual: label à esquerda + campo de digitação à direita
            -- (como "Frame doLugarDeDigitar" do original)
            function Section:AddTextBox(cfg)
                cfg = cfg or {}
                local name = cfg.Name or "TextBox"
                local holder = cfg.Placeholder or "Digite aqui..."
                local default = cfg.Default or ""
                local numeric = cfg.Numeric or false
                local flag = cfg.Flag
                local callback = cfg.Callback or function() end
                local desc = cfg.Description or ""
                local hasDesc = desc ~= ""

                if flag then StormHub.Flags[flag] = default end

                local Container = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, hasDesc and 54 or 40),
                    BackgroundColor3 = Theme.Element,
                    BorderSizePixel = 0,
                    LayoutOrder = NextOrder(),
                    ZIndex = 3,
                    Parent = SecContent,
                })
                Corner(Container, 6)
                Stroke(Container, Theme.Stroke, 1)

                Create("TextLabel", {
                    Position = UDim2.new(0, 8, 0, 5),
                    Size = UDim2.new(0.5, 0, 0, 14),
                    BackgroundTransparency = 1,
                    Text = name,
                    TextColor3 = Theme.TextPrimary,
                    TextSize = 13,
                    Font = Enum.Font.GothamSemibold,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 4,
                    Parent = Container,
                })

                if hasDesc then
                    Create("TextLabel", {
                        Position = UDim2.new(0, 8, 0, 21),
                        Size = UDim2.new(0.55, 0, 0, 11),
                        BackgroundTransparency = 1,
                        Text = desc,
                        TextColor3 = Theme.TextMuted,
                        TextSize = 11,
                        Font = Enum.Font.Gotham,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        ZIndex = 4,
                        Parent = Container,
                    })
                end

                -- Campo de digitação (Frame doLugarDeDigitar — como no original)
                local InputBg = Create("Frame", {
                    AnchorPoint = Vector2.new(1, 1),
                    Position = UDim2.new(1, -6, 1, -6),
                    Size = UDim2.new(0.42, 0, 0, 22),
                    BackgroundColor3 = Color3.fromRGB(80, 80, 80),
                    BorderSizePixel = 0,
                    ZIndex = 4,
                    Parent = Container,
                })
                Corner(InputBg, 5)
                local InputStroke = Stroke(InputBg, Theme.Stroke, 1)

                local TB = Create("TextBox", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    PlaceholderText = holder,
                    PlaceholderColor3 = Theme.TextMuted,
                    Text = default,
                    TextColor3 = Theme.TextPrimary,
                    TextSize = 12,
                    Font = Enum.Font.Gotham,
                    ClearTextOnFocus = false,
                    ZIndex = 5,
                    Parent = InputBg,
                })
                Padding(TB, 0, 0, 6, 6)

                TB.Focused:Connect(function()
                    Tween(InputStroke, 0.2, {Color = Theme.Accent})
                    Tween(InputBg, 0.2, {BackgroundColor3 = Color3.fromRGB(55, 28, 80)})
                end)
                TB.FocusLost:Connect(function(enter)
                    Tween(InputStroke, 0.2, {Color = Theme.Stroke})
                    Tween(InputBg, 0.2, {BackgroundColor3 = Color3.fromRGB(80, 80, 80)})
                    local val = TB.Text
                    if numeric then
                        val = tonumber(val) or tonumber(default) or 0
                        TB.Text = tostring(val)
                    end
                    if flag then StormHub.Flags[flag] = val end
                    callback(val, enter)
                end)

                local TBObj = {}
                function TBObj:Set(v)
                    TB.Text = tostring(v)
                    if flag then StormHub.Flags[flag] = v end
                end
                function TBObj:Get() return TB.Text end
                return TBObj
            end

            -- ── ColorPicker ───────────────────────────────────────────────────
            function Section:AddColorPicker(cfg)
                cfg = cfg or {}
                local name = cfg.Name or "Color"
                local default = cfg.Default or Color3.fromRGB(137, 6, 255)
                local flag = cfg.Flag
                local callback = cfg.Callback or function() end

                local h, s, v = Color3.toHSV(default)
                local currentColor = default
                if flag then StormHub.Flags[flag] = currentColor end

                local Container = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 34),
                    BackgroundColor3 = Theme.Element,
                    BorderSizePixel = 0,
                    LayoutOrder = NextOrder(),
                    ZIndex = 3,
                    Parent = SecContent,
                })
                Corner(Container, 6)
                Stroke(Container, Theme.Stroke, 1)

                Create("TextLabel", {
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, 8, 0.5, 0),
                    Size = UDim2.new(1, -56, 1, 0),
                    BackgroundTransparency = 1,
                    Text = name,
                    TextColor3 = Theme.TextPrimary,
                    TextSize = 13,
                    Font = Enum.Font.GothamSemibold,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 4,
                    Parent = Container,
                })

                local Preview = Create("Frame", {
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, -8, 0.5, 0),
                    Size = UDim2.new(0, 26, 0, 26),
                    BackgroundColor3 = currentColor,
                    BorderSizePixel = 0,
                    ZIndex = 4,
                    Parent = Container,
                })
                Corner(Preview, 6)
                Stroke(Preview, Theme.Stroke, 1)

                -- Popup com sliders H/S/V — parented ao Overlay
                local Popup = Create("Frame", {
                    Size = UDim2.new(0, 0, 0, 0),
                    BackgroundColor3 = Color3.fromRGB(25, 25, 25),
                    BorderSizePixel = 0,
                    ZIndex = 501,
                    ClipsDescendants = true,
                    Visible = false,
                    Parent = Overlay,
                })
                Corner(Popup, 8)
                Stroke(Popup, Theme.StrokeAccent, 1)

                local PopContent = Create("Frame", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    ZIndex = 502,
                    Parent = Popup,
                })
                Padding(PopContent, 8, 8, 8, 8)

                local function MakeHSVSlider(label, yPos, initVal)
                    Create("TextLabel", {
                        Position = UDim2.new(0, 0, 0, yPos),
                        Size = UDim2.new(1, 0, 0, 13),
                        BackgroundTransparency = 1,
                        Text = label,
                        TextColor3 = Theme.TextSecondary,
                        TextSize = 10,
                        Font = Enum.Font.Gotham,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        ZIndex = 502,
                        Parent = PopContent,
                    })
                    local Track = Create("Frame", {
                        Position = UDim2.new(0, 0, 0, yPos + 15),
                        Size = UDim2.new(1, 0, 0, 10),
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        BorderSizePixel = 0,
                        ZIndex = 502,
                        Parent = PopContent,
                    })
                    Corner(Track, 5)
                    local Knob = Create("Frame", {
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Position = UDim2.new(initVal, 0, 0.5, 0),
                        Size = UDim2.new(0, 12, 0, 12),
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        BorderSizePixel = 0,
                        ZIndex = 504,
                        Parent = Track,
                    })
                    Corner(Knob, 6)
                    Stroke(Knob, Color3.fromRGB(0, 0, 0), 1.5)
                    return Track, Knob
                end

                local hTrack, hKnob = MakeHSVSlider("Hue", 0, h)
                local sTrack, sKnob = MakeHSVSlider("Saturation", 32, s)
                local vTrack, vKnob = MakeHSVSlider("Brightness", 64, v)

                local hGrad = Instance.new("UIGradient")
                hGrad.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0,     Color3.fromHSV(0,     1, 1)),
                    ColorSequenceKeypoint.new(0.167, Color3.fromHSV(0.167, 1, 1)),
                    ColorSequenceKeypoint.new(0.333, Color3.fromHSV(0.333, 1, 1)),
                    ColorSequenceKeypoint.new(0.5,   Color3.fromHSV(0.5,   1, 1)),
                    ColorSequenceKeypoint.new(0.667, Color3.fromHSV(0.667, 1, 1)),
                    ColorSequenceKeypoint.new(0.833, Color3.fromHSV(0.833, 1, 1)),
                    ColorSequenceKeypoint.new(1,     Color3.fromHSV(1,     1, 1)),
                })
                hGrad.Parent = hTrack

                local sGrad = Instance.new("UIGradient")
                sGrad.Color = ColorSequence.new(Color3.fromHSV(h, 0, 1), Color3.fromHSV(h, 1, 1))
                sGrad.Parent = sTrack

                local vGrad = Instance.new("UIGradient")
                vGrad.Color = ColorSequence.new(Color3.fromHSV(h, s, 0), Color3.fromHSV(h, s, 1))
                vGrad.Parent = vTrack

                local function Apply()
                    currentColor = Color3.fromHSV(h, s, v)
                    Preview.BackgroundColor3 = currentColor
                    sGrad.Color = ColorSequence.new(Color3.fromHSV(h, 0, 1), Color3.fromHSV(h, 1, 1))
                    vGrad.Color = ColorSequence.new(Color3.fromHSV(h, s, 0), Color3.fromHSV(h, s, 1))
                    if flag then StormHub.Flags[flag] = currentColor end
                    callback(currentColor)
                end

                local function MakeTrackInput(track, knob, onVal)
                    local drag = false
                    track.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1
                        or input.UserInputType == Enum.UserInputType.Touch then
                            drag = true
                            local rel = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                            knob.Position = UDim2.new(rel, 0, 0.5, 0)
                            onVal(rel)
                            Apply()
                        end
                    end)
                    UserInputService.InputChanged:Connect(function(input)
                        if not drag then return end
                        if input.UserInputType == Enum.UserInputType.MouseMovement
                        or input.UserInputType == Enum.UserInputType.Touch then
                            local rel = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                            knob.Position = UDim2.new(rel, 0, 0.5, 0)
                            onVal(rel)
                            Apply()
                        end
                    end)
                    UserInputService.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1
                        or input.UserInputType == Enum.UserInputType.Touch then
                            drag = false
                        end
                    end)
                end

                MakeTrackInput(hTrack, hKnob, function(val) h = val end)
                MakeTrackInput(sTrack, sKnob, function(val) s = val end)
                MakeTrackInput(vTrack, vKnob, function(val) v = val end)

                local popOpen = false
                local popupW = 0

                local CBtn = Create("TextButton", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = "",
                    ZIndex = 5,
                    Parent = Container,
                })
                CBtn.MouseButton1Click:Connect(function()
                    popOpen = not popOpen
                    if popOpen then
                        local ap = Container.AbsolutePosition
                        local as = Container.AbsoluteSize
                        popupW = as.X
                        Popup.Position = UDim2.new(0, ap.X, 0, ap.Y + as.Y + 4)
                        Popup.Size = UDim2.new(0, popupW, 0, 0)
                        Popup.Visible = true
                        Tween(Popup, 0.22, {Size = UDim2.new(0, popupW, 0, 108)})
                    else
                        Tween(Popup, 0.22, {Size = UDim2.new(0, popupW, 0, 0)})
                        task.delay(0.22, function() Popup.Visible = false end)
                    end
                end)
                CBtn.MouseEnter:Connect(function()
                    Tween(Container, 0.15, {BackgroundColor3 = Theme.ElementHover})
                end)
                CBtn.MouseLeave:Connect(function()
                    Tween(Container, 0.15, {BackgroundColor3 = Theme.Element})
                end)

                local CPObj = {}
                function CPObj:Set(color)
                    currentColor = color
                    h, s, v = Color3.toHSV(color)
                    hKnob.Position = UDim2.new(h, 0, 0.5, 0)
                    sKnob.Position = UDim2.new(s, 0, 0.5, 0)
                    vKnob.Position = UDim2.new(v, 0, 0.5, 0)
                    Preview.BackgroundColor3 = color
                    if flag then StormHub.Flags[flag] = color end
                    Apply()
                end
                function CPObj:Get() return currentColor end
                return CPObj
            end

            -- ── Label ─────────────────────────────────────────────────────────
            function Section:AddLabel(cfg)
                cfg = cfg or {}
                local text = cfg.Text or cfg.Name or "Label"
                local color = cfg.Color or Theme.TextSecondary
                local size = cfg.TextSize or 12

                local Lbl = Create("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1,
                    Text = text,
                    TextColor3 = color,
                    TextSize = size,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextWrapped = true,
                    LayoutOrder = NextOrder(),
                    ZIndex = 3,
                    Parent = SecContent,
                })
                Padding(Lbl, 2, 2, 6, 6)

                local LblObj = {}
                function LblObj:Set(newText) Lbl.Text = tostring(newText) end
                function LblObj:SetColor(c) Lbl.TextColor3 = c end
                return LblObj
            end

            -- ── Separator ─────────────────────────────────────────────────────
            function Section:AddSeparator()
                Create("Frame", {
                    Size = UDim2.new(1, -12, 0, 1),
                    BackgroundColor3 = Theme.Stroke,
                    BorderSizePixel = 0,
                    LayoutOrder = NextOrder(),
                    ZIndex = 3,
                    Parent = SecContent,
                })
            end

            -- ── Dialog ────────────────────────────────────────────────────────
            function Section:AddDialog(cfg)
                cfg = cfg or {}
                local name = cfg.Name or "Abrir Dialog"
                local guiText = cfg.GuiText or "Tem certeza que deseja continuar?"
                local yesBtn = cfg.YesBtn or "Sim"
                local noBtn = cfg.NoBtn or "Não"
                local callback = cfg.Callback or function() end

                local Btn = Create("TextButton", {
                    Size = UDim2.new(1, 0, 0, 34),
                    BackgroundColor3 = Theme.Element,
                    BorderSizePixel = 0,
                    Text = "",
                    LayoutOrder = NextOrder(),
                    ZIndex = 3,
                    Parent = SecContent,
                })
                Corner(Btn, 6)
                Stroke(Btn, Theme.StrokeAccent, 1)

                Create("TextLabel", {
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, 8, 0.5, 0),
                    Size = UDim2.new(0, 18, 0, 18),
                    BackgroundTransparency = 1,
                    Text = "⚠",
                    TextColor3 = Theme.Accent,
                    TextSize = 14,
                    Font = Enum.Font.GothamBold,
                    ZIndex = 4,
                    Parent = Btn,
                })

                Create("TextLabel", {
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, 30, 0.5, 0),
                    Size = UDim2.new(1, -38, 1, 0),
                    BackgroundTransparency = 1,
                    Text = name,
                    TextColor3 = Theme.TextPrimary,
                    TextSize = 13,
                    Font = Enum.Font.GothamSemibold,
                    TextXAlignment = Enum.TextXAlignment.Center,
                    ZIndex = 4,
                    Parent = Btn,
                })

                Btn.MouseEnter:Connect(function()
                    Tween(Btn, 0.15, {BackgroundColor3 = Theme.ElementHover})
                end)
                Btn.MouseLeave:Connect(function()
                    Tween(Btn, 0.15, {BackgroundColor3 = Theme.Element})
                end)
                Btn.MouseButton1Down:Connect(function()
                    Tween(Btn, 0.1, {BackgroundColor3 = Theme.ElementPress})
                end)
                Btn.MouseButton1Up:Connect(function()
                    Tween(Btn, 0.1, {BackgroundColor3 = Theme.ElementHover})
                end)
                Btn.MouseButton1Click:Connect(function()
                    OpenDialog({
                        GuiText = guiText,
                        YesBtn = yesBtn,
                        NoBtn = noBtn,
                        Callback = callback,
                    })
                end)
            end

            return Section
        end -- AddSection

        return Tab
    end -- AddTab

    return Window
end -- CreateWindow

-- ─── API pública ──────────────────────────────────────────────────────────────
function StormHub:SetTheme(custom)
    for k, v in pairs(custom) do Theme[k] = v end
end

function StormHub:GetFlag(flag)
    return StormHub.Flags[flag]
end

return StormHub

--[[
╔═══════════════════════════════════════════════════════════╗
║              STORM HUB — EXEMPLO COMPLETO                 ║
╚═══════════════════════════════════════════════════════════╝

local StormHub = loadstring(game:HttpGet("URL_AQUI"))()

local Window = StormHub:CreateWindow({
    Title = "Storm Hub",
    By = "By SeuNome",
    Game = "Jogo Exemplo",
    Width = 460,
    Height = 330,
})

-- Tabs (botões na sidebar esquerda — DenkOne font)
local TabMain   = Window:AddTab({ Name = "Main"   })
local TabPlayer = Window:AddTab({ Name = "Player" })
local TabVisual = Window:AddTab({ Name = "Visual" })

-- ── Tab Main ────────────────────────────────────────────
local SecCombat = TabMain:AddSection({ Name = "Combat" })

SecCombat:AddButton({
    Name = "Kill All",
    Description = "Elimina todos os jogadores.",
    Callback = function() print("Kill All!") end,
})

SecCombat:AddToggle({
    Name = "Aimbot",
    Description = "Mira automática nos inimigos.",
    Default = false,
    Flag = "Aimbot",
    Callback = function(state) print("Aimbot:", state) end,
})

SecCombat:AddSlider({
    Name = "FOV",
    Description = "Raio de detecção do aimbot.",
    Min = 10,
    Max = 360,
    Default = 90,
    Increment = 5,
    Suffix = "°",
    Flag = "FOV",
    Callback = function(val) print("FOV:", val) end,
})

local SecConfig = TabMain:AddSection({ Name = "Config" })

SecConfig:AddDropdown({
    Name = "Hit Part",
    Description = "Parte do corpo alvo.",
    Options = { "Head", "Torso", "Random" },
    Default = "Head",
    Flag = "HitPart",
    Callback = function(v) print("Hit Part:", v) end,
})

SecConfig:AddMultiDropdown({
    Name = "Ignorar Times",
    Description = "Times que serão ignorados.",
    Options = { "Aliados", "Inimigos", "Neutros" },
    Default = { "Aliados" },
    Flag = "IgnoreTeams",
    Callback = function(sel) print("Ignorar:", sel) end,
})

SecConfig:AddKeybind({
    Name = "Toggle UI",
    Default = Enum.KeyCode.RightShift,
    Flag = "UIKey",
    Callback = function(key) print("Key:", key) end,
})

SecConfig:AddDialog({
    Name = "Resetar Config",
    GuiText = "Isso vai resetar todas as configurações. Continuar?",
    YesBtn = "Sim, resetar",
    NoBtn = "Cancelar",
    Callback = function() print("Config resetada!") end,
})

-- ── Tab Player ──────────────────────────────────────────
local SecPlayer = TabPlayer:AddSection({ Name = "Modificadores" })

SecPlayer:AddToggle({
    Name = "Speed Hack",
    Description = "Aumenta a velocidade do personagem.",
    Default = false,
    Flag = "SpeedHack",
    Callback = function(state) print("Speed:", state) end,
})

SecPlayer:AddSlider({
    Name = "WalkSpeed",
    Description = "Velocidade de movimento.",
    Min = 16,
    Max = 500,
    Default = 16,
    Suffix = " st",
    Flag = "WalkSpeed",
    Callback = function(val)
        local char = game.Players.LocalPlayer.Character
        if char then char.Humanoid.WalkSpeed = val end
    end,
})

SecPlayer:AddTextBox({
    Name = "Alvo",
    Description = "Nome do jogador a mirar.",
    Placeholder = "ex: Player1",
    Flag = "Target",
    Callback = function(text, enter)
        if enter then print("Alvo:", text) end
    end,
})

-- ── Tab Visual ──────────────────────────────────────────
local SecESP = TabVisual:AddSection({ Name = "ESP" })

SecESP:AddToggle({
    Name = "ESP Ativado",
    Default = false,
    Flag = "ESP",
    Callback = function(state) print("ESP:", state) end,
})

SecESP:AddColorPicker({
    Name = "Cor do ESP",
    Default = Color3.fromRGB(137, 6, 255),
    Flag = "ESPColor",
    Callback = function(color) print("Cor:", color) end,
})

SecESP:AddSeparator()

SecESP:AddLabel({
    Text = "Storm Hub v1.0 — By SeuNome",
    Color = Color3.fromRGB(137, 6, 255),
})

-- Ler flags:
print(StormHub:GetFlag("Aimbot"))
print(StormHub:GetFlag("WalkSpeed"))

-- Destruir:
-- Window:Destroy()
--]]
