POINTSHOP.Hats = {}
local Christmas = false
if (os.date("%m") == "11") or (os.date("%m") == "12") or (os.date("%m") == "1") then
	Christmas = true
end

local KeyToHook = {
	F1 = "ShowHelp",
	F2 = "ShowTeam",
	F3 = "ShowSpare1",
	F4 = "ShowSpare2",
	None = "ThisHookDoesNotExist"
}

hook.Add(KeyToHook[POINTSHOP.Config.ShopKey], "PointShop_ShopKey", function(ply)
	if ply:GetPData("Joining") == "1" then
		ply:PS_ShowShop(true)
	else		
		ply:PS_Notify('Shop Loading!')
		return
	end
end)

hook.Add("PlayerSay", "Chatrandomft", function(ply, text)
    if  (string.lower(text) == "!shop") or (string.lower(text) == "!store") or (string.lower(text) == "!hat") or (string.lower(text) == "!buy") then
        ply:PS_ShowShop(true)
    end
end )

hook.Add( "PlayerSpawn", "SpawnWeaponsPS", function( ply )
	
	timer.Simple(1,function()
		if ply:GetPData("weapon_real_cs_knife") == "1" then
			ply:Give("weapon_real_cs_knife")
			ply:SelectWeapon("weapon_real_cs_knife")
		end
		if ply:GetPData("lightsaber") == "1" then
			ply:Give("lightsaber")
			ply:SelectWeapon("lightsaber")
		end
		if ply:GetPData("weapon_sythe") == "1" then
			ply:Give("weapon_sythe")
			ply:SelectWeapon("weapon_sythe")
		end
		if ply:GetPData("weapon_stunstick") == "1" then
			ply:Give("weapon_stunstick")
			ply:SelectWeapon("weapon_stunstick")
		end
		if ply:GetPData("weapon_katana") == "1" then
			ply:Give("weapon_katana")
			ply:SelectWeapon("weapon_katana")
		end
	end )
	
end )

hook.Add("PlayerInitialSpawn", "PointShop_PlayerInitialSpawn", function(ply)

	if !ply:GetPData("weapon_real_cs_knife") then
		ply:SetPData("weapon_real_cs_knife", 0)
	elseif !ply:GetPData("lightsaber") then
		ply:SetPData("lightsaber", 0)
	elseif !ply:GetPData("weapon_sythe") then
		ply:SetPData("weapon_sythe", 0)
	elseif !ply:GetPData("weapon_stunstick") then
		ply:SetPData("weapon_stunstick", 0)
	elseif !ply:GetPData("weapon_katana") then
		ply:SetPData("weapon_katana", 0)
	end
	
	ply:SetPData("Joining", 0)
	timer.Simple(1.2, function()
		ply:SetPData("Joining", 1)
	end )
	
	ply.PS_Items = 0
	ply.PS_Items = {}
	
	timer.Simple(1, function()
		ply:PS_UpdatePoints()
		ply:PS_LoadItems()
		ply:PS_SendHats()
	end )
	timer.Simple(1.1, function()
		for _,p in pairs(player.GetAll()) do
			for _, item_id in pairs(p.PS_Items) do
				if POINTSHOP.FindCategoryByItemID(item_id).Name == "Hats" or POINTSHOP.FindCategoryByItemID(item_id).Name == "Visuals" then
					local item = POINTSHOP.FindItemByID(item_id)
					if item and item.Functions and item.Functions.OnTake then
						item.Functions.OnTake(p, item)
					end
			
					if item and item.Functions and item.Functions.OnGive then
						item.Functions.OnGive(p, item)
					end
				end
			end
			if p:GetPData("LastHatEquipped") then
				p:PS_EquipHat(POINTSHOP.FindItemByID(p:GetPData("LastHatEquipped")))
			end
		end
	end)
	
	if POINTSHOP.Config.PointsTimer then
		timer.Create("PointShop_" .. ply:UniqueID(), 60 * POINTSHOP.Config.PointsTimerDelay, 0, function(ply)
			ply:PS_GivePoints(POINTSHOP.Config.PointsTimerAmount, POINTSHOP.Config.PointsTimerDelay .. " minutes on server")
		end, ply)
	end
	
	if POINTSHOP.Config.ShopNotify then
		ply:PS_Notify('You have ' .. ply:PS_GetPoints() .. ' points to spend! Press ' .. POINTSHOP.Config.ShopKey .. ' to open the Shop!')
	end
end)

for id, category in pairs(POINTSHOP.Items) do
	if category.Enabled then
		for item_id, item in pairs(category.Items) do
			if item.Enabled then
				if item.Hooks then
					for name, func in pairs(item.Hooks) do
						timer.Simple(1, function()
							hook.Add(name, "PointShop_" .. item_id .. "_" .. name, function(ply, ...) -- Pass any arguments through.
								if ply:PS_HasItem(item_id) then -- only run the hook if the player actually has this item.
									item.ID = item_id -- Pass the ID incase it's needed in the hook.
									return func(ply, item, unpack({...}))
								end
							end)
						end)
					end
				end
				if item.ConstantHooks then
					for name, func in pairs(item.ConstantHooks) do
						hook.Add(name, "PointShop_" .. item_id .. "_Constant_" .. name, function(ply, ...) -- Pass any arguments through.
							item.ID = item_id
							return func(ply, item, unpack({...}))
						end)
					end
				end
			end
		end
	end
end

concommand.Add("pointshop_buy", function(ply, cmd, args)
	local item_id = args[1]
	if not item_id then return end
	
	if ply:PS_HasItem(item_id) then
		ply:PS_Notify('You already have this item!')
		return
	end
	
	local item = POINTSHOP.FindItemByID(item_id)
	if not item then return end
	
	local category = POINTSHOP.FindCategoryByItemID(item_id)
	
	if not item.Enabled then
		ply:PS_Notify('This item isn\'t enabled!')
		return
	end
	
	if not category.Enabled then
		ply:PS_Notify('The category ' .. category.Name .. 'is not enabled!')
		return
	end
	
	if item.AdminOnly and not ply:IsAdmin() then
		ply:PS_Notify('Only admins can buy this item!')
		if ply:GetPData("Joining") == "1" then
			ply:PS_ShowShop(false)
			timer.Simple(0.5, function() ply:PS_ShowShop(true) end)
		end
		return
	end

	if item.Donator and !ply:GetNWBool("LDTdonator") then
		ply:PS_Notify('You need to be a donator to buy this item!')
		ply:SendLua("Derma_Message(\"You need to be a donator to buy this item!\", \"PointShop\", \"Close\")")
		return
	end
	
	if item.Christmas and not Christmas == true then
		ply:PS_Notify('It is not Christmas!')
		ply:SendLua("Derma_Message(\"It is not Christmas!\", \"PointShop\", \"Close\")")
		return
	end
	
	if item.Functions and item.Functions.CanPlayerBuy then
		local canbuy, reason = item.Functions.CanPlayerBuy(ply)
		if not canbuy then
			ply:PS_Notify('Can\'t buy item (' .. reason .. ')')
			return
		end
	end
	
	if category.NumAllowedItems and ply:PS_NumItemsFromCategory(category) >= category.NumAllowedItems then -- More than would never happen, but just incase.
		ply:PS_Notify('You can only have ' .. category.NumAllowedItems .. ' items from the ' .. category.Name .. ' category!')
		if ply:GetPData("Joining") == "1" then
			ply:PS_ShowShop(false)
			timer.Simple(0.5, function() ply:PS_ShowShop(true) end)
		end
		return
	end
	
	if not ply:PS_CanAfford(item_id) then
		ply:PS_Notify('You can\'t afford this!')
		return
	end

	ply:PS_GiveItem(item_id, true)
	ply:PS_EquipHat(POINTSHOP.FindItemByID(item_id))
	ply:SendLua( "surface.PlaySound( Sound( \"buttons/button14.wav\" ) )" )
end)

concommand.Add("pointshop_sell", function(ply, cmd, args)
	local item_id = args[1]
	if not item_id then return end
	
	if not ply:PS_HasItem(item_id) then return end
	
	if POINTSHOP.FindCategoryByItemID(item_id).Name == "Hats" then
		if ply.PS_Items_Equipped[item_id] then
			local stop = 0
			for _, iid in pairs(ply.PS_Items) do
				if stop < 1 then
					if POINTSHOP.FindCategoryByItemID(iid).Name == "Hats" then
						ply:PS_EquipHat(POINTSHOP.FindItemByID(iid))
						stop = stop +1
					end
				end
			end
			stop = 0
		end
	end
	
	ply:PS_TakeItem(item_id, true)
	ply:SendLua( "surface.PlaySound( Sound( \"buttons/button14.wav\" ) )" )
end)

concommand.Add("pointshop_equip", function(ply, cmd, args)
	local item_id = args[1]
	if not item_id then return end
	
	if not ply:PS_HasItem(item_id) then return end
	

	if #ply.PS_Items > 1 or !ply.PS_Items_Equipped[item_id] then
		if ply:GetPData("Joining") == "1" then
			ply:PS_ShowShop(false)
			timer.Simple(0.5, function() ply:PS_ShowShop(true) end)
		end
	end

	ply:PS_EquipHat(POINTSHOP.FindItemByID(item_id))
	ply:SendLua( "surface.PlaySound( Sound( \"buttons/button18.wav\" ) )" )
end)

concommand.Add("pointshop_unequip", function(ply, cmd, args)
	local item_id = args[1]
	if not item_id then return end
	
	if not ply:PS_HasItem(item_id) then return end
	
	ply:PS_UnEquipHat(POINTSHOP.FindItemByID(item_id))
	ply:SendLua( "surface.PlaySound( Sound( \"buttons/button18.wav\" ) )" )
	if ply:GetPData("Joining") == "1" then
		ply:PS_ShowShop(false)
		timer.Simple(0.5, function() ply:PS_ShowShop(true) end)
	end
end)

concommand.Add("ps_givepoints", function(ply, cmd, args)
	-- Give Points
	if not ply:IsAdmin() then return end
	
	local to_give = POINTSHOP.FindPlayerByName(args[1])
	local num = tonumber(args[2])
	
	if not to_give or not num then
		ply:PS_Notify("Please give a name and number!")
		return
	end
	
	if not type(to_give) == "player" then
		if to_give then
			ply:PS_Notify("You weren't specific enough with the name you typed!")
		else
			ply:PS_Notify("No player found by that name!")
		end
	else
		to_give:PS_GivePoints(num, "given by " .. ply:Nick() .. "!")
	end
end)

concommand.Add("ps_takepoints", function(ply, cmd, args)
	-- Take Points
	if not ply:IsAdmin() then return end
	
	local to_take = POINTSHOP.FindPlayerByName(args[1])
	local num = tonumber(args[2])
	
	if not to_take or not num then
		ply:PS_Notify("Please give a name and number!")
		return
	end
	
	if not type(to_take) == "player" then
		if to_take then
			ply:PS_Notify("You weren't specific enough with the name you typed!")
		else
			ply:PS_Notify("No player found by that name!")
		end
	else
		to_take:PS_TakePoints(num, "taken by " .. ply:Nick() .. "!")
	end
end)

concommand.Add("ps_setpoints", function(ply, cmd, args)
	-- Set Points
	if not ply:IsAdmin() then return end
	
	local to_set = POINTSHOP.FindPlayerByName(args[1])
	local num = tonumber(args[2])
	
	if not to_set or not num then
		ply:PS_Notify("Please give a name and number!")
		return
	end
	
	if not type(to_set) == "player" then
		if to_set then
			ply:PS_Notify("You weren't specific enough with the name you typed!")
		else
			ply:PS_Notify("No player found by that name!")
		end
	else
		to_set:PS_SetPoints(num)
		to_set:PS_Notify("Points set to " .. num .. " by " .. ply:Nick() .. "!")
	end
end)