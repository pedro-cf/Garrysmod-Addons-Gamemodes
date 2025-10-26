ITEM.Name = "Santa Hat"
ITEM.Enabled = true
ITEM.Christmas = true
ITEM.Description = "Gives you a Santa Hat."
ITEM.Cost = 1000
ITEM.Model = "models/santahat/santahat.mdl"
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
		pos = pos + (ang:Up()*2) + (ang:Forward()*-3)
		return ent, pos, ang
	end,
}

ITEM.Hooks = {
	PlayerInitialSpawn = function(ply, item)
		ply:PS_AddHat(item)
	end
}