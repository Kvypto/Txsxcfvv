for i,v in next, game:GetService("Players").LocalPlayer.Character:GetDescendants() do
if v:IsA("BasePart") and v.Name ~="HumanoidRootPart" then 
game:GetService("RunService").Heartbeat:connect(function()
v.Velocity = Vector3.new(15,24,17)
end)
end
end

local ME = game:GetService("Players").LocalPlayer
local HB = game:GetService("RunService").Heartbeat
local vel = Vector3.new(25, 30, 10)
for _, v in ipairs(ME.Character:GetDescendants()) do
    if v:IsA("BasePart") and v.Name == "Handle" then
        HB:Connect(function()
            v.Velocity = vel
        end)
    end
end
