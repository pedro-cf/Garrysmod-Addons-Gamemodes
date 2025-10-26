local function KQSoundON()
	if LocalPlayer():GetPData( "KQS" ) == "0" then
		return false
	else
		return true
	end
end

local function KQSTraitorON()
	if LocalPlayer():GetPData( "KQStraitor" ) == "1" then
		return true
	else
		return false
	end
end

local function KQSTeamKillON()
	if LocalPlayer():GetPData( "KQStk" ) == "1" then
		return true
	else
		return false
	end
end

concommand.Add( "Enable_KQS",  function( ply, cmd, args )

	local window = vgui.Create( "DFrame" )
		window:SetSize( 310, 75 + 20 )
		window:SetPos( ScrW()*0.05, ScrH()*0.45 )
		window:SetTitle( "Quake Sounds" )
		window:SetVisible(true)
		window:SetDraggable(false)
		window:ShowCloseButton(true)
		window:MakePopup()
	
	local box1 = vgui.Create( "DCheckBox", window )
		box1:SetPos( 15, 30 )
		if KQSoundON() then 
			box1:SetChecked( true )
		end
		box1.DoClick = function()
			if box1:GetChecked() then
				LocalPlayer():SetPData( "KQS", 0 )
				box1:Toggle()
			else
				LocalPlayer():SetPData( "KQS", 1 )
				box1:Toggle()
			end
		end
		
	local label1 = vgui.Create( "DLabel", window )
		label1:SetPos( 40, 29 )
		label1:SetFont("Trebuchet18")
		label1:SetColor( Color( 255, 255, 255, 255 ) )
		label1:SetText( "Enable all kill messages when Spectator." )
		label1:SizeToContents()
		
	local box2 = vgui.Create( "DCheckBox", window )
		box2:SetPos( 15, 50 )
		if KQSTraitorON() then
			box2:SetChecked( true )
		end
		box2.DoClick = function()
			if box2:GetChecked() then
				LocalPlayer():SetPData( "KQStraitor", 0 )
				box2:Toggle()
			else
				LocalPlayer():SetPData( "KQStraitor", 1 )
				box2:Toggle()
			end
		end
	local label2 = vgui.Create( "DLabel", window )
		label2:SetPos( 40, 49 )
		label2:SetFont("Trebuchet18")
		label2:SetColor( Color( 255, 255, 255, 255 ) )
		label2:SetText( "Enable my kill messages when Traitor." )
		label2:SizeToContents()
		
	local box3 = vgui.Create( "DCheckBox", window )
		box3:SetPos( 15, 70 )
		if KQSTeamKillON() then
			box3:SetChecked( true )
		end
		box3.DoClick = function()
			if box3:GetChecked() then
				LocalPlayer():SetPData( "KQStk", 0 )
				box3:Toggle()
			else
				LocalPlayer():SetPData( "KQStk", 1 )
				box3:Toggle()
			end
		end
		
	local label3 = vgui.Create( "DLabel", window )
		label3:SetPos( 40, 69 )
		label3:SetFont("Trebuchet18")
		label3:SetColor( Color( 255, 255, 255, 255 ) )
		label3:SetText( "Enable all team kill messages when Spectator." )
		label3:SizeToContents()
	
	
end )


local ColorTable = {}
ColorTable["white"] = Color( 255, 255, 255 )
ColorTable["black"] = Color( 0, 0, 0 )
ColorTable["red"] = Color( 255, 0, 0 )
ColorTable["green"] = Color( 0, 255, 0 )
ColorTable["blue"] = Color( 0, 0, 255 )
ColorTable["teal"] = Color( 0, 255, 255 )


local Domination = false
local Domintxt = ""
local BestKills = false
local BestKillstxt = ""
usermessage.Hook( "QuakeSound", function( um )
	
	if !IsValid( LocalPlayer() ) then return end
	if LocalPlayer():IsActiveTraitor() and !KQSTraitorON() then return end
	if LocalPlayer():IsSpec() and !KQSoundON() and !KQSTeamKillON() then return end
	
	local message = um:ReadString()
	local sound = um:ReadString()
	local color = um:ReadString() or "white"
	
	if LocalPlayer():IsSpec() and !KQSoundON() and KQSTeamKillON() and sound != "quake/kkteamkiller.mp3" then return end
	
	if message == "info" and !KQSoundON() then
		chat.AddText(
		Color(255,153,0), "[LDT] ",
		Color(198,226,255), "Type ",
		Color(30,144,255), "!kqs ",
		Color(198,226,255), "to setup KQS.")
	end
	
	if message and message != "" and message != "info" and sound != "bestkills" then chat.AddText( ColorTable[color], message ) end
	if sound and KQSoundON() or KQSTraitorON() and sound != "" and sound != "bestkills" then 
		surface.PlaySound( sound )
	end
	if sound == "quake/kkbloodbath.mp3" then
		Domintxt = message
		Domination = true
		timer.Simple( 10, function()
			Domination = false
			Domintxt = ""
		end )
	end
	
	if sound == "bestkills" then
		BestKillstxt = message
		BestKills = true
		timer.Simple( 10, function()
			BestKills = false
			BestKillstxt = ""
		end )
	end
	
end )


surface.CreateFont( "Bloodbathfont", { font = "DefaultSmallDropShadow", size =  ScrH()*0.075, weight = 700, blursize  = 1, antialias = 1, underline = 1, italic = 1, strikeout = 1, shadow = 1, outline = 1 } )
surface.CreateFont( "BestKillsbathfont", { font = "DefaultSmallDropShadow", size =  ScrH()*0.04, weight = 700, blursize  = 1, antialias = 1, underline = 1, italic = 1, strikeout = 1, shadow = 1, outline = 1 } )

hook.Add( "HUDPaint", "Dominationscreen", function()

	if Domination then
		surface.SetFont( "Bloodbathfont" )
		local w = surface.GetTextSize( Domintxt )
		draw.SimpleTextOutlined( Domintxt, "Bloodbathfont", ( ScrW() / 2 ) - w / 2, 200, Color( 255, 0, 0, 120 + (math.sin( CurTime() * 20 ) * 80) ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 5, Color( 0, 0, 0, 255) )
    end
	
	if BestKills and !Domination then
		surface.SetFont( "BestKillsbathfont" )
		local wi = surface.GetTextSize( BestKillstxt )
		draw.SimpleTextOutlined( BestKillstxt, "BestKillsbathfont", ( ScrW() / 2 ) - wi / 2, 200, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 1, Color( 0, 0, 0, 255) )
	end
	
end )