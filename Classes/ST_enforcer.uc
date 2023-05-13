// ===============================================================
// Stats.ST_enforcer: put your comment here

// Created by UClasses - (C) 2000-2001 by meltdown@thirdtower.com
// ===============================================================

class ST_enforcer extends enforcer;

var ST_Mutator STM;

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

function PostBeginPlay()
{
	Super.PostBeginPlay();

	ForEach AllActors(Class'ST_Mutator', STM)
		break;		// Find master :D
}

function ProcessTraceHit(Actor Other, Vector HitLocation, Vector HitNormal, Vector X, Vector Y, Vector Z)
{
	local UT_Shellcase s;
	local vector realLoc;
	local Pawn PawnOwner;
	local vector Momentum;
	local float Damage;

	PawnOwner = Pawn(Owner);
	STM.PlayerFire(PawnOwner, 3);			// 3 = Enforcer
	if (SlaveEnforcer != None)
		STM.PlayerSpecial(PawnOwner, 3);	// 3 = Enforcer, Slave enforcer is special.

	realLoc = Owner.Location + CalcDrawOffset();
	s = Spawn(class'UT_ShellCase',, '', realLoc + 20 * X + FireOffset.Y * Y + Z);
	if ( s != None )
		s.Eject(((FRand()*0.3+0.4)*X + (FRand()*0.2+0.2)*Y + (FRand()*0.3+1.0) * Z)*160);
	if (Other == Level)
	{
		if ( bIsSlave || (SlaveEnforcer != None) )
			Spawn(class'UT_LightWallHitEffect',,, HitLocation+HitNormal, Rotator(HitNormal));
		else
			Spawn(class'UT_WallHit',,, HitLocation+HitNormal, Rotator(HitNormal));
	}
	else if ((Other != self) && (Other != Owner) && (Other != None) )
	{
		if ( FRand() < 0.2 )
			X *= 5;

		Momentum = 3000.0 * X;
		if (Other.bIsPawn) {
			if (SlaveEnforcer == none && bIsSlave == false)
				Momentum *= STM.WeaponSettings.EnforcerMomentum;
			else
				Momentum *= STM.WeaponSettings.EnforcerMomentumDouble;
		}

		if (SlaveEnforcer == none && bIsSlave == false)
			Damage = STM.WeaponSettings.EnforcerDamage;
		else
			Damage = STM.WeaponSettings.EnforcerDamageDouble;

		STM.PlayerHit(PawnOwner, 3, False);	// 3 = Enforcer
		Other.TakeDamage(
			Damage,
			PawnOwner,
			HitLocation,
			Momentum,
			MyDamageType
		);
		STM.PlayerClear();
		if ( !Other.bIsPawn && !Other.IsA('Carcass') )
			spawn(class'UT_SpriteSmokePuff',,,HitLocation+HitNormal*9);
		else
			Other.PlaySound(Sound 'ChunkHit',, 4.0,,100);
	}
}

function bool HandlePickupQuery( inventory Item )
{
	if (GetWeaponSettings().EnforcerAllowDouble) {
		return super.HandlePickupQuery(Item);
	} else {
		return super(TournamentWeapon).HandlePickupQuery(Item);
	}
}

function SetSwitchPriority(pawn Other)
{	// Make sure "old" priorities are kept.
	local int i;
	local name temp, carried;

	if ( PlayerPawn(Other) != None )
	{
		// also set double switch priority

		for ( i=0; i<ArrayCount(PlayerPawn(Other).WeaponPriority); i++)
			if ( PlayerPawn(Other).WeaponPriority[i] == 'doubleenforcer' )
			{
				DoubleSwitchPriority = i;
				break;
			}

		for ( i=0; i<ArrayCount(PlayerPawn(Other).WeaponPriority); i++)
			if ( IsA(PlayerPawn(Other).WeaponPriority[i]) )		// <- The fix...
			{
				AutoSwitchPriority = i;
				return;
			}
		// else, register this weapon
		carried = 'enforcer';
		for ( i=AutoSwitchPriority; i<ArrayCount(PlayerPawn(Other).WeaponPriority); i++ )
		{
			if ( PlayerPawn(Other).WeaponPriority[i] == '' )
			{
				PlayerPawn(Other).WeaponPriority[i] = carried;
				return;
			}
			else if ( i<ArrayCount(PlayerPawn(Other).WeaponPriority)-1 )
			{
				temp = PlayerPawn(Other).WeaponPriority[i];
				PlayerPawn(Other).WeaponPriority[i] = carried;
				carried = temp;
			}
		}


	}
}

simulated function PlayFiring() {
	local float AnimSpeed;
	if (SlaveEnforcer == none && bIsSlave == false)
		AnimSpeed = GetWeaponSettings().EnforcerReloadAnimSpeed();
	else
		AnimSpeed = GetWeaponSettings().EnforcerReloadDoubleAnimSpeed();

	PlayOwnedSound(FireSound, SLOT_None,2.0*Pawn(Owner).SoundDampening);
	bMuzzleFlash++;
	PlayAnim('Shoot', AnimSpeed * (0.5 + 0.31 * FireAdjust), 0.02);
}

simulated function PlayAltFiring() {
	local float AnimSpeed;
	if (SlaveEnforcer == none && bIsSlave == false)
		AnimSpeed = GetWeaponSettings().EnforcerReloadAltAnimSpeed();
	else
		AnimSpeed = GetWeaponSettings().EnforcerReloadAltDoubleAnimSpeed();

	PlayAnim('T1', AnimSpeed * 1.3, 0.05);
	bFirstFire = true;
}

simulated function PlayRepeatFiring() {
	local float AnimSpeed;
	if (SlaveEnforcer == none && bIsSlave == false)
		AnimSpeed = GetWeaponSettings().EnforcerReloadRepeatAnimSpeed();
	else
		AnimSpeed = GetWeaponSettings().EnforcerReloadRepeatDoubleAnimSpeed();

	if ((PlayerPawn(Owner) != None)
		&& ((Level.NetMode == NM_Standalone) || PlayerPawn(Owner).Player.IsA('ViewPort')))
	{
		if (InstFlash != 0.0)
			PlayerPawn(Owner).ClientInstantFlash( -0.2, vect(325, 225, 95));
		PlayerPawn(Owner).ShakeView(ShakeTime, ShakeMag, ShakeVert);
	}
	if ( Affector != None )
		Affector.FireEffect();
	bMuzzleFlash++;
	PlayOwnedSound(FireSound, SLOT_None,2.0*Pawn(Owner).SoundDampening);
	PlayAnim('Shot2', AnimSpeed * (0.7 + 0.3 * FireAdjust), 0.05);
}

simulated function PlaySelect() {
	bForceFire = false;
	bForceAltFire = false;
	bCanClientFire = false;
	if (!IsAnimating() || (AnimSequence != 'Select'))
		PlayAnim('Select', GetWeaponSettings().EnforcerSelectAnimSpeed(), 0.0);
	Owner.PlaySound(SelectSound, SLOT_Misc, Pawn(Owner).SoundDampening);	
}

simulated function TweenDown() {
	local float TweenTime;

	TweenTime = 0.05;
	if (Owner != none && Owner.IsA('bbPlayer') && bbPlayer(Owner).IGPlus_UseFastWeaponSwitch)
		TweenTime = 0.00;

	if (IsAnimating() && (AnimSequence != '') && (GetAnimGroup(AnimSequence) == 'Select'))
		TweenAnim( AnimSequence, AnimFrame * GetWeaponSettings().EnforcerDownTime );
	else
		PlayAnim('Down', GetWeaponSettings().EnforcerDownAnimSpeed(), TweenTime);
}

state NormalFire {
ignores Fire, AltFire, AnimEnd;

Begin:
	FlashCount++;
	if (SlaveEnforcer != none)
		SetTimer(GetWeaponSettings().EnforcerShotOffsetDouble, false);
	FinishAnim();
	if (bIsSlave)
		GotoState('Idle');
	else 
		Finish();
}

state ClientFiring {
	simulated function BeginState() {
		Super(TournamentWeapon).BeginState();
		if (SlaveEnforcer != None)
			SetTimer(GetWeaponSettings().EnforcerShotOffsetDouble, false);
		else 
			SetTimer(0.5, false);
	}
}

state AltFiring {
ignores Fire, AltFire, AnimEnd;

Begin:
	if (SlaveEnforcer != none)
		SetTimer(GetWeaponSettings().EnforcerShotOffsetDouble, false);
	FinishAnim();
Repeater:	
	if (AmmoType.UseAmmo(1)) {
		FlashCount++;
		if ( SlaveEnforcer != None )
			Pawn(Owner).PlayRecoil(3 * FiringSpeed);
		else if (!bIsSlave)
			Pawn(Owner).PlayRecoil(1.5 * FiringSpeed);
		TraceFire(AltAccuracy);
		PlayRepeatFiring();
		FinishAnim();
	}

	if (AltAccuracy < 3)
		AltAccuracy += 0.5;
	if (bIsSlave) {
		if ((Pawn(Owner).bAltFire!=0) && AmmoType.AmmoAmount>0)
			Goto('Repeater');
	}
	else if (bChangeWeapon)
		GotoState('DownWeapon');
	else if ((Pawn(Owner).bAltFire!=0) && AmmoType.AmmoAmount>0) {
		if (PlayerPawn(Owner) == None)
			Pawn(Owner).bAltFire = int(FRand() < AltReFireRate);
		Goto('Repeater');
	}
	PlayAnim('T2', 0.9, 0.05);
	FinishAnim();
	Finish();
}

state ClientAltFiring {
	simulated function BeginState() {
		Super(TournamentWeapon).BeginState();
		if ( SlaveEnforcer != None )
			SetTimer(GetWeaponSettings().EnforcerShotOffsetDouble, false);
		else 
			SetTimer(0.5, false);
	}
}

defaultproperties {
}
