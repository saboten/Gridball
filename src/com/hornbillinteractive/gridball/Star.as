package com.hornbillinteractive.gridball
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	public class Star
	{
		public var BD:BitmapData;
		public var rect:Rectangle;
		public var p:Point;
		public var velocity:Number;
		public var timer:Timer;
		
		public function Star()
		{
			BD = new BitmapData(6,6,false,0xffffff);
			rect = new Rectangle(0,0,6,6);
//			var topBottom:Number = randRange(1,1624);
//			
//			if(topBottom < 1024)
//				p = new Point(randRange(100,1024), -50);
//			else
//				p = new Point(1100,randRange(0,500))
			
			p = new Point(randRange(100,1024),randRange(0,500));
					
			velocity = 6;
			
			timer = new Timer(20);
			timer.addEventListener(TimerEvent.TIMER,moveStar);
			timer.start();
		}
		
		private function moveStar(event:TimerEvent):void
		{
			p.x -= velocity;
			p.y += velocity;
			
			if(p.x < 0 || p.y > 600)
			{
				var topBottom:Number = randRange(1,1624);
				
				if(topBottom < 1024)
				{
					p.x = randRange(100,1024);
					p.y = -50;
				}
				else
				{
					p.x = 1100;
					p.y = randRange(0,500);
				}
			}
		}
		
		private function randRange(minNum:Number, maxNum:Number):Number
		{
			return (Math.floor(Math.random() * (maxNum - minNum + 1)) + minNum);
		}
	}
}