local Broadcasts = {}
local Broadcast_setttings = {}

net.Receive("broadcast", function(len)
	notification.AddLegacy( net.ReadString(), 0, 10 )
	surface.PlaySound(net.ReadString())
end)

net.Receive("broadcast_ed", function(len)
	Broadcasts = net.ReadTable()
	Broadcast_setttings = net.ReadTable()
end)

local function updateServer()
	net.Start("cl_broadcast")
		net.WriteTable(Broadcasts)
		net.WriteTable(Broadcast_setttings)
	net.SendToServer()
end

local function updateCB(bBox)
	bBox:Clear(true)
	for i, bc in pairs(Broadcasts) do
		bBox:AddChoice(bc)
	end
end

local function broadcastMenu()
	local menu = vgui.Create("DFrame")
		menu:SetSize(490, 140)
		menu:SetTitle("Broadcasts Editor")
		menu:SetVisible(true)
		menu:MakePopup()
		menu:Center()
		menu.btnClose.DoClick = function ( button ) menu:SetVisible(false) end
		menu.btnMaxim:SetVisible(false)
		menu.btnMinim:SetVisible(false)
		
	local panel = vgui.Create("DPanel", menu)
		panel:SetPos(10, 30)
		panel:SetSize(470, 100)
		
	local lbl1 = vgui.Create("DLabel", panel)
		lbl1:SetPos( 11, 15 )
		lbl1:SetText( "Interval:" )
		lbl1:SizeToContents()
		lbl1:SetTextColor(Color(0,0,0,255))
		
	local itv = vgui.Create( "DTextEntry", panel)
		itv:SetPos(65, 12.5)
		itv:SetSize(30, 20)
		itv:SetText(Broadcast_setttings[1] or "")
		itv.OnEnter = function(self)
			if self:GetValue() == NULL or self:GetValue() == "" then 
				surface.PlaySound("buttons/button8.wav")
				return 
			end
			Broadcast_setttings[1] = self:GetValue()
			updateServer()
			surface.PlaySound("buttons/button14.wav")
		end
	
	local lbl2 = vgui.Create("DLabel", panel)
		lbl2:SetPos(120, 15)
		lbl2:SetText("Sound:")
		lbl2:SizeToContents()
		lbl2:SetTextColor(Color(0,0,0,255))
		
	local snd = vgui.Create("DTextEntry", panel)
		snd:SetPos(160, 12.5 )
		snd:SetSize(300, 20)
		snd:SetText(Broadcast_setttings[2] or "")
		snd.OnEnter = function(self)
			if self:GetValue() == NULL or self:GetValue() == "" then 
				surface.PlaySound("buttons/button8.wav")
				return 
			end
			Broadcast_setttings[2] = self:GetValue()
			updateServer()
			surface.PlaySound("buttons/button14.wav")
		end
		
	local ind = 0
	local bBox
	
		
	bBox = vgui.Create("DComboBox", panel)
		bBox.bRemove = true
		bBox:SetPos(10, 40)
		bBox:SetSize(450, 20)
		updateCB(bBox)
		if table.Count(Broadcasts) > 0 then
			bBox:ChooseOptionID(1)
			ind = 1
		else
			bBox:SetValue("Click [Add] to add broadcasts")
		end
		bBox.OnSelect = function( _, index, value, data )
				ind  = index
			end
	
	local addBtn = vgui.Create("DButton", panel)
		addBtn:SetPos(10, 70)
		addBtn:SetSize(100, 20)
		addBtn:SetText("Add")
		addBtn.DoClick = function() 
			table.insert(Broadcasts, table.Count(Broadcasts)+1, ">New Broadcast<")
			ind = table.Count(Broadcasts)
			updateCB(bBox)
			bBox:ChooseOptionID(table.Count(Broadcasts))
			updateServer()
			surface.PlaySound("buttons/button14.wav")
		end
	local rmvBtn = vgui.Create("DButton", panel)
		rmvBtn:SetPos(120, 70)
		rmvBtn:SetSize(100, 20)
		rmvBtn:SetText("Remove")
		rmvBtn.DoClick = function()
			if ind == 0 then
				surface.PlaySound("buttons/button8.wav")
				return 
			end
			Derma_Query(Broadcasts[ind] .. "                        ", "Remove this broadcast?",
				"Yes", function() 
					table.remove(Broadcasts, ind)
					updateCB(bBox)
					ind = table.Count(Broadcasts)
					if table.Count(Broadcasts) > 0 then
						bBox:ChooseOptionID(table.Count(Broadcasts))
					else
						bBox:SetValue("Click Add to add broadcasts")
					end
					updateServer()
					surface.PlaySound("buttons/button14.wav")
				end,
				"No", function() end)
		end
		
	local ediBtn = vgui.Create("DButton", panel)
		ediBtn:SetPos(230, 70)
		ediBtn:SetSize(100, 20)
		ediBtn:SetText("Edit")
		ediBtn.DoClick = function()
			if ind == 0 then
				surface.PlaySound("buttons/button8.wav")
				return
			end
			Derma_StringRequest("Edit Broadcast", Broadcasts[ind], Broadcasts[ind], function(text)
				if text == "" or text == NULL then
					surface.PlaySound("buttons/button8.wav")
					return
				end
				Broadcasts[ind] = text
				updateCB(bBox)
				bBox:ChooseOptionID(ind)
				updateServer()
				surface.PlaySound("buttons/button14.wav")
			end)
		end
end

net.Receive("cc_broadcast", function(len)
	broadcastMenu()
end)