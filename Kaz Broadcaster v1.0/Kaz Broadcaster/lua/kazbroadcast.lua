local Broadcasts = {}
local Broadcast_setttings = {}

local curBroadcast = 1

for i, broadcast in pairs( string.Explode( "\n", string.Trim( file.Read( "kaz_broadcasts.txt", "DATA" ) ) ) ) do 
	if broadcast != "" and broadcast != NULL then
		table.insert( Broadcasts, table.Count(Broadcasts) + 1,  broadcast )
	end
end

for i, set in pairs( string.Explode( "\n", string.Trim( file.Read( "kaz_broadcasts_set.txt", "DATA" ) ) ) ) do 
	table.insert( Broadcast_setttings, table.Count(Broadcast_setttings) + 1, set )
end

local function notifyClients( str )
	net.Start("kazbroadcast")
		net.WriteString( str )
		net.WriteString( Broadcast_setttings[2] )
	net.Broadcast()
end

local function updateAdmin( ply )
	if !ply:IsAdmin() then return end
	net.Start( "kazbroadcast_ed" )
		net.WriteTable( Broadcasts )
		net.WriteTable( Broadcast_setttings )
	net.Send( ply )
	ply.kazbcRDY = true
end

local function updateAdmins()
	for _, ply in pairs( player.GetAll() ) do
		updateAdmin( ply )
	end
end

net.Receive( "cl_kazbroadcast", function( len, ply )
	if !ply:IsAdmin() then return end
	Broadcasts = net.ReadTable()
	Broadcast_setttings = net.ReadTable()
	updateAdmins()
	curBroadcast = 1
	
	if timer.Exists( "KazBroadcaster_Timer" ) then
		timer.Destroy( "KazBroadcaster_Timer" )
	end
	timer.Create( "KazBroadcaster_Timer", tonumber(Broadcast_setttings[1]), 0, function()
			if table.Count( Broadcasts ) > 0 then
				notifyClients( Broadcasts[curBroadcast] )
				curBroadcast = curBroadcast +1
				if ( curBroadcast > table.Count( Broadcasts ) ) then
					curBroadcast = 1
				end	
			end
	end )
	
	file.Write( "kaz_broadcasts.txt", "" )
	for k, bc in pairs( Broadcasts ) do
		file.Append( "kaz_broadcasts.txt", bc )
		if k != table.Count( Broadcasts ) then
			file.Append( "kaz_broadcasts.txt", "\n" )
		end
	end
	
	file.Write( "kaz_broadcasts_set.txt", "" )
	for k, set in pairs( Broadcast_setttings ) do
		file.Append( "kaz_broadcasts_set.txt", set )
		if k != table.Count( Broadcast_setttings ) then
			file.Append( "kaz_broadcasts_set.txt", "\n" )
		end
	end
	
end )

hook.Add( "Initialize", "Timer_KazBroadcaster_Active", function()
	timer.Create( "KazBroadcaster_Timer", tonumber(Broadcast_setttings[1]), 0, function()
			if table.Count( Broadcasts ) > 0 then
				notifyClients( Broadcasts[curBroadcast] )
				curBroadcast = curBroadcast +1
				if ( curBroadcast > table.Count( Broadcasts ) ) then
					curBroadcast = 1
				end	
			end
	end )
end )

hook.Add("PlayerInitialSpawn", "kazbroadcast_initspawn", function( ply )
	ply.kazbcRDY = false;
	timer.Simple(3, function()
		updateAdmin( ply )
	end)
end)

concommand.Add( "broadcasteditor", function( ply, cmd, args, str )
	if !ply:IsAdmin()  then return end
	if !ply.kazbcRDY then 
		pdateAdmin( ply )
	end
	net.Start( "cc_kazbroadcast" )
	net.Send( ply )
end)

hook.Add( "PlayerSay", "kazbroadcast_txt_cmd", function(ply, text, public)
	if ply:IsAdmin() and ( string.lower(text) == "!bceditor" or string.lower(text) == "!broadcasteditor" ) then
		if !ply.kazbcRDY then
			updateAdmin( ply )
		end
		ply:ConCommand( "broadcasteditor" )
		return ""
	end
end)