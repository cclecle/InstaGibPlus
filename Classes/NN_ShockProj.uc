// ===============================================================
// Stats.NN_ShockProj: put your comment here

// Created by UClasses - (C) 2000-2001 by meltdown@thirdtower.com
// ===============================================================

class NN_ShockProj extends ShockProj;

#exec TEXTURE IMPORT NAME=ASMDAlt_TRED_a00 FILE=Textures\ShockProj\ASMDAlt_TRED_a00.pcx
#exec TEXTURE IMPORT NAME=ASMDAlt_TRED_a01 FILE=Textures\ShockProj\ASMDAlt_TRED_a01.pcx
#exec TEXTURE IMPORT NAME=ASMDAlt_TRED_a02 FILE=Textures\ShockProj\ASMDAlt_TRED_a02.pcx
#exec TEXTURE IMPORT NAME=ASMDAlt_TRED_a03 FILE=Textures\ShockProj\ASMDAlt_TRED_a03.pcx

#exec TEXTURE IMPORT NAME=ASMDAlt_TBLUE_a00 FILE=Textures\ShockProj\ASMDAlt_TBLUE_a00.pcx
#exec TEXTURE IMPORT NAME=ASMDAlt_TBLUE_a01 FILE=Textures\ShockProj\ASMDAlt_TBLUE_a01.pcx
#exec TEXTURE IMPORT NAME=ASMDAlt_TBLUE_a02 FILE=Textures\ShockProj\ASMDAlt_TBLUE_a02.pcx
#exec TEXTURE IMPORT NAME=ASMDAlt_TBLUE_a03 FILE=Textures\ShockProj\ASMDAlt_TBLUE_a03.pcx

#exec TEXTURE IMPORT NAME=ASMDAlt_TGREEN_a00 FILE=Textures\ShockProj\ASMDAlt_TGREEN_a00.pcx
#exec TEXTURE IMPORT NAME=ASMDAlt_TGREEN_a01 FILE=Textures\ShockProj\ASMDAlt_TGREEN_a01.pcx
#exec TEXTURE IMPORT NAME=ASMDAlt_TGREEN_a02 FILE=Textures\ShockProj\ASMDAlt_TGREEN_a02.pcx
#exec TEXTURE IMPORT NAME=ASMDAlt_TGREEN_a03 FILE=Textures\ShockProj\ASMDAlt_TGREEN_a03.pcx

#exec TEXTURE IMPORT NAME=ASMDAlt_TGOLD_a00 FILE=Textures\ShockProj\ASMDAlt_TGOLD_a00.pcx
#exec TEXTURE IMPORT NAME=ASMDAlt_TGOLD_a01 FILE=Textures\ShockProj\ASMDAlt_TGOLD_a01.pcx
#exec TEXTURE IMPORT NAME=ASMDAlt_TGOLD_a02 FILE=Textures\ShockProj\ASMDAlt_TGOLD_a02.pcx
#exec TEXTURE IMPORT NAME=ASMDAlt_TGOLD_a03 FILE=Textures\ShockProj\ASMDAlt_TGOLD_a03.pcx


// For Standstill combo Special
var vector StartLocation;
var actor NN_HitOther;
var int zzNN_ProjIndex;

var int DamageMultiplierExplode;
var int DamageMultiplierSuperExplode;
var int DamageMultiplierSuperDuperExplode;

var bool 	bTeamColor;
var bool 	bTeamColorDone;
var int 	iTeamIdx;
var byte 	currTx;

var Texture TeamTextures[4];

replication
{
	unreliable if(Role == ROLE_Authority && bNetOwner)
		bTeamColor,iTeamIdx;
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	if (Instigator != None)
		StartLocation = Instigator.Location;
	else if (Owner != None)
		StartLocation = Owner.Location;

	currTx=0;
	SetTimer(0.025, True);
}

simulated function applyTeamColor()
{
	switch(iTeamIdx)
	{
		case 0:
			TeamTextures[0] = Texture'ASMDAlt_TRED_a00';
			TeamTextures[1] = Texture'ASMDAlt_TRED_a01';
			TeamTextures[2] = Texture'ASMDAlt_TRED_a02';
			TeamTextures[3] = Texture'ASMDAlt_TRED_a03';
			break;
		case 1:
			TeamTextures[0] = Texture'ASMDAlt_TBLUE_a00';
			TeamTextures[1] = Texture'ASMDAlt_TBLUE_a01';
			TeamTextures[2] = Texture'ASMDAlt_TBLUE_a02';
			TeamTextures[3] = Texture'ASMDAlt_TBLUE_a03';
			break;
		case 2:
			TeamTextures[0] = Texture'ASMDAlt_TGREEN_a00';
			TeamTextures[1] = Texture'ASMDAlt_TGREEN_a01';
			TeamTextures[2] = Texture'ASMDAlt_TGREEN_a02';
			TeamTextures[3] = Texture'ASMDAlt_TGREEN_a03';
			break;
		case 3:
			TeamTextures[0] = Texture'ASMDAlt_TGOLD_a00';
			TeamTextures[1] = Texture'ASMDAlt_TGOLD_a01';
			TeamTextures[2] = Texture'ASMDAlt_TGOLD_a02';
			TeamTextures[3] = Texture'ASMDAlt_TGOLD_a03';
			break;
		default:
			bTeamColor=False;
			break;
	}
}

simulated function Timer()
{
	if(bTeamColor && !bTeamColorDone)
	{
		applyTeamColor();
		bTeamColorDone=True;
	}
	if(bTeamColor)
	{
		Texture = TeamTextures[currTx%4];
		currTx++;
	}
}


function SuperExplosion()	// aka, combo.
{
	local bbPlayer bbP;

	bbP = bbPlayer(Owner);
	if (bbP != None && bbP.bNewNet)
	{
		if (Level.NetMode == NM_Client && !IsA('NN_ShockProjOwnerHidden'))
		{
			bbP.NN_HurtRadius(self, class'ShockRifle', Damage*DamageMultiplierSuperExplode, 250, MyDamageType, MomentumTransfer*2, Location, zzNN_ProjIndex );
			bbP.xxNN_RemoveProj(zzNN_ProjIndex, Location, vect(0,0,0), true);
		}
	}
	else
	{
		HurtRadius(Damage*DamageMultiplierSuperExplode, 250, MyDamageType, MomentumTransfer*2, Location );
	}
	Spawn(Class'ut_ComboRing',,'',Location, Instigator.ViewRotation);
	PlayOwnedSound(ExploSound,,20.0,,2000,0.6);

	Destroy();
}

simulated function NN_SuperExplosion(Pawn Pwner)	// aka, combo.
{
	local rotator Tater;
	local bbPlayer bbP;
    local UT_ComboRing Ring;

	bbP = bbPlayer(Pwner);
	Tater = Pwner.ViewRotation;

	if (bbP != None && bbP.bNewNet)
	{
		if (Level.NetMode == NM_Client)
		{
			bbP.NN_HurtRadius(self, class'ShockRifle', Damage*DamageMultiplierSuperExplode, 250, MyDamageType, MomentumTransfer*2, Location, zzNN_ProjIndex );
			bbP.xxNN_RemoveProj(zzNN_ProjIndex, Location, vect(0,0,0), true);
		}
	}
	else
	{
		HurtRadius(Damage*DamageMultiplierSuperExplode, 250, MyDamageType, MomentumTransfer*2, Location );
	} 
	Ring = Spawn(Class'ut_ComboRing',Pwner,'',Location, Tater);
	
	PlaySound(ExploSound,,20.0,,2000,0.6);
    if(bbP != none)
    {
        bbP.xxClientDemoFix(Ring, class'ut_ComboRing', Location, Ring.Velocity, Ring.Acceleration, Tater);
    }

	Destroy();
}

function SuperDuperExplosion()	// aka, combo.
{
	local bbPlayer bbP;
    local UT_SuperComboRing Ring;

	bbP = bbPlayer(Owner);
	if (bbP != None && bbP.bNewNet)
	{
		if (Level.NetMode == NM_Client && !IsA('NN_ShockProjOwnerHidden'))
		{
			bbP.NN_HurtRadius(self, class'ShockRifle', Damage*DamageMultiplierSuperDuperExplode, 750, MyDamageType, MomentumTransfer*6, Location, zzNN_ProjIndex );
			bbP.xxNN_RemoveProj(zzNN_ProjIndex, Location, vect(0,0,0), true);
		}
	}
	else
	{
		HurtRadius(Damage*DamageMultiplierSuperDuperExplode, 750, MyDamageType, MomentumTransfer*6, Location );
	}
	Ring = Spawn(Class'UT_SuperComboRing',,'',Location, Instigator.ViewRotation);
	PlayOwnedSound(ExploSound,,20.0,,2000,0.6);

	Destroy();
}


simulated function NN_SuperDuperExplosion(Pawn Pwner)	// aka, combo.
{
	local rotator Tater;
	local bbPlayer bbP;
    local UT_SuperComboRing Ring;

	bbP = bbPlayer(Pwner);
	Tater = Pwner.ViewRotation;

	if (bbP != None && bbP.bNewNet)
	{
		if (Level.NetMode == NM_Client)
		{
			bbP.NN_HurtRadius(self, class'ShockRifle', Damage*DamageMultiplierSuperDuperExplode, 750, MyDamageType, MomentumTransfer*6, Location, zzNN_ProjIndex );
			bbP.xxNN_RemoveProj(zzNN_ProjIndex, Location, vect(0,0,0), true);
		}
	}
	else
	{
		HurtRadius(Damage*DamageMultiplierSuperDuperExplode, 750, MyDamageType, MomentumTransfer*6, Location );
	} 
	Ring = Spawn(Class'UT_SuperComboRing',Pwner,'',Location, Tater);
	PlaySound(ExploSound,,20.0,,2000,0.6);
	if(bbP != none)
		bbP.xxClientDemoFix(Ring, Class'UT_SuperComboRing', Location, Ring.Velocity, Ring.Acceleration, Tater);

	Destroy();
}



auto state Flying
{
	simulated function ProcessTouch(Actor Other, vector HitLocation)
	{
		if (bDeleteMe || Other == None || Other.bDeleteMe)
			return;
		If ( Level.NetMode == NM_Client && Other!=Owner && Other!=Instigator && Other.Owner != Owner && (!Other.IsA('Projectile') || (Other.CollisionRadius > 0)) && NN_HitOther != Other )
		{
			if (Other.IsA('Projectile') && Other.bOwnerNoSee)
				bbPlayer(Owner).xxExplodeOther(Projectile(Other));
			NN_HitOther = Other;
			Explode(HitLocation,Normal(HitLocation-Other.Location));
		}
	}

	simulated function BeginState()
	{
		Velocity = vector(Rotation) * speed;
	}
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	local bbPlayer bbP;

	bbP = bbPlayer(Owner);

	if (bDeleteMe)
		return;

	if (bbP != None && bbP.bNewNet)
	{
		if (Level.NetMode == NM_Client && !IsA('NN_ShockProjOwnerHidden'))
		{
			bbP.NN_HurtRadius(self, class'ShockRifle', Damage*DamageMultiplierExplode, 70, MyDamageType, MomentumTransfer, Location, zzNN_ProjIndex );
			bbP.xxNN_RemoveProj(zzNN_ProjIndex, HitLocation, HitNormal);
		}
	}
	else
	{
		HurtRadius(Damage*DamageMultiplierExplode, 70, MyDamageType, MomentumTransfer, Location );
	} 
	NN_Momentum( 70, MomentumTransfer, Location );

	if (Damage > 60)
	{
		Spawn(class'ut_RingExplosion3',,, HitLocation+HitNormal*8,rotator(HitNormal));
		if (bbP != None)
			bbP.xxClientDemoFix(None, class'ut_RingExplosion3',HitLocation+HitNormal*8,,, rotator(HitNormal));
	}
	else
	{
		Spawn(class'ut_RingExplosion',,, HitLocation+HitNormal*8,rotator(Velocity));
		if (bbP != None)
			bbP.xxClientDemoFix(None, class'ut_RingExplosion',HitLocation+HitNormal*8,,, rotator(Velocity));
	}

	PlayOwnedSound(ImpactSound, SLOT_Misc, 0.5,,, 0.5+FRand());

	Destroy();
}

simulated function NN_Momentum( float DamageRadius, float Momentum, vector HitLocation )
{
	local actor Victims;
	local float damageScale, dist;
	local vector dir;
	local bbPlayer bbP;

	bbP = bbPlayer(Owner);

	if ( bbP == None || !bbP.bNewNet || Self.IsA('NN_ShockProjOwnerHidden') || RemoteRole == ROLE_Authority )
		return;

	foreach VisibleCollidingActors( class 'Actor', Victims, DamageRadius, HitLocation )
	{
		if( Victims == Owner )
		{
			dir = Owner.Location - HitLocation;
			dist = FMax(1,VSize(dir));
			dir = dir/dist;
			damageScale = 1 - FMax(0,(dist - Owner.CollisionRadius)/DamageRadius);

			dir = damageScale * Momentum * dir;

			if (bbP.Physics == PHYS_None)
				bbP.SetMovementPhysics();
			if (bbP.Physics == PHYS_Walking)
				dir.Z = FMax(dir.Z, 0.4 * VSize(dir));

			dir = 0.6*dir/bbP.Mass;

			bbP.AddVelocity(dir);
		}
	}
}

defaultproperties
{
	DamageMultiplierExplode=1
	DamageMultiplierSuperExplode=3
	DamageMultiplierSuperDuperExplode=9
}