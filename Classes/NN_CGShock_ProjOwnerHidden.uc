class NN_CGShock_ProjOwnerHidden extends NN_ShockProjOwnerHidden;

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

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	if ( Level.NetMode != NM_DedicatedServer )
		setTimer(0.025,True);
}

simulated function Destroyed()
{
	local bbPlayer bbP;

	if (Level.NetMode == NM_Client)
	{
		bbP = bbPlayer(Owner);
		if(bbP!=None) {
			bbP.xxNN_RemoveProj(zzNN_ProjIndex);
		}
	}
}

simulated function Timer()
{
	local bbPlayer bbP;

	if ( Level.NetMode != NM_DedicatedServer )
	{
		if(Owner!=None) {
			bbP = bbPlayer(Owner);
			if (bbP!=None) {
				if(applyTeamColor(bbP)) {
						setTimer(0,False);
				}
			}
		}
	}
}

simulated function bool applyTeamColor(bbPlayer bbP) {
	if(Pawn(Owner).PlayerReplicationInfo==None)
		return False;
	
	if ((bbP.Settings.cShockBeam == 2)||(bbP.Settings.cShockBeam == 4)) {
		switch(Pawn(Owner).PlayerReplicationInfo.Team) {
			case 0:
				Texture=Texture'ASMDAlt_TRED_a00';
				LightHue=255;
				LightSaturation=76;
				break;
			case 1:
				Texture=Texture'ASMDAlt_TBLUE_a00';
				LightHue=170;
				LightSaturation=76;
				break;
			case 2:
				Texture=Texture'ASMDAlt_TGREEN_a00';
				LightHue=85;
				LightSaturation=64;
				break;
			case 3:
				Texture=Texture'ASMDAlt_TGOLD_a00';
				LightHue=22;
				LightSaturation=50;
				break;
			default:
				Texture=Texture'Botpack.ASMDAlt.ASMDAlt_a00';
				LightHue=165;
				LightSaturation=72;
				break;
		}
	}
	else {
		Texture=Texture'Botpack.ASMDAlt.ASMDAlt_a00';
		LightHue=165;
		LightSaturation=72;
	}
	
	return True;
}


simulated function DoExplode(int Dmg, vector HitLocation,vector HitNormal)
{
	local PlayerPawn P;
	local NN_CGShock_UT_RingExplosion instRingExpl;

	if (RemoteRole < ROLE_Authority) {
		ForEach AllActors(class'PlayerPawn', P) {
			if(MessagingSpectator(P)!=None) continue;
			if(!P.bIsPlayer) continue;
			
			if (P != Instigator) {
				instRingExpl = P.Spawn(class'NN_CGShock_UT_RingExplosion',P,, HitLocation+HitNormal*8,rotator(HitNormal));
				instRingExpl.bOnlyOwnerSee  = True;
				instRingExpl.iTeamIdx 	= Pawn(Owner).PlayerReplicationInfo.Team;
			}
		}
	}
}

defaultproperties
{
	DamageMultiplierExplode=10
	DamageMultiplierSuperExplode=30
	DamageMultiplierSuperDuperExplode=90
}