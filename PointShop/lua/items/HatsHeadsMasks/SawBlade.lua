ITEM.Name = "Saw Blade"
ITEM.Enabled = true
ITEM.Description = "Gives you a Saw Blade."
ITEM.Cost = 6500
ITEM.Model = "models/props_junk/sawblade001a.mdl"
ITEM.Attachment = "eyes"

ITEM.Functions = {
	OnGive = function(ply, item)
		ply:PS_AddHat(item)
	end,
	
	OnTake = function(ply, item)
		ply:PS_RemoveHat(item)
	end,
	
	ModifyHat = function(ent, pos, ang)
		ent:SetModelScale(Vector(0.4, 0.4, 0.4))
		pos = pos + (ang:Forward() * 2) + (ang:Up() * 2)
		ang:RotateAroundAxis(ang:Forward(), 90)
		return ent, pos, ang
	end,
}

ITEM.Hooks = {
	PlayerInitialSpawn = function(ply, item)
		ply:PS_AddHat(item)
	end
}