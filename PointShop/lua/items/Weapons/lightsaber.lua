ITEM.Name = "Lightsaber"
ITEM.Enabled = true
ITEM.Description = "Get a Lightsaber!"
ITEM.Cost = 25000
ITEM.Model = "models/weapons/v_crewbar.mdl"
ITEM.Weapon = "lightsaber"

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