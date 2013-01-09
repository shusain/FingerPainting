package com.shaunhusain.fingerPainting.tools 
{
	import com.shaunhusain.fingerPainting.view.SecondaryBrushOptions;
	
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.TouchEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	public class BrushTool extends ToolBase implements ITool
	{
		//--------------------------------------------------------------------------------
		//				Variables
		//--------------------------------------------------------------------------------
		private var touchSamples:ByteArray;
		
		protected var secondaryBrushOptions:SecondaryBrushOptions;
		
		protected var curColor:uint;
		protected var curAlpha:Number;
		protected var curBrushWidth:Number;
		
		protected var receivedDown:Boolean;
		
		protected var positionChangeCounter:Number=0;
		protected var lastPointBeforeBDDraw:Point;
		
		//--------------------------------------------------------------------------------
		//				Constructor
		//--------------------------------------------------------------------------------
		public function BrushTool(stage:Stage)
		{
			super(stage);
			touchSamples = new ByteArray();
			
			secondaryBrushOptions = new SecondaryBrushOptions();
			secondaryBrushOptions.x = 100;
			secondaryBrushOptions.y = 100;
		}
		
		//--------------------------------------------------------------------------------
		//				Public Methods
		//--------------------------------------------------------------------------------
		public function toggleSecondaryOptions():void
		{
			if(secondaryPanelManager.currentlyShowing == secondaryBrushOptions)
				secondaryPanelManager.hidePanel();
			else
			{
				secondaryPanelManager.showPanel(secondaryBrushOptions);
			}
		}
		
		//--------------------------------------------------------------------------------
		//				Handlers
		//--------------------------------------------------------------------------------
		public function takeAction(event:TouchEvent=null):void
		{
			if(event.touchPointID!=0)
				return;
			undoManager.extendTimer();
			
			switch(event.type)
			{
				case TouchEvent.TOUCH_BEGIN:
					touchBeginHandler(event);
					break;
				case TouchEvent.TOUCH_MOVE:
					touchMoveHandler(event);
					break;
				case TouchEvent.TOUCH_END:
					drawSpriteDataToBitmap(false);
					break;
				case TouchEvent.TOUCH_TAP:
					break;
			}
		}
		private function touchBeginHandler(event:TouchEvent):void
		{
			var sp:Sprite = model.currentDrawingOverlay;
			receivedDown = true;
			//trace("brush touch begin");
			curColor = getColorToUse();
			curAlpha = getAlphaToUse();
			curBrushWidth = getBrushWidth();
			sp.graphics.moveTo(event.stageX,event.stageY);
		}
		private function touchMoveHandler(event:TouchEvent):void
		{
			if(!receivedDown)
				return;
			var result:uint = event.getSamples(touchSamples,false);
			touchSamples.position = 0;     // rewind to beginning of array before reading
			
			var xCoord:Number,yCoord:Number,pressure:Number;
			while( touchSamples.bytesAvailable > 0 )
			{
				xCoord = touchSamples.readFloat();
				yCoord = touchSamples.readFloat();
				pressure = touchSamples.readFloat();
				
				//drawDirectlyToBitmapData(xCoord,yCoord,pressure,curColor,drawingRect);
				drawToOverlaySprite(curColor,xCoord,yCoord,pressure);
			}
		}
		//--------------------------------------------------------------------------------
		//				Helper functions
		//--------------------------------------------------------------------------------
		protected function getColorToUse():uint{
			return model.currentColor;
		}
		
		protected function getAlphaToUse():Number{
			return model.brushOpacity;
		}
		
		protected function getBrushWidth():Number{
			return model.brushCurrentWidth;
		}
		
		private function drawDirectlyToBitmapData(curColor:uint,drawingRect:Rectangle):void
		{
			var bm:BitmapData = layerManager.currentLayerBitmap;
			if(model.isPressureSensitive)
				drawingRect.width = drawingRect.height = drawingRect.width*model.brushCurrentWidth;
			else
				drawingRect.width = drawingRect.height = model.brushCurrentWidth;
			//trace("xCoord: " +xCoord+ " yCoord: " + yCoord + " Pressure: " + pre);
			
			bm.fillRect(drawingRect, curColor);
		}
		
		private function drawToOverlaySprite(curColor:uint,xCoord:Number,yCoord:Number,pressure:Number):void
		{
			var sp:Sprite = model.currentDrawingOverlay;
			//sp.alpha = model.brushOpacity;
			sp.blendMode = BlendMode.INVERT;
			var drawingWidth:Number;
			if(model.isPressureSensitive)
				drawingWidth = pressure*curBrushWidth;
			else
				drawingWidth = curBrushWidth;
			
			//trace("xCoord: " +drawingRect.x+ " yCoord: " + drawingRect.y + " Pressure: " + drawingRect.width);
			//trace(pressure);
			sp.graphics.lineStyle(drawingWidth,curColor,1,true,"normal",CapsStyle.ROUND,JointStyle.MITER);
			sp.graphics.lineTo(xCoord,yCoord);
			
			positionChangeCounter++;
			
			if(positionChangeCounter > 400)
			{
				lastPointBeforeBDDraw = new Point(xCoord,yCoord);
				drawSpriteDataToBitmap();
				positionChangeCounter = 0;
			}
		}
		
		protected function drawSpriteDataToBitmap(receivedDown = true):void
		{
			var sp:Sprite = model.currentDrawingOverlay;
			
			this.receivedDown = receivedDown;
			
			//trace("brush touch end");
			
			var tempBD:BitmapData = new BitmapData(layerManager.currentLayerBitmap.width,layerManager.currentLayerBitmap.height,true,0x00000000);
			tempBD.draw(sp);
			
			var colorTransform:ColorTransform = new ColorTransform();
			colorTransform.color = curColor;
			colorTransform.alphaMultiplier = curAlpha;
			//bm.draw(tempBD,null,colorTransform);
			layerManager.currentLayerBitmap.draw(tempBD,null,colorTransform,null,null,true);
			layerManager.currentLayer.updateThumbnail();
			
			sp.graphics.clear();
			
			if(!receivedDown)
			{
				undoManager.addHistoryElement(layerManager.currentLayerBitmap);
				positionChangeCounter=0;
			}
			else
			{
				sp.graphics.moveTo(lastPointBeforeBDDraw.x,lastPointBeforeBDDraw.y);
			}
		}
	}	
}