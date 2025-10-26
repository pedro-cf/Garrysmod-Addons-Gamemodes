/*-------------------------------------------------------------------------------------------------------------------------
	Slap a player
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Slap"
PLUGIN.Description = "Slap a player."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "slap"
PLUGIN.Usage = "[players] [damage]"
PLUGIN.Privileges = { "Slap" }

--IMPROVED

function PLUGIN:Call( ply, args )
	if ( ply:EV_HasPrivilege( "Slap" ) ) then
		local players = evolve:FindPlayer( args, ply, true )
		local dmg = math.abs( tonumber( args[ #args ] ) or 10 )
		
		for _, pl in ipairs( players ) do
			local after = pl:Health() - dmg
			pl:SetHealth(after)
			pl:EmitSound("ambient/voices/citizen_punches2.wav")
			if math.random() > 0.5 then
				pl:ViewPunch( Angle( 0, -60, 0 ) )
				pl:SetVelocity( Vector( 0, 300, 300) )
			else
				pl:ViewPunch( Angle( -60, 0, 0 ) )
				pl:SetVelocity( Vector( 300, 0, 300) )
			end
			
			if ( pl:Health() < 1 ) then pl:Kill() end
		end
		
		if ( #players > 0 ) then
			evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has slapped ", evolve.colors.red, evolve:CreatePlayerList( players ), evolve.colors.white, " with " .. dmg .. " damage." )
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
		RunConsoleCommand( "ev", "slap", unpack( players ) )
	else
		args = {}
		for i = 1, 10 do
			args[i] = { i * 10 }
		end
		return "Slap", evolve.category.punishment, args
	end
end

evolve:RegisterPlugin( PLUGIN )