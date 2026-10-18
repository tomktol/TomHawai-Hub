-- TOM HAWAI HUB V8 - Delta UI compatibility edition
-- Interface only. No game automation or ban protection.
local Players = game:GetService('Players')
local UIS = game:GetService('UserInputService')
local player = Players.LocalPlayer
if not player then warn('TOMHAWAI HUB: LocalPlayer unavailable'); return end
local gui = Instance.new('ScreenGui')
gui.Name = 'TomHawaiHubV8DeltaFix'
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 99999
-- Use the same PlayerGui parent as the confirmed working TOM HUB OK test.
local pg = player:WaitForChild('PlayerGui')
local old = pg:FindFirstChild(gui.Name)
if old then old:Destroy() end
gui.Parent = pg
local function make(class, parent, props)
    local item = Instance.new(class)
    for k,v in pairs(props) do item[k] = v end
    item.Parent = parent
    return item
end
local bg = Color3.fromRGB(12,19,32)
local cyan = Color3.fromRGB(34,211,238)
local white = Color3.fromRGB(238,247,255)
local function round(item, radius) make('UICorner',item,{CornerRadius=UDim.new(0,radius)}) end
local floating = make('TextButton',gui,{
    Name='OpenMenu',Size=UDim2.fromOffset(126,50),Position=UDim2.new(0,18,0.4,0),
    BackgroundColor3=bg,BorderSizePixel=0,Text='TOM HUB',TextColor3=cyan,
    Font=Enum.Font.GothamBold,TextSize=16,Active=true,AutoButtonColor=true,ZIndex=20
})
round(floating,15)
make('UIStroke',floating,{Color=cyan,Thickness=2,Transparency=0.1})
local panel = make('Frame',gui,{
    Name='MainPanel',Size=UDim2.fromOffset(305,350),Position=UDim2.new(0.5,-152,0.5,-175),
    BackgroundColor3=bg,BorderSizePixel=0,Visible=false,Active=true,ZIndex=5
})
round(panel,14)
make('UIStroke',panel,{Color=cyan,Thickness=1.5,Transparency=0.15})
make('TextLabel',panel,{
    Size=UDim2.new(1,-60,0,48),Position=UDim2.fromOffset(15,5),BackgroundTransparency=1,
    Text='TOM HAWAI HUB V8',TextColor3=cyan,TextSize=17,
    Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=6
})
local close = make('TextButton',panel,{
    Size=UDim2.fromOffset(32,32),Position=UDim2.new(1,-43,0,12),
    Text='×',TextColor3=white,TextSize=24,Font=Enum.Font.GothamBold,
    BackgroundColor3=Color3.fromRGB(39,54,76),BorderSizePixel=0,ZIndex=6
})
round(close,9)
make('TextLabel',panel,{
    Size=UDim2.new(1,-24,0,40),Position=UDim2.fromOffset(12,56),
    Text='GIAO DIỆN THỬ NGHIỆM • MOBILE / PC',TextColor3=white,
    TextSize=12,Font=Enum.Font.Gotham,BackgroundTransparency=1,ZIndex=6
})
local scroll = make('ScrollingFrame',panel,{
    Size=UDim2.new(1,-24,1,-110),Position=UDim2.fromOffset(12,102),
    BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=3,
    CanvasSize=UDim2.fromOffset(0,0),ZIndex=6
})
local layout = make('UIListLayout',scroll,{Padding=UDim.new(0,7)})
layout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
    scroll.CanvasSize=UDim2.fromOffset(0,layout.AbsoluteContentSize.Y+10)
end)
local names={'Common','Uncommon','Rare','Epic','Legendary','Mythic','Divine','Secret'}
local selected={}
for _,name in ipairs(names) do
    local row=make('TextButton',scroll,{
        Size=UDim2.new(1,-5,0,37),BackgroundColor3=Color3.fromRGB(29,43,62),
        BorderSizePixel=0,Text='  '..name..'     OFF',TextColor3=white,
        Font=Enum.Font.GothamMedium,TextSize=14,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=7
    })
    round(row,9)
    row.MouseButton1Click:Connect(function()
        selected[name]=not selected[name]
        row.Text='  '..name..(selected[name] and '     ON' or '     OFF')
        row.TextColor3=selected[name] and cyan or white
    end)
end
local function toggle() panel.Visible=not panel.Visible end
floating.MouseButton1Click:Connect(toggle)
close.MouseButton1Click:Connect(function() panel.Visible=false end)
-- Drag via InputChanged; avoid interpreting drag as a click.
local startInput, startPosition, moving
floating.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then
        startInput=input.Position; startPosition=floating.Position; moving=true
    end
end)
UIS.InputChanged:Connect(function(input)
    if not moving or not startInput then return end
    if input.UserInputType~=Enum.UserInputType.Touch and input.UserInputType~=Enum.UserInputType.MouseMovement then return end
    local delta=input.Position-startInput
    if delta.Magnitude>9 then
        floating.Position=UDim2.new(startPosition.X.Scale,startPosition.X.Offset+delta.X,startPosition.Y.Scale,startPosition.Y.Offset+delta.Y)
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then
        moving=false
    end
end)
print('TOM HUB DELTA FIX: UI attached to '..gui.Parent:GetFullName())
