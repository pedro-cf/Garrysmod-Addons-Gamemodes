local meta = FindMetaTable( "Player" );
local emeta = FindMetaTable( "Entity" );

GibAmt = 12; -- formerly 20

hook.Add( "ShouldCollide", "CorpseBloodDecal", function( ent1, ent2 )
	
	if ent1:IsWorld() then
		if util.IsValidRagdoll( ent2:GetModel() ) and !ent2:IsPlayer() then
			if !ent2.Decals then
				ent2.Decals = 0
			end
			if ent2.Decals < 22 then
				KCreateDeathEffect(ent2, false)
				ent2.Decals = ent2.Decals + 1
			end
		end
	elseif ent2:IsWorld() then
		if util.IsValidRagdoll( ent1:GetModel() ) and !ent1:IsPlayer() then
			if !ent1.Decals then
				ent1.Decals = 0
			end
			if ent1.Decals < 22 then
				KCreateDeathEffect(ent1, false)
				ent1.Decals = ent1.Decals + 1
			end
		end
	end

end )

function meta:CreateServCorpse()
	if !IsValid(self) then return end
	if !self:IsPlayer() then return end
	if !self:Alive() then return end
	
	local vec = self:GetVelocity()
	local plyRag = ents.Create("prop_ragdoll")
	plyRag:SetModel(self:GetModel())
	plyRag:SetPos(self:GetPos())
	plyRag:Spawn()
	for i = 0, plyRag:GetPhysicsObjectCount() -1 do
		local ragBone = plyRag:GetPhysicsObjectNum(i)
		local boneID = plyRag:TranslatePhysBoneToBone(ragBone)
		local bonePos, boneAng = self:GetBonePosition(boneID)
		ragBone:SetPos(bonePos)
		ragBone:SetAngle(boneAng)
		ragBone:Wake()
		ragBone:SetVelocity( vec/2 )
	end
	SafeRemoveEntityDelayed(plyRag, 10)
	self.SRag = plyRag
	timer.Simple( 9.9, function()
		self.SRag = nil
	end )
end

function util.PaintDown(start, effname, ignore)
   local btr = util.TraceLine({start=start, endpos=(start + Vector(0,0,-256)), filter=ignore, mask=MASK_SOLID})

   util.Decal(effname, btr.HitPos+btr.HitNormal, btr.HitPos-btr.HitNormal)
end

function KCreateDeathEffect(ent, marked)
   local pos = ent:GetPos() + Vector(0, 0, 20)

   local jit = 35.0

   local jitter = Vector(math.Rand(-jit, jit), math.Rand(-jit, jit), 0)
   util.PaintDown(pos + jitter, "Blood", ent)

   if marked then
      util.PaintDown(pos, "Cross", ent)
   end
end

function meta:GibDeath()
	
	local origin = self:GetPos();
	local vel = self:GetVelocity();
	
	umsg.Start( "msgGibFX" );
		umsg.Vector( origin );
	umsg.End();
	
	for _ = 1, GibAmt do
		
		local ent = ents.Create( "cube_gib" )
		ent:SetPos( Vector( origin.x, origin.y, math.random( origin.z, origin.z + 72 ) ) )
		ent:Spawn()
		local phys = ent:GetPhysicsObject()
		if phys:IsValid() then
				phys:SetVelocity( vel ) 
		end
		
		table.insert( self.SpawnRemoveEnts, ent );
		 SafeRemoveEntityDelayed( ent, 6 )
	end
	
end

function meta:BurnDeath()
	
	self:SetModel( "models/Humans/Charple01.mdl" );
	self:CreateServCorpse()
	
	local rag = self.SRag
	rag:Ignite( 10, 0 );
	
end

function meta:ExplodeDeath()
	
	local origin = self:GetPos();
	local vel = self:GetVelocity();
	
	umsg.Start( "msgGibFX" );
		umsg.Vector( origin );
	umsg.End();
	
	for _ = 1, GibAmt do
		
		local ent = ents.Create( "cube_gib" );
		ent:SetPos( Vector( origin.x, origin.y, math.random( origin.z, origin.z + 72 ) ) );
		ent:Spawn();
		local rdm = math.random(1,3)
		if rdm == 2 then
			ent:Ignite( 10, 0 );
		end
		local phys = ent:GetPhysicsObject()
		if phys:IsValid() then
				phys:SetVelocity( vel ) 
		end
		
		table.insert( self.SpawnRemoveEnts, ent );
		SafeRemoveEntityDelayed( ent, 6 )
	end
	
end

function meta:DissolveDeath()
	
	self:CreateServCorpse()
	
	local ent = self.SRag
	
	local dissolve = ents.Create( "env_entity_dissolver" );
	dissolve:SetPos( ent:GetPos() );
	
	ent:SetName( tostring( ent ) );
	dissolve:SetKeyValue( "target", ent:GetName() );
	
	dissolve:SetKeyValue( "dissolvetype", "0" );
	dissolve:Spawn();
	dissolve:Fire( "Dissolve", "", 0 );
	dissolve:Fire( "kill", "", 1 );
	
end

function meta:CrushDeath()
	
	local origin = self:EyePos();
	
	local traceDiffs = { };
	
	for i = 0, 40, 5 do
		
		for j = 0, 360, 45 do
			
			local x = math.cos( j ) * i;
			local y = math.sin( j ) * i;
			table.insert( traceDiffs, Vector( x, y, 0 ) );
			
		end
		
	end
	
	for _, v in pairs( traceDiffs ) do -- splat
		
		local trace = { };
		trace.start = origin;
		trace.endpos = trace.start - Vector( 0, 0, 72 );
		trace.filter = self;
		
		local tr = util.TraceLine( trace );
		
		tr.HitPos = tr.HitPos + v;
		
		util.Decal( "Blood", tr.HitPos - tr.HitNormal, tr.HitPos + tr.HitNormal );
		
	end
	
end

function emeta:GibBodyPart( bone, mdl )
	
	local look = bone;
	if( type( bone ) == "string" ) then
		look = self:LookupBone( bone );
	end
	
	local matrix = self:GetBoneMatrix( look );
	local pos = matrix:GetTranslation();
	
	umsg.Start( "msgRemoveRagBone" );
		umsg.Short( look );
		umsg.Entity( self );
	umsg.End();
	
	umsg.Start( "msgDecapFX" );
		umsg.Vector( pos );
	umsg.End();
	
	if( mdl ) then
		
		local ent = ents.Create( "cube_gib" );
		ent:SetPos( pos );
		ent:SetModel( mdl );
		ent:Spawn();
		
		table.insert( self.SpawnRemoveEnts, ent );
		SafeRemoveEntityDelayed( ent, 6 )
	end
	
end

function meta:DecapitateDeath()
	
	self:CreateServCorpse();
	local rag = self.SRag;
	local attach = rag:LookupAttachment( "forward" );
	local angpos = rag:GetAttachment( attach );
	--[[
	umsg.Start( "msgDecapFX" );
		umsg.Vector( angpos.Pos );
	umsg.End();--]]
	
	local e = ents.Create( "info_particle_system" );
	e:SetPos( rag:EyePos() );
	e:SetKeyValue( "effect_name", "blood_advisor_puncture_withdraw" );
	e:SetKeyValue( "start_active", "1" );
	e:Spawn();
	e:Activate();
	e:SetParent( rag );
	
	table.insert( self.SpawnRemoveEnts, e );
	
	timer.Simple( 0.1, function()
		
		rag:GibBodyPart( 6 );
		
	end );
	
end
