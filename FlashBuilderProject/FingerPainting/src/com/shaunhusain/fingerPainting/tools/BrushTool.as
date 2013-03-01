package com.shaunhusain.fingerPainting.tools 
{
	import com.shaunhusain.fingerPainting.tools.extras.BrushTip;
	import com.shaunhusain.fingerPainting.view.optionPanels.BrushOptionsPanel;
	
	import flash.display.Stage;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	
	public class BrushTool extends ToolBase implements ITool
	{
		//--------------------------------------------------------------------------------
		//				Variables
		//--------------------------------------------------------------------------------
		protected var secondaryBrushOptions:BrushOptionsPanel;
		
		protected var receivedDown:Boolean;
		
		protected var positionChangeCounter:Number=0;
		protected var lastPointBeforeBDDraw:Point;
		
		private var touchSamples:ByteArray;
		
		private var currentPoint:Point;
		private var previousPoint:Point;
		
		private var leftoverFromPrevious:Number=0;
		protected var brushTip:BrushTip;

		
		//--------------------------------------------------------------------------------
		//				Constructor
		//--------------------------------------------------------------------------------
		public function BrushTool(stage:Stage)
		{
			super(stage);
			touchSamples = new ByteArray();
			
			brushTip = new BrushTip();
			
			secondaryBrushOptions = new BrushOptionsPanel(brushTip);
			secondaryBrushOptions.x = 100;
			secondaryBrushOptions.y = 100;
			
			previousPoint = new Point(NaN,NaN);
			currentPoint = new Point();
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
		public function toString():String
		{
			return "Brush: Touch again to toggle options";
		}
		
		//--------------------------------------------------------------------------------
		//				Handlers
		//--------------------------------------------------------------------------------
		public function takeAction(event:TouchEvent=null):void
		{
			if(event.touchPointID!=0 || event.target!=stage)
				return;
			
			switch(event.type)
			{
				case TouchEvent.TOUCH_BEGIN:
					touchBeginHandler(event);
					break;
				case TouchEvent.TOUCH_MOVE:
					touchMoveHandler(event);
					break;
				case TouchEvent.TOUCH_END:
					leftoverFromPrevious = 0;
					previousPoint.x = previousPoint.y = NaN;
					layerM.currentLayer.updateThumbnail();
					undoManager.addHistoryElement(layerM.currentLayerBitmap);
					break;
			}
		}
		private function touchBeginHandler(event:TouchEvent):void
		{
			receivedDown = true;
			
			/*
			Need to do this only if a move doesn't happen afterwards
			var curScale:Number = layerM.scaleX;
			var adjustedX:Number = event.stageX/curScale - layerM.x/curScale;
			var adjustedY:Number = event.stageY/curScale - layerM.y/curScale;
			if(brushTip.isPressureSensitive)
				brushTip.stampMask(new Point(adjustedX,adjustedY),.7,layerM.currentLayerBitmap);
			else
				brushTip.stampMask(new Point(adjustedX,adjustedY),1,layerM.currentLayerBitmap);*/
		}
		private function touchMoveHandler(event:TouchEvent):void
		{
			if(!receivedDown)
				return;
			
			var result:uint = event.getSamples(touchSamples,false);
			touchSamples.position = 0;     // rewind to beginning of array before reading
			
			var xCoord:Number,yCoord:Number,pressure:Number, curScale:Number;
			while( touchSamples.bytesAvailable > 0 )
			{
				curScale = layerM.scaleX;
				xCoord = touchSamples.readFloat();
				yCoord = touchSamples.readFloat();
				pressure = touchSamples.readFloat();
				currentPoint.x = xCoord/curScale-layerM.x/curScale;
				currentPoint.y = yCoord/curScale-layerM.y/curScale;
				
				if(!isNaN(previousPoint.x))
				{
					leftoverFromPrevious = brushTip.stampMaskLine(previousPoint,currentPoint,leftoverFromPrevious,pressure,layerM.currentLayer.bitmapData);
				}
				
				previousPoint.x = xCoord/curScale-layerM.x/curScale;
				previousPoint.y = yCoord/curScale-layerM.y/curScale;
				
			}
		}
		//--------------------------------------------------------------------------------
		//				Helper functions
		//--------------------------------------------------------------------------------
		protected function getColorToUse():uint{
			return model.currentColor;
		}
		
	}	
}