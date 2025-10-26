ITEM.Name = "Scanner Head"
ITEM.Enabled = true
ITEM.Donator = true
ITEM.Description = "Gives you a Scanner Head."
ITEM.Cost = 10000
ITEM.Model = "models/Combine_Scanner.mdl"
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
		pos = pos + (ang:Forward() * -2) + (ang:Up() * -1.5)
		return ent, pos, ang
	end,
}

ITEM.Hooks = {
	PlayerInitialSpawn = function(ply, item)
		ply:PS_AddHat(item)
	end
}