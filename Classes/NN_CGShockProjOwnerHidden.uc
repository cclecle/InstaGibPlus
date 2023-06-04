class NN_CGShockProjOwnerHidden extends NN_ShockProjOwnerHidden;

var bool 	bTeamColor;
var int 	iTeamIdx;

replication
{
	reliable if(Role == ROLE_Authority)
		bTeamColor,iTeamIdx;
}


simulated function DoExplode(int Dmg, vector HitLocation,vector HitNormal)
{
	local PlayerPawn P;
	local Actor CR;
	local class<NN_ComboShock_UT_RingExplosion_RED> ClsNN_UT_RingExplosion;

	if (RemoteRole < ROLE_Authority) {
		
		if(bTeamColor)
		{
			switch(iTeamIdx) {
				case 0:
					ClsNN_UT_RingExplosion=class'NN_ComboShock_UT_RingExplosion_RED';
					break;
				case 1:
					ClsNN_UT_RingExplosion=class'NN_ComboShock_UT_RingExplosion_RED';
					break;
				case 2:
					ClsNN_UT_RingExplosion=class'NN_ComboShock_UT_RingExplosion_RED';
					break;
				case 3:
					ClsNN_UT_RingExplosion=class'NN_ComboShock_UT_RingExplosion_RED';
					break;
			}
		}
		ForEach AllActors(class'PlayerPawn', P)
			if (P != Instigator) {
				CR = P.Spawn(ClsNN_UT_RingExplosion,P,, HitLocation+HitNormal*8,rotator(HitNormal));
				CR.bOnlyOwnerSee = True;
				
			}
	}
}
