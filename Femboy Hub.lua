-- ========================================================
-- Glue Piece Auto Farm Hub with WindUI
-- ========================================================

-- 1. Setup Services & Global Variables
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

getgenv().SelectedTarget = nil
getgenv().AutoFarmToggle = false
getgenv().TweenSpeed = 100 -- ค่าเริ่มต้น (Min: 100, Max: 1000, Step: 100)

-- รายชื่อ NPC ร้านค้า/ระบบ ใน Glue Piece ที่ต้องการคัดออก ไม่ให้บินไปหา
local IgnoredNPCs = {
    ["Epic Sword Seller"] = true,
    ["Boat Seller"] = true,
    ["Geppo Seller"] = true,
    ["Spawn"] = true,
    ["Quest"] = true,
    ["Stats"] = true,
}

-- 2. ฟังก์ชันสแกนหารายชื่อมอนสเตอร์ใน Glue Piece
local function getGluePieceMonsters()
    local monsterNames = {}
    local addedNames = {}

    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj ~= LocalPlayer.Character then
            -- ข้ามหากเป็น ผู้เล่นคนอื่น
            if Players:GetPlayerFromCharacter(obj) then continue end
            
            -- ข้ามหากเป็น NPC ร้านค้า
            if IgnoredNPCs[obj.Name] then continue end

            -- ตรวจสอบว่าเป็น มอนสเตอร์ (มี Humanoid และ HumanoidRootPart ที่ขยับได้)
            local humanoid = obj:FindFirstChildOfClass("Humanoid")
            local hrp = obj:FindFirstChild("HumanoidRootPart") or obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")

            if humanoid and hrp and not hrp.Anchored then
                if not addedNames[obj.Name] then
                    addedNames[obj.Name] = true
                    table.insert(monsterNames, obj.Name)
                end
            end
        end
    end

    table.sort(monsterNames)
    return monsterNames
end

-- 3. ฟังก์ชัน Tween เคลื่อนที่ไปหาเป้าหมาย
local function tweenTo(targetCFrame)
    local character = LocalPlayer.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local distance = (hrp.Position - targetCFrame.Position).Magnitude
    local duration = distance / getgenv().TweenSpeed

    local tweenInfo = TweenInfo.new(
        duration,
        Enum.EasingStyle.Linear,
        Enum.EasingDirection.Out
    )

    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
    tween:Play()

    -- เช็กสถานะการเดินทาง (ยกเลิก Tween ทันทีเมื่อปิด Toggle)
    while tween.PlaybackState == Enum.PlaybackState.Playing do
        if not getgenv().AutoFarmToggle then
            tween:Cancel()
            break
        end
        task.wait(0.05)
    end
end

-- 4. โหลด WindUI Library
local WindUI = loadstring(game:HttpGet("https://tree-hub.vercel.app/api/UI/WindUI"))()

-- สร้าง Window หลัก
local Window = WindUI:CreateWindow({
    Title = "Glue Piece Hub",
    Icon = "sword",
    Author = "Luau Script",
    Folder = "GluePieceConfig",
    Size = UDim2.fromOffset(580, 460),
    Transparent = true,
    Theme = "Dark"
})

-- สร้าง Main Tab
local MainTab = Window:Tab({
    Title = "Auto Farm",
    Icon = "crosshair"
})

-- 5. สแกนหารายชื่อมอนสเตอร์เริ่มต้น
local initialMonsters = getGluePieceMonsters()

-- 5.1 Dropdown เลือกมอนสเตอร์/บอส
local MonsterDropdown = MainTab:Dropdown({
    Title = "Select Monster / Boss",
    Desc = "เลือกมอนสเตอร์ในแมพ Glue Piece ที่ต้องการฟาร์ม",
    Values = #initialMonsters > 0 and initialMonsters or {"No Monsters Found"},
    Value = initialMonsters[1] or "No Monsters Found",
    Callback = function(selectedName)
        getgenv().SelectedTarget = selectedName
        print("[Glue Piece] Target selected:", selectedName)
    end
})

getgenv().SelectedTarget = initialMonsters[1]

-- 5.2 ปุ่ม Refresh รายชื่อมอนสเตอร์
MainTab:Button({
    Title = "Refresh Monster List",
    Desc = "สแกนค้นหามอนสเตอร์ที่เกิดใหม่ในแมพอีกครั้ง",
    Callback = function()
        local updatedMonsters = getGluePieceMonsters()
        if MonsterDropdown.SetValues then
            MonsterDropdown:SetValues(updatedMonsters)
        elseif MonsterDropdown.Refresh then
            MonsterDropdown:Refresh(updatedMonsters)
        end

        WindUI:Notify({
            Title = "Scanner",
            Content = "พบมอนสเตอร์ที่ขยับได้ " .. tostring(#updatedMonsters) .. " รายการ",
            Duration = 3
        })
    end
})

-- 5.3 Slider ปรับความเร็ว Tween (Min: 100, Max: 1000, Step: 100)
MainTab:Slider({
    Title = "Tween Speed",
    Desc = "ปรับความเร็วการบิน (ขั้นต่ำ 100, สูงสุด 1000, ปรับทีละ 100)",
    Step = 100,
    Value = {
        Min = 100,
        Max = 1000,
        Default = 100
    },
    Callback = function(speedValue)
        getgenv().TweenSpeed = speedValue
        print("[Glue Piece] Tween Speed set to:", speedValue)
    end
})

-- 5.4 Toggle เปิด/ปิด Auto Farm
MainTab:Toggle({
    Title = "Enable Auto Farm",
    Desc = "เปิดระบบบิน (Tween) ไปหามอนสเตอร์ที่เลือกไว้",
    Value = false,
    Callback = function(state)
        getgenv().AutoFarmToggle = state

        if state then
            task.spawn(function()
                while getgenv().AutoFarmToggle do
                    task.wait(0.1)

                    local targetName = getgenv().SelectedTarget
                    if not targetName or targetName == "No Monsters Found" then
                        continue
                    end

                    -- ค้นหาตัวมอนสเตอร์เป้าหมายใน Workspace
                    local targetModel = nil
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if obj:IsA("Model") and obj.Name == targetName and obj ~= LocalPlayer.Character then
                            local hum = obj:FindFirstChildOfClass("Humanoid")
                            local hrp = obj:FindFirstChild("HumanoidRootPart") or obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")

                            -- เงื่อนไข: มอนสเตอร์ต้องยังมีชีวิตอยู่และขยับได้ (Unanchored)
                            if hum and hum.Health > 0 and hrp and not hrp.Anchored then
                                targetModel = hrp
                                break
                            end
                        end
                    end

                    -- สั่ง Tween เดินทางไปหา
                    if targetModel and getgenv().AutoFarmToggle do
                        tweenTo(targetModel.CFrame)
                        task.wait(0.5)
                    end
                end
            end)
        end
    end
})
