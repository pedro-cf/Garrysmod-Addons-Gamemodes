/*-------------------------------------------------------------------------------------------------------------------------
	Default custom scoreboard
-------------------------------------------------------------------------------------------------------------------------*/

resource.AddFile( "materials/gui/ldtdrscoreboard.vmt" )
resource.AddFile( "materials/gui/scoreboard_middle.vtf" )
resource.AddFile( "materials/gui/scoreboard_middle.vmt" )
resource.AddFile( "materials/gui/scoreboard_bottom.vtf" )
resource.AddFile( "materials/gui/scoreboard_bottom.vmt" )
resource.AddFile( "materials/gui/scoreboard_ping.vtf" )
resource.AddFile( "materials/gui/scoreboard_ping.vmt" )
resource.AddFile( "materials/gui/scoreboard_frags.vtf" )
resource.AddFile( "materials/gui/scoreboard_frags.vmt" )
resource.AddFile( "materials/gui/scoreboard_skull.vtf" )
resource.AddFile( "materials/gui/scoreboard_skull.vmt" )
resource.AddFile( "materials/gui/scoreboard_playtime.vtf" )
resource.AddFile( "materials/gui/scoreboard_playtime.vmt" )

local PLUGIN = {}
PLUGIN.Title = "Scoreboard"
PLUGIN.Description = "DR scoreboard."
PLUGIN.Author = "Overv"

if ( CLIENT ) then
	PLUGIN.TexHeader = surface.GetTextureID( "gui/ldtdrscoreboard" )
	PLUGIN.TexMiddle = surface.GetTextureID( "gui/scoreboard_middle" )
	PLUGIN.TexBottom = surface.GetTextureID( "gui/scoreboard_bottom" )
	PLUGIN.TexPing = surface.GetTextureID( "gui/scoreboard_ping" )
	PLUGIN.TexFrags = surface.GetTextureID( "gui/scoreboard_frags" )
	PLUGIN.TexDeaths = surface.GetTextureID( "gui/scoreboard_skull" )
	PLUGIN.TexPlaytime = surface.GetTextureID( "gui/scoreboard_playtime" )
	
	PLUGIN.Width = 687
	
	surface.CreateFont( "coolvetica", 22, 400, true, false, "EvolveScoreboardHeader" )
end

function PLUGIN:ScoreboardShow()
	if ( evolve.installed ) then
		self.DrawScoreboard = true
		return true
	end
end

function PLUGIN:ScoreboardHide()
	if ( self.DrawScoreboard ) then
		self.DrawScoreboard = false
		return true
	end
end

function PLUGIN:DrawTexturedRect( tex, x, y, w, h )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetTexture( tex )
	surface.DrawTexturedRect( x, y, w, h )
end

function PLUGIN:QuickTextSize( font, text )
	surface.SetFont( font )
	return surface.GetTextSize( text )
end

function PLUGIN:FormatTime( raw )
	if ( raw < 60 ) then
		return math.floor( raw ) .. " secs"
	elseif ( raw < 3600 ) then
		if ( raw < 120 ) then return "1 min" else return math.floor( raw / 60 ) .. " mins" end
	elseif ( raw < 3600*24 ) then
		if ( raw < 7200 ) then return "1 hour" else return math.floor( raw / 3600 ) .. " hours" end
	else
		if ( raw < 3600*48 ) then return "1 day" else return math.floor( raw / 3600 / 24 ) .. " days" end
	end
end

local TxtColor = Color( 255, 255, 255, 255 )
local TxtColorB = Color( 0,0,0,255)

function PLUGIN:DrawInfoBar()
	// Background
	surface.SetDrawColor( 0, 0, 0, 200 )
	surface.DrawRect( self.X + 15, self.Y + 110, self.Width - 30, 28 )
	
	surface.SetDrawColor( 0, 0, 0, 255 )
	surface.DrawOutlinedRect( self.X + 15, self.Y + 110, self.Width - 30, 28 )
	
	// Content
	local x = self.X + 24
	draw.SimpleText( "Currently playing ", "Default", x, self.Y + 117, TxtColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	x = x + self:QuickTextSize( "Default", "Currently playing " )
	draw.SimpleText( "Deathrun", "DefaultBold", x, self.Y + 117, TxtColorB, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	x = x + self:QuickTextSize( "DefaultBold", "Deathrun" )
	draw.SimpleText( " on the map ", "Default", x, self.Y + 117, TxtColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	x = x + self:QuickTextSize( "Default", " on the map " )
	draw.SimpleText( game.GetMap(), "DefaultBold", x, self.Y + 117, TxtColorB, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	x = x + self:QuickTextSize( "DefaultBold", game.GetMap() )
	draw.SimpleText( ", with ", "Default", x, self.Y + 117, TxtColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	x = x + self:QuickTextSize( "Default", ", with " )
	draw.SimpleText( #player.GetAll(), "DefaultBold", x, self.Y + 117, TxtColorB, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	x = x + self:QuickTextSize( "DefaultBold", #player.GetAll() )
	local s = ""
	if ( #player.GetAll() > 1 ) then s = "s" end
	draw.SimpleText( " player" .. s .. ".", "Default", x, self.Y + 117, TxtColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	local round = 13 - GetGlobalInt( "RoundNumber" )
	draw.SimpleText( "Rounds Left: ", "Default", x + 135, self.Y + 117, TxtColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	draw.SimpleText( round, "DefaultBold", x + 135 + self:QuickTextSize( "Default", "Rounds Left: " ), self.Y + 117, TxtColorB, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
end


function PLUGIN:DrawTeam( playerinfo, teamid, title, col, y )
	local playersFound = false
	for _, pl in ipairs( playerinfo ) do
		if ( pl.Team == teamid ) then
			playersFound = true
			break
		end
	end
	if ( !playersFound ) then return y end
	
	surface.SetDrawColor( 0, 0, 0, 200 )
	surface.DrawRect( self.X + 0.5, y, self.Width - 2, 22 )
	local TeamPlayers = #team.GetPlayers(teamid)
	local TeamAlive = 0
	for k,v in pairs( team.GetPlayers(teamid) ) do
		if v:Alive() then
			TeamAlive = TeamAlive + 1
		end
	end
	draw.SimpleText( title, "DefaultBold", self.X + 50, y + 4, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	
	draw.SimpleText( "Rank", "DefaultBold", self.X + 300, y + 4, Color(0,0,0), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	self:DrawTexturedRect( self.TexPing, self.X + self.Width - 50, y + 4, 14, 14 )
	--self:DrawTexturedRect( self.TexDeaths, self.X + self.Width - 150.5, y + 4, 14, 14 )
	--self:DrawTexturedRect( self.TexFrags, self.X + self.Width - 190.5,  y + 4, 14, 14 )
	self:DrawTexturedRect( self.TexPlaytime, self.X + self.Width - 100,  y + 4, 14, 14 )
	
	y = y + 26
	
	for _, pl in ipairs( playerinfo ) do
		if ( pl.Team == teamid ) then
			if pl.Usergroup != "guest" then 
				draw.SimpleText( evolve.ranks[ pl.Usergroup ].Title, "ScoreboardText", self.X + 300, y, Color( 39, 39, 39, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
				draw.SimpleText( pl.Nick, "ScoreboardText", self.X + 50, y, Color( 39, 39, 39, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			else
				draw.SimpleText( pl.Nick, "ScoreboardText", self.X + 50, y, Color( 39, 39, 39, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			end					
			if !pl.Alive and pl.Team != 1002 then self:DrawTexturedRect( self.TexDeaths,  self.X + 22.5, y+2, 14, 14 ) end
			--draw.SimpleText( pl.Frags, "ScoreboardText", self.X + self.Width - 187, y, Color( 39, 39, 39, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			--draw.SimpleText( pl.Deaths, "ScoreboardText", self.X + self.Width - 147, y, Color( 39, 39, 39, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			draw.SimpleText( pl.Ping, "ScoreboardText", self.X + self.Width - 50, y, Color( 39, 39, 39, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			draw.SimpleText( self:FormatTime( pl.PlayTime ), "ScoreboardText", self.X + self.Width - 92, y, Color( 39, 39, 39, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
			
			y = y + 20
		end
	end
	
	return y + 10
end

function PLUGIN:DrawPlayers()
	local playerInfo = {}
	for _, v in pairs( player.GetAll() ) do
		if v:Alive() then
			table.insert( playerInfo, { Nick = v:Nick(), Usergroup = v:EV_GetRank(), Frags = v:Frags(), Deaths = v:Deaths(), Ping = v:Ping(), Alive = v:Alive(), Team = v:Team(), PlayTime = evolve:Time() - v:GetNWInt( "EV_JoinTime" ) + v:GetNWInt( "EV_PlayTime" ) } )
		end
	end
	for _, v in pairs( player.GetAll() ) do
		if !v:Alive() then
			table.insert( playerInfo, { Nick = v:Nick(), Usergroup = v:EV_GetRank(), Frags = v:Frags(), Deaths = v:Deaths(), Ping = v:Ping(), Alive = v:Alive(), Team = v:Team(), PlayTime = evolve:Time() - v:GetNWInt( "EV_JoinTime" ) + v:GetNWInt( "EV_PlayTime" ) } )
		end
	end
	
	local y = self.Y + 155
	
	local Teams = {}
	for id, info in pairs(team.GetAllTeams()) do
		table.insert( Teams, { ID = id, Title = team.GetName(id), Col = team.GetColor(id) } )
	end
	
	for _, Team in ipairs( Teams ) do
		if string.Right( Team.Title, 2) == "or" then
			y = self:DrawTeam( playerInfo, Team.ID, Team.Title.. "s", Team.Col, y )
		else
			y = self:DrawTeam( playerInfo, Team.ID, Team.Title, Team.Col, y )
		end
	end
	
	return y
end

function PLUGIN:HUDDrawScoreBoard()
	if ( !self.DrawScoreboard ) then return end
	if ( !self.Height ) then self.Height = 139 end
	
	// Update position
	self.X = ScrW() / 2 - self.Width / 2
	self.Y = ScrH() / 2 - ( self.Height ) / 2
	
	surface.SetDrawColor( 255, 255, 255, 255 )
	
	surface.SetTexture( self.TexHeader )
	surface.DrawTexturedRect( self.X, self.Y, self.Width, 122 )
	draw.SimpleText( "[LDT] Deathrun", "EvolveScoreboardHeader", self.X + 133, self.Y + 51, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	draw.SimpleText( "[LDT] Deathrun", "EvolveScoreboardHeader", self.X + 132, self.Y + 50, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetTexture( self.TexMiddle )
	surface.DrawTexturedRect( self.X, self.Y + 122, self.Width, self.Height - 122 - 37 )
	surface.SetTexture( self.TexBottom )
	surface.DrawTexturedRect( self.X, self.Y + self.Height - 37, self.Width, 37 )
	
	self:DrawInfoBar()
	
	local y = self:DrawPlayers()
	
	self.Height = y - self.Y
end

evolve:RegisterPlugin( PLUGIN )