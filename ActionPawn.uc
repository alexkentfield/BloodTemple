class ActionPawn extends UTPawn
config(ActionGame);

var float RegenAmount;
var float CamOffsetDistance;
var float CamMinDistance, CamMaxDistance;
var float CamZoomTick; 
var float CamHeight;
var float Stamina;
var float SprintRecoverTimer;
var float HealRecoverTimer;
var float Empty;
var bool bSprinting;
var public bool bHealing;
var bool bInvulnerable;
var float InvulnerableTime;
var ParticleSystemComponent healEffect;
var ParticleSystemComponent healEffect2;
var ParticleSystemComponent sprintEffect1;
var ParticleSystemComponent sprintEffect2;
var Name HealSocket;
var Name HealSocket2;
var Name sprintSocket1;
var Name sprintSocket2;
var SoundCue healSound;
var SoundCue sprintSound;
var ParticleSystemComponent swordEffectComponent;
var Name swordSocket;

simulated function bool ShouldGib(class<UTDamageType> UTDamageType)
{
	return true;
}

function CastHeal()
{
	if (bHealing != false)
	{
	Weapon.AddAmmo(-30);
	bHealing = false;
	HealDamage(RegenAmount, Controller, class'DamageType');
	Mesh.AttachComponentToSocket(healEffect, healSocket);
	Mesh.AttachComponentToSocket(healEffect2, healSocket2);
	PlaySound( healSound );
	UTPawn(Instigator).FullBodyAnimSlot.PlayCustomAnimByDuration('hoverboardjumpfall', 0.6, 0.2, 0.2, FALSE, TRUE );
	setTimer(6.0, false, 'HealReady');
	setTimer(2.0, false, 'turnOffHealingEffect');
	}	
}

function turnOffHealingEffect()
{
	Mesh.DetachComponent(healEffect);
	Mesh.DetachComponent(healEffect2);	
}

function turnOffSprintEffect()
{
	Mesh.DetachComponent(sprintEffect1);
	Mesh.DetachComponent(sprintEffect2);
}

simulated function HealReady()
{
	bHealing = true;
}

function EndInvulnerable()
{
    bInvulnerable = false;
}

simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
	super.PostInitAnimTree(SkelComp);
	AimNode.bForceAimDir = true;
}

simulated event PostBeginPlay()
{
	super.PostBeginPlay();
	Mesh.AttachComponentToSocket(swordEffectComponent, swordSocket);
	`Log("Custom Pawn up"); //debug
	//DrawDebugSphere( Location, 100, 25, 255, 100, 100, true) ;
}

simulated event BecomeViewTarget( PlayerController PC )
{
   local UTPlayerController UTPC;

   Super.BecomeViewTarget(PC);

   if (LocalPlayer(PC.Player) != None)
   {
	    UTPC = UTPlayerController(PC);
	    if (UTPC != None)
	  	{
	        //set player controller to behind view and make mesh visible
	        UTPC.SetBehindView(true);
	        SetMeshVisibility(UTPC.bBehindView); 
	        UTPC.bNoCrosshair = true;
	    }
   }
}

simulated function FaceRotation(rotator NewRotation, float DeltaTime)
{
	if (Normal(Acceleration)!=vect(0,0,0))
	{
		if ( Physics == PHYS_Ladder )
		{
			NewRotation = OnLadder.Walldir;
		}
		else if ( (Physics == PHYS_Walking) || (Physics == PHYS_Falling) )
		{
			NewRotation = rotator((Location + Normal(Acceleration))-Location);
			NewRotation.Pitch = 0;
		}
		
		SetRotation(NewRotation);
	}
	
}

simulated function bool CalcCamera( float fDeltaTime, out vector out_CamLoc, out rotator out_CamRot, out float out_FOV )
{
	local vector HitLoc,HitNorm, End, Start, vecCamHeight;

	vecCamHeight = vect(0,0,0);
	vecCamHeight.Z = CamHeight;
	Start = Location;
	End = (Location+vecCamHeight)-(Vector(Controller.Rotation) * CamOffsetDistance);
	out_CamLoc = End;

	if(Trace(HitLoc,HitNorm,End,Start,false,vect(12,12,12))!=none)
	{
		out_CamLoc = HitLoc + vecCamHeight;
	}
	
   out_CamRot=rotator((Location + vecCamHeight) - out_CamLoc);
   return true;
}

simulated function SetGroundSpeed()
{
	Groundspeed = 440;
	setTimer(4, false, 'SprintReady');
}

simulated function SprintReady()
{
	bSprinting = true;
}

exec function StartSprint()
{
	if (bSprinting != false)
	{
		bSprinting = false;
		Weapon.AddAmmo(-25);
		ConsoleCommand("Sprint");
		Groundspeed = 800;
	 	Mesh.AttachComponentToSocket(sprintEffect1, sprintSocket1);
		Mesh.AttachComponentToSocket(sprintEffect2, sprintSocket2);
		UTPawn(Instigator).FullBodyAnimSlot.PlayCustomAnimByDuration('hoverboardoverwater', 2, 0.1, 0.1, FALSE, TRUE );
		PlaySound (sprintSound);
		setTimer(4.0, false, 'turnOffSprintEffect');
		setTimer( 4 , false, 'SetGroundSpeed');
	}
}

exec function StopSprinting()
{
	GroundSpeed = 440;
}

exec function CamZoomIn()
{
	`Log("Zoom in");
	if(CamOffsetDistance > CamMinDistance)
		CamOffsetDistance-=CamZoomTick;
}

exec function CamZoomOut()
{
	`Log("Zoom out");
	if(CamOffsetDistance < CamMaxDistance)
		CamOffsetDistance+=CamZoomTick;
}

defaultproperties
{
Begin Object Class=ParticleSystemComponent Name=healEffectComponent
	Template = ParticleSystem'KismetGame_Assets.Projectile.P_Spit_01'
End object
Begin Object Class=ParticleSystemComponent Name=healEffectComponent2
	Template = ParticleSystem'KismetGame_Assets.Projectile.P_Spit_01'
End object
Begin Object Class=ParticleSystemComponent Name=sprintEffectComponent1
	Template = ParticleSystem'WP_LinkGun.Effects.P_FX_LinkGun_MF_Beam_Blue'
End object
Begin Object Class=ParticleSystemComponent Name=sprintEffectComponent2
	Template = ParticleSystem'WP_LinkGun.Effects.P_FX_LinkGun_MF_Beam_Blue'
End object
Begin Object Class=ParticleSystemComponent Name=swordEffectComponent
    Template = ParticleSystem'GDC_Materials.Effects.P_SwordTrail_01'
End object
	swordSocket = WeaponPoint
	healSound = SoundCue'CastleAudio.UI.UI_TouchToMove_Cue'
	bHealing = true
	bSprinting = true
	healEffect = healEffectComponent
	healEffect2 = healEffectComponent2
	HealSocket = WeaponPoint
	HealSocket2 = DualWeaponPoint
	sprintEffect1 = sprintEffectComponent1
	sprintEffect2 = sprintEffectComponent2
	sprintSocket1 = L_JB
	sprintSocket2 = R_JB
	sprintSound = SoundCue'A_Gameplay.A_Gameplay_Onslaught_PowerNodeStartBuild01Cue'
	RegenAmount=40.0
	MeleeRange=+100.0
	InvulnerableTime=0.3
	SprintRecoverTimer = 10.0
	Stamina = 10.0
	Empty = 1
	CamHeight = 40.0
	CamMinDistance = 40.0
	CamMaxDistance = 350.0
   	CamOffsetDistance=250.0
	CamZoomTick=20.0
	MaxMultiJump=100
	MultiJumpRemaining=100
	MultiJumpBoost=+200.0
	MaxJumpHeight=600.0
	MaxDoubleJumpHeight=600.0
	DoubleJumpThreshold=4000.0	
}