ITEM.Name = "Knife"
ITEM.Enabled = true
ITEM.Description = "Get a Knife!"
ITEM.Cost = 10000
ITEM.Model = "models/weapons/w_knife_t.mdl"
ITEM.Weapon = "weapon_real_cs_knife"

ITEM.Functions = {
	OnGive = function(ply, item)
		ply:Give(item.Weapon)
		ply:SetPData(item.Weapon, 1)
	end,
	
	OnTake = function(ply, item)
		ply:StripWeapon(item.Weapon)
		ply:SetPData(item.Weapon, 0)
	end
}

ITEM.Hooks = {
	PlayerSpawn = function(ply, item)
	end
}