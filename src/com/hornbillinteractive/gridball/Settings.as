package com.hornbillinteractive.gridball
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.SharedObject;
	import flash.text.engine.*;
	
	public class Settings extends Sprite
	{
		private var data:SharedObject;
		private var txt:TextGenerator;
		private var easyBall:Ball;
		private var normalBall:Ball;
		private var hardBall:Ball;
		private var easyBallBD:BitmapData;
		private var normalBallBD:BitmapData;
		private var hardBallBD:BitmapData;
		private var easyBallBitmap:Bitmap
		private var normalBallBitmap:Bitmap
		private var hardBallBitmap:Bitmap
		private var ballPoint:Point;
		
		public var clear:Sprite;
		public var confirm:Sprite;
		
		public function Settings(d:SharedObject,returnToMenu:Function)
		{
			txt= new TextGenerator();
			//this.graphics.beginFill(0x000000,0.5);
			//this.graphics.drawRect(0,0,1024,600);
			
			data = d;
			
			var textLine1:TextLine = txt.generateTextLine("Settings",100,0xffffff);
			textLine1.x = 300;
			textLine1.y = 100;
			
			var menuButton:Sprite = initializeMenuButton();
			var difficulty:Sprite = initializeDifficulty();
			clear = initializeClearData();
			confirm = initializeConfirmClearData();
			
			addChild(textLine1);
			addChild(menuButton);
			addChild(difficulty);
			addChild(clear);
			addChild(confirm);
			
			menuButton.addEventListener(MouseEvent.CLICK,returnToMenu);
			
			this.visible = false;
			
			this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
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
		
		private function initializeDifficulty():Sprite
		{
			if(data.data.difficulty != 1 && data.data.difficulty != 2 && data.data.difficulty != 3)
				data.data.difficulty = 2;
			
			var difficultyLine:Sprite = new Sprite();
			difficultyLine.x = 130;
			difficultyLine.y = 150;
			
			var difficultyTextLine:TextLine = txt.generateTextLine("Difficulty:", 40, 0xffffff);
			difficultyTextLine.x = 0;
			difficultyTextLine.y = 35;
			
			var easyTextLine:TextLine = txt.generateTextLine("Easy", 40, 0xffffff);
			easyTextLine.x = 310;
			easyTextLine.y = 35;
			
			var normalTextLine:TextLine = txt.generateTextLine("Normal", 40, 0x2b47f1);
			normalTextLine.x = 470;
			normalTextLine.y = 35;
			
			var hardTextLine:TextLine = txt.generateTextLine("Hard", 40, 0xbd0c04);
			hardTextLine.x = 670;
			hardTextLine.y = 35;
			
			var easyButton:Sprite = new Sprite();
			easyButton.graphics.beginFill(0x000000,0);
			easyButton.graphics.drawRect(0,0,160,50);
			easyButton.x = 270;
			easyButton.y = 0;
			
			var normalButton:Sprite = new Sprite();
			normalButton.graphics.beginFill(0x000000,0);
			normalButton.graphics.drawRect(0,0,205,50);
			normalButton.x = 430;
			normalButton.y = 0;
			
			var hardButton:Sprite = new Sprite();
			hardButton.graphics.beginFill(0x000000,0);
			hardButton.graphics.drawRect(0,0,160,50);
			hardButton.x = 635;
			hardButton.y = 0;
			
			easyBall = new Ball(true);
			easyBall.animationTimer.delay = 110;
			normalBall = new Ball(true);
			hardBall = new Ball(true);
			hardBall.animationTimer.delay = 50;
			
			easyBallBD = new BitmapData(20,20,true,0x000000);
			normalBallBD = new BitmapData(20,20,true,0x000000);
			hardBallBD = new BitmapData(20,20,true,0x000000);
			
			ballPoint = new Point(0,0);
			
			easyBallBitmap = new Bitmap(easyBallBD);
			easyBallBitmap.x = 280;
			easyBallBitmap.y = 12;
			easyBallBitmap.visible = (data.data.difficulty == 1);
			normalBallBitmap = new Bitmap(normalBallBD);
			normalBallBitmap.x = 440;
			normalBallBitmap.y = 12;
			normalBallBitmap.visible = (data.data.difficulty == 2);
			hardBallBitmap = new Bitmap(hardBallBD);
			hardBallBitmap.x = 640;
			hardBallBitmap.y = 12;
			hardBallBitmap.visible = (data.data.difficulty == 3);
			
			difficultyLine.addChild(difficultyTextLine);
			difficultyLine.addChild(easyTextLine);
			difficultyLine.addChild(normalTextLine);
			difficultyLine.addChild(hardTextLine);
			difficultyLine.addChild(easyButton);
			difficultyLine.addChild(normalButton);
			difficultyLine.addChild(hardButton);
			difficultyLine.addChild(easyBallBitmap);
			difficultyLine.addChild(normalBallBitmap);
			difficultyLine.addChild(hardBallBitmap);
			
			easyButton.addEventListener(MouseEvent.CLICK, setEasyDifficulty);
			normalButton.addEventListener(MouseEvent.CLICK, setNormalDifficulty);
			hardButton.addEventListener(MouseEvent.CLICK, setHardDifficulty);
			
			return difficultyLine
		}
		
		private function initializeClearData():Sprite
		{
			var clearLine:Sprite = new Sprite();
			clearLine.x = 130;
			clearLine.y = 250;
			
			var clearTextLine:TextLine = txt.generateTextLine("Erase Highscores:", 40, 0xffffff);
			clearTextLine.x = 0;
			clearTextLine.y = 35;
			
			var eraseTextLine:TextLine = txt.generateTextLine("Erase", 40, 0xffffff);
			eraseTextLine.x = 27;
			eraseTextLine.y = 35;
			
			var eraseButton:Sprite = new Sprite();
			eraseButton.graphics.beginFill(0xbd0c04,0.7);
			eraseButton.graphics.drawRect(0,0,160,50);
			eraseButton.x = 450;
			eraseButton.y = 0;
			
			eraseButton.addChild(eraseTextLine);
			
			clearLine.addChild(clearTextLine);
			clearLine.addChild(eraseButton);
			
			eraseButton.addEventListener(MouseEvent.CLICK, confirmDeleteData);
			
			return clearLine;
		}
		
		private function initializeConfirmClearData():Sprite
		{
			var clearLine:Sprite = new Sprite();
			clearLine.x = 130;
			clearLine.y = 250;
			
			var clearTextLine:TextLine = txt.generateTextLine("Are you sure?", 40, 0xffffff);
			clearTextLine.x = 0;
			clearTextLine.y = 35;
			
			var yesTextLine:TextLine = txt.generateTextLine("Yes", 40, 0xffffff);
			yesTextLine.x = 50;
			yesTextLine.y = 35;
			
			var yesButton:Sprite = new Sprite();
			yesButton.graphics.beginFill(0x3333ff,0.7);
			yesButton.graphics.drawRect(0,0,160,50);
			yesButton.x = 350;
			yesButton.y = 0;
			
			var noTextLine:TextLine = txt.generateTextLine("No", 40, 0xffffff);
			noTextLine.x = 60;
			noTextLine.y = 35;
			
			var noButton:Sprite = new Sprite();
			noButton.graphics.beginFill(0xbd0c04,0.7);
			noButton.graphics.drawRect(0,0,160,50);
			noButton.x = 550;
			noButton.y = 0;
			
			yesButton.addChild(yesTextLine);
			noButton.addChild(noTextLine);
			
			clearLine.addChild(clearTextLine);
			clearLine.addChild(yesButton);
			clearLine.addChild(noButton);
			
			yesButton.addEventListener(MouseEvent.CLICK,deleteData);
			noButton.addEventListener(MouseEvent.CLICK,resetDeleteData);
			
			clearLine.visible = false;
			
			return clearLine
		}
		
		private function confirmDeleteData(event:MouseEvent):void
		{
			clear.visible = false;
			confirm.visible = true;
		}
		
		private function resetDeleteData(event:MouseEvent):void
		{
			clear.visible = true;
			confirm.visible = false;
		}
		
		private function deleteData(event:MouseEvent):void
		{
			clear.visible = true;
			confirm.visible = false;
			data.data.easyHighScore = 0;
			data.data.normalHighScore = 0;
			data.data.hardHighScore = 0;
			data.flush();
		}
		
		private function setEasyDifficulty(event:MouseEvent):void
		{
			data.data.difficulty = 1;
			
			easyBallBitmap.visible = true;
			normalBallBitmap.visible = false;
			hardBallBitmap.visible = false;
		}
		
		private function setNormalDifficulty(event:MouseEvent):void
		{
			data.data.difficulty = 2;
			
			easyBallBitmap.visible = false;
			normalBallBitmap.visible = true;
			hardBallBitmap.visible = false;
		}
		
		private function setHardDifficulty(event:MouseEvent):void
		{
			data.data.difficulty = 3;
			
			easyBallBitmap.visible = false;
			normalBallBitmap.visible = false;
			hardBallBitmap.visible = true;
		}
		
		private function enterFrameHandler(event:Event):void
		{
			easyBallBD.copyPixels(easyBall.getActiveBD(),easyBall.rect,ballPoint);
			normalBallBD.copyPixels(normalBall.getActiveBD(),normalBall.rect,ballPoint);
			hardBallBD.copyPixels(hardBall.getActiveBD(),hardBall.rect,ballPoint);
		}
	}
}