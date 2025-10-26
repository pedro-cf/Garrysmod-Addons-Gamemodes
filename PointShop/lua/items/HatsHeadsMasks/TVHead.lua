ITEM.Name = "TV Head"
ITEM.Enabled = true
ITEM.Description = "Gives you a TV head."
ITEM.Cost = 5500
ITEM.Model = "models/props_c17/tv_monitor01.mdl"
ITEM.Attachment = "eyes"

ITEM.Functions = {
	OnGive = function(ply, item)
		ply:PS_AddHat(item)
	end,
	
	OnTake = function(ply, item)
		ply:PS_RemoveHat(item)
	end,
	
	ModifyHat = function(ent, pos, ang)
		ent:SetModelScale(Vector(0.8, 0.8, 0.8))
		pos = pos + (ang:Right() * -2) + (ang:Forward() * -3) + (ang:Up() * 0.5)
		return ent, pos, ang
	end,
}

ITEM.Hooks = {
	PlayerInitialSpawn = function(ply, item)
		ply:PS_AddHat(item)
	end
}
