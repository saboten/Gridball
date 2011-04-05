package com.hornbillinteractive.gridball
{
	import com.hornbillinteractive.gridball.Grid;
	
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	
	public class Line
	{
		public var grid:Grid;
		public var timer:Timer;
		public var delay:Number = 100;
		public var distance:Number;
		public var direction:String;
		public var origin:Point;
		public var tip:Point;
		
		public function Line(g:Grid,d:String,xCoord:Number,yCoord:Number)
		{
			grid = g;
			direction = d;
			origin = new Point(xCoord,yCoord);
			
			switch(direction)
			{
				case "north":
					calculateNorthTime();
					break;
				case "south":
					calculateSouthTime();
					break;
				case "east":
					calculateEastTime();
					break;
				case "west":
					calculateWestTime();
					break;
			}
			
			grid.updateTile(origin.x,origin.y,direction);
				
		}
		
		public function pauseLine():void
		{
			timer.stop();
		}
		
		public function unpauseLine():void
		{
			timer.start();
		}
		
		public function breakSelf():void
		{
			timer.stop();
			
			for(var i:Number = 0; i < distance; i++)
			{
				switch(direction)
				{
					case "north":
						grid.updateTile(origin.x,origin.y - i,"empty");
						break;
					case "south":
						grid.updateTile(origin.x,origin.y + i,"empty");
						break;
					case "east":
						grid.updateTile(origin.x + i,origin.y,"empty");
						break;
					case "west":
						grid.updateTile(origin.x - i,origin.y,"empty");
						break;
				}
			}
			
			destroySelf();
		}
		
		private function calculateNorthTime():void
		{
			if(origin.y == 0)
			{
				distance = 0;
				finishLine();
				return
			}
			
			tip = new Point(origin.x, origin.y - 1);
			
			for(var i:Number=tip.y; i >= 0; i--)
			{
				if(grid.examineTile(origin.x, i) == "full" || i == 0)
				{
					distance = origin.y - i;
					timer = new Timer(delay,distance);
					break;
				}
			}
			
			startTimer();
		}
		
		private function calculateSouthTime():void
		{
			if(origin.y == 25)
			{
				distance = 0;
				finishLine();
				return
			}
			
			tip = new Point(origin.x, origin.y + 1);
			
			for(var i:Number=tip.y; i <= 25; i++)
			{
				if(grid.examineTile(origin.x, i) == "full" || i == 25)
				{
					distance = i - origin.y;
					timer = new Timer(delay,distance);
					break;
				}
			}
			
			startTimer();
		}
		
		private function calculateEastTime():void
		{
			if(origin.x == 43)
			{
				distance = 0;
				finishLine();
				return
			}
			
			tip = new Point(origin.x + 1, origin.y);
			
			for(var i:Number=tip.x; i <= 43; i++)
			{
				if(grid.examineTile(i, origin.y) == "full" || i == 43)
				{
					distance = i - origin.x;
					timer = new Timer(delay,distance);
					break;
				}
			}
			
			startTimer();
		}
		
		private function calculateWestTime():void
		{
			if(origin.x == 0)
			{
				distance = 0;
				finishLine();
				return
			}
			
			tip = new Point(origin.x - 1, origin.y);
			
			for(var i:Number=tip.x; i >= 0; i--)
			{
				if(grid.examineTile(i, origin.y) == "full" || i == 0)
				{
					distance = origin.x - i;
					if(distance <= 0)
					{
						destroySelf();
						return
					}
					timer = new Timer(delay,distance);
					break;
				}
			}
			
			startTimer();
		}
		
		private function startTimer():void
		{
			timer.addEventListener(TimerEvent.TIMER,extendLine);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE,finishLine);
			timer.start();
		}
		
		private function destroySelf():void
		{
			if(direction == "north" || direction == "west")
				grid.destroyRedLine();
			else if(direction == "south" || direction == "east")
				grid.destroyBlueLine();
		}
		
		private function extendLine(event:TimerEvent):void
		{
			grid.updateTile(tip.x,tip.y,direction);
			
			switch(direction)
			{
				case "north":	
					tip.y--;
					break;
				case "south":
					tip.y++;
					break;
				case "east":
					tip.x++;
					break;
				case "west":
					tip.x--;
					break;
			}
		}
		
		private function finishLine(event:TimerEvent=null):void
		{			
			for(var i:Number = 0; i <= distance; i++)
			{
				switch(direction)
				{
					case "north":
						grid.updateTile(origin.x,origin.y - i,"full");
						break;
					case "south":
						grid.updateTile(origin.x,origin.y + i,"full");
						break;
					case "east":
						grid.updateTile(origin.x + i,origin.y,"full");
						break;
					case "west":
						grid.updateTile(origin.x - i,origin.y,"full");
						break;
				}
			}
			
			switch(direction)
			{
				case "north":
					if(grid.examineTile(origin.x,origin.y + 1) == "full")
						grid.fillEW(origin.x,origin.y - distance,origin.y);
					break;
				case "south":
					if(grid.examineTile(origin.x,origin.y - 1) == "full")
						grid.fillEW(origin.x,origin.y,origin.y + distance);
					break;
				case "east":
					if(grid.examineTile(origin.x - 1,origin.y) == "full")
						grid.fillNS(origin.y,origin.x,origin.x + distance);
					break;
				case "west":
					if(grid.examineTile(origin.x + 1,origin.y) == "full")
						grid.fillNS(origin.y,origin.x - distance,origin.x);
					break;
			}
			
			grid.drawTiles();
			
			destroySelf();
		}
	}
}