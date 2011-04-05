package
{
	import com.hornbillinteractive.gridball.Ball;
	import com.hornbillinteractive.gridball.BitmapNumber;
	import com.hornbillinteractive.gridball.CollisionHandler;
	import com.hornbillinteractive.gridball.GameData;
	import com.hornbillinteractive.gridball.GameInterface;
	import com.hornbillinteractive.gridball.GameOver;
	import com.hornbillinteractive.gridball.Grid;
	import com.hornbillinteractive.gridball.HighScore;
	import com.hornbillinteractive.gridball.Instructions;
	import com.hornbillinteractive.gridball.Level;
	import com.hornbillinteractive.gridball.Menu;
	import com.hornbillinteractive.gridball.Pause;
	import com.hornbillinteractive.gridball.Settings;
	import com.hornbillinteractive.gridball.Star;
	import com.hornbillinteractive.gridball.TextGenerator;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.*;
	import flash.media.*;
	import flash.net.SharedObject;
	import flash.text.*;
	import flash.text.engine.*;
	import flash.ui.Mouse;
	import flash.utils.Timer; 
	
	// The following metadata specifies the size and properties of the canvas that
	// this application should occupy on the BlackBerry PlayBook screen.
	[SWF(width="1024", height="600", backgroundColor="#000000", frameRate="60")]
	
	
	public class GridBall extends Sprite
	{	
		private var menuChannel:SoundChannel;
		private var gameChannel:SoundChannel;
		private var menuSound:Sound;
		private var gameSound:Sound;
		private var canvasBD:BitmapData;
		private var canvasBitmap:Bitmap;
		private var backgroundBD:BitmapData;
		private var backgroundRect:Rectangle;
		private var backgroundPoint:Point;
		private var ballArray:Array;
		private var starArray:Array;
		private var grid:Grid;
		private var cHandler:CollisionHandler;
		private var pause:Boolean;
		private var savedGameData:SharedObject;
		private var gameTime:Timer;
		private var gData:GameData;
		private var txt:TextGenerator;
		private var gameInterfaceScreen:GameInterface;
		private var pauseScreen:Pause;
		private var menu:Menu;
		private var gameOverScreen:GameOver;
		private var nextLevelScreen:Level;
		private var settingsScreen:Settings;
		private var instructionsScreen:Instructions;
		private var highScoreScreen:HighScore;
		private var fadeTimer:Timer;
		
		public function GridBall()
		{	
			canvasBD = new BitmapData(1024,600,false,0x000000);
			canvasBitmap = new Bitmap(canvasBD);
			ballArray = new Array();
			starArray = new Array();
			cHandler = new CollisionHandler();
			pause = false;
			savedGameData = SharedObject.getLocal("gridball_game_data");
			gameTime = new Timer(1000);
			gameTime.addEventListener(TimerEvent.TIMER,decrementTime);
			gData = new GameData();
			txt = new TextGenerator();
			pauseScreen = new Pause(unpauseGame,endGame);
			menu = new Menu(beginGame,viewSettings,viewInstructions,viewHighScores);
			gameOverScreen = new GameOver(endGame);
			nextLevelScreen = new Level(nextLevel);
			instructionsScreen = new Instructions(returnToMenu);
			highScoreScreen = new HighScore(savedGameData,returnToMenu);
			settingsScreen = new Settings(savedGameData,returnToMenu);
			
			initializeBackground();
			initializeSavedGameData();
			initializeSound();
			createStars();
			
			addChild(canvasBitmap);
			addChild(pauseScreen);
			addChild(menu);
			addChild(gameOverScreen);
			addChild(nextLevelScreen);
			addChild(settingsScreen);
			addChild(instructionsScreen);
			addChild(highScoreScreen);
			this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		private function beginGame(event:MouseEvent):void
		{
			fadeOutMenuChannel()
			gameChannel = gameSound.play(0,int.MAX_VALUE,new SoundTransform(0.5));
			startLevel();
		}
		
		private function fadeOutMenuChannel():void
		{
			fadeTimer = new Timer(10,30);
			fadeTimer.addEventListener(TimerEvent.TIMER,fadeMenuChannel);
			fadeTimer.addEventListener(TimerEvent.TIMER_COMPLETE,stopMenuChannel);
			fadeTimer.start();
		}
		
		private function fadeMenuChannel(event:TimerEvent):void
		{
			menuChannel.soundTransform = new SoundTransform((30-fadeTimer.currentCount)/30);
		}
		
		private function stopMenuChannel(event:TimerEvent):void
		{
			menuChannel.stop();
		}
		
		private function fadeOutGameChannel():void
		{
			fadeTimer = new Timer(10,30);
			fadeTimer.addEventListener(TimerEvent.TIMER,fadeGameChannel);
			fadeTimer.addEventListener(TimerEvent.TIMER_COMPLETE,stopGameChannel);
			fadeTimer.start();
		}
		
		private function fadeGameChannel(event:TimerEvent):void
		{
			gameChannel.soundTransform = new SoundTransform(((30-fadeTimer.currentCount)/30)*0.5);
		}
		
		private function stopGameChannel(event:TimerEvent):void
		{
			gameChannel.stop();
		}
		
		public function nextLevel(event:MouseEvent):void
		{
			removeChildAt(1);
			startLevel(gData.level+1);
			nextLevelScreen.visible = false;
		}
		
		private function startLevel(l:Number=1):void
		{
			gData = new GameData(l,gData.totalScore + gData.levelScore);
			pause = false;
			grid = new Grid(this);
			gameInterfaceScreen = new GameInterface(grid,pauseGame);
			addChildAt(gameInterfaceScreen,1);
			for(var i:Number = 0; i < gData.level + 1; i++)
				ballArray[i] = new Ball(false,grid,savedGameData.data.difficulty);
			
			menu.visible = false;
			
			gData.currentTime = 999;
			gameTime.start();
			
		}
		
		public function endGame(event:MouseEvent):void
		{
			pause = false;
			gData.level = 0;
			gData.totalScore = 0;
			gData.levelScore = 0;
			grid = null;
			ballArray = new Array();
			pauseScreen.visible = false;
			gameOverScreen.visible = false;
			removeChildAt(1);
			fadeOutGameChannel()
			menuChannel = menuSound.play(0,int.MAX_VALUE);
			menu.visible = true;
		}
		
		private function decrementTime(event:TimerEvent):void
		{
			gData.decrementTime();
			if(gData.currentTime == 0)
			{
				gameOver();
			}
				
		}
		
		private function gameOver():void
		{
			pause = true;
			for(var i:Number=0; i < ballArray.length; i++)
				ballArray[i].pause = (true);
			
			gameOverScreen.highScore.visible = false;
			switch(savedGameData.data.difficulty)
			{
				case 1:
					if((gData.levelScore + gData.totalScore) > savedGameData.data.easyHighScore)
					{
						savedGameData.data.easyHighScore = gData.levelScore + gData.totalScore;
						gameOverScreen.highScore.visible = true;
						gameOverScreen.updateHighScore(gData.levelScore + gData.totalScore);
					}
					break
				case 2:
					if((gData.levelScore + gData.totalScore) > savedGameData.data.normalHighScore)
					{
						savedGameData.data.normalHighScore = gData.levelScore + gData.totalScore;
						gameOverScreen.highScore.visible = true;
						gameOverScreen.updateHighScore(gData.levelScore + gData.totalScore);
					}
					break
				case 3:
					if((gData.levelScore + gData.totalScore) > savedGameData.data.hardHighScore)
					{
						savedGameData.data.hardHighScore = gData.levelScore + gData.totalScore;
						gameOverScreen.highScore.visible = true;
						gameOverScreen.updateHighScore(gData.levelScore + gData.totalScore);
					}
					break
			}
			
			savedGameData.flush();
			
			gameOverScreen.visible = true;
			grid.pauseGrid();
			gameTime.stop();
		}
		
		public function loseLife():void
		{
			gData.loseLife();
			if(gData.lives <= 0)
			{
				gameOver();
			}
		}
		
		public function createStars():void
		{
			for(var i:Number = 0; i < 20; i++)
			{
				starArray[i] = new Star();
			}
		}
		
		public function updatePercentClear(cleared:Number):void
		{
			gData.updatePercentClear(cleared);
			if(cleared >= 75)
			{
				gameInterfaceScreen.screenSurface.removeEventListener(MouseEvent.CLICK,grid.startLine);
				pause = true;
				for(var i:Number=0; i < ballArray.length; i++)
					ballArray[i].pause = (true);
				nextLevelScreen.visible = true;
				grid.pauseGrid();
				gameTime.stop();
			}
		}
		
		public function updateScore(emptyTiles:Number):void
		{
			gData.updateScore(emptyTiles);
		}
		
		public function updateBallData():void
		{
			grid.clearBallData();
			
			for(var i:Number = 0; i < ballArray.length; i++)
			{
				grid.ballData[grid.stageToGrid("X",ballArray[i].p.x)][grid.stageToGrid("Y",ballArray[i].p.y)] = true;
				grid.ballData[grid.stageToGrid("X",ballArray[i].p.x + 20)][grid.stageToGrid("Y",ballArray[i].p.y)] = true;
				grid.ballData[grid.stageToGrid("X",ballArray[i].p.x)][grid.stageToGrid("Y",ballArray[i].p.y + 20)] = true;
				grid.ballData[grid.stageToGrid("X",ballArray[i].p.x + 20)][grid.stageToGrid("Y",ballArray[i].p.y + 20)] = true;
			}
		}
		
		private function initializeBackground():void
		{
			backgroundBD = new BitmapData(1024,600,false,0x000000);
			backgroundRect = new Rectangle(0,0,1024,600);
			backgroundPoint = new Point(0,0);
		}
		
		private function initializeSavedGameData():void
		{
			if(savedGameData.data.difficulty != 1 && savedGameData.data.difficulty != 2 && savedGameData.data.difficulty != 3)
				savedGameData.data.difficulty = 2;
			
			if(savedGameData.data.easyHighScore == null)
				savedGameData.data.easyHighScore = 0;
			
			if(savedGameData.data.normalHighScore == null)
				savedGameData.data.normalHighScore = 0;
			
			if(savedGameData.data.hardHighScore == null)
				savedGameData.data.hardHighScore = 0;
			
			savedGameData.flush();
		}
		
		private function initializeSound():void
		{
			[Embed(source="/data/menu_music.mp3")]
			var MenuMusic:Class;
			
			[Embed(source="/data/game_music.mp3")]
			var GameMusic:Class;
			
			[Embed(source="/data/err.mp3")]
			var ErrMusic:Class;
			
			menuSound = new MenuMusic() as Sound;
			menuChannel = menuSound.play(0,int.MAX_VALUE);
			
			gameSound = new GameMusic() as Sound; 
		}
		
		private function viewSettings(event:MouseEvent):void
		{
			gData.level = -1;
			menu.visible = false;
			settingsScreen.visible = true;
		}
		
		private function viewInstructions(event:MouseEvent):void
		{
			gData.level = -1;
			menu.visible = false;
			instructionsScreen.visible = true;
		}
		
		private function viewHighScores(event:MouseEvent):void
		{
			highScoreScreen.updateHighScores();
			gData.level = -1;
			menu.visible = false;
			highScoreScreen.visible = true;
		}
		
		private function returnToMenu(event:MouseEvent):void
		{
			gData.level = 0;
			menu.visible = true;
			settingsScreen.visible = false;
			instructionsScreen.visible = false;
			highScoreScreen.visible = false;
		}

		private function pauseGame(event:MouseEvent):void
		{
			pause = true;
			for(var i:Number=0; i < ballArray.length; i++)
				ballArray[i].pause = (true);
			pauseScreen.visible = true;
			grid.pauseGrid();
			gameTime.stop();
		}
		
		public function unpauseGame(event:MouseEvent):void
		{
			pause = false;
			for(var i:Number=0; i < ballArray.length; i++)
				ballArray[i].pause = false;
			pauseScreen.visible = false;
			grid.unpauseGrid();
			gameTime.start();
		}
		
		
		private function enterFrameHandler ( E:Event ) : void
		{	
			if(pause == false && gData.level > 0)
				measureBalls()
			draw();
		}
		
		private function measureBalls():void
		{
			for(var i:Number = 0; i < ballArray.length; i++)
			{
				var ball1:Ball = ballArray[i];
				
				for(var j:Number = i + 1; j < ballArray.length; j++)
				{
					var ball2:Ball = ballArray[j];
					
					var distX:Number = ball1.xCenter() - ball2.xCenter();
					var distY:Number = ball1.yCenter() - ball2.yCenter();
					var distance:Number = Math.sqrt(distX  * distX + distY * distY);
					
					if(distance < 20)
					{
						cHandler.collideBalls(ball1, ball2, distX, distY, distance);
					}
				}
			}
		}
		
		private function draw():void
		{
			canvasBD.lock();

			canvasBD.copyPixels(backgroundBD,backgroundRect, backgroundPoint);
			
			for(var i:Number = 0; i < starArray.length; i++)
				canvasBD.copyPixels(starArray[i].BD,starArray[i].rect,starArray[i].p);
			
			if(gData.level == 0)
			{
				canvasBD.copyPixels(menu.BD,menu.rect, menu.p);
				canvasBD.copyPixels(menu.logoDot.getActiveBD(),menu.logoDot.rect,menu.logoDot.p);
			}
			
			if(gData.level > 0)
			{
				canvasBD.copyPixels(grid.BD,grid.rect,grid.p);
				canvasBD.copyPixels(gData.BD,gData.rect,gData.p);
				
				for(i = 0; i < ballArray.length; i++)
					canvasBD.copyPixels(ballArray[i].getActiveBD(),ballArray[i].rect,ballArray[i].p);
				
				for(i = 0; i < gData.lives; i++)
					if(gData.lifeArray[i] != null)
						canvasBD.copyPixels(gData.lifeArray[i].getActiveBD(),gData.lifeArray[i].rect,gData.lifeArray[i].p);
			}
			
			canvasBD.unlock();
		}		
	}
}