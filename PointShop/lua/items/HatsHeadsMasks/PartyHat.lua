ITEM.Name = "Party Hat"
ITEM.Enabled = true
ITEM.Description = "Gives you a Party Hat."
ITEM.Cost = 4500
ITEM.Model = "models/gmod_tower/partyhat.mdl"
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
		pos = pos + (ang:Up() *3.5) + (ang:Right() *0.3) + (ang:Forward() *-2)
		ang:RotateAroundAxis(ang:Forward(), -6)
		return ent, pos, ang
	end
}

ITEM.Hooks = {
	PlayerInitialSpawn = function(ply, item)
		ply:PS_AddHat(item)
	end
}