ITEM.Name = "<3 Turtles Hat"
ITEM.Enabled = true
ITEM.Description = "Gives you a <3 Turtles Hat."
ITEM.Cost = 4500
ITEM.Model = "models/props/de_tides/Vending_hat.mdl"
ITEM.Attachment = "eyes"

ITEM.Functions = {
	OnGive = function(ply, item)
		ply:PS_AddHat(item)
	end,
	
	OnTake = function(ply, item)
		ply:PS_RemoveHat(item)
	end,
	
	ModifyHat = function(ent, pos, ang)
		ent:SetModelScale(Vector(0.85, 0.85, 0.85))
		pos = pos + (ang:Up() * 1.5) + (ang:Forward()*-2.5)
		ang:RotateAroundAxis(ang:Up(), -90)
		return ent, pos, ang
	end,
}

ITEM.Hooks = {
	PlayerInitialSpawn = function(ply, item)
		ply:PS_AddHat(item)
	end
}