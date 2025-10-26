local PLUGIN = {}
PLUGIN.Title = "Vote Kick"
PLUGIN.Description = "Starts a vote for kicking a player."
PLUGIN.Author = "Anonymous"
PLUGIN.ChatCommand = "votekick"
PLUGIN.Usage = "[players]"
PLUGIN.Privileges = { "Vote Kick" }


function PLUGIN:Call( ply, args )
  if #player.GetAll() < 4 then
	  evolve:Notify( ply, evolve.colors.red, "You can only do votes with atleast 4 people." )
   else
   if ( ply:EV_HasPrivilege( "Vote Kick" ) ) then
		local pl = evolve:FindPlayer( args[1] )
		if ( #pl > 1 ) then
			evolve:Notify( ply, evolve.colors.white, "Did you mean ", evolve.colors.red, evolve:CreatePlayerList( pl, true ), evolve.colors.white, "?" )
		elseif ( #pl == 1 ) then
			if ply:EV_BetterThan( pl[1] ) then
				playerToKick = pl[1]
				voteCallback = kickPlayer
				setupVote( ply, "Kick " .. pl[1]:Nick() .. "?", 20 )
			else
				evolve:Notify( ply, evolve.colors.red, evolve.constants.noplayers2 )
			end
		end
   else
      evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
   end
   end
end
 
function PLUGIN:Menu( arg, players )
	if ( arg ) then
		RunConsoleCommand( "ev", "votekick",  players[1] )
	else
		return "Vote Kick", evolve.category.administration
	end
end

evolve:RegisterPlugin( PLUGIN )