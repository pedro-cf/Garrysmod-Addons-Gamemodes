ITEM.Name = "Katana"
ITEM.Enabled = true
ITEM.Description = "Get a Katana!"
ITEM.Cost = 20000
ITEM.Model = "models/weapons/w_katana.mdl"
ITEM.Weapon = "weapon_katana"

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