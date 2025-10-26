ITEM.Name = "Dunce Hat"
ITEM.Enabled = true
ITEM.Description = "Gives you a Dunce Hat."
ITEM.Cost = 1400
ITEM.Model = "models/duncehat/duncehat.mdl"
ITEM.Attachment = "eyes"

ITEM.Functions = {
	OnGive = function(ply, item)
		ply:PS_AddHat(item)
	end,
	
	OnTake = function(ply, item)
		ply:PS_RemoveHat(item)
	end,
		
	ModifyHat = function(ent, pos, ang)
		pos = pos + (ang:Forward() * -3) + (ang:Up())
		return ent, pos, ang
	end
}

ITEM.Hooks = {
	PlayerInitialSpawn = function(ply, item)
		ply:PS_AddHat(item)
	end
}