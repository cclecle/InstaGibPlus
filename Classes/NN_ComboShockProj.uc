class NN_ComboShockProj extends NN_ShockProj;

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
	setTimer(0.025,True);
}

simulated function Timer()
{
	local bbPlayer bbP;

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
	if(Pawn(Owner).PlayerReplicationInfo==None)
		return False;
	
	if (bbP.Settings.bTeamColoredShockRifle) {
		switch(Pawn(Owner).PlayerReplicationInfo.Team) {
			case 0:
				Texture=Texture'ASMDAlt_TRED_a00';
				break;
			case 1:
				Texture=Texture'ASMDAlt_TBLUE_a00';
				break;
			case 2:
				Texture=Texture'ASMDAlt_TGREEN_a00';
				break;
			case 3:
				Texture=Texture'ASMDAlt_TGOLD_a00';
				break;
			default:
				Texture=Texture'Botpack.ASMDAlt.ASMDAlt_a00';
				break;
		}
	}
	else {
		Texture=Texture'Botpack.ASMDAlt.ASMDAlt_a00';
	}
	
	return True;
}


simulated function Explode(vector HitLocation, vector HitNormal)
{
	local bbPlayer bbP;
	local NN_ComboShock_UT_RingExplosion instRingExpl;

	bbP = bbPlayer(Owner);

	if (bDeleteMe)
		return;

	if (bbP != None && bbP.bNewNet) {
		if (Level.NetMode == NM_Client && !IsA('NN_ShockProjOwnerHidden')) {
			bbP.NN_HurtRadius(self, class'ShockRifle', Damage*DamageMultiplierExplode, 70, MyDamageType, MomentumTransfer, Location, zzNN_ProjIndex );
			bbP.xxNN_RemoveProj(zzNN_ProjIndex, HitLocation, HitNormal);
		}
	}
	else {
		HurtRadius(Damage*DamageMultiplierExplode, 70, MyDamageType, MomentumTransfer, Location );
	} 
	NN_Momentum( 70, MomentumTransfer, Location );

	instRingExpl=Spawn(class'NN_ComboShock_UT_RingExplosion',Owner,, HitLocation+HitNormal*8,rotator(HitNormal));
	instRingExpl.RemoteRole = ROLE_None;
	instRingExpl.iTeamIdx 	= Pawn(Owner).PlayerReplicationInfo.Team;
	
	if (bbP != None)
		bbP.xxClientDemoFix(None, class'NN_ComboShock_UT_RingExplosion',HitLocation+HitNormal*8,,, rotator(HitNormal));

	PlayOwnedSound(ImpactSound, SLOT_Misc, 0.5,,, 0.5+FRand());

	Destroy();
}

defaultproperties
{
	DamageMultiplierExplode=1000
	DamageMultiplierSuperExplode=3000
	DamageMultiplierSuperDuperExplode=9000
}