ITEM.Name = "Visor"
ITEM.Enabled = true
ITEM.Description = "Gives you a Visor."
ITEM.Cost = 4500
ITEM.Model = "models/props_phx/construct/glass/glass_dome180.mdl"
ITEM.Attachment = "eyes"

ITEM.Functions = {
	OnGive = function(ply, item)
		ply:PS_AddHat(item)
	end,
	
	OnTake = function(ply, item)
		ply:PS_RemoveHat(item)
	end,
	
	ModifyHat = function(ent, pos, ang)
		ent:SetModelScale(Vector(0.11, 0.11, 0.11))
		pos = pos + (ang:Forward() * -2) 
		ang:RotateAroundAxis(ang:Up(), 180)
		ang:RotateAroundAxis(ang:Right(), 35)
		return ent, pos, ang
	end,
}

ITEM.Hooks = {
	PlayerInitialSpawn = function(ply, item)
		ply:PS_AddHat(item)
	end
}