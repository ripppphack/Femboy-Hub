local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "Femboy Hub",
    Icon = "door-open",
    Author = "by AI.gemini",
    Folder = "My femboy.gemini"
})

local Tab = Window:Tab({
    Title = "Auto Farm",
    Icon = "bird",
    Locked = false,
})

-- ค่าเริ่มต้นของระบบ
_G.Mon = "Thug"
_G.Cam = CFrame.Angles(math.rad(-90), 0, 0)
local High = 5
_G.Up = CFrame.new(0, High, 0)

-- Dropdown เลือกมอนสเตอร์
local Dropdown = Tab:Dropdown({
    Title = "Select Mob",
    Desc = "เลือกมอนสเตอร์ที่ต้องการฟาร์ม",
    Values = { 
        "Thug",
        "Sneaky",
        "Elite Noob",
        "Cutie Noob",
        "Big Boss",
        "King Slime",
        "Unknown Boss",
        "Cutie",
        "Nooby",
        "King Noob",
        "Sword Master",
        "Sans",
        "Chara",
        "Duck" 
    },
    Value = "Thug",
    Callback = function(option) 
        print("Mobs selected: " .. option) 
        _G.Mon = option
    end
})

-- Sliderปรับความสูง
local Slider = Tab:Slider({
    Title = "High",
    Desc = "ปรับระยะความสูงเหนือตัวมอนสเตอร์",
    Step = 0.1,
    Value = {
        Min = 1,
        Max = 25,
        Default = 5,
    },
    Callback = function(value)
        High = value
        _G.Up = CFrame.new(0, High, 0)
    end
})

-- ฟังก์ชันสำหรับวาร์ปไปหา Target
local function AutoFarm(target)
    pcall(function()
        local player = game.Players.LocalPlayer
        if target and target:FindFirstChild("HumanoidRootPart") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = target.HumanoidRootPart.CFrame * _G.Up * _G.Cam
        end
    end)
end

-- Toggle เปิด/ปิด Auto Farm
local Toggle = Tab:Toggle({
    Title = "Auto Farm",
    Desc = "เปิด/ปิด ระบบฟาร์มอัตโนมัติ",
    Icon = "bird",
    Type = "Checkbox",
    Value = false,
    Callback = function(state) 
        getgenv().On = state
        print("Toggle Activated: " .. tostring(state))
        
        -- ใช้ task.spawn แยก Thread ทำงานลูปเดียว
        if getgenv().On then
            task.spawn(function()
                while getgenv().On do
                    task.wait(0.1)
                    
                    -- ค้นหาใน workspace.NPCs
                    if workspace:FindFirstChild("NPCs") then
                        for _, v in pairs(workspace.NPCs:GetChildren()) do
                            if v.Name == _G.Mon then
                                AutoFarm(v)
                            end
                        end
                        
                        -- ค้นหาเพิ่มเติมใน workspace.NPCs.Boss (ถ้ามี)
                        if workspace.NPCs:FindFirstChild("Boss") then
                            for _, v in pairs(workspace.NPCs.Boss:GetChildren()) do
                                if v.Name == _G.Mon then
                                    AutoFarm(v)
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
})