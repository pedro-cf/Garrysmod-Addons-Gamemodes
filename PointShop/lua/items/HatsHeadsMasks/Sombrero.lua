ITEM.Name = "Sombrero"
ITEM.Enabled = true
ITEM.Description = "Gives you a Sombrero."
ITEM.Cost = 6500
ITEM.Model = "models/gmod_tower/sombrero.mdl"
ITEM.Attachment = "eyes"

ITEM.Functions = {
	OnGive = function(ply, item)
		ply:PS_AddHat(item)
	end,
	
	OnTake = function(ply, item)
		ply:PS_RemoveHat(item)
	end,
	
	ModifyHat = function(ent, pos, ang)
		ent:SetModelScale(Vector(1, 1, 1))
		pos = pos + (ang:Forward() * -3.5) + (ang:Up() * 2)
		ang:RotateAroundAxis(ang:Right(), 10)
		return ent, pos, ang
	end,
}

ITEM.Hooks = {
	PlayerInitialSpawn = function(ply, item)
		ply:PS_AddHat(item)
	end
}