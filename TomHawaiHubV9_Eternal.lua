-- TOM HAWAI HUB V9 - compact mobile UI. Interface only; no gameplay automation.
local Players=game:GetService('Players')
local UIS=game:GetService('UserInputService')
local player=Players.LocalPlayer
if not player then return end
local pg=player:WaitForChild('PlayerGui')
local old=pg:FindFirstChild('TomHawaiV9Compact')
if old then old:Destroy() end
local gui=Instance.new('ScreenGui')
gui.Name='TomHawaiV9Compact'; gui.ResetOnSpawn=false; gui.IgnoreGuiInset=true; gui.DisplayOrder=1000; gui.Parent=pg
local function new(class,parent,props)
 local o=Instance.new(class)
 for k,v in pairs(props) do o[k]=v end
 o.Parent=parent; return o
end
local bg=Color3.fromRGB(11,18,31)
local surface=Color3.fromRGB(25,38,58)
local cyan=Color3.fromRGB(37,213,244)
local pale=Color3.fromRGB(239,247,255)
local muted=Color3.fromRGB(159,177,197)
local function corner(o,r) new('UICorner',o,{CornerRadius=UDim.new(0,r)}) end
local function stroke(o) new('UIStroke',o,{Color=cyan,Thickness=1.3,Transparency=0.15}) end
local bubble=new('TextButton',gui,{Name='FloatingMenu',Size=UDim2.fromOffset(68,54),Position=UDim2.new(0,18,0.42,0),BackgroundColor3=bg,Text='TOM\nHUB',TextColor3=cyan,TextSize=15,Font=Enum.Font.GothamBold,BorderSizePixel=0,Active=true,ZIndex=20})
corner(bubble,17);stroke(bubble)
local panel=new('Frame',gui,{Name='Panel',Size=UDim2.fromOffset(294,350),Position=UDim2.new(0.5,-147,0.5,-175),BackgroundColor3=bg,BorderSizePixel=0,Visible=false,Active=true,ZIndex=5})
corner(panel,15);stroke(panel)
local header=new('TextLabel',panel,{Size=UDim2.new(1,-55,0,45),Position=UDim2.fromOffset(14,5),BackgroundTransparency=1,Text='🥚 TOM HAWAI HUB',Font=Enum.Font.GothamBold,TextSize=16,TextColor3=cyan,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=6})
local close=new('TextButton',panel,{Size=UDim2.fromOffset(31,31),Position=UDim2.new(1,-40,0,11),BackgroundColor3=surface,Text='×',TextSize=24,TextColor3=pale,Font=Enum.Font.GothamBold,ZIndex=7})
corner(close,9)
local tabs=new('Frame',panel,{Size=UDim2.new(1,-24,0,35),Position=UDim2.fromOffset(12,53),BackgroundTransparency=1,ZIndex=6})
local content=new('ScrollingFrame',panel,{Size=UDim2.new(1,-24,1,-105),Position=UDim2.fromOffset(12,96),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=3,CanvasSize=UDim2.new(),ZIndex=6})
local layout=new('UIListLayout',content,{Padding=UDim.new(0,7),SortOrder=Enum.SortOrder.LayoutOrder})
layout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function() content.CanvasSize=UDim2.fromOffset(0,layout.AbsoluteContentSize.Y+12) end)
local function clear()
 for _,o in ipairs(content:GetChildren()) do if o~=layout then o:Destroy() end end
 content.CanvasPosition=Vector2.new(0,0)
end
local function label(text,height)
 local o=new('TextLabel',content,{Size=UDim2.new(1,-4,0,height or 42),BackgroundColor3=surface,BorderSizePixel=0,Text=text,TextColor=pale,TextSize=13,TextWrapped=true,Font=Enum.Font.Gotham,LayoutOrder=1,ZIndex=7})
 corner(o,9);return o
end
local function toggle(name,states)
 local row=new('TextButton',content,{Size=UDim2.new(1,-4,0,39),BackgroundColor3=surface,BorderSizePixel=0,Text='',LayoutOrder=1,ZIndex=7})
 corner(row,9)
 new('TextLabel',row,{Size=UDim2.new(1,-70,1,0),Position=UDim2.fromOffset(11,0),BackgroundTransparency=1,Text=name,TextXAlignment=Enum.TextXAlignment.Left,Font=Enum.Font.GothamMedium,TextSize=13,TextColor=pale,ZIndex=8})
 local state=new('TextLabel',row,{Size=UDim2.fromOffset(52,26),Position=UDim2.new(1,-60,0.5,-13),BackgroundColor3=Color3.fromRGB(66,78,96),Text='OFF',TextSize=12,TextColor=pale,Font=Enum.Font.GothamBold,ZIndex=8})
 corner(state,13)
 local function paint() state.Text=states[name] and 'ON' or 'OFF';state.BackgroundColor3=states[name] and Color3.fromRGB(12,135,157) or Color3.fromRGB(66,78,96) end
 paint();row.MouseButton1Click:Connect(function()states[name]=not states[name];paint() end)
end
local chosen={}
local function render(which)
 clear()
 if which=='Trứng' then
  label('Chọn loại trứng • chỉ lưu lựa chọn, chưa tự nhặt',46)
  for _,name in ipairs({'Common','Uncommon','Rare','Epic','Legendary','Mythic','Divine','Secret','Eternal'}) do toggle(name,chosen) end
 elseif which=='Tính năng' then
  label('Các tính năng bên dưới CHƯA được kết nối với game.',52)
  for _,name in ipairs({'Auto Farm Trứng','Auto Về Nhà','Auto Máy Chạy','Treo AFK','Auto Đánh'}) do
   local item=label(name..'   •   CHƯA CÓ',41)
   item.TextColor=muted
  end
 else
  label('Tìm server ít người: chưa tích hợp API. Không tự chuyển server.',68)
  label('Phiên bản này tập trung sửa nút nổi, thu gọn và kéo thả.',68)
 end
end
local names={'Trứng','Tính năng','Server'}
for i,name in ipairs(names) do
 local tab=new('TextButton',tabs,{Size=UDim2.new(1/3,-4,1,0),Position=UDim2.new((i-1)/3,2,0,0),BackgroundColor3=surface,Text=name,TextSize=12,TextColor=pale,Font=Enum.Font.GothamBold,ZIndex=7})
 corner(tab,9);tab.MouseButton1Click:Connect(function()render(name) end)
end
render('Trứng')
local function show()panel.Visible=not panel.Visible end
close.MouseButton1Click:Connect(function()panel.Visible=false end)
local dragStart,orig,dragged,tracking
bubble.InputBegan:Connect(function(input)
 if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then
  dragStart=input.Position;orig=bubble.Position;dragged=false;tracking=true
 end
end)
UIS.InputChanged:Connect(function(input)
 if tracking and (input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseMovement) then
  local d=input.Position-dragStart
  if d.Magnitude>8 then dragged=true end
  if dragged then
   local maxX=math.max(0,gui.AbsoluteSize.X-bubble.AbsoluteSize.X)
   local maxY=math.max(0,gui.AbsoluteSize.Y-bubble.AbsoluteSize.Y)
   local x=math.clamp(orig.X.Offset+d.X,0,maxX)
   local y=math.clamp(orig.Y.Offset+d.Y,0,maxY)
   -- Convert initial scale-based position to absolute offsets.
   if orig.X.Scale~=0 or orig.Y.Scale~=0 then
    x=math.clamp(orig.X.Scale*gui.AbsoluteSize.X+orig.X.Offset+d.X,0,maxX)
    y=math.clamp(orig.Y.Scale*gui.AbsoluteSize.Y+orig.Y.Offset+d.Y,0,maxY)
   end
   bubble.Position=UDim2.fromOffset(x,y)
  end
 end
end)
UIS.InputEnded:Connect(function(input)
 if tracking and (input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1) then tracking=false end
end)
bubble.MouseButton1Click:Connect(function() if not dragged then show() end end)
print('TOM HAWAI HUB V9: menu loaded')
