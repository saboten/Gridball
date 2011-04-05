package com.hornbillinteractive.gridball
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.SharedObject;

	public class GameData
	{
		public var BD:BitmapData;
		public var rect:Rectangle;
		public var p:Point;
		public var percentClearBD:BitmapData;
		public var scoreBD:BitmapData;
		public var timeBD:BitmapData;
		public var percentClearRect:Rectangle;
		public var percentClearPoint:Point;
		public var scoreRect:Rectangle;
		public var scorePoint:Point;
		public var timeRect:Rectangle;
		public var timePoint:Point;
		
		public var level:Number;
		public var percentClear:Number;
		public var totalScore:Number;
		public var levelScore:Number;
		public var bitNumbers:BitmapNumber;
		public var lives:Number;
		public var lifeArray:Array;
		public var currentTime:Number;
		public var difficulty:Number;
		
		public function GameData(l:Number=0,t:Number=0)
		{
			BD = new BitmapData(1024,600,true,0x000000);
			rect = new Rectangle(0,0,1024,600);
			p = new Point(0,0);
			
			bitNumbers = new BitmapNumber();
			level = l;
			lives = l + 1;
			percentClear = 0;
			levelScore = 0;
			totalScore = t;
			currentTime = 999;
			
			initializeInterface();
			initializeLives();
		}
		
		private function initializeInterface():void
		{
			[Embed(source="/data/ArrowsNS.png")]
			var ArrowsNSPNG:Class;
			
			[Embed(source="/data/ArrowsEW.png")]
			var ArrowsEWPNG:Class;
			
			percentClearBD = bitNumbers.percentClearedBD(0);
			percentClearRect = new Rectangle(0,0,16*3,18);
			percentClearPoint = new Point(100,562);
			
			scoreBD = bitNumbers.scoreBD(0);
			scoreRect = new Rectangle(0,0,16*8,18);
			scorePoint = new Point(400,20);
			
			timeBD = bitNumbers.timeBD(999);
			timeRect = new Rectangle(0,0,16*3,18);
			timePoint = new Point(900,20);
			
			var nsBD:BitmapData = new BitmapData(60,60,true,0x000000);
			var nsBitmap:Bitmap = new ArrowsNSPNG();
			nsBD.draw(nsBitmap);
			var nsRect:Rectangle = new Rectangle(0,0,60,60);
			var nsP:Point = new Point(20,223);
			
			BD.copyPixels(nsBD,nsRect,nsP);
			
			var ewBD:BitmapData = new BitmapData(60,60,true,0x000000);
			var ewBitmap:Bitmap = new ArrowsEWPNG();
			ewBD.draw(ewBitmap);
			var ewRect:Rectangle = new Rectangle(0,0,60,60);
			var ewP:Point = new Point(20,318);
			
			BD.copyPixels(ewBD,ewRect,ewP);
		}
		
		private function initializeLives():void
		{
			var b:Ball;
			lifeArray = new Array();
			var count:Number;
			if(lives > 7)
				count = 7;
			else
				count = lives;
			
			for(var i:Number = 0; i < count; i++)
			{
				b = new Ball(true);
				b.p.x = 300 - (i * 30);
				b.p.y = 15;
				lifeArray[i] = b;
			}
		}
		
		public function loseLife():void
		{
			lives--;
		}
		
		public function decrementTime():void
		{
			currentTime--;
			timeBD = bitNumbers.timeBD(currentTime);
			BD.copyPixels(timeBD,timeRect,timePoint);
		}
		
		public function updatePercentClear(cleared:Number):void
		{
			percentClear = cleared;
			percentClearBD = bitNumbers.percentClearedBD(cleared);
			BD.copyPixels(percentClearBD,percentClearRect,percentClearPoint);
		}
		
		public function updateScore(emptyTiles:Number):void
		{
			levelScore = emptyTiles * 5;
			scoreBD = bitNumbers.scoreBD(levelScore + totalScore);
			BD.copyPixels(scoreBD,scoreRect,scorePoint);
		}
	}
}