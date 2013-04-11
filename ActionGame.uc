class ActionGame extends UTTeamGame
config(ActionGame);

var int EnemiesLeft;
var int CurrentWave;
var bool displayWaveText;
var soundcue PregameSounds[4];
var soundcue pancakeSample;
var soundcue massacreSample;
var int currentCountdownSeconds;
var int maxCountdownSeconds;

function StartMatch()
{
	Super.StartMatch();
	GoToState('PendingSpawners');
}

state PendingSpawners
{
	function BeginState(name PreviousStateName)
	{
		displayWaveText = true;
		SetTimer(1.5, true, 'Countdown');

	}

	function EndState(name NextStateName)
	{
		ClearTimer('Countdown');		
	}

	function Countdown()
	{
		PlaySound(PregameSounds[currentCountdownSeconds++]);

		if( currentCountdownSeconds >= maxCountdownSeconds)
		{
			currentCountdownSeconds=0;
			StartSpawning();
		}
	}

	function StartSpawning()
	{
		`log(" Starting Spawning ");
		ActivateSpawners();
		currentCountdownSeconds = 0;
		GoTostate('');	
		displayWaveText = false;	
	}
}

function AddInitialBots()
{
}


function ScoreKill(Controller Killer, Controller Other)
{
	local ActionPlayerController PC;
	super.ScoreKill(Killer, Other);

	PC = ActionPlayerController(Killer);
	PC.GiveXP(75);

	EnemiesLeft--;

	if ( EnemiesLeft <= 0)
	{
		CurrentWave++;
		CleanupAllBots();
		GoToState('PendingSpawners');
		
		PlaySound( massacreSample );
	}

	if ( CurrentWave >= 4 )
	{
		CleanupAllBots();
		PlaySound( pancakeSample );
	}
	
	Super.ScoreKill(Killer, Other );

}

function CleanupAllBots()
{
	local UTPawn pawn;
	foreach DynamicActors(class'UTPawn', pawn)
	{
		if( PlayerController(pawn.Controller) == none )
		{
			pawn.Destroy();				
		}
	}
}

function ActivateSpawners()
{
	local int i;
	local ActionMapInfo MapInfo;
	
	`log(self@GetFuncName());
	MapInfo = ActionMapInfo(WorldInfo.GetMapInfo());
	
	for( i=0 ; i< MapInfo.WaveInfo[CurrentWave].requiredEnemiesToKill ; i++ )
	{		
		AddCustomBot();
	}

	EnemiesLeft = MapInfo.WaveInfo[CurrentWave].requiredEnemiesToKill;
}

function NavigationPoint FindPlayerStart(Controller Player, optional byte InTeam, optional string incomingName)
{
	local ActionMapInfo MapInfo;	
	local int spawnIndex;
	local NavigationPoint result;
		
	MapInfo = ActionMapInfo(WorldInfo.GetMapInfo());
	spawnIndex = Rand(MapInfo.WaveInfo[CurrentWave].spawnLocations.Length);		
	result = MapInfo.WaveInfo[CurrentWave].spawnLocations[spawnIndex];

	`log("Finding player start for "@Player@" at"@ result);
	return result;
}

function AddCustomBot()
{
	local UTBot NewBot;
	local UTTeamInfo BotTeam;
	local CharacterInfo BotInfo;

	BotTeam = GetBotTeam(,true,1);
	BotInfo = BotTeam.GetBotInfo("Enemy Bot");

	NewBot = Spawn(BotClass);
	NewBot.Skill += 1.0;

	`log(" Adding custom bot "@NewBot);
	if ( NewBot != None )
	{
		InitializeBot(NewBot, BotTeam, BotInfo);

		if (BaseMutator != None)
		{
			BaseMutator.NotifyLogin(NewBot);
		}
		ReStartPlayer(NewBot);
	}

}

function UTBot AddBot(optional string BotName, optional bool bUseTeamIndex, optional int TeamIndex)
{
}

function bool TooManyBots(Controller botToRemove)
{
	local TeamInfo BotTeam, OtherTeam;

	if ( bForceAllRed )
		return false;
	if ( (!bPlayersVsBots || (WorldInfo.NetMode == NM_Standalone)) && (UTBot(botToRemove) != None) &&
		(!bCustomBots || (WorldInfo.NetMode != NM_Standalone)) && botToRemove.PlayerReplicationInfo.Team != None )
	{
		BotTeam = botToRemove.PlayerReplicationInfo.Team;
		OtherTeam = Teams[1-BotTeam.TeamIndex];
		if ( OtherTeam.Size < BotTeam.Size - 5 )
		{
			return true;
		}
		else if ( OtherTeam.Size > BotTeam.Size )
		{
			return false;
		}
	}
	if ( (WorldInfo.NetMode != NM_Standalone) && bPlayersVsBots )
		return ( NumBots > Min(16,BotRatio*NumPlayers) );
	if ( bPlayerBecameActive )
	{
		bPlayerBecameActive = false;
		return true;
	}
	return ( NumBots + NumPlayers > DesiredPlayerCount );
}

defaultproperties
{
	DefaultInventory(0) = class'AlexGame.UTWeap_Staff'
	DefaultInventory(1) = class'AlexGame.UTWeap_MyWeap'
	bAutoNumBots = false
	EnemiesLeft = 20
	bScoreDeaths = false
	DefaultPawnClass = class'AlexGame.ActionPawn'
	PlayerControllerClass = class'AlexGame.ActionPlayerController'
    HUDType = class'AlexGame.MyHUD'
	bUseClassicHud = true
	CurrentWave = 0
	displayWaveText = false
	bPlayersVsBots = true
	PregameSounds[0] = SoundCue'MyPackage.A_3'	
	PregameSounds[1] = SoundCue'MyPackage.A_2'
	PregameSounds[2] = SoundCue'MyPackage.A_1'
	PregameSounds[3]= soundCue'MyPackage.A_Play'
	currentCountdownSeconds = 0
	maxCountdownSeconds = 4
	pancakeSample = SoundCue'MyPackage.myPancake'
	massacreSample = SoundCue'MyPackage.A_Massacre'
	DefaultMaxLives = 50
} 