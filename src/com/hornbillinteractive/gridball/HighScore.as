package com.hornbillinteractive.gridball
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.SharedObject;
	import flash.text.engine.*;
	
	import qnx.ui.text.ReturnKeyType;

	public class HighScore extends Sprite
	{
		private var txt:TextGenerator;
		private var bitText:BitmapNumber;
		private var data:SharedObject;
		
		public var easyScoreBD:BitmapData;
		public var normalScoreBD:BitmapData;
		public var hardScoreBD:BitmapData;
		
		public var rect:Rectangle;
		public var p:Point;
		
		public function HighScore(d:SharedObject,returnToMenu:Function)
		{
			rect = new Rectangle(0,0,32*8,36);
			p = new Point(0,0);
			data = d;
			txt= new TextGenerator();
			bitText = new BitmapNumber();
			var textLine1:TextLine = txt.generateTextLine("High Scores",100,0xffffff);
			textLine1.x = 210;
			textLine1.y = 100;
			
			var menuButton:Sprite = initializeMenuButton();
			
			var easyScoreText:TextLine = txt.generateTextLine("Easy High Score",40,0xffffff);
			easyScoreText.x = 350;
			easyScoreText.y = 180;
			
			easyScoreBD = bitText.highScoreBD(data.data.easyHighScore,0);
			var easyScoreBitmap:Bitmap = new Bitmap(easyScoreBD);
			easyScoreBitmap.x = 380;
			easyScoreBitmap.y = 200;
			
			var normalScoreText:TextLine = txt.generateTextLine("Normal High Score",40,0x2b47f1);
			normalScoreText.x = 330;
			normalScoreText.y = 300;
			
			normalScoreBD = bitText.highScoreBD(data.data.normalHighScore,2);
			var normalScoreBitmap:Bitmap = new Bitmap(normalScoreBD);
			normalScoreBitmap.x = 380;
			normalScoreBitmap.y = 320;
			
			var hardScoreText:TextLine = txt.generateTextLine("Hard High Score",40,0xbd0c04);
			hardScoreText.x = 350;
			hardScoreText.y = 420;
			
			hardScoreBD = bitText.highScoreBD(data.data.hardHighScore,1);
			var hardScoreBitmap:Bitmap = new Bitmap(hardScoreBD);
			hardScoreBitmap.x = 380;
			hardScoreBitmap.y = 440;
			
			addChild(textLine1);
			addChild(menuButton);
			addChild(easyScoreText);
			addChild(easyScoreBitmap);
			addChild(normalScoreText);
			addChild(normalScoreBitmap);
			addChild(hardScoreText);
			addChild(hardScoreBitmap);
			
			menuButton.addEventListener(MouseEvent.CLICK,returnToMenu);
			
			this.visible = false;
		}
		
		private function initializeMenuButton():Sprite
		{
			var menuButton:Sprite = new Sprite();
			
			menuButton.graphics.beginFill(0x3333ff,0.7);
			menuButton.graphics.drawRect(0,0,300,50);
			menuButton.x = 50;
			menuButton.y = 500;
			
			var menuTextLine:TextLine = txt.generateTextLine("Main Menu", 40, 0xffffff);
			menuTextLine.x = 55;
			menuTextLine.y = 35;
			
			menuButton.addChild(menuTextLine);
			
			return menuButton;
		}
		
		public function updateHighScores():void
		{
			easyScoreBD.copyPixels(bitText.highScoreBD(data.data.easyHighScore,0),rect,p);
			normalScoreBD.copyPixels(bitText.highScoreBD(data.data.normalHighScore,2),rect,p);
			hardScoreBD.copyPixels(bitText.highScoreBD(data.data.hardHighScore,1),rect,p);
		}
	}
}