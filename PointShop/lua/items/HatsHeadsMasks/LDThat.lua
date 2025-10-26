ITEM.Name = "LDT Hat"
ITEM.Enabled = true
ITEM.Description = "Gives you a LDT Hat."
ITEM.Cost = 1100
ITEM.Model = "models/props/ld_office/ldtclan_hat.mdl"
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
		pos = pos + (ang:Up() * 2.7) + (ang:Forward()*-2)
		ang:RotateAroundAxis(ang:Up(), -90)
		return ent, pos, ang
	end,
}

ITEM.Hooks = {
	PlayerInitialSpawn = function(ply, item)
		ply:PS_AddHat(item)
	end
}