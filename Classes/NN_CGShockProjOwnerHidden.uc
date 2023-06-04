class NN_CGShockProjOwnerHidden extends NN_ShockProjOwnerHidden;

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

//var bool 	bTeamColor;

simulated function PostBeginPlay()
{
	log("NN_CGShockProjOwnerHidden->PostBeginPlay()");
	Super.PostBeginPlay();
	setTimer(0.025,True);
}

simulated function Timer()
{
	local bbPlayer bbP;
	log("NN_CGShockProjOwnerHidden->Timer()");

	if(Owner!=None) {
		bbP = bbPlayer(Owner);
		if (bbP!=None) {
			if(applyTeamColor(bbP)) {
					setTimer(0,False);
			}
		}
	}
}

simulated function bool applyTeamColor(bbPlayer bbP) {
	log("NN_CGShockProjOwnerHidden->applyTeamColor()");
	if(Pawn(Owner).PlayerReplicationInfo==None)
		return False;
	
	if (bbP.Settings.bTeamColoredShockRifle) {
		//bTeamColor=True;
		switch(Pawn(Owner).PlayerReplicationInfo.Team) {
			case 0:
				Texture=Texture'ASMDAlt_TRED_a00';
				log("RED");
				break;
			case 1:
				Texture=Texture'ASMDAlt_TBLUE_a00';
				log("BLUE");
				break;
			case 2:
				Texture=Texture'ASMDAlt_TGREEN_a00';
				break;
			case 3:
				Texture=Texture'ASMDAlt_TGOLD_a00';
				break;
			default:
				Texture=Texture'Botpack.ASMDAlt.ASMDAlt_a00';
				log("NORMAL");
				break;
		}
	}
	else {
		Texture=Texture'Botpack.ASMDAlt.ASMDAlt_a00';
		log("NORMAL2");
	}
	
	return True;
}


simulated function DoExplode(int Dmg, vector HitLocation,vector HitNormal)
{
	local PlayerPawn P;
	local NN_ComboShock_UT_RingExplosion instRingExpl;

	if (RemoteRole < ROLE_Authority) {
		ForEach AllActors(class'PlayerPawn', P) {
			if(MessagingSpectator(P)!=None) continue;
			if(!P.bIsPlayer) continue;
			
			if (P != Instigator) {
				instRingExpl = P.Spawn(class'NN_ComboShock_UT_RingExplosion',P,, HitLocation+HitNormal*8,rotator(HitNormal));
				instRingExpl.bOnlyOwnerSee  = True;
				//instRingExpl.bTeamColor = bTeamColor;
				instRingExpl.iTeamIdx 	= Pawn(Owner).PlayerReplicationInfo.Team;
			}
		}
	}
}
