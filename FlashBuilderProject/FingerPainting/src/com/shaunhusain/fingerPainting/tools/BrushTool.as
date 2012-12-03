package com.shaunhusain.fingerPainting.tools 
{
	import com.shaunhusain.fingerPainting.model.PaintModel;
	
	import flash.display.BitmapData;
	import flash.events.TouchEvent;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	public class BrushTool extends ToolBase implements ITool
	{
		private var touchSamples:ByteArray;
		public function BrushTool()
		{
			touchSamples = new ByteArray();
		}
		
		public function takeAction(event:TouchEvent=null):void
		{
			var bm:BitmapData = model.bitmapData;
			if(event.type == TouchEvent.TOUCH_MOVE)
			{
				var result:uint = event.getSamples(touchSamples,false);
				touchSamples.position = 0;     // rewind to beginning of array before reading
				
				var xCoord:Number, yCoord:Number, pressure:Number;
				var curColor:uint = model.currentColor;
				curColor = curColor & 0x00FFFFFF;
				curColor = curColor + ((Math.round(model.brushOpacity*255))<<24);
				trace(curColor);
				var drawingRect:Rectangle = new Rectangle(xCoord,yCoord,10,10)
				while( touchSamples.bytesAvailable > 0 )
				{
					xCoord = touchSamples.readFloat();
					yCoord = touchSamples.readFloat();
					pressure = touchSamples.readFloat();
					if(model.isPressureSensitive)
						drawingRect.width = drawingRect.height = pressure*model.brushCurrentWidth;
					else
						drawingRect.width = drawingRect.height = model.brushCurrentWidth;
					//trace("xCoord: " +xCoord+ " yCoord: " + yCoord + " Pressure: " + pre);
					
					//bm.cop
					drawingRect.x = xCoord-drawingRect.width/2;
					drawingRect.y = yCoord-drawingRect.height/2;
					bm.fillRect(drawingRect, curColor);
					//do something with the sample data
				}
			}
			else if(event.type == TouchEvent.TOUCH_TAP)
			{
				//bm.fillRect(new Rectangle(xCoord,yCoord,10,10), PaintModel.getInstance().currentColor);
			}
			else if(event.type == TouchEvent.TOUCH_BEGIN)
			{
			}
			else if(event.type == TouchEvent.TOUCH_END)
			{
			}
		}
	}
}