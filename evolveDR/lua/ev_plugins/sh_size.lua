-- Name: Size
-- Desc: Allows you to see people at different sizes
-- Author: Lixquid

-- Heavily based on Overv's original Scale plugin

local PLUGIN = {}
PLUGIN.Title = "Size"
PLUGIN.Description = "Allows you to see people at different sizes"
PLUGIN.Author = "Lixquid"
PLUGIN.ChatCommand = "size"
PLUGIN.Usage = "<players> <x> <y> <z>"
PLUGIN.Privileges = { "Size" }

function PLUGIN:RenderScene()
	for _, v in pairs( player.GetAll() ) do
		if v:GetModelScale() ~= v:GetNWVector( "EV_Size", Vector( 1, 1, 1 ) ) then
			v:SetModelScale( v:GetNWVector( "EV_Size", Vector( 1, 1, 1 ) ) )
		end
	end
end

function PLUGIN:Call( ply, args )
	if ply:EV_HasPrivilege( "Size" ) then
		if #args >= 3 then
			local x = tonumber( args[ #args - 2 ] )
			local y = tonumber( args[ #args - 1 ] )
			local z = tonumber( args[ #args ] )
			table.remove( args, #args )
			table.remove( args, #args )
			table.remove( args, #args )
			
			if x and y and z then
				x = math.Clamp( x, 0.05, 20 )
				y = math.Clamp( y, 0.05, 20 )
				z = math.Clamp( z, 0.05, 20 )
				local players = evolve:FindPlayer( args, ply )
				local size = Vector( x, y, z )
				
				if #players > 0 then
					for _, pl in pairs( players ) do
						pl:SetNWVector( "EV_Size", size )
						pl:SetHull( Vector( -16 * x, -16 * y, 0 ), Vector( 16 * x, 16 * y, 72 * z ) )
						pl:SetHullDuck( Vector( -16 * x, -16 * y, 0 ), Vector( 16 * x, 16 * y, 36 * z ) )
						pl:SetViewOffset( Vector( 0, 0, 68 * z ) )
						pl:SetViewOffsetDucked( Vector( 0, 0, 32 * z ) )
						pl:SetStepSize( z * 16 ) -- Best Guess, anyone?
						pl:SetCollisionBounds( Vector( -16 * x, -16 * y, 0 ), Vector( 16 * x, 16 * y, 72 * z ) )
						pl:SetWalkSpeed( 50 * ( x + y + z ) * 0.33 + 200 )
						pl:SetRunSpeed( 100 * ( x + y + z ) * 0.33 + 400 )
						pl:SetJumpPower( 160 * z )
						--pl:SetGravity( 1 / z )
					end
					evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has set the size of ", evolve.colors.red, evolve:CreatePlayerList( players ), evolve.colors.white, " to " .. x .. ", " .. y .. ", " .. z .. "." )
				else
					evolve:Notify( ply, evolve.colors.red, "No matching players found." )
				end
			else
				evolve:Notify( ply, evolve.colors.red, "You must specify numeric size parameters!" )
			end
		else
			evolve:Notify( ply, evolve.colors.red, "You need to specify at least one player and three size parameters!" )
		end
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

function PLUGIN:CalcView( ply, origin, angles, fov )
	if ply:GetNWVector( "EV_Size", Vector( 1, 1, 1 ) ) == Vector( 1, 1, 1 ) then return end
	
	local z = ply:GetNWVector( "EV_Scale", Vector( 1, 1, 1 ) ).z
	
	origin = origin + Vector( 0, 0, 64 * z )
end

function PLUGIN:Menu( arg, players )
	if arg then
		table.insert( players, arg )
		RunConsoleCommand( "ev", "size", unpack( players ) )
	else
		return "Size", evolve.category.actions, {
			{ "Default", { 1, 1, 1 } },
			{ "Giant", { 10, 10, 10 } },
			{ "Small", { 0.7, 0.7, 0.7 } },
			{ "Flat", { 1, 1, 0.05 } },
			{ "Paper", { 1, 0.05, 1 } }
		}
	end
end
evolve:RegisterPlugin( PLUGIN )