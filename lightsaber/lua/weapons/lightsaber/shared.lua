
if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
	
	
end

if ( CLIENT ) then
	
	SWEP.DrawWeaponInfoBox 	= false
	SWEP.PrintName			= "Lightsaber"			
	SWEP.Slot				= 1
	SWEP.SlotPos			= 1
	SWEP.IconLetter			= "f"
	SWEP.DrawCrosshair		= true
	
        killicon.AddFont( "weapon_knife", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )


end

-----------------------Main functions----------------------------
 
-- function SWEP:Reload() --To do when reloading
-- end 
 
function SWEP:Initialize()
	util.PrecacheSound("weapons/ls/lightsaber_swing.wav")
	util.PrecacheSound("weapons/ls/saberon.wav")
	util.PrecacheSound("weapons/ls/saberoff.wav")
	util.PrecacheSound("weapons/ls/ltsaberhit02.wav")
	self:SetWeaponHoldType("melee") 
end
 
function SWEP:PrimaryAttack()
	if !self.Owner then return end
 	local phtr = self.Owner:GetEyeTrace()
	if IsValid(phtr) then
		local ph = phtr.Entity:GetPhysicsObject()
	end
	self.Weapon:SetNextPrimaryFire(CurTime() + 0.35)	
	local trace = util.GetPlayerTrace(self.Owner)
 	local tr = util.TraceLine(trace)
	if (self.Owner:GetPos() - tr.HitPos):Length() < 110 then
		if tr.Entity:IsPlayer() or string.find(tr.Entity:GetClass(),"npc") or string.find(tr.Entity:GetClass(),"prop_ragdoll") or tr.MatType == MAT_FLESH or tr.MatType == MAT_ALIENFLESH or tr.MatType == MAT_ANTLION then
					bullet = {}
					bullet.Num    = 1
					bullet.Src    = self.Owner:GetShootPos()
					bullet.Dir    = self.Owner:GetAimVector()
					bullet.Spread = Vector(0, 0, 0)
					bullet.Tracer = 0
					bullet.Force  = 20
					bullet.Damage = 48
				self.Owner:FireBullets(bullet) 
			self.Weapon:EmitSound("weapons/ls/ltsaberhit02.wav")
			self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
			self.Owner:SetAnimation( PLAYER_ATTACK1 )
			
		else
		
			util.Decal("ManhackCut", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
		
			self.Weapon:EmitSound("weapons/ls/ltsaberhit02.wav")
			self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
			self.Owner:SetAnimation( PLAYER_ATTACK1 )
			if not tr.HitWorld and not string.find(tr.Entity:GetClass(),"prop_static") then
				if SERVER then if IsValid(phtr) then ph:ApplyForceCenter(self.Owner:GetAimVector()*5000) end
				tr.Entity:TakeDamage(100, self.Owner, self)
				end
			end
			
		end
	else
		self.Weapon:EmitSound("weapons/ls/lightsaber_swing.wav")
		self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
		self.Owner:SetAnimation( PLAYER_ATTACK1 )
	end
end

/*---------------------------------------------------------
		SecondaryAttack
---------------------------------------------------------*/
function SWEP:SecondaryAttack() return end



-------------------------------------------------------------------

------------General Swep Info---------------
SWEP.Spawnable      = false
SWEP.AdminSpawnable  = true
-----------------------------------------------

------------Models---------------------------
SWEP.ViewModel      = "models/weapons/v_crewbar.mdl"
SWEP.WorldModel   = "models/weapons/v_crewbar.mdl"
-----------------------------------------------

-------------Primary Fire Attributes----------------------------------------
SWEP.Primary.Delay			= 0.25	--In seconds
SWEP.Primary.Recoil			= 0		--Gun Kick
SWEP.Primary.NumShots		= 1		--Number of shots per one fire
SWEP.Primary.Cone			= 0 	--Bullet Spread
SWEP.Primary.ClipSize		= -1	--Use "-1 if there are no clips"
SWEP.Primary.DefaultClip	= -1	--Number of shots in next clip
SWEP.Primary.Automatic   	= true	--Pistol fire (false) or SMG fire (true)
SWEP.Primary.Ammo         	= "none"	--Ammo Type
-------------End Primary Fire Attributes------------------------------------
 
-------------Secondary Fire Attributes-------------------------------------
SWEP.Secondary.Delay		= 120
SWEP.Secondary.Recoil		= 0
SWEP.Secondary.Damage		= 0
SWEP.Secondary.NumShots		= 1
SWEP.Secondary.Cone			= 0
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic   	= true
SWEP.Secondary.Ammo         = "none"
-------------End Secondary Fire Attributes--------------------------------
function SWEP:Deploy()
	self.Weapon:EmitSound( "weapons/ls/saberon.wav" )
	return true
end

	
function SWEP:Holster( wep )
	self.Weapon:EmitSound( "weapons/ls/saberoff.wav" )
	return true
end
