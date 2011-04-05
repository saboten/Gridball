package com.hornbillinteractive.gridball
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.engine.*;

	public class Menu extends Sprite
	{
		public var BD:BitmapData;
		public var rect:Rectangle;
		public var p:Point;
		public var txt:TextGenerator;
		
		public var logo:BitmapData;
		public var logoRect:Rectangle;
		public var logoPoint:Point;
		public var logoDot:Ball;
		public var startButton:Sprite;
		public var settingsButton:Sprite;
		public var howToButton:Sprite;
		public var highScoreButton:Sprite;
		
		public function Menu(beginGame:Function,viewSettings:Function,viewInstructions:Function,viewHighScores:Function)
		{
			BD = new BitmapData(1024,600,true,0x000000);
			rect = new Rectangle(0,0,1024,600);
			p = new Point(0,0);
			txt = new TextGenerator();
			
			[Embed(source="/data/Gridball_Title_Color.png")]
			var Logo:Class;
			
			logo = new BitmapData(689,100,true,0x000000);
			var logoBitmap:Bitmap = new Logo();
			logo.draw(logoBitmap);
			logoRect = new Rectangle(0,0,689,100);
			logoPoint = new Point(167,200);
			
			BD.copyPixels(logo,logoRect, logoPoint);
			
			logoDot = new Ball(true);
			logoDot.p.x = 369;
			logoDot.p.y = 200;
			
			startButton = new Sprite();
			startButton.graphics.beginFill(0x000000,0);
			startButton.graphics.drawRect(0,0,300,50);
			var startButtonText:TextLine = txt.generateTextLine("Start",40,0xffffff);
			startButtonText.x = 105;
			startButtonText.y = 35;
			startButton.addChild(startButtonText);
			startButton.x = 350;
			startButton.y = 350;
			
			settingsButton = new Sprite();
			settingsButton.graphics.beginFill(0x000000,0);
			settingsButton.graphics.drawRect(0,0,300,50);
			var settingsButtonText:TextLine = txt.generateTextLine("Settings",40,0xffffff);
			settingsButtonText.x = 70;
			settingsButtonText.y = 35;
			settingsButton.addChild(settingsButtonText);
			settingsButton.x = 350;
			settingsButton.y = 400;
			
			howToButton = new Sprite();
			howToButton.graphics.beginFill(0x000000,0);
			howToButton.graphics.drawRect(0,0,300,50);
			var howToButtonText:TextLine = txt.generateTextLine("Instructions",40,0xffffff);
			howToButtonText.x = 26;
			howToButtonText.y = 35;
			howToButton.addChild(howToButtonText);
			howToButton.x = 350;
			howToButton.y = 450;
			
			highScoreButton = new Sprite();
			highScoreButton.graphics.beginFill(0x000000,0);
			highScoreButton.graphics.drawRect(0,0,300,50);
			var highScoreButtonText:TextLine = txt.generateTextLine("High Scores",40,0xffffff);
			highScoreButtonText.x = 36;
			highScoreButtonText.y = 35;
			highScoreButton.addChild(highScoreButtonText);
			highScoreButton.x = 350;
			highScoreButton.y = 500;
			
			addChild(startButton);
			addChild(settingsButton);
			addChild(howToButton);
			addChild(highScoreButton);
			startButton.addEventListener(MouseEvent.CLICK,beginGame);
			settingsButton.addEventListener(MouseEvent.CLICK,viewSettings);
			howToButton.addEventListener(MouseEvent.CLICK,viewInstructions);
			highScoreButton.addEventListener(MouseEvent.CLICK,viewHighScores);
		}
	}
}