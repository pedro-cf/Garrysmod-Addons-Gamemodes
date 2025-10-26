local PLUGIN = {}
PLUGIN.Title = "Scare"
PLUGIN.Description = "Scare a player."
PLUGIN.Author = "Anonymous"
PLUGIN.ChatCommand = "scare"
PLUGIN.Usage = "[players]"
PLUGIN.Privileges = { "Scare" }

function PLUGIN:Call( ply, args )
	if ( ply:EV_HasPrivilege( "Scare" ) ) then
		local players = evolve:FindPlayer( args, ply )
		
		for _, pl in ipairs( players ) do
			--Spawn Body
			local eyeangle = Vector(pl:GetAimVector().x, pl:GetAimVector().y, 0):Angle()
			pl:SetEyeAngles(eyeangle)
			local loc = 0
			local angle = 0
			local bodyvec = 0
			local crouch = 0
			pl:Lock()
			timer.Create( "my_tttimer", 0.2, 1, function()
			local stay =  ents.Create( "prop_physics" )
				local staypos = pl:GetPos() + Vector(0,0,50)
				stay:SetPos(staypos)
				stay:SetModel("models/props_phx/construct/metal_plate1.mdl")
				stay:SetColor(Color(0,0,0,0))
				stay:Spawn()
				stay:GetPhysicsObject():EnableMotion(false)
			if !pl:Crouching() then
				loc = pl:GetPos() + ( pl:GetAimVector()*39) + Vector(0,0,34)
				bodyvec = pl:GetPos() - loc
				angle = bodyvec:Angle() + Vector(-6,-9,0)
			else
				loc = pl:GetPos() + ( pl:GetAimVector()*29) + Vector(0,0,-10)
				bodyvec = pl:GetPos() - loc
				angle = bodyvec:Angle() + Vector(37,-13,0)
			end
			local body =  ents.Create( "prop_physics" )
				body:SetModel("models/Zombie/Fast.mdl")
				body:SetPos(loc)
				body:SetAngles(angle)
				body:SetCollisionGroup(COLLISION_GROUP_NONE)
				body:Spawn()
				body:GetPhysicsObjectNum():EnableMotion(false)
			pl:EmitSound("npc/stalker/go_alert2a.wav")
			pl:SendLua( "surface.PlaySound( Sound( \"npc/stalker/go_alert2a.wav\" ) )" )
			timer.Simple(0.8, function()
				body:Remove()
				stay:Remove()
				pl:UnLock()
			end )
			end )
		
		end
		
		if ( #players > 0 ) then
			evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has scared ", evolve.colors.red, evolve:CreatePlayerList( players ), evolve.colors.white, "." )
		else
			evolve:Notify( ply, evolve.colors.red, evolve.constants.noplayers )
		end
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end


function PLUGIN:Menu( arg, players )
	if ( arg ) then
		RunConsoleCommand( "ev", "scare", unpack( players ) )
	else
		return "Scare", evolve.category.punishment
	end
end

evolve:RegisterPlugin( PLUGIN )