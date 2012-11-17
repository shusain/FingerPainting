package
{
	import flash.display.Sprite;
	
	public class AccelerometerButton extends Sprite
	{
		public function AccelerometerButton()
		{
			super();
			
			graphics.beginFill(0xFF0000);
			graphics.drawRect(0,0,100,50);
			graphics.beginFill(0x00FF00);
			graphics.drawRect(0,50,100,50);
			graphics.endFill();
		}
	}
}