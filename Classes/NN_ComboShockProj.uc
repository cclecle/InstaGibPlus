class NN_ComboShockProj extends NN_ShockProj;

simulated function Explode(vector HitLocation, vector HitNormal)
{
	local bbPlayer bbP;
	local class<NN_ComboShock_UT_RingExplosion_RED> ClsNN_UT_RingExplosion;

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

	ClsNN_UT_RingExplosion=class'NN_ComboShock_UT_RingExplosion_RED';
	log("EXPLODEEEEEEEEE :"@bTeamColor@"iTeamIdx:"@iTeamIdx);
	if(bTeamColor)
	{
		switch(iTeamIdx)
		{
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


	
	Spawn(ClsNN_UT_RingExplosion,,, HitLocation+HitNormal*8,rotator(HitNormal));
	if (bbP != None)
		bbP.xxClientDemoFix(None,ClsNN_UT_RingExplosion,HitLocation+HitNormal*8,,, rotator(HitNormal));

	PlayOwnedSound(ImpactSound, SLOT_Misc, 0.5,,, 0.5+FRand());

	Destroy();
}

defaultproperties
{
	DamageMultiplierExplode=1000
	DamageMultiplierSuperExplode=3000
	DamageMultiplierSuperDuperExplode=9000
}