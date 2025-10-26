surface.CreateFont ("coolvetica", 30, 800, true, false, "HealthFont") --unscaled
surface.CreateFont ("coolvetica", 120, 800, true, false, "WinnerFont") --unscaled
surface.CreateFont ("coolvetica", 80, 800, true, false, "Join") --unscaled

local spabebar = surface.GetTextureID( "gui/spacebar" )

hook.Add( "HUDPaint", "DeathRunHUDPaint", function()
	local ply = LocalPlayer()
	local InProgress = GetGlobalBool( "InRound" )
	--local Preparing = GetGlobalBool( "RoundPreparing" )
	local Add = 0
	local Push = 0
	if InProgress then
		if ply:Alive() then
			Add = 42
		end
	end
	if !InProgress or !ply:Alive() then
			Push = 41
	end
	local BoxLength = 250
	local BoxHeight = 45 + Add
	local BoxXPos = 25
	local BoxYPos = ScrH() - 95 + Push
	local Font = "HealthFont"
	local Health =  math.min(ply:Health(),100)
	local HealthPc = Health / 100
	local Team = ply:Team()
	local TeamName = team.GetName(Team)
	local TimeLeft = math.min( GetGlobalFloat( "RoundEndTime") - CurTime(), 300 )
	local Countdown = string.ToMinutesSeconds( TimeLeft )
	if TimeLeft < 0 then
		Countdown = "05:00"
	end
	
	// Info
	draw.RoundedBox( 6, BoxXPos, BoxYPos, BoxLength, BoxHeight, Color(5, 0, 0, 130) )
	draw.RoundedBox( 4, BoxXPos+5, BoxYPos+5, 165, 35, Color( 15, 15, 15 ) )
	if InProgress then
		draw.SimpleTextOutlined( Countdown, Font, BoxXPos + 180, BoxYPos+8, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 1.5, Color(0,0,0) )
	end
	
	if GetGlobalBool( "DelayFirstRound" ) or ( #team.GetPlayers(1) + #team.GetPlayers(2) < 2 ) then
		draw.SimpleTextOutlined( "Waiting", Font, BoxXPos+36, BoxYPos+8, Color( 255, 255, 255, 200 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 1, Color(0,0,0)  )
	elseif InProgress then
		if ply:Alive() then
			if ply:Team() == 1 then
				draw.SimpleTextOutlined( TeamName, Font, BoxXPos+40, BoxYPos+8, Color( 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 1, Color(0,0,0) )
			else
				draw.SimpleTextOutlined( TeamName, Font, BoxXPos+52, BoxYPos+8, Color( 255, 0, 0 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 1, Color(0,0,0) )
			end
		else
			draw.SimpleTextOutlined( "In Progress", Font, BoxXPos+23, BoxYPos+8, Color( 255, 255, 255, 200 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 1, Color(0,0,0)  )
		end
	else
		draw.SimpleTextOutlined( "Round Over", Font, BoxXPos+20, BoxYPos+8, Color( 255, 255, 255, 200 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 1, Color(0,0,0)  )
	end
	
	// Health Bar
	if InProgress then
		if ply:Alive() then
			draw.RoundedBox( 4, BoxXPos+5, BoxYPos+45, BoxLength-10, 35, Color( 15, 15, 15 ) )
			if Health > 50 then
				draw.RoundedBox( 4, BoxXPos+5, BoxYPos+45, ( BoxLength - 10 )*HealthPc, 35, Color(((100 - Health) / 50)*255 ,255,0) )
			else
				draw.RoundedBox( 4, BoxXPos+5, BoxYPos+45, ( BoxLength - 10 )*HealthPc, 35, Color(255, (Health/50)*255, 0) )
			end 
			local Width
			local Height
			surface.SetFont( Font )
			Width, Height = surface.GetTextSize( tostring( Health ) )
			draw.SimpleTextOutlined( Health, Font, BoxXPos + BoxLength/2 - Width/2, BoxYPos + 35 + Height/2, Color( 255, 255, 255, 200 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 1.5, Color(0,0,0)  )
		end
	end
	
	// Round Results
	local Round = GetGlobalInt( "RoundNumber" )
	local LastRoundResult = GetGlobalInt( "RoundResult" )
	local WinFont = "WinnerFont"
	
	if not ( ply:Team() == 1002 ) then
		if !InProgress and Round > 0 then
			if LastRoundResult == 1 then
				surface.SetFont( WinFont )
				local Wd, He = surface.GetTextSize( "RUNNERS WIN" )
				draw.SimpleTextOutlined( "RUNNERS WIN", WinFont, ScrW()/2 - Wd/2, ScrH()/4, Color( 0, 0, 200, 200 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 6, Color(0,0,0)  )
			elseif LastRoundResult == 2 then
				surface.SetFont( WinFont )
				local Wd, He = surface.GetTextSize( "DEATH WINS" )
				draw.SimpleTextOutlined( "DEATH WINS", WinFont, ScrW()/2 - Wd/2, ScrH()/4, Color( 255, 0, 0, 200 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 6, Color(0,0,0)  )
			else
				surface.SetFont( WinFont )
				local Wd, He = surface.GetTextSize( "DRAW!" )
				draw.SimpleTextOutlined( "DRAW!", WinFont, ScrW()/2 - Wd/2, ScrH()/4, Color( 255, 255, 0, 200 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 6, Color(0,0,0)  )
			end
		end
	end
	
	// AFK WARN
	if ply:Team() == 1002 then
		surface.SetFont( "WinnerFont" )
		local Width, Height = surface.GetTextSize( "YOU ARE A SPECTATOR" )
		draw.SimpleTextOutlined( "YOU ARE A SPECTATOR", "WinnerFont", ScrW()/2 - Width/2 , ScrH()/2 - 2*Height, Color( 255, 255, 0 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 3, Color( 0, 0, 0 )  )
		surface.SetFont( "Join" )
		local Wi, He = surface.GetTextSize( "Press" )
		draw.SimpleTextOutlined( "Press", "Join", ScrW()/2 - Wi/2, ScrH()/2 - He, Color( 255, 255, 0 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 3, Color( 0, 0, 0 )  )
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetTexture( spabebar )
		surface.DrawTexturedRect( ScrW()/2 - 110, ScrH()/2+ He/2, 229, 80 )
		surface.SetFont( "HealthFont" )
		local Witt, Hett = surface.GetTextSize( "SPACE" )
		draw.SimpleText( "SPACE", "HealthFont", ScrW()/2 - Witt/2, ScrH()/2+ Hett*2, Color(0,0,0), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )
		surface.SetFont( "Join" )
		local Wit, Het = surface.GetTextSize( "To Join!" )
		draw.SimpleTextOutlined( "To Join!", "Join", ScrW()/2 - Wit/2, ScrH()/2 +Het*2, Color( 255, 255, 0 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 3, Color( 0, 0, 0 )  )
	end
	
	
end )

local LastKeyPressed = 0
hook.Add( "KeyPress", "KeyPressJoinGame", function()
	if CurTime() >  LastKeyPressed + 1 and LocalPlayer():Team() == 1002 then
		if input.IsKeyDown( KEY_SPACE ) then
			LastKeyPressed = CurTime()
			LocalPlayer():ConCommand( "changeteam 1" )
		end
	end
end )