package com.hornbillinteractive.gridball
{
	import com.hornbillinteractive.gridball.Line;
	import com.hornbillinteractive.gridball.Tile;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.*;
	import flash.text.engine.TextLine;
	import flash.utils.getTimer;
	import flash.media.*;
	
	public class Grid extends Sprite
	{
		private var gridData:Array;
		private var checkedTiles:Array;
		private var gBall:GridBall;
		public var ballData:Array;
		public var BD:BitmapData;
		public var rect:Rectangle;
		public var p:Point;
		public var redLine:Line;
		public var blueLine:Line;
		public var direction:String;
		public var pause:Boolean;
		public var cleared:Number;
		public var errSound:Sound;
		public var errChannel:SoundChannel;
		public var tweetSound:Sound;
		public var tweetChannel:SoundChannel;
		
		public function Grid(g:GridBall)
		{
			gBall = g;
			gridData = new Array();
			ballData = new Array();
			checkedTiles = new Array();
			rect = new Rectangle(0,0,880,520);
			p = new Point(100,40);
			direction = "ns";
			pause = false;
			
			[Embed(source="/data/err.mp3")]
			var ErrMusic:Class;
			
			[Embed(source="/data/tweet.mp3")]
			var TweetMusic:Class;
			
			errSound = new ErrMusic() as Sound;
			tweetSound = new TweetMusic() as Sound;
			
			for(var i:Number = 0; i < 44; i++)
			{
				gridData[i] = new Array();
				ballData[i] = new Array();
				checkedTiles[i] = new Array();
				
				for(var j:Number = 0; j < 26; j++)
				{
					gridData[i][j] = new Tile(i,j);
					ballData[i][j] = false;
					checkedTiles[i][j] = true;
				}
			}
			drawTiles();
		}
		
		public function examineTile(xCoord:Number,yCoord:Number):String
		{
			if(xCoord < 0 || xCoord > 43 || yCoord < 0 || yCoord > 25)
			{
				return "full"
			}
			
			return gridData[xCoord][yCoord].state;
		}
		
		public function stageToGrid(axis:String,coord:Number):Number
		{
			switch(axis)
			{
				case "X":
					return int((coord - 100) / 20)
				case "Y":
					return int((coord - 40) / 20)
				default:
					return 0
			}
		}
		
		public function clearBallData():void
		{
			for(var i:Number = 0; i < 44; i++)
			{			
				for(var j:Number = 0; j < 26; j++)
				{
					ballData[i][j] = false;
				}
			}
		}
		
		public function startLine( event:MouseEvent ):void
		{
			if(redLine != null || blueLine != null || pause == true)
				return
				
			if(event.stageY > 545 || event.stageY < 55 || event.stageX > 965 || event.stageX < 115)
				return
				
			if(direction == "ns")
				startNSLines(event.stageX,event.stageY);
			else if(direction == "ew")
				startEWLines(event.stageX,event.stageY);
			
		}
		
		private function startEWLines(stageX:Number,stageY:Number):void
		{
			var row:Number = stageToGrid("Y", stageY);
			var west:Number = stageToGrid("X",stageX);
			var east:Number;
			
			if(west == stageToGrid("X", stageX - 10))
			{
				east = stageToGrid("X", stageX + 10);
			}
			else
			{
				east = west;
				west = stageToGrid("X", stageX - 10)
			}
			
			if(examineTile(west,row) != "full")
				redLine = new Line(this,"west",west,row);
			if(examineTile(east,row) != "full")
				blueLine = new Line(this,"east",east,row);
		}
		
		private function startNSLines(stageX:Number,stageY:Number):void
		{
			var column:Number = stageToGrid("X", stageX);
			var north:Number = stageToGrid("Y", stageY);
			var south:Number;
			
			if(north == stageToGrid("Y", stageY - 10))
			{
				south = stageToGrid("Y", stageY + 10);
			}
			else
			{
				south = north;
				north = stageToGrid("Y", stageY - 10)
			}
			
			if(examineTile(column,north) != "full")
				redLine = new Line(this,"north",column,north);
			if(examineTile(column,south) != "full")
				blueLine = new Line(this,"south",column,south);
		}
		
		public function destroyRedLine():void
		{
			redLine = null;
		}
		
		public function destroyBlueLine():void
		{
			blueLine = null;
		}
		
		public function loseLife():void
		{
			gBall.loseLife();
			tweetChannel = tweetSound.play();
		}
		
		public function updateTile(xCoord:Number,yCoord:Number,state:String):void
		{
			gridData[xCoord][yCoord].setState(state);
			if(state != "full")
				drawTiles();
		}
		
		public function fillEW(column:Number,north:Number,south:Number):void
		{
			gBall.updateBallData();

			for(var i:Number = north; i <= south; i++)
			{
				if(examineTile(column + 1,i) != "fill")
					findEmptyTiles(column + 1, i);
				
				if(examineTile(column - 1,i) != "fill")
					findEmptyTiles(column - 1, i);
			}
			
			errChannel = errSound.play();
		}
		
		public function fillNS(row:Number,west:Number,east:Number):void
		{
			gBall.updateBallData();
			
			for(var i:Number = west; i <= east; i++)
			{
				if(examineTile(i,row + 1) == "empty")
					findEmptyTiles(i,row + 1);
				
				if(examineTile(i,row - 1) == "empty")
					findEmptyTiles(i,row - 1);
			}
			
			errChannel = errSound.play();
		}
		
		private function findEmptyTiles(xCoord:Number,yCoord:Number):void
		{
			var p:Point;
			
			clearCheckedTiles();
			var queue:Array = new Array();
			queue.push(new Point(xCoord,yCoord));
			
			while(queue.length > 0)
			{
				p = queue.pop();
				if(ballData[p.x][p.y] == true)
					return
				else
				{
					if(p.x + 1 <= 43 && checkedTiles[p.x + 1][p.y] == false && examineTile(p.x + 1,p.y) == "empty")
						queue.push(new Point(p.x + 1,p.y));
					if(p.x - 1 >= 0 && checkedTiles[p.x - 1][p.y] == false && examineTile(p.x - 1,p.y) == "empty")
						queue.push(new Point(p.x - 1,p.y));
					if(p.y + 1 <= 25 && checkedTiles[p.x][p.y + 1] == false && examineTile(p.x,p.y + 1) == "empty")
						queue.push(new Point(p.x,p.y + 1));
					if(p.y - 1 >= 0 && checkedTiles[p.x][p.y - 1] == false && examineTile(p.x,p.y - 1) == "empty")
						queue.push(new Point(p.x,p.y - 1));
				}
				checkedTiles[p.x][p.y] = true;
			}
			
			for(var i:Number = 0; i < 44; i++)
			{			
				for(var j:Number = 0; j < 26; j++)
				{
					if(checkedTiles[i][j] == true)
						updateTile(i,j,"full");
				}
			}
			drawTiles();
		}
		
		private function clearCheckedTiles():void
		{
			for(var i:Number = 0; i < 44; i++)
			{			
				for(var j:Number = 0; j < 26; j++)
				{
					checkedTiles[i][j] = false;
				}
			}
		}
		
		public function checkXCollisions(xCoord:Number,yStart:Number):Number
		{
			var collidedPoints:Number = 0;
			for(var i:Number = yStart + 1; i <= yStart + 18; i++)
			{
				var state:String = examineTile(int(xCoord / 20),int(i / 20));	
				collidedPoints += countCollisions(state);
				
			}
			return collidedPoints;
		}
		
		public function checkYCollisions(yCoord:Number,xStart:Number):Number
		{
			var collidedPoints:Number = 0;
			for(var i:Number = xStart + 1; i <= xStart + 18; i++)
			{
				var state:String = examineTile(int(i / 20),int(yCoord / 20))
				collidedPoints += countCollisions(state);
				
			}
			return collidedPoints;
		}
		
		private function countCollisions(state:String):Number
		{
			switch(state)
			{
				case "full":
					return 1;
				case "north":
					if(redLine != null)
					{
						redLine.breakSelf();
						loseLife();
					}
					break;
				case "south":
					if(blueLine != null)
					{
						blueLine.breakSelf();
						loseLife();
					}
					break;
				case "east":
					if(blueLine != null)
					{
						blueLine.breakSelf();
						loseLife();
					}
					break;
				case "west":
					if(redLine != null)
					{
						redLine.breakSelf();
						loseLife();
					}
					break;
			}
			return 0
		}
		
		public function pauseGrid():void
		{
			pause = true;
			if(blueLine)
				blueLine.pauseLine();
			if(redLine)
				redLine.pauseLine();
		}
		
		public function unpauseGrid():void
		{
			pause = false;
			if(blueLine)
				blueLine.unpauseLine();
			if(redLine)
				redLine.unpauseLine();
		}
		
		public function drawTiles():void
		{
			var missingCount:Number = 0;
			BD = new BitmapData(880,520,true,0x00000000);
			for(var i:Number = 0; i < 44; i++)
			{				
				for(var j:Number = 0; j < 26; j++)
				{
					if(gridData[i][j].state != "full")
						BD.copyPixels(gridData[i][j].BD,gridData[i][j].rect,gridData[i][j].p);
					else
						missingCount++;
				}
			}
			cleared = (missingCount / 1144) * 100;
			gBall.updatePercentClear(int(cleared));
			gBall.updateScore(missingCount);
		}
	}
}