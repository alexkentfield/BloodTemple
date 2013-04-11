class ActionPlayerController extends UTPlayerController;
 
var int maxLevel;
var int curLevel; 
var int curXP; 
var int maxXP;

exec function CastHeal()
{
  ActionPawn(Pawn).CastHeal();
}

exec function StartSprint()
{
  ActionPawn(Pawn).StartSprint();
}

state PlayerWalking
{
ignores SeePlayer, HearNoise, Bump;

   function ProcessMove(float DeltaTime, vector NewAccel, eDoubleClickDir DoubleClickMove, rotator DeltaRot)
   {
	   local Vector tempAccel;
		local Rotator CameraRotationYawOnly;
		
      if( Pawn == None )
      {
         return;
      }

      if (Role == ROLE_Authority)
      {
         Pawn.SetRemoteViewPitch( Rotation.Pitch );
      }

      tempAccel.Y =  PlayerInput.aStrafe * DeltaTime * 100 * PlayerInput.MoveForwardSpeed;
      tempAccel.X = PlayerInput.aForward * DeltaTime * 100 * PlayerInput.MoveForwardSpeed;
      tempAccel.Z = 0; 
      
	CameraRotationYawOnly.Yaw = Rotation.Yaw; 
	tempAccel = tempAccel>>CameraRotationYawOnly; 
	Pawn.Acceleration = tempAccel;
   
	Pawn.FaceRotation(Rotation,DeltaTime); 

    CheckJumpOrDuck();
   }
}

function UpdateRotation( float DeltaTime )
{
local Rotator   DeltaRot, newRotation, ViewRotation;

   ViewRotation = Rotation;
   if (Pawn!=none)
   {
      Pawn.SetDesiredRotation(ViewRotation);
   }

   DeltaRot.Yaw   = PlayerInput.aTurn;
   DeltaRot.Pitch   = PlayerInput.aLookUp;

   ProcessViewRotation( DeltaTime, ViewRotation, DeltaRot );
   SetRotation(ViewRotation);

   NewRotation = ViewRotation;
   NewRotation.Roll = Rotation.Roll;

   if ( Pawn != None )
      Pawn.FaceRotation(NewRotation, deltatime);
}   

public function GiveXP(int amount)
{
   curXP += amount;
    
   while (curXP >= maxXP && curLevel < maxLevel)
   {
      curXP -= maxXP;
      curLevel++;
      maxXP += 20;
   }
}

DefaultProperties
{
   curLevel = 1;
   curXP = 1;
   maxXP = 100;
   maxLevel = 5;
}