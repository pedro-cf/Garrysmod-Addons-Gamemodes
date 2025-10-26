--in case the lua gets openscripted.
for id, pla in pairs(player.GetAll()) do
	pla.AFKTime = os.time()
end

hook.Add( "PlayerInitialSpawn", "TTT_Shop_FSpawn", function( ply )
	ply.AFKTime = os.time()
end )

hook.Add( "KeyPress", "Shop_AFKpress", function( ply )
	ply.AFKTime = os.time()
end )

hook.Add( "PlayerSay", "Shop_AFKsay", function( ply )
	ply.AFKTime = os.time()
end )

function _R.Player:IsAFK(time)
	local secs = tonumber(time) or 45
	if (os.time() - self.AFKTime > secs) then
		return true
	else
		return false
	end
end

hook.Add( "Initialize", "Timer_Shop_Active", function()
	timer.Create( "Points_ActiveTimer", 300, 0, function()
			for _,v in pairs(player.GetAll()) do
				if !v:IsAFK(45) then
					v:PS_GivePoints(10, "received due being active!")
				end
			end
	end )
end )