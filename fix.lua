local ME = game:GetService("Players").LocalPlayer
local HB = game:GetService("RunService").Heartbeat
local vel = Vector3.new(7.08782e-06, 6.12542e-08, 8.28769e-06)
local rotvel = Vector3.new(2, -5, 2)
for _, v in ipairs(ME.Character:GetDescendants()) do
    if v:IsA("BasePart") and v.Name == "Handle" then
        HB:Connect(function()
            v.Velocity = vel
            v.RotVelocity = rotvel
        end)
    end
end
