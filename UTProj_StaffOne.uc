/**
 * Copyright 1998-2012 Epic Games, Inc. All Rights Reserved.
 */
class UTProj_StaffOne extends UTProj_ShockBall;


defaultproperties
{
	Damage=15.0
	DrawScale=0.7
	DamageRadius=200
	CheckRadius=100.0
	MaxEffectDistance=20000.0
	speed=3500.0
	MaxSpeed=3500.0
	LifeSpan=1.0
	ProjFlightTemplate=ParticleSystem'VH_Scorpion.Effects.PS_Scorpion_Gun_Impact'
	AmbientSound=SoundCue'A_Pickups.Health.Cue.A_Pickups_Health_Medium_Cue'
	ExplosionSound=SoundCue'A_Pickups_Powerups.PowerUps.A_Powerup_JumpBoots_JumpCue'
	bCheckProjectileLight=true
	ProjectileLightClass=class'UTGame.UTRocketLight'
	ExplosionLightClass=class'UTGame.UTRocketExplosionLight'
}
