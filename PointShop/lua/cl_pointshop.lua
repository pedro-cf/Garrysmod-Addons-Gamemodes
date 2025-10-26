local calc = 0
local stuff = 0
local Christmas = false
if (os.date("%m") == "11") or (os.date("%m") == "12") or (os.date("%m") == "1") then
	Christmas = true
end
Yourself = Entity()


usermessage.Hook("PointShop_Menu", function(um)
	if um:ReadBool() then
		if Loading then
			Loading:SetVisible(false)
		end
		
		POINTSHOP.Menu = vgui.Create("DFrame")
		if ScrW() > 640 then
			POINTSHOP.Menu:SetSize( ScrW()*0.5, ScrH()*0.55 )
		else
			POINTSHOP.Menu:SetSize( 640, 480 )
		end
		POINTSHOP.Menu:SetTitle("")
		POINTSHOP.Menu:SetVisible(true)
		POINTSHOP.Menu:SetDraggable(false)
		POINTSHOP.Menu:ShowCloseButton(true)
		POINTSHOP.Menu:MakePopup()
		POINTSHOP.Menu:Center()
		
		local labelt = vgui.Create("DLabel", POINTSHOP.Menu)
			labelt:SetText("Points:")
			labelt:SetTextColor( Color(255, 255, 255, 255) )
			labelt:SetPos(300,17)
			labelt:SetFont("KCV30")
			labelt:SizeToContents()
		local label = vgui.Create("DLabel", POINTSHOP.Menu)
			label:SetText(tostring(LocalPlayer():PS_GetPoints()))
			label:SetTextColor( Color(255, 255, 0, 255) )
			label:SetPos(385,12)
			label:SetFont("KCV40")
			label:SizeToContents()

		
		local AcceptButton = vgui.Create( "DButton", POINTSHOP.Menu )
			AcceptButton:SetText( "CLOSE" )
			AcceptButton:SetSize( POINTSHOP.Menu:GetWide()*0.2, POINTSHOP.Menu:GetTall()*0.1 )
			AcceptButton:SetPos( POINTSHOP.Menu:GetWide()/2 - AcceptButton:GetWide()/2, POINTSHOP.Menu:GetTall()*0.88 )
			AcceptButton.DoClick = function()
					if POINTSHOP.Menu then
						POINTSHOP.Menu:Remove()
					end
			end
			
		local Tabs = vgui.Create("DPropertySheet", POINTSHOP.Menu)
		Tabs:SetPos(5, 30)
		Tabs:SetSize(POINTSHOP.Menu:GetWide() - 10, POINTSHOP.Menu:GetTall()*0.8)
		
		
		--Inventory Tab
		local TabOne = vgui.Create( "DPanel" )
		TabOne:SetVisible( true )
		
		
		if gmod.GetGamemode().Name == "Trouble in Terrorist Town" then
			if LocalPlayer():IsSpec() then
				local numofhatsA = 0
				for k,j in pairs(LocalPlayer():PS_GetItems()) do
					if POINTSHOP.FindCategoryByItemID(j).Name == "Hats" then
						numofhatsA = numofhatsA + 1
					end
				end
				if #LocalPlayer():PS_GetItems() > 0 and numofhatsA > 0 and LocalPlayer().Equiped then
					if table.HasValue( LocalPlayer().Equiped, true ) then
						local iconm = vgui.Create( "DPlayerModelhat", TabOne )
						iconm:SetModel( "models/player/phoenix.mdl" )
						iconm:SetPos(ScrW()*0.234,-ScrH()*0.025)
						iconm:SetSize( ScrW()*0.417, ScrW()*0.417 )
						iconm:SetCamPos( Vector( 120, 120, 60 ) )
						iconm:SetLookAt( Vector( 0, 0, 0 ) )
						Yourself = iconm:GetEntity()
					else
						local iconm = vgui.Create( "DModelPanel", TabOne )
						iconm:SetModel( "models/player/phoenix.mdl" )
						iconm:SetPos(ScrW()*0.234,-ScrH()*0.025)
						iconm:SetSize( ScrW()*0.417, ScrW()*0.417 )
						iconm:SetCamPos( Vector( 120, 120, 60 ) )
						iconm:SetLookAt( Vector( 0, 0, 0 ) )
					end
				else
					local iconm = vgui.Create( "DModelPanel", TabOne )
					iconm:SetModel( "models/player/phoenix.mdl" )
					iconm:SetPos(ScrW()*0.234,-ScrH()*0.025)
					iconm:SetSize( ScrW()*0.417, ScrW()*0.417 )
					iconm:SetCamPos( Vector( 120, 120, 60 ) )
					iconm:SetLookAt( Vector( 0, 0, 0 ) )
				end
			elseif !LocalPlayer():IsSpec() then
				local numofhats = 0
				for k,j in pairs(LocalPlayer():PS_GetItems()) do
					if POINTSHOP.FindCategoryByItemID(j).Name == "Hats" then
						numofhats = numofhats + 1
					end
				end
				if #LocalPlayer():PS_GetItems() > 0 and numofhats > 0 and LocalPlayer().Equiped then
					if table.HasValue( LocalPlayer().Equiped, true ) then
						local iconm = vgui.Create( "DPlayerModelhat", TabOne )
						iconm:SetModel( LocalPlayer():GetModel() )
						iconm:SetPos(ScrW()*0.234,-ScrH()*0.025)
						iconm:SetSize( ScrW()*0.417, ScrW()*0.417 )
						iconm:SetCamPos( Vector( 120, 120, 60 ) )
						iconm:SetLookAt( Vector( 0, 0, 0 ) )
						Yourself = iconm:GetEntity()
					else
						local iconm = vgui.Create( "DModelPanel", TabOne )
						iconm:SetModel( LocalPlayer():GetModel() )
						iconm:SetPos(ScrW()*0.234,-ScrH()*0.025)
						iconm:SetSize( ScrW()*0.417, ScrW()*0.417 )
						iconm:SetCamPos( Vector( 120, 120, 60 ) )
						iconm:SetLookAt( Vector( 0, 0, 0 ) )
					end
				else
					local iconm = vgui.Create( "DModelPanel", TabOne )
					iconm:SetModel( LocalPlayer():GetModel() )
					iconm:SetPos(ScrW()*0.234,-ScrH()*0.025)
					iconm:SetSize( ScrW()*0.417, ScrW()*0.417 )
					iconm:SetCamPos( Vector( 120, 120, 60 ) )
					iconm:SetLookAt( Vector( 0, 0, 0 ) )
				end
			end
		else
			if #LocalPlayer():PS_GetItems() > 0 and LocalPlayer().Equiped then
				local numofhatsB = 0
				for k,j in pairs(LocalPlayer():PS_GetItems()) do
					if POINTSHOP.FindCategoryByItemID(j).Name == "Hats" then
						numofhatsB = numofhatsB + 1
					end
				end
				if numofhatsB > 0 then
					if table.HasValue( LocalPlayer().Equiped, true ) then
						local iconm = vgui.Create( "DPlayerModelhat", TabOne )
						if LocalPlayer():GetModel() == "models/player.mdl" then
							iconm:SetModel( "models/player/Kleiner.mdl" )
						else
							iconm:SetModel( LocalPlayer():GetModel() )
						end
						iconm:SetPos(ScrW()*0.234,-ScrH()*0.025)
						iconm:SetSize( ScrW()*0.417, ScrW()*0.417 )
						iconm:SetCamPos( Vector( 120, 120, 60 ) )
						iconm:SetLookAt( Vector( 0, 0, 0 ) )
						Yourself = iconm:GetEntity()
					else
						local iconm = vgui.Create( "DModelPanel", TabOne )
						if LocalPlayer():GetModel() == "models/player.mdl" then
							iconm:SetModel( "models/player/Kleiner.mdl" )
						else
							iconm:SetModel( LocalPlayer():GetModel() )
						end
						iconm:SetPos(ScrW()*0.234,-ScrH()*0.025)
						iconm:SetSize( ScrW()*0.417, ScrW()*0.417 )
						iconm:SetCamPos( Vector( 120, 120, 60 ) )
						iconm:SetLookAt( Vector( 0, 0, 0 ) )
					end
				end
			else
				local iconm = vgui.Create( "DModelPanel", TabOne )
				if LocalPlayer():GetModel() == "models/player.mdl" then
					iconm:SetModel( "models/player/Kleiner.mdl" )
				else
					iconm:SetModel( LocalPlayer():GetModel() )
				end
				iconm:SetPos(ScrW()*0.234,-ScrH()*0.025)
				iconm:SetSize( ScrW()*0.417, ScrW()*0.417 )
				iconm:SetCamPos( Vector( 120, 120, 60 ) )
				iconm:SetLookAt( Vector( 0, 0, 0 ) )
			end
		end

		local InventoryContainer = vgui.Create("DPanelList", TabOne)
		InventoryContainer:SetSize(POINTSHOP.Menu:GetWide()*0.8, POINTSHOP.Menu:GetTall()*0.85)
		InventoryContainer:SetSpacing(5)
		InventoryContainer:SetPadding(5)
		InventoryContainer:EnableHorizontal(true)
		InventoryContainer:EnableVerticalScrollbar(false)
		
		for id, item_id in pairs(LocalPlayer():PS_GetItems()) do
			
			local item = POINTSHOP.FindItemByID(item_id)
			if item then
				item.inv = true
				if item.Model then
					local Icon = vgui.Create("DShopModel")
					Icon:SetData(item)
					if POINTSHOP.FindCategoryByItemID(item_id).Name == "Hats" then
						if LocalPlayer().Equiped then
							if LocalPlayer().Equiped[item_id] then
								Icon:SetColor(Color(0,255,0,255))
							else
								Icon:SetColor(Color(255,0,0,255))
							end
						else
							Icon:SetColor(Color(255,0,0,255))
						end
					end
					Icon:SetSize(96, 96)
					Icon.Sell = true
					Icon.DoClick = function()
						local menu = DermaMenu()
						if POINTSHOP.FindCategoryByItemID(item_id).Name == "Hats" then
							if !LocalPlayer().Equiped then
								menu:AddOption("Equip", function()
								if POINTSHOP.Menu then
									POINTSHOP.Menu:Remove()
								end
								RunConsoleCommand("pointshop_equip", item_id)
								end)
							else
								if !LocalPlayer().Equiped[item_id] then
									menu:AddOption("Equip", function()
										if POINTSHOP.Menu then
											POINTSHOP.Menu:Remove()
										end
										RunConsoleCommand("pointshop_equip", item_id)
									end)
								end
							end
						end
						if POINTSHOP.FindCategoryByItemID(item_id).Name == "Hats" then
							if LocalPlayer().Equiped then
								if LocalPlayer().Equiped[item_id] then
									menu:AddOption("Unequip", function()
									if POINTSHOP.Menu then
										POINTSHOP.Menu:Remove()
									end
									RunConsoleCommand("pointshop_unequip", item_id)
									end)
								end
							end
						end
						menu:AddOption("Sell", function()
							calc = item.Cost*0.25
							Derma_Query("Do you want to sell '" .. item.Name .. "' for " .. calc .. " points?", "Sell Item",
								"Yes", function() 
								if POINTSHOP.Menu then
									POINTSHOP.Menu:Remove()
								end
								if LocalPlayer().Equiped then
									LocalPlayer().Equiped[item_id] = false
								end
								RunConsoleCommand("pointshop_sell", item_id) 
								end,
								"No", function() end
							)
						end)
						menu:Open()
					end
					
					InventoryContainer:AddItem(Icon)
				elseif item.Material then
					Icon = vgui.Create("DShopMaterial")
					Icon:SetData(item)
					Icon:SetSize(96, 96)
					Icon.Sell = true
					Icon.DoClick = function()
						local menu = DermaMenu()
						menu:AddOption("Sell", function()
							stuff = item.Cost*0.25
							Derma_Query("Do you want to sell '" .. item.Name .. "' for " .. stuff .. " points?", "Sell Item",
								"Yes", function()
							if POINTSHOP.Menu then
								POINTSHOP.Menu:Remove()
							end
								RunConsoleCommand("pointshop_sell", item_id) 
								end,
								"No", function() end
							)
						end)
						menu:Open()
					end
					
					InventoryContainer:AddItem(Icon)
				end
			end
		end
		
		
		Tabs:AddSheet( "Inventory", TabOne, "gui/silkicons/box", false, false, "Browse your inventory!" )
		
		
		--Shop Tab
		local ShopCategoryTabs = vgui.Create("DColumnSheet")
		ShopCategoryTabs:SetSize(Tabs:GetWide() - 10, Tabs:GetTall() - 90)
        ShopCategoryTabs.Navigation:SetWidth(100)
        ShopCategoryTabs.Navigation:DockMargin(15, 5, 15, 0)
		
		local npc_id = um:ReadLong()
		local is_npc_menu = false
		
		for c_id, category in pairs(POINTSHOP.Items) do
			if category.Enabled  and category.Name == "Hats" then
				if (is_npc_menu and table.HasValue(npc_categories, category.Name)) or not is_npc_menu then
					local CategoryTab = vgui.Create("DPanelList", ShopCategoryTabs)
					CategoryTab:SetSpacing(5)
					CategoryTab:SetPadding(5)
					CategoryTab:EnableHorizontal(true)
					CategoryTab:EnableVerticalScrollbar(true)
					CategoryTab:Dock(FILL)
					
					for item_id, item in pairs(category.Items) do
						if item.Enabled then
							if not table.HasValue(LocalPlayer():PS_GetItems(), item_id) then
							item.inv = false
								if item.Model then
									local Icon
									if item.Description == "PlayerModel" then
										Icon = vgui.Create("SpawnIcon")
										Icon:SetModel(item.Model)
										Icon:SetToolTip(item.Name.. ": " ..item.Cost)
									else
										Icon = vgui.Create("DShopModel")
										Icon:SetData(item)
									end
									Icon:SetSize(96, 96)
									Icon.DoClick = function()
										if category.NumAllowedItems then
											if LocalPlayer():PS_NumItemsFromCategory(category) >= category.NumAllowedItems then
												Derma_Message("You can only have " .. category.NumAllowedItems .. " items from the " .. category.Name .. "  category!", "PointShop", "Close")
												surface.PlaySound( "buttons/button10.wav" )
												return
											end
										end
										if item.Donator and !LocalPlayer():GetNWBool("LDTdonator") then
											Derma_Message("You need to be a donator to buy this item!", "PointShop", "Close")
											surface.PlaySound( "buttons/button10.wav" )
											return
										end
										if item.Christmas and not Christmas == true then
											Derma_Message("It is not Christmas!", "PointShop", "Close")
											surface.PlaySound( "buttons/button10.wav" )
											return
										end
										if LocalPlayer():PS_CanAfford(item.Cost) then
											Derma_Query("Do you want to buy '" .. item.Name .. "' for " .. item.Cost .. " points?", "Buy Item",
												"Yes", function()
												RunConsoleCommand("pointshop_buy", item_id) end,
												"No", function() end
											)
										else
											Derma_Message("You can't afford this item!", "PointShop", "Close")
											surface.PlaySound( "buttons/button10.wav" )
										end
									end
									CategoryTab:AddItem(Icon)
								elseif item.Material then
									local Icon = vgui.Create("DShopMaterial")
									Icon:SetData(item)
									Icon:SetSize(96, 96)
									Icon.DoClick = function()
										if category.NumAllowedItems then
											if LocalPlayer():PS_NumItemsFromCategory(category) >= category.NumAllowedItems then
												Derma_Message("You can only have " .. category.NumAllowedItems .. " items from the " .. category.Name .. "  category!", "PointShop", "Close")
												surface.PlaySound( "buttons/button10.wav" )
												return
											end
										end
										if item.Donator and !LocalPlayer():GetNWBool("LDTdonator") then
											Derma_Message("You need to be a donator to buy this item!", "PointShop", "Close")
											return
										end
										if item.Christmas and not Christmas == true then
											Derma_Message("It is not Christmas!", "PointShop", "Close")
											return
										end
										if LocalPlayer():PS_CanAfford(item.Cost) then
											Derma_Query("Do you want to buy '" .. item.Name .. "' for " .. item.Cost .. " points?", "Buy Item",
												"Yes", function() 
												RunConsoleCommand("pointshop_buy", item_id)
												end,
												"No", function() end
											)
										else
											Derma_Message("You can't afford this item!", "PointShop", "Close")
										end
									end
									CategoryTab:AddItem(Icon)
								end
							end
						end
					end
					ShopCategoryTabs:AddSheet(category.Name, CategoryTab, "gui/silkicons/" .. category.Icon, category.Name)
				end
			end
		end
		
		for c_id, category in pairs(POINTSHOP.Items) do
			if category.Enabled and category.Name != "Hats" then
				if (is_npc_menu and table.HasValue(npc_categories, category.Name)) or not is_npc_menu then
					local CategoryTab = vgui.Create("DPanelList", ShopCategoryTabs)
					CategoryTab:SetSpacing(5)
					CategoryTab:SetPadding(5)
					CategoryTab:EnableHorizontal(true)
					CategoryTab:EnableVerticalScrollbar(true)
					CategoryTab:Dock(FILL)
					
					for item_id, item in pairs(category.Items) do
						if item.Enabled then
							if not table.HasValue(LocalPlayer():PS_GetItems(), item_id) then
							item.inv = false
								if item.Model then
									local Icon
									if item.Description == "PlayerModel" then
										Icon = vgui.Create("SpawnIcon")
										Icon:SetModel(item.Model)
										Icon:SetToolTip(item.Name.. ": " ..item.Cost)
									else
										Icon = vgui.Create("DShopModel")
										Icon:SetData(item)
									end
									Icon:SetSize(96, 96)
									Icon.DoClick = function()
										if category.NumAllowedItems then
											if LocalPlayer():PS_NumItemsFromCategory(category) >= category.NumAllowedItems then
												Derma_Message("You can only have " .. category.NumAllowedItems .. " items from the " .. category.Name .. "  category!", "PointShop", "Close")
												surface.PlaySound( "buttons/button10.wav" )
												return
											end
										end
										if item.Donator and !LocalPlayer():GetNWBool("LDTdonator") then
											Derma_Message("You need to be a donator to buy this item!", "PointShop", "Close")
											surface.PlaySound( "buttons/button10.wav" )
											return
										end
										if item.Christmas and not Christmas == true then
											Derma_Message("It is not Christmas!", "PointShop", "Close")
											surface.PlaySound( "buttons/button10.wav" )
											return
										end
										if LocalPlayer():PS_CanAfford(item.Cost) then
											Derma_Query("Do you want to buy '" .. item.Name .. "' for " .. item.Cost .. " points?", "Buy Item",
												"Yes", function()
												RunConsoleCommand("pointshop_buy", item_id) end,
												"No", function() end
											)
										else
											Derma_Message("You can't afford this item!", "PointShop", "Close")
											surface.PlaySound( "buttons/button10.wav" )
										end
									end
									CategoryTab:AddItem(Icon)
								elseif item.Material then
									local Icon = vgui.Create("DShopMaterial")
									Icon:SetData(item)
									Icon:SetSize(96, 96)
									Icon.DoClick = function()
										if category.NumAllowedItems then
											if LocalPlayer():PS_NumItemsFromCategory(category) >= category.NumAllowedItems then
												Derma_Message("You can only have " .. category.NumAllowedItems .. " items from the " .. category.Name .. "  category!", "PointShop", "Close")
												surface.PlaySound( "buttons/button10.wav" )
												return
											end
										end
										if item.Donator and !LocalPlayer():GetNWBool("LDTdonator") then
											Derma_Message("You need to be a donator to buy this item!", "PointShop", "Close")
											return
										end
										if item.Christmas and not Christmas == true then
											Derma_Message("It is not Christmas!", "PointShop", "Close")
											return
										end
										if LocalPlayer():PS_CanAfford(item.Cost) then
											Derma_Query("Do you want to buy '" .. item.Name .. "' for " .. item.Cost .. " points?", "Buy Item",
												"Yes", function() 
												RunConsoleCommand("pointshop_buy", item_id)
												end,
												"No", function() end
											)
										else
											Derma_Message("You can't afford this item!", "PointShop", "Close")
										end
									end
									CategoryTab:AddItem(Icon)
								end
							end
						end
					end
					ShopCategoryTabs:AddSheet(category.Name, CategoryTab, "gui/silkicons/" .. category.Icon, category.Name)
				end
			end
		end
		
		Tabs:AddSheet("Shop", ShopCategoryTabs, "gui/silkicons/application_view_tile", false, false, "Browse the shop!")
		
		
		--About Tab
		local About = vgui.Create( "DPanel" )
		About:SetVisible( true )
		About:SetSize(Tabs:GetWide() - 10, Tabs:GetTall() - 110)
		local label = vgui.Create("DLabel", About)
			label:SetText( [[
This is the LDT Community Point Shop.

You can purchase Hats/Models/Trails/PowerUPs
depending on the gamemode.

In Deathrun you will win points for
beeing active and you can win extra points
by winning rounds!

You can also donate in order to recieve points.
]]
			)
			label:SetTextColor( Color( 0,0,0, 255 ) )
			label:SetPos(20,40)
			if ScrW() >= 1500 then
				label:SetFont("KCV30")
			else
				label:SetFont("KCV20")
			end
			label:SizeToContents()
		Tabs:AddSheet("Info", About, "gui/silkicons/page_white_magnify", false, false, "How to win points!")

		POINTSHOP.Menu:SetSkin("Blackskin")
	else
		if POINTSHOP.Menu then
			POINTSHOP.Menu:Remove()
		end
		Loading = vgui.Create("DFrame")
		Loading:SetSize( 205, 60 )
		Loading:SetTitle("")
		Loading:SetVisible(true)
		Loading:SetDraggable(false)
		Loading:ShowCloseButton(false)
		Loading:MakePopup()
		Loading:SetPos(ScrW()/2 -102.5, ScrH()/3)
		local label = vgui.Create("DLabel", Loading)
		label:SetText("Refreshing...")
		label:SetTextColor( Color(255, 255, 255, 255) )
		label:SetPos(12,12)
		label:SetFont("KCV40")
		label:SizeToContents()
		
		Loading:SetSkin("Blackskin")
		
	end
end)


usermessage.Hook("PointShop_Notify", function(um)
	local text = um:ReadString()
	if text then
		chat.AddText(Color( 98, 176, 255, 255 ), text)
	end
end)

usermessage.Hook("PointShop_AddHat", function(um)
	local ply = Entity(um:ReadLong())
	local item_id = um:ReadString()
	
	if not ply or not item_id then return end
	
	local item = POINTSHOP.FindItemByID(item_id)
	if not item then return end
	
	if not ply._Hats then
		ply._Hats = {}
	end
	
	if ply._Hats[item_id] then return end
	
	local mdl = ClientsideModel(item.Model, RENDERGROUP_OPAQUE)
	mdl:SetNoDraw(true)
	
	ply._Hats[item_id] = {
		Model = mdl,
		Attachment = item.Attachment or nil,
		Bone = item.Bone or nil,
		Modify = item.Functions.ModifyHat or function(ent, pos, ang) return ent, pos, ang end
	}
end)

usermessage.Hook("PointShop_RemoveHat", function(um)
	local ply = Entity(um:ReadLong())
	local item_id = um:ReadString()
	
	if not ply or not ply:IsValid() or not ply:IsPlayer() or not item_id then return end
	if not ply._Hats then return end
	if not ply._Hats[item_id] then return end
	
	ply._Hats[item_id] = nil
end)

usermessage.Hook("PointShop_EquipHat", function(um)
	local ply = Entity(um:ReadLong())
	local item_id = um:ReadString()
	
	if not ply or not ply:IsValid() or not ply:IsPlayer() or not item_id then return end
	if not ply._Hats then return end
	if not ply._Hats[item_id] then return end
	
	local item = POINTSHOP.FindItemByID(item_id)
	
	
	for k,v in pairs(ply._Hats) do
		v.Equiped = false
	end
	
	ply._Hats[item_id].Equiped = true
	
	if ply == LocalPlayer() then
		if not LocalPlayer().Equiped then
			LocalPlayer().Equiped = {}
			for id, item_id in pairs(LocalPlayer():PS_GetItems()) do
				LocalPlayer().Equiped[id] = false
			end
		end
	
		for id, bool in pairs(LocalPlayer().Equiped) do
			LocalPlayer().Equiped[id] = false
		end
		LocalPlayer().Equiped[item_id] = true
	end
end)

usermessage.Hook("PointShop_UnEquipHat", function(um)
	local ply = Entity(um:ReadLong())
	local item_id = um:ReadString()
	
	if not ply or not ply:IsValid() or not ply:IsPlayer() or not item_id then return end
	if not ply._Hats then return end
	if not ply._Hats[item_id] then return end
	
	for k,v in pairs(ply._Hats) do
		v.Equiped = false
	end
	
	if ply == LocalPlayer() then
		if not LocalPlayer().Equiped then
			LocalPlayer().Equiped = {}
			for id, item_id in pairs(LocalPlayer():PS_GetItems()) do
				LocalPlayer().Equiped[id] = false
			end
		end
	
		for id, bool in pairs(LocalPlayer().Equiped) do
			LocalPlayer().Equiped[id] = false
		end
	end
end)

hook.Add("InitPostEntity", "PointShop_InitPostEntity", function()
	LocalPlayer().PS_Points = 0
	LocalPlayer().PS_Items = {}
end)

hook.Add("Initialize", "PointShop_DColumnSheet_AddSheet_Override", function()
	function DColumnSheet:AddSheet(label, panel, material, tooltip)
		if not IsValid(panel) then return end

		local Sheet = {}
		
		if self.ButtonOnly then
			Sheet.Button = vgui.Create("DImageButton", self.Navigation)
		else
			Sheet.Button = vgui.Create("DButton", self.Navigation)
		end
		
		Sheet.Button:SetImage(material)
		Sheet.Button.Target = panel
		Sheet.Button:Dock(TOP)
		Sheet.Button:SetText(label)
		Sheet.Button:DockMargin(0, 20, 0, 0)
		
		if tooltip then
			Sheet.Button:SetToolTip(false)
		end
		
		Sheet.Button.DoClick = function()
			self:SetActiveButton(Sheet.Button)
		end
		
		Sheet.Panel = panel
		Sheet.Panel:SetParent(self.Content)
		Sheet.Panel:SetVisible(false)
		
		if self.ButtonOnly then
			Sheet.Button:SizeToContents()
			Sheet.Button:SetColor(Color(150, 150, 150, 200))
		end
		
		table.insert(self.Items, Sheet)
		
		if not IsValid(self.ActiveButton) then
			self:SetActiveButton(Sheet.Button)
		end
	end
end)

hook.Add("PostPlayerDraw", "PointShop_PostPlayerDraw", function(ply)
	if not ply:Alive() then return end
	if not hook.Call("ShouldDrawHats", GAMEMODE) and ply == LocalPlayer() and GetViewEntity():GetClass() == "player" and !LocalPlayer():ShouldDrawLocalPlayer() then return end
	
	if ply._Hats and #ply._Hats then
		for id, hat in pairs(ply._Hats) do
			if hat.Equiped or hat.Attachment != "eyes" then
				local pos = Vector()
				local ang = Angle()
				
				if not hat.Attachment and not hat.Bone then return end
				
				if hat.Attachment then
					local attach = ply:GetAttachment(ply:LookupAttachment(hat.Attachment))
					if attach then
						pos = attach.Pos
						ang = attach.Ang
					end
					if ply:GetModel() == "models/player/urban.mdl" or
						ply:GetModel() == "models/player/riot.mdl" or 
						ply:GetModel() == "models/player/gasmask.mdl" or 
						ply:GetModel() == "models/player/swat.mdl" then
						pos = pos + (ang:Up()*6)
					end
				elseif hat.Bone then
					pos, ang = ply:GetBonePosition(ply:LookupBone(hat.Bone))
					if (ply:GetModel() == "models/player/arctic.mdl") then
						pos = pos + (ang:Up()*5)
					elseif ply:GetModel() != "models/player/arctic.mdl" and
						ply:GetModel() != "models/player/guerilla.mdl" and
						ply:GetModel() != "models/player/leet.mdl" and
						ply:GetModel() != "models/player/phoenix.mdl" then
						pos = pos + (ang:Up()*5)
					end
				end
				
				if (ply:GetModel() == "models/player/guerilla.mdl") then
					pos = pos + ang:Up()*6
				elseif (ply:GetModel() == "models/player/arctic.mdl") then
					pos = pos + ang:Up() + ang:Forward()*-2
					if hat.Model:GetModel() == "models/gmod_tower/aviators.mdl" then
						pos = pos + ang:Up()*-1 + ang:Forward()*0.5
					end
				elseif (ply:GetModel() == "models/player/leet.mdl") then
					pos = pos + ang:Up()*4.5 + ang:Forward()
					if hat.Model:GetModel() == "models/gmod_tower/aviators.mdl" then
						pos = pos + ang:Up()*-0.9 + ang:Forward()*-0.3
					end
					if hat.Model:GetModel() == "models/props/ld_office/ldtclan_hat.mdl" then
						pos = pos + ang:Forward()*0.5
					end
				elseif (ply:GetModel() == "models/player/phoenix.mdl") then
					pos = pos + ang:Up()*6
					if hat.Model:GetModel() == "models/gmod_tower/aviators.mdl" then
						pos = pos + ang:Up()*-1.1 + ang:Forward()*0.75
					end
				end
				
				hat.Model, pos, ang = hat.Modify(hat.Model, pos, ang)
				hat.Model:SetPos(pos)
				hat.Model:SetAngles(ang)
				hat.Model:SetRenderOrigin( pos )
				hat.Model:SetRenderAngles( ang )
				hat.Model:SetupBones()
				hat.Model:DrawModel()
				hat.Model:SetRenderOrigin()
				hat.Model:SetRenderAngles()
			end
		end
	end
end)

----------------------SKIN----------------------
surface.CreateFont ("coolvetica", ScrW()*0.0208, 400, true, false, "KCV40") --scaled
surface.CreateFont ("coolvetica", ScrW()*0.0156, 400, true, false, "KCV30") --scaled
surface.CreateFont ("coolvetica", ScrW()*0.0104, 400, true, false, "KCV20") --scaled

local SKIN = {}

SKIN.PrintName          = "Blackskin"
SKIN.Author             = "Anonymous"
SKIN.DermaVersion       = 1

function SKIN:PaintButton(button)
	local w, h = button:GetSize()
	local x, y = 0,0
	
	local bordersize = 8
	if w <= 32 or h <= 32 then bordersize = 4 end -- This is so small buttons don't look messed up
	
	if button.m_bBackground then
		local color1 = Color(50, 50, 50, 255)
		local color2 = Color(0, 0, 0, 200)
		
		if button:GetDisabled() then
			color2 = Color(80, 80, 80, 255)
		elseif button.Depressed or button:GetSelected() then
			color2 = Color(color2.r + 200, color2.g + 200, color2.b + 200, color2.a + 40)
		elseif button.Hovered then
			color1 = Color(color1.r + 150, color1.g + 150, color1.b + 150, color1.a)
			color2 = Color(color2.r + 40, color2.g + 40, color2.b + 40, color2.a + 40)
		end
		draw.RoundedBox(bordersize, x, y, w, h, color1)
		draw.RoundedBox(bordersize, x+1, y+1, w-2, h-2, color2)
		draw.RoundedBox(bordersize, x+1, y+1, w-2, (h-2)/2, Color(100,100,100,255))
	end
end

function SKIN:SchemeButton( panel )
	if panel:GetWide() > 150 then
		panel:SetFont( "KCV40" )
	else
		panel:SetFont( "KCV20" )
	end
	
	if ( panel:GetDisabled() ) then
		panel:SetTextColor( self.colButtonText )
	else
		panel:SetTextColor( self.colButtonText )
	end
	
	DLabel.ApplySchemeSettings( panel )

end

function SKIN:PaintFrame(frame)
        local w, h = frame:GetSize()
        local color = Color(50,50,50,255)
        draw.RoundedBox(8, 0, 0, w, h, color)
        
        surface.SetDrawColor(color)
        surface.DrawLine(0, 20, w, 20)
end

function SKIN:PaintTab( panel )

	// This adds a little shadow to the right which helps define the tab shape..
	draw.RoundedBox( 4, 0, 0, panel:GetWide(), panel:GetTall() + 8, self.colTabShadow )
	
	if ( panel:GetPropertySheet():GetActiveTab() == panel ) then
		draw.RoundedBox( 4, 1, 0, panel:GetWide()-2, panel:GetTall() + 8, Color(100,100,100,255) )
	else
		draw.RoundedBox( 4, 0, 0, panel:GetWide()-1, panel:GetTall() + 8, Color(100,100,100,150) )
	end
	
end

function SKIN:SchemeTab( panel )

	panel:SetFont( "KCV20" )

	local ExtraInset = 10

	if ( panel.Image ) then
		ExtraInset = ExtraInset + panel.Image:GetWide()
	end
	
	panel:SetTextInset( ExtraInset )
	panel:SizeToContents()
	panel:SetSize( panel:GetWide() + 10, panel:GetTall() + 8 )
	
	local Active = panel:GetPropertySheet():GetActiveTab() == panel
	
	if ( Active ) then
		panel:SetTextColor( self.colTabText )
	else
		panel:SetTextColor( self.colTabTextInactive )
	end
	
	panel.BaseClass.ApplySchemeSettings( panel )
		
end

function SKIN:LayoutTab( panel )

	panel:SetTall( 25 )

	if ( panel.Image ) then
	
		local Active = panel:GetPropertySheet():GetActiveTab() == panel
		
		local Diff = panel:GetTall() - panel.Image:GetTall()
		panel.Image:SetPos( 7, Diff * 0.6 )
		
		if ( !Active ) then
			panel.Image:SetImageColor( Color( 170, 170, 170, 155 ) )
		else
			panel.Image:SetImageColor( Color( 255, 255, 255, 255 ) )
		end
	
	end	
	
end

function SKIN:PaintPropertySheet( panel )

	local ActiveTab = panel:GetActiveTab()
	local Offset = 0
	if ( ActiveTab ) then Offset = ActiveTab:GetTall() end
	
	// This adds a little shadow to the right which helps define the tab shape..
	draw.RoundedBox( 4, 0, Offset, panel:GetWide(), panel:GetTall()-Offset, Color(100,100,100,255) )
	
end

function SKIN:SchemeCategoryHeader( panel )
	
	panel:SetTextInset( 5 )
	panel:SetFont( self.fontCategoryHeader )
	
	if ( panel:GetParent():GetExpanded() ) then
		panel:SetTextColor( self.colCategoryText )
	else
		panel:SetTextColor( self.colCategoryText )
	end
	
end



derma.DefineSkin( "Blackskin", "Black Color", SKIN )