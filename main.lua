-- Steal a brainrot LTM Jump For Egg Script | loading screen
-- Standalone visual only: run it on its own. It shows the loading screen for LOAD_TIME seconds, then fades out.
do
	local LOAD_TIME = 300 -- total wait in seconds (5 minutes)
	local FAST_TIME = 3   -- seconds to go from 1% to 99%
	local SEGS = 25

	local TS = game:GetService("TweenService")
	local HUI = (gethui and gethui()) or game:GetService("CoreGui")
	local G = getgenv and getgenv() or _G
	if G.StarHubLoader then pcall(function() G.StarHubLoader:Destroy() end) end
	local old = HUI:FindFirstChild("StarHubLoading")
	if old then old:Destroy() end

	local RED, DARK, HOT = Color3.fromRGB(200, 45, 45), Color3.fromRGB(96, 18, 22), Color3.fromRGB(255, 120, 90)
	local YEL, BROWN = Color3.fromRGB(255, 214, 10), Color3.fromRGB(122, 70, 4)
	local NAVY, LIT = Color3.fromRGB(18, 20, 48), Color3.fromRGB(255, 240, 150)
	local STONE1, STONE2 = Color3.fromRGB(112, 112, 118), Color3.fromRGB(140, 140, 146)
	local rnd = Random.new()

	local function new(class, props, parent)
		local o = Instance.new(class)
		for k, v in pairs(props) do o[k] = v end
		o.Parent = parent
		return o
	end
	local function round(p, r) new("UICorner", { CornerRadius = UDim.new(0, r or 4) }, p) end
	local function text(parent, props)
		props.BackgroundTransparency = 1
		props.Font = props.Font or Enum.Font.Arcade
		props.TextColor3 = props.TextColor3 or Color3.new(1, 1, 1)
		return new("TextLabel", props, parent)
	end
	local function pixels(parent, map, pal, px, x, y)
		local f = new("Frame", { Position = UDim2.fromOffset(x, y), Size = UDim2.fromOffset(#map[1] * px, #map * px), BackgroundTransparency = 1 }, parent)
		for r, row in ipairs(map) do
			for c = 1, #row do
				local k = row:sub(c, c)
				if k ~= "." then
					new("Frame", { Position = UDim2.fromOffset((c - 1) * px, (r - 1) * px), Size = UDim2.fromOffset(px, px), BackgroundColor3 = pal[k], BorderSizePixel = 0 }, f)
				end
			end
		end
		return f
	end

	local gui = new("ScreenGui", { Name = "StarHubLoading", ResetOnSpawn = false, IgnoreGuiInset = true, DisplayOrder = 1000 }, HUI)
	local root = new("CanvasGroup", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0), Active = true, GroupTransparency = 1 }, gui)
	local bg = new("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0 }, root)
	new("UIGradient", { Rotation = 90, Color = ColorSequence.new(Color3.fromRGB(64, 14, 17), Color3.fromRGB(12, 5, 7)) }, bg)

	for i = 1, 16 do -- drifting pixel sparks
		local s, x = rnd:NextInteger(4, 8), rnd:NextNumber()
		local p = new("Frame", { Position = UDim2.fromScale(x, 1.05), Size = UDim2.fromOffset(s, s), BackgroundColor3 = i % 3 == 0 and RED or YEL, BackgroundTransparency = 0.6, BorderSizePixel = 0 }, root)
		task.delay(rnd:NextNumber() * 6, function()
			if p.Parent then
				TS:Create(p, TweenInfo.new(rnd:NextNumber(7, 13), Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1), { Position = UDim2.fromScale(x, -0.05) }):Play()
			end
		end)
	end

	local vp = workspace.CurrentCamera.ViewportSize
	local base = math.min(1, vp.X / 460, vp.Y / 320)
	local holder = new("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(420, 276), BackgroundTransparency = 1 }, root)
	local sc = new("UIScale", { Scale = base * 0.85 }, holder)
	for _, g in ipairs({ { 16, 0.95 }, { 10, 0.9 }, { 5, 0.84 } }) do -- breathing glow
		local gf = new("Frame", { Position = UDim2.fromOffset(-g[1], -g[1]), Size = UDim2.fromOffset(420 + g[1] * 2, 276 + g[1] * 2), BackgroundColor3 = YEL, BackgroundTransparency = g[2], BorderSizePixel = 0 }, holder)
		round(gf, 14)
		TS:Create(gf, TweenInfo.new(1.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), { BackgroundTransparency = g[2] - 0.05 }):Play()
	end
	round(new("Frame", { Position = UDim2.fromOffset(5, 8), Size = UDim2.fromOffset(420, 276), BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = 0.45, BorderSizePixel = 0 }, holder), 6)
	local card = new("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = RED }, holder)
	round(card, 6)
	new("UIStroke", { Color = STONE1, Thickness = 4 }, card)

	-- marquee: chasing bulbs + twinkling pixel stars
	local marquee = new("Frame", { Position = UDim2.fromOffset(12, 12), Size = UDim2.fromOffset(396, 36), BackgroundColor3 = NAVY }, card)
	round(marquee, 3)
	local bulbs = {}
	for i = 0, 15 do
		bulbs[i] = { new("Frame", { Position = UDim2.fromOffset(9 + i * 24, 3), Size = UDim2.fromOffset(6, 3), BackgroundColor3 = YEL, BorderSizePixel = 0 }, marquee),
			new("Frame", { Position = UDim2.fromOffset(9 + i * 24, 30), Size = UDim2.fromOffset(6, 3), BackgroundColor3 = DARK, BorderSizePixel = 0 }, marquee) }
	end
	text(marquee, { Position = UDim2.fromOffset(0, 4), Size = UDim2.new(1, 0, 1, -4), Text = "STEAL A BRAINROT", TextSize = 22, TextColor3 = YEL })
	local STAR = { "...Y...", "..YYY..", "YYYYYYY", ".YYYYY.", "..YYY..", ".YY.YY.", "YY...YY" }
	local star1 = pixels(marquee, STAR, { Y = YEL }, 2, 56, 11)
	local star2 = pixels(marquee, STAR, { Y = YEL }, 2, 326, 11)

	text(card, {
		Position = UDim2.fromOffset(12, 54), Size = UDim2.fromOffset(396, 40), Font = Enum.Font.GothamBold, TextSize = 16, TextWrapped = true, RichText = true,
		Text = 'Steal a brainrot <font color="#FFD60A">LTM Jump For Egg Script</font>',
	})

	-- arcade screen
	local screen = new("Frame", { Position = UDim2.fromOffset(12, 100), Size = UDim2.fromOffset(396, 120), BackgroundColor3 = YEL, ClipsDescendants = true }, card)
	round(screen, 4)
	new("UIStroke", { Color = DARK, Thickness = 3 }, screen)
	local pctSh = text(screen, { Position = UDim2.fromOffset(16, 10), Size = UDim2.fromOffset(160, 40), Text = "1%", TextSize = 38, TextColor3 = BROWN, TextTransparency = 0.55, TextXAlignment = Enum.TextXAlignment.Left })
	local pctLbl = text(screen, { Position = UDim2.fromOffset(14, 8), Size = UDim2.fromOffset(160, 40), Text = "1%", TextSize = 38, TextColor3 = DARK, TextXAlignment = Enum.TextXAlignment.Left })
	local timeLbl = text(screen, { Position = UDim2.new(1, -184, 0, 16), Size = UDim2.fromOffset(170, 24), Text = "", TextSize = 16, TextColor3 = BROWN, TextXAlignment = Enum.TextXAlignment.Right })
	local tube = new("Frame", { Position = UDim2.fromOffset(10, 55), Size = UDim2.fromOffset(376, 26), BackgroundColor3 = DARK }, screen)
	round(tube, 3)
	local segs = {}
	for i = 1, SEGS do
		segs[i] = new("Frame", { Position = UDim2.fromOffset(4 + (i - 1) * 14.72, 3), Size = UDim2.fromOffset(12, 20), BackgroundColor3 = BROWN, BorderSizePixel = 0 }, tube)
		round(segs[i], 2)
	end
	local status = text(screen, { Position = UDim2.fromOffset(14, 88), Size = UDim2.fromOffset(368, 22), Text = "> Starting up", TextSize = 15, TextColor3 = BROWN, TextXAlignment = Enum.TextXAlignment.Left })
	local shine = new("Frame", { Position = UDim2.fromOffset(-80, -20), Size = UDim2.fromOffset(36, 170), Rotation = 20, BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 0.82, BorderSizePixel = 0 }, screen)
	TS:Create(shine, TweenInfo.new(1.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1, false, 3), { Position = UDim2.fromOffset(440, -20) }):Play()
	for y = 0, 120, 6 do
		new("Frame", { Position = UDim2.fromOffset(0, y), Size = UDim2.new(1, 0, 0, 2), BackgroundColor3 = DARK, BackgroundTransparency = 0.9, BorderSizePixel = 0 }, screen)
	end

	-- stone base, "please wait" prompt, hopping pixel eggs
	for i = 0, 11 do
		round(new("Frame", { Position = UDim2.fromOffset(12 + i * 33, 250), Size = UDim2.fromOffset(32, 20), BackgroundColor3 = i % 2 == 0 and STONE1 or STONE2 }, card), 2)
	end
	local wait = text(card, { Position = UDim2.fromOffset(60, 228), Size = UDim2.fromOffset(300, 20), Text = "PLEASE WAIT", TextSize = 14, TextColor3 = YEL })
	local dots = text(card, { Position = UDim2.fromOffset(212 + wait.TextBounds.X / 2, 228), Size = UDim2.fromOffset(40, 20), Text = "", TextSize = 14, TextColor3 = YEL, TextXAlignment = Enum.TextXAlignment.Left })
	local EGG = { "..OOOO..", ".OYYHYO.", ".OYHYYO.", "OYYYYYYO", "OYRRRRYO", "OYYYYYSO", "OYYYYSSO", ".OYYSSO.", "..OOOO.." }
	local PAL = { O = Color3.fromRGB(70, 34, 0), Y = YEL, H = LIT, S = Color3.fromRGB(226, 150, 16), R = RED }
	local function egg(x, delay)
		local e = pixels(card, EGG, PAL, 3, x, 223)
		task.delay(delay, function()
			if e.Parent then
				TS:Create(e, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, -1, true), { Position = UDim2.fromOffset(x, 205) }):Play()
			end
		end)
	end
	egg(18, 0)
	egg(378, 0.4)

	G.StarHubLoader = { Destroy = function() pcall(function() gui:Destroy() end) end }
	TS:Create(root, TweenInfo.new(0.4), { GroupTransparency = 0 }):Play()
	TS:Create(sc, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = base }):Play()

	local MSGS = { "Loading egg data", "Scanning the track", "Preparing Auto Egg", "Preparing Level Farm", "Setting up Egg ESP", "Almost ready" }
	local t0, blink, lastKey = os.clock(), -1, -1
	while true do
		if not gui.Parent then return end -- re-executed: stop this run
		local e = os.clock() - t0
		if e >= LOAD_TIME then break end
		local pct = 99
		if e < FAST_TIME then
			local x = e / FAST_TIME
			pct = 1 + 98 * (1 - (1 - x) ^ 2)
		end
		local n = math.floor(pct / 100 * SEGS + 0.5)
		local chase = e >= FAST_TIME and (math.floor(e * 14) % n) + 1 or 0
		if n * 100 + chase ~= lastKey then
			lastKey = n * 100 + chase
			for i = 1, SEGS do segs[i].BackgroundColor3 = i > n and BROWN or (i == chase and HOT or RED) end
		end
		pctLbl.Text = math.floor(pct) .. "%"
		pctSh.Text = pctLbl.Text
		local left = math.ceil(LOAD_TIME - e)
		timeLbl.Text = string.format("%d:%02d left", left // 60, left % 60)
		if e >= FAST_TIME then status.Text = "> " .. MSGS[(math.floor((e - FAST_TIME) / 4) % #MSGS) + 1] end
		local b = math.floor(e / 0.4)
		if b ~= blink then
			blink = b
			for i = 0, 15 do
				local on = (i + b) % 2 == 0
				bulbs[i][1].BackgroundColor3 = on and YEL or DARK
				bulbs[i][2].BackgroundColor3 = on and DARK or YEL
			end
			star1.Visible, star2.Visible = b % 2 == 0, b % 2 == 1
			dots.Text = string.rep(".", b % 4)
		end
		task.wait()
	end

	for i = 1, SEGS do segs[i].BackgroundColor3 = RED end
	pctLbl.Text, pctSh.Text, timeLbl.Text, status.Text, dots.Text = "100%", "100%", "", "> Ready!", ""
	wait.Text = "READY"
	task.wait(0.5)
	TS:Create(root, TweenInfo.new(0.5), { GroupTransparency = 1 }):Play()
	task.wait(0.55)
	gui:Destroy()
	G.StarHubLoader = nil
end
