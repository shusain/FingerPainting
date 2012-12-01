package com.shaunhusain.fingerPainting.view
{
	import flash.display.Sprite;
	
	public class CircleButton extends Sprite
	{
		public function CircleButton()
		{
			super();
			graphics.clear();
			graphics.beginFill(0xFF0000);
			graphics.drawCircle(90,90,90);
			graphics.endFill();
		}
	}
}