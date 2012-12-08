package com.shaunhusain.fingerPainting.tools 
{
	import flash.display.BitmapData;
	import flash.events.TouchEvent;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	public class EraserTool extends ToolBase implements ITool
	{
		private var touchSamples:ByteArray
		public function EraserTool()
		{
			touchSamples = new ByteArray();
		}
		public function takeAction(event:TouchEvent=null):void
		{
			var bm:BitmapData = model.bitmapData;
			var result:uint = event.getSamples(touchSamples,false);
			touchSamples.position = 0;     // rewind to beginning of array before reading
			
			var xCoord:Number, yCoord:Number, pressure:Number;
			
			while( touchSamples.bytesAvailable > 0 )
			{
				xCoord = touchSamples.readFloat();
				yCoord = touchSamples.readFloat();
				pressure = touchSamples.readFloat();
				
				bm.fillRect(new Rectangle(xCoord,yCoord,pressure*25,pressure*25),0xFFFFFFFF);
				//do something with the sample data
			}
		}
	}
}