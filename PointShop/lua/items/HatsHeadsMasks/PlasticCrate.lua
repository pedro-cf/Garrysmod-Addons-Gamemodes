ITEM.Name = "Plastic Crate"
ITEM.Enabled = true
ITEM.Description = "Gives you a Plastic Crate."
ITEM.Cost = 2000
ITEM.Model = "models/props_junk/PlasticCrate01a.mdl"
ITEM.Attachment = "eyes"

ITEM.Functions = {
	OnGive = function(ply, item)
		ply:PS_AddHat(item)
	end,
	
	OnTake = function(ply, item)
		ply:PS_RemoveHat(item)
	end,
	
	ModifyHat = function(ent, pos, ang)
		ent:SetModelScale(Vector(0.7, 0.7, 0.7))
		pos = pos + (ang:Forward() * -3) + (ang:Up() * 1)
		ang:RotateAroundAxis(ang:Right(), 180)
		ang:RotateAroundAxis(ang:Up(), 90)
		return ent, pos, ang
	end,
}

ITEM.Hooks = {
	PlayerInitialSpawn = function(ply, item)
		ply:PS_AddHat(item)
	end
}