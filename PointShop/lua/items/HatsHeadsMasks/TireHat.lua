ITEM.Name = "Tire Hat"
ITEM.Enabled = true
ITEM.Description = "Gives you a Tire Hat."
ITEM.Cost = 5500
ITEM.Model = "models/props_vehicles/carparts_tire01a.mdl"
ITEM.Attachment = "eyes"

ITEM.Functions = {
	OnGive = function(ply, item)
		ply:PS_AddHat(item)
	end,
	
	OnTake = function(ply, item)
		ply:PS_RemoveHat(item)
	end,
	
	ModifyHat = function(ent, pos, ang)
		ent:SetModelScale(Vector(0.4, 0.4, 0.4))
		pos = pos + (ang:Up() * 2.7) + (ang:Forward()*-3)
		ang:RotateAroundAxis(ang:Forward(), 90)
		return ent, pos, ang
	end,
}

ITEM.Hooks = {
	PlayerInitialSpawn = function(ply, item)
		ply:PS_AddHat(item)
	end
}