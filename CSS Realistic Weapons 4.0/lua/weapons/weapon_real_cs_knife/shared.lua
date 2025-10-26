if (SERVER) then

	AddCSLuaFile( "shared.lua" )
	SWEP.Weight				= 5
	SWEP.AutoSwitchTo			= false
	SWEP.AutoSwitchFrom		= false
	SWEP.HoldType			= "knife"

	local ActIndex = {}
		ActIndex[ "knife" ]		= ACT_HL2MP_IDLE_KNIFE

	function SWEP:SetWeaponHoldType( t )

		local index 								= ActIndex[ t ]
			
		if (index == nil) then
			return
		end

		self.ActivityTranslate 							= {}
		self.ActivityTranslate [ ACT_HL2MP_IDLE ] 			= index
		self.ActivityTranslate [ ACT_HL2MP_WALK ] 			= index + 1
		self.ActivityTranslate [ ACT_HL2MP_RUN ] 				= index + 2
		self.ActivityTranslate [ ACT_HL2MP_IDLE_CROUCH ] 		= index + 3
		self.ActivityTranslate [ ACT_HL2MP_WALK_CROUCH ] 		= index + 4
		self.ActivityTranslate [ ACT_HL2MP_GESTURE_RANGE_ATTACK ] 	= index + 5
		self.ActivityTranslate [ ACT_HL2MP_GESTURE_RELOAD ] 		= index + 6
		self.ActivityTranslate [ ACT_HL2MP_JUMP ] 			= index + 7
		self.ActivityTranslate [ ACT_RANGE_ATTACK1 ] 			= index + 8
	
		self:SetupWeaponHoldTypeForAI( t )
	end
end

if ( CLIENT ) then
	SWEP.PrintName			= "Knife"	
	SWEP.DrawAmmo 			= false
	SWEP.DrawCrosshair 		= true
	SWEP.ViewModelFOV			= 75
	SWEP.ViewModelFlip		= false
	SWEP.CSMuzzleFlashes		= false
	SWEP.DrawWeaponInfoBox 	= false
	
	
	SWEP.Slot				= 1
	SWEP.SlotPos			= 1
	SWEP.IconLetter			= "j"

	killicon.AddFont("weapon_real_cs_knife", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ))

	-- This is the font that's used to draw the death icons
	surface.CreateFont("csd", ScreenScale(30), 500, true, true, "CSKillIcons")
	-- This is the font that's used to draw the select icons
	surface.CreateFont("csd", ScreenScale(60), 500, true, true, "CSSelectIcons")
end


SWEP.IronSightsPos 			= Vector (-15.6937, -10.1535, -1.0596)
SWEP.IronSightsAng 			= Vector (46.9034, 9.0593, -90.2522)

SWEP.Category				= "CS:S Realistic Weapons"

SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.ViewModel 				= "models/weapons/v_knife_t.mdl"
SWEP.WorldModel 				= "models/weapons/w_knife_t.mdl" 

SWEP.Weight					= 5
SWEP.AutoSwitchTo				= false
SWEP.AutoSwitchFrom			= false

SWEP.Primary.Damage         = 45
SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = true
SWEP.Primary.Delay = 0.4
SWEP.Primary.Ammo       = "none"
SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = true
SWEP.Secondary.Ammo     = "none"
SWEP.Secondary.Delay = 1.4

SWEP.MissSound 				= Sound("weapons/knife/knife_slash1.wav")
SWEP.WallSound 				= Sound("weapons/knife/knife_hitwall1.wav")
SWEP.DeploySound				= Sound("weapons/knife/knife_deploy1.wav")

SWEP.IronSightsPos 			= Vector (-2.0423, -11.5056, 8.4193)
SWEP.IronSightsAng 			= Vector (-63.4059, 40.5195, 0)


/*---------------------------------------------------------
Initialize
---------------------------------------------------------*/
function SWEP:Initialize() 
   
 	if ( SERVER ) then 
 		self:SetWeaponHoldType( self.HoldType ) 
 	end 
	util.PrecacheSound("weapons/iceaxe/iceaxe_swing1.wav")
	util.PrecacheSound("weapons/knife/knife_hit1.wav")
	util.PrecacheSound("weapons/knife/knife_hit2.wav")
	util.PrecacheSound("weapons/knife/knife_hit3.wav")
	util.PrecacheSound("weapons/knife/knife_hit4.wav")	 

 end 

/*---------------------------------------------------------
Deploy
---------------------------------------------------------*/
function SWEP:Deploy()
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	self.Weapon:SetNextPrimaryFire(CurTime() + 1)
	self.Weapon:EmitSound( self.DeploySound, 50, 100 )
	return true
end

/*---------------------------------------------------------
SecondaryAttack
---------------------------------------------------------*/
function SWEP:SecondaryAttack() return end

/*---------------------------------------------------------
PrimaryAttack
---------------------------------------------------------*/
function SWEP:PrimaryAttack()

if !self.Owner then return end
 	local phtr = self.Owner:GetEyeTrace()
	if IsValid(phtr) then
		local ph = phtr.Entity:GetPhysicsObject()
	end
	self.Weapon:SetNextPrimaryFire(CurTime() + 0.4)	
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
			self.Weapon:EmitSound( "weapons/knife/knife_hit" .. math.random(1, 4) .. ".wav" )
			self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
			self.Owner:SetAnimation( PLAYER_ATTACK1 )
			
		else
		
			util.Decal("ManhackCut", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
		
			self.Weapon:EmitSound( self.WallSound )		
			self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
			self.Owner:SetAnimation( PLAYER_ATTACK1 )
			if not tr.HitWorld and not string.find(tr.Entity:GetClass(),"prop_static") then
				if SERVER then if IsValid(phtr) then ph:ApplyForceCenter(self.Owner:GetAimVector()*5000) end
				tr.Entity:TakeDamage(40, self.Owner, self)
				end
			end
			
		end
	else
		self.Weapon:EmitSound(self.MissSound,100,math.random(90,120))
		self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
		self.Owner:SetAnimation( PLAYER_ATTACK1 )
	end
	
end

/*---------------------------------------------------------
Reload
---------------------------------------------------------*/
function SWEP:Reload()

	return false
end

/*---------------------------------------------------------
OnRemove
---------------------------------------------------------*/
function SWEP:OnRemove()

return true
end

/*---------------------------------------------------------
Holster
---------------------------------------------------------*/
function SWEP:Holster()

	return true
end

/*---------------------------------------------------------
ShootEffects
---------------------------------------------------------*/
function SWEP:ShootEffects()

end

local IRONSIGHT_TIME = 0.15

/*---------------------------------------------------------
GetViewModelPosition
---------------------------------------------------------*/
function SWEP:GetViewModelPosition(pos, ang)
	if (not self.IronSightsPos) then return pos, ang end

	local bIron = self.Weapon:GetNWBool("Ironsights")

	if (bIron != self.bLastIron) then
		self.bLastIron = bIron
		self.fIronTime = CurTime()

		if (bIron) then
			self.SwayScale 	= 0.3
			self.BobScale 	= 0.1
		else
			self.SwayScale 	= 1.0
			self.BobScale 	= 1.0
		end
	end

	local fIronTime = self.fIronTime or 0

	if (not bIron and fIronTime < CurTime() - IRONSIGHT_TIME) then
		return pos, ang
	end

	local Mul = 1.0

	if (fIronTime > CurTime() - IRONSIGHT_TIME) then
		Mul = math.Clamp((CurTime() - fIronTime) / IRONSIGHT_TIME, 0, 1)

		if not bIron then Mul = 1 - Mul end
	end

	local Offset	= self.IronSightsPos

	if (self.IronSightsAng) then
		ang = ang * 1
		ang:RotateAroundAxis(ang:Right(), 		self.IronSightsAng.x * Mul)
		ang:RotateAroundAxis(ang:Up(), 		self.IronSightsAng.y * Mul)
		ang:RotateAroundAxis(ang:Forward(), 	self.IronSightsAng.z * Mul)
	end

	local Right 	= ang:Right()
	local Up 		= ang:Up()
	local Forward 	= ang:Forward()

	pos = pos + Offset.x * Right * Mul
	pos = pos + Offset.y * Forward * Mul
	pos = pos + Offset.z * Up * Mul

	return pos, ang
end


/*---------------------------------------------------------
SetIronsights
---------------------------------------------------------*/
function SWEP:SetIronsights(b)

	self.Weapon:SetNetworkedBool("Ironsights", b)
end

function SWEP:GetIronsights()

	return self.Weapon:GetNWBool("Ironsights")
end

SWEP.NextSecondaryAttack = 0