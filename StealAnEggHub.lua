-- Steal an Egg Hub V6 - client-side diagnostic UI
-- Only reads replicated objects and attributes. No server actions.
local Players = game:GetService('Players')
local CollectionService = game:GetService('CollectionService')
local StarterGui = game:GetService('StarterGui')
local player = Players.LocalPlayer
local pg = player:WaitForChild('PlayerGui')
local previous = pg:FindFirstChild('StealAnEggHubV6')
if previous then previous:Destroy() end
local gui = Instance.new('ScreenGui')
gui.Name = 'StealAnEggHubV6'
gui.ResetOnSpawn = false
gui.Parent = pg
local panel = Instance.new('Frame')
panel.Size = UDim2.fromOffset(350, 420)
panel.Position = UDim2.new(0.5,-175,0.5,-210)
panel.BackgroundColor3 = Color3.fromRGB(17,22,34)
panel.Active = true
panel.Draggable = true
panel.Parent = gui
Instance.new('UICorner',panel).CornerRadius = UDim.new(0,12)
local pad = Instance.new('UIPadding',panel)
pad.PaddingTop = UDim.new(0,10)
pad.PaddingLeft = UDim.new(0,12)
pad.PaddingRight = UDim.new(0,12)
local layout = Instance.new('UIListLayout',panel)
layout.Padding = UDim.new(0,7)
local function text(s,h)
 local l=Instance.new('TextLabel')
 l.Size=UDim2.new(1,0,0,h)
 l.BackgroundTransparency=1
 l.TextColor3=Color3.fromRGB(235,242,255)
 l.TextWrapped=true
 l.TextXAlignment=Enum.TextXAlignment.Left
 l.Font=Enum.Font.Gotham
 l.TextSize=14
 l.Text=s
 l.Parent=panel
 return l
end
local heading=text('🥚 STEAL AN EGG HUB V6',30)
heading.Font=Enum.Font.GothamBold
heading.TextSize=18
local status=text('Ready | Client-only tracker',25)
local function btn(s,callback)
 local b=Instance.new('TextButton')
 b.Size=UDim2.new(1,0,0,34)
 b.BackgroundColor3=Color3.fromRGB(40,75,118)
 b.TextColor3=Color3.new(1,1,1)
 b.Font=Enum.Font.GothamSemibold
 b.TextSize=13
 b.Text=s
 b.Parent=panel
 Instance.new('UICorner',b).CornerRadius=UDim.new(0,8)
 b.MouseButton1Click:Connect(function() callback(b) end)
 return b
end
local esp=false
local alert=false
local highlights={}
local known={}
local results=text('Egg Tracker: press Scan Eggs',125)
results.TextYAlignment=Enum.TextYAlignment.Top
local function getEggs()
 local out={}
 local seen={}
 local function add(o)
  if not o or seen[o] or not o:IsDescendantOf(workspace) then return end
  if not (o:IsA('BasePart') or o:IsA('Model')) then return end
  seen[o]=true
  table.insert(out,o)
 end
 for _,o in ipairs(CollectionService:GetTagged('Egg')) do add(o) end
 local folder=workspace:FindFirstChild('Eggs')
 if folder then for _,o in ipairs(folder:GetChildren()) do add(o) end end
 return out
end
local function rarity(o)
 return tostring(o:GetAttribute('Rarity') or 'Unknown')
end
local function clearHighlights()
 for _,h in ipairs(highlights) do if h.Parent then h:Destroy() end end
 table.clear(highlights)
end
local function redraw()
 clearHighlights()
 if not esp then return end
 local colors={Common=Color3.fromRGB(200,200,200),Rare=Color3.fromRGB(60,155,255),Epic=Color3.fromRGB(170,80,255),Legendary=Color3.fromRGB(255,191,40),Mythic=Color3.fromRGB(255,65,110)}
 for _,o in ipairs(getEggs()) do
  local h=Instance.new('Highlight')
  h.Name='EggHubHighlight'
  h.Adornee=o
  h.FillColor=colors[rarity(o)] or Color3.fromRGB(100,230,210)
  h.FillTransparency=0.55
  h.OutlineTransparency=0
  h.Parent=gui
  table.insert(highlights,h)
 end
end
local function scan()
 local eggs=getEggs()
 table.sort(eggs,function(a,b)
  return (tonumber(a:GetAttribute('MoneyPerSecond')) or 0) > (tonumber(b:GetAttribute('MoneyPerSecond')) or 0)
 end)
 local lines={}
 for i,o in ipairs(eggs) do
  if i>6 then break end
  local pet=tostring(o:GetAttribute('PetName') or o.Name)
  local income=o:GetAttribute('MoneyPerSecond')
  table.insert(lines,pet..' ['..rarity(o)..'] | '..(income and ('$'..tostring(income)..'/s') or '$?/s'))
 end
 results.Text=#eggs>0 and table.concat(lines,'\n') or 'No tagged Eggs / Workspace.Eggs found.\nGame may not replicate egg metadata.'
 status.Text='Detected eggs: '..#eggs..' | PlaceId: '..game.PlaceId
 redraw()
end
btn('SCAN EGGS',function() scan() end)
btn('EGG ESP: OFF',function(b)
 esp=not esp
 b.Text='EGG ESP: '..(esp and 'ON' or 'OFF')
 redraw()
end)
btn('RARE EGG ALERT: OFF',function(b)
 alert=not alert
 b.Text='RARE EGG ALERT: '..(alert and 'ON' or 'OFF')
 if alert then
  for _,o in ipairs(getEggs()) do known[o]=true end
 end
end)
btn('HIDE MENU',function() panel.Visible=false end)
local open=Instance.new('TextButton')
open.Size=UDim2.fromOffset(90,34)
open.Position=UDim2.new(0,12,0.5,0)
open.BackgroundColor3=Color3.fromRGB(20,120,170)
open.TextColor3=Color3.new(1,1,1)
open.Text='EGG HUB'
open.Parent=gui
Instance.new('UICorner',open).CornerRadius=UDim.new(0,8)
open.MouseButton1Click:Connect(function() panel.Visible=not panel.Visible end)
local function notify(s)
 pcall(function() StarterGui:SetCore('SendNotification',{Title='Rare Egg Alert',Text=s,Duration=5}) end)
end
local rare={Epic=true,Legendary=true,Mythic=true}
task.spawn(function()
 while gui.Parent do
  task.wait(3)
  local eggs=getEggs()
  local now={}
  for _,o in ipairs(eggs) do
   now[o]=true
   if not known[o] and alert and rare[rarity(o)] then
    notify(tostring(o:GetAttribute('PetName') or o.Name)..' - '..rarity(o))
   end
  end
  known=now
  if esp then redraw() end
 end
end)
scan()
