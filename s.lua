-- LocalScript (วางใน StarterPlayerScripts)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- สร้าง ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FarmPetControlUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- กรอบปุ่มสัตว์ (Frame)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 250)
frame.Position = UDim2.new(0.5, -150, 0.6, 0)
frame.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
frame.BorderSizePixel = 1
frame.Parent = screenGui

-- หัวข้อ
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🐮 เลือกสัตว์ในฟาร์ม"
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextColor3 = Color3.fromRGB(0, 0, 0)
title.Parent = frame

-- กล่องแสดงรายชื่อสัตว์
local petList = Instance.new("ScrollingFrame")
petList.Size = UDim2.new(1, -20, 1, -80)
petList.Position = UDim2.new(0, 10, 0, 40)
petList.CanvasSize = UDim2.new(0, 0, 0, 0)
petList.ScrollBarThickness = 6
petList.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
petList.BorderSizePixel = 1
petList.Parent = frame

-- UIListLayout เพื่อจัดเรียงปุ่มสัตว์
local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 6)
listLayout.Parent = petList

-- ปุ่ม Freeze / Pull
local freezeButton = Instance.new("TextButton")
freezeButton.Size = UDim2.new(0, 130, 0, 40)
freezeButton.Position = UDim2.new(0.5, -140, 1, -35)
freezeButton.Text = "❄️ หยุด / ปล่อยสัตว์"
freezeButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
freezeButton.TextColor3 = Color3.new(1, 1, 1)
freezeButton.Font = Enum.Font.GothamBold
freezeButton.TextSize = 18
freezeButton.Parent = frame

local pullButton = Instance.new("TextButton")
pullButton.Size = UDim2.new(0, 130, 0, 40)
pullButton.Position = UDim2.new(0.5, 10, 1, -35)
pullButton.Text = "🧲 ดึงสัตว์มาหา"
pullButton.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
pullButton.TextColor3 = Color3.new(1, 1, 1)
pullButton.Font = Enum.Font.GothamBold
pullButton.TextSize = 18
pullButton.Parent = frame

-- ตัวแปรเก็บชื่อสัตว์ที่เลือก
local selectedPetName = nil

-- ฟังก์ชันสร้างปุ่มสัตว์ในรายชื่อ
local function createPetButton(petName)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 35)
	btn.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
	btn.TextColor3 = Color3.new(0, 0, 0)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 18
	btn.Text = petName
	btn.Parent = petList

	btn.MouseButton1Click:Connect(function()
		-- เลือกสัตว์นี้
		selectedPetName = petName
		-- เปลี่ยนสีปุ่มให้ดูว่าเลือกแล้ว
		for _, child in ipairs(petList:GetChildren()) do
			if child:IsA("TextButton") then
				child.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
			end
		end
		btn.BackgroundColor3 = Color3.fromRGB(100, 180, 255)
	end)
end

-- โหลดรายชื่อสัตว์จาก workspace
local function refreshPetList()
	-- ลบปุ่มเก่าออกก่อน
	for _, child in ipairs(petList:GetChildren()) do
		if child:IsA("TextButton") then
			child:Destroy()
		end
	end

	for _, pet in ipairs(workspace:GetChildren()) do
		if pet:IsA("Model") and pet:FindFirstChildOfClass("Humanoid") then
			createPetButton(pet.Name)
		end
	end

	-- ปรับ CanvasSize ให้เลื่อนได้
	local layout = petList:FindFirstChildOfClass("UIListLayout")
	if layout then
		petList.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
	end
end

refreshPetList()

-- RemoteEvents
local freezeEvent = ReplicatedStorage:WaitForChild("FreezeToggleEvent")
local pullEvent = ReplicatedStorage:WaitForChild("PullPetEvent")

-- ปุ่ม Freeze
freezeButton.MouseButton1Click:Connect(function()
	if selectedPetName then
		freezeEvent:FireServer(selectedPetName)
	end
end)

-- ปุ่ม Pull
pullButton.MouseButton1Click:Connect(function()
	if selectedPetName then
		pullEvent:FireServer(selectedPetName)
	end
end)

-- (ถ้าต้องการ) รีเฟรชรายการทุก 10 วินาที
--[[
while true do
	wait(10)
	refreshPetList()
end
]]
