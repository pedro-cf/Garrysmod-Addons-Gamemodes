ITEM.Name = "No Entry Mask"
ITEM.Enabled = true
ITEM.Description = "Gives you a no entry sign mask."
ITEM.Cost = 2000
ITEM.Model = "models/props_c17/streetsign004f.mdl"
ITEM.Attachment = "eyes"

ITEM.Functions = {
	OnGive = function(ply, item)
		ply:PS_AddHat(item)
	end,
	
	OnTake = function(ply, item)
		ply:PS_RemoveHat(item)
	end,
	
	ModifyHat = function(ent, pos, ang)
		ent:SetModelScale(Vector(0.3, 0.3, 0.3))
		pos = pos + (ang:Forward() * 2) + (ang:Up() * 3)
		ang:RotateAroundAxis(ang:Up(), -90)
		ang:RotateAroundAxis(ang:Forward(), 10)
		return ent, pos, ang
	end,
}

ITEM.Hooks = {
	PlayerInitialSpawn = function(ply, item)
		ply:PS_AddHat(item)
	end
}