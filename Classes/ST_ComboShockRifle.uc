// ===============================================================
// Stats.ST_ShockRifle: put your comment here

// Created by UClasses - (C) 2000-2001 by meltdown@thirdtower.com
// ===============================================================

class ST_ComboShockRifle extends ST_ShockRifle;

function AltFire( float Value )
{
	if (Owner == None)
		return;

	STM.PlayerFire(Pawn(Owner), 6);		// 6 = Shock Ball

	Super.AltFire(Value);
}

function ProcessTraceHit(Actor Other, Vector HitLocation, Vector HitNormal, Vector X, Vector Y, Vector Z)
{
	local PlayerPawn PlayerOwner;
	local Pawn PawnOwner;

	PawnOwner = Pawn(Owner);
	STM.PlayerFire(PawnOwner, 5);		// 5 = Shock Beam.

	if (Other==None)
	{
		HitNormal = -X;
		HitLocation = Owner.Location + X*10000.0;
	}

	PlayerOwner = PlayerPawn(Owner);
	if ( PlayerOwner != None )
		PlayerOwner.ClientInstantFlash( -0.4, vect(450, 190, 650));
	SpawnEffect(HitLocation, Owner.Location + CalcDrawOffset() + (FireOffset.X + 20) * X + FireOffset.Y * Y + FireOffset.Z * Z);

	
	if ( ST_ShockProj(Other)!=None )
	{ 
		AmmoType.UseAmmo(2);
		STM.PlayerUnfire(PawnOwner, 5);		// 5 = Shock Beam
		ST_ShockProj(Other).SuperExplosion();
		return;
	}
	else
		Spawn(class'ut_RingExplosion5',,, HitLocation+HitNormal*8,rotator(HitNormal));

	if ( (Other != self) && (Other != Owner) && (Other != None) ) 
	{
		STM.PlayerHit(PawnOwner, 5, False);			// 5 = Shock Beam
		Other.TakeDamage(
			GetWeaponSettings().ComboShockBeamDamage,
			PawnOwner,
			HitLocation,
			GetWeaponSettings().ComboShockBeamMomentum*60000.0*X,
			MyDamageType);
		STM.PlayerClear();
	}

	if (Pawn(Other) != None && Other != Owner && Pawn(Other).Health > 0)
	{	// We hit a pawn that wasn't the owner or dead. (How can you hit yourself? :P)
		HitCounter++;						// +1 hit
		if (HitCounter == 3)
		{	// Wowsers!
			HitCounter = 0;
			STM.PlayerSpecial(PawnOwner, 5);		// 5 = Shock Beam
		}
	}
	else
		HitCounter = 0;
}



defaultproperties {
	AltProjectileClass=Class'ST_ShockProjGib'
}
