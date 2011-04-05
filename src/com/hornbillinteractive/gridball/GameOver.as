package com.hornbillinteractive.gridball
{
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.engine.*;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class GameOver extends Sprite
	{
		public var highScore:Sprite;
		public var scoreBD:BitmapData;
		public var txt:TextGenerator; 
		public var bitText:BitmapNumber;
		
		public var rect:Rectangle;
		public var p:Point;
		
		public function GameOver(endGame:Function)
		{
			rect = new Rectangle(0,0,32*8,36);
			p = new Point(0,0);
			txt = new TextGenerator();
			bitText = new BitmapNumber();
			this.graphics.beginFill(0x000000,0.5);
			this.graphics.drawRect(0,0,1024,600);
			var menuButton:Sprite = new Sprite();
			highScore = initializeHighScore();
			
			var textLine1:TextLine = txt.generateTextLine("Game Over",100,0xffffff);
			textLine1.x = 270;
			textLine1.y = 280;
			
			menuButton.graphics.beginFill(0x3333ff,0.7);
			menuButton.graphics.drawRect(0,0,300,50);
			menuButton.x = 350;
			menuButton.y = 300;
			
			var menuTextLine:TextLine = txt.generateTextLine("Main Menu", 40, 0xffffff);
			menuTextLine.x = 55;
			menuTextLine.y = 35;
			
			menuButton.addChild(menuTextLine);
			
			var scoreTextLine:TextLine = txt.generateTextLine("New High Score!", 40, 0xffffff);
			scoreTextLine.x = 200;
			scoreTextLine.y = 400;
			
			addChild(textLine1);
			addChild(menuButton);
			addChild(highScore);
			
			menuButton.addEventListener(MouseEvent.CLICK,endGame);
			
			this.visible = false;
		}
		
		public function initializeHighScore():Sprite
		{
			var score:Sprite = new Sprite();
			score.x = 340;
			score.y = 380;
			
			var scoreTextLine:TextLine = txt.generateTextLine("New High Score!", 40, 0xffffff);
			scoreTextLine.x = 0;
			scoreTextLine.y = 35;
			
			scoreBD = bitText.highScoreBD(0,0);
			var scoreBitmap:Bitmap = new Bitmap(scoreBD);
			scoreBitmap.x = 30;
			scoreBitmap.y = 45;
			
			score.addChild(scoreTextLine);
			score.addChild(scoreBitmap);
			
			return score
		}
		
		public function updateHighScore(score:Number):void
		{
			scoreBD.copyPixels(bitText.highScoreBD(score,0),rect,p);
		}
	}
}