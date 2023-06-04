class NN_CGShock_Rifle extends ShockRifle;

#exec TEXTURE IMPORT NAME=TRED_ASMD_t  FILE=Textures\ShockRifle\TRED_ASMD_t.PCX  LODSET=2
#exec TEXTURE IMPORT NAME=TRED_ASMD_t1 FILE=Textures\ShockRifle\TRED_ASMD_t1.PCX LODSET=2
#exec TEXTURE IMPORT NAME=TRED_ASMD_t2 FILE=Textures\ShockRifle\TRED_ASMD_t2.PCX LODSET=2
#exec TEXTURE IMPORT NAME=TRED_ASMD_t3 FILE=Textures\ShockRifle\TRED_ASMD_t3.PCX LODSET=2
#exec TEXTURE IMPORT NAME=TRED_ASMD_t4 FILE=Textures\ShockRifle\TRED_ASMD_t4.PCX LODSET=2

#exec TEXTURE IMPORT NAME=TBLUE_ASMD_t  FILE=Textures\ShockRifle\TBLUE_ASMD_t.PCX  LODSET=2
#exec TEXTURE IMPORT NAME=TBLUE_ASMD_t1 FILE=Textures\ShockRifle\TBLUE_ASMD_t1.PCX LODSET=2
#exec TEXTURE IMPORT NAME=TBLUE_ASMD_t2 FILE=Textures\ShockRifle\TBLUE_ASMD_t2.PCX LODSET=2
#exec TEXTURE IMPORT NAME=TBLUE_ASMD_t3 FILE=Textures\ShockRifle\TBLUE_ASMD_t3.PCX LODSET=2
#exec TEXTURE IMPORT NAME=TBLUE_ASMD_t4 FILE=Textures\ShockRifle\TBLUE_ASMD_t4.PCX LODSET=2

#exec TEXTURE IMPORT NAME=TGOLD_ASMD_t  FILE=Textures\ShockRifle\TGOLD_ASMD_t.PCX  LODSET=2
#exec TEXTURE IMPORT NAME=TGOLD_ASMD_t1 FILE=Textures\ShockRifle\TGOLD_ASMD_t1.PCX LODSET=2
#exec TEXTURE IMPORT NAME=TGOLD_ASMD_t2 FILE=Textures\ShockRifle\TGOLD_ASMD_t2.PCX LODSET=2
#exec TEXTURE IMPORT NAME=TGOLD_ASMD_t3 FILE=Textures\ShockRifle\TGOLD_ASMD_t3.PCX LODSET=2
#exec TEXTURE IMPORT NAME=TGOLD_ASMD_t4 FILE=Textures\ShockRifle\TGOLD_ASMD_t4.PCX LODSET=2

#exec TEXTURE IMPORT NAME=TGREEN_ASMD_t  FILE=Textures\ShockRifle\TGREEN_ASMD_t.PCX  LODSET=2
#exec TEXTURE IMPORT NAME=TGREEN_ASMD_t1 FILE=Textures\ShockRifle\TGREEN_ASMD_t1.PCX LODSET=2
#exec TEXTURE IMPORT NAME=TGREEN_ASMD_t2 FILE=Textures\ShockRifle\TGREEN_ASMD_t2.PCX LODSET=2
#exec TEXTURE IMPORT NAME=TGREEN_ASMD_t3 FILE=Textures\ShockRifle\TGREEN_ASMD_t3.PCX LODSET=2
#exec TEXTURE IMPORT NAME=TGREEN_ASMD_t4 FILE=Textures\ShockRifle\TGREEN_ASMD_t4.PCX LODSET=2

var bool bNewNet;
var Vector CDO;
var float yMod;
var float LastFiredTime;
var name ST_MyDamageType;

var bool 	bTeamColor;
var bool 	bTeamColorPrev;

var class<NN_CGShock_ProjOwnerHidden> AltProjectileHiddenClass;

simulated event Tick( float DeltaTime )
{
	local bbPlayer bbP;
	
	super.Tick(DeltaTime);
	
	if (Level.NetMode != NM_DedicatedServer) {
		bbP = bbPlayer(Owner);
		if (bbP!=None) {
			bTeamColor=bbP.Settings.bTeamColoredShockRifle;
			if(bTeamColorPrev!=bTeamColor) {
				if(UpdateWeaponSkin(bbP)) bTeamColorPrev = bTeamColor;
			}
		}
	}
}

// try to update WeaponSkins, return True on success 
simulated function bool UpdateWeaponSkin(bbPlayer bbP) {
	local int 	iTeamIdx;

	if (bbP.Settings.bTeamColoredShockRifle)
		bTeamColor=bbP.Settings.bTeamColoredShockRifle;
	
	if(bTeamColor) {
		if(Pawn(Owner).PlayerReplicationInfo==None) 
			return False;
		iTeamIdx = Pawn(Owner).PlayerReplicationInfo.Team;
		if(bNetOwner)
		{
			switch(iTeamIdx) {
				case 0:
					MultiSkins[0] = Texture'TRED_ASMD_t1';
					MultiSkins[1] = Texture'TRED_ASMD_t2';
					MultiSkins[2] = Texture'TRED_ASMD_t3';
					MultiSkins[3] = Texture'TRED_ASMD_t4';
					break;
				case 1:
					MultiSkins[0] = Texture'TBLUE_ASMD_t1';
					MultiSkins[1] = Texture'TBLUE_ASMD_t2';
					MultiSkins[2] = Texture'TBLUE_ASMD_t3';
					MultiSkins[3] = Texture'TBLUE_ASMD_t4';
					break;
				case 2:
					MultiSkins[0] = Texture'TGREEN_ASMD_t1';
					MultiSkins[1] = Texture'TGREEN_ASMD_t2';
					MultiSkins[2] = Texture'TGREEN_ASMD_t3';
					MultiSkins[3] = Texture'TGREEN_ASMD_t4';
					break;
				case 3:
					MultiSkins[0] = Texture'TGOLD_ASMD_t1';
					MultiSkins[1] = Texture'TGOLD_ASMD_t2';
					MultiSkins[2] = Texture'TGOLD_ASMD_t3';
					MultiSkins[3] = Texture'TGOLD_ASMD_t4';
					break;
			}
		}
		else
		{
			switch(iTeamIdx) {
				case 0:
					MultiSkins[1] = Texture'TRED_ASMD_t';
					break;
				case 1:
					MultiSkins[1] = Texture'TBLUE_ASMD_t';
					break;
				case 2:
					MultiSkins[1] = Texture'TGREEN_ASMD_t';
					break;
				case 3:
					MultiSkins[1] = Texture'TGOLD_ASMD_t';
					break;
			}
		}
	}
	else {
		MultiSkins[0] = None;
		MultiSkins[1] = None;
		MultiSkins[2] = None;
		MultiSkins[3] = None;
	}
	
	return True;
}

simulated function PlaySelect()
{
	Class'NN_WeaponFunctions'.static.PlaySelect( self);
	//UpdateWeaponSkin();
}

simulated function RenderOverlays(Canvas Canvas)
{
	local bbPlayer bbP;

	Super.RenderOverlays(Canvas);
	yModInit();

	bbP = bbPlayer(Owner);
	if (bNewNet && Role < ROLE_Authority && bbP != None)
	{
		if (bbP.bFire != 0 && !IsInState('ClientFiring')) {
			ClientFire(1);
		} else if (bbP.bAltFire != 0 && !IsInState('ClientAltFiring')) {
			ClientAltFire(1);
		}
	}
}

simulated function yModInit()
{
	local bbPlayer P;
	P = bbPlayer(Owner);

	if (P == None)
		return;

	yMod = P.Handedness;
	if (yMod != 2.0)
		yMod *= Default.FireOffset.Y;
	else
		yMod = 0;

	CDO = class'NN_WeaponFunctions'.static.IGPlus_CalcDrawOffset(P, self);
}

simulated function bool ClientFire(float Value)
{
	local bbPlayer bbP;
	local bool Result;

	if (Owner.IsA('Bot'))
		return Super.ClientFire(Value);

	class'NN_WeaponFunctions'.static.IGPlus_BeforeClientFire(self);

	if (AmmoType == None)
		AmmoType = Ammo(Pawn(Owner).FindInventoryType(AmmoName));

	bbP = bbPlayer(Owner);
	if (Role < ROLE_Authority && bbP != None && bNewNet)
	{
		if (bbP.ClientCannotShoot() || bbP.Weapon != Self || Level.TimeSeconds - LastFiredTime < 0.8) {
			class'NN_WeaponFunctions'.static.IGPlus_AfterClientFire(self);
			return false;
		}
		if ( (AmmoType == None) && (AmmoName != None) )
		{
			// ammocheck
			GiveAmmo(Pawn(Owner));
		}
		if ( AmmoType.AmmoAmount > 0 )
		{
			Instigator = Pawn(Owner);
			GotoState('ClientFiring');
			bPointing=True;
			bCanClientFire = true;
			if ( bRapidFire || (FiringSpeed > 0) )
				Pawn(Owner).PlayRecoil(FiringSpeed);
			NN_TraceFire();
			LastFiredTime = Level.TimeSeconds;
		}
	}
	Result = Super.ClientFire(Value);

	class'NN_WeaponFunctions'.static.IGPlus_AfterClientFire(self);

	return Result;
}

simulated function bool ClientAltFire(float Value) {

	local bbPlayer bbP;
	local bool Result;

	if (Owner.IsA('Bot'))
		return Super.ClientAltFire(Value);

	class'NN_WeaponFunctions'.static.IGPlus_BeforeClientAltFire(self);

	if (AmmoType == None)
		AmmoType = Ammo(Pawn(Owner).FindInventoryType(AmmoName));

	bbP = bbPlayer(Owner);
	if (Role < ROLE_Authority && bbP != None && bNewNet)
	{
		if (bbP.ClientCannotShoot() || bbP.Weapon != Self || Level.TimeSeconds - LastFiredTime < 0.4) {
			class'NN_WeaponFunctions'.static.IGPlus_AfterClientAltFire(self);
			return false;
		}
		if ( (AmmoType == None) && (AmmoName != None) )
		{
			// ammocheck
			GiveAmmo(Pawn(Owner));
		}
		if ( AmmoType.AmmoAmount > 0 )
		{
			Instigator = Pawn(Owner);
			GotoState('AltFiring');
			bCanClientFire = true;
			Pawn(Owner).PlayRecoil(FiringSpeed);
			bPointing=True;
			NN_ProjectileFire(AltProjectileClass, AltProjectileSpeed, bAltWarnTarget);
			LastFiredTime = Level.TimeSeconds;
		}
	}
	Result = Super.ClientAltFire(Value);

	class'NN_WeaponFunctions'.static.IGPlus_AfterClientAltFire(self);

	return Result;
}

function Projectile ProjectileFire(class<projectile> ProjClass, float ProjSpeed, bool bWarn)
{
	local Vector Start, X,Y,Z;
	local PlayerPawn PlayerOwner;
	local bbPlayer bbP;
	local Projectile Proj;
	local NN_CGShock_Proj ST_Proj;
	
	if (Owner.IsA('Bot'))
		return Super.ProjectileFire(ProjClass, ProjSpeed, bWarn);

	PlayerOwner = PlayerPawn(Owner);
	bbP = bbPlayer(Owner);
	if (bbP == None || !bNewNet)
	{
		return Super.ProjectileFire(ProjClass,ProjSpeed,bWarn);
	}
	
	Owner.MakeNoise(Pawn(Owner).SoundDampening);

	GetAxes(bbP.zzNN_ViewRot,X,Y,Z);
	if (Mover(bbP.Base) == None)
		Start = bbP.zzNN_ClientLoc + CalcDrawOffset() + FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z; 
	else
		Start = Owner.Location + CalcDrawOffset() + FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z; 

	AdjustedAim = pawn(owner).AdjustAim(ProjSpeed, Start, AimError, True, bWarn);	

	if ( PlayerOwner != None )
		PlayerOwner.ClientInstantFlash( -0.4, vect(450, 190, 650));
	
	Proj = Spawn(ProjClass,Owner,, Start,AdjustedAim);
	ST_Proj = NN_CGShock_Proj(Proj);
	
	return Proj;
}

simulated function Projectile NN_ProjectileFire(class<projectile> ProjClass, float ProjSpeed, bool bWarn)
{
	local Vector Start, X,Y,Z;
	local PlayerPawn PlayerOwner;
	local Projectile Proj;
	local NN_CGShock_Proj ST_Proj;
	local int ProjIndex;
	local bbPlayer bbP;
	
	if (Owner.IsA('Bot'))
		return None;

	yModInit();

	bbP = bbPlayer(Owner);
	if (bbP == None)
		return None;

	GetAxes(bbP.ViewRotation,X,Y,Z);
	Start = Owner.Location + CDO + FireOffset.X * X + yMod * Y + FireOffset.Z * Z;
	if ( PlayerOwner != None )
		PlayerOwner.ClientInstantFlash( -0.4, vect(450, 190, 650));
	
	Proj = Spawn(ProjClass,Owner,, Start,bbP.ViewRotation);
	Proj.RemoteRole = ROLE_None;
	
	ST_Proj = NN_CGShock_Proj(Proj);
	ProjIndex = bbP.xxNN_AddProj(Proj);

	if (ST_Proj != None)
	{
		ST_Proj.zzNN_ProjIndex 	= ProjIndex;
	}
		
	bbP.xxNN_AltFire(Level.TimeSeconds, ProjIndex, bbP.Location, bbP.Velocity, bbP.ViewRotation);
	bbP.xxClientDemoFix(ST_Proj, Class'ShockProj', Start, ST_Proj.Velocity, Proj.Acceleration, bbP.ViewRotation);
}


function Fire( float Value )
{
	local bbPlayer bbP;

	if (Owner.IsA('Bot'))
	{
		Super.Fire(Value);
		return;
	}

	bbP = bbPlayer(Owner);
	if (bbP != None && bNewNet && Value < 1)
		return;
		
	Super.Fire(Value);
}

simulated function PlayFiring()
{
	PlayOwnedSound(FireSound, SLOT_None, Pawn(Owner).SoundDampening*4.0);
	PlayAnim('Fire1', 0.2 + 0.2 * FireAdjust,0.05);
}

simulated function PlayAltFiring()
{
	PlayOwnedSound(AltFireSound, SLOT_None, Pawn(Owner).SoundDampening*4.0);
	PlayAnim('Fire2', 0.3 + 0.3 * FireAdjust,0.05);
}

	
function AltFire( float Value )
{
	local actor HitActor;
	local vector HitLocation, HitNormal, Start;
	local bbPlayer bbP;
	local NN_ShockProjOwnerHidden NNSP;

	if (Owner.IsA('Bot'))
	{
		Super.AltFire(Value);
		return;
	}

	bbP = bbPlayer(Owner);
	if (bbP != None && bNewNet && Value < 1)
		return;

	if ( Owner == None )
		return;

	if ( Owner.IsA('Bot') ) //make sure won't blow self up
	{
		Start = Owner.Location + CalcDrawOffset() + FireOffset.Z * vect(0,0,1);
		if ( Pawn(Owner).Enemy != None )
			HitActor = Trace(HitLocation, HitNormal, Start + 250 * Normal(Pawn(Owner).Enemy.Location - Start), Start, false, vect(12,12,12));
		else
			HitActor = self;
		if ( HitActor != None )
		{
			Global.Fire(Value);
			return;
		}
	}

	GotoState('AltFiring');
	bCanClientFire = true;
	if ( Owner.IsA('Bot') )
	{
		if ( Owner.IsInState('TacticalMove') && (Owner.Target == Pawn(Owner).Enemy)
		 && (Owner.Physics == PHYS_Walking) && !Bot(Owner).bNovice
		 && (FRand() * 6 < Pawn(Owner).Skill) )
			Pawn(Owner).SpecialFire();
	}
	bPointing=True;
	ClientAltFire(value);
	if (bNewNet)
	{
		NNSP = NN_ShockProjOwnerHidden(ProjectileFire(AltProjectileHiddenClass, AltProjectileSpeed, bAltWarnTarget));
		if (NNSP != None)
		{
			NNSP.NN_OwnerPing = float(Owner.ConsoleCommand("GETPING"));
			if (bbP != None)
				NNSP.zzNN_ProjIndex = bbP.xxNN_AddProj(NNSP);
		}
	}
	else
	{
		Pawn(Owner).PlayRecoil(FiringSpeed);
		ProjectileFire(AltProjectileClass, AltProjectileSpeed, bAltWarnTarget);
	}

}

state ClientFiring
{
	simulated function bool ClientAltFire(float Value) {
		if (Owner.IsA('Bot'))
			return Super.ClientAltFire(Value);

		return false;
	}

	simulated function AnimEnd() {
		local bbPlayer O;
		O = bbPlayer(Owner);
		if (O != none)
			O.ClientDebugMessage("SSR AnimEnd"@O.ViewRotation.Yaw@O.ViewRotation.Pitch);
		super.AnimEnd();
	}
}

state ClientAltFiring
{
	simulated function bool ClientFire(float Value) {
		if (Owner.IsA('Bot'))
			return Super.ClientFire(Value);

		return false;
	}

	simulated function AnimEnd() {
		local bbPlayer O;
		O = bbPlayer(Owner);
		if (O != none)
			O.ClientDebugMessage("SSR AnimEnd"@O.ViewRotation.Yaw@O.ViewRotation.Pitch);
		super.AnimEnd();
	}
}

simulated function NN_TraceFire()
{
	local vector HitLocation, HitDiff, HitNormal, StartTrace, EndTrace, X,Y,Z;
	local actor Other;
	local bbPlayer bbP;
	local bool zzbNN_Combo;

	if (Owner.IsA('Bot'))
		return;

	yModInit();

	bbP = bbPlayer(Owner);
	if (bbP == None)
		return;

	GetAxes(bbP.ViewRotation,X,Y,Z);
	StartTrace = Owner.Location + CDO;
	EndTrace = StartTrace + (100000 * vector(bbP.ViewRotation));

	Other = bbP.NN_TraceShot(HitLocation,HitNormal,EndTrace,StartTrace,Pawn(Owner));

	if (bbP.bDrawDebugData) {
		bbP.debugClientHitLocation = HitLocation;
		bbP.debugClientHitNormal = HitNormal;
		bbP.bClientPawnHit = False;
	}

	if (Other.IsA('Pawn'))
	{
		HitDiff = HitLocation - Other.Location;
		if (bbP.bDrawDebugData) {
			bbP.debugClientHitDiff = HitDiff;
			bbP.debugClientEnemyHitLocation = Other.Location;
			bbP.bClientPawnHit = True;
		}
	}

	zzbNN_Combo = NN_ProcessTraceHit(Other, HitLocation, HitNormal, vector(bbP.ViewRotation),Y,Z);
	
	if (zzbNN_Combo)
		bbP.xxNN_Fire(Level.TimeSeconds, NN_ShockProj(Other).zzNN_ProjIndex, bbP.Location, bbP.Velocity, bbP.ViewRotation, Other, HitLocation, HitDiff, true);
	else
		bbP.xxNN_Fire(Level.TimeSeconds, -1, bbP.Location, bbP.Velocity, bbP.ViewRotation, Other, HitLocation, HitDiff, false);
	
	if (Other == bbP.zzClientTTarget)
		bbP.zzClientTTarget.TakeDamage(0, Pawn(Owner), HitLocation, 60000.0*vector(bbP.ViewRotation), ST_MyDamageType);
}

simulated function bool NN_ProcessTraceHit(Actor Other, Vector HitLocation, Vector HitNormal, Vector X, Vector Y, Vector Z)
{
	local bbPlayer bbP;
	local vector Offset;
	local vector HitOffset;
	
	local bool zzbNN_Combo;

	if (Owner.IsA('Bot'))
		return false;

	if (Other==None)
	{
		HitNormal = -X;
		HitLocation = Owner.Location + X*100000.0;
		HitOffset = HitLocation;
	} else { 
		HitOffset = HitLocation - Other.Location;
	}

	bbP = bbPlayer(Owner);
	if (bbP == none) return false;
	
	if ( NN_ShockProj(Other)!=None )
	{
		NN_ShockProj(Other).NN_SuperExplosion(Pawn(Owner));
		zzbNN_Combo = true;
	}

	Offset = CDO + (FireOffset.X + 20) * X + Y * yMod + FireOffset.Z * Z;
	if(zzbNN_Combo)
	{
		bbP.SendWeaponEffect(
			class'SuperShockRifleWeaponEffectNoRing',
			bbP.PlayerReplicationInfo,
			Owner.Location + Offset,
			Offset,
			Other,
			HitLocation,
			HitOffset,
			HitNormal);
	}
	else
	{
		bbP.SendWeaponEffect(
			class'SuperShockRifleWeaponEffect',
			bbP.PlayerReplicationInfo,
			Owner.Location + Offset,
			Offset,
			Other,
			HitLocation,
			HitOffset,
			HitNormal);
	}

	class'bbPlayerStatics'.static.PlayClientHitResponse(Pawn(Owner), Other, HitDamage, ST_MyDamageType);

	return zzbNN_Combo;
}

function TraceFire( float Accuracy )
{
	local bbPlayer bbP;
	local vector NN_HitLoc, HitLocation,HitNormal, StartTrace, EndTrace, X,Y,Z;
	
	if (Owner.IsA('Bot'))
	{
		Super.TraceFire(Accuracy);
		return;
	}

	bbP = bbPlayer(Owner);
	if (bbP == None || !bNewNet)
	{
		Super.TraceFire(Accuracy);
		return;
	}

	if (bbP.zzNN_HitActor != None && bbP.zzNN_HitActor.IsA('bbPlayer') && !bbPlayer(bbP.zzNN_HitActor).xxCloseEnough(bbP.zzNN_HitLoc))
		bbP.zzNN_HitActor = None;

	Owner.MakeNoise(bbP.SoundDampening);
	GetAxes(bbP.zzNN_ViewRot,X,Y,Z);

	StartTrace = Owner.Location + CalcDrawOffset() + FireOffset.Y * Y + FireOffset.Z * Z;
	EndTrace = StartTrace + Accuracy * (FRand() - 0.5 )* Y * 1000
		+ Accuracy * (FRand() - 0.5 ) * Z * 1000 ;

	if ( bBotSpecialMove && (Tracked != None)
		&& (((Owner.Acceleration == vect(0,0,0)) && (VSize(Owner.Velocity) < 40)) ||
			(Normal(Owner.Velocity) Dot Normal(Tracked.Velocity) > 0.95)) )
		EndTrace += 100000 * Normal(Tracked.Location - StartTrace);
	else
	{
		AdjustedAim = bbP.AdjustAim(1000000, StartTrace, 2.75*AimError, False, False);
		EndTrace += (100000 * vector(AdjustedAim));
	}

	if (bbP.zzNN_HitActor != None && VSize(bbP.zzNN_HitDiff) > bbP.zzNN_HitActor.CollisionRadius + bbP.zzNN_HitActor.CollisionHeight)
		bbP.zzNN_HitDiff = vect(0,0,0);

	if (bbP.zzNN_HitActor != None && (bbP.zzNN_HitActor.IsA('Pawn') || bbP.zzNN_HitActor.IsA('Projectile')) && FastTrace(bbP.zzNN_HitActor.Location + bbP.zzNN_HitDiff, StartTrace))
	{
		NN_HitLoc = bbP.zzNN_HitActor.Location + bbP.zzNN_HitDiff;
	}
	else
	{
		bbP.zzNN_HitActor = bbP.TraceShot(HitLocation,HitNormal,EndTrace,StartTrace);
		NN_HitLoc = bbP.zzNN_HitLoc;
	}
	ProcessTraceHit(bbP.zzNN_HitActor, NN_HitLoc, HitNormal, vector(AdjustedAim), Y, Z);
	bbP.zzNN_HitActor = None;
	Tracked = None;
	bBotSpecialMove = false;
}

function ProcessTraceHit(Actor Other, Vector HitLocation, Vector HitNormal, Vector X, Vector Y, Vector Z)
{
	local Pawn PawnOwner;
	local Pawn P;
	local bbPlayer bbP;
	local vector HitOffset;
	local vector SmokeOffset;
	local bool	bCombo;
	local class<SuperShockRifleWeaponEffect> ClsWPEffect;
	
	if (Owner.IsA('Bot'))
	{
		Super.ProcessTraceHit(Other, HitLocation, HitNormal, X, Y, Z);
		return;
	}

	yModInit();

	PawnOwner = Pawn(Owner);
	bbP = bbPlayer(Owner);

	if (Other==None) {
		HitNormal = -X;
		HitLocation = Owner.Location + X*10000.0;
		HitOffset = HitLocation;
	} else {
		HitOffset = HitLocation - Other.Location;
	}

	SmokeOffset = CalcDrawOffset() + (FireOffset.X + 20) * X + FireOffset.Y * Y + FireOffset.Z * Z;
	SpawnEffect(HitLocation, Owner.Location + SmokeOffset);
	
	if ( NN_ShockProjOwnerHidden(Other)!=None )
	{
		//AmmoType.UseAmmo(1);
		Other.SetOwner(Owner);
		NN_ShockProjOwnerHidden(Other).SuperExplosion();
		bCombo=True;
	}
	else if ( NN_ShockProj(Other)!=None )
	{
		//AmmoType.UseAmmo(1);
		NN_ShockProj(Other).SuperExplosion();
		bCombo=True;
	}
	
	if(bCombo)	ClsWPEffect = class'SuperShockRifleWeaponEffectNoRing';
	else		ClsWPEffect = class'SuperShockRifleWeaponEffect';
	
	if (Owner.IsA('Bot') == false) {
		for (P = Level.PawnList; P != none; P = P.NextPawn) {
			if (P == Owner) continue;
			if (bbPlayer(P) != none)
				bbPlayer(P).SendWeaponEffect(
					ClsWPEffect,
					Pawn(Owner).PlayerReplicationInfo,
					Owner.Location + SmokeOffset,
					SmokeOffset,
					Other,
					HitLocation,
					HitOffset,
					HitNormal);
			else if (bbCHSpectator(P) != none)
				bbCHSpectator(P).SendWeaponEffect(
					ClsWPEffect,
					Pawn(Owner).PlayerReplicationInfo,
					Owner.Location + SmokeOffset,
					SmokeOffset,
					Other,
					HitLocation,
					HitOffset,
					HitNormal);
		}
	}

	if (!bCombo && (Other != self) && (Other != Owner) && (Other != None) )
	{
		Other.TakeDamage(HitDamage, PawnOwner, HitLocation, 60000.0*X, ST_MyDamageType);
	}
}

function SpawnEffect(vector HitLocation, vector SmokeLocation)
{
	local ShockBeam SSB;

	if (Owner.IsA('Bot'))
	{
		Super.SpawnEffect(HitLocation, SmokeLocation);
		return;
	}

	// This is only done to fix stats, because stats count the number of
	// SuperShockBeams that were spawned
	if (Role == ROLE_Authority) {
		SSB = Spawn(class'ShockBeam');
		// Dont show locally
		SSB.bHidden = true;
		// Dont replicate to clients
		SSB.RemoteRole = ROLE_None;
	}
}

function SetSwitchPriority(pawn Other)
{
	Class'NN_WeaponFunctions'.static.SetSwitchPriority( Other, self, 'ComboShockRifle');
}

simulated function TweenDown ()
{
	Class'NN_WeaponFunctions'.static.TweenDown( self);
}

simulated function AnimEnd ()
{
	Class'NN_WeaponFunctions'.static.AnimEnd( self);
}

state NormalFire
{
	function Fire(float F)
	{
		if (Owner.IsA('Bot'))
		{
			Super.Fire(F);
			return;
		}
		if (F > 0 && bbPlayer(Owner) != None)
			Global.Fire(F);
	}
	function AltFire(float F)
	{
		if (Owner.IsA('Bot'))
		{
			Super.AltFire(F);
			return;
		}
		if (F > 0 && bbPlayer(Owner) != None)
			Global.AltFire(F);
	}
}

state AltFiring
{
	function Fire(float F)
	{
		if (Owner.IsA('Bot'))
		{
			Super.Fire(F);
			return;
		}
		if (F > 0 && bbPlayer(Owner) != None)
			Global.Fire(F);
	}
	function AltFire(float F)
	{
		if (Owner.IsA('Bot'))
		{
			Super.AltFire(F);
			return;
		}
		if (F > 0 && bbPlayer(Owner) != None)
			Global.AltFire(F);
	}
}

State ClientActive
{
	simulated function bool ClientFire(float Value)
	{
		if (Owner.IsA('Bot'))
			return Super.ClientFire(Value);
		bForceFire = bbPlayer(Owner) == None || !bbPlayer(Owner).ClientCannotShoot();
		return bForceFire;
	}

	simulated function bool ClientAltFire(float Value)
	{
		if (Owner.IsA('Bot'))
			return Super.ClientAltFire(Value);
		bForceAltFire = bbPlayer(Owner) == None || !bbPlayer(Owner).ClientCannotShoot();
		return bForceAltFire;
	}

	simulated function AnimEnd()
	{
		if ( Owner == None )
		{
			Global.AnimEnd();
			GotoState('');
		}
		else if ( Owner.IsA('TournamentPlayer')
			&& (TournamentPlayer(Owner).PendingWeapon != None || TournamentPlayer(Owner).ClientPending != None) )
			GotoState('ClientDown');
		else if ( bWeaponUp )
		{
			if ( (bForceFire || (PlayerPawn(Owner).bFire != 0)) && Global.ClientFire(1) )
				return;
			else if ( (bForceAltFire || (PlayerPawn(Owner).bAltFire != 0)) && Global.ClientAltFire(1) )
				return;
			PlayIdleAnim();
			GotoState('');
		}
		else
		{
			PlayPostSelect();
			bWeaponUp = true;
		}
	}
}

state Active
{
	function Fire(float F)
	{
		if (Owner.IsA('Bot'))
		{
			Super.Fire(F);
			return;
		}
		if (F > 0 && bbPlayer(Owner) != None)
			Global.Fire(F);
	}
	function AltFire(float F)
	{
		if (Owner.IsA('Bot'))
		{
			Super.AltFire(F);
			return;
		}
		if (F > 0 && bbPlayer(Owner) != None)
			Global.AltFire(F);
	}
}

auto state Pickup
{
	ignores AnimEnd;

	simulated function Landed(Vector HitNormal)
	{
		Super(Inventory).Landed(HitNormal);
	}
}

defaultproperties
{
	ThirdPersonMesh=LodMesh'Botpack.ASMD2hand'
	AltProjectileClass=Class'NN_CGShock_Proj'
	AltProjectileHiddenClass=Class'NN_CGShock_ProjOwnerHidden'
	bNewNet=True
	PickupViewScale=1.750000
	ST_MyDamageType=jolted
	hitdamage=1000
	AmmoName=Class'Botpack.SuperShockCore'
	aimerror=650.000000
	DeathMessage="%k electrified %o with the %w."
	PickupMessage="You got the Combo Shock Rifle."
	ItemName="Combo Shock Rifle"

}
