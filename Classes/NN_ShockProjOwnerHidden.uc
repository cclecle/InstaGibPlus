class NN_ShockProjOwnerHidden extends NN_ShockProj;

var bool bAlreadyHidden;
var float NN_OwnerPing, NN_EndAccelTime;

replication
{
	reliable if ( Role == ROLE_Authority )
		NN_OwnerPing;
}

simulated function Tick(float DeltaTime)
{
	local bbPlayer bbP;
	
	if ( Owner == None )
		return;

	if (Level.NetMode == NM_Client) {

		if (!bAlreadyHidden && Owner.IsA('bbPlayer') && bbPlayer(Owner).Player != None) {
			Texture = None;
			LightType = LT_None;
			SetCollisionSize(0, 0);
			ImpactSound = None;
			ExplosionDecal = None;
			bAlreadyHidden = True;
			Destroy();
			return;
		}

		if (NN_OwnerPing > 0)
		{
			if (NN_EndAccelTime == 0)
			{
				Velocity *= 2;
				NN_EndAccelTime = Level.TimeSeconds + NN_OwnerPing * Level.TimeDilation / 2500;
				ForEach AllActors(class'bbPlayer', bbP)
					if ( Viewport(bbP.Player) != None )
						NN_EndAccelTime += bbP.PlayerReplicationInfo.Ping * Level.TimeDilation / 2500;
			}
			else if (Level.TimeSeconds > NN_EndAccelTime)
			{
				Velocity = Velocity / 2;
				NN_OwnerPing = 0;
			}
		}
	}
}

simulated function Explode(vector HitLocation,vector HitNormal)
{
	local bbPlayer bbP;

	if (bDeleteMe)
		return;
		
	if(Owner==None)
		Destroy();
	
	if (!bbPlayer(Owner).bNewNet)
		HurtRadius(Damage, 70, MyDamageType, MomentumTransfer, Location );

	DoExplode(Damage, HitLocation, HitNormal);
	PlayOwnedSound(ImpactSound, SLOT_Misc, 0.5,,, 0.5+FRand());

	bbP = bbPlayer(Instigator);
	if (bbP != None && Level.NetMode != NM_Client)
	{
		bbP.xxNN_ClientProjExplode(zzNN_ProjIndex, HitLocation, HitNormal);
	}

	Destroy();
}

simulated function DoExplode(int Dmg, vector HitLocation,vector HitNormal)
{
	local PlayerPawn P;
	local Actor CR;

	if (RemoteRole < ROLE_Authority) {
		ForEach AllActors(class'PlayerPawn', P) {
			if(MessagingSpectator(P)!=None) continue;
			if(!P.bIsPlayer) continue;
			if (P != Instigator) {
				if (Dmg > 60)
					CR = P.Spawn(class'ut_RingExplosion3',P,, HitLocation+HitNormal*8,rotator(HitNormal));
				else
					CR = P.Spawn(class'ut_RingExplosion',P,, HitLocation+HitNormal*8,rotator(Velocity));
				CR.bOnlyOwnerSee = True;
			}
		}
	}
}

function SuperExplosion()	// aka, combo.
{

	if (!bbPlayer(Owner).bNewNet)
		HurtRadius(Damage*3, 250, MyDamageType, MomentumTransfer*2, Location );

	DoSuperExplosion();
	PlayOwnedSound(ExploSound,,20.0,,2000,0.6);
	if (bbPlayer(Instigator) != None)
		bbPlayer(Instigator).xxNN_ClientProjExplode(-1*(zzNN_ProjIndex + 1));

	Destroy();
}

simulated function DoSuperExplosion()
{
	local Pawn P;
	local Actor CR;
	log("????????11111");

	if (RemoteRole < ROLE_Authority) {
		ForEach AllActors(class'Pawn', P) {
			//if(MessagingSpectator(P)!=None) continue;
			if(!P.bIsPlayer) continue;
			
			log("Spawning ut_ComboRing (super) for:"@P);
			
			if (P != Owner)
			{	
				//class'ut_ComboRing'.default.bOnlyOwnerSee=True;
				CR = P.Spawn(Class'ut_ComboRing',P,'',Location, Pawn(Owner).ViewRotation);
				//class'ut_ComboRing'.default.bOnlyOwnerSee=False;
				CR.bOnlyOwnerSee = True;
			}
			else
			{
				CR = P.Spawn(Class'ut_ComboRing',P,'',Location, Pawn(Owner).ViewRotation);
				CR.RemoteRole = ROLE_None;
			}
			log("SPAWNEDDD :(");
			log(CR);
			log(CR.bOnlyOwnerSee);
			
		}
	}
}

defaultproperties
{
     bOwnerNoSee=True
}
