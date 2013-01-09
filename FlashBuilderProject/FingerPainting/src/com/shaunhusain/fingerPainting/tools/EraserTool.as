package com.shaunhusain.fingerPainting.tools 
{
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.ColorTransform;
	import flash.utils.ByteArray;
	
	public class EraserTool extends BrushTool
	{
		//--------------------------------------------------------------------------------
		//				Variables
		//--------------------------------------------------------------------------------
		private var touchSamples:ByteArray
		
		//--------------------------------------------------------------------------------
		//				Constructor
		//--------------------------------------------------------------------------------
		public function EraserTool(stage:Stage)
		{
			super(stage);
			touchSamples = new ByteArray();
		}
		
		//--------------------------------------------------------------------------------
		//				Overrides
		//--------------------------------------------------------------------------------
		override protected function getColorToUse():uint
		{
			return 0xFFFFFFFF;
		}
		override protected function getAlphaToUse():Number
		{
			return 1;
		}
		override protected function getBrushWidth():Number{
			return 60;
		}
		
		override protected function drawSpriteDataToBitmap(receivedDown = true):void
		{
			var sp:Sprite = model.currentDrawingOverlay;
			
			this.receivedDown = receivedDown;
			
			//trace("brush touch end");
			
			var colorTransform:ColorTransform = new ColorTransform();
			colorTransform.color = curColor;
			colorTransform.alphaMultiplier = curAlpha;
			//bm.draw(tempBD,null,colorTransform);
			layerManager.currentLayerBitmap.draw(sp,null,null,BlendMode.ERASE);
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