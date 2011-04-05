package com.hornbillinteractive.gridball
{
	import com.hornbillinteractive.gridball.Grid;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.*;
	import flash.utils.Timer;

	public class Ball extends Sprite
	{
		public var dx:Number;
		public var dy:Number;
		public var pause:Boolean;
		public var rect:Rectangle;
		public var p:Point;
		public var grid:Grid;
		public var animationArray:Array;
		public var animationTimer:Timer;
		public var animationIndex:Number;
		
		public function Ball(stationary:Boolean=false,g:Grid=null,difficulty:Number=2)
		{
			initializeAnimationArray();
			animationIndex = 0;
			rect = new Rectangle(0,0,20,20);
			p = new Point();
			pause = false;
			
			if(stationary == false)
			{
				grid = g;
				
				var magnitude:Number = difficulty * 2;
				var direction:Number = randDirection();	
				
				dx = magnitude * Math.cos(direction * Math.PI / 180);
				dy = magnitude * Math.sin(direction * Math.PI / 180);
				
				p.x = randRange(130,950);
				p.y = randRange(50,540);
				
				this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			}
			
			animationTimer = new Timer(80);
			animationTimer.addEventListener(TimerEvent.TIMER,advanceAnimation);
			animationTimer.start();
		}
		
		public function getActiveBD():BitmapData
		{
			return animationArray[animationIndex];
		}
		
		private function advanceAnimation(event:TimerEvent):void
		{
			if(animationIndex == 17)
				animationIndex = 0;
			else
				animationIndex++;
		}
		
		private function initializeAnimationArray():void
		{
			animationArray = new Array();
			
			[Embed(source="/data/rotating_ball1.png")]
			var Ball1:Class;	
			animationArray[0] = new BitmapData(20,20,true,0x00000000);
			animationArray[0].draw(new Ball1());
			
			[Embed(source="/data/rotating_ball2.png")]
			var Ball2:Class;
			animationArray[1] = new BitmapData(20,20,true,0x00000000);
			animationArray[1].draw(new Ball2());
			
			[Embed(source="/data/rotating_ball3.png")]
			var Ball3:Class;
			animationArray[2] = new BitmapData(20,20,true,0x00000000);
			animationArray[2].draw(new Ball3());
			
			[Embed(source="/data/rotating_ball4.png")]
			var Ball4:Class;
			animationArray[3] = new BitmapData(20,20,true,0x00000000);
			animationArray[3].draw(new Ball4());
			
			[Embed(source="/data/rotating_ball5.png")]
			var Ball5:Class;
			animationArray[4] = new BitmapData(20,20,true,0x00000000);
			animationArray[4].draw(new Ball5());
			
			[Embed(source="/data/rotating_ball6.png")]
			var Ball6:Class;
			animationArray[5] = new BitmapData(20,20,true,0x00000000);
			animationArray[5].draw(new Ball6());
			
			[Embed(source="/data/rotating_ball7.png")]
			var Ball7:Class;
			animationArray[6] = new BitmapData(20,20,true,0x00000000);
			animationArray[6].draw(new Ball7());
			
			[Embed(source="/data/rotating_ball8.png")]
			var Ball8:Class;
			animationArray[7] = new BitmapData(20,20,true,0x00000000);
			animationArray[7].draw(new Ball8());
			
			[Embed(source="/data/rotating_ball9.png")]
			var Ball9:Class;
			animationArray[8] = new BitmapData(20,20,true,0x00000000);
			animationArray[8].draw(new Ball9());
			
			[Embed(source="/data/rotating_ball10.png")]
			var Ball10:Class;
			animationArray[9] = new BitmapData(20,20,true,0x00000000);
			animationArray[9].draw(new Ball10());
			
			[Embed(source="/data/rotating_ball11.png")]
			var Ball11:Class;
			animationArray[10] = new BitmapData(20,20,true,0x00000000);
			animationArray[10].draw(new Ball11());
			
			[Embed(source="/data/rotating_ball12.png")]
			var Ball12:Class;
			animationArray[11] = new BitmapData(20,20,true,0x00000000);
			animationArray[11].draw(new Ball12());
			
			[Embed(source="/data/rotating_ball13.png")]
			var Ball13:Class;
			animationArray[12] = new BitmapData(20,20,true,0x00000000);
			animationArray[12].draw(new Ball13());
			
			[Embed(source="/data/rotating_ball14.png")]
			var Ball14:Class;
			animationArray[13] = new BitmapData(20,20,true,0x00000000);
			animationArray[13].draw(new Ball14());
			
			[Embed(source="/data/rotating_ball15.png")]
			var Ball15:Class;
			animationArray[14] = new BitmapData(20,20,true,0x00000000);
			animationArray[14].draw(new Ball15());
			
			[Embed(source="/data/rotating_ball16.png")]
			var Ball16:Class;
			animationArray[15] = new BitmapData(20,20,true,0x00000000);
			animationArray[15].draw(new Ball16());
			
			[Embed(source="/data/rotating_ball17.png")]
			var Ball17:Class;
			animationArray[16] = new BitmapData(20,20,true,0x00000000);
			animationArray[16].draw(new Ball17());
			
			[Embed(source="/data/rotating_ball18.png")]
			var Ball18:Class;
			animationArray[17] = new BitmapData(20,20,true,0x00000000);
			animationArray[17].draw(new Ball18());
			
		}
		
		private function randDirection():Number
		{
			var degree:Number = randRange(15,75);
			var multiplier:Number = randRange(0,3);
			return multiplier * 90 + degree;
		}
		
		public function xCenter():Number
		{
			return relativeX() + 10;
		}
		
		public function yCenter():Number
		{
			return relativeY() + 10;
		}
		
		public function relativeX():Number
		{
			return p.x - 100;
		}
		
		public function relativeY():Number
		{
			return p.y - 40;
		}
		
		private function enterFrameHandler ( E:Event ) : void
		{
			if(pause == false)
			{
				p.x += dx;
				p.y += dy;
				
				checkEdges();
				checkBlocks();	
			}
		}
		
		private function checkEdges():void
		{
			if(p.x + 20 >= 980)
			{
				p.x = 959;
				dx *= -1;
			}
			else if(p.x <= 100)
			{
				p.x = 101;
				dx *= -1;
			}	
			else if(p.y + 20 >= 560)
			{
				p.y = 539;
				dy *= -1;
			}
			else if(p.y <= 40)
			{
				p.y = 41;
				dy *= -1;
			}
		}
		
		private function checkBlocks():void
		{		
			var right:Number = grid.checkXCollisions(relativeX() + 19, relativeY());
			var left:Number = grid.checkXCollisions(relativeX(), relativeY());
			var top:Number = grid.checkYCollisions(relativeY(), relativeX());
			var bottom:Number = grid.checkYCollisions(relativeY() + 19, relativeX());
			
			//There must be a better way to do this.
			if(right > bottom)
				bottom = 0;
			if(right > top)
				top = 0;
			if(left > bottom)
				bottom = 0;
			if(left > top)
				top = 0;
			if(bottom > right)
				right = 0;
			if(bottom > left)
				left = 0;
			if(top > right)
				right = 0;
			if(top > left)
				left = 0;
			
			if(right > 0)
			{
				p.x = int(p.x / 20)*20 - 1;
				dx = Math.abs(dx) * -1;
			}
			if(top > 0)
			{
				p.y = int(p.y / 20)*20 + 21;
				dy = Math.abs(dy);
			}
			if(left > 0)
			{
				p.x = int(p.x / 20)*20 + 21;
				dx = Math.abs(dx);
			}
			if(bottom > 0)
			{
				p.y = int(p.y / 20)*20 -1;
				dy = Math.abs(dy) * -1;
			}
		}
		
		
		
		private function randRange(minNum:Number, maxNum:Number):Number
		{
			return (Math.floor(Math.random() * (maxNum - minNum + 1)) + minNum);
		}
	}
}