class UTAttachment_Staff extends UTWeaponAttachment;


simulated function ThirdPersonFireEffects(vector HitLocation)
{
	Super.ThirdPersonFireEffects(HitLocation);
	Mesh.PlayAnim('WeaponFire');
	UTPawn(Instigator).FullBodyAnimSlot.PlayCustomAnimByDuration('hoverboardjumpfall', 0.6, 0.2, 0.2, FALSE, TRUE );
}

defaultproperties
{
Begin Object Name=SkeletalMeshComponent0
SkeletalMesh=SkeletalMesh'CH_Gibs.Mesh.SK_CH_Gibs_Corrupt_Part01'
Scale3D=(X=0.85,Y=0.85,Z=4.0)
Translation=(X=1,Y=1,Z=5)
End Object
WeaponClass=class'UTWeap_Staff'
MuzzleFlashSocket=MuzzleFlashSocket
}