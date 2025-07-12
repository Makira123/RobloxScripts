-- LocalScript (สำหรับมือถือแนวนอน - Landscape)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- สร้าง GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FarmPetControlUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- กรอบหลัก
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 600, 0, 260)
frame.Position = UDim2.new(0.5, -300, 0.65, 0)
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

-- รายการสัตว์ (แนวตั้ง ซ้าย)
local petList = Instance.new("ScrollingFrame")
petList.Size = UDim2.new(0, 260, 0, 200)
petList.Position = UDim2.new(0, 20, 0, 40)
petList.CanvasSize = UDim2.new(0, 0, 0, 0)
petList.ScrollBarThickness = 6
petList.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
petList.BorderSizePixel = 1
petList.Parent = frame

local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 5)
listLayout.Parent = petList

-- ปุ่มควบคุม (ด้านขวา)
local freezeButton = Instance.new("TextButton")
freezeButton.Size = UDim2.new(0, 250, 0, 60)
freezeButton.Position = UDim2.new(0, 320, 0, 70)
freezeButton.Text = "❄️ หยุด / ปล่อยสัตว์"
freezeButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
freezeButton.TextColor3 = Color3.new(1, 1, 1)
freezeButton.Font = Enum.Font.GothamBold
freezeButton.TextSize = 20
freezeButton.Parent = frame

local pullButton = Instance.new("TextButton")
pullButton.Size = UDim2.new(0, 250, 0, 60)
pullButton.Position = UDim2.new(0, 320, 0, 140)
pullButton.Text = "🧲 ดึงสัตว์มาหา"
pullButton.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
pullButton.TextColor3 = Color3.new(1, 1, 1)
pullButton.Font = Enum.Font.GothamBold
pullButton.TextSize = 20
pullButton.Parent = frame

-- ตัวแปรสำหรับสัตว์ที่เลือก
local selectedPetName = nil

-- ฟังก์ชันสร้างปุ่มสัตว์
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
		selectedPetName = petName
		for _, child in ipairs(petList:GetChildren()) do
			if child:IsA("TextButton") then
				child.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
			end
		end
		btn.BackgroundColor3 = Color3.fromRGB(100, 180, 255)
	end)
end

-- โหลดสัตว์จาก workspace
local function refreshPetList()
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

	local layout = petList:FindFirstChildOfClass("UIListLayout")
	if layout then
		petList.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
	end
end

refreshPetList()

-- ส่งคำสั่งไป Server
local freezeEvent = ReplicatedStorage:WaitForChild("FreezeToggleEvent")
local pullEvent = ReplicatedStorage:WaitForChild("PullPetEvent")

freezeButton.MouseButton1Click:Connect(function()
	if selectedPetName then
		freezeEvent:FireServer(selectedPetName)
	end
end)

pullButton.MouseButton1Click:Connect(function()
	if selectedPetName then
		pullEvent:FireServer(selectedPetName)
	end
end)
