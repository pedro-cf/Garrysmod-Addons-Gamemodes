ITEM.Name = "Spotlight Head"
ITEM.Enabled = true
ITEM.Description = "Gives you a spotlight head."
ITEM.Cost = 5000
ITEM.Model = "models/props_wasteland/light_spotlight01_lamp.mdl"
ITEM.Attachment = "eyes"

ITEM.Functions = {
	OnGive = function(ply, item)
		ply:PS_AddHat(item)
	end,
	
	OnTake = function(ply, item)
		ply:PS_RemoveHat(item)
	end,
	
	ModifyHat = function(ent, pos, ang)
		ent:SetModelScale(Vector(0.75, 0.75, 0.75))
		pos = pos +(ang:Up() * -2) + (ang:Forward() * -2)
		return ent, pos, ang
	end,
}

ITEM.Hooks = {
	PlayerInitialSpawn = function(ply, item)
		ply:PS_AddHat(item)
	end
}