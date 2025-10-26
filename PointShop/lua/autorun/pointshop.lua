if not datastream then require("datastream") end

if SERVER then
	AddCSLuaFile("autorun/pointshop.lua")
	
	AddCSLuaFile("vgui/DShopModel.lua")
	AddCSLuaFile("vgui/DShopMaterial.lua")
	
	AddCSLuaFile("sh_pointshop.lua")
	AddCSLuaFile("sh_config.lua")
	AddCSLuaFile("sh_items.lua")
	AddCSLuaFile("cl_player_extension.lua")
	AddCSLuaFile("cl_pointshop.lua")
	
	include("sh_pointshop.lua")
	include("sh_config.lua")
	include("sh_items.lua")
	include("sv_player_extension.lua")
	include("sv_pointshop.lua")
end

if CLIENT then
	include("vgui/DShopModel.lua")
	include("vgui/DShopMaterial.lua")
	
	include("sh_pointshop.lua")
	include("sh_config.lua")
	include("sh_items.lua")
	include("cl_player_extension.lua")
	include("cl_pointshop.lua")
end