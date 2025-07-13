local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- UI Button
local button = player:WaitForChild("PlayerGui"):WaitForChild("ScreenGui"):WaitForChild("HiButton")

-- สัตว์ชื่อ Pet1
local pet = workspace:WaitForChild("Pet1")

-- ตรวจสอบว่ามี PrimaryPart
if not pet.PrimaryPart then
	warn("สัตว์ของคุณ (Pet1) ยังไม่ได้ตั้ง PrimaryPart!")
	return
end

-- ฟังก์ชันให้สัตว์วิ่งมาหา
local function bringPet()
	local targetPos = character:WaitForChild("HumanoidRootPart").Position + Vector3.new(2, 0, 2)

	local tweenInfo = TweenInfo.new(
		1.5,
		Enum.EasingStyle.Sine,
		Enum.EasingDirection.Out
	)

	local tween = TweenService:Create(pet.PrimaryPart, tweenInfo, {
		Position = targetPos
	})
	tween:Play()
end

-- เมื่อกดปุ่ม
button.MouseButton1Click:Connect(function()
	bringPet()
end)
