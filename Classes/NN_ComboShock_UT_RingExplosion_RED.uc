class NN_ComboShock_UT_RingExplosion_RED extends NN_UT_RingExplosion;

#exec TEXTURE IMPORT NAME=TRED_RING FILE=Textures\ShockProj\TRED_RING.PCX LODSET=2

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	log("NN_ComboShock_UT_RingExplosion_RED->PostBeginPlay()");
}

simulated event Tick( float DeltaTime )
{
	super.Tick(DeltaTime);
	log("TYIIIIIIIIIIIIK");
}

defaultproperties
{
	MultiSkins(0)=Texture'TRED_RING';
	ClsNN_ShockExplo=class'NN_ComboShock_ShockExplo'
}