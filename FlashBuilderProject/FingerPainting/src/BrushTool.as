package 
{
	import flash.display.BitmapData;
	import flash.events.TouchEvent;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	public class BrushTool implements ITool
	{
		private var touchSamples:ByteArray;
		public function BrushTool()
		{
			touchSamples = new ByteArray();
		}
		
		public function takeAction(event:TouchEvent=null, bitmapData:BitmapData=null, currentColor:uint=NaN):void
		{
			var result:uint = event.getSamples(touchSamples,false);
			touchSamples.position = 0;     // rewind to beginning of array before reading
			
			var xCoord:Number, yCoord:Number, pressure:Number;
			
			while( touchSamples.bytesAvailable > 0 )
			{
				xCoord = touchSamples.readFloat();
				yCoord = touchSamples.readFloat();
				pressure = touchSamples.readFloat();
				
				bitmapData.fillRect(new Rectangle(xCoord,yCoord,pressure*20,pressure*20), currentColor);
				//do something with the sample data
			}
		}
	}
}