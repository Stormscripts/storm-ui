--[[
    ╔══════════════════════════════════════════╗
    ║        STORM UI LIBRARY  v1.1            ║
    ║     Modern Roblox Interface Library      ║
    ╠══════════════════════════════════════════╣
    ║  Componentes:                            ║
    ║   Button  Toggle  Slider  Dropdown       ║
    ║   MultiDropdown  Keybind  TextBox        ║
    ║   ColorPicker  Label  Section  Tabs      ║
    ╠══════════════════════════════════════════╣
    ║  Uso rápido:                             ║
    ║   local S = loadstring(...)()            ║
    ║   local W = S:CreateWindow({...})        ║
    ║   local T = W:AddTab({Name="Main"})      ║
    ║   local S = T:AddSection({Name="..."})   ║
    ║   S:AddToggle({Name="X",Callback=...})   ║
    ╚══════════════════════════════════════════╝

    CORREÇÕES v1.1
    ─────────────────────────────────────────
    [Bug 1] Toggle/Minimize double-fire
      Causa: MouseButton1Click + InputBegan:Touch
      disparavam juntos no mobile, chamando a
      mesma função duas vezes (ON→OFF imediato).
      Fix: removido InputBegan:Touch duplicado.
      Agora só MouseButton1Click é usado — ele
      funciona em PC e mobile sem double-fire.

    [Bug 2] Cantos pontudos ao minimizar
      Causa: TopBarFix (frame que quadra os
      cantos inferiores do TopBar) continuava
      visível, deixando a UI com pontas.
      Fix: TopBarFix e AccentLine são ocultados
      ao minimizar e restaurados ao expandir.

    [Bug 3] Dropdowns por baixo de outros elementos
      Causa: os popups eram filhos de elementos
      dentro do ScrollingFrame (ClipsDescendants=true),
      sendo cortados pela ScrollingFrame pai.
      Fix: popups parented ao frame Overlay
      (filho direto do ScreenGui, ZIndex 500),
      posicionados via AbsolutePosition ao abrir.
      Também adicionado "fechar ao clicar fora".

    [Bug 4] Interface muito alta no mobile
      Fix: altura padrão reduzida 500→420px.

    [Limpeza] Espaçamento de alinhamento removido.
--]]

-- ─── Serviços ─────────────────────────────────────────────────────────────────
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- ─── Tema ─────────────────────────────────────────────────────────────────────
local Theme = {
    Background = Color3.fromRGB(11, 11, 15),
    TopBar = Color3.fromRGB(16, 16, 22),
    TabBar = Color3.fromRGB(13, 13, 18),
    Section = Color3.fromRGB(18, 18, 26),
    Element = Color3.fromRGB(23, 23, 33),
    ElementHover = Color3.fromRGB(32, 32, 46),
    ElementPress = Color3.fromRGB(15, 15, 22),
    Accent = Color3.fromRGB(100, 65, 230),
    AccentDark = Color3.fromRGB(68, 42, 160),
    AccentLight = Color3.fromRGB(140, 105, 255),
    AccentAlt = Color3.fromRGB(60, 160, 255),
    TabActive = Color3.fromRGB(100, 65, 230),
    TabInactive = Color3.fromRGB(22, 22, 32),
    ToggleOn = Color3.fromRGB(100, 65, 230),
    ToggleOff = Color3.fromRGB(40, 40, 58),
    SliderFill = Color3.fromRGB(100, 65, 230),
    SliderBg = Color3.fromRGB(32, 32, 48),
    TextPrimary = Color3.fromRGB(240, 238, 255),
    TextSecondary = Color3.fromRGB(155, 150, 180),
    TextMuted = Color3.fromRGB(90, 88, 115),
    TextAccent = Color3.fromRGB(140, 105, 255),
    Stroke = Color3.fromRGB(35, 35, 52),
    StrokeAccent = Color3.fromRGB(80, 50, 180),
}

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

local function Gradient(parent, c0, c1, rot)
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new(c0, c1)
    g.Rotation = rot or 0
    g.Parent = parent
    return g
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

-- ─── Helper: fechar popup ao clicar fora ──────────────────────────────────────
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

        if not inFrame(popup) and not inFrame(trigger) then
            closeFn()
        end
    end)
end

-- ─── Biblioteca ───────────────────────────────────────────────────────────────
local StormUI = {}
StormUI.__index = StormUI
StormUI.Flags = {}
StormUI.Theme = Theme

-- ─── CreateWindow ─────────────────────────────────────────────────────────────
function StormUI:CreateWindow(config)
    config = config or {}
    local title = config.Title or "Storm UI"
    local subtitle = config.Subtitle or ""
    local width = config.Width or 320
    local height = config.Height or 420
    local startPos = config.Position or UDim2.new(0.5, -(width / 2), 0.5, -(height / 2))

    -- ScreenGui
    local ScreenGui = Create("ScreenGui", {
        Name = "StormUI_" .. title,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 999,
        IgnoreGuiInset = true,
    })
    local ok = pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
    if not ok then
        ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end

    -- [Fix Bug 3] Overlay — filho direto do ScreenGui, ZIndex alto, sem clipping.
    -- Todos os popups (dropdowns, colorpicker) são parented aqui para
    -- não sofrerem clipping do ScrollingFrame ou de outros elementos.
    local Overlay = Create("Frame", {
        Name = "StormOverlay",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ZIndex = 500,
        Parent = ScreenGui,
    })

    -- Janela principal
    local Main = Create("Frame", {
        Name = "StormMain",
        Position = startPos,
        Size = UDim2.new(0, width, 0, height),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        ClipsDescendants = false,
        Parent = ScreenGui,
    })
    Corner(Main, 12)
    Stroke(Main, Theme.Stroke, 1.5)

    -- Sombra
    Create("ImageLabel", {
        Name = "Shadow",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 6),
        Size = UDim2.new(1, 40, 1, 40),
        BackgroundTransparency = 1,
        Image = "rbxassetid://6015897843",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.45,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49, 49, 450, 450),
        ZIndex = 0,
        Parent = Main,
    })

    -- ── TopBar ────────────────────────────────────────────────────────────────
    local TopBar = Create("Frame", {
        Name = "TopBar",
        Size = UDim2.new(1, 0, 0, 46),
        BackgroundColor3 = Theme.TopBar,
        BorderSizePixel = 0,
        ZIndex = 2,
        Parent = Main,
    })
    Corner(TopBar, 12)

    -- [Fix Bug 2] Guardamos referência do TopBarFix.
    -- Este frame "quadra" os cantos inferiores do TopBar enquanto a UI está
    -- expandida (necessário para ele conectar visualmente ao conteúdo abaixo).
    -- Ao minimizar, ocultamos ele para que os 4 cantos fiquem arredondados.
    local TopBarFix = Create("Frame", {
        Name = "CornerFix",
        Position = UDim2.new(0, 0, 0.5, 0),
        Size = UDim2.new(1, 0, 0.5, 0),
        BackgroundColor3 = Theme.TopBar,
        BorderSizePixel = 0,
        ZIndex = 2,
        Parent = TopBar,
    })

    -- Linha de acento (também oculta ao minimizar)
    local AccentLine = Create("Frame", {
        Name = "AccentLine",
        Position = UDim2.new(0, 0, 1, -1),
        Size = UDim2.new(1, 0, 0, 2),
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
        ZIndex = 3,
        Parent = TopBar,
    })
    Gradient(AccentLine, Color3.fromRGB(60, 35, 160), Color3.fromRGB(130, 90, 255))

    -- Ícone pulsante
    local IconFrame = Create("Frame", {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 12, 0.5, 0),
        Size = UDim2.new(0, 10, 0, 10),
        BackgroundColor3 = Theme.AccentLight,
        BorderSizePixel = 0,
        ZIndex = 3,
        Parent = TopBar,
    })
    Corner(IconFrame, 5)

    task.spawn(function()
        while TopBar and TopBar.Parent do
            Tween(IconFrame, 1.2, {BackgroundColor3 = Theme.AccentAlt}, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            task.wait(1.2)
            Tween(IconFrame, 1.2, {BackgroundColor3 = Theme.AccentLight}, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            task.wait(1.2)
        end
    end)

    -- Título / Subtítulo
    local titleOffsetY = subtitle ~= "" and -8 or 0

    Create("TextLabel", {
        Name = "Title",
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 28, 0.5, titleOffsetY),
        Size = UDim2.new(1, -90, 0, 18),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Theme.TextPrimary,
        TextSize = 15,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 3,
        Parent = TopBar,
    })

    if subtitle ~= "" then
        Create("TextLabel", {
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.new(0, 28, 0.5, 8),
            Size = UDim2.new(1, -90, 0, 12),
            BackgroundTransparency = 1,
            Text = subtitle,
            TextColor3 = Theme.TextMuted,
            TextSize = 11,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 3,
            Parent = TopBar,
        })
    end

    -- Botão minimizar
    local MinBtn = Create("TextButton", {
        Name = "Minimize",
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -10, 0.5, 0),
        Size = UDim2.new(0, 26, 0, 26),
        BackgroundColor3 = Theme.Element,
        BorderSizePixel = 0,
        Text = "─",
        TextColor3 = Theme.TextSecondary,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        ZIndex = 4,
        Parent = TopBar,
    })
    Corner(MinBtn, 7)
    Stroke(MinBtn, Theme.Stroke, 1)

    MinBtn.MouseEnter:Connect(function()
        Tween(MinBtn, 0.15, {BackgroundColor3 = Theme.Accent, TextColor3 = Theme.TextPrimary})
    end)
    MinBtn.MouseLeave:Connect(function()
        Tween(MinBtn, 0.15, {BackgroundColor3 = Theme.Element, TextColor3 = Theme.TextSecondary})
    end)

    -- ── Conteúdo ──────────────────────────────────────────────────────────────
    local Content = Create("Frame", {
        Name = "Content",
        Position = UDim2.new(0, 0, 0, 47),
        Size = UDim2.new(1, 0, 1, -47),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        ZIndex = 2,
        Parent = Main,
    })

    -- Tab bar
    local TabBar = Create("ScrollingFrame", {
        Name = "TabBar",
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundColor3 = Theme.TabBar,
        BorderSizePixel = 0,
        ScrollBarThickness = 0,
        ScrollingDirection = Enum.ScrollingDirection.X,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ZIndex = 3,
        Parent = Content,
    })
    local TabLayout = ListLayout(TabBar, Enum.FillDirection.Horizontal, 4)
    TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    Padding(TabBar, 5, 5, 6, 6)

    TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabBar.CanvasSize = UDim2.new(0, TabLayout.AbsoluteContentSize.X + 12, 0, 0)
    end)

    -- Separador tab/conteúdo
    Create("Frame", {
        Position = UDim2.new(0, 0, 0, 36),
        Size = UDim2.new(1, 0, 0, 1),
        BackgroundColor3 = Theme.Stroke,
        BorderSizePixel = 0,
        ZIndex = 3,
        Parent = Content,
    })

    -- Container das páginas
    local TabContent = Create("Frame", {
        Name = "TabContent",
        Position = UDim2.new(0, 0, 0, 38),
        Size = UDim2.new(1, 0, 1, -38),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        ZIndex = 2,
        Parent = Content,
    })

    -- ── Minimizar ─────────────────────────────────────────────────────────────
    -- [Fix Bug 1 + Bug 2]
    -- Usamos apenas MouseButton1Click (funciona no PC e mobile).
    -- O bug era ter MouseButton1Click + InputBegan:Touch, que no mobile
    -- disparam juntos, causando minimizar→restaurar imediato.
    -- Ao minimizar: TopBarFix e AccentLine são ocultados → cantos arredondados.
    local minimized = false
    local fullSize = UDim2.new(0, width, 0, height)
    local miniSize = UDim2.new(0, width, 0, 46)

    MinBtn.MouseButton1Click:Connect(function()
        minimized = not minimized

        if minimized then
            Content.Visible = false
            TopBarFix.Visible = false
            AccentLine.Visible = false
            Tween(Main, 0.3, {Size = miniSize})
            MinBtn.Text = "+"
        else
            TopBarFix.Visible = true
            AccentLine.Visible = true
            Tween(Main, 0.3, {Size = fullSize})
            MinBtn.Text = "─"
            task.delay(0.28, function()
                if not minimized then
                    Content.Visible = true
                end
            end)
        end
    end)

    MakeDraggable(TopBar, Main)

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

        local TabBtn = Create("TextButton", {
            Name = tabName,
            AutomaticSize = Enum.AutomaticSize.X,
            Size = UDim2.new(0, 0, 1, 0),
            BackgroundColor3 = Theme.TabInactive,
            BorderSizePixel = 0,
            Text = tabName,
            TextColor3 = Theme.TextSecondary,
            TextSize = 13,
            Font = Enum.Font.GothamSemibold,
            ZIndex = 4,
            Parent = TabBar,
        })
        Corner(TabBtn, 7)
        Padding(TabBtn, 0, 0, 12, 12)

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
            Parent = TabContent,
        })
        local PageLayout = ListLayout(TabPage, Enum.FillDirection.Vertical, 6)
        PageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        Padding(TabPage, 8, 8, 6, 6)

        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabPage.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 14)
        end)

        local function ActivateTab()
            if activeTab then
                Tween(activeTab.btn, 0.2, {BackgroundColor3 = Theme.TabInactive, TextColor3 = Theme.TextSecondary})
                activeTab.page.Visible = false
            end
            activeTab = {btn = TabBtn, page = TabPage}
            Tween(TabBtn, 0.2, {BackgroundColor3 = Theme.TabActive, TextColor3 = Theme.TextPrimary})
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

        function Tab:Select()
            ActivateTab()
        end

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
            Corner(SectionFrame, 10)
            Stroke(SectionFrame, Theme.Stroke, 1)

            -- Cabeçalho da seção
            local SecHeader = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 32),
                BackgroundColor3 = Theme.Element,
                BorderSizePixel = 0,
                ZIndex = 3,
                Parent = SectionFrame,
            })
            Corner(SecHeader, 10)
            -- Quadra cantos inferiores do cabeçalho
            Create("Frame", {
                Position = UDim2.new(0, 0, 0.5, 0),
                Size = UDim2.new(1, 0, 0.5, 0),
                BackgroundColor3 = Theme.Element,
                BorderSizePixel = 0,
                ZIndex = 3,
                Parent = SecHeader,
            })

            local SecAccent = Create("Frame", {
                AnchorPoint = Vector2.new(0, 0.5),
                Position = UDim2.new(0, 10, 0.5, 0),
                Size = UDim2.new(0, 3, 0, 16),
                BackgroundColor3 = Theme.Accent,
                BorderSizePixel = 0,
                ZIndex = 4,
                Parent = SecHeader,
            })
            Corner(SecAccent, 2)
            Gradient(SecAccent, Theme.AccentDark, Theme.AccentLight, 90)

            Create("TextLabel", {
                AnchorPoint = Vector2.new(0, 0.5),
                Position = UDim2.new(0, 20, 0.5, 0),
                Size = UDim2.new(1, -24, 1, 0),
                BackgroundTransparency = 1,
                Text = secName,
                TextColor3 = Theme.TextPrimary,
                TextSize = 12,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 4,
                Parent = SecHeader,
            })

            -- Conteúdo da seção
            local SecContent = Create("Frame", {
                Name = "Content",
                Position = UDim2.new(0, 0, 0, 33),
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                ZIndex = 2,
                Parent = SectionFrame,
            })
            local SecLayout = ListLayout(SecContent, Enum.FillDirection.Vertical, 4)
            SecLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            Padding(SecContent, 6, 10, 7, 7)

            local Section = {}
            local elOrder = 0

            local function NextOrder()
                elOrder = elOrder + 1
                return elOrder
            end

            -- ── Button ────────────────────────────────────────────────────────
            function Section:AddButton(cfg)
                cfg = cfg or {}
                local name = cfg.Name or "Button"
                local desc = cfg.Desc or ""
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
                Corner(Btn, 7)
                Stroke(Btn, Theme.Stroke, 1)

                local BtnBar = Create("Frame", {
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, 0, 0.5, 0),
                    Size = UDim2.new(0, 3, 0, 18),
                    BackgroundColor3 = Theme.Accent,
                    BorderSizePixel = 0,
                    ZIndex = 4,
                    Parent = Btn,
                })
                Corner(BtnBar, 2)

                Create("TextLabel", {
                    AnchorPoint = Vector2.new(0, hasDesc and 0 or 0.5),
                    Position = UDim2.new(0, 12, hasDesc and 0 or 0.5, hasDesc and 6 or 0),
                    Size = UDim2.new(1, -20, 0, 16),
                    BackgroundTransparency = 1,
                    Text = name,
                    TextColor3 = Theme.TextPrimary,
                    TextSize = 13,
                    Font = Enum.Font.GothamSemibold,
                    TextXAlignment = Enum.TextXAlignment.Center,
                    ZIndex = 4,
                    Parent = Btn,
                })

                if hasDesc then
                    Create("TextLabel", {
                        Position = UDim2.new(0, 12, 0, 24),
                        Size = UDim2.new(1, -20, 0, 14),
                        BackgroundTransparency = 1,
                        Text = desc,
                        TextColor3 = Theme.TextMuted,
                        TextSize = 11,
                        Font = Enum.Font.Gotham,
                        TextXAlignment = Enum.TextXAlignment.Center,
                        ZIndex = 4,
                        Parent = Btn,
                    })
                end

                Btn.MouseEnter:Connect(function()
                    Tween(Btn, 0.15, {BackgroundColor3 = Theme.ElementHover})
                    Tween(BtnBar, 0.15, {Size = UDim2.new(0, 3, 0, 24)})
                end)
                Btn.MouseLeave:Connect(function()
                    Tween(Btn, 0.15, {BackgroundColor3 = Theme.Element})
                    Tween(BtnBar, 0.15, {Size = UDim2.new(0, 3, 0, 18)})
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
            function Section:AddToggle(cfg)
                cfg = cfg or {}
                local name = cfg.Name or "Toggle"
                local default = cfg.Default or false
                local flag = cfg.Flag
                local callback = cfg.Callback or function() end

                local state = default
                if flag then StormUI.Flags[flag] = state end

                local Row = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 34),
                    BackgroundColor3 = state and Color3.fromRGB(26, 22, 40) or Theme.Element,
                    BorderSizePixel = 0,
                    LayoutOrder = NextOrder(),
                    ZIndex = 3,
                    Parent = SecContent,
                })
                Corner(Row, 7)
                Stroke(Row, Theme.Stroke, 1)

                Create("TextLabel", {
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, 10, 0.5, 0),
                    Size = UDim2.new(1, -62, 1, 0),
                    BackgroundTransparency = 1,
                    Text = name,
                    TextColor3 = Theme.TextPrimary,
                    TextSize = 13,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 4,
                    Parent = Row,
                })

                local SwitchBg = Create("Frame", {
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, -10, 0.5, 0),
                    Size = UDim2.new(0, 40, 0, 20),
                    BackgroundColor3 = state and Theme.ToggleOn or Theme.ToggleOff,
                    BorderSizePixel = 0,
                    ZIndex = 4,
                    Parent = Row,
                })
                Corner(SwitchBg, 10)

                local SwitchKnob = Create("Frame", {
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = state and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0),
                    Size = UDim2.new(0, 16, 0, 16),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BorderSizePixel = 0,
                    ZIndex = 5,
                    Parent = SwitchBg,
                })
                Corner(SwitchKnob, 8)

                local function DoToggle()
                    state = not state
                    if flag then StormUI.Flags[flag] = state end
                    Tween(SwitchBg, 0.2, {BackgroundColor3 = state and Theme.ToggleOn or Theme.ToggleOff})
                    Tween(SwitchKnob, 0.2, {Position = state and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)})
                    Tween(Row, 0.2, {BackgroundColor3 = state and Color3.fromRGB(26, 22, 40) or Theme.Element})
                    callback(state)
                end

                -- [Fix Bug 1] Apenas MouseButton1Click — sem InputBegan:Touch duplicado.
                local ClickBtn = Create("TextButton", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = "",
                    ZIndex = 6,
                    Parent = Row,
                })
                ClickBtn.MouseButton1Click:Connect(DoToggle)
                ClickBtn.MouseEnter:Connect(function()
                    if not state then
                        Tween(Row, 0.15, {BackgroundColor3 = Theme.ElementHover})
                    end
                end)
                ClickBtn.MouseLeave:Connect(function()
                    if not state then
                        Tween(Row, 0.15, {BackgroundColor3 = Theme.Element})
                    end
                end)

                local ToggleObj = {}
                function ToggleObj:Set(v)
                    if v ~= state then DoToggle() end
                end
                function ToggleObj:Get()
                    return state
                end
                return ToggleObj
            end

            -- ── Slider ────────────────────────────────────────────────────────
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

                local value = math.clamp(default, min, max)
                if flag then StormUI.Flags[flag] = value end

                local Container = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 52),
                    BackgroundColor3 = Theme.Element,
                    BorderSizePixel = 0,
                    LayoutOrder = NextOrder(),
                    ZIndex = 3,
                    Parent = SecContent,
                })
                Corner(Container, 7)
                Stroke(Container, Theme.Stroke, 1)

                Create("TextLabel", {
                    Position = UDim2.new(0, 10, 0, 7),
                    Size = UDim2.new(0.6, 0, 0, 16),
                    BackgroundTransparency = 1,
                    Text = name,
                    TextColor3 = Theme.TextPrimary,
                    TextSize = 13,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 4,
                    Parent = Container,
                })

                local ValLabel = Create("TextLabel", {
                    AnchorPoint = Vector2.new(1, 0),
                    Position = UDim2.new(1, -10, 0, 7),
                    Size = UDim2.new(0.4, -10, 0, 16),
                    BackgroundTransparency = 1,
                    Text = tostring(value) .. suffix,
                    TextColor3 = Theme.TextAccent,
                    TextSize = 12,
                    Font = Enum.Font.GothamBold,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    ZIndex = 4,
                    Parent = Container,
                })

                local Track = Create("Frame", {
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 10, 1, -10),
                    Size = UDim2.new(1, -20, 0, 6),
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
                Gradient(Fill, Theme.AccentDark, Theme.AccentLight)

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
                Stroke(Knob, Theme.AccentLight, 1.5)

                local sliding = false

                local function UpdateSlider(inputX)
                    local ts = Track.AbsoluteSize.X
                    if ts == 0 then return end
                    local rel = math.clamp((inputX - Track.AbsolutePosition.X) / ts, 0, 1)
                    local raw = min + (max - min) * rel
                    value = math.clamp(math.floor(raw / increment + 0.5) * increment, min, max)
                    local pct = (value - min) / (max - min)
                    if flag then StormUI.Flags[flag] = value end
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
                    if flag then StormUI.Flags[flag] = value end
                    Fill.Size = UDim2.new(pct, 0, 1, 0)
                    Knob.Position = UDim2.new(pct, 0, 0.5, 0)
                    ValLabel.Text = tostring(value) .. suffix
                    callback(value)
                end
                function SliderObj:Get() return value end
                return SliderObj
            end

            -- ── Dropdown ──────────────────────────────────────────────────────
            -- [Fix Bug 3] Popup parented ao Overlay (fora do ScrollingFrame).
            -- Posicionado via AbsolutePosition ao abrir.
            function Section:AddDropdown(cfg)
                cfg = cfg or {}
                local name = cfg.Name or "Dropdown"
                local options = cfg.Options or {}
                local default = cfg.Default or options[1] or "None"
                local flag = cfg.Flag
                local callback = cfg.Callback or function() end

                local selected = default
                if flag then StormUI.Flags[flag] = selected end

                local Container = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 34),
                    BackgroundColor3 = Theme.Element,
                    BorderSizePixel = 0,
                    LayoutOrder = NextOrder(),
                    ZIndex = 3,
                    Parent = SecContent,
                })
                Corner(Container, 7)
                Stroke(Container, Theme.Stroke, 1)

                Create("TextLabel", {
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, 10, 0.5, 0),
                    Size = UDim2.new(0.45, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = name,
                    TextColor3 = Theme.TextPrimary,
                    TextSize = 13,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 4,
                    Parent = Container,
                })

                local SelLabel = Create("TextLabel", {
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, -26, 0.5, 0),
                    Size = UDim2.new(0.52, 0, 1, 0),
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
                    Position = UDim2.new(1, -8, 0.5, 0),
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
                    BackgroundColor3 = Theme.Section,
                    BorderSizePixel = 0,
                    ZIndex = 501,
                    ScrollBarThickness = 2,
                    ScrollBarImageColor3 = Theme.Accent,
                    CanvasSize = UDim2.new(0, 0, 0, 0),
                    ClipsDescendants = true,
                    Visible = false,
                    Parent = Overlay,
                })
                Corner(List, 7)
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
                            BackgroundColor3 = isActive and Theme.AccentDark or Theme.Element,
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
                                Tween(OptBtn, 0.1, {BackgroundColor3 = Theme.ElementHover})
                            end
                        end)
                        OptBtn.MouseLeave:Connect(function()
                            if not isActive then
                                Tween(OptBtn, 0.1, {BackgroundColor3 = Theme.Element})
                            end
                        end)
                        OptBtn.MouseButton1Click:Connect(function()
                            selected = opt
                            if flag then StormUI.Flags[flag] = selected end
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

                CloseOnOutsideClick(
                    function() return listOpen end,
                    List, Container, CloseList
                )

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
                    if flag then StormUI.Flags[flag] = v end
                    SelLabel.Text = tostring(v)
                    BuildList()
                    callback(v)
                end
                function DropObj:SetOptions(newOpts)
                    options = newOpts
                    BuildList()
                end
                function DropObj:Get() return selected end
                return DropObj
            end

            -- ── MultiDropdown ─────────────────────────────────────────────────
            -- [Fix Bug 3] Mesma correção do Dropdown acima.
            function Section:AddMultiDropdown(cfg)
                cfg = cfg or {}
                local name = cfg.Name or "Multi Select"
                local options = cfg.Options or {}
                local defaults = cfg.Default or {}
                local flag = cfg.Flag
                local callback = cfg.Callback or function() end

                local selected = {}
                for _, v in ipairs(defaults) do selected[v] = true end
                if flag then StormUI.Flags[flag] = selected end

                local function DisplayText()
                    local n = 0
                    for _ in pairs(selected) do n = n + 1 end
                    if n == 0 then return "Nenhum" end
                    return n .. " selecionado" .. (n > 1 and "s" or "")
                end

                local Container = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 34),
                    BackgroundColor3 = Theme.Element,
                    BorderSizePixel = 0,
                    LayoutOrder = NextOrder(),
                    ZIndex = 3,
                    Parent = SecContent,
                })
                Corner(Container, 7)
                Stroke(Container, Theme.Stroke, 1)

                Create("TextLabel", {
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, 10, 0.5, 0),
                    Size = UDim2.new(0.45, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = name,
                    TextColor3 = Theme.TextPrimary,
                    TextSize = 13,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 4,
                    Parent = Container,
                })

                local SelLabel = Create("TextLabel", {
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, -26, 0.5, 0),
                    Size = UDim2.new(0.52, 0, 1, 0),
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
                    Position = UDim2.new(1, -8, 0.5, 0),
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
                    BackgroundColor3 = Theme.Section,
                    BorderSizePixel = 0,
                    ZIndex = 501,
                    ScrollBarThickness = 2,
                    ScrollBarImageColor3 = Theme.Accent,
                    CanvasSize = UDim2.new(0, 0, 0, 0),
                    ClipsDescendants = true,
                    Visible = false,
                    Parent = Overlay,
                })
                Corner(List, 7)
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
                            BackgroundColor3 = isSel and Color3.fromRGB(22, 18, 38) or Theme.Element,
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
                            BackgroundColor3 = isSel and Theme.Accent or Theme.SliderBg,
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
                            if flag then StormUI.Flags[flag] = selected end
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

                CloseOnOutsideClick(
                    function() return listOpen end,
                    List, Container, CloseMulti
                )

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
                    if flag then StormUI.Flags[flag] = selected end
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
                if flag then StormUI.Flags[flag] = currentKey end

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
                Corner(Row, 7)
                Stroke(Row, Theme.Stroke, 1)

                Create("TextLabel", {
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, 10, 0.5, 0),
                    Size = UDim2.new(1, -80, 1, 0),
                    BackgroundTransparency = 1,
                    Text = name,
                    TextColor3 = Theme.TextPrimary,
                    TextSize = 13,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 4,
                    Parent = Row,
                })

                local Badge = Create("Frame", {
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, -8, 0.5, 0),
                    Size = UDim2.new(0, 66, 0, 22),
                    BackgroundColor3 = Theme.TabBar,
                    BorderSizePixel = 0,
                    ZIndex = 4,
                    Parent = Row,
                })
                Corner(Badge, 6)
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
                        Tween(Badge, 0.2, {BackgroundColor3 = Theme.TabBar})
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
                            if flag then StormUI.Flags[flag] = currentKey end
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
                    if flag then StormUI.Flags[flag] = key end
                    KeyLbl.Text = KeyStr(key)
                end
                function KeyObj:Get() return currentKey end
                return KeyObj
            end

            -- ── TextBox ───────────────────────────────────────────────────────
            function Section:AddTextBox(cfg)
                cfg = cfg or {}
                local name = cfg.Name or "TextBox"
                local holder = cfg.Placeholder or "Digite aqui..."
                local default = cfg.Default or ""
                local numeric = cfg.Numeric or false
                local flag = cfg.Flag
                local callback = cfg.Callback or function() end

                if flag then StormUI.Flags[flag] = default end

                local Container = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 52),
                    BackgroundColor3 = Theme.Element,
                    BorderSizePixel = 0,
                    LayoutOrder = NextOrder(),
                    ZIndex = 3,
                    Parent = SecContent,
                })
                Corner(Container, 7)
                Stroke(Container, Theme.Stroke, 1)

                Create("TextLabel", {
                    Position = UDim2.new(0, 10, 0, 7),
                    Size = UDim2.new(1, -20, 0, 15),
                    BackgroundTransparency = 1,
                    Text = name,
                    TextColor3 = Theme.TextPrimary,
                    TextSize = 12,
                    Font = Enum.Font.GothamBold,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 4,
                    Parent = Container,
                })

                local InputBg = Create("Frame", {
                    AnchorPoint = Vector2.new(0.5, 1),
                    Position = UDim2.new(0.5, 0, 1, -7),
                    Size = UDim2.new(1, -16, 0, 24),
                    BackgroundColor3 = Theme.TabBar,
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
                Padding(TB, 0, 0, 8, 8)

                TB.Focused:Connect(function()
                    Tween(InputStroke, 0.2, {Color = Theme.Accent})
                    Tween(InputBg, 0.2, {BackgroundColor3 = Color3.fromRGB(18, 16, 28)})
                end)
                TB.FocusLost:Connect(function(enter)
                    Tween(InputStroke, 0.2, {Color = Theme.Stroke})
                    Tween(InputBg, 0.2, {BackgroundColor3 = Theme.TabBar})
                    local val = TB.Text
                    if numeric then
                        val = tonumber(val) or tonumber(default) or 0
                        TB.Text = tostring(val)
                    end
                    if flag then StormUI.Flags[flag] = val end
                    callback(val, enter)
                end)

                local TBObj = {}
                function TBObj:Set(v)
                    TB.Text = tostring(v)
                    if flag then StormUI.Flags[flag] = v end
                end
                function TBObj:Get() return TB.Text end
                return TBObj
            end

            -- ── ColorPicker ───────────────────────────────────────────────────
            -- [Fix Bug 3] Popup parented ao Overlay — mesma correção dos dropdowns.
            function Section:AddColorPicker(cfg)
                cfg = cfg or {}
                local name = cfg.Name or "Color"
                local default = cfg.Default or Color3.fromRGB(100, 65, 230)
                local flag = cfg.Flag
                local callback = cfg.Callback or function() end

                local h, s, v = Color3.toHSV(default)
                local currentColor = default
                if flag then StormUI.Flags[flag] = currentColor end

                local Container = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 34),
                    BackgroundColor3 = Theme.Element,
                    BorderSizePixel = 0,
                    LayoutOrder = NextOrder(),
                    ZIndex = 3,
                    Parent = SecContent,
                })
                Corner(Container, 7)
                Stroke(Container, Theme.Stroke, 1)

                Create("TextLabel", {
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, 10, 0.5, 0),
                    Size = UDim2.new(1, -56, 1, 0),
                    BackgroundTransparency = 1,
                    Text = name,
                    TextColor3 = Theme.TextPrimary,
                    TextSize = 13,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 4,
                    Parent = Container,
                })

                local Preview = Create("Frame", {
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, -10, 0.5, 0),
                    Size = UDim2.new(0, 26, 0, 26),
                    BackgroundColor3 = currentColor,
                    BorderSizePixel = 0,
                    ZIndex = 4,
                    Parent = Container,
                })
                Corner(Preview, 7)
                Stroke(Preview, Theme.Stroke, 1)

                local Popup = Create("Frame", {
                    Size = UDim2.new(0, 0, 0, 0),
                    BackgroundColor3 = Theme.Section,
                    BorderSizePixel = 0,
                    ZIndex = 501,
                    ClipsDescendants = false,
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
                    if flag then StormUI.Flags[flag] = currentColor end
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
                        Popup.Position = UDim2.new(0, ap.X, 0, ap.Y + as.Y + 4)
                        Popup.Size = UDim2.new(0, as.X, 0, 0)
                        Popup.Visible = true
                        Tween(Popup, 0.22, {Size = UDim2.new(0, as.X, 0, 108)})
                    else
                        Tween(Popup, 0.22, {Size = UDim2.new(0, Popup.AbsoluteSize.X, 0, 0)})
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
                    if flag then StormUI.Flags[flag] = color end
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
                function LblObj:Set(newText)
                    Lbl.Text = tostring(newText)
                end
                function LblObj:SetColor(c)
                    Lbl.TextColor3 = c
                end
                return LblObj
            end

            -- ── Separator ─────────────────────────────────────────────────────
            function Section:AddSeparator()
                Create("Frame", {
                    Size = UDim2.new(1, -16, 0, 1),
                    BackgroundColor3 = Theme.Stroke,
                    BorderSizePixel = 0,
                    LayoutOrder = NextOrder(),
                    ZIndex = 3,
                    Parent = SecContent,
                })
            end

            return Section
        end -- AddSection

        return Tab
    end -- AddTab

    return Window
end -- CreateWindow

-- ─── API pública ──────────────────────────────────────────────────────────────
function StormUI:SetTheme(custom)
    for k, v in pairs(custom) do
        Theme[k] = v
    end
end

function StormUI:GetFlag(flag)
    return StormUI.Flags[flag]
end

return StormUI

--[[
╔══════════════════════════════════════════════════════╗
║               EXEMPLO DE USO COMPLETO               ║
╚══════════════════════════════════════════════════════╝

local StormUI = loadstring(game:HttpGet("URL_AQUI"))()

local Window = StormUI:CreateWindow({
    Title    = "Storm UI",
    Subtitle = "v1.1",
    Width    = 320,
    Height   = 420,
})

local Tab1 = Window:AddTab({ Name = "Main" })
local Tab2 = Window:AddTab({ Name = "Player" })
local Tab3 = Window:AddTab({ Name = "Visual" })

local Sec1 = Tab1:AddSection({ Name = "Combat" })

Sec1:AddToggle({
    Name     = "Aimbot",
    Default  = false,
    Flag     = "Aimbot",
    Callback = function(state) print("Aimbot:", state) end,
})

Sec1:AddSlider({
    Name      = "FOV",
    Min       = 10,
    Max       = 360,
    Default   = 90,
    Increment = 5,
    Suffix    = "°",
    Flag      = "FOV",
    Callback  = function(val) print("FOV:", val) end,
})

Sec1:AddButton({
    Name     = "Teleport",
    Desc     = "Vai para o spawn",
    Callback = function() print("Teleportando!") end,
})

local Sec2 = Tab1:AddSection({ Name = "Config" })

Sec2:AddKeybind({
    Name     = "Toggle UI",
    Default  = Enum.KeyCode.RightShift,
    Flag     = "UIKey",
    Callback = function(key) print("Key:", key) end,
})

Sec2:AddDropdown({
    Name     = "Modo",
    Options  = { "Silencioso", "Normal", "Agressivo" },
    Default  = "Normal",
    Flag     = "Modo",
    Callback = function(v) print("Modo:", v) end,
})

Sec2:AddMultiDropdown({
    Name     = "Itens",
    Options  = { "AK-47", "AWP", "Knife", "Pistol" },
    Default  = { "AK-47" },
    Flag     = "Itens",
    Callback = function(sel) print("Selecionados:", sel) end,
})

local Sec3 = Tab2:AddSection({ Name = "Player" })

Sec3:AddTextBox({
    Name        = "Nome do Alvo",
    Placeholder = "ex: Player1",
    Flag        = "Target",
    Callback    = function(text, enter)
        if enter then print("Alvo:", text) end
    end,
})

Sec3:AddColorPicker({
    Name     = "Cor do ESP",
    Default  = Color3.fromRGB(100, 65, 230),
    Flag     = "ESPColor",
    Callback = function(color) print("Cor:", color) end,
})

Sec3:AddLabel({
    Text  = "Storm UI v1.1",
    Color = Color3.fromRGB(140, 105, 255),
})

-- Ler qualquer flag a qualquer momento:
print(StormUI:GetFlag("Aimbot"))
print(StormUI:GetFlag("FOV"))
--]]
