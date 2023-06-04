class NN_UT_RingExplosion extends UT_RingExplosion;

var class<NN_ShockExplo> ClsNN_ShockExplo;

simulated function SpawnEffects()
{
	local Actor A;
	A = Spawn(ClsNN_ShockExplo);
	A.RemoteRole = ROLE_None;
}

defaultproperties
{
	ClsNN_ShockExplo=class'NN_ShockExplo'
}