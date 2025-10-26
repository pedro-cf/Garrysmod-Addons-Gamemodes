DrunMapsWithoutCrowbars = {
	"deathrun_warehouse_final"
}

DrunDieSounds = {
	"vo/npc/Barney/ba_ohshit03.wav",
	"vo/npc/Barney/ba_no01.wav",
	"vo/npc/Barney/ba_no02.wav",
	"vo/npc/male01/no01.wav",
	"vo/npc/male01/no02.wav",
	"vo/npc/male01/pain07.wav",
	"vo/npc/male01/pain08.wav",
	"vo/npc/male01/pain09.wav",
	"vo/npc/male01/pain04.wav"
}

DrunSawDieSounds = {
	"vo/npc/male01/gordead_ques01.wav",
	"vo/npc/male01/gordead_ques02.wav",
	"vo/npc/male01/gordead_ques06.wav",
	"vo/npc/male01/gordead_ques07.wav",
	"vo/npc/male01/gordead_ques11.wav",
	"vo/npc/Barney/ba_danger02.wav",
	"vo/npc/Barney/ba_damnit.wav"
}

AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_fretta_must_die.lua" )
AddCSLuaFile( "cl_gib.lua" )
AddCSLuaFile( "cl_health.lua" )

include( 'shared.lua' )
include( 'fretta_must_die.lua' )
include( 'gib.lua' )

resource.AddFile("models/player/death.mdl")
resource.AddFile("models/weapons/v_sythe.mdl")
resource.AddFile("models/weapons/w_sythe.mdl")
resource.AddFile("materials/models/grim/grim_normal.vtf")
resource.AddFile("materials/models/grim/grimbody.vmt")
resource.AddFile("materials/models/grim/mouth.vmt")
resource.AddFile("materials/models/grim/mouth_normal.vtf")
resource.AddFile("materials/models/grim/skelface.vmt")
resource.AddFile("materials/models/grim/skelface_normal.vtf")
resource.AddFile("materials/models/grim/skelface2.vmt")
resource.AddFile("materials/models/grim/skelface2_normal.vtf")
resource.AddFile("materials/models/grim/stimer.vmt")
resource.AddFile("materials/models/grim/sythe.vmt")
resource.AddFile("materials/models/grim/sythe_mask.vtf")
resource.AddFile("materials/models/weapons/v_models/sythe/stimer.vmt")
resource.AddFile("materials/models/weapons/v_models/sythe/sythe.vmt")
resource.AddFile("materials/models/weapons/v_models/sythe/sythe_mask.vtf")
--Quake
resource.AddFile("sound/quake/kkragequit.mp3")
resource.AddFile("sound/quake/kkldtcod.mp3")
resource.AddFile("sound/quake/kkldtleeroy.mp3")
resource.AddFile("sound/quake/kkldtshowv3.mp3")
resource.AddFile("sound/quake/kkfirstblood.mp3")
--Extra Gui
resource.AddFile("materials/gui/spacebar.vmt")


local file_path = "deathrun_weapon_spawns/"..game.GetMap()..".txt"
local file_contents = ""
local SpawnersPos = {}

SetGlobalBool( "DelayFirstRound", true )
timer.Simple( 40, function()
	SetGlobalBool( "DelayFirstRound", false )
end )


if file.Exists(file_path) then
	file_contents = file.Read(file_path)
	for x, y, z in string.gmatch(file_contents, "(%-?[%d%.]+), (%-?[%d%.]+), (%-?[%d%.]+)\n") do
		table.insert(SpawnersPos, {x = tonumber(x), y = tonumber(y), z = tonumber(z)})
	end
end

function GM:CanStartRound()
	if ( #team.GetPlayers( TEAM_RUN ) + #team.GetPlayers( TEAM_DEATH ) >= 2 ) and !GetGlobalBool( "DelayFirstRound" ) then return true end
	return false
end

function GM:OnPreRoundStart( num )
	game.CleanUpMap()
	
	for _,pos in ipairs(SpawnersPos) do
		local spawner = ents.Create("weapon_spawner")
		spawner:SetPos(Vector(pos.x, pos.y, pos.z))
		spawner:Spawn()
	end

	
	local OldRun = team.GetPlayers( TEAM_RUN )
	local OldDeath = team.GetPlayers( TEAM_DEATH )
	local NrActivePlayers = #OldRun + #OldDeath
	
	if NrActivePlayers >= 2 then
		
		local NrDeath = math.ceil( NrActivePlayers/10 )
	
		for _,pl in pairs ( OldDeath ) do
			pl:SetTeam( TEAM_RUN )
		end
		
		local count=0
		
		for _, pl in RandomPairs( OldRun ) do
			if count < NrDeath then
				pl:SetTeam( TEAM_DEATH )
				count=count+1
			end
		end
		
		for _, pl in RandomPairs( OldDeath ) do
			if count < NrDeath then
				pl:SetTeam( TEAM_DEATH )
				count=count+1
			end
		end
		
	end
	
	UTIL_SpawnAllPlayers()
	UTIL_FreezeAllPlayers()
end

local RoundDeaths = 1
function GM:OnRoundStart( num )

	UTIL_UnFreezeAllPlayers()
	
	RoundDeaths = 0
	
	--AFK SLAY
	local CurRound = GetGlobalInt( "RoundNumber" )
	timer.Simple( 40, function(OldCurRound)
		for k,v in pairs(player.GetAll()) do
			if v:IsAFK( 35 ) and v:Alive() and OldCurRound == GetGlobalInt( "RoundNumber" ) then
				v:KillSilent()
				v:SetTeam( TEAM_SPECTATOR )
				if v.Trail then
					SafeRemoveEntity(v.Trail)
				end
				evolve:Notify( evolve.colors.red, v:Nick(), evolve.colors.white, " is AFK and got moved to Spectators."  )
			end
		end
	end, CurRound)
	
	--LDT SOUNDS
	local rnd = math.random(10)
	for _, v in pairs( player.GetAll() ) do
		if ( rnd >= 1 ) and ( rnd < 4 ) then
			v:SendLua( "surface.PlaySound( Sound( \"quake/kkldtleeroy.mp3\" ) )" )
		elseif ( rnd >= 4 ) and ( rnd < 8 ) then
			v:SendLua( "surface.PlaySound( Sound( \"quake/kkldtcod.mp3\" ) )" )
		elseif ( rnd >= 8 ) and ( rnd <= 10 ) then
			v:SendLua( "surface.PlaySound( Sound( \"quake/kkldtshowv3.mp3\" ) )" )
		end
	end

end

function GM:ProcessResultText( result, resulttext )
	if ( resulttext == nil ) then resulttext = "" end
	
	if ( result == TEAM_RUN ) then
		resulttext = "The Runners prevailed!"
	elseif ( result == TEAM_DEATH ) then
		resulttext = "Death has triumphed!"
	end
	
	return resulttext
end

function GM:OnRoundResult( result, resulttext )
	self.BaseClass:OnRoundResult( result, resulttext )
	
	if result == TEAM_RUN then
		for _,ply in pairs(team.GetPlayers(1)) do
			if !ply:IsAFK(100) then
				ply:PS_GivePoints(30, "received for winning!")
			end
		end
		umsg.Start("Deathrun - Runners Win", ply)
		umsg.End()
	elseif result == TEAM_DEATH then
		for _,ply in pairs(team.GetPlayers(2)) do
			if !ply:IsAFK(100) then
				ply:PS_GivePoints(10, "received for winning!")
			end
		end
		umsg.Start("Deathrun - Death Wins", ply)
		umsg.End()
	end
end

function GM:PlayerUse( pl, ent )
	if pl:Alive() and ( pl:Team() == TEAM_DEATH or pl:Team() == TEAM_RUN )then
		return true
	else
		return false
	end
end

function GM:GetFallDamage( ply, flFallSpeed )
	if ( GAMEMODE.RealisticFallDamage ) then
		return flFallSpeed / 9
	end
	
	return 10
end

function GM:PlayerDeathSound()
	return true
end

function GM:DoPlayerDeath( ply, attacker, dmginfo )
	
	ply:CallClassFunction( "OnDeath", attacker, dmginfo )

	if ply:Team() == TEAM_RUN then
		ply:EmitSound( DrunDieSounds[math.random(1, #DrunDieSounds)] )
	elseif ply:Team() == TEAM_DEATH then
		ply:EmitSound( DrunDieSounds[math.random(1, #DrunDieSounds)], 90, 80 )
	end
	
end

local LastSawDie_Run = 0
local LastSawDie_Death = 0

function GM:PlayerDeath( ply, inflictor, attacker )
	self.BaseClass:PlayerDeath( ply, inflictor, attacker )
	
	local nearby_ents = ents.FindInSphere( ply:GetPos(), 750 )
		
	for _,ent in RandomPairs(nearby_ents) do
		if ent:IsValid() and ent:IsPlayer() and ent:Alive() and ent:Team() == ply:Team() and ent!=ply then
			if ent:Team() == TEAM_RUN then
				if LastSawDie_Run + 5 <= CurTime() then
					ent:EmitSound( DrunSawDieSounds[math.random(1, #DrunSawDieSounds)] )
					LastSawDie_Run = CurTime()
				end
			elseif ent:Team() == TEAM_DEATH then
				if LastSawDie_Death + 5 <= CurTime() then
					ent:EmitSound( DrunSawDieSounds[math.random(1, #DrunSawDieSounds)], 90, 80 )
					LastSawDie_Death = CurTime()
				end
			end
			break
		end
	end
end

concommand.Add("deathrun_weapon_spawner", function(ply)
	if not ply:IsValid() then return end
	if not ply:IsSuperAdmin() then return end
	local pos = ply:GetEyeTrace().HitPos
	
	local spawner = ents.Create("weapon_spawner")
	spawner:SetPos(pos)
	spawner:Spawn()
	
	table.insert(SpawnersPos, {x = pos.x, y = pos.y, z = pos.z})
	file_contents = file_contents..pos.x..", "..pos.y..", "..pos.z.."\n"
	file.Write(file_path, file_contents)
end)

hook.Add( "PlayerInitialSpawn", "RageQuitSpawn", function( ply )
	ply.LastDeath = CurTime() - 7
	if GetGlobalBool( "DelayFirstRound" ) then
		evolve:Notify( ply,  evolve.colors.white, "The ",  evolve.colors.blue, "Round " ,  evolve.colors.white, "will start shortly." )
	end
end )

hook.Add( "PlayerDeath", "RageQuitDie", function( victim, weapon, killer )
	victim.LastDeath = CurTime()
	
	if !victim:IsAFK(20) and RoundDeaths == 0  and GetGlobalInt( "RoundNumber" ) > 0 and GetGlobalBool( "InRound" ) then
		evolve:Notify( evolve.colors.red, victim:Nick(), evolve.colors.white, " was the first to ",  evolve.colors.red, "Fail", evolve.colors.white, "."  )
		for _, v in pairs( player.GetAll() ) do
			v:SendLua( "surface.PlaySound( Sound( \"quake/kkfirstblood.mp3\" ) )" )
		end
		RoundDeaths = RoundDeaths +1
	end
end )

hook.Add( "PlayerDisconnected", "RageQuitDC", function( pl )
        if( CurTime() < pl.LastDeath + 7 ) then
				evolve:Notify( evolve.colors.red, pl:Nick(), evolve.colors.white, " just ",  evolve.colors.red, "RAGE QUIT", evolve.colors.white, "!"  )
                for _, v in pairs( player.GetAll() ) do
					v:SendLua( "surface.PlaySound( Sound( \"quake/kkragequit.mp3\" ) )" )
                end
        end
end )