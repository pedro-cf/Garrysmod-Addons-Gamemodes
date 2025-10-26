ITEM.Name = "Backpack"
ITEM.Enabled = true
ITEM.Description = "Gives you a wearable backpack."
ITEM.Cost = 10000
ITEM.Model = "models/props_c17/SuitCase_Passenger_Physics.mdl"
ITEM.Bone = "ValveBiped.Bip01_Spine2"

ITEM.Functions = {
	OnGive = function(ply, item)
		ply:PS_AddHat(item)
	end,
	
	OnTake = function(ply, item)
		ply:PS_RemoveHat(item)
	end,
	
	ModifyHat = function(ent, pos, ang)
		ent:SetModelScale(Vector(0.7, 0.7, 0.7))
		pos = pos + (ang:Right() * 5) + (ang:Up() * 0) + (ang:Forward() * 2)
		return ent, pos, ang
	end,
}

ITEM.Hooks = {
	PlayerInitialSpawn = function(ply, item)
		ply:PS_AddHat(item)
	end
}

-- lua_run Entity(1):PS_RemoveHat(POINTSHOP.FindItemByID("backpack")); lua_openscript_cl sh_items.lua; lua_run Entity(1):PS_AddHat(POINTSHOP.FindItemByID("backpack"))