class NN_CGShock_UT_RingExplosion extends NN_UT_RingExplosion;

#exec TEXTURE IMPORT NAME=TRED_RING FILE=Textures\ShockProj\TRED_RING.PCX LODSET=2
#exec TEXTURE IMPORT NAME=TBLUE_RING FILE=Textures\ShockProj\TBLUE_RING.PCX LODSET=2
#exec TEXTURE IMPORT NAME=TGOLD_RING FILE=Textures\ShockProj\TGOLD_RING.PCX LODSET=2
#exec TEXTURE IMPORT NAME=TGREEN_RING FILE=Textures\ShockProj\TGREEN_RING.PCX LODSET=2

var bool 	PostSpawnEffect;
var bool 	bTeamColor;
var int 	iTeamIdx;


replication
{
	unreliable if ((Role == ROLE_Authority) && bNetOwner)
		iTeamIdx;
}

simulated function PostBeginPlay() {
	Super.PostBeginPlay();
	if ( Level.NetMode != NM_DedicatedServer )
		SetTimer(0.025, True);
}


simulated function SpawnEffects() {
	// Delay real SpawnEffects to let replication set bTeamColor/iTeamIdx
	PostSpawnEffect = True;
}

	
simulated function Timer() {
	local NN_CGShock_ShockExplo A;
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

		if(PostSpawnEffect) {
			A = NN_CGShock_ShockExplo(Spawn(ClsNN_ShockExplo));
			A.RemoteRole = ROLE_None;
			A.iTeamIdx = iTeamIdx;
			A.bTeamColor = bTeamColor;
			PostSpawnEffect=False;
		}
	}
}

simulated function bool applyTeamColor(bbPlayer bbP) {
	if(Pawn(Owner).PlayerReplicationInfo==None)
		return False;
	
	if ((bbP.Settings.cShockBeam == 2)||(bbP.Settings.cShockBeam == 4)) {
		bTeamColor=True;
		switch(iTeamIdx) {
			case 0:
				MultiSkins[0]=Texture'TRED_RING';
				LightHue=255;
				LightSaturation=76;
				break;
			case 1:
				MultiSkins[0]=Texture'TBLUE_RING';
				LightHue=170;
				LightSaturation=76;
				break;
			case 2:
				MultiSkins[0]=Texture'TGREEN_RING';
				LightHue=85;
				LightSaturation=64;
				break;
			case 3:
				MultiSkins[0]=Texture'TGOLD_RING';
				LightHue=22;
				LightSaturation=50;
				break;
			default:
				MultiSkins[0]=None;
				LightHue=165;
				LightSaturation=72;
				break;
		}
	}
	else {
		MultiSkins[0]=None;
		LightHue=165;
		LightSaturation=72;
	}
	
	return True;
}

defaultproperties
{
	ClsNN_ShockExplo=class'NN_CGShock_ShockExplo'
}