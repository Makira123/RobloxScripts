local ReplicatedStorage = game:GetService("ReplicatedStorage")
local freezeEvent = ReplicatedStorage:WaitForChild("SafeFreezeAnimalRequest")

freezeEvent.OnServerEvent:Connect(function(player)
    local character = player.Character
    if not character then return end

    local animal = workspace:FindFirstChild(player.Name .. "_Pet")
    if not animal or not animal:IsA("Model") then
        warn("สัตว์ของผู้เล่นไม่พบ")
        return
    end

    local humanoid = animal:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = 0
        humanoid.JumpPower = 0
        humanoid:ChangeState(Enum.HumanoidStateType.Physics) -- หยุดแบบ force
    end

    -- ปิด Script / LocalScript ในสัตว์
    for _, child in ipairs(animal:GetDescendants()) do
        if child:IsA("Script") or child:IsA("LocalScript") then
            child.Disabled = true
        end
        -- ลบตัวควบคุมการเคลื่อนที่ เช่น BodyVelocity
        if child:IsA("BodyMover") or child:IsA("BodyVelocity") then
            child:Destroy()
        end
    end

    -- ดึงสัตว์มาอยู่ใกล้ตัวผู้เล่น
    local root = character:FindFirstChild("HumanoidRootPart")
    local animalRoot = animal:FindFirstChild("PrimaryPart") or animal:FindFirstChild("HumanoidRootPart")
    if root and animalRoot then
        animal:SetPrimaryPartCFrame(root.CFrame * CFrame.new(2, 0, 2))
    end
end)
