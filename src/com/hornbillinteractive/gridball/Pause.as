package com.hornbillinteractive.gridball
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.engine.*;

	public class Pause extends Sprite
	{
		public function Pause(unPause:Function,endGame:Function)
		{
			var txt:TextGenerator = new TextGenerator();
			this.graphics.beginFill(0x000000,0.5);
			this.graphics.drawRect(0,0,1024,600);
			
			var textLine1:TextLine = txt.generateTextLine("Pause",100,0xffffff);
			textLine1.x = 370;
			textLine1.y = 200;
			
			var continueButton:Sprite = new Sprite();
			var menuButton:Sprite = new Sprite();
			
			continueButton.graphics.beginFill(0xff0000,0.7);
			continueButton.graphics.drawRect(0,0,300,50);
			continueButton.x = 350;
			continueButton.y = 225;
			
			menuButton.graphics.beginFill(0x3333ff,0.7);
			menuButton.graphics.drawRect(0,0,300,50);
			menuButton.x = 350;
			menuButton.y = 300;
			
			var continueTextLine:TextLine = txt.generateTextLine("Continue",40,0xffffff);
			continueTextLine.x = 65;
			continueTextLine.y = 35;
			var menuTextLine:TextLine = txt.generateTextLine("Main Menu", 40, 0xffffff);
			menuTextLine.x = 55;
			menuTextLine.y = 35;
			
			continueButton.addChild(continueTextLine);
			menuButton.addChild(menuTextLine);
			
			addChild(textLine1);
			addChild(continueButton);
			addChild(menuButton);
			
			continueButton.addEventListener(MouseEvent.CLICK, unPause);
			menuButton.addEventListener(MouseEvent.CLICK,endGame);
			
			this.visible = false;
		}
	}
}