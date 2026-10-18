-- TOM HAWAI HUB V8 - MOBILE + PC (BAN THU NGHIEM)
-- Chay bang LocalScript trong Roblox Studio, StarterPlayerScripts.
-- Giao dien tieng Viet, khong ESP, khong tu dong thao tac game.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local old = playerGui:FindFirstChild("TomHawaiHubV8")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "TomHawaiHubV8"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

local function create(class, props, parent)
    local obj = Instance.new(class)
    for k,v in pairs(props) do obj[k] = v end
    obj.Parent = parent
    return obj
end
local function corner(parent, r)
    create("UICorner", {CornerRadius=UDim.new(0,r)}, parent)
end
local bg = Color3.fromRGB(11,18,32)
local panel = Color3.fromRGB(23,36,57)
local cyan = Color3.fromRGB(6,182,212)
local white = Color3.fromRGB(242,248,255)
local muted = Color3.fromRGB(160,176,196)

local frame = create("Frame", {Size=UDim2.fromOffset(340,455),Position=UDim2.new(.5,-170,.5,-227),BackgroundColor3=bg,BorderSizePixel=0,Active=true,Draggable=true},gui)
corner(frame,14)
create("UIStroke", {Color=cyan,Thickness=1,Transparency=.35},frame)
local title = create("TextLabel", {Size=UDim2.new(1,-65,0,48),Position=UDim2.fromOffset(15,3),BackgroundTransparency=1,Text="🥚 TOM HAWAI HUB V8",TextColor3=cyan,TextSize=18,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left},frame)
local minimize = create("TextButton", {Size=UDim2.fromOffset(33,29),Position=UDim2.new(1,-43,0,13),BackgroundColor3=panel,Text="−",TextColor3=white,TextSize=23,Font=Enum.Font.GothamBold},frame)
corner(minimize,8)
local subtitle = create("TextLabel", {Size=UDim2.new(1,-24,0,23),Position=UDim2.fromOffset(12,49),BackgroundTransparency=1,Text="CHỌN LOẠI TRỨNG • CÔNG TẮC ON / OFF",TextColor3=muted,TextSize=11,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left},frame)

local search = create("TextBox", {Size=UDim2.new(1,-24,0,35),Position=UDim2.fromOffset(12,80),BackgroundColor3=panel,Text="",PlaceholderText="Tìm hoặc lọc tên loại trứng...",PlaceholderColor3=muted,TextColor3=white,TextSize=13,Font=Enum.Font.Gotham,ClearTextOnFocus=false},frame)
corner(search,8)
local scroll = create("ScrollingFrame", {Size=UDim2.new(1,-24,0,255),Position=UDim2.fromOffset(12,123),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=4,ScrollBarImageColor3=cyan,CanvasSize=UDim2.fromOffset(0,0)},frame)
local layout = create("UIListLayout", {Padding=UDim.new(0,6),SortOrder=Enum.SortOrder.LayoutOrder},scroll)
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() scroll.CanvasSize=UDim2.fromOffset(0,layout.AbsoluteContentSize.Y+5) end)

-- Danh sach mau; sua / them ten dung voi game neu can.
local types = {"Common","Uncommon","Rare","Epic","Legendary","Mythic","Divine","Secret"}
local enabled = {}
local rows = {}
local function makeRow(name)
    if rows[name] then return end
    enabled[name] = enabled[name] == true
    local row = create("Frame", {Name=name,Size=UDim2.new(1,-6,0,43),BackgroundColor3=panel,BorderSizePixel=0},scroll)
    corner(row,8)
    create("TextLabel", {Size=UDim2.new(1,-85,1,0),Position=UDim2.fromOffset(12,0),BackgroundTransparency=1,Text="🥚 "..name,TextColor3=white,TextSize=14,Font=Enum.Font.GothamMedium,TextXAlignment=Enum.TextXAlignment.Left},row)
    local toggle = create("TextButton", {Size=UDim2.fromOffset(50,26),Position=UDim2.new(1,-62,.5,-13),BackgroundColor3=Color3.fromRGB(76,88,108),Text="",AutoButtonColor=false},row)
    corner(toggle,14)
    local knob = create("Frame", {Size=UDim2.fromOffset(20,20),Position=UDim2.fromOffset(3,3),BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0},toggle)
    corner(knob,10)
    local function render(animate)
        local targetColor = enabled[name] and cyan or Color3.fromRGB(76,88,108)
        local targetPos = enabled[name] and UDim2.fromOffset(27,3) or UDim2.fromOffset(3,3)
        if animate then
            TweenService:Create(toggle,TweenInfo.new(.17),{BackgroundColor3=targetColor}):Play()
            TweenService:Create(knob,TweenInfo.new(.17),{Position=targetPos}):Play()
        else
            toggle.BackgroundColor3=targetColor
            knob.Position=targetPos
        end
    end
    toggle.MouseButton1Click:Connect(function() enabled[name]=not enabled[name];render(true) end)
    rows[name]={frame=row,render=render}
    render(false)
end
for _,name in ipairs(types) do makeRow(name) end

-- Co the them loai trung do game cung cap bang:
-- _G.TomHawaiAddEggType("TenLoaiTrung")
_G.TomHawaiAddEggType = function(name)
    if type(name)~="string" or name=="" or #name>80 then return end
    makeRow(name)
end
search:GetPropertyChangedSignal("Text"):Connect(function()
    local query=string.lower(search.Text)
    for name,row in pairs(rows) do
        row.frame.Visible = string.find(string.lower(name),query,1,true)~=nil
    end
end)

local function actionButton(label,x,width)
    local btn=create("TextButton",{Size=UDim2.fromOffset(width,31),Position=UDim2.fromOffset(x,389),BackgroundColor3=panel,Text=label,TextColor3=white,TextSize=12,Font=Enum.Font.GothamBold},frame)
    corner(btn,8)
    return btn
end
local all=actionButton("CHỌN TẤT CẢ",12,151)
local none=actionButton("TẮT TẤT CẢ",175,153)
all.MouseButton1Click:Connect(function() for name,row in pairs(rows) do enabled[name]=true;row.render(true) end end)
none.MouseButton1Click:Connect(function() for name,row in pairs(rows) do enabled[name]=false;row.render(true) end end)
local status=create("TextLabel",{Size=UDim2.new(1,-24,0,26),Position=UDim2.fromOffset(12,422),BackgroundTransparency=1,Text="Chọn các loại trứng bạn muốn ưu tiên",TextColor=muted,TextSize=11,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Center},frame)
local save=actionButton("LƯU",0,0)
save.Visible=false
local function updateStatus()
    local n=0
    for _,v in pairs(enabled) do if v then n=n+1 end end
    status.Text="Đã chọn "..n.." loại • Chỉ là cấu hình giao diện"
end
for _,row in pairs(rows) do row.frame.InputBegan:Connect(function() task.defer(updateStatus) end) end
all.MouseButton1Click:Connect(updateStatus)
none.MouseButton1Click:Connect(updateStatus)
-- Panel tim server: chi tim khi bam nut, khong tu dong doi server.
local serverButton = create("TextButton", {Size=UDim2.fromOffset(340,34),Position=UDim2.new(.5,-170,.5,238),BackgroundColor3=cyan,Text="🌐 TÌM SERVER ÍT NGƯỜI",TextColor3=bg,TextSize=13,Font=Enum.Font.GothamBold},gui)
corner(serverButton,9)
local serverPanel = create("Frame", {Size=UDim2.fromOffset(340,390),Position=UDim2.new(.5,-170,.5,-195),BackgroundColor3=bg,BorderSizePixel=0,Visible=false,Active=true,Draggable=true},gui)
corner(serverPanel,12)
create("UIStroke",{Color=cyan,Thickness=1},serverPanel)
create("TextLabel",{Size=UDim2.new(1,-55,0,40),Position=UDim2.fromOffset(12,3),BackgroundTransparency=1,Text="🌐 SERVER ÍT NGƯỜI",TextColor3=cyan,TextSize=16,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left},serverPanel)
local closeServer=create("TextButton",{Size=UDim2.fromOffset(31,29),Position=UDim2.new(1,-40,0,8),BackgroundColor3=panel,Text="X",TextColor3=white,TextSize=15},serverPanel)
corner(closeServer,7)
closeServer.MouseButton1Click:Connect(function()serverPanel.Visible=false end)
serverButton.MouseButton1Click:Connect(function()serverPanel.Visible=not serverPanel.Visible end)
local startSearch=create("TextButton",{Size=UDim2.new(1,-24,0,38),Position=UDim2.fromOffset(12,51),BackgroundColor3=cyan,Text="BẮT ĐẦU TÌM SERVER ÍT NGƯỜI",TextColor3=bg,TextSize=12,Font=Enum.Font.GothamBold},serverPanel)
corner(startSearch,8)
local serverStatus=create("TextLabel",{Size=UDim2.new(1,-24,0,39),Position=UDim2.fromOffset(12,94),BackgroundTransparency=1,Text="Chưa tìm kiếm. Không tự chuyển server.",TextWrapped=true,TextColor3=muted,TextSize=11,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left},serverPanel)
local serverScroll=create("ScrollingFrame",{Size=UDim2.new(1,-24,0,239),Position=UDim2.fromOffset(12,138),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=4,CanvasSize=UDim2.fromOffset(0,0)},serverPanel)
local serverLayout=create("UIListLayout",{Padding=UDim.new(0,6),SortOrder=Enum.SortOrder.LayoutOrder},serverScroll)
serverLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()serverScroll.CanvasSize=UDim2.fromOffset(0,serverLayout.AbsoluteContentSize.Y+8)end)

local function fetchServerPage(cursor)
    -- HTTP Roblox public servers endpoint. HTTP qua LocalScript thong thuong khong duoc ho tro.
    local endpoint="https://games.roblox.com/v1/games/"..tostring(game.PlaceId).."/servers/Public?sortOrder=Asc&limit=100"
    if cursor and cursor~="" then endpoint=endpoint.."&cursor="..HttpService:UrlEncode(cursor) end
    local req=(syn and syn.request) or http_request or request
    if type(req)~="function" then return nil,"Môi trường Lua không hỗ trợ yêu cầu HTTPS." end
    local ok,response=pcall(function()return req({Url=endpoint,Method="GET",Headers={Accept="application/json"}})end)
    if not ok or type(response)~="table" then return nil,"Không kết nối được API server." end
    if tonumber(response.StatusCode)~=200 then return nil,"API trả về HTTP "..tostring(response.StatusCode) end
    local parsed,body=pcall(function()return HttpService:JSONDecode(response.Body)end)
    if not parsed or type(body)~="table" then return nil,"Phản hồi API không hợp lệ." end
    return body
end
local searching=false
local function addServer(server)
    local count=tonumber(server.playing) or 0
    local max=tonumber(server.maxPlayers) or 0
    local row=create("Frame",{Size=UDim2.new(1,-5,0,50),BackgroundColor3=panel,BorderSizePixel=0},serverScroll)
    corner(row,7)
    create("TextLabel",{Size=UDim2.new(1,-112,1,0),Position=UDim2.fromOffset(9,0),BackgroundTransparency=1,Text=string.format("👥 %d / %d người",count,max),TextColor3=white,TextSize=13,Font=Enum.Font.GothamMedium,TextXAlignment=Enum.TextXAlignment.Left},row)
    local join=create("TextButton",{Size=UDim2.fromOffset(94,32),Position=UDim2.new(1,-101,.5,-16),BackgroundColor3=cyan,Text="THAM GIA",TextColor3=bg,TextSize=11,Font=Enum.Font.GothamBold},row)
    corner(join,7)
    join.MouseButton1Click:Connect(function()
        serverStatus.Text="Đang yêu cầu tham gia server "..count.."/"..max.."..."
        local ok,err=pcall(function()TeleportService:TeleportToPlaceInstance(game.PlaceId,server.id,player)end)
        if not ok then serverStatus.Text="Không chuyển được server: "..tostring(err):sub(1,90) end
    end)
end
startSearch.MouseButton1Click:Connect(function()
    if searching then return end
    searching=true
    startSearch.Text="ĐANG TÌM..."
    serverStatus.Text="Đang tải danh sách server công khai..."
    for _,child in ipairs(serverScroll:GetChildren()) do if child:IsA("Frame") then child:Destroy() end end
    task.spawn(function()
        local found={}
        local cursor=nil
        local err=nil
        for _=1,3 do
            local page,e=fetchServerPage(cursor)
            if not page then err=e;break end
            for _,server in ipairs(page.data or {}) do
                if type(server.id)=="string" and server.id~=game.JobId and tonumber(server.playing) and tonumber(server.maxPlayers) and server.playing<server.maxPlayers then
                    table.insert(found,server)
                end
            end
            cursor=page.nextPageCursor
            if not cursor then break end
        end
        table.sort(found,function(a,b)return a.playing<b.playing end)
        for i=1,math.min(#found,12) do addServer(found[i]) end
        if #found>0 then
            serverStatus.Text="Tìm được "..#found.." server còn chỗ; hiện tối đa 12 server ít người nhất. Chọn THAM GIA để chuyển."
        else
            serverStatus.Text=err or "Không tìm thấy server phù hợp. Hãy thử lại sau."
        end
        startSearch.Text="BẮT ĐẦU TÌM SERVER ÍT NGƯỜI"
        searching=false
    end)
end)

local mini=false
minimize.MouseButton1Click:Connect(function()
    mini=not mini
    frame.Size=mini and UDim2.fromOffset(340,53) or UDim2.fromOffset(340,455)
    for _,v in ipairs({subtitle,search,scroll,all,none,status}) do v.Visible=not mini end
    minimize.Text=mini and "+" or "−"
    serverButton.Visible=not mini
    if mini then serverPanel.Visible=false end
end)
-- Tu dong co gian cho man hinh dien thoai / may tinh.
-- Dung UIScale de giu kich thuoc chu, nut va khoang cach dong nhat.
local camera = workspace.CurrentCamera
local mainScale = create("UIScale", {Scale=1}, frame)
local serverScale = create("UIScale", {Scale=1}, serverPanel)
local buttonScale = create("UIScale", {Scale=1}, serverButton)
local function resizeForScreen()
    local cam = workspace.CurrentCamera
    if not cam then return end
    local size = cam.ViewportSize
    local factor = math.min(1, (size.X-24)/360, (size.Y-36)/530)
    factor = math.max(0.55, factor)
    mainScale.Scale = factor
    serverScale.Scale = factor
    buttonScale.Scale = factor
    -- Chinh lai vi tri khi xoay ngang / doc dien thoai.
    frame.Position = UDim2.new(.5,-170*factor,.5,-227*factor)
    serverPanel.Position = UDim2.new(.5,-170*factor,.5,-195*factor)
    serverButton.Position = UDim2.new(.5,-170*factor,.5,238*factor)
end
resizeForScreen()
if camera then camera:GetPropertyChangedSignal("ViewportSize"):Connect(resizeForScreen) end
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    resizeForScreen()
end)
print("TOM HAWAI HUB V8 Mobile + PC: da tai giao dien. Tim server can HTTPS duoc ho tro.")
