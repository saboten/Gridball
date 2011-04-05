package com.hornbillinteractive.gridball
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.engine.*;
	
	public class Level extends Sprite
	{
		public function Level(nextLevel:Function)
		{
			var txt:TextGenerator = new TextGenerator();
			this.graphics.beginFill(0x000000,0.5);
			this.graphics.drawRect(0,0,1024,600);
			
			var textLine1:TextLine = txt.generateTextLine("Level Complete!",100,0xffffff);
			textLine1.x = 120;
			textLine1.y = 200;
			
			var continueButton:Sprite = new Sprite();
			
			continueButton.graphics.beginFill(0xff0000,0.7);
			continueButton.graphics.drawRect(0,0,300,50);
			continueButton.x = 350;
			continueButton.y = 225;
			
			var continueTextLine:TextLine = txt.generateTextLine("Next",40,0xffffff);
			continueTextLine.x = 113;
			continueTextLine.y = 35;
			
			continueButton.addChild(continueTextLine);
			
			addChild(textLine1);
			addChild(continueButton);
			
			continueButton.addEventListener(MouseEvent.CLICK, nextLevel);
			
			this.visible = false;
		}
	}
}