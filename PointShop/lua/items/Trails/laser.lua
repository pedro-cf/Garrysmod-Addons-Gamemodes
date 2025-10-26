ITEM.Name = "Laser Trail"
ITEM.Enabled = true
ITEM.Description = "Gives you a Laser Trail."
ITEM.Cost = 20000
ITEM.Material = "trails/laser"

ITEM.Functions = {
	OnGive = function(ply, item)
		if ply:Alive() then
			item.Hooks.PlayerSpawn(ply, item)
		end
	end,
	
	OnTake = function(ply, item)
		SafeRemoveEntity(ply.Trail)
	end
}

ITEM.Hooks = {
	PlayerSpawn = function(ply, item)
		if ply:Alive() and ( ply:Team() == 1 or ply:Team() == 2 ) then
			ply.Trail = util.SpriteTrail(ply, 0, Color(255, 0, 0), false, 30, 5, 1.5, 0.125, item.Material .. ".vmt")
		end
	end,
	
	PlayerDeath = function(ply, item)
		if ply:Alive() then
			SafeRemoveEntity(ply.Trail)
		end
	end
}