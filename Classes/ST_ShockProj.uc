// ===============================================================
// Stats.ST_ShockProj: put your comment here

// Created by UClasses - (C) 2000-2001 by meltdown@thirdtower.com
// ===============================================================

class ST_ShockProj extends ShockProj;

var ST_Mutator STM;

// For Standstill combo Special
var vector StartLocation;

var WeaponSettingsRepl WSettings;

simulated final function WeaponSettingsRepl FindWeaponSettings() {
	local WeaponSettingsRepl S;

	foreach AllActors(class'WeaponSettingsRepl', S)
		return S;

	return none;
}

simulated final function WeaponSettingsRepl GetWeaponSettings() {
	if (WSettings != none)
		return WSettings;

	WSettings = FindWeaponSettings();
	return WSettings;
}

simulated function PostBeginPlay()
{
	if (ROLE == ROLE_Authority)
	{
		StartLocation = Instigator.Location;
		ForEach AllActors(Class'ST_Mutator', STM)
			break;		// Find master :D
	}

	Super.PostBeginPlay();
}

function SuperExplosion()	// aka, combo.
{
	STM.PlayerUnfire(Instigator, 6);			// 6 = Shock Ball -> remove this
	STM.PlayerFire(Instigator, 7);				// 7 = Shock Combo -> Instigator gets +1 Combo
	STM.PlayerHit(Instigator, 7, Instigator.Location == StartLocation);	// 7 = Shock Combo, bSpecial if Standstill.
	HurtRadius(
		GetWeaponSettings().ShockComboDamage,
		GetWeaponSettings().ShockComboHurtRadius,
		MyDamageType,
		GetWeaponSettings().ShockComboMomentum*MomentumTransfer*2,
		Location);
	STM.PlayerClear();
	
	Spawn(Class'ut_ComboRing',,'',Location, Instigator.ViewRotation);
	PlaySound(ExploSound,,20.0,,2000,0.6);	
	
	Destroy(); 
}

function Explode(vector HitLocation,vector HitNormal)
{
	PlaySound(ImpactSound, SLOT_Misc, 0.5,,, 0.5+FRand());
	STM.PlayerHit(Instigator, 6, False);	// 6 = Shock Ball
	HurtRadius(
		GetWeaponSettings().ShockProjectileDamage,
		GetWeaponSettings().ShockProjectileHurtRadius,
		MyDamageType,
		GetWeaponSettings().ShockProjectileMomentum*MomentumTransfer,
		Location);
	STM.PlayerClear();
	if (GetWeaponSettings().ShockProjectileDamage > 60)
		Spawn(class'ut_RingExplosion3',,, HitLocation+HitNormal*8,rotator(HitNormal));
	else
		Spawn(class'ut_RingExplosion',,, HitLocation+HitNormal*8,rotator(Velocity));		

	Destroy();
}

function TakeDamage( int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, name DamageType)
{
	if (DamageType == 'shot')// || DamageType == 'Pulsed' ||		// Enforcer/Minigun/Sniper, Pulse Sphere
//		DamageType == 'Corroded' || DamageType == 'jolted')	// Bio and Shock Ball.
		STM.PlayerSpecial(Instigator, 6);	// 6 = Shock Ball blocked a shot.
}


defaultproperties {
}
