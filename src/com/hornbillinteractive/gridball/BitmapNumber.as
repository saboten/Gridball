package com.hornbillinteractive.gridball
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class BitmapNumber
	{
		public var BD:BitmapData;
		public var largeBD:BitmapData;
		public var percentBD:BitmapData;
		public var rect:Rectangle;
		public var largeRect:Rectangle;
		public var percentRect:Rectangle;
		public var percentPoint:Point;
		
		public function BitmapNumber()
		{
			[Embed(source="/data/Numbers.png")]
			var NumbersImage:Class;
			
			[Embed(source="/data/Numbers_Large.png")]
			var LargeNumbersImage:Class;	
			
			[Embed(source="/data/Percent.png")]
			var PercentImage:Class;
			
			BD= new BitmapData(160,54,true,0x000000);
			BD.draw(new NumbersImage());
			largeBD = new BitmapData(320,108,true,0x000000);
			largeBD.draw(new LargeNumbersImage());
			rect = new Rectangle(0,0,16,18);
			largeRect = new Rectangle(0,0,32,36);
			
			percentBD = new BitmapData(16,18,true,0x000000);
			percentBD.draw(new PercentImage());
			percentRect = new Rectangle(0,0,16,18);
			percentPoint = new Point(16*2,0);
		}
		
		public function percentClearedBD(cleared:Number):BitmapData
		{
			var length:Number = ("" + cleared).length;
			var lineBD:BitmapData = new BitmapData(16*3,18,true,0x000000);
			lineBD.copyPixels(percentBD,percentRect,percentPoint);
			rect.y = 18;
			
			var digit:Number;
			var p:Point;
			for(var i:Number=1;i<=length;i++)
			{
				digit = int(cleared%Math.pow(10,i)/Math.pow(10,i-1));
				rect.x = digit * 16;	
				p = new Point((16*3)-(i+1)*16,0);
				lineBD.copyPixels(BD,rect,p);
			}
			
			return lineBD
		}
		
		public function scoreBD(score:Number):BitmapData
		{
			var length:Number = ("" + score).length;
			var lineBD:BitmapData = new BitmapData(16*8,18,true,0x000000);
			rect.y = 36;
			
			var digit:Number;
			var p:Point;
			for(var i:Number=1;i<=length;i++)
			{
				digit = int(score%Math.pow(10,i)/Math.pow(10,i-1));
				rect.x = digit * 16;	
				p = new Point((16*8)-i*16,0);
				lineBD.copyPixels(BD,rect,p);
			}
			
			return lineBD
		}
		
		public function timeBD(time:Number):BitmapData
		{
			var length:Number = ("" + time).length;
			var lineBD:BitmapData = new BitmapData(16*3,18,true,0x000000);
			rect.y = 0;
			
			var digit:Number;
			var p:Point;
			for(var i:Number=1;i<=length;i++)
			{
				digit = int(time%Math.pow(10,i)/Math.pow(10,i-1));
				rect.x = digit * 16;	
				p = new Point((16*3)-i*16,0);
				lineBD.copyPixels(BD,rect,p);
			}
			
			return lineBD
		}
		
		public function highScoreBD(score:Number,colorIndex:Number):BitmapData
		{
			var length:Number = ("" + score).length;
			var lineBD:BitmapData = new BitmapData(32*8,36,true,0x000000);
			largeRect.y = 36 * colorIndex;
			
			var digit:Number;
			var p:Point;
			for(var i:Number=1;i<=length;i++)
			{
				digit = int(score%Math.pow(10,i)/Math.pow(10,i-1));
				largeRect.x = digit * 32;	
				p = new Point((32*8)-i*32,0);
				lineBD.copyPixels(largeBD,largeRect,p);
			}
			
			return lineBD
		}
	}
}