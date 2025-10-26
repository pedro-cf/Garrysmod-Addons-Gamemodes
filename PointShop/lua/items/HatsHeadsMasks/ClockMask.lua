ITEM.Name = "Clock Mask"
ITEM.Enabled = true
ITEM.Description = "Gives you a clock mask."
ITEM.Cost = 2000
ITEM.Model = "models/props_c17/clock01.mdl"
ITEM.Attachment = "eyes"

ITEM.Functions = {
	OnGive = function(ply, item)
		ply:PS_AddHat(item)
	end,
	
	OnTake = function(ply, item)
		ply:PS_RemoveHat(item)
	end,
	
	ModifyHat = function(ent, pos, ang)
		pos = pos + (ang:Up() * 3) + (ang:Forward() * 0.5)
		ent:SetModelScale(Vector(0.4, 0.4, 0.4))
		ang:RotateAroundAxis(ang:Right(), -70)
		return ent, pos, ang
	end
}

ITEM.Hooks = {
	PlayerInitialSpawn = function(ply, item)
		ply:PS_AddHat(item)
	end
}