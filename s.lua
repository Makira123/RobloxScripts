-- ServerScript ควบคุมสัตว์ตามชื่อที่ผู้เล่นส่งมา
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- RemoteEvent สำหรับ Freeze และ Pull
local freezeEvent = Instance.new("RemoteEvent", ReplicatedStorage)
freezeEvent.Name = "FreezeToggleEvent"

local pullEvent = Instance.new("RemoteEvent", ReplicatedStorage)
pullEvent.Name = "PullPetEvent"

-- ฟังก์ชันหยุด/ปล่อย
freezeEvent.OnServerEvent:Connect(function(player, petName)
    local pet = workspace:FindFirstChild(petName)
    if not pet then return end

    local humanoid = pet:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    local isFrozen = humanoid:GetAttribute("IsFrozen")

    if isFrozen then
        humanoid.WalkSpeed = 16
        humanoid.JumpPower = 50
        humanoid:SetAttribute("IsFrozen", false)
    else
        humanoid.WalkSpeed = 0
        humanoid.JumpPower = 0
        humanoid:ChangeState(Enum.HumanoidStateType.Physics)
        humanoid:SetAttribute("IsFrozen", true)

        -- ปิดสคริปต์และลบแรง
        for _, child in ipairs(pet:GetDescendants()) do
            if child:IsA("Script") or child:IsA("LocalScript") then
                child.Disabled = true
            end
            if child:IsA("BodyVelocity") or child:IsA("BodyMover") then
                child:Destroy()
            end
        end
    end
end)

-- ฟังก์ชันดึงสัตว์
pullEvent.OnServerEvent:Connect(function(player, petName)
    local pet = workspace:FindFirstChild(petName)
    if not pet then return end

    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    local petRoot = pet:FindFirstChild("PrimaryPart") or pet:FindFirstChild("HumanoidRootPart")

    if root and petRoot then
        pet:SetPrimaryPartCFrame(root.CFrame * CFrame.new(2, 0, 2))
    end
end)
