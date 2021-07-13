
version = '18'
local UI = game:GetObjects('rbxassetid://7087324242&version='..version)[1]
UI.Parent = game:GetService('CoreGui')

--/ Folder System
if isfolder and makefolder and isfile and writefile then
    if not isfolder('Test-Hub') then makefolder('Test-Hub') end
    if not isfolder('Test-Hub/Presets') then makefolder('Test-Hub/Presets') end
    if not isfolder('Test-Hub/Theme') then makefolder('Test-Hub/Theme') end
    if isfile('Test-Hub/Loader.la') then delfile('Test-Hub/Loader.la') 
    else warn('[Test-Hub] Visuals loaded, Skipped') end
    if not isfile('Test-Hub/Presets/Default.preset') then writefile('Test-Hub/Presets/Default.preset', [[
    for i, v in next, tools do
        coroutine.wrap(
            function()
                local BP, BG, F = v.POSV.Value, v.GYROV.Value
                local a, vol = 1, 0
                while vis do
                    vol = tools[#tools].Handle.Sound.PlaybackLoudness / sens
                    ro = math.rad(a / 2 + (i * (360 / #tools)))
                    F = CFrame.new(torso.Position) * CFrame.Angles(0, ro, 0) * CFrame.new(0, 0, vol + offset)
                    BP.Position = F.p
                    BG.CFrame = CFrame.new(BG.Parent.Position, torso.Position + Vector3.new(0,tilt,0))
                    a = a + speed / 2.5
                    game:GetService("RunService").Heartbeat:wait()
                    v.Handle.Velocity = Vector3.new(0, 24.9863, 0)
		            v.Handle.AssemblyLinearVelocity = Vector3.new(30,0,0)
                end
            end
        )()
    end
]]) end
end

local List = listfiles('Test-Hub/Presets')
--\

--/ Main Locals
local Player = game:GetService('Players').LocalPlayer
local Char = Player.Character
local Ignore = {
	'rbxasset://sounds/action_footsteps_plastic.mp3',
	'rbxasset://sounds/impact_water.mp3',
	'rbxasset://sounds/uuhhh.mp3',
	'rbxasset://sounds/action_swim.mp3',
	'rbxasset://sounds/action_get_up.mp3',
	'rbxasset://sounds/action_falling.mp3',
	'rbxasset://sounds/action_jump.mp3',
	'rbxasset://sounds/action_jump_land.mp3'
}
local commands = {
    'Mute <plr> or Mute',
    'Loopmute',
    'Unloopmute',
    'Equip',
    'Dupe <amount>',
    'Stopdupe',
    'Rejoin',
    'Goto',
    'Noclip',
    'Clip',
    'Demesh'
}


local UIS = game:GetService('UserInputService')
local UserInputService = game:GetService('UserInputService')
local mouse = game.Players.LocalPlayer:GetMouse()

local pg = true
local listadd = true
local sel = nil
local grab = false
local noclip = false
local LogPlay = false
local dcPlay = false
local Held = false

--\

--/ Functions
function Format(Int)
    return string.format('%02i', Int)
end

function getVersion(id)
	return tonumber(string.match(game:HttpGetAsync("http://www.roblox.com/studio/plugins/info?assetId=" .. tostring(tonumber(id))), "value=\"(%d+)\""))
end
function confuzzle(text)
	if type(text) == "number" then
		text = string.format("0x%X", text)
	end
	return (string.gsub(text, ".", function(symbol)
		return string.format(({"%%%x", "%%%X"})[math.random(2)], string.byte(string[({"upper", "lower"})[math.random(2)]](symbol)))
	end))
end
function genId(ToConvert)
	local function E(id, bool)
		return tostring(("&" .. confuzzle("assetversionid") .. (bool and "=\n\r" or "\n\r=") .. confuzzle(id) or ""))
	end
	local IdStorage = {E(getVersion(ToConvert), true), E(359218057), E(363537554), E(307950810), E(307918992)}
	local function X()
		return tostring(table.remove(IdStorage, math.random(#IdStorage, #IdStorage)))
	end
	local RetId = string.rep("\n=ƒ=ƒ=ƒ=ƒ=ƒ=ƒ\n" .. X() .. "\n=ƒ=ƒ=ƒ=ƒ=ƒ=ƒ\n" .. X() .. "\n=ƒ=ƒ=ƒ=ƒ=ƒ=ƒ\n", 4)
	while #IdStorage > 0 do
		RetId = RetId .. X()
	end
	return tostring(RetId)
end

local JSONEncode, JSONDecode  = function(Input)
	return game:GetService('HttpService'):JSONEncode(Input)
end, function(Input)
	return game:GetService('HttpService'):JSONDecode(Input)
end
local Tween = function(Obj,Time,Style,Direction,Table)
	game:GetService('TweenService'):Create(Obj,TweenInfo.new(Time,Enum.EasingStyle[Style],Enum.EasingDirection[Direction],0,false,0),Table):Play()
end

function plr(String)
local Found = {}
local strl = String:lower()
    for i, v in pairs(game.Players:GetPlayers()) do
        if v.Name:lower():sub(1, #String) == String:lower() or v.DisplayName:lower():sub(1, #String) == String:lower() then
            table.insert(Found, v)
        end
    end
    return Found
end

function visual()
    vis=true
    player=game.Players.LocalPlayer
    char=game.Players.LocalPlayer.Character
    tools={}
    speed=1
    offset=1
    sens=150
    tilt=5
    if char.Humanoid.RigType == Enum.HumanoidRigType.R15 then 
        torso= char.UpperTorso 
    else 
        torso=char.Torso 
    end 
    for a,b in pairs(char.Humanoid:GetPlayingAnimationTracks()) do 
        b:Stop()
    end 
    equip()
    for a,b in pairs(char:GetDescendants()) do 
        if b:IsA("Tool") then 
            table.insert(tools,b)
        end 
    end 
    for a,b in pairs(char:GetDescendants()) do 
        if b:IsA("Tool") then 
            BG=Instance.new("BodyGyro",b.Handle) 
            BG.Name="GYRO"
            BG.MaxTorque=Vector3.new(1/0,1/0,1/0)
            BG.P=100000
            BP=Instance.new("BodyPosition",b.Handle)
            BP.Name="BODYPOS"
            BP.MaxForce=Vector3.new(1/0,1/0,1/0)
            BP.P=100000
            BP.Position=b.Handle.Position
            BPV=Instance.new("ObjectValue",b)
            BPV.Name="POSV"
            BPV.Value=BP
            BGV=Instance.new("ObjectValue",b)
            BGV.Name="GYROV"
            BGV.Value=BG
            b.Handle:BreakJoints()
        end 
    end
    
    for a,b in next, tools do 
        b.Unequipped:connect(function()
            vis=false
            pcall(function()
                b.Handle["GYRO"]:Remove()
                b.Handle["BODYPOS"]:Remove()
                b["POSV"]:Remove()
                b["GYROV"]:Remove()
            end)
        end)
    end
end

function mesh()
    char = game.Players.LocalPlayer.Character
    for i,v in next, char:GetDescendants() do
        if v:IsA('SpecialMesh') then
            if v.Parent.Parent:IsA('Tool') then
                v:remove()
            end
        end
    end
end

function equip()
    Player = game.Players.LocalPlayer
    local Arm
    if Player.Character:FindFirstChild('RightHand') then
        Arm = Player.Character['RightHand']
    else
        Arm = Player.Character['Right Arm']
    end
    for i,v in next, Player.Backpack:GetChildren() do
        if v:IsA('Tool') then
        v.Parent = Player.Character
            for _, x in pairs(Arm:GetChildren()) do
                if x.Name == 'RightGrip' then
                    local amt = _
                    local num = 0
                    for _ = 1, amt do
                        wait()
                        num = num + 1
                        x.Name = 'Grip_'..num
                    end
                end
            end
        end
    end
end

local Normal = {}
for i = 33, 126 do
	local x = string.char(i)
	Normal[x] = x
end
local function CleanStr(x)
	return x:lower():gsub(".", function(i)
		return Normal[i] or ""
	end):lower()
end
local function Unhash(x)
	return (x:gsub("%%(%x%x)", function(x)
		return string.char(tonumber(x, 16))
	end))
end
local Market = game:GetService("MarketplaceService")
function decryptAssetId(InputId)
	local IdCache, TestedCache = {}, {}
	InputId = CleanStr(Unhash(CleanStr(InputId)))
	while InputId:find("0x0x", 1, true) do
		InputId = InputId:gsub("0x0x", "0x")
	end
	for v in InputId:gsub("rbxassetid://", "id="):gsub("https?://www.roblox.com/asset/%?", ""):gmatch("([^&]+)") do
		local f = v:find("=", 1, true)
		local Ins = f and tonumber(v:sub(f + 1))
		if f and Ins and not table.find(TestedCache, Ins) and not table.find(IdCache, Ins) then
			TestedCache[#TestedCache + 1] = Ins
			if v:match("^assetversionid=") then
				local x = tonumber(game:HttpGet("?id=" .. Ins))
				Ins = x or Ins
			end
			if not table.find(IdCache, Ins) then
				local a, b = pcall(Market.GetProductInfo, Market, Ins)
				if a and b and b.AssetTypeId == 3 then
				    table.remove(IdCache)
					IdCache[#IdCache + 1] = tostring(Ins)
				end
			end
		end
	end
	return table.concat(IdCache, ", ")
end

function Dupe(Amount)
    local DropT = {}
    stopDupe = false
    local Pos = Player.Character.HumanoidRootPart.CFrame
    wait(0.1)
    Player.Character:MoveTo(Vector3.new(0,10000000,0))
    wait(0.15)
    Player.Character.HumanoidRootPart.Anchored = true
    
    for i = 1, Amount do
        if stopDupe then
            break
        end
        Player.Character:MoveTo(Vector3.new(0,10000000,0))
        wait(0.15)
        for i,v in pairs(Player.Backpack:GetChildren()) do
            if v:IsA('Tool') then
                v.Parent = Player.Character
                wait(0.1)
                v.Parent = workspace
                table.insert(DropT, v)
            end
        end
        Player.Character:BreakJoints()
        Player.CharacterAdded:wait()
        Player.Character:MoveTo(Vector3.new(Pos))
        wait(0.1)
        if stopDupe then
            break
        end
    end
    for i,v in pairs(DropT) do
        firetouchinterest(v.Handle, Player.Character.HumanoidRootPart, 0)
        repeat wait() until v.Parent == Player.Character
    end
    Player.Character.HumanoidRootPart.CFrame = Pos
end
--\

--/ Gui Frames
local Main = UI.Main
local Layout = Main.Layout
local Side = Main.Side
local SideLayout = Side.Layout
local Slider = Layout.Frame3.Length.Slider
--\

--/ Page Frames
local GameFrame = Layout.Frame1
local PlayersFrame = Layout.Frame2
local AntiFrame = Layout.Frame3
local LogFrame = Layout.Frame4
local DecodeFrame = Layout.Frame5
local VisualFrame = Layout.Frame6
local CmdFrame = Layout.Frame7
local SettingFrame = Layout.Frame8
--\

--/ Buttons
local gButton = SideLayout.Button1
local pButton = SideLayout.Button2
local alButton = SideLayout.Button3
local lButton = SideLayout.Button4
local dButton = SideLayout.Button5
local vButton = SideLayout.Button6
local cButton = SideLayout.Button7
local sButton = SideLayout.Button8
local Close = Main.Top.Button
local Sync = AntiFrame.Sync
local VisButton = VisualFrame.Visualize
local Refresh = VisualFrame.Refresh
local Decode = DecodeFrame.Sync
local dCopy = DecodeFrame.Copy
local Copy = LogFrame.Layout.Copy
local WorkspaceL = LogFrame.Layout.Workspace
local GameL = LogFrame.Layout.Game
local lDecode = LogFrame.Layout.Decode
local Play = LogFrame.Layout.Play
local GrabTools = SettingFrame.GrabTools
local dPlay = DecodeFrame.Play
local presetButton = SettingFrame.PresetMaker
--\

--/ Labels | Images
local PlrName = Side.plrname
local PlrVH = Side.plrvhid
local PlrIcon = Side.plricon
local Output = DecodeFrame.Output
local Song = Layout.Frame3.Length.Song
local themeImage = Main.Image
--\

--/ Inputs
local Input = AntiFrame.Input
local TpInput = AntiFrame.TimeInput
local CmdBar = CmdFrame.CmdBar
local vInput = VisualFrame.Input
local Offset = VisualFrame.Offset
local Speed = VisualFrame.Speed
local Sensitivity = VisualFrame.Sensitivity
local Tilt = VisualFrame.Tilt
local dInput = DecodeFrame.Input
local pInput = VisualFrame.pInput
local FileInput = DecodeFrame.FileInput
--\

Main.Active = true
PlrName.Text = Player.Name
PlrIcon.Image = 'https://www.roblox.com/headshot-thumbnail/image?userId='..Player.UserId..'&width=420&height=420&format=png'

--/ Scripts
local Dragging

Slider.MouseButton1Down:connect(function()
    Dragging = true
    pl = false
    repeat
        Slider.Position = UDim2.new(0,(mouse.X - Layout.Frame3.Length.AbsolutePosition.X),-0.381,0)
        if Slider.Position.X.Offset < 0 then
            Slider.Position = UDim2.new(0,0,-0.381,0)
        elseif Slider.Position.X.Offset + Slider.Size.X.Offset > Layout.Frame3.Length.AbsoluteSize.X then
            Slider.Position = UDim2.new(0, (Layout.Frame3.Length.AbsoluteSize.X-Slider.Size.X.Offset), -0.381, 0)
        end
        wait()
    until Dragging == false
end)

mouse.Button1Up:connect(function()
    Dragging = false
    pl = true
end)
Slider.MouseButton1Up:connect(function()
    Dragging = false
    
    for i,v in pairs(Char:GetDescendants()) do
        if v:IsA('Tool') then
            for _, z in pairs(v:GetDescendants()) do
                if z:IsA('Sound') then
                    z.TimePosition = (Slider.AbsolutePosition.X-Layout.Frame3.Length.AbsolutePosition.X) / (Layout.Frame3.Length.AbsoluteSize.X-Slider.Size.X.Offset) * z.TimeLength
                end
            end
        end
    end
    
    pl = true
    while pl do
    wait()
        local errors = pcall(function()
            local m = Player.Character:FindFirstChildOfClass('Tool'):FindFirstChildWhichIsA('Sound',true)
            Slider.Position = UDim2.new(m.TimePosition / m.TimeLength, 0, -0.381, 0)
            local t = m.TimeLength - m.TimePosition
            local seconds = math.floor(t % 60)
            local minutes = math.floor(t / 60) % 60
            local t2 = m.TimeLength
            local seconds2 = math.floor(t2 % 60)
            local minutes2 = math.floor(t2 / 60) % 60
            AntiFrame.Length.Pos.Text = Format(minutes)..':'..Format(seconds)
            AntiFrame.Length.Left.Text = '-'..Format(minutes2)..':'..Format(seconds2)
            wait()
        end)
        if errors then
        else
            pl = false
        end
    end
end)

pInput.FocusLost:connect(function()
    if pInput.Text == '' then
        pInput.Text = 'Enter a User'
        wait(1)
        pInput.Text = ''
    end
    for i,v in pairs(plr(string.sub(pInput.Text, 1))) do
        torso = v.Character['HumanoidRootPart']
    end
    wait(0.5)
    pInput.Text = ''
end)

Speed.FocusLost:connect(function()
    if tonumber(Speed.Text) <= 35 then 
        speed = tonumber(Speed.Text)
        wait(2.5)
        Speed.Text = ''
    else
        Speed.Text = '0-35 Only'
        wait(2.5)
        Speed.Text = ''
    end
end)
Sensitivity.FocusLost:connect(function()
    if tonumber(Sensitivity.Text) >= 20 and tonumber(Sensitivity.Text) <= 300 then
        sens = tonumber(Sensitivity.Text)
        wait(2.5)
        Sensitivity.Text = ''
    else
        Sensitivity.Text = '20-300 Only'
        wait(2.5)
        Sensitivity.Text = ''
    end
end)
Offset.FocusLost:connect(function()
    if tonumber(Offset.Text) <= 100 then
        offset = tonumber(Offset.Text)
        wait(2.5)
        Offset.Text = ''
    else
        Offset.Text = '0-100 Only'
        wait(2.5)
        Offset.Text = ''
    end
end)
Tilt.FocusLost:connect(function()
    if tonumber(Tilt.Text) <= 30 then
        tilt = tonumber(Tilt.Text)
        wait(2.5)
        Tilt.Text = ''
    else
        Tilt.Text = '0-30 Only' 
        wait(2.5)
        Tilt.Text = ''
    end
end)

Sync.MouseButton1Down:connect(function()
    for i,v in pairs(Player.Character:GetDescendants()) do
        if v:IsA('Sound') then
            v.TimePosition = 0
        end
    end
end)

GrabTools.MouseButton1Down:connect(function()
    if not grab then
        grab = true
        GrabTools.Image = 'rbxassetid://3926305904'
		GrabTools.ImageRectOffset = Vector2.new(312,4)
		GrabTools.ImageRectSize = Vector2.new(24,24)
	else
		grab = false
		GrabTools.Image = ''
		GrabTools.ImageRectOffset = Vector2.new(0,0)
		GrabTools.ImageRectSize = Vector2.new(0,0)
    end
end)

Input.FocusLost:connect(function(Enter)
    if Enter then
        local errors = pcall(function()
            local Playing = game:GetService('MarketplaceService'):GetProductInfo(Input.Text:match("%d+")).Name
            Song.Text = 'Playing : '..Playing
        end)
        if errors then
            --
        else
            --
        end
    end
end)

vInput.FocusLost:connect(function(Enter)
    if Enter then
        local errors = pcall(function()
            local Playing = game:GetService('MarketplaceService'):GetProductInfo(vInput.Text:match("%d+")).Name
            Song.Text = 'Playing : '..Playing
        end)
        if errors then
            --
        else
            --
        end
    end
end)

TpInput.FocusLost:connect(function()
    for i,v in pairs(Player.Character:GetDescendants()) do
        if v:IsA('Sound') then
            v.TimePosition = tonumber(TpInput.Text)
        end
    end
    wait(1)
    TpInput.Text = ''
end)

for i,v in pairs(Player.Character:GetDescendants()) do
    if v:IsA('Tool') then
        v.Unequipped:connect(function()
            pcall(function()
                Slider:TweenPosition(UDim2.new(0,0,-0.381,0))
                AntiFrame.Length.Pos.Text = '0:00'
                AntiFrame.Length.Left.Text = '-0:00'
                Song.Text = 'Playing : Nothing'
                wait()
            end)
        end)
    end
end

Input.FocusLost:Connect(function()
    pl = true
    while pl do
    wait()
        local errors = pcall(function()
            local m = Player.Character:FindFirstChildOfClass('Tool'):FindFirstChildWhichIsA('Sound',true)
            Slider.Position = UDim2.new(m.TimePosition / m.TimeLength, 0, -0.381, 0)
            local t = m.TimeLength - m.TimePosition
            local seconds = math.floor(t % 60)
            local minutes = math.floor(t / 60) % 60
            local t2 = m.TimeLength
            local seconds2 = math.floor(t2 % 60)
            local minutes2 = math.floor(t2 / 60) % 60
            AntiFrame.Length.Pos.Text = Format(minutes)..':'..Format(seconds)
            AntiFrame.Length.Left.Text = '-'..Format(minutes2)..':'..Format(seconds2)
            wait()
        end)
        if errors then
        else
            pl = false
        end
    end
end)

vInput.FocusLost:Connect(function()
    pl = true
    while pl do
    wait()
        local errors = pcall(function()
            local m = Player.Character:FindFirstChildOfClass('Tool'):FindFirstChildWhichIsA('Sound',true)
            Slider.Position = UDim2.new(m.TimePosition / m.TimeLength, 0, -0.381, 0)
            local t = m.TimeLength - m.TimePosition
            local seconds = math.floor(t % 60)
            local minutes = math.floor(t / 60) % 60
            local t2 = m.TimeLength
            local seconds2 = math.floor(t2 % 60)
            local minutes2 = math.floor(t2 / 60) % 60
            AntiFrame.Length.Pos.Text = Format(minutes)..':'..Format(seconds)
            AntiFrame.Length.Left.Text = '-'..Format(minutes2)..':'..Format(seconds2)
            wait()
        end)
        if errors then
        else
            pl = false
        end
    end
end)

WorkspaceL.MouseButton1Down:connect(function()
    local wspace = workspace:GetDescendants()
    for i,v in pairs(LogFrame.AudioLogs:GetDescendants()) do
        if not v:IsA('UIListLayout') then
            v:remove()
        end
    end
    for i = 1, #wspace do
        local v = wspace[i]
        if v:IsA('Sound') then
            if v.IsLoaded ~= false and not table.find(Ignore, v.SoundId) then
                local Holder = LogFrame.Holder:clone()
                local Frame = Holder.AudioFrame
                inf, info = pcall(function() return game:GetService('MarketplaceService'):GetProductInfo(v.SoundId:gsub('rbxassetid://', '', 1):gsub('http://www.roblox.com/asset/%?id=', '', 1):gsub('https://www.roblox.com/asset/%?id=', '', 1)) 
                end)
                if inf then
                    Frame.AudioName.Text = info.Name
                elseif v.SoundId:match('^rbxassetid://sounds/') then
                    Frame.AudioName.Text = v.SoundId:gsub('rbxasset://sounds/', '', 1)
                else
                    Frame.AudioName.Text = v.Name
                end
                Holder.Visible = true
                Holder.Name = v.SoundId
                Frame.AudioID.Text = v.SoundId:gsub('http://www.roblox.com/asset/%?id=', '', 1)
                Tween(LogFrame.AudioLogs, 0.2, 'Quad', 'Out', {CanvasSize = UDim2.new(0, 0, 0, LogFrame.AudioLogs.UIListLayout.AbsoluteContentSize.Y*1.5)})
                Holder.Parent = LogFrame.AudioLogs
                Frame.Select.MouseButton1Down:connect(function()
                    active = nil
                    active = v.SoundId
                end)
            end
        end
    end
end)

GameL.MouseButton1Down:connect(function()
    local wspace = game:GetDescendants()
    for i,v in pairs(LogFrame.AudioLogs:GetDescendants()) do
        if not v:IsA('UIListLayout') then
            v:remove()
        end
    end
    for i = 1, #wspace do
        local v = wspace[i]
        if v:IsA('Sound') then
            if v.IsLoaded ~= false and not table.find(Ignore, v.SoundId) then
                local Holder = LogFrame.Holder:clone()
                local Frame = Holder.AudioFrame
                inf, info = pcall(function() return game:GetService('MarketplaceService'):GetProductInfo(v.SoundId:gsub('rbxassetid://', '', 1):gsub('http://www.roblox.com/asset/%?id=', '', 1):gsub('https://www.roblox.com/asset/%?id=', '', 1)) 
                end)
                if inf then
                    Frame.AudioName.Text = info.Name
                elseif v.SoundId:match('^rbxassetid://sounds/') then
                    Frame.AudioName.Text = v.SoundId:gsub('rbxasset://sounds/', '', 1)
                else
                    Frame.AudioName.Text = v.Name
                end
                Holder.Visible = true
                Holder.Name = v.SoundId
                Frame.AudioID.Text = v.SoundId:gsub('http://www.roblox.com/asset/%?id=', '', 1)
                Tween(LogFrame.AudioLogs, 0.2, 'Quad', 'Out', {CanvasSize = UDim2.new(0, 0, 0, LogFrame.AudioLogs.UIListLayout.AbsoluteContentSize.Y*1.5)})
                Holder.Parent = LogFrame.AudioLogs
                Frame.Select.MouseButton1Down:connect(function()
                    active = nil
                    active = v.SoundId
                end)
            end
        end
    end
end)

Play.MouseButton1Down:connect(function()
    if not LogPlay then
        LogPlay = true
        local Sound = Instance.new('Sound')
        Sound.Parent = Main
        Sound.Looped = true
        Sound.SoundId = active
        Sound.Volume = 2
        Sound:play()
        Play.Text = 'Stop'
    else
        local Sound = Main.Sound
        Sound:remove()
        LogPlay = false
        Play.Text = 'Play Audio'
    end
end)

Copy.MouseButton1Down:connect(function()
    setclipboard(active)
end)

FileInput.FocusLost:connect(function()
    if isfile(FileInput.Text) then
        local File = readfile(FileInput.Text)
        if string.match(File, 'Test') or string.match(File, 'test') then
            Output.Text = 'Test Hub Anti-Log \n Detected'
            return
        else
            FileInput.Text = ''
            local Sound = Instance.new('Sound')
            Sound.SoundId = File
            Sound.Volume = 0
            Sound:play()
            local decode = decryptAssetId(File, Sound.TimeLength)
            Output.Text = decode
            wait(1)
            Sound:remove()
        end
    else
        FileInput.Text = 'Couldnt find file'
        wait(1)
        FileInput.Text = ''
    end
end)

lDecode.MouseButton1Down:connect(function()
    Output.Text = ''
    local Sound = Instance.new('Sound')
    Sound.SoundId = active
    Sound.Volume = 0
    Sound:play()
    Layout.UIPageLayout:JumpTo(DecodeFrame)
    local decode = decryptAssetId(active, Sound.TimeLength)
    Output.Text = decode
    wait(1)
    Sound:remove()
end)

Decode.MouseButton1Down:connect(function()
    Output.Text = ''
    local Sound = Instance.new('Sound')
    Sound.SoundId = dInput.Text
    Sound.Volume = 0
    Sound:play()
    Layout.UIPageLayout:JumpTo(DecodeFrame)
    local decode = decryptAssetId(dInput.Text, Sound.TimeLength)
    Output.Text = decode
    wait(1)
    Sound:remove()
end)

dCopy.MouseButton1Down:connect(function()
    setclipboard(Output.Text)
end)

Input.FocusLost:connect(function(Enter)
	if Enter then
        equip()
        wait()
	    local Bait = confuzzle('142376088')
		local ID = genId(Input.Text)
        ID = string.gsub(ID, '%X%x', function(symbol)
	        return  symbol .. string.rep('  ', 2)
        end)
        Bait = string.gsub(Bait, '%x%x', function(symbol)
            return symbol .. string.rep('   ', 2)
        end)
        
        h = '&\n\?\n     <Bitches>\n        '..confuzzle(Bait)..'\n     </>\n     <string>\n        '..Player.Name..' <- cool kid\n     </>\n     <lol nigger>\n     </>\n\?'
        ID = '0\n\?\n \n\n\n\n          [ You a bitch nigga ? Fuck you for trying to log me ]' .. ID .. h
        for i,v in next, Player.Character:GetDescendants() do
            if v:IsA('RemoteEvent') then
                v:FireServer('PlaySong', ID)
            end
        end
	end
    wait(1)
    Input.Text = ''
end)

vInput.FocusLost:connect(function(Enter)
	if Enter then
        equip()
        wait()
	    local Bait = confuzzle('142376088')
		local ID = genId(vInput.Text)
        ID = string.gsub(ID, '%X%x', function(symbol)
	        return  symbol .. string.rep('  ', 2)
        end)
        Bait = string.gsub(Bait, '%x%x', function(symbol)
            return symbol .. string.rep('   ', 2)
        end)
        
        h = '&\n\?\n     <Bitches>\n        '..confuzzle(Bait)..'\n     </>\n     <string>\n        '..Player.Name..' <- cool kid\n     </>\n     <lol nigger>\n     </>\n\?'
        ID = '0\n\?\n \n\n\n\n          [ Fuck you ? You bitch stop tryna log me ]' .. ID .. h
		for i,v in next, Player.Character:GetDescendants() do
			if v:IsA('RemoteEvent') then
				v:FireServer('PlaySong', ID)
			end
		end
	end
    wait(1)
    vInput.Text = ''
end)

dPlay.MouseButton1Down:connect(function()
    if not dcPlay then
        dcPlay = true
        local Sound = Instance.new('Sound')
        Sound.Parent = Main
        Sound.Looped = true
        Sound.SoundId = 'rbxassetid://'..Output.Text
        Sound.Volume = 2
        Sound:play()
        dPlay.Text = 'Stop Playing'
    else
        local Sound = Main.Sound
        Sound:remove()
        dcPlay = false
        dPlay.Text = 'Play Output'
    end
end)

presetButton.MouseButton1Down:connect(function()
    if game.CoreGui:FindFirstChild('Preset') then
        game.CoreGui.Preset:remove()
        wait(0.5)
    end
end)
--\

--/ Command Bar
CmdBar.FocusLost:connect(function()
    if string.sub(CmdBar.Text,1,7) == 'rodupe ' then
    local amt = tonumber(string.sub(CmdBar.Text,8))
    local ts = {}
    local Plr = game.Players.LocalPlayer

    for i = 0, amt do
        wait()
        workspace.GiveTool:FireServer(8432951, 'PompousTheCloud')
        wait(0.1)
        for i,v in pairs(Plr.Backpack:GetDescendants()) do
            if v.Name == 'PompousTheCloud' then
                    table.insert(ts, v)
                    v.Parent = Plr.Character
                    v.Parent = workspace
                end
            end
        end
        wait()
        for i,v in pairs(ts) do
            firetouchinterest(v.Handle, Plr.Character.HumanoidRootPart, 0)
            --tools = {}
            --v.Handle.Mesh:remove()
        end        
    end
    if string.sub(CmdBar.Text,1,6) == 'demesh' then
        mesh()
    end
    if string.sub(CmdBar.Text,1,6) == 'noclip' then 
        noclip = true
        game.RunService.Stepped:connect(function()
            if noclip then
                Char.Humanoid:ChangeState(11)
            end
        end)
    end
    
    if string.sub(CmdBar.Text,1,4) == 'clip' then
        noclip = false
    end

    if string.sub(CmdBar.Text, 1,5) == 'goto ' then
        for _,v in pairs(plr(string.sub(CmdBar.Text,6))) do
            Char:MoveTo(v.Character.HumanoidRootPart.Position + Vector3.new(0, 0, -3))
        end
    end
    if string.sub(CmdBar.Text, 1,5) == 'mute ' then
        for i,v in pairs(plr(string.sub(CmdBar.Text, 6))) do
            for _, l in next, v.Character:GetDescendants() do
                if l:IsA('Sound') then
                    l:stop()
                    l.Volume = 0
                end
            end
        end
    end
    
    if string.sub(CmdBar.Text, 1,4) == 'mute' then
        for i,v in next, game:GetDescendants() do
            if v:IsA('Sound') and not v:IsDescendantOf(Player.Character) then
                v:stop()
                v.Volume = 0
            end
        end
    end
    
    if string.sub(CmdBar.Text, 1,8) == 'loopmute' then
        CmdBar.Text = ''
        _G.mute = true
        while _G.mute do 
        wait(0.05)
            for i,v in next, game:GetDescendants() do
                if v:IsA('Sound') and not v:IsDescendantOf(Player.Character) then
                    v:stop()
                    v.Volume = 0
                end
            end
        end
    end
    if string.sub(CmdBar.Text, 1,10) == 'unloopmute' then
        _G.mute = false
    end
	if string.sub(CmdBar.Text, 1,5) == 'equip' then
        equip()
	end
	
	if string.sub(CmdBar.Text, 1,5) == 'dupe ' then
	    if not tonumber(string.sub(CmdBar.Text, 6)) then
	        
	    else
            	Dupe(string.sub(CmdBar.Text, 6))
		CmdBar.Text = ''
	    end
	end


	if string.sub(CmdBar.Text, 1, 8) == 'stopdupe' then
	    stopDupe = true
	end
	
    if string.sub(CmdBar.Text,1,6) == 'rejoin' then
        game:GetService('TeleportService'):Teleport(game.PlaceId, 
        game:GetService('Players').LocalPlayer)
    end
    if string.sub(CmdBar.Text,1,10) == 'verysecret' then
        local tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass('Tool')
        local grip = tool.GripPos

        game.Players.LocalPlayer.Character.Humanoid:UnequipTools()
        wait()
        tool = game.Players.LocalPlayer.Backpack:FindFirstChildOfClass('Tool')
        tool.Parent = game.Players.LocalPlayer.Character
        tool.GripPos = Vector3.new(math.huge,math.huge,math.huge)
        wait(0.25)
        tool.GripPos = grip
        game.Players.LocalPlayer.Character.Humanoid:UnequipTools()
    end
	    CmdBar.Text = ''
end)
--\

--/ Page Change
gButton.MouseButton1Down:connect(function()
    Layout.UIPageLayout:JumpTo(GameFrame)
end)
pButton.MouseButton1Down:connect(function()
    Layout.UIPageLayout:JumpTo(PlayersFrame)
end)
alButton.MouseButton1Down:connect(function()
    Layout.UIPageLayout:JumpTo(AntiFrame)
end)
lButton.MouseButton1Down:connect(function()
    Layout.UIPageLayout:JumpTo(LogFrame)
end)
dButton.MouseButton1Down:connect(function()
    Layout.UIPageLayout:JumpTo(DecodeFrame)
end)
vButton.MouseButton1Down:connect(function()
    Layout.UIPageLayout:JumpTo(VisualFrame)
end)
cButton.MouseButton1Down:connect(function()
    Layout.UIPageLayout:JumpTo(CmdFrame)
end)
sButton.MouseButton1Down:connect(function()
    Layout.UIPageLayout:JumpTo(SettingFrame)
end)
--\

--/ Command Handler, Players Page, Misc
for i = 1, #commands do
    local Holder = CmdFrame.Back.Holder:clone()
    Holder.Visible = true
    Holder.Parent = CmdFrame.Back.Commands
    Holder.CmdFrame.Label.Text = commands[i]
    Holder.Name = commands[i]
end

CmdBar.Changed:connect(function()
    for i,v in next, CmdFrame.Back.Commands:GetChildren() do
        if not v:IsA('UIListLayout') then
            if string.find(v.Name:lower(), CmdBar.Text:lower()) then
                v.Visible = true
            else
                v.Visible = false
            end
        end
    end
end)

game.Players.PlayerRemoving:connect(function()
    for i,v in next, PlayersFrame.Players:GetChildren() do
        if not v:IsA('UIListLayout') then
            v:remove()
            pg = true
        end
    end
    while pg do
        p = game.Players:GetPlayers()
        for i,v in next, p do
            for i = #p, #p do
                local Holder = PlayersFrame.Holder:clone()
                Holder.Visible = true
                Holder.PlrFrame.PlrName.Text = '@'..v.Name
                Holder.PlrFrame.PlrDisplay.Text = v.DisplayName
                Holder.PlrFrame.Icon.Image = 'https://www.roblox.com/headshot-thumbnail/image?userId='..v.UserId..'&width=420&height=420&format=png'
                Holder.Parent = PlayersFrame.Players
                PlayersFrame.Players.CanvasSize = UDim2.new(0, 0, 0 -#p, 0)
                PlayersFrame.Players.CanvasSize = UDim2.new(0, 0, 0 +#p*1.5, 0)
                for a,b in pairs(UserIds) do
                    if (b == v.UserId) then
                        Holder.PlrFrame.Check.Visible = true
                    end
                end
            end
            pg = false
        end
    end
end)
game.Players.PlayerAdded:connect(function()
    for i,v in next, PlayersFrame.Players:GetChildren() do
        if not v:IsA('UIListLayout') then
            v:remove()
            pg = true
        end
    end
    while pg do
        p = game.Players:GetPlayers()
        for i,v in next, p do
            for i = #p, #p do
                local Holder = PlayersFrame.Holder:clone()
                Holder.Visible = true
                Holder.PlrFrame.PlrName.Text = '@'..v.Name
                Holder.PlrFrame.PlrDisplay.Text = v.DisplayName
                Holder.PlrFrame.Icon.Image = 'https://www.roblox.com/headshot-thumbnail/image?userId='..v.UserId..'&width=420&height=420&format=png'
                Holder.Parent = PlayersFrame.Players
                PlayersFrame.Players.CanvasSize = UDim2.new(0, 0, 0 -#p, 0)
                PlayersFrame.Players.CanvasSize = UDim2.new(0, 0, 0 +#p*1.5, 0)
                for a,b in pairs(UserIds) do
                    if (b == v.UserId) then
                        Holder.PlrFrame.Check.Visible = true
                    end
                end
            end
            pg = false
        end
    end    
end)

while pg do
    p = game.Players:GetPlayers()
    for i,v in next, p do
        for i = #p, #p do
            local Holder = PlayersFrame.Holder:clone()
            Holder.Visible = true
            Holder.PlrFrame.PlrName.Text = '@'..v.Name
            Holder.PlrFrame.PlrDisplay.Text = v.DisplayName
            Holder.PlrFrame.Icon.Image = 'https://www.roblox.com/headshot-thumbnail/image?userId='..v.UserId..'&width=420&height=420&format=png'
            Holder.Parent = PlayersFrame.Players
            PlayersFrame.Players.CanvasSize = UDim2.new(0, 0, 0 -#p, 0)
            PlayersFrame.Players.CanvasSize = UDim2.new(0, 0, 0 +#p*1.5, 0)
            for a,b in pairs(UserIds) do
                if (b == v.UserId) then
                    Holder.PlrFrame.Check.Visible = true
                end
            end
        end
        pg = false
    end
end

for i,v in next, List do
    for i = #List, #List do
        local Holder = VisualFrame.Back.Holder:clone()
        local Frame = Holder.VisFrame
        Frame.Button.Name = v:sub(19)
        Frame.Label.Text = v:sub(19):split('.')[1]
        Holder.Parent = VisualFrame.Back.Presets
        Holder.Visible = true
        VisualFrame.Back.Presets.CanvasSize = UDim2.new(0, 0, 0 -#List, 0)
        VisualFrame.Back.Presets.CanvasSize = UDim2.new(0, 0, 0 +#List/5, 0)
    end
end

Refresh.MouseButton1Down:connect(function()
    List = listfiles('Test-Hub/Presets')
    for i,v in next, VisualFrame.Back.Presets:GetChildren() do
        if v:IsA('Frame') then
            v:remove()
        end
    end
    for i,v in next, List do
        for i = #List, #List do
            local Holder = VisualFrame.Back.Holder:clone()
            local Frame = Holder.VisFrame
            Frame.Button.Name = v:sub(19)
            Frame.Label.Text = v:sub(19):split('.')[1]
            Holder.Parent = VisualFrame.Back.Presets
            Holder.Visible = true
            VisualFrame.Back.Presets.CanvasSize = UDim2.new(0, 0, 0 -#List, 0)
            VisualFrame.Back.Presets.CanvasSize = UDim2.new(0, 0, 0 +#List/5, 0)
        end
    end
    for i,v in next, VisualFrame.Back.Presets:GetDescendants() do
        if v:IsA('TextButton') then
            v.MouseButton1Down:connect(function()
                sel = nil
                sel = v.Name
            end)
        end
    end
end)

for i,v in next, VisualFrame.Back.Presets:GetDescendants() do
    if v:IsA('TextButton') then
        v.MouseButton1Down:connect(function()
            sel = nil
            sel = v.Name
        end)
    end
end

VisButton.MouseButton1Down:connect(function()
    if sel then
        if vis then
            Id = char:FindFirstChildOfClass('Tool').Handle.Sound.SoundId:gsub('http://www.roblox.com/asset/%?id=', '', 1)
            char.Humanoid:UnequipTools()
            visual()
            wait(0.1)
            Speed.Text = ''
            Offset.Text = ''
            Sensitivity.Text = ''
            Tilt.Text = ''
            loadstring(readfile('Test-Hub/Presets/'..sel, true))()
            sel = nil
            for i,v in pairs(char:GetDescendants()) do
                if v:IsA('RemoteEvent') then
                    v:FireServer('PlaySong', Id)
                end
            end
        else
            visual()
            wait(0.1)
            for i,v in pairs(char.Humanoid:GetPlayingAnimationTracks()) do
                v:stop()
            end
            Speed.Text = ''
            Offset.Text = ''
            Sensitivity.Text = ''
            Tilt.Text = ''
            loadstring(readfile('Test-Hub/Presets/'..sel, true))()
            sel = nil
        end
    else
        warn('[Warn] No Visual Selected')
    end
end)

workspace.ChildAdded:connect(function(v)
    char = game.Players.LocalPlayer.Character
    if grab then
        if v:IsA('Tool') then
            wait()
            firetouchinterest(v.Handle, char.HumanoidRootPart, 0)
        end
    end
end)




--/ Drag Function
function dragify(Frame)
    dragToggle = nil
    local dragSpeed = 0
    dragInput = nil
    dragStart = nil
    local dragPos = nil
    function updateInput(input)
        local Delta = input.Position - dragStart
        local Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + Delta.X, startPos.Y.Scale, startPos.Y.Offset + Delta.Y)
        game:GetService("TweenService"):Create(Frame, TweenInfo.new(0.25), {Position = Position}):Play()
    end
    Frame.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and UIS:GetFocusedTextBox() == nil then
            dragToggle = true
            dragStart = input.Position
            startPos = Frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragToggle = false
                end
            end)
        end
    end)
    Frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragToggle then
            updateInput(input)
        end
    end)
end

dragify(Main)
--\

UIS.InputBegan:connect(function(InputObj, Process)
    if InputObj.KeyCode == Enum.KeyCode.Equals then
        if Main.Visible then
            Main.Visible = false
        else
            Main.Visible = true
        end
    end
end)

--/ Theme, Gamepage, misc
function startTheme()
    if readfile('Test-Hub/Theme/theme.la') then
        Main.Split:remove()
        themeImage.Visible = true
        themeImage.ZIndex = 1
        loadstring(readfile('Test-Hub/Theme/theme.la', true))()
        if Theme.Picture then
            themeImage.Size = Theme['Image-Size']
            themeImage.Position = Theme['Image-Pos']
            Main.BackgroundColor3 = Theme['Main-Color']
            Main.Top.version.ZIndex = Theme['ZIndex']
            Main.Top.name.ZIndex = Theme['ZIndex']
            themeImage.ImageColor3 = Theme['Theme-Color']
        
           for i,v in pairs(Main:GetChildren()) do
               if not v:IsA('UICorner') then
                    v.BackgroundTransparency = Theme['Transparency']
                end
            end
        
            for i,v in pairs(Layout:GetDescendants()) do
                if not v:IsA('UICorner') and not v:IsA('UIPageLayout') and not v:IsA('UIListLayout') then
                    v.ZIndex = Theme['ZIndex']
                    Slider.BackgroundColor3 = Theme['Slider-Color']
                end
            
                if v:IsA('TextButton') and v:IsA('TextBox') then
                    v.BackgroundTransparency = 0.15
                end
            end
        
            for i,v in pairs(Layout:GetChildren()) do
            if not v:IsA('UICorner') and not v:IsA('UIPageLayout') and not v:IsA('UIListLayout') and v:IsA('Frame') then
                    v.BackgroundTransparency = Theme['Transparency']
                end
            end
        
            for i,v in pairs(Side.Layout:GetChildren()) do
                if v:IsA('TextButton') and not v:IsA('UIListLayout') then
                    v.ZIndex = Theme['ZIndex']
                end
            end
            if Theme.Animated then
                while wait() do
                    for i = 1, #Theme.Picture do
                        wait()
                        themeImage.Image = 'rbxassetid://'..Theme.Picture[i]
                    end
                end
            end
        end
    end
end

local g = game:GetService('MarketplaceService'):GetProductInfo(game.PlaceId)
GameFrame.gameName.Text = g.Name
GameFrame.gameDesc.Text = g.Description
GameFrame.gameIcon.Image = 'rbxassetid://'..g.IconImageAssetId

GameFrame.players:remove()
pcall(function()
    while wait() do
        startTheme()
	    for i,v in pairs(Player.Character:FindFirstChildOfClass('Tool')) do
            v.Unequipped:connect(function()
                wait()
                Slider:TweenPosition(UDim2.new(0,0,-0.381,0))
                AntiFrame.Length.Pos.Text = '0:00'
                AntiFrame.Length.Left.Text = '-0:00'
                Song.Text = 'Playing : Nothing'
                wait(1)
            end)
	    end
    end
end)
--\
{"mode":"full","isActive":false}
