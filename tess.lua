for i,v in next, game:GetService("Players").LocalPlayer.Character:GetDescendants() do
if v:IsA("BasePart") and v.Name ~="HumanoidRootPart" then 
game:GetService("RunService").Heartbeat:connect(function()
v.Velocity = Vector3.new(45,54,27)
end)
end
end

local ME = game:GetService("Players").LocalPlayer
local HB = game:GetService("RunService").Heartbeat
local vel = Vector3.new(25, 25, 20)
for _, v in ipairs(ME.Character:GetDescendants()) do
    if v:IsA("BasePart") and v.Name == "Handle" then
        HB:Connect(function()
            v.Velocity = vel
        end)
    end
end
