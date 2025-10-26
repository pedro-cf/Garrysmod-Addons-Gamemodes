if !file.Exists("motd/tabs.txt", "DATA") or !file.Exists("motd/buttons.txt", "DATA") then
	return
end

local tabs_file = string.Explode("\n\n", string.Trim(file.Read("motd/tabs.txt", "DATA")))
local Tabs = {}
for i, tab in pairs(tabs_file) do
	local Tab = {}
	for j, line in pairs(string.Explode("\n", tab)) do
		Tab[j] = string.Explode("=", line)[2]
	end
	Tabs[i] = Tab
end

local buttons_file = string.Explode("\n\n", file.Read( "motd/buttons.txt", "DATA"))
local Btns = {}
for i, button in pairs(buttons_file) do
	local Btn = {}
	for j, line in pairs(string.Explode("\n", button)) do
		Btn[j] = string.Explode("=", line)[2]
	end
	Btns[i] = Btn
end

local function updateClient(ply)
	net.Start("motd")
			net.WriteTable(Tabs)
			net.WriteTable(Btns)
	net.Send(ply)
end

net.Receive("cl_motd", function(len, ply)
	if (!ply:IsAdmin()) then return end
	Tabs = net.ReadTable()
	Btns = net.ReadTable()

	if Tabs != nil then
		file.Write("motd/tabs.txt", "")
		for i, tab in pairs(Tabs) do
			for j, line in pairs(tab) do
				if (j == 1) then file.Append("motd/tabs.txt", "enabled="..line.."\n")
				elseif (j == 2) then file.Append("motd/tabs.txt", "name="..line.."\n")
				elseif (j == 3) then file.Append("motd/tabs.txt", "url="..line.."\n")
				elseif (j == 4) then file.Append("motd/tabs.txt", "icon="..line.."\n")
				end
			end
			file.Append("motd/tabs.txt", "\n")
		end
		for k, v in pairs(player.GetAll()) do
			updateClient(v)
		end
	end
	
	if Btns != nil then
		file.Write("motd/buttons.txt", "")
		for i, btn in pairs(Btns) do
			for j, line in pairs(btn) do
				if (j == 1) then file.Append("motd/buttons.txt", "enabled="..line.."\n")
				elseif (j == 2) then file.Append("motd/buttons.txt", "name="..line.."\n")
				elseif (j == 3) then file.Append("motd/buttons.txt", "url="..line.."\n")
				elseif (j == 4) then file.Append("motd/buttons.txt", "icon="..line.."\n")
				end
			end
			file.Append("motd/buttons.txt", "\n")
		end
		for k, v in pairs(player.GetAll()) do
			updateClient(v)
		end
	end
	
end)

hook.Add("PlayerInitialSpawn", "motd_initspawn", function(ply) 
	updateClient(ply)
	ply:ConCommand("open_motd")
end)

concommand.Add("motdeditor", function(ply,cmd,args,str)
    if !ply:IsAdmin() then return end
	net.Start("cc_motd")
	net.Send(ply)
end)

hook.Add( "PlayerSay", "motd_txt_cmd", function(ply, text, public)
	if string.lower(text) == "!motd" then 
		ply:ConCommand("open_motd")
	elseif ply:IsAdmin() and string.lower(text) == "!motdeditor" then
		net.Start("cc_motd")
		net.Send(ply)
		return ""
	end
end)