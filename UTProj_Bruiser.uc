/**
 * Copyright 1998-2012 Epic Games, Inc. All Rights Reserved.
 */
class UTProj_Bruiser extends UTProj_Rocket;

simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
	if (Other != Instigator)
	{
		Other.TakeDamage(Damage,InstigatorController,HitLocation,MomentumTransfer * Normal(Velocity), MyDamageType,, self);
		Shutdown();
	}
}

simulated event HitWall(vector HitNormal, actor Wall, PrimitiveComponent WallComp)
{
	Velocity = MirrorVectorByNormal(Velocity, HitNormal);
	SetRotation(Rotator(Velocity));
}

defaultproperties
{
	speed=2500.0
	MaxSpeed=2500.0
	ProjFlightTemplate=ParticleSystem'VH_Scorpion.Effects.P_Scorpion_Bounce_Projectile'
	Damage=25.0
	DrawScale=1.0
	DamageRadius=100
	CheckRadius=50
	MaxEffectDistance=5000.0
}
