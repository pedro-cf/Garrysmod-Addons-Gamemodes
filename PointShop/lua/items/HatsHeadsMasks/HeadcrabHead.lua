ITEM.Name = "Headcrab Head"
ITEM.Enabled = true
ITEM.Description = "Gives you a Headcrab head."
ITEM.Cost = 5000
ITEM.Model = "models/gmod_tower/headcrabhat.mdl"
ITEM.Attachment = "eyes"

ITEM.Functions = {
	OnGive = function(ply, item)
		ply:PS_AddHat(item)
	end,
	
	OnTake = function(ply, item)
		ply:PS_RemoveHat(item)
	end,
	
	ModifyHat = function(ent, pos, ang)
		ent:SetModelScale(Vector(0.9, 0.9, 0.9))
		pos = pos + (ang:Forward() *-2.3) + (ang:Up() *-0.3)

		return ent, pos, ang
	end,
}

ITEM.Hooks = {
	PlayerInitialSpawn = function(ply, item)
		ply:PS_AddHat(item)
	end
}