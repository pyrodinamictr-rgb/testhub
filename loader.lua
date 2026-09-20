--[[ ⚡ SH Custom v2 - ENI & LO | F4: aç/kapa ]]

local P = game:GetService("Players").LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local WS = game:GetService("Workspace")
local UIS = game:GetService("UserInputService")
local SG = game:GetService("StarterGui")
local VIM = game:GetService("VirtualInputManager")
local EV = RS:WaitForChild("Events")

-- Remote map (kısa erişim)
local R = {}
for _, f in pairs(EV:GetChildren()) do
    if f:IsA("Folder") then
        R[f.Name] = {}
        for _, r in pairs(f:GetChildren()) do R[f.Name][r.Name] = r end
    end
end

-- Togglelar
local T = {grade=false, repair=false, wash=false, sell=false, npc=false, esp=false, spy=false, afk=true}

-- ============ GUI BUILDER ============
local function c(class, props, parent)
    local i = Instance.new(class)
    for k, v in pairs(props) do i[k] = v end
    if parent then i.Parent = parent end
    return i
end

local function corner(p, r) c("UICorner", {CornerRadius = UDim.new(0, r or 8)}, p) end
local function pad(p, l, r, t, b)
    c("UIPadding", {PaddingLeft=UDim.new(0,l or 8), PaddingRight=UDim.new(0,r or 8), PaddingTop=UDim.new(0,t or 4), PaddingBottom=UDim.new(0,b or 4)}, p)
end

-- Screen GUI
local gui = c("ScreenGui", {Name="SHv2", ResetOnSpawn=false, ZIndexBehavior=Enum.ZIndexBehavior.Sibling}, P:WaitForChild("PlayerGui"))

-- Ana container
local main = c("Frame", {
    Size = UDim2.new(0, 420, 0, 340),
    Position = UDim2.new(0.5, -210, 0.5, -170),
    BackgroundColor3 = Color3.fromRGB(12, 12, 22),
    BackgroundTransparency = 0.05,
    BorderSizePixel = 0, Active = true, Draggable = true
}, gui)
corner(main, 14)
c("UIStroke", {Color=Color3.fromRGB(90, 60, 200), Thickness=1.5, Transparency=0.3}, main)

-- Üst bar
local topBar = c("Frame", {
    Size = UDim2.new(1, 0, 0, 38),
    BackgroundColor3 = Color3.fromRGB(20, 16, 40),
    BorderSizePixel = 0
}, main)
corner(topBar, 14)
-- Alt köşeleri düzelt
c("Frame", {Size=UDim2.new(1,0,0,14), Position=UDim2.new(0,0,1,-14), BackgroundColor3=Color3.fromRGB(20,16,40), BorderSizePixel=0}, topBar)

c("TextLabel", {
    Size = UDim2.new(1, -80, 1, 0),
    Position = UDim2.new(0, 14, 0, 0),
    BackgroundTransparency = 1,
    Text = "⚡ SH Custom v2",
    TextColor3 = Color3.fromRGB(180, 140, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    TextXAlignment = Enum.TextXAlignment.Left
}, topBar)

-- Minimize butonu
local minBtn = c("TextButton", {
    Size = UDim2.new(0, 30, 0, 30),
    Position = UDim2.new(1, -38, 0, 4),
    BackgroundColor3 = Color3.fromRGB(60, 40, 120),
    Text = "─", TextColor3 = Color3.fromRGB(200, 200, 220),
    Font = Enum.Font.GothamBold, TextSize = 14
}, topBar)
corner(minBtn, 6)

-- Tab bar (sol taraf)
local sidebar = c("Frame", {
    Size = UDim2.new(0, 90, 1, -44),
    Position = UDim2.new(0, 4, 0, 42),
    BackgroundTransparency = 1
}, main)
c("UIListLayout", {Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder}, sidebar)

-- İçerik alanı
local content = c("Frame", {
    Size = UDim2.new(1, -102, 1, -48),
    Position = UDim2.new(0, 98, 0, 44),
    BackgroundColor3 = Color3.fromRGB(18, 18, 32),
    BackgroundTransparency = 0.3,
    BorderSizePixel = 0
}, main)
corner(content, 10)

-- Tab sayfaları
local pages = {}
local tabs = {"Otomasyon", "Teleport", "ESP", "Araçlar"}
local icons = {"🤖", "📍", "👁️", "🔧"}
local activeTab = nil

local function makePage(name)
    local page = c("ScrollingFrame", {
        Name = name, Size = UDim2.new(1, -8, 1, -8),
        Position = UDim2.new(0, 4, 0, 4),
        BackgroundTransparency = 1,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Color3.fromRGB(90, 60, 200),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false
    }, content)
    c("UIListLayout", {Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder}, page)
    pad(page, 4, 4, 4, 4)
    pages[name] = page
    return page
end

local function switchTab(name)
    for n, p in pairs(pages) do p.Visible = (n == name) end
    for _, btn in pairs(sidebar:GetChildren()) do
        if btn:IsA("TextButton") then
            btn.BackgroundColor3 = btn.Name == name and Color3.fromRGB(50, 30, 110) or Color3.fromRGB(25, 22, 45)
        end
    end
    activeTab = name
end

-- Tab butonları oluştur
for i, name in ipairs(tabs) do
    makePage(name)
    local tab = c("TextButton", {
        Name = name,
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundColor3 = Color3.fromRGB(25, 22, 45),
        Text = icons[i] .. " " .. name,
        TextColor3 = Color3.fromRGB(190, 180, 220),
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        LayoutOrder = i
    }, sidebar)
    corner(tab, 8)
    tab.MouseButton1Click:Connect(function() switchTab(name) end)
    tab.MouseEnter:Connect(function()
        if activeTab ~= name then tab.BackgroundColor3 = Color3.fromRGB(35, 30, 65) end
    end)
    tab.MouseLeave:Connect(function()
        if activeTab ~= name then tab.BackgroundColor3 = Color3.fromRGB(25, 22, 45) end
    end)
end

-- ============ TOGGLE SWITCH ============
local function makeToggle(page, label, key, order)
    local row = c("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = Color3.fromRGB(25, 25, 42),
        BorderSizePixel = 0, LayoutOrder = order or 0
    }, page)
    corner(row, 7)

    c("TextLabel", {
        Size = UDim2.new(1, -56, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = label,
        TextColor3 = Color3.fromRGB(200, 200, 220),
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left
    }, row)

    local toggleBg = c("Frame", {
        Size = UDim2.new(0, 40, 0, 20),
        Position = UDim2.new(1, -48, 0.5, -10),
        BackgroundColor3 = Color3.fromRGB(60, 30, 30),
        BorderSizePixel = 0
    }, row)
    corner(toggleBg, 10)

    local knob = c("Frame", {
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(0, 2, 0, 2),
        BackgroundColor3 = Color3.fromRGB(180, 80, 80),
        BorderSizePixel = 0
    }, toggleBg)
    corner(knob, 8)

    local btn = c("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1, Text = ""
    }, row)

    btn.MouseButton1Click:Connect(function()
        T[key] = not T[key]
        if T[key] then
            toggleBg.BackgroundColor3 = Color3.fromRGB(25, 70, 40)
            knob.BackgroundColor3 = Color3.fromRGB(60, 220, 100)
            knob.Position = UDim2.new(0, 22, 0, 2)
        else
            toggleBg.BackgroundColor3 = Color3.fromRGB(60, 30, 30)
            knob.BackgroundColor3 = Color3.fromRGB(180, 80, 80)
            knob.Position = UDim2.new(0, 2, 0, 2)
        end
    end)
    return btn
end

-- ============ TELEPORT BUTONU ============
local function makeTpBtn(page, label, target, order)
    local btn = c("TextButton", {
        Size = UDim2.new(1, 0, 0, 28),
        BackgroundColor3 = Color3.fromRGB(28, 28, 50),
        Text = "  " .. label,
        TextColor3 = Color3.fromRGB(180, 180, 210),
        Font = Enum.Font.Gotham, TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = order
    }, page)
    corner(btn, 7)
    pad(btn, 8)

    btn.MouseEnter:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(40, 35, 70) end)
    btn.MouseLeave:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(28, 28, 50) end)

    btn.MouseButton1Click:Connect(function()
        local char = P.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root or not target then return end
        local part = target:IsA("BasePart") and target
            or (target:IsA("Model") and target.PrimaryPart)
            or target:FindFirstChildWhichIsA("BasePart", true)
        if part then root.CFrame = part.CFrame + Vector3.new(0, 5, 0) end
    end)
end

-- ============ SAYFALARI DOLDUR ============

-- OTOMASYON
local autoPage = pages["Otomasyon"]
makeToggle(autoPage, "Auto Collect Grade", "grade", 1)
makeToggle(autoPage, "Auto Collect Repair", "repair", 2)
makeToggle(autoPage, "Auto Collect Wash", "wash", 3)
makeToggle(autoPage, "Auto Sell (Pawn)", "sell", 4)
makeToggle(autoPage, "Auto Accept NPC", "npc", 5)
makeToggle(autoPage, "Anti-AFK", "afk", 6)

-- TELEPORT
local tpPage = pages["Teleport"]
local ord = 1
local areas = WS:FindFirstChild("Areas")
if areas then
    c("TextLabel", {Size=UDim2.new(1,0,0,20), BackgroundTransparency=1, Text="── Bölgeler ──", TextColor3=Color3.fromRGB(90,60,200), Font=Enum.Font.GothamBold, TextSize=11, LayoutOrder=0}, tpPage)
    for _, a in pairs(areas:GetChildren()) do
        makeTpBtn(tpPage, "📍 " .. a.Name, a, ord)
        ord = ord + 1
    end
end
local shops = WS:FindFirstChild("Shops")
if shops then
    c("TextLabel", {Size=UDim2.new(1,0,0,20), BackgroundTransparency=1, Text="── Dükkanlar ──", TextColor3=Color3.fromRGB(90,60,200), Font=Enum.Font.GothamBold, TextSize=11, LayoutOrder=ord}, tpPage)
    ord = ord + 1
    for _, s in pairs(shops:GetChildren()) do
        makeTpBtn(tpPage, "🏪 " .. s.Name, s, ord)
        ord = ord + 1
    end
end

-- ESP
local espPage = pages["ESP"]
makeToggle(espPage, "Item ESP", "esp", 1)

-- ARAÇLAR
local toolPage = pages["Araçlar"]
makeToggle(toolPage, "Auction Remote Spy", "spy", 1)

-- Envanter butonu
local invBtn = c("TextButton", {
    Size = UDim2.new(1, 0, 0, 30),
    BackgroundColor3 = Color3.fromRGB(35, 30, 60),
    Text = "📦 Envanteri Kaydet",
    TextColor3 = Color3.fromRGB(200, 200, 220),
    Font = Enum.Font.GothamBold, TextSize = 12,
    LayoutOrder = 2
}, toolPage)
corner(invBtn, 7)
invBtn.MouseButton1Click:Connect(function()
    pcall(function()
        local inv = R.Inventory.GetPlayerInventory:InvokeServer()
        local txt = ""
        if inv then
            for id, data in pairs(inv) do
                txt = txt .. tostring(id) .. ": " .. tostring(data.name or data.Name or "?") .. "\n"
            end
        end
        writefile("envanter.txt", txt)
        SG:SetCore("SendNotification", {Title="📦", Text="envanter.txt kaydedildi", Duration=3})
    end)
end)

-- İlk tab
switchTab("Otomasyon")

-- ============ MINIMIZE ============
local expanded = true
minBtn.MouseButton1Click:Connect(function()
    expanded = not expanded
    content.Visible = expanded
    sidebar.Visible = expanded
    main.Size = expanded and UDim2.new(0, 420, 0, 340) or UDim2.new(0, 200, 0, 38)
    minBtn.Text = expanded and "─" or "+"
end)

-- F4 toggle
UIS.InputBegan:Connect(function(i, g)
    if g then return end
    if i.KeyCode == Enum.KeyCode.F4 then main.Visible = not main.Visible end
end)

-- ============ LOOPS ============
-- Tek loop, hepsini yönetir
task.spawn(function()
    while task.wait(3) do
        -- Auto Collect (Grade/Repair/Wash)
        for _, info in pairs({
            {T.grade, R.Grading, "GetSlotState", "CollectGrade", "ClaimGradedItem"},
            {T.repair, R.Repair, "GetSlotState", "CollectRepair", "ClaimRepairedItem"},
            {T.wash, R.Wash, "GetSlotState", "CollectWash", "ClaimWashedItem"},
        }) do
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
        -- Auto Sell
        if T.sell then
            pcall(function()
                local items = R.Pawn.GetSellableItems:InvokeServer()
                if items and #items > 0 then R.Pawn.SellItems:InvokeServer(items) end
            end)
        end
    end
end)

-- Anti-AFK
task.spawn(function()
    while task.wait(55) do
        if T.afk then
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
        if T.npc then
            task.wait(0.3)
            pcall(function() R.NPCShopper.RespondOffer:FireServer(true) end)
        end
    end)
end)

-- ESP Loop
local espHolder = c("Folder", {Name = "ESP"}, gui)
task.spawn(function()
    while task.wait(2) do
        espHolder:ClearAllChildren()
        if T.esp then
            local carry = WS:FindFirstChild("_Carryables")
            if carry then
                for _, item in pairs(carry:GetChildren()) do
                    pcall(function()
                        local p = item:IsA("BasePart") and item or item:FindFirstChildWhichIsA("BasePart", true)
                        if p then
                            local bb = c("BillboardGui", {Size=UDim2.new(0,100,0,24), StudsOffset=Vector3.new(0,3,0), AlwaysOnTop=true, Adornee=p}, espHolder)
                            local t = c("TextLabel", {Size=UDim2.new(1,0,1,0), BackgroundColor3=Color3.fromRGB(0,0,0), BackgroundTransparency=0.4, TextColor3=Color3.fromRGB(255,255,50), Text=item.Name, TextScaled=true, Font=Enum.Font.GothamBold}, bb)
                            corner(t, 5)
                        end
                    end)
                end
            end
        end
    end
end)

-- Auction Spy
pcall(function()
    local bid = R.Auction.Bid
    local old = bid.FireServer
    bid.FireServer = function(self, ...)
        if T.spy then
            local a = {...}
            local s = ""
            for i, v in pairs(a) do s = s .. i .. ":" .. tostring(v) .. " | " end
            warn("[SPY] " .. s)
            pcall(function()
                local e = "" pcall(function() e = readfile("spy.txt") end)
                writefile("spy.txt", e .. "\n" .. s)
            end)
        end
        return old(self, ...)
    end
end)

-- Bildirim
pcall(function()
    SG:SetCore("SendNotification", {Title="⚡ SH Custom v2", Text="Yüklendi! F4: aç/kapa", Duration=4})
end)
