AddCSLuaFile( "autorun/client/cl_donate.lua" )

Msg([[

===============================================================
========= Donator System v1.0 successfuly started. ========
===============================================================

]])

-- Check or Make the table.
if !sql.TableExists("donator") then
			Msg([[

==> Donator System v1.0: 'donator' SQL table not found!

]])

	query = "CREATE TABLE donator (steamID varchar(255), name varchar(255), note varchar(255))"
	result = sql.Query(query)
	if (sql.TableExists("donator")) then
					Msg([[

==> Donator System v1.0: 'donator' SQL table created!

]])
	else
					Msg([[

==> Donator System v1.0: [ERROR] Unable to create'donator' SQL table!

]])
		print( sql.LastError( result ))
	end
else
			Msg([[

==> Donator System v1.0: 'donator' SQL table found!

]])
end

-- Add Donator
concommand.Add("adddonator", function(pl , cmd, arg)
	if !string.match( arg[1], "STEAM_[0-5]:[0-9]:[0-9]+" ) then 
		if pl then
			pl:SendLua("Derma_Message(\"Invalid Steam ID!\", \"Donator Management\", \"Close\")")
		else
			print("==> Donator System v1.0: Invalid SteamID!")
		end
		return 
	end
	
	if !pl then
		WriteSQLDonator ( arg[1], arg[2], arg[3])
	elseif pl:IsAdmin() then
		WriteSQLDonator ( arg[1], arg[2], arg[3])
	end
	
	for k, v in pairs(player.GetAll()) do
		if v:SteamID() == arg[1] then
			ProcessDonator(v)
		end
	end
end )

-- Remove Donator.
concommand.Add("removedonator", function(pl, cmd, arg)
	if !pl then
		sql.Query("DELETE FROM donator WHERE steamID = '"..arg[1].."'")
	elseif pl:IsAdmin() then
		sql.Query("DELETE FROM donator WHERE steamID = '"..arg[1].."'")
	end
	
	for k, v in pairs(player.GetAll()) do
		if v:SteamID() == arg[1] then
			ProcessDonator(v)
		end
	end
end )

-- Process the Players when they spawn.
hook.Add( "PlayerInitialSpawn", "DonaterList_FS", function(ply)	
	ProcessDonator(ply)		
end )
 
-- Check if the player is donator.
function _R.Player:IsDonator()
	return sql.QueryValue("SELECT steamID FROM donator WHERE steamID = '"..self:SteamID().."'")
end 


function ProcessDonator ( ply )
	if ply:IsDonator() then
		ply:SetNWBool("donator", true)
		ply:ChatPrint("Donator: True")
	else
		ply:SetNWBool("donator", false)
		ply:ChatPrint("Donator: False")
	end
end


function WriteSQLDonator ( steamID, name, note )
    result = sql.Query("SELECT steamID FROM donator WHERE steamID = '"..steamID.."'")
	if (result) then
		//Exists! So overwrite!
		sql.Query("UPDATE donator SET name = "..name..", note = "..note.." WHERE steamID = '"..steamID.."'")
		print("Entry overwritten")
	else
		//Doesnt exist! So insert new!
		sql.Query( "INSERT INTO donator VALUES ('"..steamID.."', '"..name.."', '"..note.."')" )
		print("Entry inserted")
	end
end

concommand.Add("donatormenu", function(pl, cmd, arg)
	local completetable = sql.Query("SELECT * FROM donator")
	if completetable then
		if !pl then
			print(completetable)
			PrintTable(completetable)
		elseif pl:IsAdmin() then
			for k, v in pairs(completetable) do
				umsg.Start("SendDonator", pl)
					umsg.String(completetable[k]["steamID"])
					umsg.String(completetable[k]["name"])
					umsg.String(completetable[k]["note"])
				umsg.End()
			end
			umsg.Start("donatorsdone", pl)
			umsg.End()
		end
	else
		if pl then
			if pl:IsAdmin() then
				umsg.Start("donatorsdone", pl)
				umsg.End()
			end
		end
			Msg([[

==> Donator System v1.0: There are currently no donators!

]])
	end
end )

hook.Add( "PlayerSay", "DS_autorunCC", function(ply, text, team)
	if (string.lower(text) == "!donators") and ply:IsAdmin() then
		ply:SendLua("LocalPlayer():ConCommand(\"donatormenu\")")
		return ""
	end
end )

