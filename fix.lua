while wait() do

if _G.NetFix == nil then
    _G.NetFix = " "
    game:service("RunService").Heartbeat:Connect(function()
        setsimulationradius(math.huge, math.huge)
    end)
end

local ME = game:GetService("Players").LocalPlayer
local HB = game:GetService("RunService").Heartbeat
local vel = Vector3.new(18, 5, 8)
for _, v in ipairs(ME.Character:GetDescendants()) do
    if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
        HB:Connect(function()
            v.Velocity = vel
        end)
    end
end

local ME = game:GetService("Players").LocalPlayer
local HB = game:GetService("RunService").Heartbeat
local vel = Vector3.new(14, 2, 5)
for _, v in ipairs(ME.Character:GetDescendants()) do
    if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
        HB:Connect(function()
            v.Velocity = vel
        end)
    end
end

local ME = game:GetService("Players").LocalPlayer
local HB = game:GetService("RunService").Heartbeat
local vel = Vector3.new(12, 2, 1)
for _, v in ipairs(ME.Character:GetDescendants()) do
    if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
        HB:Connect(function()
            v.Velocity = vel
        end)
    end
end

local ME = game:GetService("Players").LocalPlayer
local HB = game:GetService("RunService").Heartbeat
local vel = Vector3.new(11, 2, 9)
for _, v in ipairs(ME.Character:GetDescendants()) do
    if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
        HB:Connect(function()
            v.Velocity = vel
        end)
    end
end
    end
