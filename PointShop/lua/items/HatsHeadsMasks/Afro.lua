ITEM.Name = "Afro"
ITEM.Enabled = true
ITEM.Donator = true
ITEM.Description = "Gives you a hip afro."
ITEM.Cost = 10000
ITEM.Model = "models/gmod_tower/afro.mdl"
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
		pos = pos + (ang:Forward() * -4) + (ang:Up()*2)
		return ent, pos, ang
	end
}

ITEM.Hooks = {
	PlayerInitialSpawn = function(ply, item)
		ply:PS_AddHat(item)
	end
}