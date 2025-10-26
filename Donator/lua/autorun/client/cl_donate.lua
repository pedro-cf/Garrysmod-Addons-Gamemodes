
local donatordata = {}

usermessage.Hook("SendDonator", function(msg)
x = #donatordata + 1
donatordata[x] = {}
donatordata[x]["steamID"] = msg:ReadString()
donatordata[x]["name"] = msg:ReadString()
donatordata[x]["note"] = msg:ReadString()
end)

usermessage.Hook("donatorsdone", function()
if !Donatormenu then vgui.Create("Donatormenu") end
Donatormenu:Open()
end)

local PANEL = {}

function PANEL:Init()

Donatormenu = self
self:SetPos(ScrW()*0.1,ScrH()*0.1)
self:SetSize(500,400)
self:SetTitle("Donator Management")
self:SetDraggable( true )
self:ShowCloseButton( true )

self.List = vgui.Create("DListView", self)
self.List:SetPos(10, 32)
self.List:SetSize(self:GetWide()-20, self:GetTall()-140)
self.List:SetMultiSelect(false)
self.List:AddColumn("Steam ID")
self.List:AddColumn("Name")
self.List:AddColumn("Note")
self.List.OnClickLine = function(parent, selected, isselected)
Derma_Query("Steam ID:"..selected:GetValue(1).." Name:"..selected:GetValue(2).." Note:"..selected:GetValue(3), "Remove this entry?",
"Yes", function() 
	RunConsoleCommand("removedonator", selected:GetValue(1))	
	self:Close()
	RunConsoleCommand("donatormenu")
end,
"No", function() end)
end
	
self.box1 = vgui.Create("DTextEntry",self)
self.box1:SetPos( 10 , self:GetTall()-100 )
self.box1:SetTall( 20 )
self.box1:SetWide( 140 )
self.box1:SetEnterAllowed( false )
self.box1:SetValue("Steam ID")
self.box1:SetEditable( true )

self.box2 = vgui.Create("DTextEntry",self)
self.box2:SetPos( 170, self:GetTall()-100 )
self.box2:SetTall( 20 )
self.box2:SetWide( 140 )
self.box2:SetEnterAllowed( false )
self.box2:SetValue("Name")
self.box2:SetEditable( true )

self.box3 = vgui.Create("DTextEntry",self)
self.box3:SetPos( 330 , self:GetTall()-100 )
self.box3:SetTall( 20 )
self.box3:SetWide( 140 )
self.box3:SetEnterAllowed( false )
self.box3:SetValue("Note")
self.box3:SetEditable( true )

self.button = vgui.Create( "DButton", self)
self.button:SetText( "Add Donator" )
self.button:SetPos( 10, self:GetTall()-70 )
self.button:SetSize( 100, 25 )
self.button.DoClick = function ()
    RunConsoleCommand("adddonator", self.box1:GetValue(), self.box2:GetValue(), self.box3:GetValue() )
	self:Close()
	RunConsoleCommand("donatormenu")
end

self.button2 = vgui.Create( "DButton", self)
self.button2:SetText( "Current Players" )
self.button2:SetPos( 10, self:GetTall()-35 )
self.button2:SetSize( 100, 25 )
self.button2.DoClick = function ()
	local menu = DermaMenu()
	for _,v in pairs(player.GetAll()) do
		menu:AddOption(v:Nick(), function()
			Derma_StringRequest("Donator Management", "Note?", "", function(text) 
				RunConsoleCommand("adddonator", v:SteamID(), v:Nick(), text )
				self:Close()
				RunConsoleCommand("donatormenu")
			end)
		
		end)
	end
	menu:Open()
end
 
end

function PANEL:UpdateShit()
self.List:Clear()
 	for t=1, #donatordata do
		self.List:AddLine(donatordata[t]["steamID"], donatordata[t]["name"], donatordata[t]["note"])
	end
end

function PANEL:Open()
	self.KeyboardFocus = false
	RestoreCursorPosition()
	gui.EnableScreenClicker(true)
	self:UpdateShit()
	if self:IsVisible() then return end
	self:MakePopup()
	self:SetVisible(true)
	self:SetKeyboardInputEnabled(true)
	self:SetMouseInputEnabled(true)
end

function PANEL:Close()
	donatordata = {}
	RememberCursorPosition()
	gui.EnableScreenClicker(false)
	if self.KeyboardFocus then return end
	self:SetVisible(false)
	self:SetKeyboardInputEnabled(false)
	self:SetMouseInputEnabled(false)
end

vgui.Register("Donatormenu", PANEL, "DFrame")