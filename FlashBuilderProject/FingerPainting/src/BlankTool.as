package 
{
	import flash.display.BitmapData;
	import flash.events.TouchEvent;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	public class BlankTool implements ITool
	{
		public function BlankTool()
		{
		}
		public function takeAction(event:TouchEvent=null, bitmapData:BitmapData=null, currentColor:uint=NaN):void
		{
			bitmapData.fillRect(new Rectangle(0,0,bitmapData.width,bitmapData.height),0xFFFFFFFF);
		}
	}
}