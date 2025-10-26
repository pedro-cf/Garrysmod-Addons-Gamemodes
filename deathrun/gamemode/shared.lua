GM.Name 	= "Deathrun"
GM.Author 	= "Anonymous"
GM.Email 	= ""
GM.Website 	= "www.ldt-clan.com"
GM.Help		= [[The goal for a Runner is to avoid all the traps set off by the Death and eventually reaching the end to obtain a weapon and eliminate all the Deaths.
Death's main goal is to kill all Runners by setting off a series of traps. If the Runners get to the end then the deaths may be killed.]]

GM.TeamBased = true
GM.SelectClass = true
GM.ForceJoinBalancedTeams = false

GM.RoundBased = true
GM.RoundLength = 60*5
GM.RoundPreStartTime = 4
GM.RoundPostLength = 8
GM.RoundEndsWhenOneTeamAlive = true

GM.RealisticFallDamage = true
GM.NoAutomaticSpawning = true
GM.DeathLingerTime = 2

GM.SelectModel = false
GM.AllowSpectating = true
GM.CanOnlySpectateOwnTeam = false
GM.ValidSpectatorModes = { OBS_MODE_CHASE, OBS_MODE_ROAMING }

DeriveGamemode( "fretta" )
IncludePlayerClasses()

GM.RoundLimit = 13
GM.GameLength = 40

TEAM_RUN = 1
TEAM_DEATH = 2

GIB_MODELS = {
	"models/Gibs/HGIBS.mdl",
	"models/Gibs/HGIBS_rib.mdl",
	"models/Gibs/HGIBS_rib.mdl",
	"models/Gibs/HGIBS_scapula.mdl",
	"models/Gibs/HGIBS_spine.mdl",
	"models/gibs/antlion_gib_small_3.mdl"
};

function GM:CreateTeams()
 
	if ( !GAMEMODE.TeamBased ) then return end
 
	team.SetUp( TEAM_RUN, "Runners", Color( 20, 20, 200 ), true )
	team.SetSpawnPoint( TEAM_RUN, "info_player_counterterrorist" )
	team.SetClass( TEAM_RUN, { "Runner" } )
 
	team.SetUp( TEAM_DEATH, "Death", Color( 200, 20, 20 ), false )
	team.SetSpawnPoint( TEAM_DEATH, "info_player_terrorist" ) 
	team.SetClass( TEAM_DEATH, { "Death" } )
	
end

hook.Add( "PlayerInitialSpawn", "GibFirstSpawnStuff", function( ply )
	ply.SpawnRemoveEnts = { }
end )