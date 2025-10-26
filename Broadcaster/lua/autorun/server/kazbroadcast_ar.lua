// Send required files to clients
AddCSLuaFile("autorun/client/cl_broadcast_ar.lua")
AddCSLuaFile("cl_broadcast.lua")

// Required Network Strings
util.AddNetworkString("broadcast") -- Server Notifies Clients
util.AddNetworkString("cc_broadcast") -- ConCommand Security
util.AddNetworkString("broadcast_ed") -- Server updates Admins
util.AddNetworkString("cl_broadcast") -- Admin updates Server

// Create default text file if it doesn't exist
if !file.Exists("broadcasts.txt", "DATA") then
	file.Write("broadcasts.txt", ">New Broadcast<")
end
if !file.Exists("broadcasts_set.txt", "DATA") then
	file.Write("broadcasts_set.txt", "1\nbuttons/lightswitch2.wav")
end

// Load Broadcast serverside
include("broadcast.lua")