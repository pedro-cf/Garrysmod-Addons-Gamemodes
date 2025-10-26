/*-------------------------------------------------------------------------------------------------------------------------
	Clientside main script
-------------------------------------------------------------------------------------------------------------------------*/

/*-------------------------------------------------------------------------------------------------------------------------
	Voting window
-------------------------------------------------------------------------------------------------------------------------*/

// Constants
local windowWidth = 320
local windowHeight = 130
local windowLeft = 30
local windowTop = ScrH() / 4 - windowHeight / 2
local reswindowTop = ScrH() / 4 - 50
local windowIndent = 10

// Info
local voteQuestion = ""
local voteQuestionRes = ""
local voteEnd = 0
local voteResEnd = 0
local voteResMessage = ""
local voteResResult = false
local voteNumYes = 0
local voteNumNo = 0
local NumOfPlayers = 0
local voteStarter = ""
local qwidth = 0
local qheight = 0

// Fonts
surface.CreateFont( "Arial", 13, 600, true, false, "Votehelp" )
surface.CreateFont( "Arial", 16, 800, true, false, "Voteby" )
surface.CreateFont( "Arial", 22, 400, true, false, "VoteTitle" )
surface.CreateFont( "Arial", 30, 700, true, false, "VoteResult" )
surface.CreateFont( "Arial", 27, 500, true, false, "VoteQuestion" )
surface.CreateFont( "Arial", 20, 400, true, false, "VoteResultMsg" )

// Vote 'Yes'
local function voteYes( )
	RunConsoleCommand( "cv_Vote", 1 )
end

// Vote 'No'
local function voteNo( )
	RunConsoleCommand( "cv_Vote", 0 )
end

// Vote running?
local function isVoteRunning ()
	return voteEnd > CurTime()
end

// Vote result display?
local function isVoteResultShown( )
	return voteResEnd > CurTime()
end

// Draw voting window
local function drawVoteWindow( )

	if 320 < qwidth then
		windowWidth = qwidth + 50
	else
		windowWidth = 320
	end
	local windowTop = ScrH() / 4 - windowHeight / 2
		
	if isVoteRunning() then
		// Draw background
		draw.RoundedBox( 6, windowLeft, windowTop, windowWidth, windowHeight, Color( 0, 0, 0, 255 ) )
		
		local Count = tostring(math.ceil(voteEnd - CurTime()))
		
		// Voting Title
		draw.SimpleText( "Vote started by " ..voteStarter, "Voteby", windowLeft + windowIndent, windowTop + windowIndent, Color( 129, 129, 129 ) )
		
		// Timer
		draw.SimpleText(Count, "VoteTitle", windowLeft + windowIndent + windowWidth - 45, windowTop + windowIndent, Color( 129, 129, 129 ) )
		
		// Question
		draw.SimpleText( voteQuestion, "VoteQuestion", windowLeft + windowIndent, windowTop + windowIndent + 30, Color( 255, 255, 255 ) )
		
		// Draw vote help
		draw.SimpleText( "Press F7 for YES", "Votehelp", windowLeft + windowIndent, windowTop + windowIndent + 98 , Color( 129, 129, 129 ) )
		draw.SimpleText( "Press F8 for NO", "Votehelp", windowLeft + windowIndent +214, windowTop + windowIndent + 98 , Color( 129, 129, 129 ) )
		
		//Box
		draw.RoundedBox( 0, windowLeft + windowIndent, windowTop + windowIndent + 72.5 , 300, 21, Color( 90, 90, 90, 255 ) )
		surface.SetDrawColor( 150, 150, 150, 255)
		surface.DrawOutlinedRect(windowLeft + windowIndent-1, windowTop + windowIndent + 72 , 302, 23)
		
		//Ratio Vote System
		if voteNumYes != 0 then
			draw.RoundedBox( 0, windowLeft + windowIndent, windowTop + windowIndent + 72.5 , 300*(voteNumYes/(voteNumYes+voteNumNo)), 20.5, Color( 0, 255, 0, 255 ) )
		end
		
		if voteNumNo != 0 then
			draw.RoundedBox( 0, windowLeft + windowIndent+ 300 - (300*(voteNumNo/(voteNumYes+voteNumNo))), windowTop + windowIndent + 72.5 , 300*(voteNumNo/(voteNumYes+voteNumNo)), 20.5, Color( 255, 0, 0, 255 ) )
		end
		
		surface.SetDrawColor( 255, 153, 0, 255)
		surface.DrawRect(windowLeft + windowIndent + 179, windowTop + windowIndent+72.5 , 3,21)
		
	elseif isVoteResultShown() then
		
		// Draw background
		draw.RoundedBox( 6, windowLeft, windowTop, windowWidth, windowHeight, Color( 0, 0, 0, 255 ) )
		
		local Count = tostring(math.ceil(voteEnd - CurTime()))
		
		// Voting Title
		draw.SimpleText( "Vote started by " ..voteStarter, "Voteby", windowLeft + windowIndent, windowTop + windowIndent, Color( 129, 129, 129 ) )
		
		draw.SimpleText( voteQuestionRes, "VoteQuestion", windowLeft + windowIndent, windowTop + windowIndent + 30, Color( 255, 255, 255 ) )
		
		// Question
		if voteResResult then
			draw.SimpleText( "VOTE PASSED", "VoteResult", windowLeft + windowIndent, windowTop + windowIndent + 72.5, Color( 0, 255, 0) )
		else
			draw.SimpleText( "VOTE FAILED", "VoteResult", windowLeft + windowIndent, windowTop + windowIndent + 72.5, Color( 206, 2, 0) )
		end
	end
end
hook.Add( "HUDPaint", "DrawVoteWindow", drawVoteWindow )

/*-------------------------------------------------------------------------------------------------------------------------
	Handle input for voting
-------------------------------------------------------------------------------------------------------------------------*/

local lastPress = 0
local function KeyThink( )
	if CurTime() > lastPress + 1 and isVoteRunning() then
		if input.IsKeyDown( KEY_F7 ) then
			voteYes()
			lastPress = CurTime()
		elseif input.IsKeyDown( KEY_F8 ) then ------- MODIFIED FOR TESTING. REPLACE WITH KEY_F8 IN THE END
			voteNo()
			lastPress = CurTime()
		end
	end
end
hook.Add( "Think", "KeyInput", KeyThink )

/*-------------------------------------------------------------------------------------------------------------------------
	Setup votes received from the server
-------------------------------------------------------------------------------------------------------------------------*/
local function numofYes( um )
	voteNumYes = um:ReadShort()
end
usermessage.Hook( "NumOfYes", numofYes )

local function numofNo( um )
	voteNumNo = um:ReadShort()
end
usermessage.Hook( "NumOfNo", numofNo )

local function setupVote( um )
	voteQuestion = um:ReadString()
	voteQuestionRes = voteQuestion
	voteEnd = CurTime() + um:ReadLong()
	NumOfPlayers = um:ReadShort()
	voteStarter = um:ReadString()
	surface.SetFont("VoteQuestion")
	qwidth, qheight = surface.GetTextSize(voteQuestion)
end
usermessage.Hook( "cv_SetupVote", setupVote )

local function clearVote( um )
	voteResEnd = CurTime() + um:ReadLong()
	voteResMessage = um:ReadString()
	voteResResult = um:ReadBool()
	
	voteQuestion = ""
	voteEnd = 0
	voteNumYes = 0
	voteNumNo = 0
end
usermessage.Hook( "cv_FinishVote", clearVote )