ITEM.Name = "Bomb Head"
ITEM.Enabled = true
ITEM.Description = "Gives you a bomb head."
ITEM.Cost = 5500
ITEM.Model = "models/Combine_Helicopter/helicopter_bomb01.mdl"
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
		pos = pos + (ang:Forward() * -2)
		ang:RotateAroundAxis(ang:Right(), 90)
		return ent, pos, ang
	end,
}

ITEM.Hooks = {
	PlayerInitialSpawn = function(ply, item)
		ply:PS_AddHat(item)
	end
}
