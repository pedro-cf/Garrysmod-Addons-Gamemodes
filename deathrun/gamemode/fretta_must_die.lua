function GM:StartFrettaVote()
	  GAMEMODE.WinningGamemode = "deathrun"

      SetGlobalBool("InGamemodeVote", true)
      GAMEMODE.m_bVotingStarted = true

      GAMEMODE:ClearPlayerWants()
      
      GAMEMODE:StartMapVote()
	  PrintMessage( HUD_PRINTTALK, "Starting map vote..." )
end

GM.StartGamemodeVote = GM.StartFrettaVote

function GM:VoteForChange( ply )
   if GetConVarNumber( "fretta_voting" ) == 0 then return end
   if ply:GetNWBool( "WantsVote" ) then return end
   if GAMEMODE:InGamemodeVote() then return end   

   ply:SetNWBool( "WantsVote", true )
   
   local VotesNeeded = GAMEMODE:GetVotesNeededForChange()
   local NeedTxt = ""
   if VotesNeeded > 0 and CurTime() < GetConVarNumber("fretta_votegraceperiod") then
      NeedTxt = " (need "..VotesNeeded.." more)"
   end

   local votetype = "map"
   evolve:Notify( Color(255, 165, 0), ply:Nick().. " has voted to change the " ..votetype.. ". " ..NeedTxt )
   
   MsgN( ply:Nick() .. " voted to change the " .. votetype )
   
   timer.Simple( 2, function() GAMEMODE:CountVotesForChange() end )

end

function GM:EndOfGame( bGamemodeVote )

	if GAMEMODE.IsEndOfGame then return end

	GAMEMODE.IsEndOfGame = true
	SetGlobalBool( "IsEndOfGame", true );
	
	GAMEMODE:OnEndOfGame();
	
	if ( bGamemodeVote ) then
	
		timer.Simple( GAMEMODE.VotingDelay, function() GAMEMODE:StartGamemodeVote() end )
		
	end

end

function GM:OnPlayerChangedTeam( ply, oldteam, newteam )

	// Here's an immediate respawn thing by default. If you want to 
	// re-create something more like CS or some shit you could probably
	// change to a spectator or something while dead.
	if ( newteam == TEAM_SPECTATOR ) then
	
		// If we changed to spectator mode, respawn where we are
		local Pos = ply:EyePos()
		ply:SetPos( Pos )
		
	else
	
		// If we're straight up changing teams just hang
		//  around until we're ready to respawn onto the 
		//  team that we chose
		
	end
	
	//PrintMessage( HUD_PRINTTALK, Format( "%s joined '%s'", ply:Nick(), team.GetName( newteam ) ) )
	
	// Send umsg for team change
    local rf = RecipientFilter();
    rf:AddAllPlayers();
 
    umsg.Start( "fretta_teamchange", rf );
		umsg.Entity( ply );
		umsg.Short( oldteam );
		umsg.Short( newteam );
    umsg.End();
	
end

function GM:CanPlayerSuicide( ply )

	if ply:Team() != 1 then 
		return false
	end

	return !GAMEMODE.NoPlayerSuicide
	
end 

function GM:ShowHelp( pl )
end

local function FillClips( ply, wep )
	if wep:Clip1() < 255 then wep:SetClip1( 250 ) end
	if wep:Clip2() < 255 then wep:SetClip2( 250 ) end
	
	if wep:GetPrimaryAmmoType() == 10 or wep:GetPrimaryAmmoType() == 8 then
		ply:GiveAmmo( 9 - ply:GetAmmoCount( wep:GetPrimaryAmmoType() ), wep:GetPrimaryAmmoType() )
	elseif wep:GetSecondaryAmmoType() == 9 or wep:GetSecondaryAmmoType() == 2 then
		ply:GiveAmmo( 9 - ply:GetAmmoCount( wep:GetSecondaryAmmoType() ), wep:GetSecondaryAmmoType() )
	end
end

hook.Add( "Tick", "InfiniteAmmo", function()
	for _, ply in ipairs( player.GetAll() ) do
		if ply:Alive() and 
		ply:GetActiveWeapon() != NULL and
		ply:GetActiveWeapon():GetClass() != "weapon_stunstick" and
		ply:GetActiveWeapon():GetClass() != "weapon_crowbar" and
		ply:GetActiveWeapon():GetClass() != "lightsaber" and
		ply:GetActiveWeapon():GetClass() != "weapon_katana" and
		ply:GetActiveWeapon():GetClass() != "weapon_real_cs_knife" and
		ply:GetActiveWeapon():GetClass() != "weapon_sythe" then
			FillClips( ply, ply:GetActiveWeapon() )
		end
	end
end )

hook.Add( "PlayerInitialSpawn", "ForceJoinTeam", function( ply )
	timer.Simple(0.1, function()
		ply:KillSilent()
		ply:SetTeam( TEAM_SPECTATOR )
	end )
end )

hook.Add( "PlayerSay", "ChatVotemap", function(  ply, text, team )
	if string.lower(text) == "!rtv" or string.lower(text) == "!votemap" then
		ServerLog("Attempting to send the Lua!")
		if !ply:GetNWBool( "WantsVote" ) then
			ServerLog("SendingLua!")
			ply:SendLua( "LocalPlayer():ConCommand(\"VoteForChange\")" )
			ServerLog("Lua Sent!")
		end
	end
end )

