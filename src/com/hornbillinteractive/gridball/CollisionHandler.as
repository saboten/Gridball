package com.hornbillinteractive.gridball
{
	import com.hornbillinteractive.gridball.Ball
		
	public class CollisionHandler
	{
		public function CollisionHandler()
		{
		}
		
		public function collideBalls(b1:Ball, b2:Ball, distX:Number, distY:Number, distance:Number):void
		{
			var angle:Number = Math.atan2(distY,distX);
			angle = angle * 180 / Math.PI;
			
			if(0 < angle < 60)
			{
				b1.dx = Math.abs(b1.dx);
				b1.dy = Math.abs(b1.dy);
				b2.dx = Math.abs(b2.dx) * -1;
				b2.dy = Math.abs(b2.dy) * -1;
			}
			else if(61 < angle < 120)
			{
				b1.dx = Math.abs(b1.dx) * -1;
				b2.dx = Math.abs(b2.dx) * -1;
			}
			else if(121 < angle)
			{
				b1.dx = Math.abs(b1.dx);
				b1.dy = Math.abs(b1.dy) * -1;
				b2.dx = Math.abs(b2.dx) * -1;
				b2.dy = Math.abs(b2.dy);
			}
			else if(-60 < angle < -1)
			{
				b1.dx = Math.abs(b1.dx) * -1;
				b1.dy = Math.abs(b1.dy);
				b2.dx = Math.abs(b2.dx);
				b2.dy = Math.abs(b2.dy) * -1;
			}
			else if(-120 < angle < -61)
			{
				b1.dy = Math.abs(b1.dy) * -1;
				b2.dy = Math.abs(b2.dy) * -1;
			}
			else if( angle < -121)
			{
				b1.dx = Math.abs(b1.dx) * -1;
				b1.dy = Math.abs(b1.dy) * -1;
				b2.dx = Math.abs(b2.dx);
				b2.dy = Math.abs(b2.dy);
			}	
		}
	}
}