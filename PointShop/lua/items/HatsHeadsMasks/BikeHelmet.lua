ITEM.Name = "Bike Helmet"
ITEM.Enabled = true
ITEM.Donator = true
ITEM.Description = "Hat"
ITEM.Cost = 10000
ITEM.Model = "models/dean/gtaiv/helmet.mdl"
ITEM.Attachment = "eyes"

ITEM.Functions = {
	OnGive = function(ply, item)
		ply:PS_AddHat(item)
	end,
	
	OnTake = function(ply, item)
		ply:PS_RemoveHat(item)
	end,
	
	ModifyHat = function(ent, pos, ang)
		ent:SetModelScale(Vector(1.2, 1.2, 1.2))
		pos = pos + (ang:Forward() * -4) + (ang:Up() * -1)
		ang:RotateAroundAxis(ang:Right(), 0)
		return ent, pos, ang
	end,
}

ITEM.Hooks = {
	PlayerInitialSpawn = function(ply, item)
		ply:PS_AddHat(item)
	end
}