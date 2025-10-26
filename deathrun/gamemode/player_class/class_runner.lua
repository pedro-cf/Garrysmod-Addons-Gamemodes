local CLASS = {}

CLASS.DisplayName			= "Runner"
CLASS.WalkSpeed 			= 275
CLASS.RunSpeed				= 275
CLASS.JumpPower				= 200
CLASS.DrawTeamRing			= true
CLASS.TeammateNoCollide 	= true
CLASS.AvoidPlayers			= false
CLASS.DropWeaponOnDie		= false
CLASS.PlayerModel			= "models/player/kleiner.mdl"

function CLASS:OnSpawn( pl )
	
	// Gore
	
	for _, v in pairs( pl.SpawnRemoveEnts ) do
		
		if( v and v:IsValid() ) then
			
			v:Remove();
			
		end
		
	end
	
	pl.SpawnRemoveEnts = { };
	function pl.BuildBonePositions() end
	
end

function CLASS:Loadout( pl )
	
	pl:StripWeapons()
	if not table.HasValue(DrunMapsWithoutCrowbars, game.GetMap():lower() ) then
		pl:Give( "weapon_crowbar" )
	end
	
end

function CLASS:OnDeath( ply, attacker, dmginfo )

	if ( attacker:IsPlayer() and attacker:GetActiveWeapon():IsValid() ) then
		if attacker:GetActiveWeapon():GetClass() == "lightsaber" then
			ply:GibDeath()
			return
		elseif attacker:GetActiveWeapon():GetClass() == "weapon_katana" then
			ply:DecapitateDeath()
			return
		elseif attacker:GetActiveWeapon():GetClass() == "weapon_sythe" then
			ply:DecapitateDeath()
			return
		end
	end
	
	if( dmginfo:IsDamageType( DMG_SLASH ) or 
	attacker:GetClass() == "trigger_hurt" or
	attacker:GetClass() == "func_door" or 
	attacker:GetClass() == "func_rotating" or 
	attacker:GetClass() == "func_door_rotating" or 
	attacker:GetClass() == "worldspawn" or 
	attacker:GetClass() == "func_physbox" or 
	attacker:GetClass() == "func_movelinear" ) then
		
		ply:GibDeath();
		return;
		
	elseif ( dmginfo:IsDamageType( DMG_CRUSH ) ) then
		
		ply:CrushDeath();
		return;
		
	elseif ( dmginfo:IsDamageType( DMG_BURN ) ) then
		
		ply:BurnDeath();
		return;
		
	elseif ( dmginfo:IsDamageType( DMG_ENERGYBEAM ) ) then
		
		ply:DissolveDeath();
		return;
		
	elseif ( dmginfo:IsDamageType( DMG_CLUB ) )  then
		
		ply:DecapitateDeath();
		return;
		
	elseif ( dmginfo:IsDamageType( DMG_BLAST ) ) then
		
		ply:ExplodeDeath();
		return;
		
	end
	
	ply:CreateServCorpse()
	
end


player_class.Register( "Runner", CLASS )