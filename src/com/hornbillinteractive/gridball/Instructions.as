package com.hornbillinteractive.gridball
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.engine.*;
	
	public class Instructions extends Sprite
	{
		private var txt:TextGenerator;
		
		public function Instructions(returnToMenu:Function)
		{
			txt= new TextGenerator();
			this.graphics.beginFill(0x000000,1);
			this.graphics.drawRect(0,0,1024,600);
			var textLine1:TextLine = txt.generateTextLine("Instructions",100,0xffffff);
			textLine1.x = 180;
			textLine1.y = 100;
			
			var menuButton:Sprite = initializeMenuButton();
			addChild(menuButton);
			
			menuButton.addEventListener(MouseEvent.CLICK,returnToMenu);
			
			addChild(textLine1);
			
			var para1:String = "You're goal is to confine the bouncing atoms to 25% of the size of the initial room. Touch the room to form vertical or horizontal walls which will divide the area into small rooms. If there are no atoms in a room, then the room is removed. When you've removed 75% of the available space, you may move on to the next level.";
			var para2:String = "If an atom collides with a wall while it is being formed, that wall is destroyed and you lose one life.  If you run out of time or loose all your lives, the game is over.";
			var para3:String = "Switch between the vertical wall tool and the horizontal wall tool using the icons to the left of the field. The ratio of empty space is displayed at the bottom and your lives, score, and remaining time are displayed at the top.";
			
			var para1Array:Array = txt.generateParagraph(para1,18,0xffffff);
			
			for(var i:Number = 0; i < para1Array.length; i++)
			{
				para1Array[i].y = 150 + 18 * i;
				para1Array[i].x = 205;
				addChild(para1Array[i]);
			}
			
			var para2Array:Array = txt.generateParagraph(para2,18,0x2b47f1);
			
			for(i = 0; i < para2Array.length; i++)
			{
				para2Array[i].y = 260 + 18 * i;
				para2Array[i].x = 205;
				addChild(para2Array[i]);
			}
			
			var para3Array:Array = txt.generateParagraph(para3,18,0xbd0c04);
			
			for(i = 0; i < para3Array.length; i++)
			{
				para3Array[i].y = 334 + 18 * i;
				para3Array[i].x = 205;
				addChild(para3Array[i]);
			}
			
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
	}
}