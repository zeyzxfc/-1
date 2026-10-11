-- [[ KGT DELUXE SUITE - DARK BLACK & WHITE EDITION (MMD UPDATE) ]]

-- Anti-Duplicate / Auto Cleanup
if game:GetService("CoreGui"):FindFirstChild("KGT_Deluxe_UI") then
	game:GetService("CoreGui"):FindFirstChild("KGT_Deluxe_UI"):Destroy()
end
if game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("KGT_Deluxe_UI") then
	game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("KGT_Deluxe_UI"):Destroy()
end

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Safe Exploit Globals Check
local safeFireTouch = firetouchinterest or function(part1, part2, toggle) end

-- Preset Color Map (Minimal Dark & White Accent Theme)
local ColorPresets = {
	["White"]  = Color3.fromRGB(240, 240, 240),
	["Gray"]   = Color3.fromRGB(180, 180, 180),
	["Green"]  = Color3.fromRGB(60, 200, 100),
	["Blue"]   = Color3.fromRGB(70, 130, 230),
	["Yellow"] = Color3.fromRGB(220, 220, 220),
	["Purple"] = Color3.fromRGB(160, 100, 220),
	["Cyan"]   = Color3.fromRGB(80, 200, 220),
	["Orange"] = Color3.fromRGB(220, 130, 60)
}

local ColorNames = {"White", "Gray", "Green", "Blue", "Yellow", "Purple", "Cyan", "Orange"}

-- Configuration State
local Config = {
	Rage = {
		KnifeAura = false,
		KnifeRange = 30,
		LoopKillAll = false,
		SilentAim = false,
		Spinbot = false,
		SpinSpeed = 50,
		Desync = false,
		HitboxExpander = false,
		HitboxSize = 5,
		LagSwitch = false,
		AutoTrashTalk = false,
		TrashTalkMsg = "EZ Get Good!"
	},
	Aimbot = {
		Enabled = false,
		TriggerBot = false,
		TriggerBotDelay = 0,
		TriggerBotTeamCheck = true,
		RageBot = false,
		RageBotAutoFire = true,
		RageBotRange = 500,
		MobileAimbot = false,
		DrawFOV = false,
		FOVRadius = 120,
		FOVType = "Center",
		FOVThickness = 1,
		FOVColor = Color3.fromRGB(240, 240, 240),
		TargetBone = "Head",
		Smoothness = 3,
		AimKey = Enum.UserInputType.MouseButton2
	},
	Player = {
		WalkSpeed = 16,
		JumpPower = 50,
		InfiniteJump = false,
		Spider = false,
		GodMode = false,
		Invisible = false,
		Noclip = false,
		Fly = false,
		MobileFly = false,
		FlySpeed = 50,
		HipHeightEnabled = false,
		HipHeight = 2
	},
	ESP = {
		Enabled = true,
		TeamCheck = false,
		Box = true,
		BoxColor = ColorPresets["White"],
		Highlight = false,
		HighlightColor = ColorPresets["White"],
		Name = true,
		NameColor = ColorPresets["White"],
		NameSize = 12,
		Health = true,
		Distance = true,
		DistanceColor = ColorPresets["White"],
		MaxDistance = 1500,
		Tracer = false,
		TracerColor = ColorPresets["White"],
		TracerOrigin = "Bottom"
	},
	PlayerMgmt = {
		SelectedPlayer = nil,
		BringHimLoop = false,
		BringAllLoop = false,
		BringDistance = 1.5,
		BringMaxDistance = 100,
		IsSpectating = false
	},
	MMD = {
		SelectedPlayer = nil,
		TeamCheck = true,
		LoopTpBack = false,
		TpBackDistance = 1.0,
		LoopTpAll = false,
		LoopTpDistance = 100,
		HitboxExpander20X = false,
		RoleESP = false,
		HighlightEsp = false,
		RoleName = true,
		AutoGrabGun = false,
		DroppedGunESP = false,
		KillAll = false,
		KillAllMaxDistance = 500,
		SelectedFlingTarget = nil
	}
}

-- Blur Effect
local blur = Lighting:FindFirstChild("KGT_MenuBlur")
if not blur then
	blur = Instance.new("BlurEffect")
	blur.Name = "KGT_MenuBlur"
	blur.Size = 12
	blur.Enabled = true
	blur.Parent = Lighting
end

-- ScreenGui Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KGT_Deluxe_UI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true

local successParent, _ = pcall(function()
	screenGui.Parent = game:GetService("CoreGui")
end)
if not successParent then
	screenGui.Parent = PlayerGui
end

-- FOV Circle
local fovCircle = Instance.new("Frame")
fovCircle.Name = "FOVCircle"
fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
fovCircle.Size = UDim2.new(0, Config.Aimbot.FOVRadius * 2, 0, Config.Aimbot.FOVRadius * 2)
fovCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
fovCircle.BackgroundTransparency = 1
fovCircle.Visible = false
fovCircle.Parent = screenGui

local fovCorner = Instance.new("UICorner")
fovCorner.CornerRadius = UDim.new(1, 0)
fovCorner.Parent = fovCircle

local fovStroke = Instance.new("UIStroke")
fovStroke.Color = Config.Aimbot.FOVColor
fovStroke.Thickness = Config.Aimbot.FOVThickness
fovStroke.Transparency = 0.5
fovStroke.Parent = fovCircle

-- Main Frames
local NORMAL_SIZE = UDim2.new(0, 520, 0, 350)
local MAXIMIZED_SIZE = UDim2.new(0, 680, 0, 450)

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = NORMAL_SIZE
mainFrame.Position = UDim2.new(0.5, -260, 0.5, -175)
mainFrame.BackgroundColor3 = Color3.fromRGB(13, 13, 15)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 0
mainFrame.Visible = true
mainFrame.Parent = screenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 8)
frameCorner.Parent = mainFrame

local frameStroke = Instance.new("UIStroke")
frameStroke.Color = Color3.fromRGB(240, 240, 240)
frameStroke.Thickness = 1.2
frameStroke.Transparency = 0.2
frameStroke.Parent = mainFrame

-- Dragging System
local dragging, dragStart, startPos
local headerBar = Instance.new("Frame")
headerBar.Name = "HeaderBar"
headerBar.Size = UDim2.new(1, 0, 0, 36)
headerBar.BackgroundTransparency = 1
headerBar.Parent = mainFrame

headerBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- Header Text & Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -110, 0, 20)
title.Position = UDim2.new(0, 12, 0, 6)
title.BackgroundTransparency = 1
title.Text = "KGT DELUXE"
title.TextColor3 = Color3.fromRGB(240, 240, 240)
title.TextSize = 14
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = mainFrame

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, -110, 0, 14)
subtitle.Position = UDim2.new(0, 12, 0, 24)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Dark & White Edition"
subtitle.TextColor3 = Color3.fromRGB(150, 150, 150)
subtitle.TextSize = 10
subtitle.Font = Enum.Font.GothamMedium
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = mainFrame

-- Window Controls
local windowControls = Instance.new("Frame")
windowControls.Size = UDim2.new(0, 60, 0, 16)
windowControls.Position = UDim2.new(1, -70, 0, 12)
windowControls.BackgroundTransparency = 1
windowControls.Parent = mainFrame

local windowList = Instance.new("UIListLayout")
windowList.FillDirection = Enum.FillDirection.Horizontal
windowList.HorizontalAlignment = Enum.HorizontalAlignment.Right
windowList.Padding = UDim.new(0, 6)
windowList.Parent = windowControls

local function createWinBtn(name, text, order)
	local btn = Instance.new("TextButton")
	btn.Name = name
	btn.Size = UDim2.new(0, 16, 0, 16)
	btn.BackgroundColor3 = Color3.fromRGB(22, 22, 25)
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(180, 180, 180)
	btn.TextSize = 10
	btn.Font = Enum.Font.GothamBold
	btn.AutoButtonColor = false
	btn.LayoutOrder = order
	btn.Parent = windowControls

	local bCorner = Instance.new("UICorner")
	bCorner.CornerRadius = UDim.new(0, 4)
	bCorner.Parent = btn

	local bStroke = Instance.new("UIStroke")
	bStroke.Color = Color3.fromRGB(45, 45, 50)
	bStroke.Thickness = 1
	bStroke.Parent = btn
	return btn
end

local closeBtn    = createWinBtn("CloseBtn", "✕", 3)
local maximizeBtn = createWinBtn("MaximizeBtn", "▢", 2)
local minimizeBtn = createWinBtn("MinimizeBtn", "—", 1)

local isOpen = true
local isMaximized = false
local currentActiveTab = "Rage"

local function setMenuVisible(visible)
	isOpen = visible
	mainFrame.Visible = visible
	if blur then blur.Enabled = visible end
end

minimizeBtn.MouseButton1Click:Connect(function()
	setMenuVisible(false)
end)

maximizeBtn.MouseButton1Click:Connect(function()
	isMaximized = not isMaximized
	if isMaximized then
		mainFrame.Size = MAXIMIZED_SIZE
		mainFrame.Position = UDim2.new(0.5, -340, 0.5, -225)
	else
		mainFrame.Size = NORMAL_SIZE
		mainFrame.Position = UDim2.new(0.5, -260, 0.5, -175)
	end
end)

-- Mobile Toggle Button
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "KGT_ToggleButton"
toggleButton.Size = UDim2.new(0, 100, 0, 30)
toggleButton.Position = UDim2.new(0.5, -50, 0, 12)
toggleButton.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
toggleButton.BackgroundTransparency = 0.1
toggleButton.BorderSizePixel = 0
toggleButton.Text = "KGT Menu"
toggleButton.TextColor3 = Color3.fromRGB(240, 240, 240)
toggleButton.TextSize = 11
toggleButton.Font = Enum.Font.GothamBold
toggleButton.ZIndex = 100
toggleButton.Parent = screenGui

local tbCorner = Instance.new("UICorner")
tbCorner.CornerRadius = UDim.new(0, 6)
tbCorner.Parent = toggleButton

local tbStroke = Instance.new("UIStroke")
tbStroke.Color = Color3.fromRGB(240, 240, 240)
tbStroke.Thickness = 1
tbStroke.Parent = toggleButton

toggleButton.MouseButton1Click:Connect(function()
	setMenuVisible(not isOpen)
end)

-- Exit Confirmation Overlay
local confirmOverlay = Instance.new("Frame")
confirmOverlay.Name = "ConfirmOverlay"
confirmOverlay.Size = UDim2.new(1, 0, 1, 0)
confirmOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
confirmOverlay.BackgroundTransparency = 0.7
confirmOverlay.Visible = false
confirmOverlay.ZIndex = 200
confirmOverlay.Parent = screenGui

local confirmBox = Instance.new("Frame")
confirmBox.Name = "ConfirmBox"
confirmBox.Size = UDim2.new(0, 300, 0, 130)
confirmBox.Position = UDim2.new(0.5, -150, 0.5, -65)
confirmBox.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
confirmBox.BorderSizePixel = 0
confirmBox.ZIndex = 201
confirmBox.Parent = confirmOverlay

local confirmCorner = Instance.new("UICorner")
confirmCorner.CornerRadius = UDim.new(0, 8)
confirmCorner.Parent = confirmBox

local confirmStroke = Instance.new("UIStroke")
confirmStroke.Color = Color3.fromRGB(50, 50, 55)
confirmStroke.Thickness = 1
confirmStroke.Parent = confirmBox

local confirmTitle = Instance.new("TextLabel")
confirmTitle.Size = UDim2.new(1, -20, 0, 24)
confirmTitle.Position = UDim2.new(0, 10, 0, 10)
confirmTitle.BackgroundTransparency = 1
confirmTitle.Text = "Exit Confirmation"
confirmTitle.TextColor3 = Color3.fromRGB(240, 240, 240)
confirmTitle.TextSize = 13
confirmTitle.Font = Enum.Font.GothamBold
confirmTitle.ZIndex = 202
confirmTitle.Parent = confirmBox

local confirmDesc = Instance.new("TextLabel")
confirmDesc.Size = UDim2.new(1, -20, 0, 32)
confirmDesc.Position = UDim2.new(0, 10, 0, 36)
confirmDesc.BackgroundTransparency = 1
confirmDesc.Text = "Are you sure you want to exit and unload script features?"
confirmDesc.TextColor3 = Color3.fromRGB(160, 160, 160)
confirmDesc.TextSize = 11
confirmDesc.Font = Enum.Font.Gotham
confirmDesc.TextWrapped = true
confirmDesc.ZIndex = 202
confirmDesc.Parent = confirmBox

local yesBtn = Instance.new("TextButton")
yesBtn.Size = UDim2.new(0, 120, 0, 28)
yesBtn.Position = UDim2.new(0, 20, 1, -38)
yesBtn.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
yesBtn.Text = "Exit"
yesBtn.TextColor3 = Color3.fromRGB(20, 20, 24)
yesBtn.TextSize = 11
yesBtn.Font = Enum.Font.GothamBold
yesBtn.ZIndex = 202
yesBtn.Parent = confirmBox

local yesCorner = Instance.new("UICorner")
yesCorner.CornerRadius = UDim.new(0, 5)
yesCorner.Parent = yesBtn

local noBtn = Instance.new("TextButton")
noBtn.Size = UDim2.new(0, 120, 0, 28)
noBtn.Position = UDim2.new(1, -140, 1, -38)
noBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
noBtn.Text = "Cancel"
noBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
noBtn.TextSize = 11
noBtn.Font = Enum.Font.GothamBold
noBtn.ZIndex = 202
noBtn.Parent = confirmBox

local noCorner = Instance.new("UICorner")
noCorner.CornerRadius = UDim.new(0, 5)
noCorner.Parent = noBtn

closeBtn.MouseButton1Click:Connect(function()
	confirmOverlay.Visible = true
end)

noBtn.MouseButton1Click:Connect(function()
	confirmOverlay.Visible = false
end)

-- Layout Structure
local divider = Instance.new("Frame")
divider.Size = UDim2.new(1, -24, 0, 1)
divider.Position = UDim2.new(0, 12, 0, 42)
divider.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
divider.BorderSizePixel = 0
divider.Parent = mainFrame

local tabNav = Instance.new("Frame")
tabNav.Name = "TabNavigation"
tabNav.Size = UDim2.new(0, 110, 1, -50)
tabNav.Position = UDim2.new(0, 12, 0, 48)
tabNav.BackgroundTransparency = 1
tabNav.Parent = mainFrame

local tabListLayout = Instance.new("UIListLayout")
tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabListLayout.Padding = UDim.new(0, 4)
tabListLayout.Parent = tabNav

local contentArea = Instance.new("Frame")
contentArea.Name = "ContentArea"
contentArea.Size = UDim2.new(1, -138, 1, -50)
contentArea.Position = UDim2.new(0, 128, 0, 48)
contentArea.BackgroundTransparency = 1
contentArea.Parent = mainFrame

-- UI Helper Component Builders
local function createScrollContainer(parent)
	local scroll = Instance.new("ScrollingFrame")
	scroll.Size = UDim2.new(1, 0, 1, 0)
	scroll.BackgroundTransparency = 1
	scroll.BorderSizePixel = 0
	scroll.ScrollBarThickness = 2
	scroll.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 85)
	scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	scroll.Parent = parent

	local layout = Instance.new("UIListLayout")
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, 6)
	layout.Parent = scroll

	return scroll
end

local function createToggle(parent, text, defaultState, callback)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, -6, 0, 26)
	container.BackgroundTransparency = 1
	container.Parent = parent

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -40, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = Color3.fromRGB(190, 190, 190)
	label.TextSize = 11
	label.Font = Enum.Font.Gotham
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = container

	local switch = Instance.new("TextButton")
	switch.Size = UDim2.new(0, 32, 0, 16)
	switch.Position = UDim2.new(1, -32, 0.5, -8)
	switch.BackgroundColor3 = defaultState and Color3.fromRGB(240, 240, 240) or Color3.fromRGB(25, 25, 28)
	switch.BorderSizePixel = 0
	switch.Text = ""
	switch.AutoButtonColor = false
	switch.Parent = container

	local switchCorner = Instance.new("UICorner")
	switchCorner.CornerRadius = UDim.new(1, 0)
	switchCorner.Parent = switch

	local switchStroke = Instance.new("UIStroke")
	switchStroke.Color = Color3.fromRGB(50, 50, 55)
	switchStroke.Thickness = 1
	switchStroke.Parent = switch

	local knob = Instance.new("Frame")
	knob.Size = UDim2.new(0, 10, 0, 10)
	knob.Position = defaultState and UDim2.new(1, -12, 0.5, -5) or UDim2.new(0, 2, 0.5, -5)
	knob.BackgroundColor3 = defaultState and Color3.fromRGB(20, 20, 24) or Color3.fromRGB(140, 140, 140)
	knob.BorderSizePixel = 0
	knob.Parent = switch

	local knobCorner = Instance.new("UICorner")
	knobCorner.CornerRadius = UDim.new(1, 0)
	knobCorner.Parent = knob

	local state = defaultState
	switch.MouseButton1Click:Connect(function()
		state = not state
		switch.BackgroundColor3 = state and Color3.fromRGB(240, 240, 240) or Color3.fromRGB(25, 25, 28)
		knob.Position = state and UDim2.new(1, -12, 0.5, -5) or UDim2.new(0, 2, 0.5, -5)
		knob.BackgroundColor3 = state and Color3.fromRGB(20, 20, 24) or Color3.fromRGB(140, 140, 140)
		callback(state)
	end)

	local toggleObj = {}
	function toggleObj:SetState(newState)
		state = newState
		switch.BackgroundColor3 = state and Color3.fromRGB(240, 240, 240) or Color3.fromRGB(25, 25, 28)
		knob.Position = state and UDim2.new(1, -12, 0.5, -5) or UDim2.new(0, 2, 0.5, -5)
		knob.BackgroundColor3 = state and Color3.fromRGB(20, 20, 24) or Color3.fromRGB(140, 140, 140)
		callback(state)
	end

	return toggleObj
end

local function createSlider(parent, text, min, max, default, isFloat, allowExceed, callback)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, -6, 0, 36)
	container.BackgroundTransparency = 1
	container.Parent = parent

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0.65, 0, 0, 14)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = Color3.fromRGB(190, 190, 190)
	label.TextSize = 11
	label.Font = Enum.Font.Gotham
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = container

	local valInput = Instance.new("TextBox")
	valInput.Size = UDim2.new(0.3, 0, 0, 16)
	valInput.Position = UDim2.new(0.7, 0, 0, -1)
	valInput.BackgroundTransparency = 0.5
	valInput.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
	valInput.Text = tostring(default)
	valInput.TextColor3 = Color3.fromRGB(230, 230, 230)
	valInput.TextSize = 10
	valInput.Font = Enum.Font.GothamBold
	valInput.TextXAlignment = Enum.TextXAlignment.Right
	valInput.ClearTextOnFocus = false
	valInput.Parent = container

	local valCorner = Instance.new("UICorner")
	valCorner.CornerRadius = UDim.new(0, 3)
	valCorner.Parent = valInput

	local track = Instance.new("TextButton")
	track.Size = UDim2.new(1, 0, 0, 4)
	track.Position = UDim2.new(0, 0, 0, 22)
	track.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
	track.Text = ""
	track.AutoButtonColor = false
	track.Parent = container

	local trackCorner = Instance.new("UICorner")
	trackCorner.CornerRadius = UDim.new(1, 0)
	trackCorner.Parent = track

	local trackStroke = Instance.new("UIStroke")
	trackStroke.Color = Color3.fromRGB(45, 45, 50)
	trackStroke.Thickness = 1
	trackStroke.Parent = track

	local fill = Instance.new("Frame")
	local pct = math.clamp((default - min) / (max - min), 0, 1)
	fill.Size = UDim2.new(pct, 0, 1, 0)
	fill.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
	fill.BorderSizePixel = 0
	fill.Parent = track

	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = UDim.new(1, 0)
	fillCorner.Parent = fill

	local currentVal = default

	local function setVal(v, fromInput)
		local num = tonumber(v)
		if not num then
			valInput.Text = tostring(currentVal)
			return
		end

		if allowExceed then
			num = math.max(num, min)
		else
			num = math.clamp(num, min, max)
		end

		if not isFloat then
			num = math.floor(num)
		else
			num = math.floor(num * 100) / 100
		end

		currentVal = num
		valInput.Text = tostring(currentVal)

		local alpha = math.clamp((currentVal - min) / (max - min), 0, 1)
		fill.Size = UDim2.new(alpha, 0, 1, 0)

		callback(currentVal)
	end

	valInput.FocusLost:Connect(function()
		setVal(valInput.Text, true)
	end)

	local draggingSlider = false
	local function update(input)
		local posX = math.clamp(input.Position.X - track.AbsolutePosition.X, 0, track.AbsoluteSize.X)
		local alpha = posX / track.AbsoluteSize.X
		local rawVal = min + (max - min) * alpha
		setVal(rawVal, false)
	end

	track.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			draggingSlider = true
			update(input)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			draggingSlider = false
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			update(input)
		end
	end)
end

local function createDropdown(parent, text, options, defaultOption, callback)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, -6, 0, 28)
	container.BackgroundTransparency = 1
	container.ClipsDescendants = false
	container.Parent = parent

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0.45, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = Color3.fromRGB(190, 190, 190)
	label.TextSize = 11
	label.Font = Enum.Font.Gotham
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = container

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.53, 0, 0, 24)
	btn.Position = UDim2.new(0.47, 0, 0.5, -12)
	btn.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
	btn.Text = (defaultOption or "Select") .. "  ▼"
	btn.TextColor3 = Color3.fromRGB(220, 220, 220)
	btn.TextSize = 10
	btn.Font = Enum.Font.GothamMedium
	btn.ZIndex = 5
	btn.Parent = container

	local btnStroke = Instance.new("UIStroke")
	btnStroke.Color = Color3.fromRGB(45, 45, 50)
	btnStroke.Thickness = 1
	btnStroke.Parent = btn

	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 4)
	btnCorner.Parent = btn

	local listFrame = Instance.new("Frame")
	listFrame.Size = UDim2.new(0.53, 0, 0, math.min(#options, 5) * 22)
	listFrame.Position = UDim2.new(0.47, 0, 1, 2)
	listFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
	listFrame.Visible = false
	listFrame.ZIndex = 10
	listFrame.Parent = container

	local listCorner = Instance.new("UICorner")
	listCorner.CornerRadius = UDim.new(0, 4)
	listCorner.Parent = listFrame

	local listStroke = Instance.new("UIStroke")
	listStroke.Color = Color3.fromRGB(45, 45, 50)
	listStroke.Thickness = 1
	listStroke.Parent = listFrame

	local listScroll = Instance.new("ScrollingFrame")
	listScroll.Size = UDim2.new(1, 0, 1, 0)
	listScroll.BackgroundTransparency = 1
	listScroll.BorderSizePixel = 0
	listScroll.ScrollBarThickness = 2
	listScroll.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 85)
	listScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	listScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	listScroll.ZIndex = 11
	listScroll.Parent = listFrame

	local listLayout = Instance.new("UIListLayout")
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Parent = listScroll

	local isDropdownOpen = false
	local selectedOpt = defaultOption

	btn.MouseButton1Click:Connect(function()
		isDropdownOpen = not isDropdownOpen
		listFrame.Visible = isDropdownOpen
		btn.Text = (selectedOpt or "Select") .. (isDropdownOpen and "  ▲" or "  ▼")
	end)

	local dropdownObj = {}

	local function rebuildOptions(newOpts, preserveSelected)
		for _, child in ipairs(listScroll:GetChildren()) do
			if child:IsA("TextButton") then child:Destroy() end
		end

		options = newOpts
		listFrame.Size = UDim2.new(0.53, 0, 0, math.min(#options, 5) * 22)

		if not preserveSelected or not table.find(options, selectedOpt) then
			selectedOpt = options[1] or "No Players"
		end

		btn.Text = selectedOpt .. (isDropdownOpen and "  ▲" or "  ▼")
		callback(selectedOpt)

		for _, opt in ipairs(options) do
			local optBtn = Instance.new("TextButton")
			optBtn.Size = UDim2.new(1, 0, 0, 22)
			optBtn.BackgroundTransparency = 1
			optBtn.Text = opt
			optBtn.TextColor3 = (opt == selectedOpt) and Color3.fromRGB(250, 250, 250) or Color3.fromRGB(150, 150, 150)
			optBtn.TextSize = 10
			optBtn.Font = Enum.Font.Gotham
			optBtn.ZIndex = 12
			optBtn.Parent = listScroll

			optBtn.MouseButton1Click:Connect(function()
				selectedOpt = opt
				btn.Text = opt .. "  ▼"
				isDropdownOpen = false
				listFrame.Visible = false
				callback(opt)

				for _, child in ipairs(listScroll:GetChildren()) do
					if child:IsA("TextButton") then
						child.TextColor3 = (child.Text == opt) and Color3.fromRGB(250, 250, 250) or Color3.fromRGB(150, 150, 150)
					end
				end
			end)
		end
	end

	rebuildOptions(options, false)

	function dropdownObj:Refresh(newOptions)
		rebuildOptions(newOptions, true)
	end

	return dropdownObj
end

local function createButton(parent, text, callback)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, -6, 0, 28)
	container.BackgroundTransparency = 1
	container.Parent = parent

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 1, 0)
	btn.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(220, 220, 220)
	btn.TextSize = 11
	btn.Font = Enum.Font.GothamMedium
	btn.AutoButtonColor = true
	btn.Parent = container

	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 4)
	btnCorner.Parent = btn

	local btnStroke = Instance.new("UIStroke")
	btnStroke.Color = Color3.fromRGB(45, 45, 50)
	btnStroke.Thickness = 1
	btnStroke.Parent = btn

	btn.MouseButton1Click:Connect(callback)
	return container
end

-- Tab Creator
local tabs = {}
local tabButtons = {}

local function createTab(tabName, order)
	local btn = Instance.new("TextButton")
	btn.Name = tabName .. "Btn"
	btn.Size = UDim2.new(1, 0, 0, 26)
	btn.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
	btn.BackgroundTransparency = (tabName == currentActiveTab) and 0 or 1
	btn.BorderSizePixel = 0
	btn.Text = ""
	btn.AutoButtonColor = false
	btn.LayoutOrder = order
	btn.Parent = tabNav

	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 4)
	btnCorner.Parent = btn

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -12, 1, 0)
	label.Position = UDim2.new(0, 8, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = tabName
	label.TextColor3 = (tabName == currentActiveTab) and Color3.fromRGB(20, 20, 24) or Color3.fromRGB(140, 140, 140)
	label.TextSize = 10
	label.Font = Enum.Font.GothamBold
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = btn

	local container = Instance.new("Frame")
	container.Name = tabName .. "Container"
	container.Size = UDim2.new(1, 0, 1, 0)
	container.BackgroundTransparency = 1
	container.Visible = (tabName == currentActiveTab)
	container.Parent = contentArea

	tabs[tabName] = container
	tabButtons[tabName] = {Button = btn, Label = label}

	btn.MouseButton1Click:Connect(function()
		if currentActiveTab == tabName then return end

		for name, tabFrame in pairs(tabs) do
			if name == tabName then
				tabFrame.Visible = true
				tabButtons[name].Button.BackgroundTransparency = 0
				tabButtons[name].Label.TextColor3 = Color3.fromRGB(20, 20, 24)
			else
				tabFrame.Visible = false
				tabButtons[name].Button.BackgroundTransparency = 1
				tabButtons[name].Label.TextColor3 = Color3.fromRGB(140, 140, 140)
			end
		end
		currentActiveTab = tabName
	end)

	return container
end

-- Helper to fetch player list names
local function getOtherPlayerNames()
	local names = {}
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LocalPlayer then
			table.insert(names, p.Name)
		end
	end
	if #names == 0 then table.insert(names, "No Players") end
	return names
end

----------------------------------------------------------------------
-- 1. RAGE TAB
----------------------------------------------------------------------
local rageGroup = createTab("Rage", 1)
local rageScroll = createScrollContainer(rageGroup)

local mm2RageHeader = Instance.new("TextLabel")
mm2RageHeader.Size = UDim2.new(1, -6, 0, 18)
mm2RageHeader.BackgroundTransparency = 1
mm2RageHeader.Text = "MMD / COMBAT AĞIR ÖLDÜRME"
mm2RageHeader.TextColor3 = Color3.fromRGB(240, 240, 240)
mm2RageHeader.TextSize = 10
mm2RageHeader.Font = Enum.Font.GothamBold
mm2RageHeader.TextXAlignment = Enum.TextXAlignment.Center
mm2RageHeader.Parent = rageScroll

createToggle(rageScroll, "Knife Range Extender (Aura)", Config.Rage.KnifeAura, function(v) Config.Rage.KnifeAura = v end)
createSlider(rageScroll, "Knife Range (Studs)", 10, 150, Config.Rage.KnifeRange, false, false, function(v) Config.Rage.KnifeRange = v end)

createToggle(rageScroll, "Loop Kill All (0.05s)", Config.Rage.LoopKillAll, function(v) Config.Rage.LoopKillAll = v end)
createToggle(rageScroll, "Silent Aim (Wallbang)", Config.Rage.SilentAim, function(v) Config.Rage.SilentAim = v end)

local chaosHeader = Instance.new("TextLabel")
chaosHeader.Size = UDim2.new(1, -6, 0, 18)
chaosHeader.BackgroundTransparency = 1
chaosHeader.Text = "RAGE & CHAOS COMBAT"
chaosHeader.TextColor3 = Color3.fromRGB(240, 240, 240)
chaosHeader.TextSize = 10
chaosHeader.Font = Enum.Font.GothamBold
chaosHeader.TextXAlignment = Enum.TextXAlignment.Center
chaosHeader.Parent = rageScroll

createToggle(rageScroll, "Spinbot (Anti-Aim)", Config.Rage.Spinbot, function(v) Config.Rage.Spinbot = v end)
createToggle(rageScroll, "Desync (Ghost Hitbox)", Config.Rage.Desync, function(v) Config.Rage.Desync = v end)
createToggle(rageScroll, "Hitbox Expander", Config.Rage.HitboxExpander, function(v) Config.Rage.HitboxExpander = v end)
createSlider(rageScroll, "Hitbox Size", 2, 20, Config.Rage.HitboxSize, false, false, function(v) Config.Rage.HitboxSize = v end)
createToggle(rageScroll, "Lag Switch (Freeze Net)", Config.Rage.LagSwitch, function(v) Config.Rage.LagSwitch = v end)
createToggle(rageScroll, "Auto Trash-Talk (Chat)", Config.Rage.AutoTrashTalk, function(v) Config.Rage.AutoTrashTalk = v end)

----------------------------------------------------------------------
-- 2. AIMBOT TAB
----------------------------------------------------------------------
local aimbotGroup = createTab("AimBot", 2)
local aimbotScroll = createScrollContainer(aimbotGroup)

createToggle(aimbotScroll, "AimBot Enabled", Config.Aimbot.Enabled, function(v) Config.Aimbot.Enabled = v end)
createToggle(aimbotScroll, "Mobile Aimbot (Auto Lock)", Config.Aimbot.MobileAimbot, function(v) Config.Aimbot.MobileAimbot = v end)
createToggle(aimbotScroll, "Draw FOV Circle", Config.Aimbot.DrawFOV, function(v) Config.Aimbot.DrawFOV = v; fovCircle.Visible = v end)
createDropdown(aimbotScroll, "FOV Konumu", {"Merkeze Sabit", "Fareyi Takip Et"}, "Merkeze Sabit", function(opt)
	Config.Aimbot.FOVType = (opt == "Merkeze Sabit") and "Center" or "Mouse"
end)
createSlider(aimbotScroll, "FOV Radius", 30, 400, Config.Aimbot.FOVRadius, false, false, function(v)
	Config.Aimbot.FOVRadius = v
	fovCircle.Size = UDim2.new(0, v * 2, 0, v * 2)
end)
createSlider(aimbotScroll, "FOV Kalınlığı", 1, 5, Config.Aimbot.FOVThickness, false, false, function(v)
	Config.Aimbot.FOVThickness = v
	fovStroke.Thickness = v
end)
createDropdown(aimbotScroll, "FOV Rengi", ColorNames, "White", function(opt)
	Config.Aimbot.FOVColor = ColorPresets[opt]
	fovStroke.Color = ColorPresets[opt]
end)
createSlider(aimbotScroll, "Smoothness (1-5)", 1, 5, Config.Aimbot.Smoothness, false, false, function(v) Config.Aimbot.Smoothness = v end)

----------------------------------------------------------------------
-- 3. TRIGGERBOT TAB
----------------------------------------------------------------------
local triggerbotGroup = createTab("TriggerBot", 3)
local triggerbotScroll = createScrollContainer(triggerbotGroup)

createToggle(triggerbotScroll, "TriggerBot Enabled", Config.Aimbot.TriggerBot, function(v)
	Config.Aimbot.TriggerBot = v
end)
createToggle(triggerbotScroll, "Team Check", Config.Aimbot.TriggerBotTeamCheck, function(v)
	Config.Aimbot.TriggerBotTeamCheck = v
end)
createSlider(triggerbotScroll, "Trigger Delay (ms)", 0, 500, Config.Aimbot.TriggerBotDelay, false, false, function(v)
	Config.Aimbot.TriggerBotDelay = v
end)

----------------------------------------------------------------------
-- 4. RAGEBOT TAB
----------------------------------------------------------------------
local ragebotGroup = createTab("RageBot", 4)
local ragebotScroll = createScrollContainer(ragebotGroup)

createToggle(ragebotScroll, "RageBot Enabled", Config.Aimbot.RageBot, function(v)
	Config.Aimbot.RageBot = v
end)
createToggle(ragebotScroll, "Auto Fire", Config.Aimbot.RageBotAutoFire, function(v)
	Config.Aimbot.RageBotAutoFire = v
end)
createSlider(ragebotScroll, "Rage Range", 50, 2500, Config.Aimbot.RageBotRange, false, false, function(v)
	Config.Aimbot.RageBotRange = v
end)

----------------------------------------------------------------------
-- 5. PLAYER TAB
----------------------------------------------------------------------
local playerGroup = createTab("Player", 5)
local playerScroll = createScrollContainer(playerGroup)

local function applyPlayerStats()
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
		pcall(function()
			local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
			hum.WalkSpeed = Config.Player.WalkSpeed
			hum.JumpPower = Config.Player.JumpPower
			if Config.Player.HipHeightEnabled then
				hum.HipHeight = Config.Player.HipHeight
			end
		end)
	end
end

createSlider(playerScroll, "WalkSpeed (Auto-Locked)", 16, 250, Config.Player.WalkSpeed, false, true, function(v)
	Config.Player.WalkSpeed = v
	applyPlayerStats()
end)

local speedLockConnection = RunService.Stepped:Connect(function()
	if LocalPlayer.Character then
		local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		if hum and Config.Player.WalkSpeed ~= 16 then
			hum.WalkSpeed = Config.Player.WalkSpeed
		end
	end
end)

createSlider(playerScroll, "JumpPower", 50, 350, Config.Player.JumpPower, false, true, function(v)
	Config.Player.JumpPower = v
	applyPlayerStats()
end)

createToggle(playerScroll, "Hip Height", Config.Player.HipHeightEnabled, function(v)
	Config.Player.HipHeightEnabled = v
	if LocalPlayer.Character then
		local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.HipHeight = v and Config.Player.HipHeight or 2
		end
	end
end)

createSlider(playerScroll, "Hip Height Value", 0, 100, Config.Player.HipHeight, false, true, function(v)
	Config.Player.HipHeight = v
	if Config.Player.HipHeightEnabled and LocalPlayer.Character then
		local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.HipHeight = Config.Player.HipHeight
		end
	end
end)

local hipHeightConnection = RunService.Stepped:Connect(function()
	if Config.Player.HipHeightEnabled and LocalPlayer.Character then
		local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.HipHeight = Config.Player.HipHeight
		end
	end
end)

createToggle(playerScroll, "Infinite Jump", Config.Player.InfiniteJump, function(v) Config.Player.InfiniteJump = v end)
createToggle(playerScroll, "Spider", Config.Player.Spider, function(v) Config.Player.Spider = v end)
createToggle(playerScroll, "Noclip", Config.Player.Noclip, function(v) Config.Player.Noclip = v end)

local noclipConnection = RunService.Stepped:Connect(function()
	if Config.Player.Noclip and LocalPlayer.Character then
		for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end)

createToggle(playerScroll, "Fly", Config.Player.Fly, function(v)
	Config.Player.Fly = v
	if not v and LocalPlayer.Character then
		local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		if hrp then hrp.AssemblyLinearVelocity = Vector3.zero end
	end
end)

createToggle(playerScroll, "Mobile Fly", Config.Player.MobileFly, function(v)
	Config.Player.MobileFly = v
	if not v and LocalPlayer.Character then
		local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		if hrp then hrp.AssemblyLinearVelocity = Vector3.zero end
	end
end)

local flyConnection = RunService.RenderStepped:Connect(function()
	if (Config.Player.Fly or Config.Player.MobileFly) and LocalPlayer.Character then
		local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		if hrp and hum then
			local moveDir = hum.MoveDirection
			if moveDir.Magnitude > 0 then
				local flyVel = Camera.CFrame.LookVector * (moveDir.Z < 0 and Config.Player.WalkSpeed or -Config.Player.WalkSpeed)
				if Config.Player.MobileFly then
					flyVel = Camera.CFrame:VectorToWorldSpace(CFrame.new(moveDir.X, 0, moveDir.Z).Position) * Config.Player.WalkSpeed
				end
				hrp.AssemblyLinearVelocity = flyVel
			else
				hrp.AssemblyLinearVelocity = Vector3.zero
			end
		end
	end
end)

local godConnection
createToggle(playerScroll, "God Mode", Config.Player.GodMode, function(state)
	Config.Player.GodMode = state
	local char = LocalPlayer.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")

	if state then
		if hum then hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false) end
		godConnection = RunService.Stepped:Connect(function()
			if Config.Player.GodMode and LocalPlayer.Character then
				local h = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
				if h then
					h.Health = h.MaxHealth
				end
			end
		end)
	else
		if godConnection then godConnection:Disconnect() godConnection = nil end
		if hum then hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true) end
	end
end)

local invisConnection
createToggle(playerScroll, "Invisible", Config.Player.Invisible, function(state)
	Config.Player.Invisible = state
	if state then
		invisConnection = RunService.RenderStepped:Connect(function()
			if Config.Player.Invisible and LocalPlayer.Character then
				for _, v in ipairs(LocalPlayer.Character:GetDescendants()) do
					if v:IsA("BasePart") or v:IsA("Decal") then
						v.LocalTransparencyModifier = 1
					end
				end
			end
		end)
	else
		if invisConnection then invisConnection:Disconnect() invisConnection = nil end
		if LocalPlayer.Character then
			for _, v in ipairs(LocalPlayer.Character:GetDescendants()) do
				if v:IsA("BasePart") or v:IsA("Decal") then
					v.LocalTransparencyModifier = 0
				end
			end
		end
	end
end)

local jumpConnection = UserInputService.JumpRequest:Connect(function()
	if Config.Player.InfiniteJump and LocalPlayer.Character then
		local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
	end
end)

----------------------------------------------------------------------
-- 6. VISUAL TAB
----------------------------------------------------------------------
local visualGroup = createTab("Visual", 6)
local visualScroll = createScrollContainer(visualGroup)

createToggle(visualScroll, "Enabled", Config.ESP.Enabled, function(v) Config.ESP.Enabled = v end)
createToggle(visualScroll, "Team Check", Config.ESP.TeamCheck, function(v) Config.ESP.TeamCheck = v end)
createToggle(visualScroll, "Box ESP", Config.ESP.Box, function(v) Config.ESP.Box = v end)
createToggle(visualScroll, "Health Bar", Config.ESP.Health, function(v) Config.ESP.Health = v end)
createToggle(visualScroll, "Tracer (Line)", Config.ESP.Tracer, function(v) Config.ESP.Tracer = v end)
createDropdown(visualScroll, "Tracer Origin", {"Bottom", "Top", "Center", "Mouse"}, Config.ESP.TracerOrigin, function(opt) Config.ESP.TracerOrigin = opt end)
createToggle(visualScroll, "Highlight ESP", Config.ESP.Highlight, function(v) Config.ESP.Highlight = v end)
createToggle(visualScroll, "Name ESP", Config.ESP.Name, function(v) Config.ESP.Name = v end)
createToggle(visualScroll, "Distance ESP", Config.ESP.Distance, function(v) Config.ESP.Distance = v end)
createSlider(visualScroll, "Max Distance", 50, 2500, Config.ESP.MaxDistance, false, false, function(v) Config.ESP.MaxDistance = v end)

local colorHeader = Instance.new("TextLabel")
colorHeader.Size = UDim2.new(1, -6, 0, 18)
colorHeader.BackgroundTransparency = 1
colorHeader.Text = "COLOR SETTINGS"
colorHeader.TextColor3 = Color3.fromRGB(120, 120, 125)
colorHeader.TextSize = 10
colorHeader.Font = Enum.Font.GothamBold
colorHeader.TextXAlignment = Enum.TextXAlignment.Center
colorHeader.Parent = visualScroll

createDropdown(visualScroll, "Box Color", ColorNames, "White", function(opt) Config.ESP.BoxColor = ColorPresets[opt] end)
createDropdown(visualScroll, "Tracer Color", ColorNames, "White", function(opt) Config.ESP.TracerColor = ColorPresets[opt] end)
createDropdown(visualScroll, "Highlight Color", ColorNames, "White", function(opt) Config.ESP.HighlightColor = ColorPresets[opt] end)
createDropdown(visualScroll, "Name Color", ColorNames, "White", function(opt) Config.ESP.NameColor = ColorPresets[opt] end)
createDropdown(visualScroll, "Distance Color", ColorNames, "White", function(opt) Config.ESP.DistanceColor = ColorPresets[opt] end)

----------------------------------------------------------------------
-- 7. PLAYER MANAGEMENT TAB
----------------------------------------------------------------------
local pmGroup = createTab("Player Management", 7)
local pmScroll = createScrollContainer(pmGroup)

local initialPNames = getOtherPlayerNames()
Config.PlayerMgmt.SelectedPlayer = initialPNames[1]

local pmDropdown = createDropdown(pmScroll, "Target Player", initialPNames, initialPNames[1], function(opt)
	Config.PlayerMgmt.SelectedPlayer = opt
end)

local isFlingingActive = false
local savedFlingCFrame = nil

local function stopFlingEngine()
	isFlingingActive = false
	task.wait(0.1)

	local myChar = LocalPlayer.Character
	local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")

	if myHrp then
		myHrp.AssemblyAngularVelocity = Vector3.zero
		myHrp.AssemblyLinearVelocity = Vector3.zero
		if savedFlingCFrame then
			myHrp.CFrame = savedFlingCFrame
		end
	end
end

local function advancedLadderFlingPlayer(targetPlr)
	if not targetPlr or not targetPlr.Character then return end

	local targetChar = targetPlr.Character
	local targetHrp = targetChar:FindFirstChild("HumanoidRootPart")
	local targetHum = targetChar:FindFirstChildOfClass("Humanoid")

	local myChar = LocalPlayer.Character
	local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")

	if not (targetHrp and targetHum and myHrp) then return end

	isFlingingActive = false
	task.wait(0.05)

	savedFlingCFrame = myHrp.CFrame
	isFlingingActive = true

	task.spawn(function()
		local steppedConn = RunService.Stepped:Connect(function()
			if isFlingingActive and myChar then
				for _, part in ipairs(myChar:GetDescendants()) do
					if part:IsA("BasePart") then
						part.CanCollide = false
					end
				end
			end
		end)

		local startTime = tick()
		local stepCounter = 0

		while isFlingingActive do
			RunService.Heartbeat:Wait()

			if not isFlingingActive then break end
			if not targetHrp or not targetHrp.Parent or not targetHum or targetHum.Health <= 0 then
				break
			end

			stepCounter = stepCounter + 1
			local verticalClimbOffset = math.sin(stepCounter * 0.8) * 2.2

			myHrp.AssemblyAngularVelocity = Vector3.new(999999, 999999, 999999)
			myHrp.AssemblyLinearVelocity = Vector3.new(999999, 999999, 999999)

			myHrp.CFrame = targetHrp.CFrame * CFrame.new(math.random(-0.5, 0.5), verticalClimbOffset, math.random(-0.5, 0.5)) * CFrame.Angles(math.rad(math.random(0, 360)), math.rad(math.random(0, 360)), 0)

			local targetVel = targetHrp.AssemblyLinearVelocity.Magnitude
			local targetPosY = targetHrp.Position.Y

			if targetVel > 220 or targetPosY > 300 or (tick() - startTime > 10) then
				break
			end
		end

		if steppedConn then steppedConn:Disconnect() end
		stopFlingEngine()
	end)
end

createToggle(pmScroll, "Bring Him (Loop)", false, function(v) Config.PlayerMgmt.BringHimLoop = v end)
createToggle(pmScroll, "Bring All (Loop)", false, function(v) Config.PlayerMgmt.BringAllLoop = v end)
createSlider(pmScroll, "Bring Distance (Studs)", 0.5, 2, Config.PlayerMgmt.BringDistance, true, false, function(v) Config.PlayerMgmt.BringDistance = v end)
createSlider(pmScroll, "Bring All Max Dist (M)", 10, 500, Config.PlayerMgmt.BringMaxDistance, false, false, function(v) Config.PlayerMgmt.BringMaxDistance = v end)

createToggle(pmScroll, "Spectate Player", false, function(v)
	Config.PlayerMgmt.IsSpectating = v
	if not v then
		if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
			Camera.CameraSubject = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		end
	end
end)

createButton(pmScroll, "Start Ladder Fling", function()
	local targetPlr = Players:FindFirstChild(Config.PlayerMgmt.SelectedPlayer)
	if targetPlr then
		advancedLadderFlingPlayer(targetPlr)
	end
end)

createButton(pmScroll, "Stop Fling (Reset Position)", function()
	stopFlingEngine()
end)

createButton(pmScroll, "Teleport to Player", function()
	local targetPlr = Players:FindFirstChild(Config.PlayerMgmt.SelectedPlayer)
	local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if targetPlr and targetPlr.Character and targetPlr.Character:FindFirstChild("HumanoidRootPart") and myHrp then
		myHrp.CFrame = targetPlr.Character.HumanoidRootPart.CFrame * CFrame.new(0, 2, 2)
	end
end)

----------------------------------------------------------------------
-- 8. MMD TAB (YENİLENEN MM2 & MMD KATEGORİSİ)
----------------------------------------------------------------------
local mmdGroup = createTab("MMD", 8)
local mmdScroll = createScrollContainer(mmdGroup)

local mmdHeader = Instance.new("TextLabel")
mmdHeader.Size = UDim2.new(1, -6, 0, 18)
mmdHeader.BackgroundTransparency = 1
mmdHeader.Text = "MMD / MM2 KONTROL PANELİ"
mmdHeader.TextColor3 = Color3.fromRGB(240, 240, 240)
mmdHeader.TextSize = 10
mmdHeader.Font = Enum.Font.GothamBold
mmdHeader.TextXAlignment = Enum.TextXAlignment.Center
mmdHeader.Parent = mmdScroll

Config.MMD.SelectedPlayer = initialPNames[1]
local mmdDropdown = createDropdown(mmdScroll, "Player List (Auto)", initialPNames, initialPNames[1], function(opt)
	Config.MMD.SelectedPlayer = opt
end)

createToggle(mmdScroll, "Team Check", Config.MMD.TeamCheck, function(v) Config.MMD.TeamCheck = v end)
createToggle(mmdScroll, "Loop Teleport His Back", Config.MMD.LoopTpBack, function(v) Config.MMD.LoopTpBack = v end)
createSlider(mmdScroll, "Back Distance", 0.5, 1.5, Config.MMD.TpBackDistance, true, false, function(v) Config.MMD.TpBackDistance = v end)

createToggle(mmdScroll, "Loop TP All", Config.MMD.LoopTpAll, function(v) Config.MMD.LoopTpAll = v end)
createSlider(mmdScroll, "Loop TP Max Distance", 10, 1000, Config.MMD.LoopTpDistance, false, false, function(v) Config.MMD.LoopTpDistance = v end)

createToggle(mmdScroll, "Hitbox Expander 20X", Config.MMD.HitboxExpander20X, function(v) Config.MMD.HitboxExpander20X = v end)

createToggle(mmdScroll, "Role ESP", Config.MMD.RoleESP, function(v) Config.MMD.RoleESP = v end)
createToggle(mmdScroll, "Highlight ESP", Config.MMD.HighlightEsp, function(v) Config.MMD.HighlightEsp = v end)
createToggle(mmdScroll, "Role Name", Config.MMD.RoleName, function(v) Config.MMD.RoleName = v end)

createToggle(mmdScroll, "Kill All", Config.MMD.KillAll, function(v) Config.MMD.KillAll = v end)
createSlider(mmdScroll, "Kill All Range", 50, 1000, Config.MMD.KillAllMaxDistance, false, false, function(v) Config.MMD.KillAllMaxDistance = v end)

createToggle(mmdScroll, "Instant Gun Fetch", Config.MMD.AutoGrabGun, function(v) Config.MMD.AutoGrabGun = v end)
createToggle(mmdScroll, "Dropped Gun ESP", Config.MMD.DroppedGunESP, function(v) Config.MMD.DroppedGunESP = v end)

-- MMD Arka Plan Döngü ve Özellik Fonksiyonları
task.spawn(function()
	while true do
		task.wait(0.01)
		local myChar = LocalPlayer.Character
		local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
		local hum = myChar and myChar:FindFirstChildOfClass("Humanoid")
		local backpack = LocalPlayer:FindFirstChild("Backpack")

		-- Hitbox Expander 20X
		if Config.MMD.HitboxExpander20X then
			for _, p in ipairs(Players:GetPlayers()) do
				if p ~= LocalPlayer and p.Character then
					local head = p.Character:FindFirstChild("Head")
					if head and head:IsA("BasePart") then
						head.Size = Vector3.new(20, 20, 20)
						head.Transparency = 0.7
						head.CanCollide = false
					end
				end
			end
		end

		-- Loop TP Back to Selected Player
		if Config.MMD.LoopTpBack and Config.MMD.SelectedPlayer and myHrp then
			local targetPlr = Players:FindFirstChild(Config.MMD.SelectedPlayer)
			if targetPlr and targetPlr.Character and targetPlr.Character:FindFirstChild("HumanoidRootPart") then
				if not (Config.MMD.TeamCheck and targetPlr.Team == LocalPlayer.Team) then
					local targetHrp = targetPlr.Character.HumanoidRootPart
					myHrp.CFrame = targetHrp.CFrame * CFrame.new(0, 0, Config.MMD.TpBackDistance)
				end
			end
		end

		-- Loop TP All (Sırayla her oyuncunun arkasına 0.05s gidip bir sonrakine geçer)
		if Config.MMD.LoopTpAll and myHrp then
			for _, p in ipairs(Players:GetPlayers()) do
				if not Config.MMD.LoopTpAll then break end
				if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
					local targetHum = p.Character:FindFirstChildOfClass("Humanoid")
					if targetHum and targetHum.Health > 0 then
						if not (Config.MMD.TeamCheck and p.Team == LocalPlayer.Team) then
							local targetHrp = p.Character.HumanoidRootPart
							local dist = (myHrp.Position - targetHrp.Position).Magnitude
							if dist <= Config.MMD.LoopTpDistance then
								myHrp.CFrame = targetHrp.CFrame * CFrame.new(0, 0, Config.MMD.TpBackDistance)
								task.wait(0.05)
							end
						end
					end
				end
			end
		end

		-- Kill All / Knife Aura Logic for MMD
		if Config.MMD.KillAll or Config.Rage.LoopKillAll then
			if myHrp and hum and hum.Health > 0 then
				local knife = (backpack and backpack:FindFirstChild("Knife")) or myChar:FindFirstChild("Knife")
				if knife then
					if knife.Parent ~= myChar then
						hum:EquipTool(knife)
					end
					local knifeHandle = knife:FindFirstChild("Handle") or knife.PrimaryPart or knife:FindFirstChildOfClass("BasePart")
					for _, target in ipairs(Players:GetPlayers()) do
						if target ~= LocalPlayer and target.Character then
							if not (Config.MMD.TeamCheck and target.Team == LocalPlayer.Team) then
								local targetHrp = target.Character:FindFirstChild("HumanoidRootPart")
								local targetHum = target.Character:FindFirstChildOfClass("Humanoid")
								if targetHrp and targetHum and targetHum.Health > 0 then
									local dist = (myHrp.Position - targetHrp.Position).Magnitude
									local limitDist = Config.Rage.LoopKillAll and Config.Rage.KnifeRange or Config.MMD.KillAllMaxDistance
									if dist <= limitDist then
										if knifeHandle then
											safeFireTouch(knifeHandle, targetHrp, 0)
											safeFireTouch(knifeHandle, targetHrp, 1)
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
end)

-- Gun Fetch Loop for MMD
task.spawn(function()
	while true do
		task.wait(1.5)
		if Config.MMD.AutoGrabGun then
			local char = LocalPlayer.Character
			local hrp = char and char:FindFirstChild("HumanoidRootPart")
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			
			local hasGunInInventory = (LocalPlayer.Backpack and LocalPlayer.Backpack:FindFirstChild("Gun")) or (char and char:FindFirstChild("Gun"))
			if not hasGunInInventory and hrp and hum and hum.Health > 0 then
				local gunDrop = Workspace:FindFirstChild("GunDrop", true)
				if not gunDrop then
					for _, v in ipairs(Workspace:GetDescendants()) do
						if v.Name == "GunDrop" or (v:IsA("Tool") and v.Name == "Gun" and v.Parent == Workspace) then
							gunDrop = v
							break
						end
					end
				end

				if gunDrop then
					local targetPart = gunDrop:IsA("BasePart") and gunDrop or (gunDrop:FindFirstChild("Handle") or gunDrop.PrimaryPart)
					if targetPart then
						if firetouchinterest then
							safeFireTouch(hrp, targetPart, 0)
							safeFireTouch(hrp, targetPart, 1)
						else
							local oldCFrame = hrp.CFrame
							hrp.CFrame = targetPart.CFrame * CFrame.new(0, 1, 0)
							task.wait(0.001)
							hrp.CFrame = oldCFrame
						end
					end
				end
			end
		end
	end
end)

local droppedGunBillboard = Instance.new("BillboardGui")
droppedGunBillboard.Name = "KGT_DroppedGunESP"
droppedGunBillboard.Size = UDim2.new(0, 120, 0, 40)
droppedGunBillboard.AlwaysOnTop = true
droppedGunBillboard.StudsOffset = Vector3.new(0, 2, 0)

local gunLabel = Instance.new("TextLabel")
gunLabel.Size = UDim2.new(1, 0, 1, 0)
gunLabel.BackgroundTransparency = 1
gunLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
gunLabel.TextStrokeTransparency = 0.2
gunLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
gunLabel.Font = Enum.Font.GothamBold
gunLabel.TextSize = 11
gunLabel.TextXAlignment = Enum.TextXAlignment.Center
gunLabel.Parent = droppedGunBillboard

task.spawn(function()
	while true do
		task.wait(0.1)
		if Config.MMD.DroppedGunESP then
			local gunDrop = Workspace:FindFirstChild("GunDrop", true)
			if not gunDrop then
				for _, v in ipairs(Workspace:GetDescendants()) do
					if v.Name == "GunDrop" or (v:IsA("Tool") and v.Name == "Gun" and v.Parent == Workspace) then
						gunDrop = v
						break
					end
				end
			end

			if gunDrop then
				local targetPart = gunDrop:IsA("BasePart") and gunDrop or (gunDrop:FindFirstChild("Handle") or gunDrop.PrimaryPart)
				local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

				if targetPart and myHrp then
					local dist = math.floor((myHrp.Position - targetPart.Position).Magnitude)
					gunLabel.Text = "[ GUN DROP ]\n" .. dist .. "m"
					droppedGunBillboard.Adornee = targetPart
					droppedGunBillboard.Enabled = true
					droppedGunBillboard.Parent = screenGui
				else
					droppedGunBillboard.Enabled = false
				end
			else
				droppedGunBillboard.Enabled = false
			end
		else
			droppedGunBillboard.Enabled = false
		end
	end
end)

createButton(mmdScroll, "Teleport Random Innocent", function()
	local innocents = {}
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
			local bp = p:FindFirstChild("Backpack")
			local char = p.Character
			local hasKnife = (bp and bp:FindFirstChild("Knife")) or char:FindFirstChild("Knife")
			local hasGun = (bp and bp:FindFirstChild("Gun")) or char:FindFirstChild("Gun")

			if not hasKnife and not hasGun then
				table.insert(innocents, p)
			end
		end
	end

	if #innocents > 0 then
		local randomInnocent = innocents[math.random(1, #innocents)]
		local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		if myHrp and randomInnocent.Character and randomInnocent.Character:FindFirstChild("HumanoidRootPart") then
			myHrp.CFrame = randomInnocent.Character.HumanoidRootPart.CFrame * CFrame.new(0, 2, 2)
		end
	end
end)

createButton(mmdScroll, "Teleport to Map Center", function()
	local char = LocalPlayer.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local mapModel = Workspace:FindFirstChild("Map") or Workspace:FindFirstChild("Maps")
	local targetCFrame = nil

	if mapModel then
		local spawnsFolder = mapModel:FindFirstChild("Spawns", true) or mapModel:FindFirstChild("SpawnLocation", true)
		if spawnsFolder then
			if spawnsFolder:IsA("BasePart") then
				targetCFrame = spawnsFolder.CFrame
			elseif spawnsFolder:IsA("Model") or spawnsFolder:IsA("Folder") then
				local spawns = spawnsFolder:GetChildren()
				if #spawns > 0 then
					local rnd = spawns[math.random(1, #spawns)]
					if rnd:IsA("BasePart") then
						targetCFrame = rnd.CFrame
					end
				end
			end
		end
	end

	if targetCFrame then
		hrp.CFrame = targetCFrame * CFrame.new(0, 3, 0)
	else
		local totalPos = Vector3.zero
		local validCount = 0

		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
				local pHum = p.Character:FindFirstChildOfClass("Humanoid")
				if pHum and pHum.Health > 0 then
					totalPos = totalPos + p.Character.HumanoidRootPart.Position
					validCount = validCount + 1
				end
			end
		end

		if validCount > 0 then
			local centerPos = totalPos / validCount
			local randomOffset = Vector3.new(math.random(-5, 5), 3, math.random(-5, 5))
			hrp.CFrame = CFrame.new(centerPos + randomOffset)
		end
	end
end)

-- Default Active Tab
currentActiveTab = "Rage"
tabs["Rage"].Visible = true
tabButtons["Rage"].Button.BackgroundTransparency = 0
tabButtons["Rage"].Label.TextColor3 = Color3.fromRGB(20, 20, 24)

-- Dynamic Player List Event Connectors
local function refreshPlayerDropdowns()
	local updatedNames = getOtherPlayerNames()
	pmDropdown:Refresh(updatedNames)
	mmdDropdown:Refresh(updatedNames)
end

-- ESP CORE SYSTEM
local espCache = {}

local function createESPForPlayer(plr)
	if plr == LocalPlayer then return end

	local boxFrame = Instance.new("Frame")
	boxFrame.Name = "ESP_Box_" .. plr.Name
	boxFrame.BackgroundTransparency = 1
	boxFrame.Visible = false
	boxFrame.Parent = screenGui

	local boxStroke = Instance.new("UIStroke")
	boxStroke.Thickness = 1.2
	boxStroke.Color = Config.ESP.BoxColor
	boxStroke.Parent = boxFrame

	local healthBarBg = Instance.new("Frame")
	healthBarBg.Name = "HealthBg"
	healthBarBg.Size = UDim2.new(0, 3, 1, 0)
	healthBarBg.Position = UDim2.new(0, -6, 0, 0)
	healthBarBg.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
	healthBarBg.BorderSizePixel = 0
	healthBarBg.Parent = boxFrame

	local healthBarFill = Instance.new("Frame")
	healthBarFill.Name = "HealthFill"
	healthBarFill.Size = UDim2.new(1, 0, 1, 0)
	healthBarFill.Position = UDim2.new(0, 0, 1, 0)
	healthBarFill.AnchorPoint = Vector2.new(0, 1)
	healthBarFill.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
	healthBarFill.BorderSizePixel = 0
	healthBarFill.Parent = healthBarBg

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.new(1, 0, 0, 14)
	nameLabel.Position = UDim2.new(0, 0, 0, -18)
	nameLabel.BackgroundTransparency = 1
	nameLabel.TextColor3 = Config.ESP.NameColor
	nameLabel.TextStrokeTransparency = 0.3
	nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.TextSize = Config.ESP.NameSize
	nameLabel.TextXAlignment = Enum.TextXAlignment.Center
	nameLabel.Text = plr.Name
	nameLabel.Parent = boxFrame

	local distLabel = Instance.new("TextLabel")
	distLabel.Size = UDim2.new(1, 0, 0, 14)
	distLabel.Position = UDim2.new(0, 0, 1, 2)
	distLabel.BackgroundTransparency = 1
	distLabel.TextColor3 = Config.ESP.DistanceColor
	distLabel.TextStrokeTransparency = 0.3
	distLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	distLabel.Font = Enum.Font.GothamMedium
	distLabel.TextSize = 10
	distLabel.TextXAlignment = Enum.TextXAlignment.Center
	distLabel.Parent = boxFrame

	local tracerLine = Instance.new("Frame")
	tracerLine.Name = "ESP_Tracer_" .. plr.Name
	tracerLine.AnchorPoint = Vector2.new(0.5, 0.5)
	tracerLine.BackgroundColor3 = Config.ESP.TracerColor
	tracerLine.BorderSizePixel = 0
	tracerLine.Visible = false
	tracerLine.Parent = screenGui

	local highlight = Instance.new("Highlight")
	highlight.Name = "ESP_Highlight_" .. plr.Name
	highlight.FillColor = Config.ESP.HighlightColor
	highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
	highlight.FillTransparency = 0.5

	espCache[plr] = {
		BoxFrame = boxFrame,
		BoxStroke = boxStroke,
		HealthBarBg = healthBarBg,
		HealthBarFill = healthBarFill,
		NameLabel = nameLabel,
		DistLabel = distLabel,
		TracerLine = tracerLine,
		Highlight = highlight
	}
end

local function removeESPForPlayer(plr)
	if espCache[plr] then
		if espCache[plr].BoxFrame then espCache[plr].BoxFrame:Destroy() end
		if espCache[plr].TracerLine then espCache[plr].TracerLine:Destroy() end
		if espCache[plr].Highlight then espCache[plr].Highlight:Destroy() end
		espCache[plr] = nil
	end
end

for _, p in ipairs(Players:GetPlayers()) do createESPForPlayer(p) end

local playerAddedConnection = Players.PlayerAdded:Connect(function(p)
	createESPForPlayer(p)
	refreshPlayerDropdowns()
end)

local playerRemovingConnection = Players.PlayerRemoving:Connect(function(p)
	removeESPForPlayer(p)
	refreshPlayerDropdowns()
end)

-- SILENT AIM & METAMETHOD HOOKING Altyapısı
local function getMurdererPlayer()
	for _, p in ipairs(Players:GetPlayers()) do
		if p.Character then
			local bp = p:FindFirstChild("Backpack")
			local char = p.Character
			local hasKnife = (bp and bp:FindFirstChild("Knife")) or (char and char:FindFirstChild("Knife"))
			if hasKnife then
				return p
			end
		end
	end
	return nil
end

pcall(function()
	if hookmetamethod and getnamecallmethod then
		local oldNamecall
		oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
			local method = getnamecallmethod()
			local args = {...}
			if Config.Rage.SilentAim and (method == "FireServer" or method == "InvokeServer") then
				local murderer = getMurdererPlayer()
				if murderer and murderer.Character and murderer.Character:FindFirstChild("Head") then
					for i, v in ipairs(args) do
						if typeof(v) == "Vector3" then
							args[i] = murderer.Character.Head.Position
						elseif typeof(v) == "CFrame" then
							args[i] = CFrame.new(murderer.Character.Head.Position)
						end
					end
				end
			end
			return oldNamecall(self, unpack(args))
		end)
	end
end)

-- REFINED AIMBOT / TARGET FINDER
local function getClosestPlayerInFOV()
	local closestPlayer = nil
	local shortestDistance = Config.Aimbot.FOVRadius
	local viewportSize = Camera.ViewportSize
	local refPos = (Config.Aimbot.FOVType == "Center") and Vector2.new(viewportSize.X / 2, viewportSize.Y / 2) or UserInputService:GetMouseLocation()

	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer then
			local char = plr.Character
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			local targetPart = char and char:FindFirstChild(Config.Aimbot.TargetBone)

			if char and hum and hum.Health > 0 and targetPart then
				if not (Config.ESP.TeamCheck and plr.Team == LocalPlayer.Team) then
					local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
					if onScreen and screenPos.Z > 0 then
						local screen2D = Vector2.new(screenPos.X, screenPos.Y)
						local dist = (screen2D - refPos).Magnitude
						if dist <= shortestDistance then
							shortestDistance = dist
							closestPlayer = plr
						end
					end
				end
			end
		end
	end
	return closestPlayer
end

local renderConnection

local function cleanupEverything()
	if renderConnection then renderConnection:Disconnect() end
	if playerAddedConnection then playerAddedConnection:Disconnect() end
	if playerRemovingConnection then playerRemovingConnection:Disconnect() end
	if jumpConnection then jumpConnection:Disconnect() end
	if godConnection then godConnection:Disconnect() end
	if invisConnection then invisConnection:Disconnect() end
	if speedLockConnection then speedLockConnection:Disconnect() end
	if hipHeightConnection then hipHeightConnection:Disconnect() end
	if noclipConnection then noclipConnection:Disconnect() end
	if flyConnection then flyConnection:Disconnect() end

	Config.ESP.Enabled = false
	Config.Aimbot.Enabled = false
	Config.Aimbot.TriggerBot = false
	Config.Aimbot.RageBot = false
	Config.Aimbot.MobileAimbot = false
	Config.Rage.KnifeAura = false
	Config.Rage.LoopKillAll = false
	Config.Rage.SilentAim = false
	Config.Rage.Spinbot = false
	Config.Rage.Desync = false
	Config.Rage.HitboxExpander = false
	Config.Rage.LagSwitch = false
	Config.Rage.AutoTrashTalk = false
	Config.Player.InfiniteJump = false
	Config.Player.Spider = false
	Config.Player.GodMode = false
	Config.Player.Invisible = false
	Config.Player.Noclip = false
	Config.Player.Fly = false
	Config.Player.MobileFly = false
	Config.Player.HipHeightEnabled = false
	Config.MMD.KillAll = false
	Config.MMD.DroppedGunESP = false
	Config.MMD.LoopTpBack = false
	Config.MMD.LoopTpAll = false
	Config.MMD.HitboxExpander20X = false

	stopFlingEngine()

	for plr, esp in pairs(espCache) do
		if esp.BoxFrame then esp.BoxFrame:Destroy() end
		if esp.TracerLine then esp.TracerLine:Destroy() end
		if esp.Highlight then esp.Highlight:Destroy() end
	end
	table.clear(espCache)

	if droppedGunBillboard then droppedGunBillboard:Destroy() end

	if LocalPlayer.Character then
		for _, v in ipairs(LocalPlayer.Character:GetDescendants()) do
			if v:IsA("BasePart") or v:IsA("Decal") then
				v.LocalTransparencyModifier = 0
			end
		end
		local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.WalkSpeed = 16
			hum.JumpPower = 50
			hum.HipHeight = 2
			hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
		end
	end

	if blur then blur:Destroy() end
	screenGui:Destroy()
end

yesBtn.MouseButton1Click:Connect(cleanupEverything)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.RightShift then
		setMenuVisible(not isOpen)
	end
end)

-- MAIN RENDER LOOP
renderConnection = RunService.RenderStepped:Connect(function()
	local myChar = LocalPlayer.Character
	local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")

	-- Update FOV Circle Position
	if Config.Aimbot.DrawFOV then
		fovCircle.Visible = true
		if Config.Aimbot.FOVType == "Center" then
			fovCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
			fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
		else
			local mouseLoc = UserInputService:GetMouseLocation()
			fovCircle.Position = UDim2.new(0, mouseLoc.X, 0, mouseLoc.Y)
			fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
		end
	else
		fovCircle.Visible = false
	end

	if myHrp then
		-- Spinbot (Anti-Aim)
		if Config.Rage.Spinbot then
			myHrp.CFrame = myHrp.CFrame * CFrame.Angles(0, math.rad(50), 0)
		end

		-- Desync (Ghost Hitbox)
		if Config.Rage.Desync then
			pcall(function()
				myHrp.AssemblyLinearVelocity = Vector3.new(math.random(-50, 50), 0, math.random(-50, 50))
			end)
		end

		-- Lag Switch
		if Config.Rage.LagSwitch then
			pcall(function()
				settings():GetService("NetworkSettings"):SetIncomingReplicationLag(9999)
			end)
		else
			pcall(function()
				settings():GetService("NetworkSettings"):SetIncomingReplicationLag(0)
			end)
		end

		-- Bring Him Loop
		if Config.PlayerMgmt.BringHimLoop and Config.PlayerMgmt.SelectedPlayer then
			local targetPlr = Players:FindFirstChild(Config.PlayerMgmt.SelectedPlayer)
			if targetPlr and targetPlr.Character and targetPlr.Character:FindFirstChild("HumanoidRootPart") then
				local targetHrp = targetPlr.Character.HumanoidRootPart
				targetHrp.CFrame = myHrp.CFrame * CFrame.new(0, 0, -Config.PlayerMgmt.BringDistance)
			end
		end

		-- Bring All Loop
		if Config.PlayerMgmt.BringAllLoop then
			for _, p in ipairs(Players:GetPlayers()) do
				if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
					local targetHrp = p.Character.HumanoidRootPart
					local dist = (targetHrp.Position - myHrp.Position).Magnitude
					if dist <= Config.PlayerMgmt.BringMaxDistance then
						targetHrp.CFrame = myHrp.CFrame * CFrame.new(0, 0, -Config.PlayerMgmt.BringDistance)
					end
				end
			end
		end

		-- Spectate Camera System
		if Config.PlayerMgmt.IsSpectating and Config.PlayerMgmt.SelectedPlayer then
			local targetPlr = Players:FindFirstChild(Config.PlayerMgmt.SelectedPlayer)
			if targetPlr and targetPlr.Character and targetPlr.Character:FindFirstChildOfClass("Humanoid") then
				Camera.CameraSubject = targetPlr.Character:FindFirstChildOfClass("Humanoid")
			end
		end
	end

	-- Hitbox Expander Loop
	if Config.Rage.HitboxExpander then
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= LocalPlayer and p.Character then
				local head = p.Character:FindFirstChild("Head")
				if head and head:IsA("BasePart") then
					head.Size = Vector3.new(Config.Rage.HitboxSize, Config.Rage.HitboxSize, Config.Rage.HitboxSize)
					head.Transparency = 0.6
					head.CanCollide = false
				end
			end
		end
	end

	-- Knife Aura / Range Extender Loop
	if Config.Rage.KnifeAura and myHrp then
		local backpack = LocalPlayer:FindFirstChild("Backpack")
		local knife = (backpack and backpack:FindFirstChild("Knife")) or (myChar and myChar:FindFirstChild("Knife"))
		if knife then
			if knife.Parent ~= myChar then
				local hum = myChar:FindFirstChildOfClass("Humanoid")
				if hum then hum:EquipTool(knife) end
			end
			local knifeHandle = knife:FindFirstChild("Handle") or knife.PrimaryPart or knife:FindFirstChildOfClass("BasePart")
			if knifeHandle then
				for _, target in ipairs(Players:GetPlayers()) do
					if target ~= LocalPlayer and target.Character then
						local targetHrp = target.Character:FindFirstChild("HumanoidRootPart")
						local targetHum = target.Character:FindFirstChildOfClass("Humanoid")
						if targetHrp and targetHum and targetHum.Health > 0 then
							if (myHrp.Position - targetHrp.Position).Magnitude <= Config.Rage.KnifeRange then
								safeFireTouch(knifeHandle, targetHrp, 0)
								safeFireTouch(knifeHandle, targetHrp, 1)
							end
						end
					end
				end
			end
		end
	end

	-- Spider Mechanism
	if Config.Player.Spider and myHrp then
		local ray = Ray.new(myHrp.Position, myHrp.CFrame.LookVector * 2.5)
		local part = Workspace:FindPartOnRay(ray, myChar)
		if part then myHrp.Velocity = Vector3.new(myHrp.Velocity.X, 30, myHrp.Velocity.Z) end
	end

	-- Aimbot Loop
	if Config.Aimbot.Enabled and (Config.Aimbot.MobileAimbot or UserInputService:IsMouseButtonPressed(Config.Aimbot.AimKey)) then
		local targetPlayer = getClosestPlayerInFOV()
		if targetPlayer and targetPlayer.Character then
			local targetPart = targetPlayer.Character:FindFirstChild(Config.Aimbot.TargetBone)
			if targetPart then
				local lerpFactor = math.clamp(Config.Aimbot.Smoothness * 0.08, 0.02, 0.8)
				Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, targetPart.Position), lerpFactor)
			end
		end
	end

	-- TriggerBot Loop
	if Config.Aimbot.TriggerBot then
		local mouse = LocalPlayer:GetMouse()
		local target = mouse.Target
		if target and target.Parent then
			local char = target.Parent:FindFirstChildOfClass("Humanoid") and target.Parent or (target.Parent.Parent and target.Parent.Parent:FindFirstChildOfClass("Humanoid") and target.Parent.Parent)
			if char and char ~= LocalPlayer.Character then
				local plr = Players:GetPlayerFromCharacter(char)
				if plr then
					if not (Config.Aimbot.TriggerBotTeamCheck and plr.Team == LocalPlayer.Team) then
						local hum = char:FindFirstChildOfClass("Humanoid")
						local headPart = char:FindFirstChild(Config.Aimbot.TargetBone) or char:FindFirstChild("HumanoidRootPart")
						if hum and hum.Health > 0 and headPart then
							local screenPos, onScreen = Camera:WorldToViewportPoint(headPart.Position)
							if onScreen then
								local refPos = (Config.Aimbot.FOVType == "Center") and Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2) or UserInputService:GetMouseLocation()
								local distToRef = (Vector2.new(screenPos.X, screenPos.Y) - refPos).Magnitude
								if distToRef <= Config.Aimbot.FOVRadius then
									pcall(function()
										mouse1click()
									end)
								end
							end
						end
					end
				end
			end
		end
	end

	-- RageBot Loop
	if Config.Aimbot.RageBot then
		local targetPlayer = getClosestPlayerInFOV()
		if targetPlayer and targetPlayer.Character then
			local targetPart = targetPlayer.Character:FindFirstChild(Config.Aimbot.TargetBone) or targetPlayer.Character:FindFirstChild("HumanoidRootPart")
			if targetPart then
				local distToMe = myHrp and (myHrp.Position - targetPart.Position).Magnitude or 0
				if distToMe <= Config.Aimbot.RageBotRange then
					Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPart.Position)
					if Config.Aimbot.RageBotAutoFire then
						pcall(function()
							mouse1click()
						end)
					end
				end
			end
		end
	end

	-- Players ESP Loop
	if myHrp then
		local viewportSize = Camera.ViewportSize

		for plr, esp in pairs(espCache) do
			local char = plr.Character
			local hrpPart = char and char:FindFirstChild("HumanoidRootPart")
			local headPart = char and char:FindFirstChild("Head")
			local hum = char and char:FindFirstChildOfClass("Humanoid")

			if Config.ESP.Enabled and char and hrpPart and headPart and hum and hum.Health > 0 then
				local dist = (myHrp.Position - hrpPart.Position).Magnitude
				local isSameTeam = Config.ESP.TeamCheck and (plr.Team == LocalPlayer.Team)

				if dist <= Config.ESP.MaxDistance and not isSameTeam then
					local hrpPos, hrpOnScreen = Camera:WorldToViewportPoint(hrpPart.Position)

					if hrpPos.Z > 0 and hrpOnScreen then
						local factor = 1 / (hrpPos.Z * math.tan(math.rad(Camera.FieldOfView * 0.5)) * 2)
						local boxHeight = math.clamp(factor * 4.5 * viewportSize.Y, 10, 800)
						local boxWidth = boxHeight * 0.6

						local boxX = hrpPos.X - (boxWidth / 2)
						local boxY = hrpPos.Y - (boxHeight / 2)

						if Config.ESP.Box then
							esp.BoxFrame.Size = UDim2.new(0, boxWidth, 0, boxHeight)
							esp.BoxFrame.Position = UDim2.new(0, boxX, 0, boxY)
							esp.BoxStroke.Color = Config.ESP.BoxColor
							esp.BoxFrame.Visible = true

							if Config.ESP.Health then
								esp.HealthBarBg.Visible = true
								local hpPct = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
								esp.HealthBarFill.Size = UDim2.new(1, 0, hpPct, 0)
								esp.HealthBarFill.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
							else
								esp.HealthBarBg.Visible = false
							end

							local roleText = ""
							local roleColor = Color3.fromRGB(240, 240, 240)

							if Config.MMD.RoleESP then
								local backpack = plr:FindFirstChild("Backpack")
								local hasGun = (backpack and backpack:FindFirstChild("Gun")) or (char and char:FindFirstChild("Gun"))
								local hasKnife = (backpack and backpack:FindFirstChild("Knife")) or (char and char:FindFirstChild("Knife"))

								if hasKnife then
									roleText = " [Murderer]"
									roleColor = ColorPresets["White"]
								elseif hasGun then
									roleText = " [Sheriff]"
									roleColor = ColorPresets["Blue"]
								else
									roleText = " [Innocent]"
									roleColor = ColorPresets["Green"]
								end
							end

							if Config.ESP.Name then
								esp.NameLabel.Visible = true
								if Config.MMD.RoleESP and Config.MMD.RoleName then
									esp.NameLabel.Text = plr.Name .. roleText
									esp.NameLabel.TextColor3 = roleColor
								else
									esp.NameLabel.Text = plr.Name
									esp.NameLabel.TextColor3 = Config.ESP.NameColor
								end
							else
								esp.NameLabel.Visible = false
							end

							esp.DistLabel.Visible = Config.ESP.Distance
							esp.DistLabel.Text = "[" .. math.floor(dist) .. "m]"
							esp.DistLabel.TextColor3 = Config.ESP.DistanceColor
						else
							esp.BoxFrame.Visible = false
						end

						if Config.ESP.Tracer then
							local startPoint = Vector2.new(viewportSize.X / 2, viewportSize.Y)
							if Config.ESP.TracerOrigin == "Top" then
								startPoint = Vector2.new(viewportSize.X / 2, 0)
							elseif Config.ESP.TracerOrigin == "Center" then
								startPoint = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
							elseif Config.ESP.TracerOrigin == "Mouse" then
								startPoint = UserInputService:GetMouseLocation()
							end

							local targetPoint = Vector2.new(hrpPos.X, hrpPos.Y + (boxHeight / 2))
							local distance = (targetPoint - startPoint).Magnitude
							local angle = math.atan2(targetPoint.Y - startPoint.Y, targetPoint.X - startPoint.X)

							esp.TracerLine.Size = UDim2.new(0, distance, 0, 1)
							esp.TracerLine.Position = UDim2.new(0, (startPoint.X + targetPoint.X) / 2, 0, (startPoint.Y + targetPoint.Y) / 2)
							esp.TracerLine.Rotation = math.deg(angle)
							esp.TracerLine.BackgroundColor3 = Config.ESP.TracerColor
							esp.TracerLine.Visible = true
						else
							esp.TracerLine.Visible = false
						end

						if Config.ESP.Highlight and Config.MMD.RoleESP and Config.MMD.HighlightEsp then
							esp.Highlight.Parent = char
							local backpack = plr:FindFirstChild("Backpack")
							local hasGun = (backpack and backpack:FindFirstChild("Gun")) or (char and char:FindFirstChild("Gun"))
							local hasKnife = (backpack and backpack:FindFirstChild("Knife")) or (char and char:FindFirstChild("Knife"))

							if hasKnife then
								esp.Highlight.FillColor = ColorPresets["White"]
							elseif hasGun then
								esp.Highlight.FillColor = ColorPresets["Blue"]
							else
								esp.Highlight.FillColor = ColorPresets["Green"]
							end
							esp.Highlight.Enabled = true
						elseif Config.ESP.Highlight then
							esp.Highlight.Parent = char
							esp.Highlight.FillColor = Config.ESP.HighlightColor
							esp.Highlight.Enabled = true
						else
							esp.Highlight.Enabled = false
						end
					else
						esp.BoxFrame.Visible = false
						esp.TracerLine.Visible = false
						esp.Highlight.Enabled = false
					end
				else
					esp.BoxFrame.Visible = false
					esp.TracerLine.Visible = false
					esp.Highlight.Enabled = false
				end
			else
				esp.BoxFrame.Visible = false
				esp.TracerLine.Visible = false
				esp.Highlight.Enabled = false
			end
		end
	end
end)
