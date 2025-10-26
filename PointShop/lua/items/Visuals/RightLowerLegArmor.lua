ITEM.Name = "RL Leg Armor"
ITEM.Enabled = true
ITEM.Description = "Visual"
ITEM.Cost = 20000
ITEM.Model = "models/props_combine/CombineInnerwall001a.mdl"
ITEM.Bone = "ValveBiped.Bip01_R_Calf"

ITEM.Functions = {
	OnGive = function(ply, item)
		ply:PS_AddHat(item)
	end,
	
	OnTake = function(ply, item)
		ply:PS_RemoveHat(item)
	end,
	
	ModifyHat = function(ent, pos, ang)
		ent:SetModelScale(Vector(0.046, 0.046, 0.026))
		--pos = pos + (ang:Right() * 2)
		pos = pos + (ang:Up()*-5) + (ang:Forward() * 6)
		ang:RotateAroundAxis(ang:Right(), 90)
		ang:RotateAroundAxis(ang:Up(), -90)
		return ent, pos, ang
	end,
}

ITEM.Hooks = {
	PlayerInitialSpawn = function(ply, item)
		ply:PS_AddHat(item)
	end
}

-- lua_run Entity(1):PS_RemoveHat(POINTSHOP.FindItemByID("leftlowerlegarmor")); lua_openscript_cl sh_items.lua; lua_run Entity(1):PS_AddHat(POINTSHOP.FindItemByID("leftlowerlegarmor"))