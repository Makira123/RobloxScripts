-- LocalScript ที่ใช้สร้าง UI และส่งชื่อสัตว์
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "PetControlUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- 🔤 TextBox สำหรับใส่ชื่อสัตว์
local nameBox = Instance.new("TextBox")
nameBox.Size = UDim2.new(0, 200, 0, 40)
nameBox.Position = UDim2.new(0.5, -100, 0.75, 0)
nameBox.PlaceholderText = "ใส่ชื่อสัตว์ เช่น MyPig"
nameBox.Text = ""
nameBox.Font = Enum.Font.Gotham
nameBox.TextSize = 18
nameBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
nameBox.TextColor3 = Color3.new(0, 0, 0)
nameBox.Parent = gui

-- ❄️ ปุ่ม Freeze / Unfreeze
local freezeButton = Instance.new("TextButton")
freezeButton.Size = UDim2.new(0, 200, 0, 50)
freezeButton.Position = UDim2.new(0.5, -100, 0.8, 0)
freezeButton.Text = "❄️ หยุด / ปล่อย"
freezeButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
freezeButton.TextColor3 = Color3.new(1, 1, 1)
freezeButton.Font = Enum.Font.GothamBold
freezeButton.TextSize = 20
freezeButton.Parent = gui

-- 🧲 ปุ่มดึงสัตว์มาหา
local pullButton = Instance.new("TextButton")
pullButton.Size = UDim2.new(0, 200, 0, 50)
pullButton.Position = UDim2.new(0.5, -100, 0.88, 0)
pullButton.Text = "🧲 ดึงสัตว์มาหา"
pullButton.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
pullButton.TextColor3 = Color3.new(1, 1, 1)
pullButton.Font = Enum.Font.GothamBold
pullButton.TextSize = 20
pullButton.Parent = gui

-- RemoteEvents
local freezeEvent = ReplicatedStorage:WaitForChild("FreezeToggleEvent")
local pullEvent = ReplicatedStorage:WaitForChild("PullPetEvent")

-- ปุ่มหยุด/ปล่อย
freezeButton.MouseButton1Click:Connect(function()
    local petName = nameBox.Text
    if petName ~= "" then
        freezeEvent:FireServer(petName)
    end
end)

-- ปุ่มดึงสัตว์
pullButton.MouseButton1Click:Connect(function()
    local petName = nameBox.Text
    if petName ~= "" then
        pullEvent:FireServer(petName)
    end
end)
