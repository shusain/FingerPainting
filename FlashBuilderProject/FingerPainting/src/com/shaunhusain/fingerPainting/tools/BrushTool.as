package com.shaunhusain.fingerPainting.tools 
{
	import com.shaunhusain.fingerPainting.model.PaintModel;
	
	import flash.display.BitmapData;
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.TouchEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	public class BrushTool extends ToolBase implements ITool
	{
		private var touchSamples:ByteArray;
		public function BrushTool()
		{
			touchSamples = new ByteArray();
		}
		
		private function drawDirectlyToBitmapData(curColor:uint,drawingRect:Rectangle):void
		{
			var bm:BitmapData = model.bitmapData;
			if(model.isPressureSensitive)
				drawingRect.width = drawingRect.height = drawingRect.width*model.brushCurrentWidth;
			else
				drawingRect.width = drawingRect.height = model.brushCurrentWidth;
			//trace("xCoord: " +xCoord+ " yCoord: " + yCoord + " Pressure: " + pre);
			
			bm.fillRect(drawingRect, curColor);
		}
		
		private function drawToOverlaySprite(curColor:uint,xCoord:Number,yCoord:Number,pressure:Number):void
		{
			if(xCoord == 0 || yCoord == 0)
				return;
			var sp:Sprite = model.currentDrawingOverlay;
			var drawingWidth:Number;
			if(model.isPressureSensitive)
				drawingWidth = pressure*model.brushCurrentWidth;
			else
				drawingWidth = model.brushCurrentWidth;
			
			//trace("xCoord: " +drawingRect.x+ " yCoord: " + drawingRect.y + " Pressure: " + drawingRect.width);
			
			sp.graphics.lineStyle(drawingWidth,curColor,model.brushOpacity,true,"normal",CapsStyle.ROUND,JointStyle.MITER);
			sp.graphics.lineTo(xCoord,yCoord);
		}
		
		public function takeAction(event:TouchEvent=null):void
		{
			var sp:Sprite = model.currentDrawingOverlay;
			if(event.type == TouchEvent.TOUCH_MOVE)
			{
				var result:uint = event.getSamples(touchSamples,false);
				touchSamples.position = 0;     // rewind to beginning of array before reading
				
				var curColor:uint = model.currentColor;
				curColor = curColor & 0x00FFFFFF;
				curColor = curColor + ((Math.round(model.brushOpacity*255))<<24);
				var xCoord:Number,yCoord:Number,pressure:Number;
				//trace(curColor);
				while( touchSamples.bytesAvailable > 0 )
				{
					xCoord = touchSamples.readFloat()-model.brushCurrentWidth/2;
					yCoord = touchSamples.readFloat()-model.brushCurrentWidth/2;
					pressure = touchSamples.readFloat();
					
					
					//drawDirectlyToBitmapData(xCoord,yCoord,pressure,curColor,drawingRect);
					drawToOverlaySprite(curColor,xCoord,yCoord,pressure);
				}
			}
			else if(event.type == TouchEvent.TOUCH_TAP)
			{
				//bm.fillRect(new Rectangle(xCoord,yCoord,10,10), PaintModel.getInstance().currentColor);
			}
			else if(event.type == TouchEvent.TOUCH_BEGIN)
			{
				trace("brush touch begin");
				sp.graphics.moveTo(event.stageX-model.brushCurrentWidth/2,event.stageY-model.brushCurrentWidth/2);
			}
			else if(event.type == TouchEvent.TOUCH_END)
			{
				trace("brush touch end");
				
				var bm:BitmapData = model.bitmapData;
				
				
				//var colorTransform:ColorTransform = new ColorTransform();
				//colorTransform.color = model.currentColor;
				//colorTransform.alphaMultiplier = model.brushOpacity;
				bm.draw(sp);
				sp.graphics.clear();
				
				undoManager.addHistoryElement(bm);
			}
		}
	}
}