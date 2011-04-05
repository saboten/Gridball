package com.hornbillinteractive.gridball
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.*;

	public class Tile extends Sprite
	{
		public var xCoord:Number;
		public var yCoord:Number;
		public var BD:BitmapData;
		public var whiteRectangle:Shape;
		public var redRectangle:Shape;
		public var blueRectangle:Shape;
		public var rect:Rectangle;
		public var p:Point;
		public var state:String;
		
		public function Tile(xIndex:Number, yIndex:Number)
		{
			initializeRectangles();
			
			BD = new BitmapData(20,20,true,0x00000000);
			BD.draw(whiteRectangle);
			rect = new Rectangle(0,0,20,20);
			p = new Point(xIndex * 20,yIndex * 20);
			state = "empty";
		}
		
		private function initializeRectangles():void
		{
			whiteRectangle = new Shape();
			redRectangle = new Shape();
			blueRectangle = new Shape();
			whiteRectangle.graphics.beginFill(0x000000,0.6);
			whiteRectangle.graphics.drawRect(0,0,20,20);
			whiteRectangle.graphics.endFill();
			redRectangle.graphics.beginFill(0x000000,0.6);
			redRectangle.graphics.drawRect(0,0,20,20);
			redRectangle.graphics.endFill();
			blueRectangle.graphics.beginFill(0x000000,0.6);
			blueRectangle.graphics.drawRect(0,0,20,20);
			blueRectangle.graphics.endFill();
			whiteRectangle.graphics.lineStyle(2,0x999999,0.8,false,"normal","square","miter");
			redRectangle.graphics.lineStyle(2,0xff0000,0.7,false,"normal","square","miter");
			blueRectangle.graphics.lineStyle(2,0x3333ff,0.7,false,"normal","square","miter");
			whiteRectangle.graphics.beginFill(0x333333,0.8);
			redRectangle.graphics.beginFill(0xff0000,0.3);
			blueRectangle.graphics.beginFill(0x3333ff,0.3);
			whiteRectangle.graphics.drawRect(2,2,16,16);
			redRectangle.graphics.drawRect(2,2,16,16);
			blueRectangle.graphics.drawRect(2,2,16,16);
			whiteRectangle.graphics.endFill();
			redRectangle.graphics.endFill();
			blueRectangle.graphics.endFill();
		}
		public function setState(newState:String):void
		{
			state = newState;
			
			switch(newState)
			{
				case "empty":
					BD = new BitmapData(20,20,true,0x00000000);
					BD.draw(whiteRectangle);
					break;
				case "north":
					BD = new BitmapData(20,20,true,0x00000000);
					BD.draw(redRectangle);
					break;
				case "south":
					BD = new BitmapData(20,20,true,0x00000000);
					BD.draw(blueRectangle);
					break;
				case "west":
					BD = new BitmapData(20,20,true,0x00000000);
					BD.draw(redRectangle);
					break;
				case "east":
					BD = new BitmapData(20,20,true,0x00000000);
					BD.draw(blueRectangle);
					break;
			}
		}
	}
}