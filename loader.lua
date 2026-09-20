--[[
    SH Custom v4 - by pyrodinamictr-rgb
    Storage Hunters: Open World
    Harici kutuphane yok, kesin calisir
    F4: Ac/Kapa | Surukleme | Minimize | Tab Menu
]]

local P = game:GetService("Players").LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local WS = game:GetService("Workspace")
local UIS = game:GetService("UserInputService")
local SG = game:GetService("StarterGui")
local VIM = game:GetService("VirtualInputManager")
local TS = game:GetService("TweenService")
local EV = RS:WaitForChild("Events")

-- Remote map
local R = {}
for _, f in pairs(EV:GetChildren()) do
    if f:IsA("Folder") then
        R[f.Name] = {}
        for _, r in pairs(f:GetChildren()) do R[f.Name][r.Name] = r end
    end
end

-- Togglelar
local T = {grade=false,repair=false,wash=false,lock=false,sell=false,npc=false,esp=false,npcEsp=false,spy=false,afk=true}
local sliders = {sellInterval=5, collectInterval=3, espDist=500, walkSpeed=16, jumpPower=50}

-- Tema renkleri
local C = {
    bg = Color3.fromRGB(14, 14, 24),
    topbar = Color3.fromRGB(22, 18, 38),
    sidebar = Color3.fromRGB(18, 16, 32),
    content = Color3.fromRGB(20, 20, 34),
    card = Color3.fromRGB(28, 26, 48),
    cardHover = Color3.fromRGB(38, 34, 62),
    accent = Color3.fromRGB(110, 70, 220),
    accentLight = Color3.fromRGB(140, 100, 255),
    toggleOn = Color3.fromRGB(60, 200, 100),
    toggleOff = Color3.fromRGB(70, 40, 40),
    knobOn = Color3.fromRGB(80, 240, 130),
    knobOff = Color3.fromRGB(160, 70, 70),
    text = Color3.fromRGB(210, 210, 230),
    textDim = Color3.fromRGB(130, 130, 160),
    section = Color3.fromRGB(110, 70, 220),
    red = Color3.fromRGB(255, 70, 70),
    green = Color3.fromRGB(70, 220, 100),
    yellow = Color3.fromRGB(255, 220, 50),
}

-- ============ HELPER ============
local function c(class, props, parent)
    local i = Instance.new(class)
    for k, v in pairs(props) do i[k] = v end
    if parent then i.Parent = parent end
    return i
end
local function corner(p, r) c("UICorner", {CornerRadius=UDim.new(0, r or 8)}, p) end
local function tween(obj, props, t)
    TS:Create(obj, TweenInfo.new(t or 0.2, Enum.EasingStyle.Quad), props):Play()
end

-- Bildirim sistemi
local function notify(title, text, dur)
    pcall(function()
        SG:SetCore("SendNotification", {Title=title, Text=text, Duration=dur or 3})
    end)
end

-- ============ GUI ============
-- Eski GUI varsa sil
if P:WaitForChild("PlayerGui"):FindFirstChild("SHv4") then
    P.PlayerGui.SHv4:Destroy()
end
pcall(function()
    if game:GetService("CoreGui"):FindFirstChild("SHCustomESP") then
        game:GetService("CoreGui").SHCustomESP:Destroy()
    end
end)

local gui = c("ScreenGui", {Name="SHv4", ResetOnSpawn=false, ZIndexBehavior=Enum.ZIndexBehavior.Sibling}, P:WaitForChild("PlayerGui"))

local main = c("Frame", {
    Size=UDim2.new(0,460,0,360), Position=UDim2.new(0.5,-230,0.5,-180),
    BackgroundColor3=C.bg, BackgroundTransparency=0.02, BorderSizePixel=0,
    Active=true, Draggable=true, ClipsDescendants=true
}, gui)
corner(main, 14)
c("UIStroke", {Color=C.accent, Thickness=1.5, Transparency=0.5}, main)

-- GÃ¶lge
local shadow = c("ImageLabel", {
    Size=UDim2.new(1,40,1,40), Position=UDim2.new(0,-20,0,-20),
    BackgroundTransparency=1, Image="rbxassetid://6015897843",
    ImageColor3=Color3.new(0,0,0), ImageTransparency=0.5, ScaleType=Enum.ScaleType.Slice,
    SliceCenter=Rect.new(49,49,450,450), ZIndex=0
}, main)

-- ===== TOP BAR =====
local topbar = c("Frame", {Size=UDim2.new(1,0,0,40), BackgroundColor3=C.topbar, BorderSizePixel=0}, main)
corner(topbar, 14)
c("Frame", {Size=UDim2.new(1,0,0,14), Position=UDim2.new(0,0,1,-14), BackgroundColor3=C.topbar, BorderSizePixel=0, ZIndex=2}, topbar)

-- Logo + baslik
c("TextLabel", {
    Size=UDim2.new(0,200,1,0), Position=UDim2.new(0,14,0,0),
    BackgroundTransparency=1, Text="âš¡ SH Custom v4",
    TextColor3=C.accentLight, Font=Enum.Font.GothamBold, TextSize=15,
    TextXAlignment=Enum.TextXAlignment.Left
}, topbar)

c("TextLabel", {
    Size=UDim2.new(0,180,1,0), Position=UDim2.new(0,165,0,0),
    BackgroundTransparency=1, Text="pyrodinamictr-rgb",
    TextColor3=C.textDim, Font=Enum.Font.Gotham, TextSize=10,
    TextXAlignment=Enum.TextXAlignment.Left
}, topbar)

-- Minimize butonu
local minBtn = c("TextButton", {
    Size=UDim2.new(0,28,0,28), Position=UDim2.new(1,-36,0,6),
    BackgroundColor3=C.accent, Text="â”€",
    TextColor3=C.text, Font=Enum.Font.GothamBold, TextSize=14
}, topbar)
corner(minBtn, 6)

-- ===== SIDEBAR =====
local sidebar = c("Frame", {
    Size=UDim2.new(0,80,1,-44), Position=UDim2.new(0,4,0,44),
    BackgroundColor3=C.sidebar, BackgroundTransparency=0.5, BorderSizePixel=0
}, main)
corner(sidebar, 10)
c("UIListLayout", {Padding=UDim.new(0,2), SortOrder=Enum.SortOrder.LayoutOrder, HorizontalAlignment=Enum.HorizontalAlignment.Center}, sidebar)
c("UIPadding", {PaddingTop=UDim.new(0,4)}, sidebar)

-- ===== CONTENT =====
local content = c("Frame", {
    Size=UDim2.new(1,-92,1,-50), Position=UDim2.new(0,88,0,46),
    BackgroundColor3=C.content, BackgroundTransparency=0.3, BorderSizePixel=0
}, main)
corner(content, 10)

-- ===== TAB SYSTEM =====
local pages = {}
local activeTab = nil
local tabButtons = {}
local tabData = {
    {name="Farm", icon="ğŸ¤–", order=1},
    {name="Collect", icon="ğŸ“¦", order=2},
    {name="Teleport", icon="ğŸ“", order=3},
    {name="ESP", icon="ğŸ‘", order=4},
    {name="Tools", icon="ğŸ”§", order=5},
}

local function makePage(name)
    local page = c("ScrollingFrame", {
        Name=name, Size=UDim2.new(1,-10,1,-10), Position=UDim2.new(0,5,0,5),
        BackgroundTransparency=1, ScrollBarThickness=3,
        ScrollBarImageColor3=C.accent, CanvasSize=UDim2.new(0,0,0,0),
        AutomaticCanvasSize=Enum.AutomaticSize.Y, Visible=false
    }, content)
    c("UIListLayout", {Padding=UDim.new(0,4), SortOrder=Enum.SortOrder.LayoutOrder}, page)
    c("UIPadding", {PaddingLeft=UDim.new(0,4), PaddingRight=UDim.new(0,4), PaddingTop=UDim.new(0,4), PaddingBottom=UDim.new(0,4)}, page)
    pages[name] = page
    return page
end

local function switchTab(name)
    for n, p in pairs(pages) do p.Visible = (n == name) end
    for n, btn in pairs(tabButtons) do
        if n == name then
            tween(btn, {BackgroundColor3 = C.accent, BackgroundTransparency = 0})
        else
            tween(btn, {BackgroundColor3 = C.sidebar, BackgroundTransparency = 0.5})
        end
    end
    activeTab = name
end

for _, td in ipairs(tabData) do
    makePage(td.name)
    local btn = c("TextButton", {
        Name=td.name, Size=UDim2.new(0,70,0,50),
        BackgroundColor3=C.sidebar, BackgroundTransparency=0.5,
        Text=td.icon.."\n"..td.name, TextColor3=C.text,
        Font=Enum.Font.GothamBold, TextSize=10, LayoutOrder=td.order,
        AutoButtonColor=false
    }, sidebar)
    corner(btn, 8)
    tabButtons[td.name] = btn
    btn.MouseButton1Click:Connect(function() switchTab(td.name) end)
    btn.MouseEnter:Connect(function()
        if activeTab ~= td.name then tween(btn, {BackgroundTransparency = 0.2}) end
    end)
    btn.MouseLeave:Connect(function()
        if activeTab ~= td.name then tween(btn, {BackgroundTransparency = 0.5}) end
    end)
end

-- ===== UI COMPONENTS =====
local function makeSection(page, text, order)
    local lbl = c("TextLabel", {
        Size=UDim2.new(1,0,0,22), BackgroundTransparency=1,
        Text="â”€â”€ "..text.." â”€â”€", TextColor3=C.section,
        Font=Enum.Font.GothamBold, TextSize=11,
        TextXAlignment=Enum.TextXAlignment.Left, LayoutOrder=order
    }, page)
end

local function makeToggle(page, label, desc, key, order)
    local row = c("Frame", {
        Size=UDim2.new(1,0,0,38), BackgroundColor3=C.card, BorderSizePixel=0, LayoutOrder=order
    }, page)
    corner(row, 8)

    c("TextLabel", {
        Size=UDim2.new(1,-60,0,18), Position=UDim2.new(0,12,0,4),
        BackgroundTransparency=1, Text=label, TextColor3=C.text,
        Font=Enum.Font.GothamBold, TextSize=12, TextXAlignment=Enum.TextXAlignment.Left
    }, row)

    if desc then
        c("TextLabel", {
            Size=UDim2.new(1,-60,0,13), Position=UDim2.new(0,12,0,20),
            BackgroundTransparency=1, Text=desc, TextColor3=C.textDim,
            Font=Enum.Font.Gotham, TextSize=9, TextXAlignment=Enum.TextXAlignment.Left
        }, row)
    end

    local bg = c("Frame", {
        Size=UDim2.new(0,38,0,20), Position=UDim2.new(1,-50,0.5,-10),
        BackgroundColor3=C.toggleOff, BorderSizePixel=0
    }, row)
    corner(bg, 10)

    local knob = c("Frame", {
        Size=UDim2.new(0,16,0,16), Position=UDim2.new(0,2,0,2),
        BackgroundColor3=C.knobOff, BorderSizePixel=0
    }, bg)
    corner(knob, 8)

    local btn = c("TextButton", {Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Text=""}, row)

    local function update()
        if T[key] then
            tween(bg, {BackgroundColor3=C.toggleOn})
            tween(knob, {Position=UDim2.new(0,20,0,2), BackgroundColor3=C.knobOn})
        else
            tween(bg, {BackgroundColor3=C.toggleOff})
            tween(knob, {Position=UDim2.new(0,2,0,2), BackgroundColor3=C.knobOff})
        end
    end

    btn.MouseButton1Click:Connect(function() T[key] = not T[key]; update() end)
    btn.MouseEnter:Connect(function() tween(row, {BackgroundColor3=C.cardHover}) end)
    btn.MouseLeave:Connect(function() tween(row, {BackgroundColor3=C.card}) end)
    update()
end

local function makeSlider(page, label, key, min, max, order)
    local row = c("Frame", {
        Size=UDim2.new(1,0,0,42), BackgroundColor3=C.card, BorderSizePixel=0, LayoutOrder=order
    }, page)
    corner(row, 8)

    local valLabel = c("TextLabel", {
        Size=UDim2.new(0,40,0,18), Position=UDim2.new(1,-52,0,4),
        BackgroundTransparency=1, Text=tostring(sliders[key]),
        TextColor3=C.accentLight, Font=Enum.Font.GothamBold, TextSize=11
    }, row)

    c("TextLabel", {
        Size=UDim2.new(1,-60,0,18), Position=UDim2.new(0,12,0,4),
        BackgroundTransparency=1, Text=label, TextColor3=C.text,
        Font=Enum.Font.GothamBold, TextSize=11, TextXAlignment=Enum.TextXAlignment.Left
    }, row)

    local track = c("Frame", {
        Size=UDim2.new(1,-24,0,6), Position=UDim2.new(0,12,0,28),
        BackgroundColor3=Color3.fromRGB(40,38,60), BorderSizePixel=0
    }, row)
    corner(track, 3)

    local pct = (sliders[key] - min) / (max - min)
    local fill = c("Frame", {
        Size=UDim2.new(pct,0,1,0), BackgroundColor3=C.accent, BorderSizePixel=0
    }, track)
    corner(fill, 3)

    local knob = c("Frame", {
        Size=UDim2.new(0,14,0,14), Position=UDim2.new(pct,-7,0.5,-7),
        BackgroundColor3=C.accentLight, BorderSizePixel=0
    }, track)
    corner(knob, 7)

    local dragging = false
    local hitbox = c("TextButton", {Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Text=""}, track)

    local function updateSlider(input)
        local x = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + x * (max - min))
        sliders[key] = val
        fill.Size = UDim2.new(x, 0, 1, 0)
        knob.Position = UDim2.new(x, -7, 0.5, -7)
        valLabel.Text = tostring(val)
    end

    hitbox.MouseButton1Down:Connect(function()
        dragging = true
        local input = UIS:GetMouseLocation()
        updateSlider({Position = Vector2.new(input.X, input.Y)})
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
end

local function makeButton(page, label, desc, callback, order, color)
    local btn = c("TextButton", {
        Size=UDim2.new(1,0,0,36), BackgroundColor3=color or C.card,
        Text="", BorderSizePixel=0, LayoutOrder=order, AutoButtonColor=false
    }, page)
    corner(btn, 8)

    c("TextLabel", {
        Size=UDim2.new(1,-16,0,16), Position=UDim2.new(0,12,0,4),
        BackgroundTransparency=1, Text=label, TextColor3=C.text,
        Font=Enum.Font.GothamBold, TextSize=12, TextXAlignment=Enum.TextXAlignment.Left
    }, btn)

    if desc then
        c("TextLabel", {
            Size=UDim2.new(1,-16,0,12), Position=UDim2.new(0,12,0,19),
            BackgroundTransparency=1, Text=desc, TextColor3=C.textDim,
            Font=Enum.Font.Gotham, TextSize=9, TextXAlignment=Enum.TextXAlignment.Left
        }, btn)
    end

    btn.MouseButton1Click:Connect(callback)
    btn.MouseEnter:Connect(function() tween(btn, {BackgroundColor3=C.cardHover}) end)
    btn.MouseLeave:Connect(function() tween(btn, {BackgroundColor3=color or C.card}) end)
end

-- Teleport dropdown + buton
local function makeTpSection(page, title, items, itemMap, startOrder)
    makeSection(page, title, startOrder)
    local ord = startOrder + 1
    for _, name in ipairs(items) do
        local btn = c("TextButton", {
            Size=UDim2.new(1,0,0,28), BackgroundColor3=C.card,
            Text="", BorderSizePixel=0, LayoutOrder=ord, AutoButtonColor=false
        }, page)
        corner(btn, 7)
        c("TextLabel", {
            Size=UDim2.new(1,-16,1,0), Position=UDim2.new(0,12,0,0),
            BackgroundTransparency=1, Text="â†’  "..name, TextColor3=C.text,
            Font=Enum.Font.Gotham, TextSize=11, TextXAlignment=Enum.TextXAlignment.Left
        }, btn)
        btn.MouseButton1Click:Connect(function()
            local target = itemMap[name]
            if not target then return end
            local char = P.Character
            if not char then return end
            local root = char:FindFirstChild("HumanoidRootPart")
            if not root then return end
            local part = target:IsA("BasePart") and target
                or (target:IsA("Model") and target.PrimaryPart)
                or target:FindFirstChildWhichIsA("BasePart", true)
            if part then root.CFrame = part.CFrame + Vector3.new(0,5,0) end
            notify("Teleport", name.." konumuna isinlandin!", 2)
        end)
        btn.MouseEnter:Connect(function() tween(btn, {BackgroundColor3=C.cardHover}) end)
        btn.MouseLeave:Connect(function() tween(btn, {BackgroundColor3=C.card}) end)
        ord = ord + 1
    end
    return ord
end

-- ============ SAYFALARI DOLDUR ============

-- FARM
local fp = pages["Farm"]
makeSection(fp, "OTOMASYON", 1)
makeToggle(fp, "Auto Sell (Pawn)", "Esyalari otomatik satar", "sell", 2)
makeToggle(fp, "Auto Accept NPC", "Musteri tekliflerini kabul eder", "npc", 3)
makeToggle(fp, "Anti-AFK", "Oyundan atilmayi engeller", "afk", 4)
makeSlider(fp, "Satis Araligi (sn)", "sellInterval", 2, 30, 5)
makeSection(fp, "HIZLI ISLEM", 6)
makeButton(fp, "âš¡ Hepsini Simdi Sat", "Tum satilabilir esyalari satar", function()
    pcall(function()
        local items = R.Pawn.GetSellableItems:InvokeServer()
        if items and #items > 0 then
            R.Pawn.SellItems:InvokeServer(items)
            notify("Satis", #items.." esya satildi!", 3)
        else notify("Satis", "Satilacak esya yok", 3) end
    end)
end, 7)

-- COLLECT
local cp = pages["Collect"]
makeSection(cp, "OTOMATIK TOPLAMA", 1)
makeToggle(cp, "Auto Collect Grade", "Bitmis gradeleri toplar", "grade", 2)
makeToggle(cp, "Auto Collect Repair", "Bitmis tamirleri toplar", "repair", 3)
makeToggle(cp, "Auto Collect Wash", "Bitmis yikamalari toplar", "wash", 4)
makeToggle(cp, "Auto Collect Locksmith", "Acilmis kasalari toplar", "lock", 5)
makeSlider(cp, "Toplama Araligi (sn)", "collectInterval", 1, 15, 6)
makeSection(cp, "HIZLI ISLEM", 7)
makeButton(cp, "ğŸ“¦ Tumunu Simdi Topla", "Tum slotlari kontrol et ve topla", function()
    local count = 0
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
                        count = count + 1
                    end
                end
            end
        end)
    end
    notify("Toplama", count.." slot toplandi!", 3)
end, 8)

-- TELEPORT
local tp = pages["Teleport"]
local areaNames, shopNames = {}, {}
local areaMap, shopMap = {}, {}
local areas = WS:FindFirstChild("Areas")
if areas then for _, a in pairs(areas:GetChildren()) do table.insert(areaNames, a.Name); areaMap[a.Name]=a end end
local shops = WS:FindFirstChild("Shops")
if shops then for _, s in pairs(shops:GetChildren()) do table.insert(shopNames, s.Name); shopMap[s.Name]=s end end
local nextOrd = makeTpSection(tp, "BOLGELER", areaNames, areaMap, 1)
makeTpSection(tp, "DUKKANLAR", shopNames, shopMap, nextOrd)

makeButton(tp, "ğŸ  Kendi Plotuma Isinlan", nil, function()
    pcall(function() R.Plot.TeleportToPlot:FireServer() end)
    notify("Teleport", "Plotuna isinlaniyorsun!", 2)
end, 100)

-- ESP
local ep = pages["ESP"]
makeSection(ep, "ESP SISTEMI", 1)
makeToggle(ep, "Item ESP", "Tasinabilir esyalari gosterir", "esp", 2)
makeToggle(ep, "NPC Shopper ESP", "Alisveris NPC lerini gosterir", "npcEsp", 3)
makeSlider(ep, "Maks Mesafe (studs)", "espDist", 50, 2000, 4)

-- TOOLS
local toolp = pages["Tools"]
makeSection(toolp, "ARACLAR", 1)
makeToggle(toolp, "Auction Remote Spy", "Bid argÃ¼manlarini yakalar", "spy", 2)
makeSlider(toolp, "Yurume Hizi", "walkSpeed", 16, 150, 3)
makeSlider(toolp, "Ziplama Gucu", "jumpPower", 50, 300, 4)
makeSection(toolp, "BILGI", 5)
makeButton(toolp, "ğŸ“¦ Envanteri Kaydet", "sh_envanter.txt dosyasina yazar", function()
    pcall(function()
        local inv = R.Inventory.GetPlayerInventory:InvokeServer()
        local txt, n = "=== ENVANTER ===\n", 0
        if inv then for id, d in pairs(inv) do
            local name = type(d)=="table" and (d.name or d.Name or d.itemName or "?") or "?"
            txt = txt..id.." | "..tostring(name).."\n"; n=n+1
        end end
        writefile("sh_envanter.txt", txt.."\nToplam: "..n)
        notify("Envanter", n.." esya kaydedildi", 3)
    end)
end, 6)
makeButton(toolp, "â­ Grade Durumu", "Aktif slotlarin durumunu gosterir", function()
    pcall(function()
        local state = R.Grading.GetSlotState:InvokeServer()
        local txt = ""
        if state then for id, d in pairs(state) do txt=txt.."Slot "..id..": "..(d.status or "?").."\n" end end
        notify("Grade", txt ~= "" and txt or "Aktif slot yok", 5)
    end)
end, 7)
makeButton(toolp, "ğŸ’° Pawn Orani", "Satis oranini gosterir", function()
    pcall(function()
        local state = R.Pawn.GetPawnState:InvokeServer()
        if state then notify("Pawn", "Oran: "..tostring(state.rate or state.Rate or state.multiplier or "?"), 4) end
    end)
end, 8)

-- Ä°lk tab
switchTab("Farm")

-- ===== MINIMIZE =====
local expanded = true
minBtn.MouseButton1Click:Connect(function()
    expanded = not expanded
    content.Visible = expanded
    sidebar.Visible = expanded
    tween(main, {Size = expanded and UDim2.new(0,460,0,360) or UDim2.new(0,220,0,40)})
    minBtn.Text = expanded and "â”€" or "+"
end)

-- F4 toggle
UIS.InputBegan:Connect(function(i, g)
    if g then return end
    if i.KeyCode == Enum.KeyCode.F4 then main.Visible = not main.Visible end
end)

-- ============ BACKGROUND LOOPS ============

-- Collect loop
task.spawn(function()
    while task.wait(sliders.collectInterval) do
        for _, info in pairs({
            {T.grade, R.Grading, "GetSlotState", "CollectGrade", "ClaimGradedItem"},
            {T.repair, R.Repair, "GetSlotState", "CollectRepair", "ClaimRepairedItem"},
            {T.wash, R.Wash, "GetSlotState", "CollectWash", "ClaimWashedItem"},
            {T.lock, R.Locksmith, "GetSlotState", "OpenSafe", "ClaimItem"},
        }) do
            if info[1] then
                pcall(function()
                    local state = info[2][info[3]]:InvokeServer()
                    if state then for id, d in pairs(state) do
                        if d.status=="completed" or d.ready then
                            pcall(function() info[2][info[4]]:InvokeServer(id) end)
                            task.wait(0.3)
                            pcall(function() info[2][info[5]]:InvokeServer(id) end)
                        end
                    end end
                end)
            end
        end
    end
end)

-- Sell loop
task.spawn(function()
    while task.wait(sliders.sellInterval) do
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
        if T.afk then pcall(function()
            VIM:SendKeyEvent(true, Enum.KeyCode.F13, false, game)
            task.wait(0.05)
            VIM:SendKeyEvent(false, Enum.KeyCode.F13, false, game)
        end) end
    end
end)

-- NPC Accept
pcall(function()
    R.NPCShopper.OfferPresented.OnClientEvent:Connect(function()
        if T.npc then task.wait(0.2); pcall(function() R.NPCShopper.RespondOffer:FireServer(true) end) end
    end)
end)

-- ESP
local espHolder = Instance.new("Folder")
espHolder.Name = "SHCustomESP"
pcall(function() espHolder.Parent = game:GetService("CoreGui") end)
if not espHolder.Parent then espHolder.Parent = gui end

task.spawn(function()
    while task.wait(1.5) do
        espHolder:ClearAllChildren()
        local root = P.Character and P.Character:FindFirstChild("HumanoidRootPart")
        if not root then continue end

        if T.esp then
            local carry = WS:FindFirstChild("_Carryables")
            if carry then for _, item in pairs(carry:GetChildren()) do pcall(function()
                local p = item:IsA("BasePart") and item or item:FindFirstChildWhichIsA("BasePart", true)
                if p then
                    local dist = math.floor((p.Position - root.Position).Magnitude)
                    if dist <= sliders.espDist then
                        local bb = c("BillboardGui", {Size=UDim2.new(0,110,0,32), StudsOffset=Vector3.new(0,3,0), AlwaysOnTop=true, Adornee=p}, espHolder)
                        local t = c("TextLabel", {Size=UDim2.new(1,0,0.6,0), BackgroundColor3=Color3.new(0,0,0), BackgroundTransparency=0.4, TextColor3=C.yellow, Text=item.Name, TextScaled=true, Font=Enum.Font.GothamBold}, bb)
                        corner(t, 4)
                        c("TextLabel", {Size=UDim2.new(1,0,0.4,0), Position=UDim2.new(0,0,0.6,0), BackgroundTransparency=1, TextColor3=C.textDim, Text=dist.." studs", TextScaled=true, Font=Enum.Font.Gotham}, bb)
                    end
                end
            end) end end
        end

        if T.npcEsp then
            local npcF = WS:FindFirstChild("_NPCShoppers")
            if npcF then for _, npc in pairs(npcF:GetChildren()) do pcall(function()
                local p = npc:FindFirstChildWhichIsA("BasePart", true)
                if p then
                    local bb = c("BillboardGui", {Size=UDim2.new(0,100,0,24), StudsOffset=Vector3.new(0,4,0), AlwaysOnTop=true, Adornee=p}, espHolder)
                    local t = c("TextLabel", {Size=UDim2.new(1,0,1,0), BackgroundColor3=Color3.new(0,0,0), BackgroundTransparency=0.4, TextColor3=C.green, Text="ğŸ›’ "..npc.Name, TextScaled=true, Font=Enum.Font.GothamBold}, bb)
                    corner(t, 4)
                end
            end) end end
        end
    end
end)

-- Speed/Jump loop
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local hum = P.Character and P.Character:FindFirstChild("Humanoid")
            if hum then
                if sliders.walkSpeed ~= 16 then hum.WalkSpeed = sliders.walkSpeed end
                if sliders.jumpPower ~= 50 then hum.JumpPower = sliders.jumpPower end
            end
        end)
    end
end)

-- Auction Spy
pcall(function()
    local bid = R.Auction.Bid
    local old = bid.FireServer
    bid.FireServer = function(self, ...)
        if T.spy then
            local a = {...}
            local s = os.date().." [BID] "
            for i, v in pairs(a) do s = s.."arg"..i.."="..tostring(v).." | " end
            warn(s)
            pcall(function()
                local e = "" pcall(function() e = readfile("sh_spy.txt") end)
                writefile("sh_spy.txt", e..s.."\n")
            end)
        end
        return old(self, ...)
    end
end)

-- Respawn fix
P.CharacterAdded:Connect(function(char)
    task.wait(1)
    pcall(function()
        local hum = char:WaitForChild("Humanoid", 5)
        if hum and sliders.walkSpeed ~= 16 then hum.WalkSpeed = sliders.walkSpeed end
        if hum and sliders.jumpPower ~= 50 then hum.JumpPower = sliders.jumpPower end
    end)
end)

notify("âš¡ SH Custom v4", "Yuklendi! F4 ile ac/kapa", 4)
