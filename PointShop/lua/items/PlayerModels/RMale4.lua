ITEM.Name = "Male Rebel 4"
ITEM.Enabled = true
ITEM.Description = "PlayerModel"
ITEM.Cost = 2000
ITEM.Model = "models/player/Group03/Male_04.mdl"

ITEM.Functions = {
	OnGive = function(ply, item)
		item.Hooks.PlayerSpawn(ply, item)
	end,
	
	OnTake = function(ply, item)
		if ply._OldModel then
			ply:SetModel(ply._OldModel)
		end
	end
}

ITEM.Hooks = {
	PlayerSpawn = function(ply, item)
		if not ply._OldModel then
			ply._OldModel = ply:GetModel()
		end
		if ply._OldModel == "models/player.mdl" then
			ply._OldModel = "models/player/kleiner.mdl"
		end
		timer.Simple(0.2, function() ply:SetModel(item.Model) end)
	end
}