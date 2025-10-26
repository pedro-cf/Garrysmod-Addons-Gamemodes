local PLUGIN = {}
PLUGIN.Title = "Give Points"
PLUGIN.Description = "Gives Shop Points."
PLUGIN.Author = "Anonymous"
PLUGIN.ChatCommand = "givepoints"
PLUGIN.Usage = "<players> [points]"
PLUGIN.Privileges = { "Give Points" }

function PLUGIN:Call( ply, args )
	if ( ply:EV_HasPrivilege( "Give Points" ) ) then
		local pl = evolve:FindPlayer( args[1] )
		if ( #pl > 1 ) then
			evolve:Notify( ply, evolve.colors.white, "Did you mean ", evolve.colors.red, evolve:CreatePlayerList( pl, true ), evolve.colors.white, "?" )
		elseif ( #pl == 1 ) then
			local pointstogive = math.Clamp(tonumber( args[2] ) or 100, 0, 999999999 - tonumber(pl[1]:PS_GetPoints()))
			if ply:IsAdmin() then
				pl[1]:PS_GivePoints(pointstogive, "given by " .. ply:Nick() .. "!")
				evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has given ", evolve.colors.red, pl[1]:Nick(), evolve.colors.white, " " ..pointstogive.. " points." )
			elseif ply == pl[1] then
				evolve:Notify( ply, evolve.colors.red, "You can not give points to yourself." )
			elseif ( tonumber(ply:PS_GetPoints()) - pointstogive )  > 0 then
				ply:PS_TakePoints(pointstogive, "given to " .. pl[1]:Nick() .. "!")
				pl[1]:PS_GivePoints(pointstogive, "given by " .. ply:Nick() .. "!")
				evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has given ", evolve.colors.red, pl[1]:Nick(), evolve.colors.white, " " ..pointstogive.. " of his points." )
			elseif ( tonumber(ply:PS_GetPoints()) - pointstogive ) <= 0 then
				evolve:Notify( ply, evolve.colors.red, "You do not own that much points." )
			end
		else
			evolve:Notify( ply, evolve.colors.red, evolve.constants.noplayers )
		end
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

function PLUGIN:Menu( arg, players )
	if ( arg ) then
		table.insert( players, arg )
		RunConsoleCommand( "ev", "givepoints", unpack( players ) )
	else
		args = {}
		for i = 1, 10 do
			args[i] = { i * 1000 }
		end
		return "Give Points", evolve.category.administration, args
	end
end

evolve:RegisterPlugin( PLUGIN )

------------------------------------------------------


local PLUGIN = {}
PLUGIN.Title = "Take Points"
PLUGIN.Description = "Takes Shop Points."
PLUGIN.Author = "Anonymous"
PLUGIN.ChatCommand = "takepoints"
PLUGIN.Usage = "<players> [points]"
PLUGIN.Privileges = { "Take Points" }

function PLUGIN:Call( ply, args )
	if ( ply:EV_HasPrivilege( "Take Points" ) ) then
		local pl = evolve:FindPlayer( args[1] )
		
		if ( #pl > 1 ) then
			evolve:Notify( ply, evolve.colors.white, "Did you mean ", evolve.colors.red, evolve:CreatePlayerList( pl, true ), evolve.colors.white, "?" )
		elseif ( #pl == 1 ) then
			local pointstotake = math.Clamp(tonumber( args[2] ) or 100, 0, tonumber(pl[1]:PS_GetPoints()))
			evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has taken " ..pointstotake.. " points from ", evolve.colors.red, pl[1]:Nick(), evolve.colors.white, "." )
			pl[1]:PS_TakePoints(pointstotake, "taken by " .. ply:Nick() .. "!")
		else
			evolve:Notify( ply, evolve.colors.red, evolve.constants.noplayers )
		end
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

function PLUGIN:Menu( arg, players )
	if ( arg ) then
		table.insert( players, arg )
		RunConsoleCommand( "ev", "takepoints", unpack( players ) )
	else
		args = {}
		for i = 1, 10 do
			args[i] = { i * 1000 }
		end
		return "Take Points", evolve.category.administration, args
	end
end

evolve:RegisterPlugin( PLUGIN )


------------------------------------------------------


local PLUGIN = {}
PLUGIN.Title = "Set Points"
PLUGIN.Description = "Sets Shop Points."
PLUGIN.Author = "Anonymous"
PLUGIN.ChatCommand = "setpoints"
PLUGIN.Usage = "<players> [points]"
PLUGIN.Privileges = { "Set Points" }

function PLUGIN:Call( ply, args )
	if ( ply:EV_HasPrivilege( "Set Points" ) ) then
		local pl = evolve:FindPlayer( args[1] )
		
		if ( #pl > 1 ) then
			evolve:Notify( ply, evolve.colors.white, "Did you mean ", evolve.colors.red, evolve:CreatePlayerList( pl, true ), evolve.colors.white, "?" )
		elseif ( #pl == 1 ) then
			local pointstoset = math.Clamp( tonumber( args[2] ) or 100, 0, 999999999)
			evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has set ", evolve.colors.red, pl[1]:Nick(), evolve.colors.white, "'s points to " ..pointstoset.. "." )
			pl[1]:PS_SetPoints(pointstoset)
			pl[1]:PS_Notify("Points set to " .. pointstoset .. " by " .. ply:Nick() .. "!")
		else
			evolve:Notify( ply, evolve.colors.red, evolve.constants.noplayers )
		end
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

function PLUGIN:Menu( arg, players )
	if ( arg ) then
		table.insert( players, arg )
		RunConsoleCommand( "ev", "setpoints", unpack( players ) )
	else
		args = {}
		for i = 1, 10 do
			args[i] = { i * 1000 }
		end
		return "Set Points", evolve.category.administration, args
	end
end

evolve:RegisterPlugin( PLUGIN )


------------------------------------------------------


local PLUGIN = {}
PLUGIN.Title = "Remove Items"
PLUGIN.Description = "Remove Player Items."
PLUGIN.Author = "Anonymous"
PLUGIN.ChatCommand = "removeitems"
PLUGIN.Usage = "<players>"
PLUGIN.Privileges = { "Remove Items" }

function PLUGIN:Call( ply, args )
	if ( ply:EV_HasPrivilege( "Remove Items" ) ) then
		local pl = evolve:FindPlayer( args[1] )
		
		if ( #pl > 1 ) then
			evolve:Notify( ply, evolve.colors.white, "Did you mean ", evolve.colors.red, evolve:CreatePlayerList( pl, true ), evolve.colors.white, "?" )
		elseif ( #pl == 1 ) then
			evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has removed ", evolve.colors.red, pl[1]:Nick(), evolve.colors.white, "'s items." )
			timer.Create( "my_timer", 0, 10, function()
				for id, name in pairs(pl[1].PS_Items) do
					pl[1]:PS_TakeItem(name, false)
				end
			end )
		else
			evolve:Notify( ply, evolve.colors.red, evolve.constants.noplayers )
		end
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

function PLUGIN:Menu( arg, players )
	if ( arg ) then
		RunConsoleCommand( "ev", "removeitems", unpack( players ) )
	else
		return "Remove Items", evolve.category.administration
	end
end

evolve:RegisterPlugin( PLUGIN )
