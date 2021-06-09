local ME = game:GetService("Players").LocalPlayer
local HB = game:GetService("RunService").Heartbeat
local vel = Vector3.new(-17, 0, -17)
for _, v in ipairs(ME.Character:GetDescendants()) do
    if v:IsA("BasePart") and v.Name == "Handle" then
        HB:Connect(function()
            v.Velocity = vel
        end)
    end
end
