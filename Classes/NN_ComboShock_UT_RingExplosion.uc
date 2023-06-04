class NN_ComboShock_UT_RingExplosion extends NN_UT_RingExplosion;

#exec TEXTURE IMPORT NAME=TRED_RING FILE=Textures\ShockProj\TRED_RING.PCX LODSET=2
#exec TEXTURE IMPORT NAME=TBLUE_RING FILE=Textures\ShockProj\TBLUE_RING.PCX LODSET=2
#exec TEXTURE IMPORT NAME=TGOLD_RING FILE=Textures\ShockProj\TGOLD_RING.PCX LODSET=2
#exec TEXTURE IMPORT NAME=TGREEN_RING FILE=Textures\ShockProj\TGREEN_RING.PCX LODSET=2

var bool 	PostSpawnEffect;
var int 	iTeamIdx;


replication
{
	unreliable if ((Role == ROLE_Authority) && bNetOwner)
		iTeamIdx;
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	SetTimer(0.025, True);
	
	log("NN_ComboShock_UT_RingExplosion -> PostBeginPlay()");
	log(Owner);
	//log("bTeamColor:"@bTeamColor);
	//log("iTeamIdx:"@iTeamIdx);
}

/*
simulated function SpawnEffects()
{
	// Delay real SpawnEffects to let replication set bTeamColor/iTeamIdx
	PostSpawnEffect = True;
	
	log("NN_ComboShock_UT_RingExplosion -> SpawnEffects()");
	log("bTeamColor:"@bTeamColor);
	log("iTeamIdx:"@iTeamIdx);
}
*/
	
simulated function Timer()
{
	//local NN_ComboShock_ShockExplo A;
	local bbPlayer bbP;
	
	log("NN_ComboShock_UT_RingExplosion -> Timer()");
	log(Owner);
	//log("bTeamColor:"@bTeamColor);
	//log("iTeamIdx:"@iTeamIdx);
	
	if(Owner!=None) {
		bbP = bbPlayer(Owner);
		if (bbP!=None) {
			if(applyTeamColor(bbP)) {
					setTimer(0,False);
			}
		}
	}

	/*
	if(PostSpawnEffect)
	{
		A = NN_ComboShock_ShockExplo(Spawn(ClsNN_ShockExplo));
		A.RemoteRole = ROLE_None;
		A.bTeamColor = bTeamColor;
		A.iTeamIdx = iTeamIdx;
		PostSpawnEffect=False;
	}*/
}

simulated function bool applyTeamColor(bbPlayer bbP) {
	log("NN_ComboShockProj->applyTeamColor()");
	log("bTeamColoredShockRifle:"@bbP.Settings.bTeamColoredShockRifle);
	if(Pawn(Owner).PlayerReplicationInfo==None)
		return False;
	
	if (bbP.Settings.bTeamColoredShockRifle) {
		//bTeamColor=True;
		switch(iTeamIdx) {
			case 0:
				MultiSkins[0]=Texture'TRED_RING';
				break;
			case 1:
				MultiSkins[0]=Texture'TBLUE_RING';
				break;
			case 2:
				MultiSkins[0]=Texture'TGOLD_RING';
				break;
			case 3:
				MultiSkins[0]=Texture'TGREEN_RING';
				break;
			default:
				MultiSkins[0]=None;
				break;
		}
	}
	else {
		MultiSkins[0]=None;
		log("NORMAL2");
	}
	
	return True;
}

defaultproperties
{
	ClsNN_ShockExplo=class'NN_ComboShock_ShockExplo'
}