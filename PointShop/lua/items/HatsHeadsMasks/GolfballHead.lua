ITEM.Name = "Golfball Head"
ITEM.Enabled = true
ITEM.Description = "Gives you a Golfball Head."
ITEM.Cost = 4500
ITEM.Model = "models/XQM/Rails/gumball_1.mdl"
ITEM.Attachment = "eyes"

ITEM.Functions = {
	OnGive = function(ply, item)
		ply:PS_AddHat(item)
	end,
	
	OnTake = function(ply, item)
		ply:PS_RemoveHat(item)
	end,
	
	ModifyHat = function(ent, pos, ang)
		ent:SetModelScale(Vector(0.5, 0.5, 0.5))
		pos = pos + (ang:Forward() * -2) + (ang:Up() * -1)
		return ent, pos, ang
	end,
}

ITEM.Hooks = {
	PlayerInitialSpawn = function(ply, item)
		ply:PS_AddHat(item)
	end
}