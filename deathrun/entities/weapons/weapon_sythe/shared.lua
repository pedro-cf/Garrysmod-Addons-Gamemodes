if(SERVER) then
	AddCSLuaFile("shared.lua")
	SWEP.Weight			= 5
	SWEP.AutoSwitchTo	= true
	SWEP.AutoSwitchFrom	= true
end

if(CLIENT) then
	SWEP.PrintName			= "Sythe"
	SWEP.Slot				= 0
	SWEP.SlotPos			= 3
	SWEP.DrawAmmo			= false
	SWEP.DrawCrosshair		= true
	SWEP.DrawWeaponInfoBox 	= false
end

SWEP.Base = "weapon_base"

SWEP.ViewModel		= Model("models/weapons/v_sythe.mdl")
SWEP.WorldModel		= Model("models/weapons/w_sythe.mdl")

SWEP.HoldType		= "melee"

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.Mins = Vector(-8, -8, -8)
SWEP.Maxs = Vector(8, 8, 8)

SWEP.SoundSwing			= Sound("weapons/iceaxe/iceaxe_swing1.wav")
SWEP.DeploySound		= Sound("Weapon_Knife.Deploy")
SWEP.SlashSound			= Sound("Weapon_Knife.Slash")
SWEP.HitSound			= Sound("Weapon_Knife.Hit")
SWEP.HitSoundWall		= Sound("Weapon_Knife.HitWall")

SWEP.HitTable = {
	"prop_physics",
	"func_breakable"
}

function SWEP:Initialize()
	if(self.SetWeaponHoldType) then
		self:SetWeaponHoldType(self.HoldType)
	end
end

function SWEP:Deploy()
	self.Weapon:EmitSound(self.DeploySound)
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	return true
end

function SWEP:Holster()
	self.Weapon:SendWeaponAnim(ACT_VM_HOLSTER)
	return true
end

function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire(CurTime() + 0.4)
	
	local tr = util.TraceHull({
		start	= self.Owner:GetShootPos(),
		endpos 	= self.Owner:GetShootPos() + (self.Owner:GetAimVector() * 75),
		mins	= self.Mins,
		maxs	= self.Maxs,
		filter = self.Owner
	})
	
	local EmitSound = self.SlashSound
	
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
	
	if(tr.Hit) then
		if(IsValid(tr.Entity) and (tr.Entity:IsPlayer() or tr.Entity:IsNPC() or table.HasValue(self.HitTable, tr.Entity:GetClass()))) then
			EmitSound = self.HitSound
			if(SERVER) then
				tr.Entity:TakeDamage(math.random(70, 85), self.Owner)
			end
		else
			EmitSound = self.HitSoundWall
		end
	end
	
	if(IsFirstTimePredicted()) then
		self.Weapon:EmitSound(EmitSound)
	end
end

function SWEP:CanPrimaryAttack()
	return true
end

function SWEP:CanSecondaryAttack()
	return false
end

function SWEP:Reload()
	return false
end
