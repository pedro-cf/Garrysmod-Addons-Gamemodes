-- Quake Sounds v4.0

print("KQS will only work properly next round.")
for _, p in pairs(player.GetAll()) do
	p:ChatPrint("KQS will only work properly next round.")
end

function _R.Player:QuakeSound( message, sound, color )

	umsg.Start( "QuakeSound", self )
		if message then umsg.String( message ) end
		if sound then umsg.String( sound ) end
		if color then umsg.String( color ) end
	umsg.End()
	
end

local KillStreaks = {
        false, -- No message for 1 kill.
		false, -- No message for 2 kills.
        { "%s is on a killing spree!", "quake/kkKilling_Spree.mp3" },
        { "%s is dominating!", "quake/kkDominating.mp3" },
        { "%s is unstoppable!", "quake/kkUnstoppable.mp3" },
		{ "%s is wicked sick!", "quake/kkWhickedSick.mp3" },
		{ "%s is GOD LIKE!", "quake/kkGodLike.mp3" },
        { "%s is beyond GOD LIKE! Someone kill him!", "quake/kkholyshit.mp3" }
}

local QuickKills = {
        false, -- No message for 1 kill.
        { "%s just got a double kill!", "quake/kkdoublekill.mp3" },
        { "%s just got a triple kill!", "quake/kktriplekill.mp3" },
		{ "%s just got a mega kill!", "quake/kkmegakill.mp3" },
        { "%s just got a monster kill!", "quake/kkmonsterkill.mp3" },
		{ "%s just got an ultra kill!", "quake/kkultrakill.mp3" },
		{ "%s is on a RAMPAGE!", "quake/kkRampage.mp3" }
}

local RoundStartSounds =  {
	"quake/kkldtleeroy.mp3",
	"quake/kkldtcod.mp3",
	"quake/kkldtshowv3.mp3",
	"quake/kkdthenlets.mp3",
	"quake/kkragdoll.mp3"
}
 
Roundstartedttt = 0

hook.Add( "TTTBeginRound", "TTT_quake_beginround", function()

	for _, pla in pairs( player.GetAll() ) do
		pla.KillCounter = 0
		pla.nodomination = 0
		pla.QuickKillCounter = 0
		pla.MaxKills = 0
	end
	Roundstartedttt = 1

	for _, v in pairs( player.GetAll() ) do
		v:QuakeSound( "", RoundStartSounds[math.random( 1, #RoundStartSounds)], "" )
	end
	
	FailTimer = CurTime()	

end )

local function tablestring( table, separator )
	local Tstring = ""
	for _,v in pairs(table) do
		if Tstring == "" then
			Tstring = v
		else
			Tstring = Tstring .. separator .. v
		end
	end
	return Tstring
end

hook.Add( "TTTEndRound", "TTT_quake_endround", function( type )

	Roundstartedttt = 0
	local Dominator = nil
	local LastDKills = 0
	local BestKills = 0
	
	--get the best scores
	for _, v in pairs( player.GetAll() ) do
		if !Dominator then
			Dominator = v
			LastDKills = v.KillCounter
		end
		
		if v.KillCounter > LastDKills then
			Dominator = v
			LastDKills = v.KillCounter
		end
		
		if !BestKills then
			BestKills = v.MaxKills
		end
		
		if v.MaxKills > BestKills then
			BestKills = v.MaxKills
		end
	end
	
	local BestKillers = nil
	local BestKillers = {}
	
	local Checkequalmax = 0
	for _, d in pairs( player.GetAll() ) do
		if d.KillCounter == LastDKills then
			Checkequalmax = Checkequalmax +1
		end
		if d.MaxKills == BestKills and d.MaxKills >= 3 then
			BestKillers[d:EntIndex()] = d:GetName()
		end
	end
	
	
	--do the domination if all terms comply
	--Atleast 10 Kills
	--Only 1 guy with the "max" number of kills ( no dominating if some1 has the same kills as u)
	--Also If you were combo broken u won't get a domination 
	if (LastDKills > 9) and (Checkequalmax < 2) and (Dominator.nodomination == 0) then
		for _, p in pairs( player.GetAll() ) do
			timer.Simple( 1, function()
				p:QuakeSound( Dominator:GetName().. " IS ON A BLOODBATH!!!", "quake/kkbloodbath.mp3", "teal" )
			end )
		end
	elseif table.Count(BestKillers) > 0 then
		if table.Count(BestKillers) == 1 then
			local solokstring = tablestring( BestKillers, "" ).. " was " ..string.gsub( string.Right(KillStreaks[BestKills][1], string.len(KillStreaks[BestKills][1]) - 6), "!", " this round!")
			for _, p in pairs( player.GetAll() ) do
				timer.Simple( 1, function()
					p:QuakeSound( solokstring, "bestkills", "teal" )
				end )
			end
		elseif table.Count(BestKillers) > 1 then
			local multikstring = tablestring( BestKillers, ", " ).. " were " ..string.gsub( string.Right(KillStreaks[BestKills][1], string.len(KillStreaks[BestKills][1]) - 6), "!", " this round!")
			for _, p in pairs( player.GetAll() ) do
				timer.Simple( 1, function()
					p:QuakeSound( multikstring, "bestkills", "teal" )
				end )
			end
		end
	end

	local currenttime = CurTime()
	if (( type == WIN_INNOCENT ) and ( currenttime < FailTimer + 30 )) or ( type == WIN_TIMELIMIT )  then 
		for _, m in pairs( player.GetAll() ) do
			m:QuakeSound( "THE TRAITORS HAVE FAILED BADLY!", "quake/kkfail.mp3", "red" )
		end
	end
end )
 
hook.Add( "PlayerDisconnected", "PlDisc", function( pl )
	if( CurTime() < pl.LastDeath + 10 ) then
		for _, v in pairs( player.GetAll() ) do
			if v:IsSpec() then
				v:QuakeSound( string.format( "%s just rage quitted!", pl:GetName() ), "quake/kkragequit.mp3" , "red" )
			end
		end
	end
end )
 
 
hook.Add( "PlayerInitialSpawn", "PlInitSp", function( pl )

	timer.Simple( 10, function()
		pl:QuakeSound( "info", "", "green" )
	end )
	pl.KillCounter = 0
    pl.LastDeath = CurTime()-15
	pl.nodomination = 0
	pl.QuickKillCounter = 0
	pl.MaxKills = 0
	
end )
 
hook.Add( "PlayerDeath", "PlDeath", function( Victim, Weapon, Killer )

	if ( Roundstartedttt == 1 ) then
		if !WasRoles then
			WasRoles = {}
		end
		WasRoles[ Victim:EntIndex() ] = Victim:GetRoleString()
		
		--- MISSING INSTRUCTIONS ON DEATH WITH KQS OFF
		Victim:QuakeSound( "info", "", "" )
		
		if  ( Victim.KillCounter > 4 ) then
			Victim.nodomination = 1
			for _, v in pairs(player.GetAll()) do
				if v:IsSpec() or ( v == Victim ) then
					if Killer:IsPlayer() then
						v:QuakeSound( Killer:GetName().. " just ended " ..Victim:GetName().. "'s Kill Streak!", "quake/kkcombobreaker.mp3", "red" )
					else
						v:QuakeSound( Victim:GetName().. "'s Kill Streak has ended!", "quake/kkcombobreaker.mp3", "red" )
					end
				end
			end
		end
		
		Victim.KillCounter = 0
		Victim.QuickKillCounter = 0
		Victim.LastDeath = CurTime()

		if ( ( Killer:GetClass() == "worldspawn" ) or ( Killer:GetClass() == "prop_physics" ) ) and Victim:IsPlayer() then
			Killer.KillCounter = 0
				for _, v in pairs(player.GetAll()) do
					if v:IsSpec() or ( v == Victim ) then
						v:QuakeSound( Victim:GetName().. " just suffered a humiliation!", "quake/kkhumiliation.mp3", "red" )
					end
				end  
				
		elseif Killer:IsPlayer() then
		
			if ( ( Killer:IsActiveTraitor() and Victim:IsActiveTraitor() ) or ( !Killer:IsActiveTraitor() and !Victim:IsActiveTraitor() and !Killer:IsSpec() ) or ( Killer:IsSpec() and ( (WasRoles[ Killer:EntIndex() ] == "traitor" and Victim:IsActiveTraitor()) or (WasRoles[ Killer:EntIndex() ] != "traitor" and !Victim:IsActiveTraitor()) ) ) ) and ( Victim ~= Killer ) and ( Weapon:GetClass() ~= "npc_turret_floor" ) then
				for _, v in pairs(player.GetAll()) do
					if v:IsSpec() or ( v == Victim ) or ( v == Killer and v:IsActiveTraitor() ) then
						v:QuakeSound( Killer:GetName().. " just team killed " ..Victim:GetName().. ".", "quake/kkteamkiller.mp3", "white" )
					end
				end
				return
			end

			if !Killer.KillCounter then
				Killer.KillCounter = 0
			end
			
			if !Killer.QuickKillCounter then
				Killer.QuickKillCounter = 0
			end
			
			if timer.IsTimer( Killer:EntIndex() ) then
				timer.Stop( Killer:EntIndex() )
				timer.Destroy( Killer:EntIndex() )
			end
			
			if ( Victim ~= Killer ) and Killer:IsPlayer() and ( ( Killer:IsActiveTraitor() and !Victim:IsActiveTraitor() ) or ( Killer:IsSpec() and ( (WasRoles[ Killer:EntIndex() ] == "traitor" and !Victim:IsActiveTraitor()) or (WasRoles[ Killer:EntIndex() ] != "traitor" and Victim:IsActiveTraitor()) ) ) or ( !Killer:IsActiveTraitor() and Victim:IsActiveTraitor() ) ) or ( Weapon:GetClass() == "npc_turret_floor" ) then
				Killer.KillCounter = Killer.KillCounter + 1
				Killer.QuickKillCounter = Killer.QuickKillCounter + 1
				timer.Create( Killer:EntIndex(), 10, 1, function()
					Killer.QuickKillCounter = 0
				end )
				Killer.MaxKills = Killer.MaxKills + 1
			end
		   
			if ( Weapon:GetClass() == "weapon_zm_improvised" ) and ( Victim:IsPlayer() )  then
				for _, v in pairs(player.GetAll()) do
					if v:IsSpec() or ( v == Victim ) or ( v == Killer and v:IsActiveTraitor() ) then
						v:QuakeSound( Victim:GetName().. " just suffered a humiliation!", "quake/kkhumiliation.mp3", "red" )
					end
				end
			end
				   
			if( Killer.KillCounter > 2 ) then
				local Index = Killer.KillCounter < 9 && Killer.KillCounter || 8
				for k, v in pairs( player.GetAll() ) do
					if v:IsSpec() or ( v == Victim ) or ( v == Killer and v:IsActiveTraitor() ) then
						v:QuakeSound( string.format( KillStreaks[Index][1], Killer:GetName() ), KillStreaks[Index][2], "red" )
					end
				end
			end
			
			if( Killer.QuickKillCounter > 1 ) then
				local Indexx = Killer.QuickKillCounter < 8 && Killer.QuickKillCounter || 7
				for k, v in pairs( player.GetAll() ) do
					if v:IsSpec() or ( v == Victim ) or ( v == Killer and v:IsActiveTraitor() ) then
						timer.Simple( 1, function()
							v:QuakeSound( string.format( QuickKills[Indexx][1], Killer:GetName() ), QuickKills[Indexx][2], "green" )
						end)
					end
				end
			end
			
		end
			
	end

end )

hook.Add( "PlayerSay", "EnableKQSChat", function(ply, text, team)
	if !IsValid( ply ) then return end
	if string.lower(text) == "!kqs" or string.lower(text) == "!quake" then
		ply:ConCommand( "Enable_KQS" )
		return ""
	end
end )