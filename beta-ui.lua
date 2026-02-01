local Config = {
    Themes = {
        Default = {
            Accent={215, 214, 213}
        }
    },
    Layout = {
        SectionWidthLeft = 0.5,
        SectionWidthRight = 0.5,
        SectionGap = 10
    },
    Borders = {
        Enabled = true,
        Top = true,
        Right = true,
        Bottom = true,
        Left = true,
        Color = Color3.fromRGB(12,12,12),
        Thickness = 1
    }
}

local comet = {}
local pages = {}
local sections = {}
local multisections = {}
local mssections = {}
local toggles = {}
local buttons = {}
local sliders = {}
local dropdowns = {}
local multiboxs = {}
local buttonboxs = {}
local textboxs = {}
local keybinds = {}
local colorpickers = {}
local configloaders = {}
local watermarks = {}
local loaders = {}
local notifications = {}
local utility = {}
local util={}
local check_exploit = (syn and "Synapse") or (KRNL_LOADED and "Krnl") or (isourclosure and "ScriptWare") or nil
local plrs = game:GetService("Players")
local cre = game:GetService("CoreGui")
local rs = game:GetService("RunService")
local ts = game:GetService("TweenService")
local uis = game:GetService("UserInputService")
local hs = game:GetService("HttpService")
local ws = game:GetService("Workspace")
local plr = plrs.LocalPlayer
local cam = ws.CurrentCamera
comet.__index = comet
pages.__index = pages
sections.__index = sections
multisections.__index = multisections
mssections.__index = mssections
toggles.__index = toggles
buttons.__index = buttons
sliders.__index = sliders
dropdowns.__index = dropdowns
multiboxs.__index = multiboxs
buttonboxs.__index = buttonboxs
textboxs.__index = textboxs
keybinds.__index = keybinds
colorpickers.__index = colorpickers
configloaders.__index = configloaders
watermarks.__index = watermarks
loaders.__index = loaders
notifications.__index = notifications

utility.new = function(instance,properties)
	local ins = Instance.new(instance)
	for property,value in pairs(properties) do
		ins[property] = value
	end
	return ins
end

utility.dragify = function(ins,touse)
	local dragging
	local dragInput
	local dragStart
	local startPos
	local function update(input)
		local delta = input.Position - dragStart
		touse:TweenPosition(UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.1,true)
	end
	ins.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = touse.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	ins.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	uis.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input)
		end
	end)
end

utility.round = function(n,d)
	return tonumber(string.format("%."..(d or 0).."f",n))
end

utility.zigzag = function(X)
	return math.acos(math.cos(X*math.pi))/math.pi
end

utility.capatalize = function(s)
	local l = ""
	for v in s:gmatch('%u') do
		l = l..v
	end
	return l
end

utility.splitenum = function(enum)
	local s = tostring(enum):split(".")
	return s[#s]
end

utility.from_hex = function(h)
	local r,g,b = string.match(h,"^#?(%w%w)(%w%w)(%w%w)$")
	return Color3.fromRGB(tonumber(r,16), tonumber(g,16), tonumber(b,16))
end

utility.to_hex = function(c)
	return string.format("#%02X%02X%02X",c.R *255,c.G *255,c.B *255)
end

utility.removespaces = function(s)
   return s:gsub(" ","")
end

local function applyCorner(parent, enable, radius)
	if enable then
		local r = tonumber(radius) or 1
		utility.new("UICorner",{CornerRadius = UDim.new(0,r), Parent = parent})
	end
end

local function applyBorders(frame, opts)
	local o = {
		Enabled = Config.Borders.Enabled,
		Top = Config.Borders.Top,
		Right = Config.Borders.Right,
		Bottom = Config.Borders.Bottom,
		Left = Config.Borders.Left,
		Color = Config.Borders.Color,
		Thickness = Config.Borders.Thickness
	}
	for k,v in pairs(opts or {}) do o[k]=v end
	frame.BorderSizePixel = 0
	if not o.Enabled then return end
	local function edge(name, size, pos)
		local f = utility.new("Frame",{
			Name=name,
			BackgroundColor3 = o.Color,
			BorderSizePixel = 0,
			Size=size,
			Position=pos,
			ZIndex = frame.ZIndex+1,
			Parent = frame
		})
		return f
	end
	if o.Top then edge("BTop", UDim2.new(1,0,0,o.Thickness), UDim2.new(0,0,0,0)) end
	if o.Bottom then edge("BBottom", UDim2.new(1,0,0,o.Thickness), UDim2.new(0,0,1,-o.Thickness)) end
	if o.Left then edge("BLeft", UDim2.new(0,o.Thickness,1,0), UDim2.new(0,0,0,0)) end
	if o.Right then edge("BRight", UDim2.new(0,o.Thickness,1,0), UDim2.new(1,-o.Thickness,0,0)) end
end

local function borderOptions(props, defaults)
	local out = {}
	local b = props or {}
	out.border = (b.border == nil) and true or b.border
	out.borderTop = (b["border-top"] == nil and b.borderTop == nil) and true or (b["border-top"] ~= nil and b["border-top"] or b.borderTop)
	out.borderBottom = (b["border-bottom"] == nil and b.borderBottom == nil) and true or (b["border-bottom"] ~= nil and b["border-bottom"] or b.borderBottom)
	out.borderLeft = (b["border-left"] == nil and b.borderLeft == nil) and true or (b["border-left"] ~= nil and b["border-left"] or b.borderLeft)
	out.borderRight = (b["border-right"] == nil and b.borderRight == nil) and true or (b["border-right"] ~= nil and b["border-right"] or b.borderRight)
	out.borderColor = b.borderColor or b.bordercolor or b.border_colour or defaults and defaults.Color or Config.Borders.Color
	out.borderThickness = b.borderThickness or b.borderthickness or b["border-width"] or defaults and defaults.Thickness or Config.Borders.Thickness
	if type(out.borderColor)=="string" then
		if out.borderColor:lower():find("rgba") then
			local r,g,bb,a = out.borderColor:match("rgba%((%d+),%s*(%d+),%s*(%d+),%s*([%d%.]+)%)")
			out.borderColor = Color3.fromRGB(tonumber(r or 255),tonumber(g or 255),tonumber(bb or 255))
		else
			out.borderColor = utility.from_hex(out.borderColor)
		end
	end
	return out
end

local function applyRounding(frame, rounding)
	applyCorner(frame, rounding and rounding.enabled or rounding, rounding and rounding.radius or rounding)
end

function comet:new(props)
	local textsize = props.textsize or props.TextSize or props.textSize or props.Textsize or 12
	local font = props.font or props.Font or "RobotoMono"
	local name = props.name or props.Name or props.UiName or props.Uiname or props.uiName or props.username or props.Username or props.UserName or props.userName or "new ui"
	local color = props.color or props.Color or props.mainColor or props.maincolor or props.MainColor or props.Maincolor or props.Accent or props.accent or Color3.fromRGB(unpack(Config.Themes.Default.Accent))
	local roundedGlobal = props.rounded or props.Rounded or false
	local roundnessGlobal = props.roundness or props.Roundness or 1
	local rounding = props.rounding or {enabled = roundedGlobal, radius = roundnessGlobal}
	local borderCfg = borderOptions(props, Config.Borders)
	local layoutOverrides = props.layout or {}
	local sectionWidthLeft = layoutOverrides.SectionWidthLeft or Config.Layout.SectionWidthLeft
	local sectionWidthRight = layoutOverrides.SectionWidthRight or Config.Layout.SectionWidthRight
	local sectionGap = layoutOverrides.SectionGap or Config.Layout.SectionGap

	local window = {}
	local screen = utility.new(
		"ScreenGui",
		{
			Name = tostring(math.random(0,999999))..tostring(math.random(0,999999)),
			DisplayOrder = 9999,
			ResetOnSpawn = false,
			ZIndexBehavior = "Global",
			Parent = cre
		}
	)
	if (check_exploit == "Synapse" and syn.request) then
		syn.protect_gui(screen)
	end
	local outline = utility.new(
		"Frame",
		{
			AnchorPoint = Vector2.new(0.5,0.5),
			BackgroundColor3 = color,
			Size = UDim2.new(0,500,0,606),
			Position = UDim2.new(0.5,0,0.5,0),
			Parent = screen
		}
	)
	applyRounding(outline, rounding)
	applyBorders(outline, {
		Enabled = borderCfg.border,
		Top = borderCfg.borderTop,
		Right = borderCfg.borderRight,
		Bottom = borderCfg.borderBottom,
		Left = borderCfg.borderLeft,
		Color = borderCfg.borderColor,
		Thickness = borderCfg.borderThickness
	})
	local outline2 = utility.new(
		"Frame",
		{
			AnchorPoint = Vector2.new(0.5,0.5),
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			Size = UDim2.new(1,-4,1,-4),
			Position = UDim2.new(0.5,0,0.5,0),
			Parent = outline
		}
	)
	applyRounding(outline2, rounding)
	applyBorders(outline2, {
		Enabled = borderCfg.border,
		Top = borderCfg.borderTop,
		Right = borderCfg.borderRight,
		Bottom = borderCfg.borderBottom,
		Left = borderCfg.borderLeft,
		Color = borderCfg.borderColor,
		Thickness = borderCfg.borderThickness
	})
	local indent = utility.new(
		"Frame",
		{
			AnchorPoint = Vector2.new(0.5,0.5),
			BackgroundColor3 = Color3.fromRGB(20, 20, 20),
			Size = UDim2.new(1,0,1,0),
			Position = UDim2.new(0.5,0,0.5,0),
			Parent = outline2
		}
	)
	applyRounding(indent, rounding)
	applyBorders(indent, {
		Enabled = borderCfg.border,
		Top = borderCfg.borderTop,
		Right = borderCfg.borderRight,
		Bottom = borderCfg.borderBottom,
		Left = borderCfg.borderLeft,
		Color = Color3.fromRGB(56,56,56),
		Thickness = borderCfg.borderThickness
	})
	local main = utility.new(
		"Frame",
		{
			AnchorPoint = Vector2.new(0.5,1),
			BackgroundColor3 = Color3.fromRGB(20, 20, 20),
			Size = UDim2.new(1,-10,1,-25),
			Position = UDim2.new(0.5,0,1,-5),
			Parent = outline2
		}
	)
	applyRounding(main, rounding)
	applyBorders(main, {
		Enabled = borderCfg.border,
		Top = borderCfg.borderTop,
		Right = borderCfg.borderRight,
		Bottom = borderCfg.borderBottom,
		Left = borderCfg.borderLeft,
		Color = Color3.fromRGB(56,56,56),
		Thickness = borderCfg.borderThickness
	})
	local title = utility.new(
		"Frame",
		{
			AnchorPoint = Vector2.new(0.5,0),
			BackgroundTransparency = 1,
			Size = UDim2.new(1,0,0,20),
			Position = UDim2.new(0.5,0,0,0),
			Parent = outline2
		}
	)
	local outline3 = utility.new(
		"Frame",
		{
			AnchorPoint = Vector2.new(0.5,0.5),
			BackgroundColor3 = Color3.fromRGB(24, 24, 24),
			Size = UDim2.new(1,0,1,0),
			Position = UDim2.new(0.5,0,0.5,0),
			Parent = main
		}
	)
	applyRounding(outline3, rounding)
	applyBorders(outline3, {
		Enabled = borderCfg.border,
		Top = borderCfg.borderTop,
		Right = borderCfg.borderRight,
		Bottom = borderCfg.borderBottom,
		Left = borderCfg.borderLeft,
		Color = Color3.fromRGB(12,12,12),
		Thickness = borderCfg.borderThickness
	})
	local titletext = utility.new(
		"TextLabel",
		{
			AnchorPoint = Vector2.new(0.5,0),
			BackgroundTransparency = 1,
			Size = UDim2.new(1,-10,1,0),
			Position = UDim2.new(0.5,0,0,0),
			Font = font,
			Text = name,
			RichText = true,
			TextWrapped=true,
			TextColor3 = Color3.fromRGB(255,255,255),
			TextXAlignment = "Left",
			TextSize = textsize,
			TextStrokeTransparency = 0,
			Parent = title
		}
	)
	local holder = utility.new(
		"Frame",
		{
			AnchorPoint = Vector2.new(0.5,0.5),
			BackgroundTransparency = 1,
			Size = UDim2.new(1,-6,1,-6),
			Position = UDim2.new(0.5,0,0.5,0),
			Parent = main
		}
	)
	applyRounding(holder, rounding)
	local holder2 = utility.new(
		"Frame",
		{
			AnchorPoint = Vector2.new(0.5,0.5),
			BackgroundTransparency = 1,
			Size = UDim2.new(1,-6,1,-6),
			Position = UDim2.new(0.5,0,0.5,0),
			Parent = main
		}
	)
	applyRounding(holder2, rounding)
	local tabs = utility.new(
		"Frame",
		{
			AnchorPoint = Vector2.new(0.5,1),
			BackgroundColor3 = Color3.fromRGB(20, 20, 20),
			Size = UDim2.new(1,0,1,-20),
			Position = UDim2.new(0.5,0,1,0),
			Parent = holder2
		}
	)
	applyRounding(tabs, rounding)
	applyBorders(tabs, {
		Enabled = borderCfg.border,
		Top = borderCfg.borderTop,
		Right = borderCfg.borderRight,
		Bottom = borderCfg.borderBottom,
		Left = borderCfg.borderLeft,
		Color = Color3.fromRGB(12,12,12),
		Thickness = borderCfg.borderThickness
	})
	local tabsbuttons = utility.new(
		"ScrollingFrame",
		{
			AnchorPoint = Vector2.new(0.5,0),
			BackgroundTransparency = 1,
			Size = UDim2.new(1,0,0,21),
			Position = UDim2.new(0.5,0,0,0),
			ZIndex = 2,
			BorderSizePixel = 0,
			AutomaticCanvasSize = "X",
			CanvasSize = UDim2.new(0,0,0,0),
			ScrollBarImageTransparency = 1,
			ScrollBarImageColor3 = Color3.fromRGB(0,0,0),
			ScrollBarThickness = 0,
			HorizontalScrollBarInset = "None",
			ScrollingDirection = "X",
			Parent = holder2
		}
	)
	local outline4 = utility.new(
		"Frame",
		{
			BackgroundColor3 = Color3.fromRGB(20, 20, 20),
			Size = UDim2.new(1,0,1,0),
			Position = UDim2.new(0,0,0,0),
			Parent = tabs
		}
	)
	applyRounding(outline4, rounding)
	applyBorders(outline4, {
		Enabled = borderCfg.border,
		Top = borderCfg.borderTop,
		Right = borderCfg.borderRight,
		Bottom = borderCfg.borderBottom,
		Left = borderCfg.borderLeft,
		Color = Color3.fromRGB(56,56,56),
		Thickness = borderCfg.borderThickness
	})
	utility.new(
		"UIListLayout",
		{
			FillDirection = "Horizontal",
			Padding = UDim.new(0,2),
			Parent = tabsbuttons
		}
	)
	utility.dragify(title,outline)
	window = {
		["screen"] = screen,
		["holder"] = holder2,
		["labels"] = {},
		["tabs"] = outline4,
		["tabsbuttons"] = tabsbuttons,
		["outline"] = outline,
		["pages"] = {},
		["pointers"] = {},
		["dropdowns"] = {},
		["multiboxes"] = {},
		["buttonboxs"] = {},
		["colorpickers"] = {},
		["x"] = true,
		["y"] = true,
		["key"] = Enum.KeyCode.RightShift,
		["textsize"] = textsize,
		["font"] = font,
		["rounding"] = rounding,
		["theme"] = {
			["accent"] = color
		},
		["themeitems"] = {
			["accent"] = {
				["BackgroundColor3"] = {},
				["BorderColor3"] = {},
				["TextColor3"] = {}
			}
		},
		["layout"] = {
			SectionWidthLeft = sectionWidthLeft,
			SectionWidthRight = sectionWidthRight,
			SectionGap = sectionGap
		},
		["borders"] = borderCfg
	}
	table.insert(window.themeitems["accent"]["BackgroundColor3"],outline)
	local toggled = true
	local cooldown = false
	local saved = UDim2.new(0,0,0,0)
	uis.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.Keyboard then
			if Input.KeyCode == window.key then
				if cooldown == false then
					if toggled then
						cooldown = true
						toggled = not toggled
						saved = outline.Position
						local xx,yy = 0,0
						local xxx,yyy = 0,0
						if (outline.AbsolutePosition.X+(outline.AbsoluteSize.X/2)) < (cam.ViewportSize.X/2) then
							xx = -3
						else
							xx = 3
						end
						if window.y then
							if (outline.AbsolutePosition.Y+(outline.AbsoluteSize.Y/2)) < (cam.ViewportSize.Y/2) then
								yy = -3
							else
								yy = 3
							end
						else
							yy = saved.Y.Scale
							yyy = saved.Y.Offset
						end
						if window.x == false and window.y == false then
							screen.Enabled = false
						else
							ts:Create(outline, TweenInfo.new(0.5,Enum.EasingStyle.Quad,Enum.EasingDirection.In), {Position = UDim2.new(xx,xxx,yy,yyy)}):Play()
						end
						wait(0.5)
						cooldown = false
					else
						cooldown = true
						toggled = not toggled
						if window.x == false and window.y == false then
							screen.Enabled = true
						else
							ts:Create(outline, TweenInfo.new(0.5,Enum.EasingStyle.Quad,Enum.EasingDirection.Out), {Position = saved}):Play()
						end
						wait(0.5)
						cooldown = false
					end
				end
			end
		end
	end)
	window.labels[#window.labels+1] = titletext
	setmetatable(window, comet)
	return window
end

function comet:watermark()
	local watermark = {}
	local outline = utility.new(
		"Frame",
		{
			AnchorPoint = Vector2.new(1,0),
			BackgroundColor3 = self.theme.accent,
			Size = UDim2.new(0,300,0,26),
			Position = UDim2.new(1,-10,0,10),
			ZIndex = 9900,
			Visible = false,
			Parent = self.screen
		}
	)
	applyRounding(outline, self.rounding)
	applyBorders(outline, {
		Enabled = self.borders.border,
		Top = self.borders.borderTop,
		Right = self.borders.borderRight,
		Bottom = self.borders.borderBottom,
		Left = self.borders.borderLeft,
		Color = self.borders.borderColor,
		Thickness = self.borders.borderThickness
	})
	table.insert(self.themeitems["accent"]["BackgroundColor3"],outline)
	local outline2 = utility.new(
		"Frame",
		{
			AnchorPoint = Vector2.new(0.5,0.5),
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			Size = UDim2.new(1,-4,1,-4),
			Position = UDim2.new(0.5,0,0.5,0),
			ZIndex = 9901,
			Parent = outline
		}
	)
	applyRounding(outline2, self.rounding)
	applyBorders(outline2, {
		Enabled = self.borders.border,
		Top = self.borders.borderTop,
		Right = self.borders.borderRight,
		Bottom = self.borders.borderBottom,
		Left = self.borders.borderLeft,
		Color = self.borders.borderColor,
		Thickness = self.borders.borderThickness
	})
	local indent = utility.new(
		"Frame",
		{
			AnchorPoint = Vector2.new(0.5,0.5),
			BackgroundColor3 = Color3.fromRGB(20, 20, 20),
			Size = UDim2.new(1,0,1,0),
			Position = UDim2.new(0.5,0,0.5,0),
			ZIndex = 9902,
			Parent = outline2
		}
	)
	applyRounding(indent, self.rounding)
	applyBorders(indent, {
		Enabled = self.borders.border,
		Top = self.borders.borderTop,
		Right = self.borders.borderRight,
		Bottom = self.borders.borderBottom,
		Left = self.borders.borderLeft,
		Color = Color3.fromRGB(56,56,56),
		Thickness = self.borders.borderThickness
	})
	local title = utility.new(
		"TextLabel",
		{
			AnchorPoint = Vector2.new(0.5,0),
			BackgroundTransparency = 1,
			Size = UDim2.new(1,-10,1,0),
			Position = UDim2.new(0.5,0,0,0),
			Font = self.font,
			Text = "",
			TextWrapped=true,
			RichText = true,
			TextColor3 = Color3.fromRGB(255,255,255),
			TextXAlignment = "Left",
			TextSize = self.textsize,
			TextStrokeTransparency = 0,
			ZIndex = 9903,
			Parent = indent
		}
	)
	local con
	con = title:GetPropertyChangedSignal("TextBounds"):Connect(function()
		outline.Size = UDim2.new(0,title.TextBounds.X+20,0,26)
	end)
	watermark = {
		["outline"] = outline,
		["outline2"] = outline2,
		["indent"] = indent,
		["title"] = title,
		["connection"] = con
	}
	self.labels[#self.labels+1] = title
	setmetatable(watermark,watermarks)
	return watermark
end

function watermarks:update(content)
	local content = content or {}
	local watermark = self
	local text = ""
	for i,v in pairs(content) do
		text = text..i..": "..v.."  "
	end
	text = text:sub(0, -3)
	watermark.title.Text = text
end

function watermarks:updateside(side)
	side = utility.removespaces(tostring(side):lower())
	local sides = {
		topright = {
			AnchorPoint = Vector2.new(1,0),
			Position = UDim2.new(1,-10,0,10)
		},
		topleft = {
			AnchorPoint = Vector2.new(0,0),
			Position = UDim2.new(0,10,0,10)
		},
		bottomright = {
			AnchorPoint = Vector2.new(1,1),
			Position = UDim2.new(1,-10,1,-10)
		},
		bottomleft = {
			AnchorPoint = Vector2.new(0,1),
			Position = UDim2.new(0,10,1,-10)
		}
	}
	if sides[side] then
		self.outline.AnchorPoint = sides[side].AnchorPoint
		self.outline.Position = sides[side].Position
	end
end

function comet:loader(props)
	local name = props.name or props.Name or props.LoaderName or props.Loadername or props.loaderName or props.loadername or "Loader"
	local lcontent = props.lcontent or props.Lcontent or props.LContent or props.content or props.Content or "Universal"
	local closed = props.close or props.Close or props.closecallback or props.Closecallback or props.CloseCallback or props.closeCallback or function()end
	local logedin = props.login or props.Login or props.logincallback or props.Logincallback or props.LoginCallback or props.loginCallback or function()end
	local rounding = props.rounding or self.rounding
	local borderCfg = borderOptions(props, self.borders)
	local loader = {}
	local screen = utility.new(
		"ScreenGui",
		{
			Name = tostring(math.random(0,999999))..tostring(math.random(0,999999)),
			DisplayOrder = 9999,
			ResetOnSpawn = false,
			ZIndexBehavior = "Global",
			Parent = cre
		}
	)
	if (check_exploit == "Synapse" and syn.request) then
		syn.protect_gui(screen)
	end
	local tempLabel = utility.new(
		"TextLabel",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 280, 0, 1000),
			Font = "RobotoMono",
			Text = lcontent,
			RichText = true,
			TextSize = 12,
			TextWrapped = true,
			TextYAlignment = "Top",
			Visible = false,
			Parent = screen
		}
	)
	task.wait()
	local contentHeight = tempLabel.TextBounds.Y
	tempLabel:Destroy()
	local titleHeight = 20
	local contentPadding = 10
	local buttonHeight = 20
	local buttonSpacing = 2
	local totalButtonHeight = (buttonHeight * 2) + buttonSpacing
	local bottomPadding = 10
	local totalHeight = titleHeight + contentPadding + contentHeight + contentPadding + totalButtonHeight + bottomPadding
	totalHeight = math.max(totalHeight, 90)
	local outline = utility.new(
		"Frame",
		{
			AnchorPoint = Vector2.new(0.5,0.5),
			BackgroundColor3 = Color3.fromRGB(168, 52, 235),
			Size = UDim2.new(0, 300, 0, totalHeight),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			ZIndex = 9900,
			Visible = false,
			Parent = screen
		}
	)
	applyRounding(outline, rounding)
	applyBorders(outline, {
		Enabled = borderCfg.border,
		Top = borderCfg.borderTop,
		Right = borderCfg.borderRight,
		Bottom = borderCfg.borderBottom,
		Left = borderCfg.borderLeft,
		Color = borderCfg.borderColor,
		Thickness = borderCfg.borderThickness
	})
	local outline2 = utility.new(
		"Frame",
		{
			AnchorPoint = Vector2.new(0.5,0.5),
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			Size = UDim2.new(1, -4, 1, -4),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			ZIndex = 9901,
			Parent = outline
		}
	)
	applyRounding(outline2, rounding)
	applyBorders(outline2, {
		Enabled = borderCfg.border,
		Top = borderCfg.borderTop,
		Right = borderCfg.borderRight,
		Bottom = borderCfg.borderBottom,
		Left = borderCfg.borderLeft,
		Color = borderCfg.borderColor,
		Thickness = borderCfg.borderThickness
	})
	local indent = utility.new(
		"Frame",
		{
			AnchorPoint = Vector2.new(0.5,0.5),
			BackgroundColor3 = Color3.fromRGB(20, 20, 20),
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			ZIndex = 9902,
			Parent = outline2
		}
	)
	applyRounding(indent, rounding)
	applyBorders(indent, {
		Enabled = borderCfg.border,
		Top = borderCfg.borderTop,
		Right = borderCfg.borderRight,
		Bottom = borderCfg.borderBottom,
		Left = borderCfg.borderLeft,
		Color = Color3.fromRGB(56,56,56),
		Thickness = borderCfg.borderThickness
	})
	local title = utility.new(
		"TextLabel",
		{
			AnchorPoint = Vector2.new(0.5, 0),
			BackgroundTransparency = 1,
			Size = UDim2.new(1, -10, 0, 20),
			Position = UDim2.new(0.5, 0, 0, 0),
			Font = "RobotoMono",
			Text = name,
			RichText = true,
			TextWrapped=true,
			TextColor3 = Color3.fromRGB(168, 52, 235),
			TextXAlignment = "Center",
			TextSize = 12,
			TextStrokeTransparency = 0,
			ZIndex = 9903,
			Parent = indent
		}
	)
	local scripttitle = utility.new(
		"TextLabel",
		{
			AnchorPoint = Vector2.new(0, 0),
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, contentHeight),
			Position = UDim2.new(0, 0, 0, titleHeight + contentPadding),
			Font = "RobotoMono",
			Text = lcontent,
			RichText = true,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextXAlignment = "Center",
			TextWrapped=true,
			TextYAlignment = "Center",
			TextSize = 12,
			TextStrokeTransparency = 0,
			ZIndex = 9903,
			Parent = indent
		}
	)
	local buttonStartY = titleHeight + contentPadding + contentHeight + contentPadding
	local function makebutton(nameb, parent)
		local button_holder = utility.new(
			"Frame",
			{
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ZIndex = 9904,
				Parent = parent
			}
		)
		applyRounding(button_holder, rounding)
		local button_outline = utility.new(
			"Frame",
			{
				BackgroundColor3 = Color3.fromRGB(24, 24, 24),
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(1, 0, 1, 0),
				ZIndex = 9905,
				Parent = button_holder
			}
		)
		applyRounding(button_outline, rounding)
		applyBorders(button_outline, {
			Enabled = borderCfg.border,
			Top = borderCfg.borderTop,
			Right = borderCfg.borderRight,
			Bottom = borderCfg.borderBottom,
			Left = borderCfg.borderLeft,
			Color = Color3.fromRGB(12,12,12),
			Thickness = borderCfg.borderThickness
		})
		local button_outline2 = utility.new(
			"Frame",
			{
				BackgroundColor3 = Color3.fromRGB(24, 24, 24),
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(1, 0, 1, 0),
				ZIndex = 9906,
				Parent = button_outline
			}
		)
		applyRounding(button_outline2, rounding)
		applyBorders(button_outline2, {
			Enabled = borderCfg.border,
			Top = borderCfg.borderTop,
			Right = borderCfg.borderRight,
			Bottom = borderCfg.borderBottom,
			Left = borderCfg.borderLeft,
			Color = Color3.fromRGB(56,56,56),
			Thickness = borderCfg.borderThickness
		})
		local button_color = utility.new(
			"Frame",
			{
				AnchorPoint = Vector2.new(0, 0),
				BackgroundColor3 = Color3.fromRGB(30, 30, 30),
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 0),
				Position = UDim2.new(0, 0, 0, 0),
				ZIndex = 9907,
				Parent = button_outline2
			}
		)
		utility.new(
			"UIGradient",
			{
				Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(199, 191, 204)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255))},
				Rotation = 90,
				Parent = button_color
			}
		)
		local button_button = utility.new(
			"TextButton",
			{
				AnchorPoint = Vector2.new(0, 0),
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				Position = UDim2.new(0, 0, 0, 0),
				Text = nameb,
				RichText = true,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextSize = 12,
				TextStrokeTransparency = 0,
				Font = "RobotoMono",
				ZIndex = 9908,
				Parent = button_holder
			}
		)
		return {button_holder, button_outline, button_button}
	end
	local close = makebutton("Close", indent)
	local ok = makebutton("Okay!", indent)
	close[1].AnchorPoint = Vector2.new(0.5, 0)
	close[1].Size = UDim2.new(0.5, 0, 0, 20)
	close[1].Position = UDim2.new(0.5, 0, 0, buttonStartY)
	ok[1].AnchorPoint = Vector2.new(0.5, 0)
	ok[1].Size = UDim2.new(0.5, 0, 0, 20)
	ok[1].Position = UDim2.new(0.5, 0, 0, buttonStartY + 22)
	close[3].MouseButton1Down:Connect(function()
		close[2].BorderColor3 = Color3.fromRGB(168, 52, 235)
		outline:TweenPosition(UDim2.new(-1.5, 0, 0.5, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.75, true)
		closed()
		wait(0.05)
		close[2].BorderColor3 = Color3.fromRGB(12, 12, 12)
		wait(0.7)
		screen:Remove()
	end)
	ok[3].MouseButton1Down:Connect(function()
		ok[2].BorderColor3 = Color3.fromRGB(168, 52, 235)
		outline:TweenPosition(UDim2.new(1.5, 0, 0.5, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.75, true)
		logedin()
		wait(0.05)
		ok[2].BorderColor3 = Color3.fromRGB(12, 12, 12)
		wait(0.7)
		screen:Remove()
	end)
	loader = {
		["outline"] = outline,
		["outline2"] = outline2,
		["indent"] = indent,
		["title"] = title,
		["scripttitle"] = scripttitle
	}
	setmetatable(loader, loaders)
	return loader
end

function loaders:toggle()
	self.outline.Visible = true
end

function watermarks:toggle(bool)
	local watermark = self
	watermark.outline.Visible = bool
end

function comet:saveconfig()
	local cfg = {}
	for i,v in pairs(self.pointers) do
		cfg[i] = {}
		for c,d in pairs(v) do
			cfg[i][c] = {}
			for x,z in pairs(d) do
				if typeof(z.current) == "Color3" then
					cfg[i][c][x] = {z.current.R,z.current.G,z.current.B}
				else
					cfg[i][c][x] = z.current
				end
			end
		end
	end
	return hs:JSONEncode(cfg)
end

function comet:loadconfig(cfg)
	local cfg = hs:JSONDecode(readfile(cfg))
	for i,v in pairs(cfg) do
		for c,d in pairs(v) do
			for x,z in pairs(d) do
				if z ~= nil then
					if self.pointers[i] ~= nil and self.pointers[i][c] ~= nil and self.pointers[i][c][x] ~= nil then
						self.pointers[i][c][x]:set(z)
					end
				end
			end
		end
	end
end

function comet:settheme(theme,color)
	local window = self
	if window.theme[theme] then
		window.theme[theme] = color
	end
	if window.themeitems[theme] then
		for i,v in pairs(window.themeitems[theme]) do
			for z,x in pairs(v) do
				x[i] = color
			end
		end
	end
end

function comet:setkey(key)
	if typeof(key) == "EnumItem" then
		local window = self
		window.key = key
	end
end

function comet:settoggle(side,bool)
	if side == "x" then
		self.x = bool
	else
		self.y = bool
	end
end

function comet:setfont(font)
	if font ~= nil then
		local window = self
		for i,v in pairs(window.labels) do
			if v ~= nil then
				v.Font = font
			end
		end
	end
end

function comet:settextsize(size)
	if size ~= nil then
		local window = self
		for i,v in pairs(window.labels) do
			if v ~= nil then
				v.TextSize = size
			end
		end
	end
end

function comet:page(props)
	local name = props.name or props.Name or props.page or props.Page or props.pagename or props.Pagename or props.PageName or props.pageName or "new ui"
	local rounding = props.rounding or self.rounding
	local borderCfg = borderOptions(props, self.borders)
	local page = {}
	local tabbutton = utility.new(
		"Frame",
		{
			BackgroundColor3 = Color3.fromRGB(20, 20, 20),
			Size = UDim2.new(0,75,1,0),
			Parent = self.tabsbuttons
		}
	)
	applyRounding(tabbutton, rounding)
	applyBorders(tabbutton, {
		Enabled = borderCfg.border,
		Top = borderCfg.borderTop,
		Right = borderCfg.borderRight,
		Bottom = borderCfg.borderBottom,
		Left = borderCfg.borderLeft,
		Color = Color3.fromRGB(12,12,12),
		Thickness = borderCfg.borderThickness
	})
	local outline = utility.new(
		"Frame",
		{
			BackgroundColor3 = Color3.fromRGB(24, 24, 24),
			Size = UDim2.new(1,0,1,0),
			Position = UDim2.new(0,0,0,0),
			Parent = tabbutton
		}
	)
	applyRounding(outline, rounding)
	applyBorders(outline, {
		Enabled = borderCfg.border,
		Top = borderCfg.borderTop,
		Right = borderCfg.borderRight,
		Bottom = borderCfg.borderBottom,
		Left = borderCfg.borderLeft,
		Color = Color3.fromRGB(56,56,56),
		Thickness = borderCfg.borderThickness
	})
	local button = utility.new(
		"TextButton",
		{
			AnchorPoint = Vector2.new(0,0),
			BackgroundTransparency = 1,
			Size = UDim2.new(1,0,1,0),
			Position = UDim2.new(0,0,0,0),
			Text = "",
			Parent = tabbutton
		}
	)
	local indicatorBar = utility.new(
		"Frame",
		{
			BackgroundColor3 = self.theme.accent,
			BorderSizePixel = 0,
			Size = UDim2.new(1,0,0,3),
			Position = UDim2.new(0,0,1,-3),
			ZIndex = 3,
			Parent = outline
		}
	)
	indicatorBar.Visible = false
	table.insert(self.themeitems["accent"]["BackgroundColor3"],indicatorBar)
	local label = utility.new(
		"TextLabel",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1,0,0,20),
			Position = UDim2.new(0,0,0,0),
			Font = self.font,
			Text = name,
			RichText = true,
			TextWrapped=true,
			TextColor3 = Color3.fromRGB(255,255,255),
			TextSize = self.textsize,
			TextStrokeTransparency = 0,
			Parent = outline
		}
	)
	local pageholder = utility.new(
		"Frame",
		{
			AnchorPoint = Vector2.new(0.5,0.5),
			BackgroundTransparency = 1,
			Size = UDim2.new(1,-20,1,-20),
			Position = UDim2.new(0.5,0,0.5,0),
			Visible = false,
			Parent = self.tabs
		}
	)
	applyRounding(pageholder, rounding)
	local left = utility.new(
		"ScrollingFrame",
		{
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(self.layout.SectionWidthLeft,-5,1,0),
			Position = UDim2.new(0,0,0,0),
			AutomaticCanvasSize = "Y",
			CanvasSize = UDim2.new(0,0,0,0),
			ScrollBarImageTransparency = 0.25,
			ScrollBarImageColor3 = Color3.fromRGB(0,0,0),
			ScrollBarThickness = 5,
			ClipsDescendants = true,
			VerticalScrollBarInset = "ScrollBar",
			VerticalScrollBarPosition = "Right",
			Parent = pageholder
		}
	)
	utility.new(
		"UIListLayout",
		{
			FillDirection = "Vertical",
			Padding = UDim.new(0,self.layout.SectionGap),
			Parent = left
		}
	)
	local right = utility.new(
		"ScrollingFrame",
		{
			AnchorPoint = Vector2.new(1,0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(self.layout.SectionWidthRight,-5,1,0),
			Position = UDim2.new(1,0,0,0),
			AutomaticCanvasSize = "Y",
			CanvasSize = UDim2.new(0,0,0,0),
			ScrollBarImageTransparency = 0.25,
			ScrollBarImageColor3 = Color3.fromRGB(0,0,0),
			ScrollBarThickness = 5,
			ClipsDescendants = true,
			VerticalScrollBarInset = "ScrollBar",
			VerticalScrollBarPosition = "Right",
			Parent = pageholder
		}
	)
	utility.new(
		"UIListLayout",
		{
			FillDirection = "Vertical",
			Padding = UDim.new(0,self.layout.SectionGap),
			Parent = right
		}
	)
	local full = utility.new(
		"ScrollingFrame",
		{
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1,0,1,0),
			Position = UDim2.new(0,0,0,0),
			AutomaticCanvasSize = "Y",
			CanvasSize = UDim2.new(0,0,0,0),
			ScrollBarImageTransparency = 0.25,
			ScrollBarImageColor3 = Color3.fromRGB(0,0,0),
			ScrollBarThickness = 5,
			ClipsDescendants = true,
			VerticalScrollBarInset = "ScrollBar",
			VerticalScrollBarPosition = "Right",
			Visible = false,
			Parent = pageholder
		}
	)
	utility.new(
		"UIListLayout",
		{
			FillDirection = "Vertical",
			Padding = UDim.new(0,self.layout.SectionGap),
			Parent = full
		}
	)
	local bottomConnect = utility.new(
		"Frame",
		{
			BackgroundColor3 = self.theme.accent,
			BorderSizePixel = 0,
			Size = UDim2.new(1,0,0,3),
			Position = UDim2.new(0,0,0,0),
			ZIndex = 3,
			Parent = self.tabs
		}
	)
	bottomConnect.Visible = false
	table.insert(self.themeitems["accent"]["BackgroundColor3"],bottomConnect)
	page = {
		["comet"] = self,
		["outline"] = outline,
		["page"] = pageholder,
		["left"] = left,
		["right"] = right,
		["full"] = full,
		["open"] = false,
		["pointers"] = {},
		["indicator"] = indicatorBar,
		["connector"] = bottomConnect,
		["rounding"] = rounding,
		["borders"] = borderCfg,
		["tabbutton"] = tabbutton
	}
	table.insert(self.pages,page)
	button.MouseButton1Down:Connect(function()
		if page.open == false then
			for i,v in pairs(self.pages) do
				if v ~= page then
					if v.open then
						v.page.Visible = false
						v.open = false
						v.indicator.Visible = false
						v.connector.Visible = false
						v.outline.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
					end
				end
			end
			self:closewindows()
			page.page.Visible = true
			page.open = true
			page.outline.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			page.indicator.Visible = true
			page.connector.Visible = true
			local abs = tabbutton.AbsolutePosition
			local size = tabbutton.AbsoluteSize
			local parentAbs = self.tabs.AbsolutePosition
			local xPos = abs.X - parentAbs.X
			page.connector.Position = UDim2.new(0,xPos,0,0)
			page.connector.Size = UDim2.new(0,size.X,0,3)
		end
	end)
	rs.RenderStepped:Connect(function()
		if page.open and page.tabbutton.Parent and self.tabs then
			local abs = page.tabbutton.AbsolutePosition
			local size = page.tabbutton.AbsoluteSize
			local parentAbs = self.tabs.AbsolutePosition
			local xPos = abs.X - parentAbs.X
			page.connector.Position = UDim2.new(0,xPos,0,0)
			page.connector.Size = UDim2.new(0,size.X,0,3)
		end
	end)
	local pointer = props.pointer or props.Pointer or props.pointername or props.Pointername or props.PointerName or props.pointerName or nil
	if pointer then
		self.pointers[tostring(pointer)] = page.pointers
	end
	self.labels[#self.labels+1] = label
	setmetatable(page, pages)
	return page
end

function pages:openpage()
	local page = self
	if page.open == false then
		for i,v in pairs(page.comet.pages) do
			if v ~= page then
				if v.open then
					v.page.Visible = false
					v.open = false
					v.indicator.Visible = false
					v.connector.Visible = false
					v.outline.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
				end
			end
		end
		page.page.Visible = true
		page.open = true
		page.outline.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		page.indicator.Visible = true
		page.connector.Visible = true
		local abs = page.tabbutton.AbsolutePosition
		local size = page.tabbutton.AbsoluteSize
		local parentAbs = page.comet.tabs.AbsolutePosition
		local xPos = abs.X - parentAbs.X
		page.connector.Position = UDim2.new(0,xPos,0,0)
		page.connector.Size = UDim2.new(0,size.X,0,3)
	end
end

function pages:remove()
	local page = self
	for i, v in pairs(page.comet.pages) do
		if v == page then
			table.remove(page.comet.pages, i)
			break
		end
	end
	if page.page then page.page:Destroy() end
	if page.outline and page.outline.Parent then
		page.outline.Parent:Destroy()
	end
	if page.open and #page.comet.pages > 0 then
		page.comet.pages[1]:openpage()
	end
end

function pages:section(props)
	local name = props.name or props.Name or props.page or props.Page or props.pagename or props.Pagename or props.PageName or props.pageName or "new ui"
	local side = (props.side or props.Side or props.sectionside or props.Sectionside or props.SectionSide or props.sectionSide or "left"):lower()
	local size = props.size or props.Size or props.yaxis or props.yAxis or props.YAxis or props.Yaxis or 200
	local rounding = props.rounding or self.rounding
	local borderCfg = borderOptions(props, self.borders)
	local section = {}
	local parentFrame = (side == "right" and self.right) or (side == "both" and self.full) or self.left
	if side == "both" then
		self.left.Visible = false
		self.right.Visible = false
		self.full.Visible = true
	end
	local sectionholder = utility.new(
		"Frame",
		{
			BackgroundColor3 = Color3.fromRGB(24, 24, 24),
			Size = UDim2.new(1,0,0,size),
			Parent = parentFrame
		}
	)
	applyRounding(sectionholder, rounding)
	applyBorders(sectionholder, {
		Enabled = borderCfg.border,
		Top = borderCfg.borderTop,
		Right = borderCfg.borderRight,
		Bottom = borderCfg.borderBottom,
		Left = borderCfg.borderLeft,
		Color = Color3.fromRGB(56,56,56),
		Thickness = borderCfg.borderThickness
	})
	local outline = utility.new(
		"Frame",
		{
			BackgroundColor3 = Color3.fromRGB(24, 24, 24),
			Size = UDim2.new(1,0,1,0),
			Parent = sectionholder
		}
	)
	applyRounding(outline, rounding)
	applyBorders(outline, {
		Enabled = borderCfg.border,
		Top = borderCfg.borderTop,
		Right = borderCfg.borderRight,
		Bottom = borderCfg.borderBottom,
		Left = borderCfg.borderLeft,
		Color = Color3.fromRGB(12,12,12),
		Thickness = borderCfg.borderThickness
	})
	local color = utility.new(
		"Frame",
		{
			AnchorPoint = Vector2.new(0.5,0),
			BackgroundColor3 = self.comet.theme.accent,
			BorderSizePixel = 0,
			Size = UDim2.new(1,-2,0,1),
			Position = UDim2.new(0.5,0,0,0),
			Parent = outline
		}
	)
	table.insert(self.comet.themeitems["accent"]["BackgroundColor3"],color)
	local content = utility.new(
		"Frame",
		{
			AnchorPoint = Vector2.new(0.5,1),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1,-12,1,-25),
			Position = UDim2.new(0.5,0,1,-5),
			Parent = outline
		}
	)
	local title = utility.new(
		"TextLabel",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1,-5,0,20),
			Position = UDim2.new(0,5,0,0),
			Font = self.comet.font,
			Text = name,
			RichText = true,
			TextWrapped=true,
			TextColor3 = Color3.fromRGB(255,255,255),
			TextSize = self.comet.textsize,
			TextStrokeTransparency = 0,
			TextXAlignment = "Left",
			Parent = outline
		}
	)
	utility.new(
		"UIListLayout",
		{
			FillDirection = "Vertical",
			Padding = UDim.new(0,5),
			Parent = content
		}
	)
	section = {
		["comet"] = self.comet,
		["sectionholder"] = sectionholder,
		["color"] = color,
		["content"] = content,
		["pointers"] = {},
		["rounding"] = rounding,
		["borders"] = borderCfg
	}
	local pointer = props.pointer or props.Pointer or props.pointername or props.Pointername or props.PointerName or props.pointerName or nil
	if pointer then
		if self.pointers then
			self.pointers[tostring(pointer)] = section.pointers
		end
	end
	self.comet.labels[#self.comet.labels+1] = title
	setmetatable(section, sections)
	return section
end

function pages:multisection(props)
	local name = props.name or props.Name or props.page or props.Page or props.pagename or props.Pagename or props.PageName or props.pageName or "new ui"
	local side = (props.side or props.Side or props.sectionside or props.Sectionside or props.SectionSide or props.sectionSide or "left"):lower()
	local size = props.size or props.Size or props.yaxis or props.yAxis or props.YAxis or props.Yaxis or 200
	local notitle = props.notitle == true
	local rounding = props.rounding or self.rounding
	local borderCfg = borderOptions(props, self.borders)
	local parentFrame = (side == "right" and self.right) or (side == "both" and self.full) or self.left
	if side == "both" then
		self.left.Visible = false
		self.right.Visible = false
		self.full.Visible = true
	end
	local multisection = {}
	local sectionholder = utility.new(
		"Frame",
		{
			BackgroundColor3 = Color3.fromRGB(24, 24, 24),
			Size = UDim2.new(1,0,0,size),
			Parent = parentFrame
		}
	)
	applyRounding(sectionholder, rounding)
	applyBorders(sectionholder, {
		Enabled = borderCfg.border,
		Top = borderCfg.borderTop,
		Right = borderCfg.borderRight,
		Bottom = borderCfg.borderBottom,
		Left = borderCfg.borderLeft,
		Color = Color3.fromRGB(56,56,56),
		Thickness = borderCfg.borderThickness
	})
	local outline = utility.new(
		"Frame",
		{
			BackgroundColor3 = Color3.fromRGB(24, 24, 24),
			Size = UDim2.new(1,0,1,0),
			Parent = sectionholder
		}
	)
	applyRounding(outline, rounding)
	applyBorders(outline, {
		Enabled = borderCfg.border,
		Top = borderCfg.borderTop,
		Right = borderCfg.borderRight,
		Bottom = borderCfg.borderBottom,
		Left = borderCfg.borderLeft,
		Color = Color3.fromRGB(12,12,12),
		Thickness = borderCfg.borderThickness
	})
	local color = utility.new(
		"Frame",
		{
			AnchorPoint = Vector2.new(0.5,0),
			BackgroundColor3 = self.comet.theme.accent,
			BorderSizePixel = 0,
			Size = UDim2.new(1,-2,0,1),
			Position = UDim2.new(0.5,0,0,0),
			Parent = outline
		}
	)
	table.insert(self.comet.themeitems["accent"]["BackgroundColor3"],color)
	local tabsholder = utility.new(
		"Frame",
		{
			AnchorPoint = Vector2.new(0,1),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1,0,1,-(notitle and 5 or 15)),
			Position = UDim2.new(0,0,1,0),
			Parent = outline
		}
	)
	local title
	if not notitle then
		title = utility.new(
			"TextLabel",
			{
				BackgroundTransparency = 1,
				Size = UDim2.new(1,-5,0,20),
				Position = UDim2.new(0,5,0,0),
				Font = self.comet.font,
				Text = name,
				RichText = true,
				TextWrapped=true,
				TextColor3 = Color3.fromRGB(255,255,255),
				TextSize = self.comet.textsize,
				TextStrokeTransparency = 0,
				TextXAlignment = "Left",
				Parent = outline
			}
		)
		self.comet.labels[#self.comet.labels+1] = title
	end
	local buttons = utility.new(
		"Frame",
		{
			AnchorPoint = Vector2.new(0.5,0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1,-6,0,20),
			Position = UDim2.new(0.5,0,0,5),
			Parent = tabsholder
		}
	)
	local tabs = utility.new(
		"Frame",
		{
			AnchorPoint = Vector2.new(0.5,1),
			BackgroundColor3 = Color3.fromRGB(20, 20, 20),
			Size = UDim2.new(1,-6,1,-(notitle and 7 or 27)),
			Position = UDim2.new(0.5,0,1,-3),
			Parent = tabsholder
		}
	)
	applyRounding(tabs, rounding)
	applyBorders(tabs, {
		Enabled = borderCfg.border,
		Top = borderCfg.borderTop,
		Right = borderCfg.borderRight,
		Bottom = borderCfg.borderBottom,
		Left = borderCfg.borderLeft,
		Color = Color3.fromRGB(12,12,12),
		Thickness = borderCfg.borderThickness
	})
	utility.new(
		"UIListLayout",
		{
			FillDirection = "Horizontal",
			Padding = UDim.new(0,2),
			Parent = buttons
		}
	)
	local tabs_outline = utility.new(
		"Frame",
		{
			AnchorPoint = Vector2.new(0,0),
			BackgroundColor3 = Color3.fromRGB(24, 24, 24),
			Size = UDim2.new(1,0,1,0),
			Position = UDim2.new(0,0,0,0),
			Parent = tabs
		}
	)
	applyRounding(tabs_outline, rounding)
	applyBorders(tabs_outline, {
		Enabled = borderCfg.border,
		Top = borderCfg.borderTop,
		Right = borderCfg.borderRight,
		Bottom = borderCfg.borderBottom,
		Left = borderCfg.borderLeft,
		Color = Color3.fromRGB(56,56,56),
		Thickness = borderCfg.borderThickness
	})
	multisection = {
		["comet"] = self.comet,
		["sectionholder"] = sectionholder,
		["color"] = color,
		["tabsholder"] = tabsholder,
		["mssections"] = {},
		["buttons"] = buttons,
		["tabs"] = tabs,
		["tabs_outline"] = tabs_outline,
		["pointers"] = {},
		["rounding"] = rounding,
		["borders"] = borderCfg,
		["notitle"] = notitle
	}
	local pointer = props.pointer or props.Pointer or props.pointername or props.Pointername or props.PointerName or props.pointerName or nil
	if pointer then
		if self.pointers then
			self.pointers[tostring(pointer)] = multisection.pointers
		end
	end
	setmetatable(multisection,multisections)
	return multisection
end

function multisections:section(props)
	local name = props.name or props.Name or props.page or props.Page or props.pagename or props.Pagename or props.PageName or props.pageName or "new ui"
	local rounding = props.rounding or self.rounding
	local borderCfg = borderOptions(props, self.borders)
	local mssection = {}
	local tabbutton = utility.new(
		"Frame",
		{
			BackgroundColor3 = Color3.fromRGB(20, 20, 20),
			Size = UDim2.new(0,60,0,20),
			Parent = self.buttons
		}
	)
	applyRounding(tabbutton, rounding)
	applyBorders(tabbutton, {
		Enabled = borderCfg.border,
		Top = borderCfg.borderTop,
		Right = borderCfg.borderRight,
		Bottom = borderCfg.borderBottom,
		Left = borderCfg.borderLeft,
		Color = Color3.fromRGB(12,12,12),
		Thickness = borderCfg.borderThickness
	})
	local outline = utility.new(
		"Frame",
		{
			BackgroundColor3 = Color3.fromRGB(20, 20, 20),
			Size = UDim2.new(1,0,1,0),
			Position = UDim2.new(0,0,0,0),
			Parent = tabbutton
		}
	)
	applyRounding(outline, rounding)
	applyBorders(outline, {
		Enabled = borderCfg.border,
		Top = borderCfg.borderTop,
		Right = borderCfg.borderRight,
		Bottom = borderCfg.borderBottom,
		Left = borderCfg.borderLeft,
		Color = Color3.fromRGB(56,56,56),
		Thickness = borderCfg.borderThickness
	})
	local button = utility.new(
		"TextButton",
		{
			AnchorPoint = Vector2.new(0,0),
			BackgroundTransparency = 1,
			Size = UDim2.new(1,0,1,0),
			Position = UDim2.new(0,0,0,0),
			Text = "",
			Parent = tabbutton
		}
	)
	local line = utility.new(
		"Frame",
		{
			BackgroundColor3 = Color3.fromRGB(20, 20, 20),
			BorderSizePixel = 0,
			Size = UDim2.new(1,0,0,2),
			Position = UDim2.new(0,0,1,0),
			ZIndex = 2,
			Parent = outline
		}
	)
	local label = utility.new(
		"TextLabel",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1,0,0,20),
			Position = UDim2.new(0,0,0,0),
			Font = self.comet.font,
			Text = name,
			RichText = true,
			TextWrapped=true,
			TextColor3 = Color3.fromRGB(255,255,255),
			TextSize = self.comet.textsize,
			TextStrokeTransparency = 0,
			Parent = outline
		}
	)
	local isFirst = #self.mssections == 0
	local content = utility.new(
		"Frame",
		{
			AnchorPoint = Vector2.new(0.5,1),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1,-6,1,-6),
			Position = UDim2.new(0.5,0,1,0),
			Visible = isFirst,
			Parent = self.tabs_outline
		}
	)
	utility.new(
		"UIListLayout",
		{
			FillDirection = "Vertical",
			Padding = UDim.new(0,5),
			Parent = content
		}
	)
	mssection = {
		["comet"] = self.comet,
		["outline"] = outline,
		["line"] = line,
		["content"] = content,
		["open"] = isFirst,
		["pointers"] = {},
		["rounding"] = rounding,
		["borders"] = borderCfg
	}
	table.insert(self.mssections,mssection)
	if isFirst then
		mssection.outline.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
		mssection.line.Size = UDim2.new(1,0,0,3)
		mssection.line.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
	end
	button.MouseButton1Down:Connect(function()
		if mssection.open == false then
			for i,v in pairs(self.mssections) do
				if v ~= mssection then
					if v.open then
						v.content.Visible = false
						v.open = false
						v.outline.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
						v.line.Size = UDim2.new(1,0,0,2)
						v.line.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
					end
				end
			end
			mssection.comet:closewindows()
			mssection.content.Visible = true
			mssection.open = true
			mssection.outline.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
			mssection.line.Size = UDim2.new(1,0,0,3)
			mssection.line.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
		end
	end)
	local pointer = props.pointer or props.Pointer or props.pointername or props.Pointername or props.PointerName or props.pointerName or nil
	if pointer then
		if self.pointers then
			self.pointers[tostring(pointer)] = mssection.pointers
		end
	end
	self.comet.labels[#self.comet.labels+1] = label
	setmetatable(mssection,mssections)
	return mssection
end

function sections:toggle(props)
	local name = props.name or props.Name or props.page or props.Page or props.pagename or props.Pagename or props.PageName or props.pageName or "new ui"
	local def = props.def or props.Def or props.default or props.Default or props.toggle or props.Toggle or props.toggled or props.Toggled or false
	local callback = props.callback or props.callBack or props.CallBack or props.Callback or function()end
	local requires = props.requires or {}
	local rounding = props.rounding or self.rounding
	local borderCfg = borderOptions(props, self.borders)
	local toggle = {}
	local toggleholder = utility.new(
		"Frame",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1,0,0,15),
			Parent = self.content
		}
	)
	local outline = utility.new(
		"Frame",
		{
			BackgroundColor3 = Color3.fromRGB(24, 24, 24),
			Size = UDim2.new(0,15,0,15),
			Parent = toggleholder
		}
	)
	applyRounding(outline, rounding)
	applyBorders(outline, {
		Enabled = borderCfg.border,
		Top = borderCfg.borderTop,
		Right = borderCfg.borderRight,
		Bottom = borderCfg.borderBottom,
		Left = borderCfg.borderLeft,
		Color = Color3.fromRGB(12,12,12),
		Thickness = borderCfg.borderThickness
	})
	local button = utility.new(
		"TextButton",
		{
			AnchorPoint = Vector2.new(0,0),
			BackgroundTransparency = 1,
			Size = UDim2.new(1,0,1,0),
			Position = UDim2.new(0,0,0,0),
			Text = "",
			Parent = toggleholder
		}
	)
	local title = utility.new(
		"TextLabel",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1,-20,1,0),
			Position = UDim2.new(0,20,0,0),
			Font = self.comet.font,
			Text = name,
			RichText = true,
			TextWrapped=true,
			TextColor3 = Color3.fromRGB(255,255,255),
			TextSize = self.comet.textsize,
			TextStrokeTransparency = 0,
			TextXAlignment = "Left",
			Parent = toggleholder
		}
	)
	local col = Color3.fromRGB(20, 20, 20)
	if def then
		col = self.comet.theme.accent
	end
	local color = utility.new(
		"Frame",
		{
			BackgroundColor3 = col,
			Size = UDim2.new(1,0,1,0),
			Parent = outline
		}
	)
	applyRounding(color, rounding)
	applyBorders(color, {
		Enabled = borderCfg.border,
		Top = borderCfg.borderTop,
		Right = borderCfg.borderRight,
		Bottom = borderCfg.borderBottom,
		Left = borderCfg.borderLeft,
		Color = Color3.fromRGB(56,56,56),
		Thickness = borderCfg.borderThickness
	})
	if def then
		table.insert(self.comet.themeitems["accent"]["BackgroundColor3"],color)
	end
	utility.new(
		"UIGradient",
		{
			Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(199, 191, 204)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255))},
			Rotation = 90,
			Parent = color
		}
	)
	local dependent = requires and #requires>0
	local subHolder
	local subOutline
	local subColor
	local subButton
	local subTitle
	if dependent then
		subHolder = utility.new("Frame",{
			BackgroundTransparency = 1,
			Size = UDim2.new(1,-10,0,13),
			Position = UDim2.new(0,10,0,16),
			Parent = self.content
		})
		subOutline = utility.new("Frame",{
			BackgroundColor3 = Color3.fromRGB(24,24,24),
			Size = UDim2.new(0,13,0,13),
			Parent = subHolder
		})
		applyRounding(subOutline, rounding)
		applyBorders(subOutline, {
			Enabled = borderCfg.border,
			Top = borderCfg.borderTop,
			Right = borderCfg.borderRight,
			Bottom = borderCfg.borderBottom,
			Left = borderCfg.borderLeft,
			Color = Color3.fromRGB(12,12,12),
			Thickness = borderCfg.borderThickness
		})
		subColor = utility.new("Frame",{
			BackgroundColor3 = Color3.fromRGB(20,20,20),
			Size = UDim2.new(1,0,1,0),
			Parent = subOutline
		})
		applyRounding(subColor, rounding)
		applyBorders(subColor, {
			Enabled = borderCfg.border,
			Top = borderCfg.borderTop,
			Right = borderCfg.borderRight,
			Bottom = borderCfg.borderBottom,
			Left = borderCfg.borderLeft,
			Color = Color3.fromRGB(56,56,56),
			Thickness = borderCfg.borderThickness
		})
		utility.new("UIGradient",{
			Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(199,191,204)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255,255,255))},
			Rotation = 90,
			Parent = subColor
		})
		subButton = utility.new("TextButton",{
			BackgroundTransparency = 1,
			Size = UDim2.new(1,0,1,0),
			Text = "",
			Parent = subHolder
		})
		subTitle = utility.new("TextLabel",{
			BackgroundTransparency = 1,
			Size = UDim2.new(1,-18,1,0),
			Position = UDim2.new(0,18,0,0),
			Font = self.comet.font,
			Text = (props.subtitle or props.Subtitle or (name.." Option")),
			RichText = true,
			TextWrapped = true,
			TextColor3 = Color3.fromRGB(210,210,210),
			TextSize = self.comet.textsize-1,
			TextStrokeTransparency = 0,
			TextXAlignment = "Left",
			Parent = subHolder
		})
		self.comet.labels[#self.comet.labels+1] = subTitle
	end
	toggle = {
		["comet"] = self.comet,
		["toggleholder"] = toggleholder,
		["title"] = title,
		["color"] = color,
		["callback"] = callback,
		["current"] = def,
		["requires"] = requires,
		["isDependent"] = false,
		["sub"] = {
			holder = subHolder, outline = subOutline, color = subColor, button = subButton, title = subTitle, current = false
		},
		["rounding"] = rounding,
		["borders"] = borderCfg
	}
	local function parentRequiredOn()
		for _,key in ipairs(requires) do
			local found = nil
			for __,ptrtbl in pairs(self.pointers) do
				if ptrtbl[key] then
					found = ptrtbl[key]
					break
				end
			end
			if not found then
				for __,pg in pairs(self.comet.pages) do
					if pg.pointers and pg.pointers[key] then found = pg.pointers[key] break end
				end
			end
			if not found then return false end
			if found.current == false then return false end
		end
		return true
	end
	local function setColorActive(frame, isActive)
		if isActive then
			frame.BackgroundColor3 = self.comet.theme.accent
			table.insert(self.comet.themeitems["accent"]["BackgroundColor3"],frame)
		else
			frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
			local find = table.find(self.comet.themeitems["accent"]["BackgroundColor3"],frame)
			if find then table.remove(self.comet.themeitems["accent"]["BackgroundColor3"],find) end
		end
	end
	local function tryToggle(main, desired)
		if #requires>0 and desired then
			if not parentRequiredOn() then
				setColorActive(main and toggle.color or toggle.sub.color, false)
				if main then toggle.current = false else toggle.sub.current = false end
				return
			end
		end
		if main then
			toggle.current = desired
			toggle.callback(desired)
		else
			toggle.sub.current = desired
			toggle.callback(desired, true)
		end
		setColorActive(main and toggle.color or toggle.sub.color, desired)
	end
	button.MouseButton1Down:Connect(function()
		tryToggle(true, not toggle.current)
	end)
	if dependent and subButton then
		subButton.MouseButton1Down:Connect(function()
			tryToggle(false, not toggle.sub.current)
		end)
	end
	local pointer = props.pointer or props.Pointer or props.pointername or props.Pointername or props.PointerName or props.pointerName or nil
	if pointer then
		if self.pointers then
			self.pointers[tostring(pointer)] = toggle
		end
	end
	self.comet.labels[#self.comet.labels+1] = title
	setmetatable(toggle, toggles)
	return toggle
end

function toggles:set(bool)
	if bool ~= nil then
		local toggle = self
		if #toggle.requires>0 and bool then
			local ok = true
			local function check()
				for _,key in ipairs(toggle.requires) do
					local found = nil
					for __,ptrtbl in pairs(toggle.comet.pointers) do
						if ptrtbl[key] then found = ptrtbl[key] break end
					end
					if not found then return false end
					if found.current == false then return false end
				end
				return true
			end
			ok = check()
			if not ok then bool = false end
		end
		toggle.callback(bool)
		toggle.current = bool
		if bool then
			toggle.color.BackgroundColor3 = self.comet.theme.accent
			table.insert(self.comet.themeitems["accent"]["BackgroundColor3"],toggle.color)
		else
			toggle.color.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			local find = table.find(self.comet.themeitems["accent"]["BackgroundColor3"],toggle.color)
			if find then
				table.remove(self.comet.themeitems["accent"]["BackgroundColor3"],find)
			end
		end
	end
end

function sections:button(props)
	local name = props.name or props.Name or "new button"
	local callback = props.callback or props.callBack or props.CallBack or props.Callback or function()end
	local rounding = props.rounding or self.rounding
	local borderCfg = borderOptions(props, self.borders)
	local button = {}
	local buttonholder = utility.new(
		"Frame",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1,0,0,20),
			Parent = self.content
		}
	)
	local outline = utility.new(
		"Frame",
		{
			BackgroundColor3 = Color3.fromRGB(24, 24, 24),
			Size = UDim2.new(1,0,1,0),
			Parent = buttonholder
		}
	)
	applyRounding(outline, rounding)
	applyBorders(outline, {
		Enabled = borderCfg.border,
		Top = borderCfg.borderTop,
		Right = borderCfg.borderRight,
		Bottom = borderCfg.borderBottom,
		Left = borderCfg.borderLeft,
		Color = Color3.fromRGB(12,12,12),
		Thickness = borderCfg.borderThickness
	})
	local outline2 = utility.new(
		"Frame",
		{
			BackgroundColor3 = Color3.fromRGB(24, 24, 24),
			Size = UDim2.new(1,0,1,0),
			Parent = outline
		}
	)
	applyRounding(outline2, rounding)
	applyBorders(outline2, {
		Enabled = borderCfg.border,
		Top = borderCfg.borderTop,
		Right = borderCfg.borderRight,
		Bottom = borderCfg.borderBottom,
		Left = borderCfg.borderLeft,
		Color = Color3.fromRGB(56,56,56),
		Thickness = borderCfg.borderThickness
	})
	local color = utility.new(
		"Frame",
		{
			BackgroundColor3 = Color3.fromRGB(30, 30, 30),
			BorderSizePixel = 0,
			Size = UDim2.new(1,0,1,0),
			Parent = outline2
		}
	)
	utility.new(
		"UIGradient",
		{
			Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(199, 191, 204)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255))},
			Rotation = 90,
			Parent = color
		}
	)
	local buttonpress = utility.new(
		"TextButton",
		{
			AnchorPoint = Vector2.new(0,0),
			BackgroundTransparency = 1,
			Size = UDim2.new(1,0,1,0),
			Position = UDim2.new(0,0,0,0),
			Text = name,
			RichText = true,
			TextColor3 = Color3.fromRGB(255,255,255),
			TextSize = self.comet.textsize,
			TextStrokeTransparency = 0,
			Font = self.comet.font,
			Parent = buttonholder
		}
	)
	buttonpress.MouseButton1Down:Connect(function()
		callback()
		outline.BorderColor3 = self.comet.theme.accent
		table.insert(self.comet.themeitems["accent"]["BorderColor3"],outline)
		wait(0.05)
		outline.BorderColor3 = Color3.fromRGB(12, 12, 12)
		local find = table.find(self.comet.themeitems["accent"]["BorderColor3"],outline)
		if find then
			table.remove(self.comet.themeitems["accent"]["BorderColor3"],find)
		end
	end)
	button = {
		["comet"] = self.comet
	}
	self.comet.labels[#self.comet.labels+1] = buttonpress
	setmetatable(button, buttons)
	return button
end

function sections:slider(props)
	local name = props.name or props.Name or props.page or props.Page or props.pagename or props.Pagename or props.PageName or props.pageName or "new ui"
	local def = props.def or props.Def or props.default or props.Default or 0
	local max = props.max or props.Max or props.maximum or props.Maximum or 100
	local min = props.min or props.Min or props.minimum or props.Minimum or 0
	local roundingNum = props.roundingnum or props.Roundingnum or props.decimals or props.Decimals or false
	local ticking = props.tick or props.Tick or props.ticking or props.Ticking or false
	local measurement = props.measurement or props.Measurement or props.digit or props.Digit or props.calc or props.Calc or ""
	local callback = props.callback or props.callBack or props.CallBack or props.Callback or function()end
	local rounding = props.rounding or self.rounding
	local borderCfg = borderOptions(props, self.borders)
	def = math.clamp(def,min,max)
	local slider = {}
	local sliderholder = utility.new(
		"Frame",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1,0,0,25),
			Parent = self.content
		}
	)
	local outline = utility.new(
		"Frame",
		{
			BackgroundColor3 = Color3.fromRGB(24, 24, 24),
			Size = UDim2.new(1,0,0,12),
			Position = UDim2.new(0,0,0,15),
			Parent = sliderholder
		}
	)
	applyRounding(outline, rounding)
	applyBorders(outline, {
		Enabled = borderCfg.border,
		Top = borderCfg.borderTop,
		Right = borderCfg.borderRight,
		Bottom = borderCfg.borderBottom,
		Left = borderCfg.borderLeft,
		Color = Color3.fromRGB(12,12,12),
		Thickness = borderCfg.borderThickness
	})
	local outline2 = utility.new(
		"Frame",
		{
			BackgroundColor3 = Color3.fromRGB(30, 30, 30),
			Size = UDim2.new(1,0,1,0),
			Parent = outline
		}
	)
	local value = utility.new(
		"TextLabel",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1,0,0,2),
			Position = UDim2.new(0,0,0.5,0),
			Font = self.comet.font,
			Text = def..measurement.."/"..max..measurement,
			RichText = true,
			TextWrapped=true,
			TextColor3 = Color3.fromRGB(255,255,255),
			TextSize = self.comet.textsize,
			TextStrokeTransparency = 0,
			ZIndex = 3,
			Parent = outline
		}
	)
	local color = utility.new(
		"Frame",
		{
			BackgroundColor3 = Color3.fromRGB(30, 30, 30),
			BorderSizePixel = 0,
			Size = UDim2.new(1,0,1,0),
			Parent = outline2
		}
	)
	utility.new(
		"UIGradient",
		{
			Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(199, 191, 204)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255))},
			Rotation = 90,
			Parent = color
		}
	)
	local slide = utility.new(
		"Frame",
		{
			BackgroundColor3 = self.comet.theme.accent,
			BorderSizePixel = 0,
			Size = UDim2.new((1 / color.AbsoluteSize.X) * (color.AbsoluteSize.X / (max - min) * (def - min)),0,1,0),
			ZIndex = 2,
			Parent = outline
		}
	)
	table.insert(self.comet.themeitems["accent"]["BackgroundColor3"],slide)
	utility.new(
		"UIGradient",
		{
			Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(199, 191, 204)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255))},
			Rotation = 90,
			Parent = slide
		}
	)
	local sliderbutton = utility.new(
		"TextButton",
		{
			AnchorPoint = Vector2.new(0,0),
			BackgroundTransparency = 1,
			Size = UDim2.new(1,0,1,0),
			Position = UDim2.new(0,0,0,0),
			Text = "",
			Parent = sliderholder
		}
	)
	local title = utility.new(
		"TextLabel",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1,0,0,15),
			Position = UDim2.new(0,0,0,0),
			Font = self.comet.font,
			Text = name,
			RichText = true,
			TextWrapped=true,
			TextColor3 = Color3.fromRGB(255,255,255),
			TextSize = self.comet.textsize,
			TextStrokeTransparency = 0,
			TextXAlignment = "Left",
			Parent = sliderholder
		}
	)
	slider = {
		["comet"] = self.comet,
		["outline"] = outline,
		["sliderbutton"] = sliderbutton,
		["title"] = title,
		["value"] = value,
		["slide"] = slide,
		["color"] = color,
		["max"] = max,
		["min"] = min,
		["current"] = def,
		["measurement"] = measurement,
		["tick"] = ticking,
		["roundingnum"] = roundingNum,
		["callback"] = callback
	}
	local function slidefn()
		local size = math.clamp(plr:GetMouse().X - slider.color.AbsolutePosition.X ,0 ,slider.color.AbsoluteSize.X)
		local result = (slider.max - slider.min) / slider.color.AbsoluteSize.X * size + slider.min
		if slider.roundingnum then
			local newres = math.floor(result)
			value.Text = newres..slider.measurement.."/"..slider.max..slider.measurement
			slider.current = newres
			slider.callback(newres)
			if slider.tick then
				slider.slide:TweenSize(UDim2.new((1 / slider.color.AbsoluteSize.X) * (slider.color.AbsoluteSize.X / (slider.max - slider.min) * (newres - slider.min)) ,0 ,1 ,0) ,Enum.EasingDirection.Out ,Enum.EasingStyle.Quad ,0.15 ,true)
			else
				slider.slide:TweenSize(UDim2.new((1 / slider.color.AbsoluteSize.X) * size ,0 ,1 ,0) ,Enum.EasingDirection.Out ,Enum.EasingStyle.Quad ,0.15 ,true)
			end
		else
			local newres = utility.round(result ,2)
			value.Text = newres..slider.measurement.."/"..slider.max..slider.measurement
			slider.current = newres
			slider.callback(newres)
			if slider.tick then
				slider.slide:TweenSize(UDim2.new((1 / slider.color.AbsoluteSize.X) * (slider.color.AbsoluteSize.X / (slider.max - slider.min) * (newres - slider.min)) ,0 ,1 ,0) ,Enum.EasingDirection.Out ,Enum.EasingStyle.Quad ,0.15 ,true)
			else
				slider.slide:TweenSize(UDim2.new((1 / slider.color.AbsoluteSize.X) * size ,0 ,1 ,0) ,Enum.EasingDirection.Out ,Enum.EasingStyle.Quad ,0.15 ,true)
			end
		end
	end
	sliderbutton.MouseButton1Down:Connect(function()
		slider.holding = true
		slidefn()
		table.insert(self.comet.themeitems["accent"]["BorderColor3"],outline)
		outline.BorderColor3 = self.comet.theme.accent
	end)
	uis.InputChanged:Connect(function()
		if slider.holding then
			slidefn()
		end
	end)
	uis.InputEnded:Connect(function(Input)
		if Input.UserInputType.Name == 'MouseButton1' and slider.holding then
			slider.holding = false
			outline.BorderColor3 = Color3.fromRGB(12, 12, 12)
			local find = table.find(self.comet.themeitems["accent"]["BorderColor3"],outline)
			if find then
				table.remove(self.comet.themeitems["accent"]["BorderColor3"],find)
			end
		end
	end)
	local pointer = props.pointer or props.Pointer or props.pointername or props.Pointername or props.PointerName or props.pointerName or nil
	if pointer then
		if self.pointers then
			self.pointers[tostring(pointer)] = slider
		end
	end
	self.comet.labels[#self.comet.labels+1] = title
	self.comet.labels[#self.comet.labels+1] = value
	setmetatable(slider, sliders)
	return slider
end

function sliders:set(value)
	local size = math.clamp((self.color.AbsoluteSize.X / (self.max - self.min) * (value - self.min)) ,0 ,self.color.AbsoluteSize.X)
	local result = value
	if self.roundingnum then
		local newres = math.floor(result)
		self.value.Text = newres..self.measurement.."/"..self.max..self.measurement
		self.current = newres
		self.callback(newres)
		if self.tick then
			self.slide:TweenSize(UDim2.new((1 / self.color.AbsoluteSize.X) * (self.color.AbsoluteSize.X / (self.max - self.min) * (newres - self.min)) ,0 ,1 ,0) ,Enum.EasingDirection.Out ,Enum.EasingStyle.Quad ,0.15 ,true)
		else
			self.slide:TweenSize(UDim2.new((1 / self.color.AbsoluteSize.X) * size ,0 ,1 ,0) ,Enum.EasingDirection.Out ,Enum.EasingStyle.Quad ,0.15 ,true)
		end
	else
		local newres = utility.round(result ,2)
		self.value.Text = newres..self.measurement.."/"..self.max..self.measurement
		self.current = newres
		self.callback(newres)
		if self.tick then
			self.slide:TweenSize(UDim2.new((1 / self.color.AbsoluteSize.X) * (self.color.AbsoluteSize.X / (self.max - self.min) * (newres - self.min)) ,0 ,1 ,0) ,Enum.EasingDirection.Out ,Enum.EasingStyle.Quad ,0.15 ,true)
		else
			self.slide:TweenSize(UDim2.new((1 / self.color.AbsoluteSize.X) * size ,0 ,1 ,0) ,Enum.EasingDirection.Out ,Enum.EasingStyle.Quad ,0.15 ,true)
		end
	end
end

function comet:closewindows(ignore)
	local window = self
	for i,v in pairs(window.dropdowns) do
	if v ~= ignore then
			if v.open then
				v.optionsholder.Visible = false
				v.indicator.Text = "-"
				v.open = false
			end
		end
	end
	for i,v in pairs(window.multiboxes) do
		if v ~= ignore then
			if v.open then
				v.optionsholder.Visible = false
				v.indicator.Text = "-"
				v.open = false
			end
		end
	end
	for i,v in pairs(window.buttonboxs) do
		if v ~= ignore then
			if v.open then
				v.optionsholder.Visible = false
				v.indicator.Text = "-"
				v.open = false
			end
		end
	end
	for i,v in pairs(window.colorpickers) do
		if v ~= ignore then
			if v.open then
				v.cpholder.Visible = false
				v.open = false
			end
		end
	end
end

function sections:dropdown(props)
	local name = props.name or props.Name or props.page or props.Page or props.pagename or props.Pagename or props.PageName or props.pageName or "new ui"
	local def = props.def or props.Def or props.default or props.Default or ""
	local max = props.max or props.Max or props.maximum or props.Maximum or 4
	local options = props.options or props.Options or props.Settings or props.settings or {}
	local callback = props.callback or props.callBack or props.CallBack or props.Callback or function()end
	local rounding = props.rounding or self.rounding
	local borderCfg = borderOptions(props, self.borders)
	local dropdown = {}
	local dropdownholder = utility.new(
		"Frame",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1,0,0,35),
			ZIndex = 2,
			Parent = self.content
		}
	)
	local outline = utility.new(
		"Frame",
		{
			BackgroundColor3 = Color3.fromRGB(24, 24, 24),
			Size = UDim2.new(1,0,0,20),
			Position = UDim2.new(0,0,0,15),
			Parent = dropdownholder
		}
	)
	applyRounding(outline, rounding)
	applyBorders(outline, {
		Enabled = borderCfg.border,
		Top = borderCfg.borderTop,
		Right = borderCfg.borderRight,
		Bottom = borderCfg.borderBottom,
		Left = borderCfg.borderLeft,
		Color = Color3.fromRGB(12,12,12),
		Thickness = borderCfg.borderThickness
	})
	local outline2 = utility.new(
		"Frame",
		{
			BackgroundColor3 = Color3.fromRGB(24, 24, 24),
			Size = UDim2.new(1,0,1,0),
			Position = UDim2.new(0,0,0,0),
			Parent = outline
		}
	)
	applyRounding(outline2, rounding)
	applyBorders(outline2, {
		Enabled = borderCfg.border,
		Top = borderCfg.borderTop,
		Right = borderCfg.borderRight,
		Bottom = borderCfg.borderBottom,
		Left = borderCfg.borderLeft,
		Color = Color3.fromRGB(56,56,56),
		Thickness = borderCfg.borderThickness
	})
	local color = utility.new(
		"Frame",
		{
			BackgroundColor3 = Color3.fromRGB(30, 30, 30),
			BorderSizePixel = 0,
			Size = UDim2.new(1,0,1,0),
			Position = UDim2.new(0,0,0,0),
			Parent = outline2
		}
	)
	utility.new(
		"UIGradient",
		{
			Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(199, 191, 204)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255))},
			Rotation = 90,
			Parent = color
		}
	)
	local value = utility.new(
		"TextLabel",
		{
			AnchorPoint = Vector2.new(0,0),
			BackgroundTransparency = 1,
			Size = UDim2.new(1,-20,1,0),
			Position = UDim2.new(0,5,0,0),
			Font = self.comet.font,
			Text = def,
			RichText = true,
			TextWrapped=true,
			TextColor3 = Color3.fromRGB(255,255,255),
			TextSize = self.comet.textsize,
			TextStrokeTransparency = 0,
			TextXAlignment = "Left",
			ClipsDescendants = true,
			Parent = outline
		}
	)
	local indicator = utility.new(
		"TextLabel",
		{
			AnchorPoint = Vector2.new(0.5,0),
			BackgroundTransparency = 1,
			Size = UDim2.new(1,-10,1,0),
			Position = UDim2.new(0.5,0,0,0),
			Font = self.comet.font,
			Text = "+",
			RichText = true,
			TextWrapped=true,
			TextColor3 = Color3.fromRGB(255,255,255),
			TextSize = self.comet.textsize,
			TextStrokeTransparency = 0,
			TextXAlignment = "Right",
			ClipsDescendants = true,
			Parent = outline
		}
	)
	local title = utility.new(
		"TextLabel",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1,0,0,15),
			Position = UDim2.new(0,0,0,0),
			Font = self.comet.font,
			Text = name,
			RichText = true,
			TextWrapped=true,
			TextColor3 = Color3.fromRGB(255,255,255),
			TextSize = self.comet.textsize,
			TextStrokeTransparency = 0,
			TextXAlignment = "Left",
			Parent = dropdownholder
		}
	)
	local dropdownbutton = utility.new(
		"TextButton",
		{
			AnchorPoint = Vector2.new(0,0),
			BackgroundTransparency = 1,
			Size = UDim2.new(1,0,1,0),
			Position = UDim2.new(0,0,0,0),
			Text = "",
			Parent = dropdownholder
		}
	)
	local optionsholder = utility.new(
		"Frame",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1,0,0,20),
			Position = UDim2.new(0,0,0,34),
			Visible = false,
			Parent = dropdownholder
		}
	)
	local size = #options
	size = math.clamp(size,1,max)
	local optionsoutline = utility.new(
		"ScrollingFrame",
		{
			BackgroundColor3 = Color3.fromRGB(56, 56, 56),
			BorderSizePixel = 0,
			Size = UDim2.new(1,0,size,2),
			Position = UDim2.new(0,0,0,0),
			ClipsDescendants = true,
			CanvasSize = UDim2.new(0,0,0,18*#options),
			ScrollBarImageTransparency = 0.25,
			ScrollBarImageColor3 = Color3.fromRGB(0,0,0),
			ScrollBarThickness = 5,
			VerticalScrollBarInset = "ScrollBar",
			VerticalScrollBarPosition = "Right",
			ZIndex = 5,
			Parent = optionsholder
		}
	)
	applyBorders(optionsoutline, {
		Enabled = borderCfg.border,
		Top = borderCfg.borderTop,
		Right = borderCfg.borderRight,
		Bottom = borderCfg.borderBottom,
		Left = borderCfg.borderLeft,
		Color = Color3.fromRGB(56,56,56),
		Thickness = borderCfg.borderThickness
	})
	utility.new(
		"UIListLayout",
		{
			FillDirection = "Vertical",
			Parent = optionsoutline
		}
	)
	dropdown = {
		["comet"] = self.comet,
		["optionsholder"] = optionsholder,
		["indicator"] = indicator,
		["options"] = options,
		["title"] = title,
		["value"] = value,
		["open"] = false,
		["titles"] = {},
		["current"] = def,
		["callback"] = callback
	}
	table.insert(dropdown.comet.dropdowns,dropdown)
	for i,v in pairs(options) do
		local ddoptionbutton = utility.new(
			"TextButton",
			{
				AnchorPoint = Vector2.new(0,0),
				BackgroundTransparency = 1,
				Size = UDim2.new(1,0,0,18),
				Text = "",
				ZIndex = 6,
				Parent = optionsoutline
			}
		)
		local ddoptiontitle = utility.new(
			"TextLabel",
			{
				AnchorPoint = Vector2.new(0.5,0),
				BackgroundTransparency = 1,
				Size = UDim2.new(1,-10,1,0),
				Position = UDim2.new(0.5,0,0,0),
				Font = self.comet.font,
				Text = v,
				RichText = true,
				TextWrapped=true,
				TextColor3 = Color3.fromRGB(255,255,255),
				TextSize = self.comet.textsize,
				TextStrokeTransparency = 0,
				TextXAlignment = "Left",
				ClipsDescendants = true,
				ZIndex = 6,
				Parent = ddoptionbutton
			}
		)
		self.comet.labels[#self.comet.labels+1] = ddoptiontitle
		table.insert(dropdown.titles,ddoptiontitle)
		if v == dropdown.current then ddoptiontitle.TextColor3 = self.comet.theme.accent end
		ddoptionbutton.MouseButton1Down:Connect(function()
			optionsholder.Visible = false
			dropdown.open = false
			indicator.Text = "+"
			for z,x in pairs(dropdown.titles) do
				if x.TextColor3 == self.comet.theme.accent then
					x.TextColor3 = Color3.fromRGB(255,255,255)
				end
			end
			dropdown.current = v
			dropdown.value.Text = v
			ddoptiontitle.TextColor3 = self.comet.theme.accent
			table.insert(self.comet.themeitems["accent"]["TextColor3"],ddoptiontitle)
			dropdown.callback(v)
		end)
	end
	dropdownbutton.MouseButton1Down:Connect(function()
		dropdown.comet:closewindows(dropdown)
		for i,v in pairs(dropdown.titles) do
			if v.Text == dropdown.current then
				v.TextColor3 = dropdown.comet.theme.accent
			else
				v.TextColor3 = Color3.fromRGB(255,255,255)
			end
		end
		optionsholder.Visible = not dropdown.open
		dropdown.open = not dropdown.open
		if dropdown.open then
			indicator.Text = "-"
		else
			indicator.Text = "+"
		end
	end)
	local pointer = props.pointer or props.Pointer or props.pointername or props.Pointername or props.PointerName or props.pointerName or nil
	if pointer then
		if self.pointers then
			self.pointers[tostring(pointer)] = dropdown
		end
	end
	self.comet.labels[#self.comet.labels+1] = title
	self.comet.labels[#self.comet.labels+1] = value
	setmetatable(dropdown, dropdowns)
	return dropdown
end

function sections:buttonbox(props)
	local name = props.name or props.Name or props.page or props.Page or props.pagename or props.Pagename or props.PageName or props.pageName or "new ui"
	local def = props.def or props.Def or props.default or props.Default or ""
	local max = props.max or props.Max or props.maximum or props.Maximum or 4
	local options = props.options or props.Options or props.Settings or props.settings or {}
	local callback = props.callback or props.callBack or props.CallBack or props.Callback or function()end
	local rounding = props.rounding or self.rounding
	local borderCfg = borderOptions(props, self.borders)
	local buttonbox = {}
	local buttonboxholder = utility.new(
		"Frame",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1,0,0,35),
			ZIndex = 2,
			Parent = self.content
		}
	)
	local outline = utility.new(
		"Frame",
		{
			BackgroundColor3 = Color3.fromRGB(24, 24, 24),
			Size = UDim2.new(1,0,0,20),
			Position = UDim2.new(0,0,0,15),
			Parent = buttonboxholder
		}
	)
	applyRounding(outline, rounding)
	applyBorders(outline, {
		Enabled = borderCfg.border,
		Top = borderCfg.borderTop,
		Right = borderCfg.borderRight,
		Bottom = borderCfg.borderBottom,
		Left = borderCfg.borderLeft,
		Color = Color3.fromRGB(12,12,12),
		Thickness = borderCfg.borderThickness
	})
	local outline2 = utility.new(
		"Frame",
		{
			BackgroundColor3 = Color3.fromRGB(24, 24, 24),
			Size = UDim2.new(1,0,1,0),
			Position = UDim2.new(0,0,0,0),
			Parent = outline
		}
	)
	applyRounding(outline2, rounding)
	applyBorders(outline2, {
		Enabled = borderCfg.border,
		Top = borderCfg.borderTop,
		Right = borderCfg.borderRight,
		Bottom = borderCfg.borderBottom,
		Left = borderCfg.borderLeft,
		Color = Color3.fromRGB(56,56,56),
		Thickness = borderCfg.borderThickness
	})
	local color = utility.new(
		"Frame",
		{
			BackgroundColor3 = Color3.fromRGB(30, 30, 30),
			BorderSizePixel = 0,
			Size = UDim2.new(1,0,1,0),
			Position = UDim2.new(0,0,0,0),
			Parent = outline2
		}
	)
	utility.new(
		"UIGradient",
		{
			Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(199, 191, 204)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255))},
			Rotation = 90,
			Parent = color
		}
	)
	local indicator = utility.new(
		"TextLabel",
		{
			AnchorPoint = Vector2.new(0.5,0),
			BackgroundTransparency = 1,
			Size = UDim2.new(1,-10,1,0),
			Position = UDim2.new(0.5,0,0,0),
			Font = self.comet.font,
			Text = "+",
			TextWrapped=true,
			RichText = true,
			TextColor3 = Color3.fromRGB(255,255,255),
			TextSize = self.comet.textsize,
			TextStrokeTransparency = 0,
			TextXAlignment = "Right",
			ClipsDescendants = true,
			Parent = outline
		}
	)
	local title = utility.new(
		"TextLabel",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1,0,0,15),
			Position = UDim2.new(0,0,0,0),
			Font = self.comet.font,
			Text = name,
			TextWrapped=true,
			RichText = true,
			TextColor3 = Color3.fromRGB(255,255,255),
			TextSize = self.comet.textsize,
			TextStrokeTransparency = 0,
			TextXAlignment = "Left",
			Parent = buttonboxholder
		}
	)
	local buttonboxbutton = utility.new(
		"TextButton",
		{
			AnchorPoint = Vector2.new(0,0),
			BackgroundTransparency = 1,
			Size = UDim2.new(1,0,1,0),
			Position = UDim2.new(0,0,0,0),
			Text = "",
			Parent = buttonboxholder
		}
	)
	local optionsholder = utility.new(
		"Frame",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1,0,0,20),
			Position = UDim2.new(0,0,0,34),
			Visible = false,
			Parent = buttonboxholder
		}
	)
	local size = #options
	size = math.clamp(size,1,max)
	local optionsoutline = utility.new(
		"ScrollingFrame",
		{
			BackgroundColor3 = Color3.fromRGB(56, 56, 56),
			BorderSizePixel = 0,
			Size = UDim2.new(1,0,size,2),
			Position = UDim2.new(0,0,0,0),
			ClipsDescendants = true,
			CanvasSize = UDim2.new(0,0,0,18*#options),
			ScrollBarImageTransparency = 0.25,
			ScrollBarImageColor3 = Color3.fromRGB(0,0,0),
			ScrollBarThickness = 5,
			VerticalScrollBarInset = "ScrollBar",
			VerticalScrollBarPosition = "Right",
			ZIndex = 5,
			Parent = optionsholder
		}
	)
	applyBorders(optionsoutline, {
		Enabled = borderCfg.border,
		Top = borderCfg.borderTop,
		Right = borderCfg.borderRight,
		Bottom = borderCfg.borderBottom,
		Left = borderCfg.borderLeft,
		Color = Color3.fromRGB(56,56,56),
		Thickness = borderCfg.borderThickness
	})
	utility.new(
		"UIListLayout",
		{
			FillDirection = "Vertical",
			Parent = optionsoutline
		}
	)
	buttonbox = {
		["comet"] = self.comet,
		["optionsholder"] = optionsholder,
		["indicator"] = indicator,
		["options"] = options,
		["title"] = title,
		["open"] = false,
		["titles"] = {},
		["current"] = def,
		["callback"] = callback
	}
	table.insert(buttonbox.comet.buttonboxs,buttonbox)
	for i,v in pairs(options) do
		local bboptionbutton = utility.new(
			"TextButton",
			{
				AnchorPoint = Vector2.new(0,0),
				BackgroundTransparency = 1,
				Size = UDim2.new(1,0,0,18),
				Text = "",
				ZIndex = 6,
				Parent = optionsoutline
			}
		)
		local bboptiontitle = utility.new(
			"TextLabel",
			{
				AnchorPoint = Vector2.new(0.5,0),
				BackgroundTransparency = 1,
				Size = UDim2.new(1,-10,1,0),
				Position = UDim2.new(0.5,0,0,0),
				Font = self.comet.font,
				Text = v,
				RichText = true,
				TextWrapped=true,
				TextColor3 = Color3.fromRGB(255,255,255),
				TextSize = self.comet.textsize,
				TextStrokeTransparency = 0,
				TextXAlignment = "Left",
				ClipsDescendants = true,
				ZIndex = 6,
				Parent = bboptionbutton
			}
		)
		self.comet.labels[#self.comet.labels+1] = bboptiontitle
		table.insert(buttonbox.titles,bboptiontitle)
		bboptionbutton.MouseButton1Down:Connect(function()
			optionsholder.Visible = false
			buttonbox.open = false
			indicator.Text = "+"
			buttonbox.current = v
			buttonbox.callback(v)
		end)
	end
	buttonboxbutton.MouseButton1Down:Connect(function()
		buttonbox.comet:closewindows(buttonbox)
		optionsholder.Visible = not buttonbox.open
		buttonbox.open = not buttonbox.open
		if buttonbox.open then
			indicator.Text = "-"
		else
			indicator.Text = "+"
		end
	end)
	local pointer = props.pointer or props.Pointer or props.pointername or props.Pointername or props.PointerName or props.pointerName or nil
	if pointer then
		if self.pointers then
			self.pointers[tostring(pointer)] = buttonbox
		end
	end
	self.comet.labels[#self.comet.labels+1] = title
	setmetatable(buttonbox, buttonboxs)
	return buttonbox
end

function dropdowns:set(value)
	if value ~= nil then
		local dropdown = self
		if table.find(dropdown.options,value) then
			self.current = tostring(value)
			self.value.Text = tostring(value)
			self.callback(tostring(value))
			for z,x in pairs(dropdown.titles) do
				if x.Text == value then
					x.TextColor3 = dropdown.comet.theme.accent
				else
					x.TextColor3 = Color3.fromRGB(255,255,255)
				end
			end
		end
	end
end

function sections:multibox(props)
	local name = props.name or props.Name or props.page or props.Page or props.pagename or props.Pagename or props.PageName or props.pageName or "new ui"
	local def = props.def or props.Def or props.default or props.Default or {}
	local max = props.max or props.Max or props.maximum or props.Maximum or 4
	local options = props.options or props.Options or props.Settings or props.settings or {}
	local callback = props.callback or props.callBack or props.CallBack or props.Callback or function()end
	local rounding = props.rounding or self.rounding
	local borderCfg = borderOptions(props, self.borders)
	local defstr = ""
	if #def > 1 then
		for i,v in pairs(def) do
			if i == #def then
				defstr = defstr..v
			else
				defstr = defstr..v..", "
			end
		end
	else
		for i,v in pairs(def) do
			defstr = defstr..v
		end
	end
	local multibox = {}
	local multiboxholder = utility.new(
		"Frame",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1,0,0,35),
			ZIndex = 2,
			Parent = self.content
		}
	)
	local outline = utility.new(
		"Frame",
		{
			BackgroundColor3 = Color3.fromRGB(24, 24, 24),
			Size = UDim2.new(1,0,0,20),
			Position = UDim2.new(0,0,0,15),
			Parent = multiboxholder
		}
	)
	applyRounding(outline, rounding)
	applyBorders(outline, {
		Enabled = borderCfg.border,
		Top = borderCfg.borderTop,
		Right = borderCfg.borderRight,
		Bottom = borderCfg.borderBottom,
		Left = borderCfg.borderLeft,
		Color = Color3.fromRGB(12,12,12),
		Thickness = borderCfg.borderThickness
	})
	local outline2 = utility.new(
		"Frame",
		{
			BackgroundColor3 = Color3.fromRGB(24, 24, 24),
			Size = UDim2.new(1,0,1,0),
			Position = UDim2.new(0,0,0,0),
			Parent = outline
		}
	)
	applyRounding(outline2, rounding)
	applyBorders(outline2, {
		Enabled = borderCfg.border,
		Top = borderCfg.borderTop,
		Right = borderCfg.borderRight,
		Bottom = borderCfg.borderBottom,
		Left = borderCfg.borderLeft,
		Color = Color3.fromRGB(56,56,56),
		Thickness = borderCfg.borderThickness
	})
	local color = utility.new(
		"Frame",
		{
			BackgroundColor3 = Color3.fromRGB(30, 30, 30),
			BorderSizePixel = 0,
			Size = UDim2.new(1,0,1,0),
			Position = UDim2.new(0,0,0,0),
			Parent = outline2
		}
	)
	utility.new(
		"UIGradient",
		{
			Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(199, 191, 204)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255))},
			Rotation = 90,
			Parent = color
		}
	)
	local value = utility.new(
		"TextLabel",
		{
			AnchorPoint = Vector2.new(0,0),
			BackgroundTransparency = 1,
			Size = UDim2.new(1,-20,1,0),
			Position = UDim2.new(0,5,0,0),
			Font = self.comet.font,
			Text = defstr,
			RichText = true,
			TextWrapped=true,
			TextColor3 = Color3.fromRGB(255,255,255),
			TextSize = self.comet.textsize,
			TextStrokeTransparency = 0,
			TextXAlignment = "Left",
			ClipsDescendants = true,
			Parent = outline
		}
	)
	local indicator = utility.new(
		"TextLabel",
		{
			AnchorPoint = Vector2.new(0.5,0),
			BackgroundTransparency = 1,
			Size = UDim2.new(1,-10,1,0),
			Position = UDim2.new(0.5,0,0,0),
			Font = self.comet.font,
			Text = "+",
			RichText = true,
			TextWrapped=true,
			TextColor3 = Color3.fromRGB(255,255,255),
			TextSize = self.comet.textsize,
			TextStrokeTransparency = 0,
			TextXAlignment = "Right",
			ClipsDescendants = true,
			Parent = outline
		}
	)
	local title = utility.new(
		"TextLabel",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1,0,0,15),
			Position = UDim2.new(0,0,0,0),
			Font = self.comet.font,
			Text = name,
			RichText = true,
			TextWrapped=true,
			TextColor3 = Color3.fromRGB(255,255,255),
			TextSize = self.comet.textsize,
			TextStrokeTransparency = 0,
			TextXAlignment = "Left",
			Parent = multiboxholder
		}
	)
	local dropdownbutton = utility.new(
		"TextButton",
		{
			AnchorPoint = Vector2.new(0,0),
			BackgroundTransparency = 1,
			Size = UDim2.new(1,0,1,0),
			Position = UDim2.new(0,0,0,0),
			Text = "",
			Parent = multiboxholder
		}
	)
	local optionsholder = utility.new(
		"Frame",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1,0,0,20),
			Position = UDim2.new(0,0,0,34),
			Visible = false,
			Parent = multiboxholder
		}
	)
	local size = #options
	size = math.clamp(size,1,max)
	local optionsoutline = utility.new(
		"ScrollingFrame",
		{
			BackgroundColor3 = Color3.fromRGB(56, 56, 56),
			BorderSizePixel = 0,
			Size = UDim2.new(1,0,size,2),
			Position = UDim2.new(0,0,0,0),
			ClipsDescendants = true,
			CanvasSize = UDim2.new(0,0,0,18*#options),
			ScrollBarImageTransparency = 0.25,
			ScrollBarImageColor3 = Color3.fromRGB(0,0,0),
			ScrollBarThickness = 5,
			VerticalScrollBarInset = "ScrollBar",
			VerticalScrollBarPosition = "Right",
			ZIndex = 5,
			Parent = optionsholder
		}
	)
	applyBorders(optionsoutline, {
		Enabled = borderCfg.border,
		Top = borderCfg.borderTop,
		Right = borderCfg.borderRight,
		Bottom = borderCfg.borderBottom,
		Left = borderCfg.borderLeft,
		Color = Color3.fromRGB(56,56,56),
		Thickness = borderCfg.borderThickness
	})
	utility.new(
		"UIListLayout",
		{
			FillDirection = "Vertical",
			Parent = optionsoutline
		}
	)
	multibox = {
		["comet"] = self.comet,
		["indicator"] = indicator,
		["optionsholder"] = optionsholder,
		["options"] = options,
		["value"] = value,
		["open"] = false,
		["titles"] = {},
		["current"] = def,
		["callback"] = callback
	}
	table.insert(multibox.comet.multiboxes,multibox)
	for i,v in pairs(options) do
		local ddoptionbutton = utility.new(
			"TextButton",
			{
				AnchorPoint = Vector2.new(0,0),
				BackgroundTransparency = 1,
				Size = UDim2.new(1,0,0,18),
				Text = "",
				ZIndex = 6,
				Parent = optionsoutline
			}
		)
		local ddoptiontitle = utility.new(
			"TextLabel",
			{
				AnchorPoint = Vector2.new(0.5,0),
				BackgroundTransparency = 1,
				Size = UDim2.new(1,-10,1,0),
				Position = UDim2.new(0.5,0,0,0),
				Font = self.comet.font,
				Text = v,
				TextWrapped=true,
				RichText = true,
				TextColor3 = Color3.fromRGB(255,255,255),
				TextSize = self.comet.textsize,
				TextStrokeTransparency = 0,
				TextXAlignment = "Left",
				ClipsDescendants = true,
				ZIndex = 6,
				Parent = ddoptionbutton
			}
		)
		self.comet.labels[#self.comet.labels+1] = ddoptiontitle
		table.insert(multibox.titles,ddoptiontitle)
		for c,b in pairs(def) do if v == b then ddoptiontitle.TextColor3 = self.comet.theme.accent end end
		ddoptionbutton.MouseButton1Down:Connect(function()
			local find = table.find(multibox.current,v)
			if find == nil then
				table.insert(multibox.current,v)
				local str = ""
				if #multibox.current > 1 then
					for i,vv in pairs(multibox.current) do
						if i == #multibox.current then
							str = str..vv
						else
							str = str..vv..", "
						end
					end
				else
					for i,vv in pairs(multibox.current) do
						str = str..vv
					end
				end
				value.Text = str
				ddoptiontitle.TextColor3 = self.comet.theme.accent
				table.insert(self.comet.themeitems["accent"]["TextColor3"],ddoptiontitle)
				multibox.callback(multibox.current)
			else
				table.remove(multibox.current,find)
				local str = ""
				if #multibox.current > 1 then
					for i,vv in pairs(multibox.current) do
						if i == #multibox.current then
							str = str..vv
						else
							str = str..vv..", "
						end
					end
				else
					for i,vv in pairs(multibox.current) do
						str = str..vv
					end
				end
				value.Text = str
				ddoptiontitle.TextColor3 = Color3.fromRGB(255,255,255)
				multibox.callback(multibox.current)
			end
		end)
	end
	dropdownbutton.MouseButton1Down:Connect(function()
		multibox.comet:closewindows(multibox)
		for i,v in pairs(multibox.titles) do
			if v.TextColor3 ~= Color3.fromRGB(255,255,255) then
				v.TextColor3 = self.comet.theme.accent
			end
		end
		optionsholder.Visible = not multibox.open
		multibox.open = not multibox.open
		if multibox.open then
			indicator.Text = "-"
		else
			indicator.Text = "+"
		end
	end)
	local pointer = props.pointer or props.Pointer or props.pointername or props.Pointername or props.PointerName or props.pointerName or nil
	if pointer then
		if self.pointers then
			self.pointers[tostring(pointer)] = multibox
		end
	end
	self.comet.labels[#self.comet.labels+1] = value
	self.comet.labels[#self.comet.labels+1] = title
	setmetatable(multibox, multiboxs)
	return multibox
end

function buttonboxs:set(value)
	if value ~= nil then
		local dropdown = self
		if table.find(dropdown.options,value) then
			self.current = tostring(value)
			self.callback(tostring(value))
		end
	end
end

function multiboxs:set(tbl)
	if tbl then
		local multibox = self
		if typeof(tbl) == "table" then
			multibox.current = {}
			for i,v in pairs(tbl) do
				if table.find(multibox.options,v) then
					table.insert(multibox.current,v)
				end
			end
			for i,v in pairs(multibox.titles) do
				if v.TextColor3 == multibox.comet.theme.accent then
					v.TextColor3 = Color3.fromRGB(255,255,255)
				end
				if table.find(tbl,v.Text) then
					v.TextColor3 = multibox.comet.theme.accent
				end
			end
			local str = ""
			if #multibox.current > 1 then
				for i,v in pairs(multibox.current) do
					if i == #multibox.current then
						str = str..v
					else
						str = str..v..", "
					end
				end
			else
				for i,v in pairs(multibox.current) do
					str = str..v
				end
			end
			multibox.value.Text = str
		end
	end
end

function sections:textbox(props)
	local name = props.name or props.Name or props.page or props.Page or props.pagename or props.Pagename or props.PageName or props.pageName or "new ui"
	local def = props.def or props.Def or props.default or props.Default or ""
	local placeholder = props.placeholder or props.Placeholder or props.placeHolder or props.PlaceHolder or props.placeholdertext or props.PlaceHolderText or props.PlaceHoldertext or props.placeHolderText or props.placeHoldertext or props.Placeholdertext or props.PlaceholderText or props.placeholderText or ""
	local callback = props.callback or props.callBack or props.CallBack or props.Callback or function()end
	local rounding = props.rounding or self.rounding
	local borderCfg = borderOptions(props, self.borders)
	local textbox = {}
	local textboxholder = utility.new(
		"Frame",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1,0,0,35),
			ZIndex = 2,
			Parent = self.content
		}
	)
	local outline = utility.new(
		"Frame",
		{
			BackgroundColor3 = Color3.fromRGB(24, 24, 24),
			Size = UDim2.new(1,0,0,20),
			Position = UDim2.new(0,0,0,15),
			Parent = textboxholder
		}
	)
	applyRounding(outline, rounding)
	applyBorders(outline, {
		Enabled = borderCfg.border,
		Top = borderCfg.borderTop,
		Right = borderCfg.borderRight,
		Bottom = borderCfg.borderBottom,
		Left = borderCfg.borderLeft,
		Color = Color3.fromRGB(12,12,12),
		Thickness = borderCfg.borderThickness
	})
	local outline2 = utility.new(
		"Frame",
		{
			BackgroundColor3 = Color3.fromRGB(24, 24, 24),
			Size = UDim2.new(1,0,1,0),
			Parent = outline
		}
	)
	applyRounding(outline2, rounding)
	applyBorders(outline2, {
		Enabled = borderCfg.border,
		Top = borderCfg.borderTop,
		Right = borderCfg.borderRight,
		Bottom = borderCfg.borderBottom,
		Left = borderCfg.borderLeft,
		Color = Color3.fromRGB(56,56,56),
		Thickness = borderCfg.borderThickness
	})
	local color = utility.new(
		"Frame",
		{
			BackgroundColor3 = Color3.fromRGB(30, 30, 30),
			BorderSizePixel = 0,
			Size = UDim2.new(1,0,1,0),
			Parent = outline2
		}
	)
	local gradient = utility.new(
		"UIGradient",
		{
			Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(199, 191, 204)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255))},
			Rotation = 90,
			Parent = color
		}
	)
	local button = utility.new(
		"TextButton",
		{
			AnchorPoint = Vector2.new(0,0),
			BackgroundTransparency = 1,
			Size = UDim2.new(1,0,1,0),
			Position = UDim2.new(0,0,0,0),
			Text = "",
			TextColor3 = Color3.fromRGB(255,255,255),
			TextSize = self.comet.textsize,
			TextStrokeTransparency = 0,
			Font = self.comet.font,
			Parent = textboxholder
		}
	)
	local title = utility.new(
		"TextLabel",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1,0,0,15),
			Position = UDim2.new(0,0,0,0),
			Font = self.comet.font,
			Text = name,
			RichText = true,
			TextWrapped=true,
			TextColor3 = Color3.fromRGB(255,255,255),
			TextSize = self.comet.textsize,
			TextStrokeTransparency = 0,
			TextXAlignment = "Left",
			Parent = textboxholder
		}
	)
	local tbox = utility.new(
		"TextBox",
		{
			AnchorPoint = Vector2.new(0.5,0),
			BackgroundTransparency = 1,
			Size = UDim2.new(1,-10,0,20),
			Position = UDim2.new(0.5,0,0,15),
			PlaceholderText = placeholder,
			Text = def,
			RichText = true,
			TextColor3 = Color3.fromRGB(255,255,255),
			TextSize = self.comet.textsize,
			TextStrokeTransparency = 0,
			TextTruncate = "AtEnd",
			Font = self.comet.font,
			Parent = textboxholder
		}
	)
	textbox = {
		["comet"] = self.comet,
		["tbox"] = tbox,
		["current"] = def,
		["callback"] = callback
	}
	button.MouseButton1Down:Connect(function()
		tbox:CaptureFocus()
	end)
	tbox.Focused:Connect(function()
		outline.BorderColor3 = self.comet.theme.accent
		table.insert(self.comet.themeitems["accent"]["BorderColor3"],outline)
	end)
	tbox.FocusLost:Connect(function(enterPressed)
		textbox.current = tbox.Text
		callback(tbox.Text)
		outline.BorderColor3 = Color3.fromRGB(12, 12, 12)
		local find = table.find(self.comet.themeitems["accent"]["BorderColor3"],outline)
		if find then
			table.remove(self.comet.themeitems["accent"]["BorderColor3"],find)
		end
	end)
	local pointer = props.pointer or props.Pointer or props.pointername or props.Pointername or props.PointerName or props.pointerName or nil
	if pointer then
		if self.pointers then
			self.pointers[tostring(pointer)] = textbox
		end
	end
	self.comet.labels[#self.comet.labels+1] = title
	self.comet.labels[#self.comet.labels+1] = tbox
	setmetatable(textbox, textboxs)
	return textbox
end

function textboxs:set(value)
	self.tbox.Text = value
	self.current = value
	self.callback(value)
end

function sections:keybind(props)
	local name = props.name or props.Name or props.page or props.Page or props.pagename or props.Pagename or props.PageName or props.pageName or "new ui"
	local def = props.def or props.Def or props.default or props.Default or nil
	local callback = props.callback or props.callBack or props.CallBack or props.Callback or function()end
	local allowed = props.allowed or props.Allowed or 1
	local rounding = props.rounding or self.rounding
	local borderCfg = borderOptions(props, self.borders)
	local default = ".."
	local typeis = nil
	if typeof(def) == "EnumItem" then
		if def == Enum.UserInputType.MouseButton1 then
			if allowed == 1 then
				default = "MB1"
				typeis = "UserInputType"
			end
		elseif def == Enum.UserInputType.MouseButton2 then
			if allowed == 1 then
				default = "MB2"
				typeis = "UserInputType"
			end
		elseif def == Enum.UserInputType.MouseButton3 then
			if allowed == 1 then
				default = "MB3"
				typeis = "UserInputType"
			end
		else
			local capd = utility.capatalize(def.Name)
			if #capd > 1 then
				default = capd
			else
				default = def.Name
			end
			typeis = "KeyCode"
		end
	end
	local keybind = {}
	local keybindholder = utility.new(
		"Frame",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1,0,0,17),
			Parent = self.content
		}
	)
	local outline = utility.new(
		"Frame",
		{
			AnchorPoint = Vector2.new(1,0),
			BackgroundColor3 = Color3.fromRGB(24, 24, 24),
			Size = UDim2.new(0,40,1,0),
			Position = UDim2.new(1,0,0,0),
			Parent = keybindholder
		}
	)
	applyRounding(outline, rounding)
	applyBorders(outline, {
		Enabled = borderCfg.border,
		Top = borderCfg.borderTop,
		Right = borderCfg.borderRight,
		Bottom = borderCfg.borderBottom,
		Left = borderCfg.borderLeft,
		Color = Color3.fromRGB(12,12,12),
		Thickness = borderCfg.borderThickness
	})
	local outline2 = utility.new(
		"Frame",
		{
			BackgroundColor3 = Color3.fromRGB(24, 24, 24),
			Size = UDim2.new(1,0,1,0),
			Position = UDim2.new(0,0,0,0),
			Parent = outline
		}
	)
	local value = utility.new(
		"TextLabel",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1,0,1,0),
			Position = UDim2.new(0,0,0,0),
			Font = self.comet.font,
			Text = default,
			RichText = true,
			TextWrapped=true,
			TextColor3 = Color3.fromRGB(255,255,255),
			TextSize = self.comet.textsize,
			TextStrokeTransparency = 0,
			TextXAlignment = "Center",
			Parent = outline
		}
	)
	outline.Size = UDim2.new(0,value.TextBounds.X+20,1,0)
	local color = utility.new(
		"Frame",
		{
			BackgroundColor3 = Color3.fromRGB(30, 30, 30),
			BorderSizePixel = 0,
			Size = UDim2.new(1,0,1,0),
			Position = UDim2.new(0,0,0,0),
			Parent = outline2
		}
	)
	utility.new(
		"UIGradient",
		{
			Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(199, 191, 204)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255))},
			Rotation = 90,
			Parent = color
		}
	)
	local button = utility.new(
		"TextButton",
		{
			AnchorPoint = Vector2.new(0,0),
			BackgroundTransparency = 1,
			Size = UDim2.new(1,0,1,0),
			Position = UDim2.new(0,0,0,0),
			Text = "",
			TextColor3 = Color3.fromRGB(255,255,255),
			TextSize = self.comet.textsize,
			TextStrokeTransparency = 0,
			Font = self.comet.font,
			Parent = keybindholder
		}
	)
	local title = utility.new(
		"TextLabel",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1,0,1,0),
			Position = UDim2.new(0,0,0,0),
			Font = self.comet.font,
			Text = name,
			RichText = true,
			TextWrapped=true,
			TextColor3 = Color3.fromRGB(255,255,255),
			TextSize = self.comet.textsize,
			TextStrokeTransparency = 0,
			TextXAlignment = "Left",
			Parent = keybindholder
		}
	)
	keybind = {
		["comet"] = self.comet,
		["down"] = false,
		["outline"] = outline,
		["value"] = value,
		["allowed"] = allowed,
		["current"] = {typeis,utility.splitenum(def)},
		["pressed"] = false,
		["callback"] = callback
	}
	button.MouseButton1Down:Connect(function()
		if keybind.down == false then
			outline.BorderColor3 = self.comet.theme.accent
			table.insert(self.comet.themeitems["accent"]["BorderColor3"],outline)
			wait()
			keybind.down = true
		end
	end)
	button.MouseButton2Down:Connect(function()
		keybind.down = false
		keybind.current = {nil,nil}
		outline.BorderColor3 = Color3.fromRGB(12, 12, 12)
		local find = table.find(self.comet.themeitems["accent"]["BorderColor3"],outline)
		if find then
			table.remove(self.comet.themeitems["accent"]["BorderColor3"],find)
		end
		value.Text = ".."
		outline.Size = UDim2.new(0,value.TextBounds.X+20,1,0)
	end)
	local function turn(typeis,current)
		outline.Size = UDim2.new(0,value.TextBounds.X+20,1,0)
		keybind.down = false
		keybind.current = {typeis,utility.splitenum(current)}
		outline.BorderColor3 = Color3.fromRGB(12, 12, 12)
		local find = table.find(self.comet.themeitems["accent"]["BorderColor3"],outline)
		if find then
			table.remove(self.comet.themeitems["accent"]["BorderColor3"],find)
		end
	end
	uis.InputBegan:Connect(function(Input)
		if keybind.down then
			if Input.UserInputType == Enum.UserInputType.Keyboard then
				local capd = utility.capatalize(Input.KeyCode.Name)
				if #capd > 1 then
					value.Text = capd
				else
					value.Text = Input.KeyCode.Name
				end
				turn("KeyCode",Input.KeyCode)
				callback(Input.KeyCode)
			end
			if allowed == 1 then
				if Input.UserInputType == Enum.UserInputType.MouseButton1 then
					value.Text = "MB1"
					turn("UserInputType",Input)
					callback(Input)
				elseif Input.UserInputType == Enum.UserInputType.MouseButton2 then
					value.Text = "MB2"
					turn("UserInputType",Input)
					callback(Input)
				elseif Input.UserInputType == Enum.UserInputType.MouseButton3 then
					value.Text = "MB3"
					turn("UserInputType",Input)
					callback(Input)
				end
			end
		end
	end)
	local pointer = props.pointer or props.Pointer or props.pointername or props.Pointername or props.PointerName or props.pointerName or nil
	if pointer then
		if self.pointers then
			self.pointers[tostring(pointer)] = keybind
		end
	end
	self.comet.labels[#self.comet.labels+1] = title
	self.comet.labels[#self.comet.labels+1] = value
	setmetatable(keybind, keybinds)
	return keybind
end

function keybinds:set(key)
	if key then
		if typeof(key) == "EnumItem" or typeof(key) == "table" then
			if typeof(key) == "table" then
				if key[1] and key[2] then
					key = Enum[key[1]][key[2]]
				else
					return
				end
			end
			local keybind = self
			local typeis = ""
			local default = ".."
			if key == Enum.UserInputType.MouseButton1 then
				if keybind.allowed == 1 then
					default = "MB1"
					typeis = "UserInputType"
				end
			elseif key == Enum.UserInputType.MouseButton2 then
				if keybind.allowed == 1 then
					default = "MB2"
					typeis = "UserInputType"
				end
			elseif key == Enum.UserInputType.MouseButton3 then
				if keybind.allowed == 1 then
					default = "MB3"
					typeis = "UserInputType"
				end
			else
				local capd = utility.capatalize(key.Name)
				if #capd > 1 then
					default = capd
				else
					default = key.Name
				end
				typeis = "KeyCode"
			end
			keybind.value.Text = default
			keybind.current = {typeis,utility.splitenum(key)}
			keybind.callback(keybind.current)
			keybind.outline.Size = UDim2.new(0,keybind.value.TextBounds.X+20,1,0)
			if keybind.down then
				keybind.down = false
				keybind.outline.BorderColor3 = Color3.fromRGB(12, 12, 12)
				local find = table.find(self.comet.themeitems["accent"]["BorderColor3"],keybind.outline)
				if find then
					table.remove(self.comet.themeitems["accent"]["BorderColor3"],find)
				end
			end
		end
	end
end

function sections:colorpicker(props)
	local name = props.name or props.Name or "new colorpicker"
	local cpname = props.cpname or props.Cpname or props.CPname or props.CPName or props.cPname or props.cpName or props.colorpickername or nil
	local def = props.def or props.Def or props.default or props.Default or Color3.fromRGB(255,255,255)
	local callback = props.callback or props.callBack or props.CallBack or props.Callback or function()end
	local rounding = props.rounding or self.rounding
	local borderCfg = borderOptions(props, self.borders)
	local h,s,v = def:ToHSV()
	local colorpicker = {}
	local colorpickerholder = utility.new(
		"Frame",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1,0,0,15),
			ZIndex = 2,
			Parent = self.content
		}
	)
	local outline = utility.new(
		"Frame",
		{
			AnchorPoint = Vector2.new(1,0),
			BackgroundColor3 = Color3.fromRGB(24, 24, 24),
			Size = UDim2.new(0,30,1,0),
			Position = UDim2.new(1,0,0,0),
			Parent = colorpickerholder
		}
	)
	applyRounding(outline, rounding)
	applyBorders(outline, {
		Enabled = borderCfg.border,
		Top = borderCfg.borderTop,
		Right = borderCfg.borderRight,
		Bottom = borderCfg.borderBottom,
		Left = borderCfg.borderLeft,
		Color = Color3.fromRGB(12,12,12),
		Thickness = borderCfg.borderThickness
	})
	local outline2 = utility.new(
		"Frame",
		{
			BackgroundColor3 = Color3.fromRGB(24, 24, 24),
			Size = UDim2.new(1,0,1,0),
			Parent = outline
		}
	)
	local cpcolor = utility.new(
		"Frame",
		{
			BackgroundColor3 = def,
			BorderSizePixel = 0,
			Size = UDim2.new(1,0,1,0),
			Parent = outline2
		}
	)
	utility.new(
		"UIGradient",
		{
			Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(199, 191, 204)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255))},
			Rotation = 90,
			Parent = cpcolor
		}
	)
	local title = utility.new(
		"TextLabel",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1,0,1,0),
			Position = UDim2.new(0,0,0,0),
			Font = self.comet.font,
			Text = name,
			RichText = true,
			TextWrapped=true,
			TextColor3 = Color3.fromRGB(255,255,255),
			TextSize = self.comet.textsize,
			TextStrokeTransparency = 0,
			TextXAlignment = "Left",
			Parent = colorpickerholder
		}
	)
	local button = utility.new(
		"TextButton",
		{
			AnchorPoint = Vector2.new(0,0),
			BackgroundTransparency = 1,
			Size = UDim2.new(1,0,1,0),
			Position = UDim2.new(0,0,0,0),
			Text = "",
			TextColor3 = Color3.fromRGB(255,255,255),
			TextSize = self.comet.textsize,
			TextStrokeTransparency = 0,
			Font = self.comet.font,
			Parent = colorpickerholder
		}
	)
	local cpholder = utility.new(
		"Frame",
		{
			AnchorPoint = Vector2.new(0,0),
			BackgroundColor3 = Color3.fromRGB(24, 24, 24),
			Size = UDim2.new(1,0,0,230),
			Position = UDim2.new(0,0,1,5),
			Visible = false,
			ZIndex = 5,
			Parent = colorpickerholder
		}
	)
	applyRounding(cpholder, rounding)
	applyBorders(cpholder, {
		Enabled = borderCfg.border,
		Top = borderCfg.borderTop,
		Right = borderCfg.borderRight,
		Bottom = borderCfg.borderBottom,
		Left = borderCfg.borderLeft,
		Color = Color3.fromRGB(12,12,12),
		Thickness = borderCfg.borderThickness
	})
	local outline2c = utility.new(
		"Frame",
		{
			BackgroundColor3 = Color3.fromRGB(24, 24, 24),
			Size = UDim2.new(1,0,1,0),
			ZIndex = 5,
			Parent = cpholder
		}
	)
	applyBorders(outline2c, {
		Enabled = borderCfg.border,
		Top = borderCfg.borderTop,
		Right = borderCfg.borderRight,
		Bottom = borderCfg.borderBottom,
		Left = borderCfg.borderLeft,
		Color = Color3.fromRGB(56,56,56),
		Thickness = borderCfg.borderThickness
	})
	local colorTop = utility.new(
		"Frame",
		{
			AnchorPoint = Vector2.new(0.5,0),
			BackgroundColor3 = self.comet.theme.accent,
			BorderSizePixel = 0,
			Size = UDim2.new(1,-2,0,1),
			Position = UDim2.new(0.5,0,0,0),
			ZIndex = 5,
			Parent = outline2c
		}
	)
	table.insert(self.comet.themeitems["accent"]["BackgroundColor3"],colorTop)
	local cptitle = utility.new(
		"TextLabel",
		{
			AnchorPoint = Vector2.new(0.5,0),
			BackgroundTransparency = 1,
			Size = UDim2.new(1,-10,0,20),
			Position = UDim2.new(0.5,0,0,0),
			Font = self.comet.font,
			Text = cpname or name,
			RichText = true,
			TextWrapped=true,
			TextColor3 = Color3.fromRGB(255,255,255),
			TextSize = self.comet.textsize,
			TextStrokeTransparency = 0,
			TextXAlignment = "Left",
			ZIndex = 5,
			Parent = outline2c
		}
	)
	local cpholder2 = utility.new(
		"Frame",
		{
			AnchorPoint = Vector2.new(0,0),
			BackgroundColor3 = Color3.fromRGB(24, 24, 24),
			Size = UDim2.new(0.875,0,0,150),
			Position = UDim2.new(0,5,0,20),
			ZIndex = 5,
			Parent = outline2c
		}
	)
	local outline3 = utility.new(
		"Frame",
		{
			BackgroundColor3 = Color3.fromHSV(h,1,1),
			Size = UDim2.new(1,0,1,0),
			ZIndex = 5,
			Parent = cpholder2
		}
	)
	applyBorders(outline3, {
		Enabled = borderCfg.border,
		Top = borderCfg.borderTop,
		Right = borderCfg.borderRight,
		Bottom = borderCfg.borderBottom,
		Left = borderCfg.borderLeft,
		Color = Color3.fromRGB(56,56,56),
		Thickness = borderCfg.borderThickness
	})
	local cpimage = utility.new(
		"ImageButton",
		{
			AutoButtonColor = false,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1,0,1,0),
			ZIndex = 5,
			Image = "rbxassetid://7074305282",
			Parent = outline3
		}
	)
	local cpcursor = utility.new(
		"ImageLabel",
		{
			AnchorPoint = Vector2.new(0.5,0.5),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(0,6,0,6),
			Position = UDim2.new(s,0,1-v,0),
			ZIndex = 5,
			Image = "rbxassetid://7074391319",
			Parent = cpimage
		}
	)
	local huepicker = utility.new(
		"Frame",
		{
			AnchorPoint = Vector2.new(1,0),
			BackgroundColor3 = Color3.fromRGB(24, 24, 24),
			Size = UDim2.new(0.05,0,0,150),
			Position = UDim2.new(1,-5,0,20),
			ZIndex = 5,
			Parent = outline2c
		}
	)
	applyBorders(huepicker, {
		Enabled = borderCfg.border,
		Top = borderCfg.borderTop,
		Right = borderCfg.borderRight,
		Bottom = borderCfg.borderBottom,
		Left = borderCfg.borderLeft,
		Color = Color3.fromRGB(12,12,12),
		Thickness = borderCfg.borderThickness
	})
	local outline4 = utility.new(
		"Frame",
		{
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			Size = UDim2.new(1,0,1,0),
			ZIndex = 5,
			Parent = huepicker
		}
	)
	applyBorders(outline4, {
		Enabled = borderCfg.border,
		Top = borderCfg.borderTop,
		Right = borderCfg.borderRight,
		Bottom = borderCfg.borderBottom,
		Left = borderCfg.borderLeft,
		Color = Color3.fromRGB(56,56,56),
		Thickness = borderCfg.borderThickness
	})
	local huebutton = utility.new(
		"TextButton",
		{
			AnchorPoint = Vector2.new(0,0),
			BackgroundTransparency = 1,
			Size = UDim2.new(1,0,1,0),
			Position = UDim2.new(0,0,0,0),
			Text = "",
			TextColor3 = Color3.fromRGB(255,255,255),
			TextSize = self.comet.textsize,
			TextStrokeTransparency = 0,
			Font = self.comet.font,
			ZIndex = 5,
			Parent = huepicker
		}
	)
	utility.new(
		"UIGradient",
		{
			Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 4)), ColorSequenceKeypoint.new(0.10, Color3.fromRGB(255, 153, 0)), ColorSequenceKeypoint.new(0.20, Color3.fromRGB(209, 255, 0)), ColorSequenceKeypoint.new(0.30, Color3.fromRGB(55, 255, 0)), ColorSequenceKeypoint.new(0.40, Color3.fromRGB(0, 255, 102)), ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 255)), ColorSequenceKeypoint.new(0.60, Color3.fromRGB(0, 102, 255)), ColorSequenceKeypoint.new(0.70, Color3.fromRGB(51, 0, 255)), ColorSequenceKeypoint.new(0.80, Color3.fromRGB(204, 0, 255)), ColorSequenceKeypoint.new(0.90, Color3.fromRGB(255, 0, 153)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 4))},
			Rotation = 90,
			Parent = outline4
		}
	)
	local huecursor = utility.new(
		"Frame",
		{
			AnchorPoint = Vector2.new(0.5,0.5),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			Size = UDim2.new(0,12,0,6),
			Position = UDim2.new(0.5,0,h,0),
			ZIndex = 5,
			Parent = outline4
		}
	)
	applyBorders(huecursor, {
		Enabled = true,
		Top = true,
		Right = true,
		Bottom = true,
		Left = true,
		Color = Color3.fromRGB(12,12,12),
		Thickness = 1
	})
	local huecursor_inline = utility.new(
		"Frame",
		{
			BackgroundColor3 = Color3.fromHSV(h,1,1),
			Size = UDim2.new(1,0,1,0),
			Position = UDim2.new(0,0,0,0),
			ZIndex = 5,
			Parent = huecursor
		}
	)
	local function textbox(parent,size,position)
		local textbox_holder = utility.new(
			"Frame",
			{
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Position = position,
				Size = size,
				ZIndex = 5,
				Parent = parent
			}
		)
		local outline5 = utility.new(
			"Frame",
			{
				BackgroundColor3 = Color3.fromRGB(24, 24, 24),
				Position = UDim2.new(0,0,0,0),
				Size = UDim2.new(1,0,1,0),
				ZIndex = 5,
				Parent = textbox_holder
			}
		)
		applyRounding(outline5, rounding)
		applyBorders(outline5, {
			Enabled = borderCfg.border,
			Top = borderCfg.borderTop,
			Right = borderCfg.borderRight,
			Bottom = borderCfg.borderBottom,
			Left = borderCfg.borderLeft,
			Color = Color3.fromRGB(12,12,12),
			Thickness = borderCfg.borderThickness
		})
		local outline6 = utility.new(
			"Frame",
			{
				BackgroundColor3 = Color3.fromRGB(24, 24, 24),
				Position = UDim2.new(0,0,0,0),
				Size = UDim2.new(1,0,1,0),
				ZIndex = 5,
				Parent = outline5
			}
		)
		applyBorders(outline6, {
			Enabled = borderCfg.border,
			Top = borderCfg.borderTop,
			Right = borderCfg.borderRight,
			Bottom = borderCfg.borderBottom,
			Left = borderCfg.borderLeft,
			Color = Color3.fromRGB(56,56,56),
			Thickness = borderCfg.borderThickness
		})
		local color2 = utility.new(
			"Frame",
			{
				AnchorPoint = Vector2.new(0,0),
				BackgroundColor3 = Color3.fromRGB(30, 30, 30),
				BorderSizePixel = 0,
				Size = UDim2.new(1,0,0,0),
				Position = UDim2.new(0,0,0,0),
				ZIndex = 5,
				Parent = outline6
			}
		)
		utility.new(
			"UIGradient",
			{
				Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(199, 191, 204)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255))},
				Rotation = 90,
				Parent = color2
			}
		)
		local tbox = utility.new(
			"TextBox",
			{
				AnchorPoint = Vector2.new(0.5,0),
				BackgroundTransparency = 1,
				Size = UDim2.new(1,0,1,0),
				Position = UDim2.new(0.5,0,0,0),
				PlaceholderColor3 = Color3.fromRGB(255,255,255),
				PlaceholderText = "",
				Text = "",
				RichText = true,
				TextColor3 = Color3.fromRGB(255,255,255),
				TextSize = self.comet.textsize,
				TextStrokeTransparency = 0,
				Font = self.comet.font,
				ZIndex = 5,
				Parent = textbox_holder
			}
		)
		local tbox_button = utility.new(
			"TextButton",
			{
				AnchorPoint = Vector2.new(0,0),
				BackgroundTransparency = 1,
				Size = UDim2.new(1,0,1,0),
				Position = UDim2.new(0,0,0,0),
				Text = "",
				TextColor3 = Color3.fromRGB(255,255,255),
				TextSize = self.comet.textsize,
				TextStrokeTransparency = 0,
				Font = self.comet.font,
				ZIndex = 5,
				Parent = textbox_holder
			}
		)
		tbox_button.MouseButton1Down:Connect(function()
			tbox:CaptureFocus()
		end)
		return {textbox_holder,tbox,outline5}
	end
	local red = textbox(outline2c,UDim2.new(0,62,0,20),UDim2.new(0,5,0,175))
	local green = textbox(outline2c,UDim2.new(0,62,0,20),UDim2.new(0,5,0,175))
	green[1].AnchorPoint = Vector2.new(0.5,0)
	green[1].Position = UDim2.new(0.5,0,0,175)
	local blue = textbox(outline2c,UDim2.new(0,62,0,20),UDim2.new(0,5,0,175))
	blue[1].AnchorPoint = Vector2.new(1,0)
	blue[1].Position = UDim2.new(1,-5,0,175)
	local hex = textbox(outline2c,UDim2.new(1,-10,0,20),UDim2.new(0,5,0,200))
	hex[2].Size = UDim2.new(1,-12,1,0)
	hex[2].TextXAlignment = "Left"
	colorpicker = {
		["comet"] = self.comet,
		["cpholder"] = cpholder,
		["cpcolor"] = cpcolor,
		["huecursor"] = huecursor,
		["outline3"] = outline3,
		["huecursor_inline"] = huecursor_inline,
		["cpcursor"] = cpcursor,
		["current"] = def,
		["open"] = false,
		["cp"] = false,
		["hue"] = false,
		["hsv"] = {h,s,v},
		["red"] = red[2],
		["green"] = green[2],
		["blue"] = blue[2],
		["hex"] = hex[2],
		["callback"] = callback
	}
	table.insert(self.comet.colorpickers,colorpicker)
	local function updateboxes()
		colorpicker.red.PlaceholderText = "R: "..tostring(math.floor(colorpicker.current.R*255))
		colorpicker.green.PlaceholderText = "G: "..tostring(math.floor(colorpicker.current.G*255))
		colorpicker.blue.PlaceholderText = "B: "..tostring(math.floor(colorpicker.current.B*255))
		colorpicker.hex.PlaceholderText = "Hex: "..utility.to_hex(colorpicker.current)
	end
	updateboxes()
	local function movehue()
		local posy = math.clamp(plr:GetMouse().Y-outline3.AbsolutePosition.Y,0,outline3.AbsoluteSize.Y)
		local resy = (1/outline3.AbsoluteSize.Y)*posy
		outline3.BackgroundColor3 = Color3.fromHSV(resy,1,1)
		huecursor_inline.BackgroundColor3 = Color3.fromHSV(resy,1,1)
		colorpicker.hsv[1] = resy
		colorpicker.current = Color3.fromHSV(colorpicker.hsv[1],colorpicker.hsv[2],colorpicker.hsv[3])
		cpcolor.BackgroundColor3 = colorpicker.current
		updateboxes()
		colorpicker.callback(colorpicker.current)
		huecursor:TweenPosition(UDim2.new(0.5,0,resy,0),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.15,true)
	end
	local function movecp()
		local posx,posy = math.clamp(plr:GetMouse().X-outline3.AbsolutePosition.X,0,outline3.AbsoluteSize.X),math.clamp(plr:GetMouse().Y-outline3.AbsolutePosition.Y,0,outline3.AbsoluteSize.Y)
		local resx,resy = (1/outline3.AbsoluteSize.X)*posx,(1/outline3.AbsoluteSize.Y)*posy
		colorpicker.hsv[2] = resx
		colorpicker.hsv[3] = 1-resy
		colorpicker.current = Color3.fromHSV(colorpicker.hsv[1],colorpicker.hsv[2],colorpicker.hsv[3])
		cpcolor.BackgroundColor3 = colorpicker.current
		updateboxes()
		colorpicker.callback(colorpicker.current)
		cpcursor:TweenPosition(UDim2.new(resx,0,resy,0),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.15,true)
	end
	button.MouseButton1Down:Connect(function()
		self.comet:closewindows(colorpicker)
		cpholder.Visible = not colorpicker.open
		colorpicker.open = not colorpicker.open
	end)
	huebutton.MouseButton1Down:Connect(function()
		colorpicker.hue = true
		movehue()
	end)
	cpimage.MouseButton1Down:Connect(function()
		colorpicker.cp = true
		movecp()
	end)
	uis.InputChanged:Connect(function()
		if colorpicker.cp then
			movecp()
		end
		if colorpicker.hue then
			movehue()
		end
	end)
	uis.InputEnded:Connect(function(Input)
		if Input.UserInputType.Name == 'MouseButton1'  then
			if colorpicker.cp then
				colorpicker.cp = false
			end
			if colorpicker.hue then
				colorpicker.hue = false
			end
		end
	end)
	red[2].Focused:Connect(function()
		red[3].BorderColor3 = self.comet.theme.accent
	end)
	red[2].FocusLost:Connect(function()
		local saved = red[2].Text
		local num = tonumber(saved)
		if num then
			saved = tostring(math.clamp(tonumber(saved),0,255))
			red[2].Text = ""
			if saved then
				if #saved >= 1 and #saved <= 3 then
					red[2].PlaceholderText = "R: "..tostring(saved)
				end
				colorpicker:set(Color3.fromRGB(tonumber(saved),colorpicker.current.G*255,colorpicker.current.B*255))
				red[3].BorderColor3 = Color3.fromRGB(12,12,12)
			else
				red[3].BorderColor3 = Color3.fromRGB(12,12,12)
			end
		else
			red[2].Text = ""
			red[3].BorderColor3 = Color3.fromRGB(12,12,12)
		end
	end)
	green[2].Focused:Connect(function()
		green[3].BorderColor3 = self.comet.theme.accent
	end)
	green[2].FocusLost:Connect(function()
		local saved = green[2].Text
		local num = tonumber(saved)
		if num then
			saved = tostring(math.clamp(tonumber(saved),0,255))
			green[2].Text = ""
			if saved then
				if #saved >= 1 and #saved <= 3 then
					green[2].PlaceholderText = "G: "..tostring(saved)
				end
				colorpicker:set(Color3.fromRGB(colorpicker.current.R*255,tonumber(saved),colorpicker.current.B*255))
				green[3].BorderColor3 = Color3.fromRGB(12,12,12)
			else
				green[3].BorderColor3 = Color3.fromRGB(12,12,12)
			end
		else
			green[2].Text = ""
			green[3].BorderColor3 = Color3.fromRGB(12,12,12)
		end
	end)
	blue[2].Focused:Connect(function()
		blue[3].BorderColor3 = self.comet.theme.accent
	end)
	blue[2].FocusLost:Connect(function()
		local saved = blue[2].Text
		local num = tonumber(saved)
		if num then
			saved = tostring(math.clamp(tonumber(saved),0,255))
			blue[2].Text = ""
			if saved then
				if #saved >= 1 and #saved <= 3 then
					blue[2].PlaceholderText = "B: "..tostring(saved)
				end
				colorpicker:set(Color3.fromRGB(colorpicker.current.R*255,colorpicker.current.G*255,tonumber(saved)))
				blue[3].BorderColor3 = Color3.fromRGB(12,12,12)
			else
				blue[3].BorderColor3 = Color3.fromRGB(12,12,12)
			end
		else
			blue[2].Text = ""
			blue[3].BorderColor3 = Color3.fromRGB(12,12,12)
		end
	end)
	hex[2].Focused:Connect(function()
		hex[3].BorderColor3 = self.comet.theme.accent
	end)
	hex[2].FocusLost:Connect(function()
		local saved = hex[2].Text
		if #saved >= 6 and #saved <= 7 then
			local e,sr = pcall(function()
				utility.from_hex(saved)
			end)
			if e == true then
				local hexcolor = utility.from_hex(saved)
				if hexcolor then
					colorpicker:set(hexcolor)
					hex[2].Text = ""
					hex[3].BorderColor3 = Color3.fromRGB(12,12,12)
				else
					hex[2].Text = ""
					hex[3].BorderColor3 = Color3.fromRGB(12,12,12)
				end
			else
				hex[2].Text = ""
				hex[3].BorderColor3 = Color3.fromRGB(12,12,12)
			end
		else
			hex[2].Text = ""
			hex[3].BorderColor3 = Color3.fromRGB(12,12,12)
		end
	end)
	local pointer = props.pointer or props.Pointer or props.pointername or props.Pointername or props.PointerName or props.pointerName or nil
	if pointer then
		if self.pointers then
			self.pointers[tostring(pointer)] = colorpicker
		end
	end
	self.comet.labels[#self.comet.labels+1] = title
	self.comet.labels[#self.comet.labels+1] = hex[2]
	self.comet.labels[#self.comet.labels+1] = red[2]
	self.comet.labels[#self.comet.labels+1] = green[2]
	self.comet.labels[#self.comet.labels+1] = blue[2]
	self.comet.labels[#self.comet.labels+1] = cptitle
	setmetatable(colorpicker, colorpickers)
	return colorpicker
end

function sections:selection(props)
	local title = props.title or props.Title or "selection"
	local height = props.height or props.Height or 222
	local textboxPlaceholder = props.placeholder or props.Placeholder or "Item Name"
	local rounding = props.rounding or self.rounding
	local borderCfg = borderOptions(props, self.borders)
	local selection = {}
	local items = {}
	local buttons = {}
	local createdItems = {}
	local selected = nil
	local holder = utility.new(
		"Frame",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, height),
			Parent = self.content
		}
	)
	if not self.content:FindFirstChildOfClass("UIListLayout") then
		utility.new(
			"UIListLayout",
			{
				FillDirection = "Vertical",
				Padding = UDim.new(0, 6),
				Parent = self.content
			}
		)
	end
	local outline = utility.new(
		"Frame",
		{
			BackgroundColor3 = Color3.fromRGB(24, 24, 24),
			Size = UDim2.new(1, 0, 1, 0),
			Parent = holder
		}
	)
	applyRounding(outline, rounding)
	applyBorders(outline, {
		Enabled = borderCfg.border,
		Top = borderCfg.borderTop,
		Right = borderCfg.borderRight,
		Bottom = borderCfg.borderBottom,
		Left = borderCfg.borderLeft,
		Color = Color3.fromRGB(12,12,12),
		Thickness = borderCfg.borderThickness
	})
	local outline2 = utility.new(
		"Frame",
		{
			BackgroundColor3 = Color3.fromRGB(24, 24, 24),
			Size = UDim2.new(1, 0, 1, 0),
			Parent = outline
		}
	)
	applyBorders(outline2, {
		Enabled = borderCfg.border,
		Top = borderCfg.borderTop,
		Right = borderCfg.borderRight,
		Bottom = borderCfg.borderBottom,
		Left = borderCfg.borderLeft,
		Color = Color3.fromRGB(56,56,56),
		Thickness = borderCfg.borderThickness
	})
	local titleLabel = utility.new(
		"TextLabel",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 15),
			Position = UDim2.new(0, 0, 0, 3),
			Font = self.comet.font,
			Text = title,
			RichText = true,
			TextWrapped=true,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextSize = self.comet.textsize,
			TextStrokeTransparency = 0,
			TextXAlignment = "Center",
			Parent = outline
		}
	)
	self.comet.labels[#self.comet.labels + 1] = titleLabel
	local color = utility.new(
		"Frame",
		{
			AnchorPoint = Vector2.new(0.5, 0),
			BackgroundColor3 = self.comet.theme.accent,
			Size = UDim2.new(1, -6, 0, 1),
			Position = UDim2.new(0.5, 0, 0, 19),
			Parent = outline
		}
	)
	table.insert(self.comet.themeitems["accent"]["BackgroundColor3"], color)
	local itemsHolder = utility.new(
		"Frame",
		{
			AnchorPoint = Vector2.new(0.5, 0),
			BackgroundColor3 = Color3.fromRGB(24, 24, 24),
			Size = UDim2.new(1, -10, 1, -25),
			Position = UDim2.new(0.5, 0, 0, 25),
			Parent = outline
		}
	)
	applyRounding(itemsHolder, rounding)
	applyBorders(itemsHolder, {
		Enabled = borderCfg.border,
		Top = borderCfg.borderTop,
		Right = borderCfg.borderRight,
		Bottom = borderCfg.borderBottom,
		Left = borderCfg.borderLeft,
		Color = Color3.fromRGB(12,12,12),
		Thickness = borderCfg.borderThickness
	})
	local outline3 = utility.new(
		"Frame",
		{
			BackgroundColor3 = Color3.fromRGB(24, 24, 24),
			Size = UDim2.new(1, 0, 1, 0),
			Parent = itemsHolder
		}
	)
	applyBorders(outline3, {
		Enabled = borderCfg.border,
		Top = borderCfg.borderTop,
		Right = borderCfg.borderRight,
		Bottom = borderCfg.borderBottom,
		Left = borderCfg.borderLeft,
		Color = Color3.fromRGB(56,56,56),
		Thickness = borderCfg.borderThickness
	})
	local buttonAreaHeight = 0
	local updateButtonArea
	local buttonArea = utility.new(
		"Frame",
		{
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, buttonAreaHeight),
			Position = UDim2.new(0, 5, 1, -5),
			AnchorPoint = Vector2.new(0, 1),
			Parent = outline3
		}
	)
	utility.new(
		"UIListLayout",
		{
			FillDirection = "Vertical",
			Padding = UDim.new(0, 2),
			Parent = buttonArea
		}
	)
	local scrollFrame = utility.new(
		"ScrollingFrame",
		{
			BackgroundColor3 = Color3.fromRGB(56, 56, 56),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, -10, 1, -buttonAreaHeight - 7),
			Position = UDim2.new(0, 5, 0, 5),
			ClipsDescendants = true,
			AutomaticCanvasSize = "Y",
			CanvasSize = UDim2.new(0, 0, 0, 0),
			ScrollBarImageTransparency = 0.25,
			ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0),
			ScrollBarThickness = 5,
			VerticalScrollBarInset = "ScrollBar",
			VerticalScrollBarPosition = "Right",
			Parent = outline3
		}
	)
	utility.new(
		"UIListLayout",
		{
			FillDirection = "Vertical",
			Padding = UDim.new(0, 0),
			Parent = scrollFrame
		}
	)
	updateButtonArea = function()
		buttonAreaHeight = (#buttons * 22) + (math.max(0, #buttons - 1) * 2)
		buttonArea.Size = UDim2.new(1, -10, 0, buttonAreaHeight)
		scrollFrame.Size = UDim2.new(1, -10, 1, -buttonAreaHeight - 12)
	end
	local function createItemUI(namei, metadata)
		local itemButton = utility.new(
			"TextButton",
			{
				AnchorPoint = Vector2.new(0, 0),
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 18),
				Position = UDim2.new(0, 0, 0, 0),
				Text = "",
				Parent = scrollFrame
			}
		)
		local grey = utility.new(
			"Frame",
			{
				AnchorPoint = Vector2.new(0.5, 0),
				BackgroundColor3 = Color3.fromRGB(125, 125, 125),
				BackgroundTransparency = 0.9,
				BorderSizePixel = 0,
				Size = UDim2.new(1, -4, 1, 0),
				Position = UDim2.new(0.5, 0, 0, 0),
				Visible = false,
				Parent = itemButton
			}
		)
		local itemTitle = utility.new(
			"TextLabel",
			{
				AnchorPoint = Vector2.new(0.5, 0),
				BackgroundTransparency = 1,
				Size = UDim2.new(1, -10, 1, 0),
				Position = UDim2.new(0.5, 0, 0, 0),
				Font = self.comet.font,
				Text = namei,
				RichText = true,
				TextWrapped=true,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextSize = self.comet.textsize,
				TextStrokeTransparency = 0,
				TextXAlignment = "Left",
				Parent = itemButton
			}
		)
		self.comet.labels[#self.comet.labels + 1] = itemTitle
		local item = {
			button = itemButton,
			grey = grey,
			title = itemTitle,
			name = namei,
			metadata = metadata
		}
		table.insert(createdItems, item)
		itemButton.MouseButton1Down:Connect(function()
			for i, v in pairs(createdItems) do
				if v ~= item then
					v.grey.Visible = false
					v.title.TextColor3 = Color3.fromRGB(255, 255, 255)
					local find = table.find(self.comet.themeitems["accent"]["TextColor3"], v.title)
					if find then
						table.remove(self.comet.themeitems["accent"]["TextColor3"], find)
					end
				end
			end
			item.grey.Visible = true
			item.title.TextColor3 = self.comet.theme.accent
			table.insert(self.comet.themeitems["accent"]["TextColor3"], item.title)
			selected = item
		end)
		return item
	end
	local function createButton(propsb)
		local btnName = propsb.name or propsb.Name or "Button"
		local callback = propsb.callback or propsb.Callback or function() end
		local btnHolder = utility.new(
			"Frame",
			{
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, -10, 0, 20),
				ZIndex = 5,
				Parent = buttonArea
			}
		)
		local btnOutline = utility.new(
			"Frame",
			{
				BackgroundColor3 = Color3.fromRGB(24, 24, 24),
				Position = UDim2.new(0.5, 0, 0, 0),
				AnchorPoint = Vector2.new(0.5, 0),
				Size = UDim2.new(1, 0, 1, 0),
				ZIndex = 5,
				Parent = btnHolder
			}
		)
		applyRounding(btnOutline, rounding)
		applyBorders(btnOutline, {
			Enabled = borderCfg.border,
			Top = borderCfg.borderTop,
			Right = borderCfg.borderRight,
			Bottom = borderCfg.borderBottom,
			Left = borderCfg.borderLeft,
			Color = Color3.fromRGB(12,12,12),
			Thickness = borderCfg.borderThickness
		})
		local btnOutline2 = utility.new(
			"Frame",
			{
				BackgroundColor3 = Color3.fromRGB(24, 24, 24),
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(1, 0, 1, 0),
				ZIndex = 5,
				Parent = btnOutline
			}
		)
		applyBorders(btnOutline2, {
			Enabled = borderCfg.border,
			Top = borderCfg.borderTop,
			Right = borderCfg.borderRight,
			Bottom = borderCfg.borderBottom,
			Left = borderCfg.borderLeft,
			Color = Color3.fromRGB(56,56,56),
			Thickness = borderCfg.borderThickness
		})
		local btnColor = utility.new(
			"Frame",
			{
				AnchorPoint = Vector2.new(0, 0),
				BackgroundColor3 = Color3.fromRGB(30, 30, 30),
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 0),
				Position = UDim2.new(0, 0, 0, 0),
				ZIndex = 5,
				Parent = btnOutline2
			}
		)
		utility.new(
			"UIGradient",
			{
				Color = ColorSequence.new{
					ColorSequenceKeypoint.new(0.00, Color3.fromRGB(199, 191, 204)),
					ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255))
				},
				Rotation = 90,
				Parent = btnColor
			}
		)
		local btnButton = utility.new(
			"TextButton",
			{
				AnchorPoint = Vector2.new(0, 0),
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				Position = UDim2.new(0, 0, 0, 0),
				Text = btnName,
				RichText = true,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextSize = self.comet.textsize,
				TextStrokeTransparency = 0,
				Font = self.comet.font,
				ZIndex = 5,
				Parent = btnHolder
			}
		)
		self.comet.labels[#self.comet.labels + 1] = btnButton
		btnButton.MouseButton1Click:Connect(function()
			btnOutline.BorderColor3 = self.comet.theme.accent
			wait(0.05)
			btnOutline.BorderColor3 = Color3.fromRGB(12, 12, 12)
			if selected then
				callback(selected.name, selected.metadata)
			end
		end)
		return {
			holder = btnHolder,
			outline = btnOutline,
			button = btnButton,
			remove = function()
				btnHolder:Remove()
				local index = table.find(buttons, btnHolder)
				if index then
					table.remove(buttons, index)
					updateButtonArea()
				end
			end
		}
	end
	function selection:add(namei, metadata)
		if not items[namei] then
			items[namei] = metadata or {}
			createItemUI(namei, items[namei])
		end
	end
	function selection:remove(namei)
		if items[namei] then
			items[namei] = nil
			for i, v in pairs(createdItems) do
				if v.name == namei then
					if selected == v then
						selected = nil
					end
					v.button:Remove()
					table.remove(createdItems, i)
					break
				end
			end
		end
	end
	function selection:get(namei)
		return items[namei]
	end
	function selection:getSelected()
		if selected then
			return selected.name, selected.metadata
		end
		return nil, nil
	end
	function selection:clear()
		for i, v in pairs(createdItems) do
			v.button:Remove()
		end
		createdItems = {}
		items = {}
		selected = nil
	end
	function selection:addButton(propsb)
		local btn = createButton(propsb)
		table.insert(buttons, btn.holder)
		updateButtonArea()
		return btn
	end
	function selection:addTextbox(propsb)
		local placeholder = propsb.placeholder or propsb.Placeholder or textboxPlaceholder
		local callback = propsb.callback or propsb.Callback or function() end
		local tboxHolder = utility.new(
			"Frame",
			{
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, -10, 0, 20),
				ZIndex = 5,
				Parent = buttonArea
			}
		)
		local outline5 = utility.new(
			"Frame",
			{
				BackgroundColor3 = Color3.fromRGB(24, 24, 24),
				Position = UDim2.new(0.5, 0, 0, 0),
				AnchorPoint = Vector2.new(0.5, 0),
				Size = UDim2.new(1, 0, 1, 0),
				ZIndex = 5,
				Parent = tboxHolder
			}
		)
		applyRounding(outline5, rounding)
		applyBorders(outline5, {
			Enabled = borderCfg.border,
			Top = borderCfg.borderTop,
			Right = borderCfg.borderRight,
			Bottom = borderCfg.borderBottom,
			Left = borderCfg.borderLeft,
			Color = Color3.fromRGB(12,12,12),
			Thickness = borderCfg.borderThickness
		})
		local outline6 = utility.new(
			"Frame",
			{
				BackgroundColor3 = Color3.fromRGB(24, 24, 24),
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(1, 0, 1, 0),
				ZIndex = 5,
				Parent = outline5
			}
		)
		applyBorders(outline6, {
			Enabled = borderCfg.border,
			Top = borderCfg.borderTop,
			Right = borderCfg.borderRight,
			Bottom = borderCfg.borderBottom,
			Left = borderCfg.borderLeft,
			Color = Color3.fromRGB(56,56,56),
			Thickness = borderCfg.borderThickness
		})
		local color2 = utility.new(
			"Frame",
			{
				AnchorPoint = Vector2.new(0, 0),
				BackgroundColor3 = Color3.fromRGB(30, 30, 30),
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 0),
				Position = UDim2.new(0, 0, 0, 0),
				ZIndex = 5,
				Parent = outline6
			}
		)
		utility.new(
			"UIGradient",
			{
				Color = ColorSequence.new{
					ColorSequenceKeypoint.new(0.00, Color3.fromRGB(199, 191, 204)),
					ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255))
				},
				Rotation = 90,
				Parent = color2
			}
		)
		local tbox = utility.new(
			"TextBox",
			{
				AnchorPoint = Vector2.new(0.5, 0),
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				Position = UDim2.new(0.5, 0, 0, 0),
				PlaceholderColor3 = Color3.fromRGB(178, 178, 178),
				PlaceholderText = placeholder,
				Text = "",
				RichText = true,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextSize = self.comet.textsize,
				TextStrokeTransparency = 0,
				Font = self.comet.font,
				ZIndex = 5,
				Parent = tboxHolder
			}
		)
		local tboxButton = utility.new(
			"TextButton",
			{
				AnchorPoint = Vector2.new(0, 0),
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				Position = UDim2.new(0, 0, 0, 0),
				Text = "",
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextSize = self.comet.textsize,
				TextStrokeTransparency = 0,
				Font = self.comet.font,
				ZIndex = 5,
				Parent = tboxHolder
			}
		)
		tboxButton.MouseButton1Down:Connect(function()
			tbox:CaptureFocus()
		end)
		tbox.Focused:Connect(function()
			outline5.BorderColor3 = self.comet.theme.accent
		end)
		tbox.FocusLost:Connect(function()
			outline5.BorderColor3 = Color3.fromRGB(12, 12, 12)
			callback(tbox.Text)
		end)
		table.insert(buttons, tboxHolder)
		updateButtonArea()
		return {
			holder = tboxHolder,
			textbox = tbox,
			outline = outline5,
			getText = function()
				return tbox.Text
			end,
			setText = function(text)
				tbox.Text = text
			end,
			remove = function()
				tboxHolder:Remove()
				local index = table.find(buttons, tboxHolder)
				if index then
					table.remove(buttons, index)
					updateButtonArea()
				end
			end
		}
	end
	selection.comet = self.comet
	return selection
end

local activeNotifications = {}

function comet:notify(props)
    local title = props.title or props.Title or "Notification"
    local text = props.text or props.Text or props.content or props.Content or "Notification content"
    local duration = props.duration or props.Duration or 3
    local rounding = props.rounding or self.rounding
    local borderCfg = borderOptions(props, self.borders)
    local notification = {}
    local notifHolder = utility.new(
        "Frame",
        {
            AnchorPoint = Vector2.new(1, 1),
            BackgroundColor3 = self.theme.accent,
            Size = UDim2.new(0, 300, 0, 70),
            Position = UDim2.new(1, 350, 1, -10),
            ZIndex = 10000,
            Parent = self.screen
        }
    )
	applyRounding(notifHolder, rounding)
	applyBorders(notifHolder, {
		Enabled = borderCfg.border,
		Top = borderCfg.borderTop,
		Right = borderCfg.borderRight,
		Bottom = borderCfg.borderBottom,
		Left = borderCfg.borderLeft,
		Color = Color3.fromRGB(12,12,12),
		Thickness = borderCfg.borderThickness
	})
    local outline2 = utility.new(
        "Frame",
        {
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            Size = UDim2.new(1, -4, 1, -4),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            ZIndex = 10001,
            Parent = notifHolder
        }
    )
	applyRounding(outline2, rounding)
	applyBorders(outline2, {
		Enabled = borderCfg.border,
		Top = borderCfg.borderTop,
		Right = borderCfg.borderRight,
		Bottom = borderCfg.borderBottom,
		Left = borderCfg.borderLeft,
		Color = borderCfg.borderColor,
		Thickness = borderCfg.borderThickness
	})
    local indent = utility.new(
        "Frame",
        {
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Color3.fromRGB(20, 20, 20),
            Size = UDim2.new(1, 0, 1, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            ZIndex = 10002,
            Parent = outline2
        }
    )
	applyRounding(indent, rounding)
	applyBorders(indent, {
		Enabled = borderCfg.border,
		Top = borderCfg.borderTop,
		Right = borderCfg.borderRight,
		Bottom = borderCfg.borderBottom,
		Left = borderCfg.borderLeft,
		Color = Color3.fromRGB(56,56,56),
		Thickness = borderCfg.borderThickness
	})
    local titleLabel = utility.new(
        "TextLabel",
        {
            AnchorPoint = Vector2.new(0.5, 0),
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -10, 0, 20),
            Position = UDim2.new(0.5, 0, 0, 5),
            Font = self.font,
            Text = title,
            RichText = true,
            TextWrapped=true,
            TextColor3 = self.theme.accent,
            TextXAlignment = "Left",
            TextSize = self.textsize,
            TextStrokeTransparency = 0,
            ZIndex = 10003,
            Parent = indent
        }
    )
    local contentLabel = utility.new(
        "TextLabel",
        {
            AnchorPoint = Vector2.new(0.5, 0),
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -10, 1, -30),
            Position = UDim2.new(0.5, 0, 0, 25),
            Font = self.font,
            Text = text,
            RichText = true,
            TextWrapped=true,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextXAlignment = "Left",
            TextYAlignment = "Top",
            TextSize = self.textsize,
            TextStrokeTransparency = 0,
            TextWrapped = true,
            ZIndex = 10003,
            Parent = indent
        }
    )
    notification = {
        holder = notifHolder,
        title = titleLabel,
        content = contentLabel,
        height = 70,
        removing = false
    }
    local function updatePositions()
        local yOffset = -10
        for i = #activeNotifications, 1, -1 do
            local notif = activeNotifications[i]
            if notif and notif.holder and notif.holder.Parent then
                notif.holder:TweenPosition(
                    UDim2.new(1, -10, 1, yOffset),
                    Enum.EasingDirection.Out,
                    Enum.EasingStyle.Quad,
                    0.3,
                    true
                )
                yOffset = yOffset - notif.height - 10
            end
        end
    end
    table.insert(activeNotifications, notification)
    notifHolder:TweenPosition(
        UDim2.new(1, -10, 1, -10),
        Enum.EasingDirection.Out,
        Enum.EasingStyle.Quad,
        0.5,
        true
    )
    task.wait(0.1)
    updatePositions()
    task.delay(duration, function()
        if not notification.removing then
            notification.removing = true
            notifHolder:TweenPosition(
                UDim2.new(1, 350, notifHolder.Position.Y.Scale, notifHolder.Position.Y.Offset),
                Enum.EasingDirection.In,
                Enum.EasingStyle.Quad,
                0.5,
                true
            )
            task.wait(0.5)
            for i, notif in pairs(activeNotifications) do
                if notif == notification then
                    table.remove(activeNotifications, i)
                    break
                end
            end
            notifHolder:Destroy()
            updatePositions()
        end
    end)
    setmetatable(notification, notifications)
    return notification
end

function sections:title(props)
	local text = props.text or props.Text or props.title or props.Title or "Title"
	local size = props.size or props.Size or props.textsize or props.TextSize or self.comet.textsize
	local titleholder = utility.new(
		"Frame",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, size + 5),
			Parent = self.content
		}
	)
	local titlelabel = utility.new(
		"TextLabel",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0, 0, 0, 0),
			Font = self.comet.font,
			Text = text,
			RichText = true,
			TextWrapped=true,
			TextColor3 = self.comet.theme.accent,
			TextSize = size,
			TextStrokeTransparency = 0,
			TextXAlignment = "Left",
			TextYAlignment = "Top",
			Parent = titleholder
		}
	)
	table.insert(self.comet.themeitems["accent"]["TextColor3"], titlelabel)
	self.comet.labels[#self.comet.labels + 1] = titlelabel
	local title = {
		comet = self.comet,
		label = titlelabel,
		holder = titleholder
	}
	function title:set(newtext)
		titlelabel.Text = newtext
	end
	function title:setcolor(color)
		titlelabel.TextColor3 = color
	end
	return title
end

function sections:paragraph(props)
	local title = props.title or props.Title or nil
	local text = props.text or props.Text or props.content or props.Content or "Paragraph text"
	local titlesize = props.titlesize or props.TitleSize or self.comet.textsize
	local textsize = props.textsize or props.TextSize or self.comet.textsize
	local tempLabel = utility.new(
		"TextLabel",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 1000),
			Font = self.comet.font,
			Text = text,
			RichText = true,
			TextWrapped=true,
			TextSize = textsize,
			TextWrapped = true,
			TextYAlignment = "Top",
			Visible = false,
			Parent = self.content.Parent
		}
	)
	task.wait()
	local contentHeight = tempLabel.TextBounds.Y
	tempLabel:Destroy()
	local totalHeight = contentHeight + 5
	if title then
		totalHeight = totalHeight + titlesize + 5
	end
	local paraholder = utility.new(
		"Frame",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, totalHeight),
			Parent = self.content
		}
	)
	local yOffset = 0
	local titlelabel = nil
	if title then
		titlelabel = utility.new(
			"TextLabel",
			{
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, titlesize + 3),
				Position = UDim2.new(0, 0, 0, 0),
				Font = self.comet.font,
				Text = title,
				TextWrapped=true,
				RichText = true,
				TextColor3 = self.comet.theme.accent,
				TextSize = titlesize,
				TextStrokeTransparency = 0,
				TextXAlignment = "Left",
				TextYAlignment = "Top",
				Parent = paraholder
			}
		)
		table.insert(self.comet.themeitems["accent"]["TextColor3"], titlelabel)
		self.comet.labels[#self.comet.labels + 1] = titlelabel
		yOffset = titlesize + 5
	end
	local contentlabel = utility.new(
		"TextLabel",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, contentHeight),
			Position = UDim2.new(0, 0, 0, yOffset),
			Font = self.comet.font,
			Text = text,
			RichText = true,
			TextColor3 = Color3.fromRGB(200, 200, 200),
			TextSize = textsize,
			TextWrapped=true,
			TextStrokeTransparency = 0,
			TextXAlignment = "Left",
			TextYAlignment = "Top",
			TextWrapped = true,
			Parent = paraholder
		}
	)
	self.comet.labels[#self.comet.labels + 1] = contentlabel
	local paragraph = {
		comet = self.comet,
		titlelabel = titlelabel,
		contentlabel = contentlabel,
		holder = paraholder
	}
	function paragraph:settext(newtext)
		contentlabel.Text = newtext
		local tempLabel2 = utility.new(
			"TextLabel",
			{
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 1000),
				Font = self.comet.font,
				Text = newtext,
				RichText = true,
				TextSize = textsize,
				TextWrapped=true,
				TextWrapped = true,
				TextYAlignment = "Top",
				Visible = false,
				Parent = paraholder.Parent
			}
		)
		task.wait()
		local newHeight = tempLabel2.TextBounds.Y
		tempLabel2:Destroy()
		contentlabel.Size = UDim2.new(1, 0, 0, newHeight)
		local newTotalHeight = newHeight + yOffset + 5
		paraholder.Size = UDim2.new(1, 0, 0, newTotalHeight)
	end
	function paragraph:settitle(newtitle)
		if titlelabel then
			titlelabel.Text = newtitle
		end
	end
	function paragraph:settitlecolor(color)
		if titlelabel then
			titlelabel.TextColor3 = color
		end
	end
	function paragraph:settextcolor(color)
		contentlabel.TextColor3 = color
	end
	return paragraph
end

mssections.toggle = sections.toggle
mssections.button = sections.button
mssections.slider = sections.slider
mssections.dropdown = sections.dropdown
mssections.buttonbox = sections.buttonbox
mssections.multibox = sections.multibox
mssections.textbox = sections.textbox
mssections.keybind = sections.keybind
mssections.colorpicker = sections.colorpicker
mssections.selection = sections.selection
mssections.title = sections.title
mssections.paragraph = sections.paragraph
return comet
