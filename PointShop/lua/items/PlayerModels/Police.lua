ITEM.Name = "Police"
ITEM.Enabled = true
ITEM.Description = "PlayerModel"
ITEM.Cost = 6000
ITEM.Model = "models/player/police.mdl"

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