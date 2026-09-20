--[[
    âš¡ SH Custom v3 - by pyrodinamictr-rgb
    Storage Hunters: Open World
    Fluent UI | Auto Farm | Teleport | ESP
]]

-- UI Library
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- Services
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local WS = game:GetService("Workspace")
local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")
local LP = Players.LocalPlayer

-- Remote map
local EV = RS:WaitForChild("Events")
local R = {}
for _, f in pairs(EV:GetChildren()) do
    if f:IsA("Folder") then
        R[f.Name] = {}
        for _, r in pairs(f:GetChildren()) do R[f.Name][r.Name] = r end
    end
end

-- Teleport hedeflerini topla
local areaNames, shopNames = {}, {}
local areaMap, shopMap = {}, {}

local areas = WS:FindFirstChild("Areas")
if areas then
    for _, a in pairs(areas:GetChildren()) do
        table.insert(areaNames, a.Name)
        areaMap[a.Name] = a
    end
end

local shops = WS:FindFirstChild("Shops")
if shops then
    for _, s in pairs(shops:GetChildren()) do
        table.insert(shopNames, s.Name)
        shopMap[s.Name] = s
    end
end

-- Teleport fonksiyonu
local function tpTo(target)
    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root or not target then return end
    local part = target:IsA("BasePart") and target
        or (target:IsA("Model") and target.PrimaryPart)
        or target:FindFirstChildWhichIsA("BasePart", true)
    if part then root.CFrame = part.CFrame + Vector3.new(0, 5, 0) end
end

-- ============================================================
--                        FLUENT UI
-- ============================================================

local Window = Fluent:CreateWindow({
    Title = "SH Custom v3",
    SubTitle = "by pyrodinamictr-rgb",
    TabWidth = 140,
    Size = UDim2.fromOffset(520, 400),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.F4
})

local Tabs = {
    Farm     = Window:AddTab({ Title = "Farm",     Icon = "cpu" }),
    Collect  = Window:AddTab({ Title = "Collect",  Icon = "package" }),
    Teleport = Window:AddTab({ Title = "Teleport", Icon = "map-pin" }),
    ESP      = Window:AddTab({ Title = "ESP",      Icon = "eye" }),
    Tools    = Window:AddTab({ Title = "Tools",    Icon = "wrench" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" }),
}

local Options = Fluent.Options

-- ============================================================
--                     TAB: FARM
-- ============================================================

Tabs.Farm:AddParagraph({
    Title = "ğŸ¤– Otomasyon",
    Content = "Otomatik satÄ±ÅŸ ve NPC iÅŸlemleri"
})

-- Auto Sell Pawn
local autoSellActive = false
Tabs.Farm:AddToggle("AutoSell", {
    Title = "Auto Sell (Pawn Shop)",
    Description = "SatÄ±labilir eÅŸyalarÄ± otomatik satar",
    Default = false
}):OnChanged(function(val)
    autoSellActive = val
end)

-- Auto Accept NPC
local autoNPCActive = false
Tabs.Farm:AddToggle("AutoNPC", {
    Title = "Auto Accept NPC Offers",
    Description = "MÃ¼ÅŸteri tekliflerini otomatik kabul eder",
    Default = false
}):OnChanged(function(val)
    autoNPCActive = val
end)

-- Sell interval slider
local sellInterval = 5
Tabs.Farm:AddSlider("SellInterval", {
    Title = "SatÄ±ÅŸ AralÄ±ÄŸÄ± (saniye)",
    Description = "KaÃ§ saniyede bir satÄ±ÅŸ kontrol edilsin",
    Default = 5,
    Min = 2,
    Max = 30,
    Rounding = 0
}):OnChanged(function(val)
    sellInterval = val
end)

-- Anti-AFK
local antiAfkActive = true
Tabs.Farm:AddToggle("AntiAFK", {
    Title = "Anti-AFK",
    Description = "Oyundan atÄ±lmayÄ± engeller",
    Default = true
}):OnChanged(function(val)
    antiAfkActive = val
end)

-- Quick Sell butonu
Tabs.Farm:AddButton({
    Title = "âš¡ Hepsini Åimdi Sat",
    Description = "TÃ¼m satÄ±labilir eÅŸyalarÄ± anÄ±nda satar",
    Callback = function()
        pcall(function()
            local items = R.Pawn.GetSellableItems:InvokeServer()
            if items and #items > 0 then
                R.Pawn.SellItems:InvokeServer(items)
                Fluent:Notify({Title = "SatÄ±ÅŸ", Content = #items .. " eÅŸya satÄ±ldÄ±!", Duration = 3})
            else
                Fluent:Notify({Title = "SatÄ±ÅŸ", Content = "SatÄ±lacak eÅŸya yok", Duration = 3})
            end
        end)
    end
})

-- ============================================================
--                     TAB: COLLECT
-- ============================================================

Tabs.Collect:AddParagraph({
    Title = "ğŸ“¦ Otomatik Toplama",
    Content = "Grade, Repair, Wash, Locksmith slotlarÄ±nÄ± otomatik toplar"
})

-- Auto Collect Grade
local autoGradeActive = false
Tabs.Collect:AddToggle("AutoGrade", {
    Title = "Auto Collect Grade",
    Description = "BitmiÅŸ grade'leri otomatik toplar",
    Default = false
}):OnChanged(function(val)
    autoGradeActive = val
end)

-- Auto Collect Repair
local autoRepairActive = false
Tabs.Collect:AddToggle("AutoRepair", {
    Title = "Auto Collect Repair",
    Description = "BitmiÅŸ tamirleri otomatik toplar",
    Default = false
}):OnChanged(function(val)
    autoRepairActive = val
end)

-- Auto Collect Wash
local autoWashActive = false
Tabs.Collect:AddToggle("AutoWash", {
    Title = "Auto Collect Wash",
    Description = "BitmiÅŸ yÄ±kamalarÄ± otomatik toplar",
    Default = false
}):OnChanged(function(val)
    autoWashActive = val
end)

-- Auto Collect Locksmith
local autoLockActive = false
Tabs.Collect:AddToggle("AutoLock", {
    Title = "Auto Collect Locksmith",
    Description = "AÃ§Ä±lmÄ±ÅŸ kasalarÄ± otomatik toplar",
    Default = false
}):OnChanged(function(val)
    autoLockActive = val
end)

-- Collect interval
local collectInterval = 3
Tabs.Collect:AddSlider("CollectInterval", {
    Title = "Toplama AralÄ±ÄŸÄ± (saniye)",
    Default = 3,
    Min = 1,
    Max = 15,
    Rounding = 0
}):OnChanged(function(val)
    collectInterval = val
end)

-- Collect All butonu
Tabs.Collect:AddButton({
    Title = "ğŸ“¦ TÃ¼mÃ¼nÃ¼ Åimdi Topla",
    Description = "TÃ¼m slotlarÄ± anÄ±nda kontrol et ve topla",
    Callback = function()
        local collected = 0
        for _, info in pairs({
            {R.Grading, "GetSlotState", "CollectGrade", "ClaimGradedItem"},
            {R.Repair, "GetSlotState", "CollectRepair", "ClaimRepairedItem"},
            {R.Wash, "GetSlotState", "CollectWash", "ClaimWashedItem"},
            {R.Locksmith, "GetSlotState", "OpenSafe", "ClaimItem"},
        }) do
            pcall(function()
                local state = info[1][info[2]]:InvokeServer()
                if state then
                    for id, d in pairs(state) do
                        if d.status == "completed" or d.ready then
                            pcall(function() info[1][info[3]]:InvokeServer(id) end)
                            task.wait(0.3)
                            pcall(function() info[1][info[4]]:InvokeServer(id) end)
                            collected = collected + 1
                        end
                    end
                end
            end)
        end
        Fluent:Notify({Title = "Toplama", Content = collected .. " slot toplandÄ±!", Duration = 3})
    end
})

-- ============================================================
--                     TAB: TELEPORT
-- ============================================================

Tabs.Teleport:AddParagraph({
    Title = "ğŸ“ IÅŸÄ±nlanma",
    Content = "BÃ¶lgelere ve dÃ¼kkanlara Ä±ÅŸÄ±nlan"
})

-- Area dropdown
Tabs.Teleport:AddDropdown("AreaTP", {
    Title = "BÃ¶lge SeÃ§",
    Description = "IÅŸÄ±nlanmak istediÄŸin bÃ¶lge",
    Values = areaNames,
    Multi = false,
})

Tabs.Teleport:AddButton({
    Title = "ğŸ“ BÃ¶lgeye IÅŸÄ±nlan",
    Callback = function()
        local sel = Options.AreaTP and Options.AreaTP.Value
        if sel and areaMap[sel] then
            tpTo(areaMap[sel])
            Fluent:Notify({Title = "Teleport", Content = sel .. " bÃ¶lgesine Ä±ÅŸÄ±nlandÄ±n!", Duration = 2})
        end
    end
})

-- Separator
Tabs.Teleport:AddParagraph({
    Title = "ğŸª DÃ¼kkanlar",
    Content = "DÃ¼kkanlara hÄ±zlÄ± Ä±ÅŸÄ±nlanma"
})

-- Shop dropdown
Tabs.Teleport:AddDropdown("ShopTP", {
    Title = "DÃ¼kkan SeÃ§",
    Values = shopNames,
    Multi = false,
})

Tabs.Teleport:AddButton({
    Title = "ğŸª DÃ¼kkana IÅŸÄ±nlan",
    Callback = function()
        local sel = Options.ShopTP and Options.ShopTP.Value
        if sel and shopMap[sel] then
            tpTo(shopMap[sel])
            Fluent:Notify({Title = "Teleport", Content = sel .. " dÃ¼kkanÄ±na Ä±ÅŸÄ±nlandÄ±n!", Duration = 2})
        end
    end
})

-- Plot TP
Tabs.Teleport:AddButton({
    Title = "ğŸ  Kendi Plotuma IÅŸÄ±nlan",
    Callback = function()
        pcall(function()
            R.Plot.TeleportToPlot:FireServer()
            Fluent:Notify({Title = "Teleport", Content = "Plotuna Ä±ÅŸÄ±nlanÄ±yorsun!", Duration = 2})
        end)
    end
})

-- ============================================================
--                     TAB: ESP
-- ============================================================

Tabs.ESP:AddParagraph({
    Title = "ğŸ‘ï¸ ESP Sistemi",
    Content = "EÅŸyalarÄ± ve Ã¶nemli nesneleri duvarlarÄ±n arkasÄ±ndan gÃ¶r"
})

local espActive = false
local espHolder = Instance.new("Folder")
espHolder.Name = "SHCustomESP"
espHolder.Parent = game:GetService("CoreGui")

Tabs.ESP:AddToggle("ESPToggle", {
    Title = "Item ESP",
    Description = "TaÅŸÄ±nabilir eÅŸyalarÄ± gÃ¶sterir",
    Default = false
}):OnChanged(function(val)
    espActive = val
    if not val then espHolder:ClearAllChildren() end
end)

-- ESP renk seÃ§imi
local espColor = Color3.fromRGB(255, 255, 50)
Tabs.ESP:AddDropdown("ESPColor", {
    Title = "ESP Rengi",
    Values = {"SarÄ±", "KÄ±rmÄ±zÄ±", "YeÅŸil", "Mavi", "Beyaz", "Turuncu"},
    Default = "SarÄ±",
    Multi = false
}):OnChanged(function(val)
    local colors = {
        ["SarÄ±"] = Color3.fromRGB(255, 255, 50),
        ["KÄ±rmÄ±zÄ±"] = Color3.fromRGB(255, 60, 60),
        ["YeÅŸil"] = Color3.fromRGB(60, 255, 60),
        ["Mavi"] = Color3.fromRGB(60, 120, 255),
        ["Beyaz"] = Color3.fromRGB(255, 255, 255),
        ["Turuncu"] = Color3.fromRGB(255, 165, 0),
    }
    espColor = colors[val] or espColor
end)

-- ESP mesafe slider
local espMaxDist = 500
Tabs.ESP:AddSlider("ESPDist", {
    Title = "Maksimum Mesafe",
    Description = "KaÃ§ stud uzaklÄ±ÄŸa kadar gÃ¶sterilsin",
    Default = 500,
    Min = 50,
    Max = 2000,
    Rounding = 0
}):OnChanged(function(val)
    espMaxDist = val
end)

-- NPC Shopper ESP
local npcEspActive = false
Tabs.ESP:AddToggle("NPCEsp", {
    Title = "NPC Shopper ESP",
    Description = "AlÄ±ÅŸveriÅŸ yapan NPC'leri gÃ¶sterir",
    Default = false
}):OnChanged(function(val)
    npcEspActive = val
end)

-- ============================================================
--                     TAB: TOOLS
-- ============================================================

Tabs.Tools:AddParagraph({
    Title = "ğŸ”§ AraÃ§lar",
    Content = "Remote spy, envanter ve diÄŸer araÃ§lar"
})

-- Auction Remote Spy
local spyActive = false
Tabs.Tools:AddToggle("AucSpy", {
    Title = "Auction Remote Spy",
    Description = "Bid argÃ¼manlarÄ±nÄ± yakalar ve dosyaya yazar",
    Default = false
}):OnChanged(function(val)
    spyActive = val
end)

-- Envanter kaydet
Tabs.Tools:AddButton({
    Title = "ğŸ“¦ Envanteri Dosyaya Kaydet",
    Description = "TÃ¼m envanterin listesini workspace'e yazar",
    Callback = function()
        pcall(function()
            local inv = R.Inventory.GetPlayerInventory:InvokeServer()
            local txt = "=== ENVANTER ===\n"
            local count = 0
            if inv then
                for id, data in pairs(inv) do
                    local name = "?"
                    if type(data) == "table" then
                        name = data.name or data.Name or data.itemName or tostring(id)
                    end
                    txt = txt .. tostring(id) .. " | " .. tostring(name) .. "\n"
                    count = count + 1
                end
            end
            txt = txt .. "\nToplam: " .. count .. " eÅŸya"
            writefile("sh_envanter.txt", txt)
            Fluent:Notify({Title = "Envanter", Content = count .. " eÅŸya kaydedildi â†’ sh_envanter.txt", Duration = 4})
        end)
    end
})

-- Grading durumu
Tabs.Tools:AddButton({
    Title = "â­ Grade Durumunu Kontrol Et",
    Description = "Aktif grade slotlarÄ±nÄ±n durumunu gÃ¶sterir",
    Callback = function()
        pcall(function()
            local state = R.Grading.GetSlotState:InvokeServer()
            local txt = ""
            if state then
                for id, d in pairs(state) do
                    txt = txt .. "Slot " .. tostring(id) .. ": " .. tostring(d.status or "?") .. "\n"
                end
            end
            Fluent:Notify({Title = "Grade Durumu", Content = txt ~= "" and txt or "Aktif slot yok", Duration = 5})
        end)
    end
})

-- Pawn rate kontrolÃ¼
Tabs.Tools:AddButton({
    Title = "ğŸ’° Pawn OranÄ±nÄ± Kontrol Et",
    Description = "Åu anki satÄ±ÅŸ oranÄ±nÄ± gÃ¶sterir",
    Callback = function()
        pcall(function()
            local state = R.Pawn.GetPawnState:InvokeServer()
            if state then
                local rate = state.rate or state.Rate or state.multiplier or "?"
                Fluent:Notify({Title = "Pawn", Content = "SatÄ±ÅŸ oranÄ±: " .. tostring(rate), Duration = 4})
            end
        end)
    end
})

-- Speed hack
local defaultSpeed = 16
Tabs.Tools:AddSlider("WalkSpeed", {
    Title = "YÃ¼rÃ¼me HÄ±zÄ±",
    Default = 16,
    Min = 16,
    Max = 150,
    Rounding = 0,
    Callback = function(val)
        pcall(function()
            LP.Character.Humanoid.WalkSpeed = val
        end)
    end
})

-- Jump power
Tabs.Tools:AddSlider("JumpPower", {
    Title = "ZÄ±plama GÃ¼cÃ¼",
    Default = 50,
    Min = 50,
    Max = 300,
    Rounding = 0,
    Callback = function(val)
        pcall(function()
            LP.Character.Humanoid.JumpPower = val
        end)
    end
})

-- ============================================================
--                   TAB: SETTINGS
-- ============================================================

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetFolder("SHCustom")
InterfaceManager:SetFolder("SHCustom")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

-- ============================================================
--                    BACKGROUND LOOPS
-- ============================================================

-- Ana collect + sell dÃ¶ngÃ¼sÃ¼
task.spawn(function()
    while task.wait(collectInterval) do
        -- Auto Collect (Grade/Repair/Wash/Locksmith)
        local jobs = {
            {autoGradeActive, R.Grading, "GetSlotState", "CollectGrade", "ClaimGradedItem"},
            {autoRepairActive, R.Repair, "GetSlotState", "CollectRepair", "ClaimRepairedItem"},
            {autoWashActive, R.Wash, "GetSlotState", "CollectWash", "ClaimWashedItem"},
            {autoLockActive, R.Locksmith, "GetSlotState", "OpenSafe", "ClaimItem"},
        }
        for _, info in pairs(jobs) do
            if info[1] then
                pcall(function()
                    local state = info[2][info[3]]:InvokeServer()
                    if state then
                        for id, d in pairs(state) do
                            if d.status == "completed" or d.ready then
                                pcall(function() info[2][info[4]]:InvokeServer(id) end)
                                task.wait(0.3)
                                pcall(function() info[2][info[5]]:InvokeServer(id) end)
                            end
                        end
                    end
                end)
            end
        end
    end
end)

-- Auto Sell dÃ¶ngÃ¼sÃ¼
task.spawn(function()
    while task.wait(sellInterval) do
        if autoSellActive then
            pcall(function()
                local items = R.Pawn.GetSellableItems:InvokeServer()
                if items and #items > 0 then
                    R.Pawn.SellItems:InvokeServer(items)
                end
            end)
        end
    end
end)

-- Anti-AFK
task.spawn(function()
    while task.wait(55) do
        if antiAfkActive then
            pcall(function()
                VIM:SendKeyEvent(true, Enum.KeyCode.F13, false, game)
                task.wait(0.05)
                VIM:SendKeyEvent(false, Enum.KeyCode.F13, false, game)
            end)
        end
    end
end)

-- NPC Auto Accept
pcall(function()
    R.NPCShopper.OfferPresented.OnClientEvent:Connect(function()
        if autoNPCActive then
            task.wait(0.2)
            pcall(function() R.NPCShopper.RespondOffer:FireServer(true) end)
        end
    end)
end)

-- ESP Loop
task.spawn(function()
    while task.wait(1.5) do
        espHolder:ClearAllChildren()
        if espActive then
            local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            local carry = WS:FindFirstChild("_Carryables")
            if carry and root then
                for _, item in pairs(carry:GetChildren()) do
                    pcall(function()
                        local p = item:IsA("BasePart") and item or item:FindFirstChildWhichIsA("BasePart", true)
                        if p and (p.Position - root.Position).Magnitude <= espMaxDist then
                            local dist = math.floor((p.Position - root.Position).Magnitude)
                            local bb = Instance.new("BillboardGui")
                            bb.Size = UDim2.new(0, 120, 0, 36)
                            bb.StudsOffset = Vector3.new(0, 3, 0)
                            bb.AlwaysOnTop = true
                            bb.Adornee = p
                            bb.Parent = espHolder

                            local txt = Instance.new("TextLabel", bb)
                            txt.Size = UDim2.new(1, 0, 0.6, 0)
                            txt.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                            txt.BackgroundTransparency = 0.4
                            txt.TextColor3 = espColor
                            txt.Text = item.Name
                            txt.TextScaled = true
                            txt.Font = Enum.Font.GothamBold
                            Instance.new("UICorner", txt).CornerRadius = UDim.new(0, 5)

                            local dtxt = Instance.new("TextLabel", bb)
                            dtxt.Size = UDim2.new(1, 0, 0.4, 0)
                            dtxt.Position = UDim2.new(0, 0, 0.6, 0)
                            dtxt.BackgroundTransparency = 1
                            dtxt.TextColor3 = Color3.fromRGB(180, 180, 180)
                            dtxt.Text = dist .. " studs"
                            dtxt.TextScaled = true
                            dtxt.Font = Enum.Font.Gotham
                        end
                    end)
                end
            end
        end
        -- NPC ESP
        if npcEspActive then
            local npcFolder = WS:FindFirstChild("_NPCShoppers")
            local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if npcFolder and root then
                for _, npc in pairs(npcFolder:GetChildren()) do
                    pcall(function()
                        local p = npc:FindFirstChildWhichIsA("BasePart", true)
                        if p then
                            local bb = Instance.new("BillboardGui")
                            bb.Size = UDim2.new(0, 100, 0, 24)
                            bb.StudsOffset = Vector3.new(0, 4, 0)
                            bb.AlwaysOnTop = true
                            bb.Adornee = p
                            bb.Parent = espHolder

                            local txt = Instance.new("TextLabel", bb)
                            txt.Size = UDim2.new(1, 0, 1, 0)
                            txt.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                            txt.BackgroundTransparency = 0.4
                            txt.TextColor3 = Color3.fromRGB(100, 255, 100)
                            txt.Text = "ğŸ›’ " .. npc.Name
                            txt.TextScaled = true
                            txt.Font = Enum.Font.GothamBold
                            Instance.new("UICorner", txt).CornerRadius = UDim.new(0, 5)
                        end
                    end)
                end
            end
        end
    end
end)

-- Auction Spy hook
pcall(function()
    local bid = R.Auction.Bid
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        if self == bid and getnamecallmethod() == "FireServer" and spyActive then
            local args = {...}
            local s = "[BID SPY] "
            for i, v in pairs(args) do s = s .. "arg" .. i .. "=" .. tostring(v) .. " | " end
            warn(s)
            pcall(function()
                local e = "" pcall(function() e = readfile("sh_spy.txt") end)
                writefile("sh_spy.txt", e .. os.date() .. " " .. s .. "\n")
            end)
        end
        return oldNamecall(self, ...)
    end))
end)

-- WalkSpeed/JumpPower respawn fix
LP.CharacterAdded:Connect(function(char)
    task.wait(1)
    pcall(function()
        local hum = char:WaitForChild("Humanoid", 5)
        if hum and Options.WalkSpeed then
            hum.WalkSpeed = Options.WalkSpeed.Value
            hum.JumpPower = Options.JumpPower.Value
        end
    end)
end)

-- Ä°lk tab
Window:SelectTab(1)

-- BaÅŸlangÄ±Ã§ bildirimi
Fluent:Notify({
    Title = "âš¡ SH Custom v3",
    Content = "YÃ¼klendi! F4 ile aÃ§/kapa\nby pyrodinamictr-rgb",
    Duration = 5
})
