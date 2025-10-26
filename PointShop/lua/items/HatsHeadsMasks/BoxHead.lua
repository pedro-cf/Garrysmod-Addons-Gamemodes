ITEM.Name = "Box Head"
ITEM.Enabled = true
ITEM.Description = "Gives you a Box Head."
ITEM.Cost = 4500
ITEM.Model = "models/props_junk/wood_crate001a.mdl"
ITEM.Attachment = "eyes"

ITEM.Functions = {
	OnGive = function(ply, item)
		ply:PS_AddHat(item)
	end,
	
	OnTake = function(ply, item)
		ply:PS_RemoveHat(item)
	end,
	
	ModifyHat = function(ent, pos, ang)
		ent:SetModelScale(Vector(0.34, 0.34, 0.34))
		pos = pos + (ang:Forward() * -3)
		return ent, pos, ang
	end,
}

ITEM.Hooks = {
	PlayerInitialSpawn = function(ply, item)
		ply:PS_AddHat(item)
	end
}