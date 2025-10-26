ITEM.Name = "Space Helmet"
ITEM.Enabled = true
ITEM.Description = "Gives you a Space Helmet."
ITEM.Cost = 6000
ITEM.Model = "models/astronauthelmet/astronauthelmet.mdl"
ITEM.Attachment = "eyes"

ITEM.Functions = {
	OnGive = function(ply, item)
		ply:PS_AddHat(item)
	end,
	
	OnTake = function(ply, item)
		ply:PS_RemoveHat(item)
	end,
	
	ModifyHat = function(ent, pos, ang)
		ent:SetModelScale(Vector(0.9, 0.9, 0.9))
		pos = pos + (ang:Forward() * -2) + (ang:Up() * -7)
		return ent, pos, ang
	end
}

ITEM.Hooks = {
	PlayerInitialSpawn = function(ply, item)
		ply:PS_AddHat(item)
	end
}