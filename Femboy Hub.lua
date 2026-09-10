local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()


WindUI:AddTheme({
    Name = "My Theme", -- theme name
    
    Accent = Color3.fromHex("#18181b"),
    Background = Color3.fromHex("#101010"), -- Accent
    Outline = Color3.fromHex("#FFFFFF"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = Color3.fromHex("#7a7a7a"),
    Button = Color3.fromHex("#52525b"),
    Icon = Color3.fromHex("#a1a1aa"),
})

local Window = WindUI:CreateWindow({
    Title = "Kid hub",
    Icon = "door-open", -- lucide icon. optional
    Author = "By femboy", -- optional
})

local Tab = Window:Tab({
    Title = "Auto fram",
    Icon = "bird", -- optional
    Locked = false,
})

local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local Enemies = workspace:WaitForChild("Enemies")

local SelectedEnemy = nil
local HitboxEnabled = false

local HitboxSize = Vector3.new(20, 20, 20)

local OriginalSizes = {}

--------------------------------------------------
-- หา Root
--------------------------------------------------

local function GetRoot(Enemy)
    return Enemy:FindFirstChild("HumanoidRootPart")
end

--------------------------------------------------
-- รายชื่อมอนแบบไม่ซ้ำ
--------------------------------------------------

local function GetEnemyNames()
    local Names = {}
    local Used = {}

    for _, Enemy in ipairs(Enemies:GetChildren()) do
        local Humanoid = Enemy:FindFirstChildOfClass("Humanoid")
        local Root = GetRoot(Enemy)

        if Humanoid and Root and Humanoid.Health > 0 then
            if not Used[Enemy.Name] then
                Used[Enemy.Name] = true
                table.insert(Names, Enemy.Name)
            end
        end
    end

    table.sort(Names)

    return Names
end

--------------------------------------------------
-- หา "ตัวที่ใกล้ที่สุด" ตามชื่อ
--------------------------------------------------

local function GetNearestEnemy(Name)
    local Character = Player.Character
    local HRP = Character and Character:FindFirstChild("HumanoidRootPart")

    if not HRP then
        return nil
    end

    local Nearest = nil
    local ShortestDistance = math.huge

    for _, Enemy in ipairs(Enemies:GetChildren()) do
        if Enemy.Name == Name then

            local Humanoid = Enemy:FindFirstChildOfClass("Humanoid")
            local Root = GetRoot(Enemy)

            if Humanoid and Root and Humanoid.Health > 0 then

                local Distance =
                    (HRP.Position - Root.Position).Magnitude

                if Distance < ShortestDistance then
                    ShortestDistance = Distance
                    Nearest = Enemy
                end
            end
        end
    end

    return Nearest
end

--------------------------------------------------
-- ขยาย Hitbox
--------------------------------------------------

local function SetHitbox(Enemy, Enabled)
    local Root = GetRoot(Enemy)

    if not Root then
        return
    end

    if Enabled then

        if not OriginalSizes[Root] then
            OriginalSizes[Root] = Root.Size
        end

        Root.Size = HitboxSize
        Root.CanCollide = false

    else

        if OriginalSizes[Root] then
            Root.Size = OriginalSizes[Root]
        end
    end
end

local function UpdateAllHitboxes()
    for _, Enemy in ipairs(Enemies:GetChildren()) do
        SetHitbox(Enemy, HitboxEnabled)
    end
end

--------------------------------------------------
-- Dropdown
--------------------------------------------------

local Dropdown = Tab:Dropdown({
    Title = "เลือกมอน",
    Desc = "ชื่อเดียวกันจะรวมเป็นรายการเดียว",
    Values = GetEnemyNames(),
    Value = nil,

    Callback = function(Value)
        SelectedEnemy = Value
    end
})

--------------------------------------------------
-- ปุ่มวาร์ป
--------------------------------------------------

Tab:Button({
    Title = "วาร์ปไปหามอน",
    Desc = "ไปหาตัวที่ใกล้ที่สุดของชื่อที่เลือก",
    Callback = function()

        if not SelectedEnemy then
            return
        end

        local Character = Player.Character
        local HRP = Character and Character:FindFirstChild("HumanoidRootPart")

        if not HRP then
            return
        end

        local Enemy = GetNearestEnemy(SelectedEnemy)

        if Enemy then
            local Root = GetRoot(Enemy)

            if Root then
                HRP.CFrame =
                    Root.CFrame + Vector3.new(0, 3, 0)
            end
        end
    end
})

--------------------------------------------------
-- Toggle ขยาย Hitbox
--------------------------------------------------

Tab:Toggle({
    Title = "Expand Hitbox",
    Desc = "ขยาย HumanoidRootPart ของมอนทุกตัว",
    Icon = "maximize",
    Type = "Checkbox",
    Value = false,

    Callback = function(Value)
        HitboxEnabled = Value
        UpdateAllHitboxes()
    end
})

--------------------------------------------------
-- มอนเกิดใหม่
--------------------------------------------------

Enemies.ChildAdded:Connect(function(Enemy)
    task.wait(0.1)

    if HitboxEnabled then
        SetHitbox(Enemy, true)
    end
end)

local Tab = Window:Tab({
    Title = "Teleport",
    Icon = "bird", -- optional
    Locked = false,
})