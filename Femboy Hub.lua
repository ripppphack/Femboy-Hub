local _version = "1.6.66"
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/download/" .. _version .. "/main.lua"))() 

local Window = WindUI:CreateWindow({
    --... ,
    Theme = "Dark" -- enter your chosen theme name
})

local Window = WindUI:CreateWindow({
    Title = "Femboy hub", -- window title
    Icon = "door-open", -- lucide icon or "rbxassetid://" or URL. optional
    Author = "by femboy", -- window subtitle. optional
    Folder = "Femboy hub", -- folder to save keys and images
    
    Size = UDim2.fromOffset(580, 460), -- window size
    MinSize = Vector2.new(560, 350), -- minimal window size
    MaxSize = Vector2.new(850, 560), -- maximum window size
    Transparent = true, -- window transparency
    Theme = "Dark", -- library theme
    Resizable = true, -- the ability to rezize window
    SideBarWidth = 200, -- sidebar (tabs) width
    HideSearchBar = true, -- hide search bar
    ScrollBarEnabled = false, -- scrollbars that are located to the right of the scroll frame
 
    BackgroundImageTransparency = 0.42, -- background image transparency
    Background = "rbxassetid://1234", -- rbxassetid
    
    User = { -- user information located at the bottom left
        Enabled = true, -- can be toggled with Window.User:Enable() or Window.User:Disable()
        Anonymous = true, -- can be toggled with Window.User:SetAnonymous(true) --(true or false)
        Callback = function() -- callback on click. optional. it can be removed
            print("clicked to the 'user icon'")
        end,
    },
    
    KeySystem = { -- key system from this library
        --  ↓ DEPRECATED
        -- Key = { "1234", "5678" },
 
        -- ✓ use this instead:
        KeyValidator = function(enteredKey)
            if enteredKey == "1234" then
                return true -- this means the key is correct
            end
            return false -- this is if the key is not correct 
        end,
 
        Note = "Example Key System.",
        
        Thumbnail = { -- the image which is located on the left. optional. it can be removed
            Image = "rbxassetid://1234",
            Title = "Thumbnail example", -- optional. it can be removed
        },
        URL = "YOUR LINK TO GET KEY (Discord, Linkvertise, Pastebin, etc.)", -- link to get the key
        
        SaveKey = true, -- automatically save and load the key.
    },
})

local Tab = Window:Tab({
    Title = "Auto fram",
    Icon = "bird", -- optional
})

local function Above()
    Above.Orientation = Vector3.new(-90, 0, 0)
    task.wait(1)
    Above.Orientation = Vector3.new(0, 0, 0)
end

local Mobs = {
    ["Thug"] = workspace.NPCs.Thug,
    ["Sneaky"] = workspace.NPCs.Snake,
    ["Elite Noob"] = workspace.NPCs["Elite Noob"],
    ["Cutie Noob"] = workspace.NPCs["Cutie Noob"],
    ["Big boss"] = workspace.NPCs.Boss["Big boss"],
    ["King slime"] = workspace.NPCs["King slime"],
    ["Unknown Boss"] = workspace.NPCs.Boss["Unknown Boss"],
    ["Cutie (Raid)"] = workspace.NPCs.Boss.Cutie,
    ["Nooby"] = workspace.NPCs.Boss.Nooby,
    ["King noob"] = workspace.NPCs.Boss["King noob"],
    ["Sword master"] = workspace.NPCs.Boss["Sword Master"],
    ["Sans"] = workspace.NPCs.Boss.Sans,
    ["Chara"] = workspace.NPCs.Boss.Chara,
    ["Duck"] = workspace.NPCs.Boss.Duck
}

Tab:Dropdown({
    Title = "Choose mobs",
    Values = {
    "Thug",
    "Sneaky",
    "Elite Noob",
    "Cutie Noob",
    "Big boss",
    "King slime",
    "Unknown boss",
    "Cutie (Raid)",
    "Nooby",
    "King noob",
    "Sword master",
    "Sans",
    "Chara",
    "Duck"
    },
    Value = "Cute Thug",
    Callback = function(Mobs selected)
        print("Mobs:", Mobs selected)
    end
})

local Toggle = Tab:Toggle({
    Title = "Enable Auto fram",
    Callback = function(state)
    print("Toggle state:", state)
    _G.ON = state
    _G.TP = state
    _G.Mon = "Mobs selected"
    _G.abc = CFrame.new(0, 5, 0);
    _G.kp = CFrame.Angles(math.rad(-90), 0, 0);
    while _G.ON == true do
        _G.Mon = "selected"
        Callback = function(Mobs selected)
        local Folder = Mobs[Mobs selected]
    end

while _G.TP do
    task.wait()

    local Target = Mobs[_G.Mon]

    if Target and Target:FindFirstChild("Humanoid") then
        if Target.Humanoid.Health <= 0 then

            for _, v in pairs(Folder:GetChildren()) do
                if v.Name == _G.Mon
                    and v:FindFirstChild("Humanoid")
                    and v.Humanoid.Health > 0 then

                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                        v.HumanoidRootPart.CFrame * _G.abc * _G.kp

                    break
                end
            end

        else
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                Target.HumanoidRootPart.CFrame * _G.abc * _G.kp
        end
    end
end

    end
})
