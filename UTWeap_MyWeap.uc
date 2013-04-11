class UTWeap_MyWeap extends UTWeapon;

const MAX_LEVEL = 5;
var int CurrentWeaponLevel;
var float FireRates[MAX_LEVEL];
var int AmmoRegenPerSecond;

simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
    setTimer(0.5, true, 'AddAmmoTimer');
}

function AddAmmoTimer()
{
    AddAmmo ( AmmoRegenPerSecond );
}

function UpgradeWeapon()
{
    if(CurrentWeaponLevel < MAX_LEVEL)
        CurrentWeaponLevel++;

    FireInterval[0] = FireRates[CurrentWeaponLevel - 1];

    if(IsInState('WeaponFiring'))
    {
        ClearTimer(nameof(RefireCheckTimer));
        TimeWeaponFiring(CurrentFireMode);
    }

    AddAmmo(MaxAmmoCount);
}

defaultproperties
{
Begin Object Name=PickupMesh
	SkeletalMesh=SkeletalMesh'GDC_Materials.Meshes.SK_ExportSword2'
End Object

Begin Object Name=FirstPersonMesh
SkeletalMesh=SkeletalMesh'GDC_Materials.Meshes.SK_ExportSword2'
AnimSets(0)=AnimSet'GDC_Materials.Meshes.SwordAnimset'
End Object

WeaponFireTypes(0)=EWFT_Projectile
WeaponFireTypes(1)=EWFT_Projectile
WeaponProjectiles(0)=class'AlexGame.UTProj_Bruiser'
WeaponProjectiles(1)=class'AlexGame.UTProj_SwordTwo'
InstantHitDamage(0)=110.0
WeaponFireSnd(0)=SoundCue'A_Character_BodyImpacts.BodyImpacts.A_Character_RobotImpact_HeadshotRoll_Cue'
WeaponFireSnd(1)=SoundCue'A_Vehicle_Generic.Vehicle.VehicleImpact_MetalMediumCue'
DefaultAnimSpeed=0.9
FireInterval(0)=+0.4
FireInterval(1)=+1.2
AttachmentClass=class 'UTAttachment_MyWeap'
PivotTranslation=(Y=-25.0)
AimingHelpRadius[0]=100.0
AimingHelpRadius[1]=100.0
CrosshairImage=Texture2D'UI_HUD.HUD.UTCrossHairs'
CrossHairCoordinates=(U=192,V=64,UL=64,VL=64)
IconCoordinates=(U=600,V=341,UL=111,VL=58)
CrosshairScaling=1.0
CurrentRating=+1.0
MaxDesireability=1
ShotCost(0)=10
ShotCost(1)=20
MessageClass=class'UTPickupMessage'
DroppedPickupClass=class'UTDroppedPickup' 
MaxAmmoCount=100
AmmoCount=50
bAllowFiringWithoutController=true
WeaponRange=150
AmmoRegenPerSecond=5
}