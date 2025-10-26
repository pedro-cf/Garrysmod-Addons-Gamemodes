ITEM.Name = "Pan Hat"
ITEM.Enabled = true
ITEM.Description = "Gives you a pan hat."
ITEM.Cost = 1500
ITEM.Model = "models/props_interiors/pot02a.mdl"
ITEM.Attachment = "eyes"

ITEM.Functions = {
	OnGive = function(ply, item)
		ply:PS_AddHat(item)
	end,
	
	OnTake = function(ply, item)
		ply:PS_RemoveHat(item)
	end,
	
	ModifyHat = function(ent, pos, ang)
		pos = pos + (ang:Forward() * -3) + (ang:Up() * 2) + (ang:Right() * 5.5)
		ang:RotateAroundAxis(ang:Right(), 180)
		return ent, pos, ang
	end,
}

ITEM.Hooks = {
	PlayerInitialSpawn = function(ply, item)
		ply:PS_AddHat(item)
	end
}