if (!Tabs_str) then Tabs_str = {} end
if (!Btns_str) then Btns_str = {} end

local closeX_sc = 0.14
local closeY_sc = 0.075
local sheet_r = 0.85

local window
local windowActive = false
local function motd() 
	window = vgui.Create("DFrame")
		if ScrW() > 640 then
			window:SetSize(ScrW()*0.9, ScrH()*0.9)
		else
			window:SetSize(640, 480)
		end
		window:SetTitle("")
		window:SetVisible(true)
		window:SetDraggable(false)
		window:SetBackgroundBlur(true)
		window:MakePopup()
		window:Center()
		window:ShowCloseButton(false)
		-- window.btnClose.DoClick = function ( button ) 
			-- window:Close()
			-- windowActive = false
		-- end
		-- window.btnMaxim:SetVisible(false)
		-- window.btnMinim:SetVisible(false)
		window:SetSkin("motd_default")
		
		windowActive = true
		
	--LDT Extra
	local ldtLbl = vgui.Create("DLabel", window)
	ldtLbl:SetFont("ldtfont")
	ldtLbl:SetText("LDT Community")
	ldtLbl:SizeToContents()
	ldtLbl:SetPos(window:GetWide() - ldtLbl:GetWide() - 15, 0)
	ldtLbl:SetTextColor(Color(233, 152, 37, 255))
	
	local close = vgui.Create("DButton", window)
	close:SetSize(200, 30)
	close:SetText("Close")
	close:SetFont("closefont")
	close.DoClick = function ( button ) 
			window:Close()
			windowActive = false
		end
	close:SetPos(window:GetWide()/2 - close:GetWide()/2, 0)

	local Tabs = vgui.Create("DPropertySheet", window)
	Tabs:SetPos(5, 30)
	Tabs:SetSize(window:GetWide()-10, window:GetTall()*sheet_r)
	
	for i, tab in pairs(Tabs_str) do
		if (tab[1] == "true") then
			local vtab = vgui.Create("DPanel", Tabs)
				vtab:SetSize(Tabs:GetWide()-10, Tabs:GetTall()-10)
				local html = vgui.Create("DHTML", vtab)
					html:SetPos(5, 5)
					html:SetSize(vtab:GetWide()-10, vtab:GetTall()-35)
					html:OpenURL(tab[3])
				Tabs:AddSheet(tab[2], vtab, tab[4], false, false, false)
		end
	end
	
	local num = 0
	for i, btn in pairs(Btns_str) do
		if (btn[1] == "true") then
			num = num + 1
		end
	end

	local btnW = (window:GetWide()/1.5)/num
	local btnH = window:GetTall()*(1-sheet_r)/2
	local btn_x = window:GetWide()/2 - ((btnW*1.5*num)/2 - btnW/3)
	
	local fontsize
	for i, btn in pairs(Btns_str) do 
		if (btn[1] == "true") then
			local vbtn = vgui.Create("DButton", window)
				vbtn:SetText(btn[2])
				vbtn:SetSize(btnW, btnH)
				if !fontsize then
					fontsize = vbtn:GetWide()*0.14
					surface.CreateFont("btnfont",  {
						 font = "coolvetica",
						 size = fontsize,
						 weight = 500,
						 blursize = 0,
						 scanlines = 0,
						 antialias = true,
						 underline = false,
						 italic = false,
						 strikeout = false,
						 symbol = false,
						 rotary = false,
						 shadow = false,
						 additive = false,
						 outline = false
						} )
				end
				vbtn:SetFont("btnfont")
				vbtn:SetPos(btn_x,  window:GetTall()*sheet_r + (window:GetTall() - window:GetTall()*sheet_r)/3)
				vbtn.DoClick = function()
					LocalPlayer():ConCommand("play common/bugreporter_succeeded.wav" )
					timer.Simple(1, function()
						LocalPlayer():ConCommand("say I'm off to"..btn[2].."!")
						LocalPlayer():ConCommand("connect "..btn[3])
					end )
				end
			if (btn[4] == "true") then
				local sticker = vgui.Create( "DImage", window )
					sticker:SetImage( "motd/new.png" )
					local s = math.min(vbtn:GetWide()*0.4, 128)
					sticker:SetSize(s, s)
					local x,y = vbtn:GetPos()
					sticker:SetPos(x-sticker:GetWide()/3, y-sticker:GetWide()/3)
				
			end
		end
		btn_x = btn_x + btnW*1.5
	end
	
end
concommand.Add("open_motd", motd )

local function updateServer()
	net.Start("cl_motd")
		net.WriteTable(Tabs_str)
		net.WriteTable(Btns_str)
	net.SendToServer()
end

local saveMotd
local function motdmenu()
	local menu = vgui.Create("DFrame")
		menu:SetSize(550, 330)
		menu:SetTitle("MOTD Editor")
		menu:SetVisible(true)
		menu:MakePopup()
		menu:Center()
		menu.btnClose.DoClick = function ( button ) menu:SetVisible(false) end
		menu.btnMaxim:SetVisible(false)
		menu.btnMinim:SetVisible(false)
		
	local red = vgui.Create("DPanel", menu)
		red:SetPos(10, 30)
		red:SetSize(530, 120)
		red:SetBackgroundColor(Color(255, 0, 0, 30))
		red:SetDrawBackground(false)
		
	local green = vgui.Create("DPanel", menu)
		green:SetPos(10, 30)
		green:SetSize(530, 120)
		green:SetBackgroundColor(Color(0, 255, 0, 30))
		green:SetDrawBackground(false)
		
	local panel = vgui.Create("DPanel", menu)
		panel:SetPos(10, 30)
		panel:SetSize(530, 120)
		panel:SetBackgroundColor(Color(255, 255, 255, 30))
	
	local tabsLbl = vgui.Create("DLabel", panel)
		tabsLbl:SetText("TAB:")
		tabsLbl:SetPos(30, 10)
		
	local tabsLblen = vgui.Create("DLabel", panel)
		tabsLblen:SetText("Enabled:")
		tabsLblen:SetPos(210, 10)	
	local enabled = vgui.Create("DCheckBox", panel)
		enabled:SetPos(260, 12.5)
		enabled:SetDisabled(true)
		enabled.OnChange = function()
			green:SetDrawBackground(false)
			panel:SetDrawBackground(false)
			red:SetDrawBackground(true)
		end
		
	local tabsLblnm = vgui.Create("DLabel", panel)
		tabsLblnm:SetText("Name:")
		tabsLblnm:SetPos(210, 35)	
	local name = vgui.Create("DTextEntry", panel)
		name:SetPos(260, 35)
		name:SetSize(250, 20)
		name:SetDisabled(true)
		name:SetEditable(false)
		name.OnChange = function()
			green:SetDrawBackground(false)
			panel:SetDrawBackground(false)
			red:SetDrawBackground(true)
		end
	
	local tabsLblurl = vgui.Create("DLabel", panel)
		tabsLblurl:SetText("URL:")
		tabsLblurl:SetPos(210, 60)	
	local url = vgui.Create("DTextEntry", panel)
		url:SetPos(260, 60)
		url:SetSize(250, 20)
		url:SetDisabled(true)
		url:SetEditable(false)
		url.OnChange = function()
			green:SetDrawBackground(false)
			panel:SetDrawBackground(false)
			red:SetDrawBackground(true)
		end
		
	local tabsLblic = vgui.Create("DLabel", panel)
		tabsLblic:SetText("Icon:")
		tabsLblic:SetPos(210, 85)
	local icon = vgui.Create("DTextEntry", panel)
		icon:SetPos(260, 85)
		icon:SetSize(250, 20)
		icon:SetDisabled(true)
		icon:SetEditable(false)
		icon.OnChange = function()
			green:SetDrawBackground(false)
			panel:SetDrawBackground(false)
			red:SetDrawBackground(true)
		end
		
	local ind
	local tabsBox = vgui.Create("DComboBox", panel)
		tabsBox.bRemove = true
		tabsBox:SetPos(60, 10)
		tabsBox:SetSize(125, 20)
		tabsBox:SetValue("Select a TAB")
		for i, tab in pairs(Tabs_str) do
			tabsBox:AddChoice(tab[2])
		end
		tabsBox.OnSelect = function( _, index, value, data )
			panel:SetDrawBackground(false)
			green:SetDrawBackground(true)
			red:SetDrawBackground(false)
			
			enabled:SetDisabled(false)
			name:SetDisabled(false)
			name:SetEditable(true)
			url:SetDisabled(false)
			url:SetEditable(true)
			icon:SetDisabled(false)
			icon:SetEditable(true)
			enabled:SetChecked(Tabs_str[index][1] == "true")
			name:SetText(value)
			url:SetText(Tabs_str[index][3])
			icon:SetText(Tabs_str[index][4])
			ind = index
		end
		
	local saveTab = vgui.Create("DButton", panel)
		saveTab:SetText("SAVE TAB")
		saveTab:SetSize(125, 20)
		saveTab:SetPos(60, 35)
		saveTab.DoClick = function() 
			if (name:GetValue() == "" or url:GetValue() == "" or icon:GetValue() == "") then 
				Derma_Message("Invalid entries.", "Error")
				return 
			end
			if enabled:GetChecked() then
				Tabs_str[ind][1] = "true"
			else
				Tabs_str[ind][1] = "false"
			end
			Tabs_str[ind][2] = name:GetValue()
			Tabs_str[ind][3] = url:GetValue()
			Tabs_str[ind][4] = icon:GetValue()
			
			tabsBox:Clear(true)
			for i, tab in pairs(Tabs_str) do
				tabsBox:AddChoice(tab[2])
			end
			tabsBox:ChooseOptionID(ind)
			
			panel:SetDrawBackground(false)
			green:SetDrawBackground(true)
			red:SetDrawBackground(false)
			surface.PlaySound("buttons/button14.wav")
		end
		
		
	local bred = vgui.Create("DPanel", menu)
		bred:SetPos(10, 160)
		bred:SetSize(530, 120)
		bred:SetBackgroundColor(Color(255, 0, 0, 30))
		bred:SetDrawBackground(false)
		
	local bgreen = vgui.Create("DPanel", menu)
		bgreen:SetPos(10, 160)
		bgreen:SetSize(530, 120)
		bgreen:SetBackgroundColor(Color(0, 255, 0, 30))
		bgreen:SetDrawBackground(false)
		
	local bpanel = vgui.Create("DPanel", menu)
		bpanel:SetPos(10, 160)
		bpanel:SetSize(530, 120)
		bpanel:SetBackgroundColor(Color(255, 255, 255, 30))
	
	local btnsLbl = vgui.Create("DLabel", bpanel)
		btnsLbl:SetText("BUTTON:")
		btnsLbl:SetPos(10, 10)
		
	local btnsLblen = vgui.Create("DLabel", bpanel)
		btnsLblen:SetText("Enabled:")
		btnsLblen:SetPos(210, 10)	
	local benabled = vgui.Create("DCheckBox", bpanel)
		benabled:SetPos(260, 12.5)
		benabled:SetDisabled(true)
		benabled.OnChange = function()
			bgreen:SetDrawBackground(false)
			bpanel:SetDrawBackground(false)
			bred:SetDrawBackground(true)
		end
		
	local btnsLblnm = vgui.Create("DLabel", bpanel)
		btnsLblnm:SetText("Name:")
		btnsLblnm:SetPos(210, 35)	
	local bname = vgui.Create("DTextEntry", bpanel)
		bname:SetPos(260, 35)
		bname:SetSize(250, 20)
		bname:SetDisabled(true)
		bname:SetEditable(false)
		bname.OnChange = function()
			bgreen:SetDrawBackground(false)
			bpanel:SetDrawBackground(false)
			bred:SetDrawBackground(true)
		end
	
	local btnsLblip = vgui.Create("DLabel", bpanel)
		btnsLblip:SetText("IP:")
		btnsLblip:SetPos(210, 60)	
	local ip = vgui.Create("DTextEntry", bpanel)
		ip:SetPos(260, 60)
		ip:SetSize(250, 20)
		ip:SetDisabled(true)
		ip:SetEditable(false)
		ip.OnChange = function()
			bgreen:SetDrawBackground(false)
			bpanel:SetDrawBackground(false)
			bred:SetDrawBackground(true)
		end
		
	local btnsLblic = vgui.Create("DLabel", bpanel)
		btnsLblic:SetText("New:")
		btnsLblic:SetPos(210, 85)
	local new = vgui.Create("DCheckBox", bpanel)
		new:SetPos(260, 87.5)
		new:SetDisabled(true)
		new.OnChange = function()
			bgreen:SetDrawBackground(false)
			bpanel:SetDrawBackground(false)
			bred:SetDrawBackground(true)
		end
		
	local ind
	local btnsBox = vgui.Create("DComboBox", bpanel)
		btnsBox.bRemove = true
		btnsBox:SetPos(60, 10)
		btnsBox:SetSize(125, 20)
		btnsBox:SetValue("Select a BUTTON")
		for i, btn in pairs(Btns_str) do
			btnsBox:AddChoice(btn[2])
		end
		btnsBox.OnSelect = function( panel, index, value, data )
			bpanel:SetDrawBackground(false)
			bgreen:SetDrawBackground(true)
			bred:SetDrawBackground(false)
			
			benabled:SetDisabled(false)
			bname:SetDisabled(false)
			bname:SetEditable(true)
			ip:SetDisabled(false)
			ip:SetEditable(true)
			new:SetDisabled(false)
			benabled:SetChecked(Btns_str[index][1] == "true")
			bname:SetText(value)
			ip:SetText(Btns_str[index][3])
			new:SetChecked(Btns_str[index][4] == "true")
			ind = index
		end
		
	local saveBtn = vgui.Create("DButton", bpanel)
		saveBtn:SetText("SAVE BUTTON")
		saveBtn:SetSize(125, 20)
		saveBtn:SetPos(60, 35)
		saveBtn.DoClick = function() 
			if (bname:GetValue() == "" or ip:GetValue() == "") then 
				Derma_Message("Invalid entries.", "Error")
				return 
			end
			if benabled:GetChecked() then
				Btns_str[ind][1] = "true"
			else
				Btns_str[ind][1] = "false"
			end
			Btns_str[ind][2] = bname:GetValue()
			Btns_str[ind][3] = ip:GetValue()
			if new:GetChecked() then
				Btns_str[ind][4] = "true"
			else
				Btns_str[ind][4] = "false"
			end
			
			btnsBox:Clear(true)
			for i, btn in pairs(Btns_str) do
				btnsBox:AddChoice(btn[2])
			end
			btnsBox:ChooseOptionID(ind)
			
			bpanel:SetDrawBackground(false)
			bgreen:SetDrawBackground(true)
			bred:SetDrawBackground(false)
			surface.PlaySound("buttons/button14.wav")
		end
				
	saveMotd = vgui.Create("DButton", menu)
		saveMotd:SetText("UPDATE SERVER")
		saveMotd:SetSize(170, 30)
		saveMotd:SetPos(10, menu:GetTall()*0.875)
		saveMotd.DoClick = function()
			if (red:GetDrawBackground() or bred:GetDrawBackground() or panel:GetDrawBackground() and bpanel:GetDrawBackground()) then
				surface.PlaySound("buttons/button8.wav")
			else
				updateServer()
				saveMotd:SetDisabled(true)
				saveMotd:SetText("SAVING MOTD...")
				surface.PlaySound("buttons/button14.wav")
			end
		end
		
	local openMotd = vgui.Create("DButton", menu)
		openMotd:SetText("OPEN MOTD")
		openMotd:SetSize(100, 30)
		openMotd:SetPos(menu:GetWide() - openMotd:GetWide() - 10, menu:GetTall()*0.875)
		openMotd.DoClick = function()
			motd()
		end
	

end

net.Receive("motd", function(len)
	Tabs_str = net.ReadTable()
	Btns_str = net.ReadTable()
	if (saveMotd and saveMotd.DoClick) then
		saveMotd:SetText("UPDATE SERVER")
		saveMotd:SetDisabled(false)
	end
	if windowActive then
		window:Close()
		motd()
	end
end)

net.Receive("cc_motd", function(len)
	motdmenu()
end)