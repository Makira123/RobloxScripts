-- LocalScript วางใน StarterPlayerScripts
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ลบ UI เดิม (ถ้ามี)
if playerGui:FindFirstChild("PetUI") then
    playerGui.PetUI:Destroy()
end

-- สร้าง GUI หลัก
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "bunny"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- 🔘 ปุ่ม Freeze/Unfreeze
local freezeBtn = Instance.new("TextButton")
freezeBtn.Name = "FreezeButton"
freezeBtn.Size = UDim2.new(0, 180, 0, 50)
freezeBtn.Position = UDim2.new(0.5, -190, 0.85, 0)
freezeBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
freezeBtn.TextColor3 = Color3.new(1, 1, 1)
freezeBtn.Font = Enum.Font.GothamBold
freezeBtn.TextSize = 20
freezeBtn.BorderSizePixel = 0
freezeBtn.Text = "❄️ หยุด/ปล่อยสัตว์"
freezeBtn.Parent = screenGui

-- 🔘 ปุ่มดึงสัตว์มา
local pullBtn = Instance.new("TextButton")
pullBtn.Name = "PullButton"
pullBtn.Size = UDim2.new(0, 180, 0, 50)
pullBtn.Position = UDim2.new(0.5, 10, 0.85, 0)
pullBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
pullBtn.TextColor3 = Color3.new(1, 1, 1)
pullBtn.Font = Enum.Font.GothamBold
pullBtn.TextSize = 20
pullBtn.BorderSizePixel = 0
pullBtn.Text = "🧲 ดึงสัตว์มาหา"
pullBtn.Parent = screenGui

-- RemoteEvent (ต้องสร้างไว้ใน ReplicatedStorage ก่อน)
local freezeEvent = ReplicatedStorage:WaitForChild("FreezeToggleEvent")
local pullEvent = ReplicatedStorage:WaitForChild("PullPetEvent")

-- Event เมื่อกดปุ่ม
freezeBtn.MouseButton1Click:Connect(function()
    freezeEvent:FireServer()
end)

pullBtn.MouseButton1Click:Connect(function()
    pullEvent:FireServer()
end)
