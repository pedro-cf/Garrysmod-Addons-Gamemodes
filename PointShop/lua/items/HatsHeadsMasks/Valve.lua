ITEM.Name = "Valve"
ITEM.Enabled = true
ITEM.Description = "Gives you a Valve."
ITEM.Cost = 6500
ITEM.Model = "models/props_pipes/valvewheel002a.mdl"
ITEM.Attachment = "eyes"

ITEM.Functions = {
	OnGive = function(ply, item)
		ply:PS_AddHat(item)
	end,
	
	OnTake = function(ply, item)
		ply:PS_RemoveHat(item)
	end,
	
	ModifyHat = function(ent, pos, ang)
		ent:SetModelScale(Vector(0.6, 0.6, 0.6))
		pos = pos + (ang:Forward() * -5) + (ang:Up() * 1)
		ang:RotateAroundAxis(ang:Right(), 60)
		return ent, pos, ang
	end,
}

ITEM.Hooks = {
	PlayerInitialSpawn = function(ply, item)
		ply:PS_AddHat(item)
	end
}