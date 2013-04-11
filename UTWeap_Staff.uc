class UTWeap_Staff extends UTWeapon;

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
SkeletalMesh=SkeletalMesh'CH_Gibs.Mesh.SK_CH_Gibs_Corrupt_Part01'
Scale3D=(X=0.85,Y=0.85,Z=4.0)
Translation=(X=1,Y=1,Z=-5)
End Object

Begin Object Name=FirstPersonMesh
SkeletalMesh=SkeletalMesh'CH_Gibs.Mesh.SK_CH_Gibs_Corrupt_Part01'
Scale3D=(X=0.85,Y=0.85,Z=4.0)
Translation=(X=1,Y=1,Z=-5)
End Object

WeaponFireTypes(0)=EWFT_Projectile
WeaponFireTypes(1)=EWFT_Projectile
WeaponProjectiles(0)=class'AlexGame.UTProj_StaffOne'
WeaponProjectiles(1)=class'AlexGame.UTProj_MyShock'
InstantHitDamage(0)=110.0
WeaponFireSnd(0)=SoundCue'a_interface.menu.UT3MenuCharacterBodyAppearCue'
WeaponFireSnd(1)=SoundCue'KismetGame_Assets.Sounds.S_WeaponRespawn_01_Cue'
DefaultAnimSpeed=0.9
FireInterval(0)=+0.2
FireInterval(1)=+2.0
AttachmentClass=class 'UTAttachment_Staff'
PivotTranslation=(Y=-25.0)
AimingHelpRadius[0]=100.0
AimingHelpRadius[1]=100.0
CrosshairImage=Texture2D'UI_HUD.HUD.UTCrossHairs'
CrossHairCoordinates=(U=192,V=64,UL=64,VL=64)
IconCoordinates=(U=600,V=341,UL=111,VL=58)
CrosshairScaling=1.0
CurrentRating=+1.0
MaxDesireability=1
ShotCost(0)=12
ShotCost(1)=35
MessageClass=class'UTPickupMessage'
DroppedPickupClass=class'UTDroppedPickup' 
MaxAmmoCount=100
AmmoCount=50
bAllowFiringWithoutController=true
WeaponRange=150
AmmoRegenPerSecond=5
}