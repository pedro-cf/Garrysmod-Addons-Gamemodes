ITEM.Name = "Stun Stick"
ITEM.Enabled = true
ITEM.Description = "Get a Stun Stick!"
ITEM.Cost = 5000
ITEM.Model = "models/weapons/W_stunbaton.mdl"
ITEM.Weapon = "weapon_stunstick"

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