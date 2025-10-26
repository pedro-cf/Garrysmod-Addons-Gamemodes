ITEM.Name = "RU Arm Armor"
ITEM.Enabled = true
ITEM.Donator = true
ITEM.Description = "Visual"
ITEM.Cost = 20000
ITEM.Model = "models/props_combine/headcrabcannister01a.mdl"
ITEM.Bone = "ValveBiped.Bip01_R_UpperArm"

ITEM.Functions = {
	OnGive = function(ply, item)
		ply:PS_AddHat(item)
	end,
	
	OnTake = function(ply, item)
		ply:PS_RemoveHat(item)
	end,
	
	ModifyHat = function(ent, pos, ang)
		ent:SetModelScale(Vector(0.18, 0.18, 0.18))
		pos = pos + (ang:Up()*-5) + (ang:Forward() * 6)
		--ang:RotateAroundAxis(ang:Right(), 200)
		return ent, pos, ang
	end,
}

ITEM.Hooks = {
	PlayerInitialSpawn = function(ply, item)
		ply:PS_AddHat(item)
	end
}

-- lua_run Entity(1):PS_RemoveHat(POINTSHOP.FindItemByID("leftupperarmarmor")); lua_openscript_cl sh_items.lua; lua_run Entity(1):PS_AddHat(POINTSHOP.FindItemByID("leftupperarmarmor"))