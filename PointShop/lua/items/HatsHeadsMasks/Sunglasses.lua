ITEM.Name = "Sun glasses"
ITEM.Enabled = true
ITEM.Donator = true
ITEM.Description = "Gives you Sun glasses."
ITEM.Cost = 10000
ITEM.Model = "models/gmod_tower/aviators.mdl"
ITEM.Attachment = "eyes"

ITEM.Functions = {
	OnGive = function(ply, item)
		ply:PS_AddHat(item)
	end,
	
	OnTake = function(ply, item)
		ply:PS_RemoveHat(item)
	end,
	
	ModifyHat = function(ent, pos, ang)
		pos = pos + (ang:Forward() * -1.5)
		return ent, pos, ang
	end
}

ITEM.Hooks = {
	PlayerInitialSpawn = function(ply, item)
		ply:PS_AddHat(item)
	end
}