class MyHUD extends UTHUD;

var const Texture2D HudFrame;
var const Texture2D healGreenBar;
var const Texture2D sprintBlueBar;

function DrawBar(String Title, float Value, float MaxValue,int X, int Y, int R, int G, int B)
{

    local int PosY;
    local int BarSizeY;
		
    PosY = Y;

	X = 503 + ((MaxValue - Value) * 1.9);
  
	if( MaxValue > 0 )
	{
		BarSizeY = 195 * FMin(Value / MaxValue, 1);
	}
	 
	Canvas.SetPos(PosY,X);
	Canvas.SetDrawColor(R, G, B, 85);
	Canvas.DrawRect(225, BarSizeY);
} 

function DrawGameHud()
{
    local ActionPlayerController PC;
    PC = ActionPlayerController(PlayerOwner);
	    
	if( PlayerOwner == none || PlayerOwner.Pawn == none )
	{
		return;
	}

	if ( !PlayerOwner.IsDead() && !UTPlayerOwner.IsInState('Spectating'))
	{    
		DrawBar(" ",PlayerOwner.Pawn.Health, PlayerOwner.Pawn.HealthMax,500,30,255,0,10); 

		Canvas.Reset(false);
		Canvas.SetPos(0,0);
		DrawBar(" ",UTWeapon(PawnOwner.Weapon).AmmoCount, UTWeapon(PawnOwner.Weapon).MaxAmmoCount ,500,1000,80,80,200);
		
		Canvas.Reset(false);
		Canvas.SetPos(0,0);
		Canvas.DrawTile(HudFrame, HudFrame.SizeX*0.67, HudFrame.SizeY*0.67, 20, -1078, HudFrame.SizeX, HudFrame.SizeY,, true);

		if ( PC.curLevel != PC.maxLevel )
		{
			Canvas.Reset(false);
			Canvas.SetPos(350 ,575);
			Canvas.SetDrawColor(80, 255, 80);
			Canvas.DrawText("Current Exp:" @ PC.curXP @ " / " @ PC.maxXP);		
		}
	}

	if (ActionPawn(PlayerOwner.Pawn).bHealing)
	{
		Canvas.Reset(false);
		Canvas.SetPos(395, 655);
		Canvas.DrawTile(healGreenBar, healGreenBar.SizeX*0.25, healGreenBar.SizeY*0.18, 20, -1035, healGreenBar.SizeX, healGreenBar.SizeY,, true);
	}

	if (ActionPawn(PlayerOwner.Pawn).bSprinting)
	{
		Canvas.Reset(false);
		Canvas.SetPos(760, 655);
		Canvas.DrawTile(sprintBlueBar, sprintBlueBar.SizeX*0.25, sprintBlueBar.SizeY*0.18, 20, -1035, sprintBlueBar.SizeX, sprintBlueBar.SizeY,, true);
	}

	Canvas.Reset(false);
	Canvas.Drawcolor = WhiteColor;
	Canvas.Font = class'Engine'.Static.GetLargeFont();

    if(PlayerOwner.Pawn != none)
    {
        Canvas.SetPos(Canvas.ClipX * 0.25, Canvas.ClipY * 0.75);
        Canvas.DrawText("Weapon Level:" @ PC.curLevel);
		Canvas.SetPos(Canvas.ClipX * 0.6, Canvas.ClipY * 0.75);
		Canvas.DrawText("Enemies Left:" @ ActionGame(WorldInfo.Game).EnemiesLeft);
    }

	if((ActionGame(WorldInfo.Game).CurrentWave >= 4))
	{
		Canvas.SetPos(Canvas.ClipX * 0.45, Canvas.ClipY * 0.5);
		Canvas.DrawText("You Win!!");
	}

	if(ActionGame(WorldInfo.Game).displayWaveText)
	{
		if(ActionGame(WorldInfo.Game).CurrentWave == 0)
		{
		Canvas.Reset(false);
		Canvas.SetPos(Canvas.ClipX * 0.25 ,Canvas.ClipY * 0.5);
		Canvas.SetDrawColor(255, 0, 0);
		Canvas.Font = class'Engine'.Static.GetLargeFont();
		Canvas.DrawText("Enemies at the entrance! Quick, find a weapon!");	
		}
		if(ActionGame(WorldInfo.Game).CurrentWave == 1)
		{
		Canvas.Reset(false);
		Canvas.SetPos(Canvas.ClipX * 0.3 ,Canvas.ClipY * 0.5);
		Canvas.SetDrawColor(255, 0, 0);
		Canvas.Font = class'Engine'.Static.GetLargeFont();
		Canvas.DrawText("Enemies on the main floor! Defend yourself!");	
		}
		if(ActionGame(WorldInfo.Game).CurrentWave == 2)
		{
		Canvas.Reset(false);
		Canvas.SetPos(Canvas.ClipX * 0.3 ,Canvas.ClipY * 0.5);
		Canvas.SetDrawColor(255, 0, 0);
		Canvas.Font = class'Engine'.Static.GetLargeFont();
		Canvas.DrawText("Enemies entering through the top of the cave!");	
		}
		if(ActionGame(WorldInfo.Game).CurrentWave == 3)
		{
		Canvas.Reset(false);
		Canvas.SetPos(Canvas.ClipX * 0.3 ,Canvas.ClipY * 0.5);
		Canvas.SetDrawColor(255, 0, 0);
		Canvas.Font = class'Engine'.Static.GetLargeFont();
		Canvas.DrawText("Enemies landing on the western balcony!");
		}
	}

}

defaultproperties
{
	HudFrame = Texture2D'MyPackage.dualGlobe'
	healGreenBar = Texture2D'MyPackage.healGreen'
	sprintBlueBar = Texture2D'MyPackage.sprintBlue'
} 