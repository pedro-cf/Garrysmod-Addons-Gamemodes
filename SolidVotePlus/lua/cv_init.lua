/*-------------------------------------------------------------------------------------------------------------------------
	Serverside main script
-------------------------------------------------------------------------------------------------------------------------*/

// Info
local NumOfPlayers = 0
local voteQuestion = ""
local voteEnd = 0
local lastVote = -1000
local voteStarter = nil
voteCallback = function(voteRes)
end

// Vote running?
local function isVoteRunning()
	return voteEnd > CurTime()
end

// Count votes
local function votesYes( )
	local c = 0
	for _, v in pairs(player.GetAll()) do
		if v:GetNWBool( "cv_Voted", false ) and v:GetNWBool( "cv_Vote", false ) then
			c = c + 1
		end
	end
	return c
end

local function votesNo( )
	local c = 0
	for _, v in pairs(player.GetAll()) do
		if v:GetNWBool( "cv_Voted", false ) and !v:GetNWBool( "cv_Vote", false ) then
			c = c + 1
		end
	end
	return c
end

// Useful functions
local function findPlayer( nick )
	for _, v in pairs(player.GetAll()) do
		if string.find( string.lower(v:Nick()), string.lower(nick) ) or string.lower(v:Nick()) == string.lower(nick) then
			return v
		end
	end
end

local function PrintAll( msg )
	for _, v in pairs(player.GetAll()) do
		v:ChatPrint( "[SolidVote] " .. msg )
	end
end

/*-------------------------------------------------------------------------------------------------------------------------
	This handles the results of the vote
-------------------------------------------------------------------------------------------------------------------------*/

local function resetVoteVars( )
	for _, v in pairs(player.GetAll()) do
		v:SetNWBool( "cv_Voted", false )
	end
end

local function voteFinish( )
	// End the vote completely
	voteEnd = 0
	timer.Remove( "tmVoteEnd" )
	
	// Handle off the result
	local mes, time = voteCallback( (votesYes() > votesNo()*1.1) )
	if !mes then mes = "Yes votes must exceed No votes." end
	if !time then time = 5 end
	
	if ( votesYes() > votesNo()*1.1 ) then
		for _, v in pairs(player.GetAll()) do
			v:SendLua( "surface.PlaySound( Sound( \"ui/menu_enter05.mp3\" ) )" )
		end
	else
		for _, v in pairs(player.GetAll()) do
			v:SendLua( "surface.PlaySound( Sound( \"ui/beep_error01.mp3\" ) )" )
		end
	end
	// Notify players
	local rp = RecipientFilter()
	rp:AddAllPlayers()
	umsg.Start( "cv_FinishVote", rp )
		umsg.Long( time )
		umsg.String( mes )
		umsg.Bool( (votesYes() > votesNo()*1.1) )
	umsg.End()
	
	// Reset variables
	resetVoteVars()
end

/*-------------------------------------------------------------------------------------------------------------------------
	Handle votes
-------------------------------------------------------------------------------------------------------------------------*/

local function playerVote( ply, com, args )
	if isVoteRunning() and !ply:GetNWBool( "cv_Voted", false ) and tonumber(args[1]) then
		local vote = tonumber(args[1])
		
		ply:SetNWBool( "cv_Vote", vote > 0 )
		ply:SetNWBool( "cv_Voted", true )
		Msg( ply:Nick() .. " voted " .. tostring(vote > 0) .. "!\n" )
		
		for _, pl in pairs(player.GetAll()) do
			umsg.Start( "NumOfYes", pl)
				umsg.Short( votesYes() )
			umsg.End()

			umsg.Start( "NumOfNo", pl)
				umsg.Short( votesNo() )
			umsg.End()
		end
		
		// If everyone voted, we can finish the vote
		if (votesYes() + votesNo() == NumOfPlayers) or (votesYes() > NumOfPlayers*0.6) or (votesNo() >= NumOfPlayers*0.4) then
			timer.Remove( "tmVoteEnd" )
			timer.Create( "tmVoteEnd", 2, 1, voteFinish )
		end
		
		// Play vote sound
		for _, v in pairs(player.GetAll()) do
			v:SendLua( "surface.PlaySound( Sound( \"common/bugreporter_succeeded.wav\" ) )" )
		end
	end
end
concommand.Add( "cv_Vote", playerVote )

/*-------------------------------------------------------------------------------------------------------------------------
	Vote setup function
-------------------------------------------------------------------------------------------------------------------------*/

function setupVote( ply, question, votetime )
	if CurTime() - lastVote < VOTE_DELAY then
		evolve:Notify( ply, evolve.colors.red, "Only one vote can be started every " .. VOTE_DELAY .. " seconds." )
	elseif voteEnd < CurTime() then
		resetVoteVars()
		
		voteStarter = ply
		voteQuestion = question
		voteEnd = CurTime() + votetime
		lastVote = CurTime()
		
		NumOfPlayers = #player.GetAll()
		
		evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has started a vote." )
		
		for _, v in pairs(player.GetAll()) do
			v:SendLua( "surface.PlaySound( Sound( \"ui/beep_synthtone01.mp3\" ) )" )
		end
		
		// Send vote to players
		local rp = RecipientFilter()
		rp:AddAllPlayers()
		
		umsg.Start( "cv_SetupVote", rp )
			umsg.String( voteQuestion )
			umsg.Long( votetime )
			umsg.Short( #player.GetAll() )
			umsg.String( ply:Nick() )
		umsg.End()
		
		// Set a timer to deal with the results when the vote is over
		timer.Create( "tmVoteEnd", votetime, 1, voteFinish )
	else
		evolve:Notify( ply, evolve.colors.red, "There's still a vote running!" )
	end
end

/*-------------------------------------------------------------------------------------------------------------------------
	Vote creation frontend
-------------------------------------------------------------------------------------------------------------------------*/

local function cleanupMap( res )
	if res then
		timer.Simple( 5, function()
			game.CleanUpMap()
		end )
		
		return "Cleaning up the map..."
	end
end

playerToKick = NULL
function kickPlayer( res )
	if res then
		if playerToKick.Nick then
			timer.Simple( 3, function()
				playerToKick:Kick( "Kicked by vote." )
				evolve:Notify( evolve.colors.red, playerToKick:Nick(), evolve.colors.white, " was kicked due to a Vote Kick started by ", evolve.colors.blue, voteStarter:Nick(), evolve.colors.white, "." )
			end )
			
			return "Kicking player " .. playerToKick:Nick() .. "..."
		end
	end
end

playerToBan = NULL
function banPlayer( res )
	if res then
		timer.Simple( 3, function()
			evolve:Ban(playerToBan:UniqueID(), 7200, "Banned by vote.", voteStarter:UniqueID())
			evolve:Notify( evolve.colors.red, playerToBan:Nick(), evolve.colors.white, " was banned for 120 minutes due to a Vote Ban started by ", evolve.colors.blue, voteStarter:Nick(), evolve.colors.white, "." )
		end )
		
		return "Banning player " .. playerToBan:Nick() .. "..."
	end
end

local function switchNoclip( res )
	if res then
		if server_settings.Int( "sbox_noclip", 0 ) > 0 then
			timer.Simple( 5, function()
				RunConsoleCommand( "sbox_noclip", 0 )
				for _, v in pairs(player.GetAll()) do v:SetMoveType( MOVETYPE_WALK ) end
			end )
		else
			timer.Simple( 5, function()
				RunConsoleCommand( "sbox_noclip", 1 )
			end )
		end
		
		return "Switching noclip..."
	end
end

local function switchGodmode( res )
	if res then
		if server_settings.Int( "sbox_godmode", 0 ) > 0 then
			timer.Simple( 5, function()
				RunConsoleCommand( "sbox_godmode", 0 )
			end )
		else
			timer.Simple( 5, function()
				RunConsoleCommand( "sbox_godmode", 1 )
			end )
		end
		
		return "Switching godmode..."
	end
end

local function regVote( res )
	if res then
		return "Yes has won the vote!"
	end
end

/*-------------------------------------------------------------------------------------------------------------------------
	Vote help
-------------------------------------------------------------------------------------------------------------------------*/

if VOTE_AD_ENABLED then
	timer.Create( "tmVoteHelp", VOTE_AD_TIME, 0, function()
		PrintAll( VOTE_AD_MESSAGE )
	end )
end