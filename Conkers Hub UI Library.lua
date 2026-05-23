--[[
    ╔══════════════════════════════════════════════╗
    ║       CONKERS HUB UI LIBRARY  v1.1           ║
    ╠══════════════════════════════════════════════╣
    ║  Componentes:                                ║
    ║   Button · Toggle · Slider · Dropdown        ║
    ║   MultiDropdown · Keybind · TextBox          ║
    ║   ColorPicker · Label · Separator · Dialog   ║
    ╠══════════════════════════════════════════════╣
    ║  Correções v1.1:                             ║
    ║  1. Drag da janela sem teleporte             ║
    ║     getInputPos() usa GetMouseLocation()     ║
    ║     para mouse e input.Position para touch.  ║
    ║                                              ║
    ║  2. Drag da bolinha sem teleporte            ║
    ║     Mesma correção aplicada ao FloatBtn.     ║
    ║                                              ║
    ║  3. Sem limite de tela                       ║
    ║     math.clamp removido: interface pode      ║
    ║     sair parcialmente da tela livremente.    ║
    ║                                              ║
    ║  4. Minimização com cantos arredondados      ║
    ║     TopBarBottomFill ocultado ao minimizar,  ║
    ║     restaurado ao expandir com delay.        ║
    ╚══════════════════════════════════════════════╝

    USO RÁPIDO:
        ConkersHub:SetTheme("Green")
        local W = ConkersHub:CreateWindow({...})
        local T = W:AddTab({Name="Main"})
        T:AddToggle({...})          -- direto na tab
        local S = T:AddSection({Name="Combat"})
        S:AddButton({...})          -- ou com section
        W:AddFloatButton({...})     -- botão flutuante
--]]

-- ─── Serviços ─────────────────────────────────────────────────────────────────
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- ─── Tema ─────────────────────────────────────────────────────────────────────
local Theme = {
    Background = Color3.fromRGB(0,   0,   0  ),
    Element = Color3.fromRGB(58,  58,  58 ),
    ElementHover = Color3.fromRGB(72,  72,  72 ),
    ElementPress = Color3.fromRGB(42,  42,  42 ),
    Section = Color3.fromRGB(28,  28,  28 ),
    SectionHeader = Color3.fromRGB(44,  44,  44 ),
    Accent = Color3.fromRGB(137, 6,   255),
    AccentDark = Color3.fromRGB(100, 4,   190),
    AccentLight = Color3.fromRGB(170, 60,  255),
    TabActive = Color3.fromRGB(137, 6,   255),
    TabInactive = Color3.fromRGB(48,  48,  48 ),
    ToggleOn = Color3.fromRGB(137, 6,   255),
    ToggleOff = Color3.fromRGB(123, 123, 123),
    SliderFill = Color3.fromRGB(137, 6,   255),
    SliderBg = Color3.fromRGB(100, 100, 100),
    TextPrimary = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(200, 200, 200),
    TextMuted = Color3.fromRGB(150, 150, 150),
    TextAccent = Color3.fromRGB(180, 80,  255),
    Divider = Color3.fromRGB(255, 255, 255),
    Stroke = Color3.fromRGB(75,  75,  75 ),
    StrokeAccent = Color3.fromRGB(137, 6,   255),
}

-- ─── Temas ────────────────────────────────────────────────────────────────────
local Themes = {
    Purple = {
        Accent=Color3.fromRGB(137,6,255),   AccentDark=Color3.fromRGB(100,4,190),
        AccentLight=Color3.fromRGB(170,60,255), TabActive=Color3.fromRGB(137,6,255),
        ToggleOn=Color3.fromRGB(137,6,255), SliderFill=Color3.fromRGB(137,6,255),
        StrokeAccent=Color3.fromRGB(137,6,255), TextAccent=Color3.fromRGB(180,80,255),
    },
    Dark = {
        Accent=Color3.fromRGB(90,90,90),    AccentDark=Color3.fromRGB(60,60,60),
        AccentLight=Color3.fromRGB(130,130,130), TabActive=Color3.fromRGB(90,90,90),
        ToggleOn=Color3.fromRGB(90,90,90),  SliderFill=Color3.fromRGB(90,90,90),
        StrokeAccent=Color3.fromRGB(80,80,80),  TextAccent=Color3.fromRGB(160,160,160),
    },
    Green = {
        Accent=Color3.fromRGB(40,180,70),   AccentDark=Color3.fromRGB(28,130,50),
        AccentLight=Color3.fromRGB(80,220,110), TabActive=Color3.fromRGB(40,180,70),
        ToggleOn=Color3.fromRGB(40,180,70), SliderFill=Color3.fromRGB(40,180,70),
        StrokeAccent=Color3.fromRGB(40,180,70), TextAccent=Color3.fromRGB(90,220,110),
    },
}

-- ─── Fontes originais do Storm Hub ────────────────────────────────────────────
local FontLucky = Font.new("rbxasset://fonts/families/LuckiestGuy.json")
local FontFredoka = Font.new("rbxasset://fonts/families/FredokaOne.json")
local FontZekton = Font.new("rbxasset://fonts/families/Zekton.json")
local FontDenk = Font.new("rbxasset://fonts/families/DenkOne.json")

-- ─── Utilitários ──────────────────────────────────────────────────────────────
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
    p.PaddingTop = UDim.new(0, top    or 6)
    p.PaddingBottom = UDim.new(0, bottom or 6)
    p.PaddingLeft = UDim.new(0, left   or 8)
    p.PaddingRight = UDim.new(0, right  or 8)
    p.Parent = parent
end

local function ListLayout(parent, dir, gap, halign)
    local l = Instance.new("UIListLayout")
    l.FillDirection = dir    or Enum.FillDirection.Vertical
    l.SortOrder = Enum.SortOrder.LayoutOrder
    l.Padding = UDim.new(0, gap or 4)
    l.HorizontalAlignment = halign or Enum.HorizontalAlignment.Center
    l.Parent = parent
    return l
end

-- ─── Drag sem teleporte ───────────────────────────────────────────────────────
-- Captura AbsolutePosition do frame e posição do cursor UMA VEZ ao iniciar.
-- Usa GetMouseLocation() para mouse (ignora GuiInset) e input.Position para touch.
-- Sem math.clamp: interface pode sair parcialmente da tela livremente.
local function getInputPos(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        return Vector2.new(input.Position.X, input.Position.Y)
    end
    return UserInputService:GetMouseLocation()
end

local function MakeDraggable(handle, frame)
    local dragging = false
    local dragStartInput = nil
    local frameStartAbs = nil

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStartInput = getInputPos(input)
            frameStartAbs = frame.AbsolutePosition
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
            local delta = getInputPos(input) - dragStartInput
            frame.Position = UDim2.new(
                0, frameStartAbs.X + delta.X,
                0, frameStartAbs.Y + delta.Y
            )
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
        local function inside(f)
            if not f or not f.Visible then return false end
            local ap, as = f.AbsolutePosition, f.AbsoluteSize
            return mp.X >= ap.X and mp.X <= ap.X + as.X
               and mp.Y >= ap.Y and mp.Y <= ap.Y + as.Y
        end
        if not inside(popup) and not inside(trigger) then closeFn() end
    end)
end

-- ─── Biblioteca ───────────────────────────────────────────────────────────────
local ConkersHub = {}
ConkersHub.__index = ConkersHub
ConkersHub.Flags = {}
ConkersHub.Theme = Theme
ConkersHub.Themes = Themes

function ConkersHub:SetTheme(name)
    local p = Themes[name]
    if not p then
        warn("ConkersHub: Tema '" .. tostring(name) .. "' inválido. Use: Dark, Purple, Green")
        return
    end
    for k, v in pairs(p) do Theme[k] = v end
end

-- ─── CreateWindow ─────────────────────────────────────────────────────────────
function ConkersHub:CreateWindow(config)
    config = config    or {}
    local hubTitle = config.Title    or "Conkers Hub"
    local hubBy = config.By       or "By SeuNome"
    local hubGame = config.Game     or "Jogo"
    local width = config.Width    or 460
    local height = config.Height   or 330
    local startPos = config.Position or UDim2.new(0.5, -(width/2), 0.5, -(height/2))

    local sidebarW = 140
    local topbarH = 60
    local divPx = 1
    local RADIUS = 10   -- raio de UICorner usado em toda a janela

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

    -- ── [Fix 1] Janela principal ───────────────────────────────────────────────
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
    Stroke(Main, Theme.Stroke, 1)

    -- Sombra
    Create("ImageLabel", {
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

    -- ── TopBar ────────────────────────────────────────────────────────────────
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

    -- Preenche cantos inferiores do TopBar (faz ficarem retos quando body visível)
    local TopBarBottomFill = Create("Frame", {
        Position = UDim2.new(0, 0, 0.5, 0),
        Size = UDim2.new(1, 0, 0.5, 0),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        ZIndex = 2,
        Parent = TopBar,
    })

    -- [Fix 5] Title descido levemente (era y=4, agora y=10)
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

    -- ── Body ──────────────────────────────────────────────────────────────────
    local Body = Create("Frame", {
        Name = "Body",
        Position = UDim2.new(0, 0, 0, topbarH + divPx),
        Size = UDim2.new(1, 0, 1, -(topbarH + divPx)),
        BackgroundTransparency = 1,
        ClipsDescendants = false,
        ZIndex = 2,
        Parent = Main,
    })

    -- ── Sidebar ───────────────────────────────────────────────────────────────
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

    local SLy = ListLayout(Sidebar, Enum.FillDirection.Vertical, 5)
    SLy.HorizontalAlignment = Enum.HorizontalAlignment.Center
    Padding(Sidebar, 7, 7, 7, 7)
    SLy:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Sidebar.CanvasSize = UDim2.new(0, 0, 0, SLy.AbsoluteContentSize.Y + 14)
    end)

    -- Divisor vertical
    Create("Frame", {
        Position = UDim2.new(0, sidebarW, 0, 0),
        Size = UDim2.new(0, divPx, 1, 0),
        BackgroundColor3 = Theme.Divider,
        BorderSizePixel = 0,
        ZIndex = 2,
        Parent = Body,
    })

    -- ── ContentArea ───────────────────────────────────────────────────────────
    -- Canto inferior-direito coincide com Main → arredondado ✓
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

    -- ── Dialog overlay ────────────────────────────────────────────────────────
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
    Stroke(DialogBox, Theme.StrokeAccent, 1.5)

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

    Create("TextLabel", {
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

    local dialogCb = nil

    local function CloseDialog()
        Tween(DialogOverlay, 0.22, {BackgroundTransparency = 1})
        Tween(DialogBox, 0.22, {Position = UDim2.new(0.5, 0, 0.65, 0)},
            Enum.EasingStyle.Quart, Enum.EasingDirection.In)
        task.delay(0.22, function() DialogOverlay.Visible = false end)
    end

    local function OpenDialog(cfg)
        DialogText.Text = cfg.GuiText  or "Tem certeza?"
        DialogNoBtn.Text = cfg.NoBtn    or "Não"
        DialogYesBtn.Text = cfg.YesBtn   or "Sim"
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

    -- ── Minimizar ─────────────────────────────────────────────────────────────
    local minimized = false
    local fullSize = UDim2.new(0, width, 0, height)
    local miniSize = UDim2.new(0, width, 0, topbarH)

    MakeDraggable(TopBar, Main)

    MinBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            Body.Visible = false
            TopDivider.Visible = false
            TopBarBottomFill.Visible = false
            Tween(Main, 0.3, {Size = miniSize})
            MinBtn.Text = "+"
        else
            Tween(Main, 0.3, {Size = fullSize})
            MinBtn.Text = "─"
            task.delay(0.28, function()
                if not minimized then
                    Body.Visible = true
                    TopDivider.Visible = true
                    TopBarBottomFill.Visible = true
                end
            end)
        end
    end)

    -- ── Fábrica de componentes ─────────────────────────────────────────────────
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

        -- ── Button ────────────────────────────────────────────────────────────
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
            Create("Frame", {Size=UDim2.new(1,0,0,28), BackgroundTransparency=1, ZIndex=1, Parent=Btn})

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
            Create("TextLabel", {
                Size=UDim2.new(1,0,1,0), BackgroundTransparency=1,
                Text="▶", TextColor3=Theme.TextPrimary, TextSize=11,
                Font=Enum.Font.GothamBold, ZIndex=5, Parent=IcoBox,
            })
            TextArea(Btn, name, desc, 38)

            Btn.MouseEnter:Connect(function() Tween(Btn,0.15,{BackgroundColor3=Theme.ElementHover}) end)
            Btn.MouseLeave:Connect(function() Tween(Btn,0.15,{BackgroundColor3=Theme.Element}) end)
            Btn.MouseButton1Down:Connect(function() Tween(Btn,0.08,{BackgroundColor3=Theme.ElementPress}) end)
            Btn.MouseButton1Up:Connect(function()   Tween(Btn,0.1, {BackgroundColor3=Theme.ElementHover}) end)
            Btn.MouseButton1Click:Connect(callback)
        end

        -- ── Toggle ────────────────────────────────────────────────────────────
        function obj:AddToggle(cfg)
            cfg = cfg or {}
            local name = cfg.Name        or "Toggle"
            local default = cfg.Default     or false
            local flag = cfg.Flag
            local callback = cfg.Callback    or function() end
            local desc = cfg.Description or ""

            local state = default
            if flag then ConkersHub.Flags[flag] = state end

            local Row = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = state and Color3.fromRGB(30,10,50) or Theme.Element,
                BorderSizePixel = 0,
                LayoutOrder = N(),
                ZIndex = 3,
                Parent = container,
            })
            Corner(Row, 6)
            Create("Frame", {Size=UDim2.new(1,0,0,28), BackgroundTransparency=1, ZIndex=1, Parent=Row})

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

            local Knob = Create("Frame", {
                AnchorPoint = Vector2.new(0, 0.5),
                Position = state and UDim2.new(1,-18,0.5,0) or UDim2.new(0,2,0.5,0),
                Size = UDim2.new(0,16,0,16),
                BackgroundColor3 = Color3.fromRGB(255,255,255),
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
                Tween(Knob,     0.2, {Position = state and UDim2.new(1,-18,0.5,0) or UDim2.new(0,2,0.5,0)})
                Tween(Row,      0.2, {BackgroundColor3 = state and Color3.fromRGB(30,10,50) or Theme.Element})
                callback(state)
            end

            local CBtn = Create("TextButton", {
                Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Text="", ZIndex=6, Parent=Row,
            })
            CBtn.MouseButton1Click:Connect(DoToggle)
            CBtn.MouseEnter:Connect(function()
                if not state then Tween(Row,0.15,{BackgroundColor3=Theme.ElementHover}) end
            end)
            CBtn.MouseLeave:Connect(function()
                if not state then Tween(Row,0.15,{BackgroundColor3=Theme.Element}) end
            end)

            local T={}
            function T:Set(v) if v~=state then DoToggle() end end
            function T:Get() return state end
            return T
        end

        -- ── Slider ────────────────────────────────────────────────────────────
        function obj:AddSlider(cfg)
            cfg = cfg or {}
            local name = cfg.Name      or "Slider"
            local min = cfg.Min       or 0
            local max = cfg.Max       or 100
            local default = cfg.Default   or min
            local increment = cfg.Increment or 1
            local suffix = cfg.Suffix    or ""
            local flag = cfg.Flag
            local callback = cfg.Callback  or function() end
            local desc = cfg.Description or ""
            local hasDesc = desc ~= ""

            local value = math.clamp(default, min, max)
            if flag then ConkersHub.Flags[flag] = value end

            local Container = Create("Frame", {
                Size=UDim2.new(1,0,0,0), AutomaticSize=Enum.AutomaticSize.Y,
                BackgroundColor3=Theme.Element, BorderSizePixel=0,
                LayoutOrder=N(), ZIndex=3, Parent=container,
            })
            Corner(Container, 6)
            local CLy = ListLayout(Container, Enum.FillDirection.Vertical, 0)
            CLy.HorizontalAlignment = Enum.HorizontalAlignment.Center

            local TopRow = Create("Frame", {
                Size=UDim2.new(1,0,0,22), BackgroundTransparency=1, ZIndex=3, Parent=Container,
            })
            Create("TextLabel", {
                Position=UDim2.new(0,8,0.5,-7), Size=UDim2.new(0.58,0,0,14),
                BackgroundTransparency=1, Text=name, TextColor3=Theme.TextPrimary,
                TextSize=13, Font=Enum.Font.GothamSemibold,
                TextXAlignment=Enum.TextXAlignment.Left, ZIndex=4, Parent=TopRow,
            })
            local ValBox = Create("Frame", {
                AnchorPoint=Vector2.new(1,0.5), Position=UDim2.new(1,-8,0.5,0),
                Size=UDim2.new(0,52,0,15), BackgroundColor3=Color3.fromRGB(78,78,78),
                BorderSizePixel=0, ZIndex=4, Parent=TopRow,
            })
            Corner(ValBox, 4)
            local ValLabel = Create("TextLabel", {
                Size=UDim2.new(1,0,1,0), BackgroundTransparency=1,
                Text=tostring(value)..suffix, TextColor3=Theme.TextPrimary,
                TextSize=11, Font=Enum.Font.GothamBold, ZIndex=5, Parent=ValBox,
            })

            if hasDesc then
                local DR = Create("Frame", {
                    Size=UDim2.new(1,0,0,0), AutomaticSize=Enum.AutomaticSize.Y,
                    BackgroundTransparency=1, ZIndex=3, Parent=Container,
                })
                Padding(DR, 0, 3, 8, 8)
                Create("TextLabel", {
                    Size=UDim2.new(1,0,0,0), AutomaticSize=Enum.AutomaticSize.Y,
                    BackgroundTransparency=1, Text=desc, TextColor3=Theme.TextMuted,
                    TextSize=11, Font=Enum.Font.Gotham,
                    TextXAlignment=Enum.TextXAlignment.Left, TextWrapped=true,
                    ZIndex=4, Parent=DR,
                })
            end

            local TrackRow = Create("Frame", {
                Size=UDim2.new(1,0,0,14), BackgroundTransparency=1, ZIndex=3, Parent=Container,
            })
            local Track = Create("Frame", {
                AnchorPoint=Vector2.new(0.5,0.5), Position=UDim2.new(0.5,0,0.5,0),
                Size=UDim2.new(1,-16,0,6), BackgroundColor3=Theme.SliderBg,
                BorderSizePixel=0, ZIndex=4, Parent=TrackRow,
            })
            Corner(Track, 3)

            local pct0 = (value-min)/(max-min)
            local Fill = Create("Frame", {
                Size=UDim2.new(pct0,0,1,0), BackgroundColor3=Theme.SliderFill,
                BorderSizePixel=0, ZIndex=5, Parent=Track,
            })
            Corner(Fill, 3)

            local TKnob = Create("Frame", {
                AnchorPoint=Vector2.new(0.5,0.5), Position=UDim2.new(pct0,0,0.5,0),
                Size=UDim2.new(0,12,0,12), BackgroundColor3=Color3.fromRGB(255,255,255),
                BorderSizePixel=0, ZIndex=6, Parent=Track,
            })
            Corner(TKnob, 6)
            Stroke(TKnob, Theme.Accent, 1.5)

            local sliding = false
            local function Update(ix)
                local ts = Track.AbsoluteSize.X
                if ts == 0 then return end
                local rel = math.clamp((ix-Track.AbsolutePosition.X)/ts, 0, 1)
                value = math.clamp(math.floor((min+(max-min)*rel)/increment+0.5)*increment, min, max)
                local pct = (value-min)/(max-min)
                if flag then ConkersHub.Flags[flag] = value end
                Fill.Size=UDim2.new(pct,0,1,0); TKnob.Position=UDim2.new(pct,0,0.5,0)
                ValLabel.Text=tostring(value)..suffix; callback(value)
            end
            Track.InputBegan:Connect(function(i)
                if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
                    sliding=true; Update(i.Position.X)
                end
            end)
            UserInputService.InputChanged:Connect(function(i)
                if not sliding then return end
                if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then
                    Update(i.Position.X)
                end
            end)
            UserInputService.InputEnded:Connect(function(i)
                if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
                    sliding=false
                end
            end)

            local S={}
            function S:Set(v)
                value=math.clamp(v,min,max)
                local pct=(value-min)/(max-min)
                if flag then ConkersHub.Flags[flag]=value end
                Fill.Size=UDim2.new(pct,0,1,0); TKnob.Position=UDim2.new(pct,0,0.5,0)
                ValLabel.Text=tostring(value)..suffix; callback(value)
            end
            function S:Get() return value end
            return S
        end

        -- ── Dropdown ──────────────────────────────────────────────────────────
        function obj:AddDropdown(cfg)
            cfg = cfg or {}
            local name = cfg.Name     or "Dropdown"
            local options = cfg.Options  or {}
            local default = cfg.Default  or options[1] or "None"
            local flag = cfg.Flag
            local callback = cfg.Callback or function() end
            local desc = cfg.Description or ""

            local selected = default
            if flag then ConkersHub.Flags[flag] = selected end

            local Container = Create("Frame", {
                Size=UDim2.new(1,0,0,0), AutomaticSize=Enum.AutomaticSize.Y,
                BackgroundColor3=Theme.Element, BorderSizePixel=0,
                LayoutOrder=N(), ZIndex=3, Parent=container,
            })
            Corner(Container, 6)
            Create("Frame", {Size=UDim2.new(1,0,0,28), BackgroundTransparency=1, ZIndex=1, Parent=Container})

            local ArrowLbl = Create("TextLabel", {
                AnchorPoint=Vector2.new(1,0), Position=UDim2.new(1,-6,0,6),
                Size=UDim2.new(0,16,0,16), BackgroundTransparency=1,
                Text="▾", TextColor3=Theme.TextMuted, TextSize=14,
                Font=Enum.Font.GothamBold, ZIndex=4, Parent=Container,
            })
            local SelLabel = Create("TextLabel", {
                AnchorPoint=Vector2.new(1,0), Position=UDim2.new(1,-24,0,7),
                Size=UDim2.new(0.42,0,0,14), BackgroundTransparency=1,
                Text=tostring(selected), TextColor3=Theme.TextAccent, TextSize=11,
                Font=Enum.Font.GothamSemibold, TextXAlignment=Enum.TextXAlignment.Right,
                TextTruncate=Enum.TextTruncate.AtEnd, ZIndex=4, Parent=Container,
            })
            TextArea(Container, name, desc, 76)

            local List = Create("ScrollingFrame", {
                Size=UDim2.new(0,0,0,0), BackgroundColor3=Color3.fromRGB(28,28,28),
                BorderSizePixel=0, ZIndex=501, ScrollBarThickness=2,
                ScrollBarImageColor3=Theme.Accent, CanvasSize=UDim2.new(0,0,0,0),
                ClipsDescendants=true, Visible=false, Parent=Overlay,
            })
            Corner(List, 6); Stroke(List, Theme.StrokeAccent, 1)
            local LI = ListLayout(List, Enum.FillDirection.Vertical, 2)
            Padding(List, 4, 4, 4, 4)
            LI:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                List.CanvasSize=UDim2.new(0,0,0, LI.AbsoluteContentSize.Y+8)
            end)

            local listOpen = false
            local function CloseList()
                listOpen=false
                Tween(List,0.2,{Size=UDim2.new(0,List.AbsoluteSize.X,0,0)})
                Tween(ArrowLbl,0.2,{Rotation=0})
                task.delay(0.2, function() List.Visible=false end)
            end
            local function BuildList()
                for _,c in ipairs(List:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
                for _,opt in ipairs(options) do
                    local isA=tostring(opt)==tostring(selected)
                    local Opt=Create("TextButton", {
                        Size=UDim2.new(1,0,0,26),
                        BackgroundColor3=isA and Theme.AccentDark or Color3.fromRGB(50,50,50),
                        BorderSizePixel=0, Text=tostring(opt),
                        TextColor3=isA and Theme.TextPrimary or Theme.TextSecondary,
                        TextSize=12, Font=Enum.Font.Gotham, ZIndex=502, Parent=List,
                    })
                    Corner(Opt, 5)
                    if isA then Stroke(Opt, Theme.Accent, 1) end
                    Opt.MouseEnter:Connect(function() if not isA then Tween(Opt,0.1,{BackgroundColor3=Color3.fromRGB(68,68,68)}) end end)
                    Opt.MouseLeave:Connect(function() if not isA then Tween(Opt,0.1,{BackgroundColor3=Color3.fromRGB(50,50,50)}) end end)
                    Opt.MouseButton1Click:Connect(function()
                        selected=opt; if flag then ConkersHub.Flags[flag]=selected end
                        SelLabel.Text=tostring(selected); BuildList(); CloseList(); callback(selected)
                    end)
                end
            end
            BuildList()
            local function OpenList()
                listOpen=true
                local ap,as=Container.AbsolutePosition,Container.AbsoluteSize
                List.Position=UDim2.new(0,ap.X,0,ap.Y+as.Y+4)
                List.Size=UDim2.new(0,as.X,0,0); List.Visible=true
                Tween(List,0.22,{Size=UDim2.new(0,as.X,0,math.min(#options*30+8,160))})
                Tween(ArrowLbl,0.2,{Rotation=180})
            end
            CloseOnOutsideClick(function() return listOpen end, List, Container, CloseList)
            local CBtn=Create("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="",ZIndex=5,Parent=Container})
            CBtn.MouseButton1Click:Connect(function() if listOpen then CloseList() else OpenList() end end)
            CBtn.MouseEnter:Connect(function() Tween(Container,0.15,{BackgroundColor3=Theme.ElementHover}) end)
            CBtn.MouseLeave:Connect(function() Tween(Container,0.15,{BackgroundColor3=Theme.Element}) end)
            local D={}
            function D:Set(v) selected=v; if flag then ConkersHub.Flags[flag]=v end; SelLabel.Text=tostring(v); BuildList(); callback(v) end
            function D:SetOptions(o) options=o; BuildList() end
            function D:Get() return selected end
            return D
        end

        -- ── MultiDropdown ─────────────────────────────────────────────────────
        function obj:AddMultiDropdown(cfg)
            cfg = cfg or {}
            local name = cfg.Name     or "Multi Select"
            local options = cfg.Options  or {}
            local defaults = cfg.Default  or {}
            local flag = cfg.Flag
            local callback = cfg.Callback or function() end
            local desc = cfg.Description or ""

            local selected = {}
            for _,v in ipairs(defaults) do selected[v]=true end
            if flag then ConkersHub.Flags[flag]=selected end

            local function Disp()
                local n=0; for _ in pairs(selected) do n=n+1 end
                return n==0 and "Nenhum" or (n.." sel.")
            end

            local Container=Create("Frame",{
                Size=UDim2.new(1,0,0,0), AutomaticSize=Enum.AutomaticSize.Y,
                BackgroundColor3=Theme.Element, BorderSizePixel=0,
                LayoutOrder=N(), ZIndex=3, Parent=container,
            })
            Corner(Container,6)
            Create("Frame",{Size=UDim2.new(1,0,0,28),BackgroundTransparency=1,ZIndex=1,Parent=Container})

            local ArrowLbl=Create("TextLabel",{
                AnchorPoint=Vector2.new(1,0), Position=UDim2.new(1,-6,0,6),
                Size=UDim2.new(0,16,0,16), BackgroundTransparency=1,
                Text="▾", TextColor3=Theme.TextMuted, TextSize=14,
                Font=Enum.Font.GothamBold, ZIndex=4, Parent=Container,
            })
            local SelLabel=Create("TextLabel",{
                AnchorPoint=Vector2.new(1,0), Position=UDim2.new(1,-24,0,7),
                Size=UDim2.new(0.4,0,0,14), BackgroundTransparency=1,
                Text=Disp(), TextColor3=Theme.TextAccent, TextSize=11,
                Font=Enum.Font.GothamSemibold, TextXAlignment=Enum.TextXAlignment.Right,
                ZIndex=4, Parent=Container,
            })
            TextArea(Container, name, desc, 76)

            local List=Create("ScrollingFrame",{
                Size=UDim2.new(0,0,0,0), BackgroundColor3=Color3.fromRGB(28,28,28),
                BorderSizePixel=0, ZIndex=501, ScrollBarThickness=2,
                ScrollBarImageColor3=Theme.Accent, CanvasSize=UDim2.new(0,0,0,0),
                ClipsDescendants=true, Visible=false, Parent=Overlay,
            })
            Corner(List,6); Stroke(List,Theme.StrokeAccent,1)
            local LL=ListLayout(List,Enum.FillDirection.Vertical,2)
            Padding(List,4,4,4,4)
            LL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                List.CanvasSize=UDim2.new(0,0,0,LL.AbsoluteContentSize.Y+8)
            end)

            local listOpen=false
            local function CloseMulti()
                listOpen=false
                Tween(List,0.2,{Size=UDim2.new(0,List.AbsoluteSize.X,0,0)})
                Tween(ArrowLbl,0.2,{Rotation=0})
                task.delay(0.2,function() List.Visible=false end)
            end
            local function BuildMulti()
                for _,c in ipairs(List:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
                for _,opt in ipairs(options) do
                    local isSel=selected[opt]==true
                    local Row=Create("Frame",{
                        Size=UDim2.new(1,0,0,26),
                        BackgroundColor3=isSel and Theme.AccentDark or Color3.fromRGB(50,50,50),
                        BorderSizePixel=0, ZIndex=502, Parent=List,
                    })
                    Corner(Row,5); if isSel then Stroke(Row,Theme.Accent,1) end
                    local Chk=Create("Frame",{
                        AnchorPoint=Vector2.new(0,0.5), Position=UDim2.new(0,5,0.5,0),
                        Size=UDim2.new(0,14,0,14),
                        BackgroundColor3=isSel and Theme.Accent or Color3.fromRGB(80,80,80),
                        BorderSizePixel=0, ZIndex=503, Parent=Row,
                    })
                    Corner(Chk,3)
                    if isSel then
                        Create("TextLabel",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,
                            Text="✓",TextColor3=Color3.fromRGB(255,255,255),
                            TextSize=10,Font=Enum.Font.GothamBold,ZIndex=504,Parent=Chk})
                    end
                    Create("TextLabel",{
                        AnchorPoint=Vector2.new(0,0.5), Position=UDim2.new(0,24,0.5,0),
                        Size=UDim2.new(1,-30,1,0), BackgroundTransparency=1,
                        Text=tostring(opt),
                        TextColor3=isSel and Theme.TextPrimary or Theme.TextSecondary,
                        TextSize=12, Font=Enum.Font.Gotham,
                        TextXAlignment=Enum.TextXAlignment.Left, ZIndex=503, Parent=Row,
                    })
                    Create("TextButton",{
                        Size=UDim2.new(1,0,1,0), BackgroundTransparency=1,
                        Text="", ZIndex=504, Parent=Row,
                    }).MouseButton1Click:Connect(function()
                        selected[opt]=not selected[opt]
                        if flag then ConkersHub.Flags[flag]=selected end
                        SelLabel.Text=Disp(); BuildMulti(); callback(selected)
                    end)
                end
            end
            BuildMulti()
            local function OpenMulti()
                listOpen=true
                local ap,as=Container.AbsolutePosition,Container.AbsoluteSize
                List.Position=UDim2.new(0,ap.X,0,ap.Y+as.Y+4)
                List.Size=UDim2.new(0,as.X,0,0); List.Visible=true
                Tween(List,0.22,{Size=UDim2.new(0,as.X,0,math.min(#options*30+8,170))})
                Tween(ArrowLbl,0.2,{Rotation=180})
            end
            CloseOnOutsideClick(function() return listOpen end, List, Container, CloseMulti)
            Create("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="",ZIndex=5,Parent=Container})
                .MouseButton1Click:Connect(function() if listOpen then CloseMulti() else OpenMulti() end end)
            local CBtn2=Container:FindFirstChildOfClass("TextButton")
            if CBtn2 then
                CBtn2.MouseEnter:Connect(function() Tween(Container,0.15,{BackgroundColor3=Theme.ElementHover}) end)
                CBtn2.MouseLeave:Connect(function() Tween(Container,0.15,{BackgroundColor3=Theme.Element}) end)
            end
            local M={}
            function M:GetSelected()
                local out={}; for k,v in pairs(selected) do if v then table.insert(out,k) end end; return out
            end
            function M:SetSelected(tbl)
                selected={}; for _,v in ipairs(tbl) do selected[v]=true end
                if flag then ConkersHub.Flags[flag]=selected end
                SelLabel.Text=Disp(); BuildMulti()
            end
            return M
        end

        -- ── Keybind ───────────────────────────────────────────────────────────
        function obj:AddKeybind(cfg)
            cfg=cfg or {}
            local name=cfg.Name or "Keybind"; local default=cfg.Default or Enum.KeyCode.Unknown
            local flag=cfg.Flag; local callback=cfg.Callback or function() end
            local curKey=default; local listening=false
            if flag then ConkersHub.Flags[flag]=curKey end
            local abbr={LeftControl="LCtrl",RightControl="RCtrl",LeftShift="LShift",
                RightShift="RShift",LeftAlt="LAlt",RightAlt="RAlt",Return="Enter",BackSpace="Backsp"}
            local function KStr(k)
                if k==Enum.KeyCode.Unknown then return "Nenhum" end
                local s=tostring(k):gsub("Enum%.KeyCode%.",""); return abbr[s] or s
            end
            local Row=Create("Frame",{Size=UDim2.new(1,0,0,28),BackgroundColor3=Theme.Element,
                BorderSizePixel=0,LayoutOrder=N(),ZIndex=3,Parent=container})
            Corner(Row,6)
            Create("TextLabel",{AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,8,0.5,0),
                Size=UDim2.new(1,-90,1,0),BackgroundTransparency=1,Text=name,
                TextColor3=Theme.TextPrimary,TextSize=13,Font=Enum.Font.GothamSemibold,
                TextXAlignment=Enum.TextXAlignment.Left,ZIndex=4,Parent=Row})
            local Badge=Create("Frame",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-6,0.5,0),
                Size=UDim2.new(0,72,0,20),BackgroundColor3=Color3.fromRGB(40,40,40),
                BorderSizePixel=0,ZIndex=4,Parent=Row})
            Corner(Badge,5)
            local KeyLbl=Create("TextLabel",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,
                Text=KStr(curKey),TextColor3=Theme.TextAccent,TextSize=11,
                Font=Enum.Font.GothamSemibold,ZIndex=5,Parent=Badge})
            local function SetL(v)
                listening=v
                if listening then KeyLbl.Text="..."; Tween(Badge,0.2,{BackgroundColor3=Theme.AccentDark}); Tween(KeyLbl,0.2,{TextColor3=Theme.TextPrimary})
                else KeyLbl.Text=KStr(curKey); Tween(Badge,0.2,{BackgroundColor3=Color3.fromRGB(40,40,40)}); Tween(KeyLbl,0.2,{TextColor3=Theme.TextAccent}) end
            end
            local CB=Create("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="",ZIndex=6,Parent=Row})
            CB.MouseButton1Click:Connect(function() SetL(not listening) end)
            CB.MouseEnter:Connect(function() Tween(Row,0.15,{BackgroundColor3=Theme.ElementHover}) end)
            CB.MouseLeave:Connect(function() Tween(Row,0.15,{BackgroundColor3=Theme.Element}) end)
            UserInputService.InputBegan:Connect(function(input,gpe)
                if gpe then return end
                if listening then
                    if input.UserInputType==Enum.UserInputType.Keyboard then
                        curKey=input.KeyCode; if flag then ConkersHub.Flags[flag]=curKey end; SetL(false); callback(curKey)
                    end
                else if input.KeyCode==curKey then callback(curKey) end end
            end)
            local K={}
            function K:Set(k) curKey=k; if flag then ConkersHub.Flags[flag]=k end; KeyLbl.Text=KStr(k) end
            function K:Get() return curKey end
            return K
        end

        -- ── TextBox ───────────────────────────────────────────────────────────
        function obj:AddTextBox(cfg)
            cfg=cfg or {}
            local name=cfg.Name or "TextBox"; local holder=cfg.Placeholder or "Digite aqui..."
            local default=cfg.Default or ""; local numeric=cfg.Numeric or false
            local flag=cfg.Flag; local callback=cfg.Callback or function() end
            local desc=cfg.Description or ""; local hasDesc=desc~=""
            if flag then ConkersHub.Flags[flag]=default end
            local Container=Create("Frame",{Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,
                BackgroundColor3=Theme.Element,BorderSizePixel=0,LayoutOrder=N(),ZIndex=3,Parent=container})
            Corner(Container,6)
            local CLy=ListLayout(Container,Enum.FillDirection.Vertical,0); CLy.HorizontalAlignment=Enum.HorizontalAlignment.Center
            local NRow=Create("Frame",{Size=UDim2.new(1,0,0,22),BackgroundTransparency=1,ZIndex=3,Parent=Container})
            Create("TextLabel",{Position=UDim2.new(0,8,0.5,-7),Size=UDim2.new(1,-16,0,14),
                BackgroundTransparency=1,Text=name,TextColor3=Theme.TextPrimary,TextSize=13,
                Font=Enum.Font.GothamSemibold,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=4,Parent=NRow})
            if hasDesc then
                local DR=Create("Frame",{Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,
                    BackgroundTransparency=1,ZIndex=3,Parent=Container})
                Padding(DR,0,3,8,8)
                Create("TextLabel",{Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,
                    BackgroundTransparency=1,Text=desc,TextColor3=Theme.TextMuted,TextSize=11,
                    Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true,ZIndex=4,Parent=DR})
            end
            local IRow=Create("Frame",{Size=UDim2.new(1,0,0,28),BackgroundTransparency=1,ZIndex=3,Parent=Container})
            local IBg=Create("Frame",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(0.5,0,0.5,0),
                Size=UDim2.new(1,-14,0,20),BackgroundColor3=Color3.fromRGB(78,78,78),
                BorderSizePixel=0,ZIndex=4,Parent=IRow})
            Corner(IBg,5)
            local IStroke=Stroke(IBg,Theme.Stroke,1)
            local TB=Create("TextBox",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,
                PlaceholderText=holder,PlaceholderColor3=Theme.TextMuted,Text=default,
                TextColor3=Theme.TextPrimary,TextSize=12,Font=Enum.Font.Gotham,
                ClearTextOnFocus=false,ZIndex=5,Parent=IBg})
            Padding(TB,0,0,6,6)
            TB.Focused:Connect(function() Tween(IStroke,0.2,{Color=Theme.Accent}); Tween(IBg,0.2,{BackgroundColor3=Color3.fromRGB(55,28,80)}) end)
            TB.FocusLost:Connect(function(enter)
                Tween(IStroke,0.2,{Color=Theme.Stroke}); Tween(IBg,0.2,{BackgroundColor3=Color3.fromRGB(78,78,78)})
                local val=TB.Text
                if numeric then val=tonumber(val) or tonumber(default) or 0; TB.Text=tostring(val) end
                if flag then ConkersHub.Flags[flag]=val end; callback(val,enter)
            end)
            local TB2={}
            function TB2:Set(v) TB.Text=tostring(v); if flag then ConkersHub.Flags[flag]=v end end
            function TB2:Get() return TB.Text end
            return TB2
        end

        -- ── ColorPicker ───────────────────────────────────────────────────────
        function obj:AddColorPicker(cfg)
            cfg=cfg or {}
            local name=cfg.Name or "Color"; local default=cfg.Default or Color3.fromRGB(137,6,255)
            local flag=cfg.Flag; local callback=cfg.Callback or function() end
            local h,s,v=Color3.toHSV(default); local curColor=default
            if flag then ConkersHub.Flags[flag]=curColor end
            local Container=Create("Frame",{Size=UDim2.new(1,0,0,28),
                BackgroundColor3=Theme.Element,BorderSizePixel=0,LayoutOrder=N(),ZIndex=3,Parent=container})
            Corner(Container,6)
            Create("TextLabel",{AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,8,0.5,0),
                Size=UDim2.new(1,-50,1,0),BackgroundTransparency=1,Text=name,
                TextColor3=Theme.TextPrimary,TextSize=13,Font=Enum.Font.GothamSemibold,
                TextXAlignment=Enum.TextXAlignment.Left,ZIndex=4,Parent=Container})
            local Preview=Create("Frame",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-6,0.5,0),
                Size=UDim2.new(0,22,0,22),BackgroundColor3=curColor,BorderSizePixel=0,ZIndex=4,Parent=Container})
            Corner(Preview,5); Stroke(Preview,Theme.Stroke,1)
            local Popup=Create("Frame",{Size=UDim2.new(0,0,0,0),BackgroundColor3=Color3.fromRGB(28,28,28),
                BorderSizePixel=0,ZIndex=501,ClipsDescendants=true,Visible=false,Parent=Overlay})
            Corner(Popup,8); Stroke(Popup,Theme.StrokeAccent,1)
            local PopContent=Create("Frame",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,ZIndex=502,Parent=Popup})
            Padding(PopContent,8,8,8,8)
            local function MkSlider(label,yPos,initVal)
                Create("TextLabel",{Position=UDim2.new(0,0,0,yPos),Size=UDim2.new(1,0,0,12),
                    BackgroundTransparency=1,Text=label,TextColor3=Theme.TextSecondary,
                    TextSize=10,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=502,Parent=PopContent})
                local Tr=Create("Frame",{Position=UDim2.new(0,0,0,yPos+14),Size=UDim2.new(1,0,0,8),
                    BackgroundColor3=Color3.fromRGB(255,255,255),BorderSizePixel=0,ZIndex=502,Parent=PopContent})
                Corner(Tr,4)
                local Kn=Create("Frame",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(initVal,0,0.5,0),
                    Size=UDim2.new(0,12,0,12),BackgroundColor3=Color3.fromRGB(255,255,255),
                    BorderSizePixel=0,ZIndex=504,Parent=Tr})
                Corner(Kn,6); Stroke(Kn,Color3.fromRGB(0,0,0),1.5)
                return Tr,Kn
            end
            local hTr,hKn=MkSlider("Hue",0,h)
            local sTr,sKn=MkSlider("Saturation",30,s)
            local vTr,vKn=MkSlider("Brightness",60,v)
            local hG=Instance.new("UIGradient")
            hG.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromHSV(0,1,1)),
                ColorSequenceKeypoint.new(0.167,Color3.fromHSV(0.167,1,1)),
                ColorSequenceKeypoint.new(0.333,Color3.fromHSV(0.333,1,1)),
                ColorSequenceKeypoint.new(0.5,Color3.fromHSV(0.5,1,1)),
                ColorSequenceKeypoint.new(0.667,Color3.fromHSV(0.667,1,1)),
                ColorSequenceKeypoint.new(0.833,Color3.fromHSV(0.833,1,1)),
                ColorSequenceKeypoint.new(1,Color3.fromHSV(1,1,1))}); hG.Parent=hTr
            local sG=Instance.new("UIGradient"); sG.Color=ColorSequence.new(Color3.fromHSV(h,0,1),Color3.fromHSV(h,1,1)); sG.Parent=sTr
            local vG=Instance.new("UIGradient"); vG.Color=ColorSequence.new(Color3.fromHSV(h,s,0),Color3.fromHSV(h,s,1)); vG.Parent=vTr
            local function Apply()
                curColor=Color3.fromHSV(h,s,v); Preview.BackgroundColor3=curColor
                sG.Color=ColorSequence.new(Color3.fromHSV(h,0,1),Color3.fromHSV(h,1,1))
                vG.Color=ColorSequence.new(Color3.fromHSV(h,s,0),Color3.fromHSV(h,s,1))
                if flag then ConkersHub.Flags[flag]=curColor end; callback(curColor)
            end
            local hsvDragging=false
            local function MkTI(track,knob,onVal)
                local drag=false
                track.InputBegan:Connect(function(i)
                    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
                        drag=true; hsvDragging=true
                        local rel=math.clamp((i.Position.X-track.AbsolutePosition.X)/track.AbsoluteSize.X,0,1)
                        knob.Position=UDim2.new(rel,0,0.5,0); onVal(rel); Apply()
                    end
                end)
                UserInputService.InputChanged:Connect(function(i)
                    if not drag then return end
                    if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then
                        local rel=math.clamp((i.Position.X-track.AbsolutePosition.X)/track.AbsoluteSize.X,0,1)
                        knob.Position=UDim2.new(rel,0,0.5,0); onVal(rel); Apply()
                    end
                end)
                UserInputService.InputEnded:Connect(function(i)
                    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
                        drag=false; hsvDragging=false
                    end
                end)
            end
            MkTI(hTr,hKn,function(val) h=val end); MkTI(sTr,sKn,function(val) s=val end); MkTI(vTr,vKn,function(val) v=val end)
            local popOpen=false; local popupW=0
            UserInputService.InputBegan:Connect(function(input)
                if not popOpen or hsvDragging then return end
                if input.UserInputType~=Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.Touch then return end
                local mp=input.Position
                local function ins(f) if not f or not f.Visible then return false end; local a,sz=f.AbsolutePosition,f.AbsoluteSize; return mp.X>=a.X and mp.X<=a.X+sz.X and mp.Y>=a.Y and mp.Y<=a.Y+sz.Y end
                if not ins(Popup) and not ins(Container) then
                    popOpen=false; Tween(Popup,0.22,{Size=UDim2.new(0,popupW,0,0)}); task.delay(0.22,function() Popup.Visible=false end)
                end
            end)
            local CBtn=Create("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="",ZIndex=5,Parent=Container})
            CBtn.MouseButton1Click:Connect(function()
                if popOpen then return end
                popOpen=true; local ap,as=Container.AbsolutePosition,Container.AbsoluteSize; popupW=as.X
                Popup.Position=UDim2.new(0,ap.X,0,ap.Y+as.Y+4); Popup.Size=UDim2.new(0,popupW,0,0); Popup.Visible=true
                Tween(Popup,0.22,{Size=UDim2.new(0,popupW,0,100)})
            end)
            CBtn.MouseEnter:Connect(function() Tween(Container,0.15,{BackgroundColor3=Theme.ElementHover}) end)
            CBtn.MouseLeave:Connect(function() Tween(Container,0.15,{BackgroundColor3=Theme.Element}) end)
            local CP={}
            function CP:Set(color)
                curColor=color; h,s,v=Color3.toHSV(color)
                hKn.Position=UDim2.new(h,0,0.5,0); sKn.Position=UDim2.new(s,0,0.5,0); vKn.Position=UDim2.new(v,0,0.5,0)
                Preview.BackgroundColor3=color; if flag then ConkersHub.Flags[flag]=color end; Apply()
            end
            function CP:Get() return curColor end
            return CP
        end

        -- ── Label ─────────────────────────────────────────────────────────────
        function obj:AddLabel(cfg)
            cfg=cfg or {}
            local Lbl=Create("TextLabel",{Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,
                BackgroundTransparency=1,Text=cfg.Text or cfg.Name or "Label",
                TextColor3=cfg.Color or Theme.TextSecondary,TextSize=cfg.TextSize or 12,
                Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true,
                LayoutOrder=N(),ZIndex=3,Parent=container})
            Padding(Lbl,2,2,6,6)
            local L={}
            function L:Set(t) Lbl.Text=tostring(t) end
            function L:SetColor(c) Lbl.TextColor3=c end
            return L
        end

        -- ── Separator ─────────────────────────────────────────────────────────
        function obj:AddSeparator()
            Create("Frame",{Size=UDim2.new(1,-12,0,1),BackgroundColor3=Theme.Stroke,
                BorderSizePixel=0,LayoutOrder=N(),ZIndex=3,Parent=container})
        end

        -- ── Dialog ────────────────────────────────────────────────────────────
        function obj:AddDialog(cfg)
            cfg=cfg or {}
            local name=cfg.Name or "Abrir Dialog"; local guiText=cfg.GuiText or "Tem certeza?"
            local yesBtn=cfg.YesBtn or "Sim"; local noBtn=cfg.NoBtn or "Não"
            local callback=cfg.Callback or function() end
            local Btn=Create("TextButton",{Size=UDim2.new(1,0,0,28),BackgroundColor3=Theme.Element,
                BorderSizePixel=0,Text="",LayoutOrder=N(),ZIndex=3,Parent=container})
            Corner(Btn,6); Stroke(Btn,Theme.StrokeAccent,1)
            Create("TextLabel",{AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,8,0.5,0),
                Size=UDim2.new(0,16,0,16),BackgroundTransparency=1,Text="⚠",
                TextColor3=Theme.Accent,TextSize=13,Font=Enum.Font.GothamBold,ZIndex=4,Parent=Btn})
            Create("TextLabel",{AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,28,0.5,0),
                Size=UDim2.new(1,-36,1,0),BackgroundTransparency=1,Text=name,
                TextColor3=Theme.TextPrimary,TextSize=12,Font=Enum.Font.GothamSemibold,
                TextXAlignment=Enum.TextXAlignment.Center,ZIndex=4,Parent=Btn})
            Btn.MouseEnter:Connect(function() Tween(Btn,0.15,{BackgroundColor3=Theme.ElementHover}) end)
            Btn.MouseLeave:Connect(function() Tween(Btn,0.15,{BackgroundColor3=Theme.Element}) end)
            Btn.MouseButton1Down:Connect(function() Tween(Btn,0.08,{BackgroundColor3=Theme.ElementPress}) end)
            Btn.MouseButton1Up:Connect(function() Tween(Btn,0.1,{BackgroundColor3=Theme.ElementHover}) end)
            Btn.MouseButton1Click:Connect(function()
                OpenDialog({GuiText=guiText,YesBtn=yesBtn,NoBtn=noBtn,Callback=callback})
            end)
        end

        return obj
    end -- MakeComponents

    -- ── Window ────────────────────────────────────────────────────────────────
    local Window = {}
    local tabs = {}
    local activeTab = nil

    function Window:Destroy() ScreenGui:Destroy() end

    -- ── [Fix 3+4] AddFloatButton ───────────────────────────────────────────────
    -- Drag corrigido: AbsolutePosition lido UMA VEZ no início.
    -- Clique vs Drag detectados por threshold de pixels.
    -- [Fix 4] Sombra removida: sem ImageLabel shadow.
    function Window:AddFloatButton(cfg)
        cfg = cfg or {}
        local btnCfg = cfg.Button or {}
        local cornerCfg = cfg.Corner or {}

        local img = btnCfg.Image                  or ""
        local bgT = btnCfg.BackgroundTransparency or 0
        local bgColor = btnCfg.BackgroundColor3        or Theme.Accent
        local radius = cornerCfg.CornerRadius         or UDim.new(0, 24)

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

        -- Drag com detecção de clique vs arrasto
        local fDragging = false
        local fDragStartInput = nil
        local fFrameStartAbs = nil
        local fWasDragged = false
        local DRAG_THRESHOLD = 8

        FloatBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
                fDragging = true
                fWasDragged = false
                fDragStartInput = getInputPos(input)
                fFrameStartAbs = FloatBtn.AbsolutePosition
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if not fDragging then return end
            if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then
                local delta = getInputPos(input) - fDragStartInput
                if delta.Magnitude > DRAG_THRESHOLD then
                    fWasDragged = true
                end
                local newX = fFrameStartAbs.X + delta.X
                local newY = fFrameStartAbs.Y + delta.Y
                FloatBtn.Position = UDim2.new(0, newX, 0, newY)
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
                fDragging = false
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

    -- ── AddTab ────────────────────────────────────────────────────────────────
    function Window:AddTab(tabConfig)
        tabConfig = tabConfig or {}
        local tabName = tabConfig.Name or ("Tab " .. (#tabs + 1))

        local TabBtn = Create("TextButton", {
            Name=tabName, Size=UDim2.new(1,0,0,30),
            BackgroundColor3=Theme.TabInactive, BorderSizePixel=0,
            Text=tabName, TextColor3=Theme.TextPrimary,
            TextSize=13, FontFace=FontDenk, ZIndex=4, Parent=Sidebar,
        })
        Corner(TabBtn, 6)

        local TabPage = Create("ScrollingFrame", {
            Name=tabName.."Page", Size=UDim2.new(1,0,1,0),
            BackgroundTransparency=1, BorderSizePixel=0,
            ScrollBarThickness=3, ScrollBarImageColor3=Theme.Accent,
            CanvasSize=UDim2.new(0,0,0,0), Visible=false, ZIndex=2, Parent=ContentArea,
        })
        local PLy = ListLayout(TabPage, Enum.FillDirection.Vertical, 5)
        PLy.HorizontalAlignment = Enum.HorizontalAlignment.Center
        Padding(TabPage, 7, 7, 5, 5)
        PLy:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabPage.CanvasSize = UDim2.new(0,0,0, PLy.AbsoluteContentSize.Y + 14)
        end)

        local function ActivateTab()
            if activeTab then
                Tween(activeTab.btn,0.2,{BackgroundColor3=Theme.TabInactive})
                activeTab.page.Visible=false
            end
            activeTab={btn=TabBtn, page=TabPage}
            Tween(TabBtn,0.2,{BackgroundColor3=Theme.TabActive})
            TabPage.Visible=true
        end

        TabBtn.MouseButton1Click:Connect(ActivateTab)
        TabBtn.MouseEnter:Connect(function()
            if activeTab and activeTab.btn~=TabBtn then
                Tween(TabBtn,0.15,{BackgroundColor3=Theme.ElementHover})
            end
        end)
        TabBtn.MouseLeave:Connect(function()
            if activeTab and activeTab.btn~=TabBtn then
                Tween(TabBtn,0.15,{BackgroundColor3=Theme.TabInactive})
            end
        end)
        if #tabs==0 then ActivateTab() end

        local Tab = MakeComponents(TabPage)
        table.insert(tabs, Tab)

        function Tab:Select() ActivateTab() end

        function Tab:AddSection(sectionConfig)
            sectionConfig = sectionConfig or {}
            local secName = sectionConfig.Name or "Section"

            local SF = Create("Frame", {
                Name=secName, Size=UDim2.new(1,-4,0,0), AutomaticSize=Enum.AutomaticSize.Y,
                BackgroundColor3=Theme.Section, BorderSizePixel=0,
                LayoutOrder=#TabPage:GetChildren(), ZIndex=2, Parent=TabPage,
            })
            Corner(SF, 8)

            local SH = Create("Frame", {
                Size=UDim2.new(1,0,0,26), BackgroundColor3=Theme.SectionHeader,
                BorderSizePixel=0, ZIndex=3, Parent=SF,
            })
            Corner(SH, 8)
            Create("Frame", {
                Position=UDim2.new(0,0,0.5,0), Size=UDim2.new(1,0,0.5,0),
                BackgroundColor3=Theme.SectionHeader, BorderSizePixel=0, ZIndex=3, Parent=SH,
            })

            local SA = Create("Frame", {
                AnchorPoint=Vector2.new(0,0.5), Position=UDim2.new(0,7,0.5,0),
                Size=UDim2.new(0,3,0,14), BackgroundColor3=Theme.Accent,
                BorderSizePixel=0, ZIndex=4, Parent=SH,
            })
            Corner(SA, 2)

            Create("TextLabel", {
                AnchorPoint=Vector2.new(0,0.5), Position=UDim2.new(0,16,0.5,0),
                Size=UDim2.new(1,-20,1,0), BackgroundTransparency=1, Text=secName,
                TextColor3=Theme.TextPrimary, TextSize=12, Font=Enum.Font.GothamBold,
                TextXAlignment=Enum.TextXAlignment.Left, ZIndex=4, Parent=SH,
            })

            local SC = Create("Frame", {
                Name="Content", Position=UDim2.new(0,0,0,27),
                Size=UDim2.new(1,0,0,0), AutomaticSize=Enum.AutomaticSize.Y,
                BackgroundTransparency=1, ZIndex=2, Parent=SF,
            })
            local SLy2 = ListLayout(SC, Enum.FillDirection.Vertical, 4)
            SLy2.HorizontalAlignment = Enum.HorizontalAlignment.Center
            Padding(SC, 5, 7, 5, 5)

            return MakeComponents(SC)
        end

        return Tab
    end

    return Window
end

-- ─── API pública ──────────────────────────────────────────────────────────────
function ConkersHub:GetFlag(flag)
    return ConkersHub.Flags[flag]
end

return ConkersHub

--[[
╔══════════════════════════════════════════════════════╗
║        CONKERS HUB v1.0 — EXEMPLO COMPLETO          ║
╠══════════════════════════════════════════════════════╣

local ConkersHub = loadstring(game:HttpGet("URL_AQUI"))()

ConkersHub:SetTheme("Green")   -- Dark | Purple | Green

local Window = ConkersHub:CreateWindow({
    Title = "Conkers Hub",
    By = "By SeuNome",
    Game = "Jogo",
    Width = 460,
    Height = 330,
})

Window:AddFloatButton({
    Button = {
        Image = "rbxassetid://71014873973869",
        BackgroundTransparency = 0,
        BackgroundColor3 = Color3.fromRGB(40, 180, 70),
    },
    Corner = { CornerRadius = UDim.new(35, 1) },
})

local TabMain = Window:AddTab({ Name = "Main"   })
local TabPlayer = Window:AddTab({ Name = "Player" })
local TabVisual = Window:AddTab({ Name = "Visual" })

-- Direto na Tab (sem Section)
TabMain:AddToggle({
    Name = "Aimbot", Default = false, Flag = "Aimbot",
    Description = "Mira automática nos inimigos.",
    Callback = function(s) print("Aimbot:", s) end,
})

-- Com Section (opcional)
local Sec = TabMain:AddSection({ Name = "Combat" })
Sec:AddSlider({ Name="FOV", Min=10, Max=360, Default=90, Suffix="°", Flag="FOV",
    Callback=function(v) print(v) end })
Sec:AddDropdown({ Name="Hit Part", Options={"Head","Torso","Random"}, Default="Head",
    Flag="HitPart", Callback=function(v) print(v) end })
Sec:AddDialog({ Name="Resetar", GuiText="Isso vai resetar tudo. Continuar?",
    YesBtn="Sim", NoBtn="Não", Callback=function() print("Resetado!") end })

local SecP = TabPlayer:AddSection({ Name = "Player" })
SecP:AddSlider({ Name="WalkSpeed", Min=16, Max=500, Default=16, Suffix=" st", Flag="WS",
    Callback=function(v)
        local c=game.Players.LocalPlayer.Character
        if c then c.Humanoid.WalkSpeed=v end
    end })

local SecV = TabVisual:AddSection({ Name = "Visual" })
SecV:AddColorPicker({ Name="Cor ESP", Default=Color3.fromRGB(40,180,70),
    Flag="ESPColor", Callback=function(c) print(c) end })
SecV:AddLabel({ Text="Conkers Hub v1.0", Color=Color3.fromRGB(40,180,70) })

print(ConkersHub:GetFlag("Aimbot"))
-- Window:Destroy()
--]]
