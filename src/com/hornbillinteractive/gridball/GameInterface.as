package com.hornbillinteractive.gridball
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class GameInterface extends Sprite
	{
		public var screenSurface:Sprite;
		public var NSbutton:Sprite;
		public var EWbutton:Sprite;
		public var pauseButton:Sprite;
		private var grid:Grid;
		
		public function GameInterface(g:Grid,pauseGame:Function)
		{
			//TODO shrink this so that it only covers the grid
			screenSurface = new Sprite();
			screenSurface.graphics.beginFill(0x000000,0);
			screenSurface.graphics.drawRect(0,0,880,520);
			screenSurface.x = 100;
			screenSurface.y = 40;
			
			grid = g;
			
			NSbutton = new Sprite();
			NSbutton.graphics.lineStyle(4,0xff0000,0.7,false,"normal","square","miter");
			NSbutton.graphics.beginFill(0xff0000,0.01);
			NSbutton.graphics.drawRect(0,0,80,80);
			NSbutton.x = 10;
			NSbutton.y = 213;
			
			EWbutton = new Sprite();
			EWbutton.graphics.lineStyle(4,0x3333ff,0.7,false,"normal","square","miter");
			EWbutton.graphics.beginFill(0x3333ff,0.01);
			EWbutton.graphics.drawRect(0,0,80,80);
			EWbutton.x = 10;
			EWbutton.y = 308;
			EWbutton.alpha = 0;
			
			pauseButton = new Sprite();
			pauseButton.graphics.beginFill(0x999999,0.05);
			pauseButton.graphics.drawRect(0,0,42,42);
			pauseButton.graphics.endFill();
			pauseButton.graphics.beginFill(0x999999,0.8);
			pauseButton.graphics.drawRect(15,13,5,17);
			pauseButton.graphics.drawRect(22,13,5,17);
			
			pauseButton.x = 30;
			pauseButton.y = 510;
			
			addChild(screenSurface);
			addChild(NSbutton);
			addChild(EWbutton);
			addChild(pauseButton);
			
			NSbutton.addEventListener(MouseEvent.CLICK,clickHandlerNS);
			EWbutton.addEventListener(MouseEvent.CLICK,clickHandlerEW);
			pauseButton.addEventListener(MouseEvent.CLICK,pauseGame);
			screenSurface.addEventListener(MouseEvent.CLICK,grid.startLine);
		}
		
		private function clickHandlerNS(event:MouseEvent):void
		{
			if(grid.direction == "ns")
				return
			else
			{
				grid.direction = "ns";
				NSbutton.alpha = 1;
				EWbutton.alpha = 0;
			}
		}
		
		private function clickHandlerEW(event:MouseEvent):void
		{
			if(grid.direction == "ew")
				return
			else
			{
				grid.direction = "ew";
				NSbutton.alpha = 0;
				EWbutton.alpha = 1;
			}
		}
	}
}