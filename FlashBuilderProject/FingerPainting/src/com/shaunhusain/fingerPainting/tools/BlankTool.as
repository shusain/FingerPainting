package com.shaunhusain.fingerPainting.tools 
{
	import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.events.TouchEvent;
	import flash.geom.Rectangle;
	
	/**
	 * Clears the bitmapData of the current layer.
	 */
	public class BlankTool extends ToolBase implements ITool
	{
		//--------------------------------------------------------------------------------
		//				Constructor
		//--------------------------------------------------------------------------------
		public function BlankTool(stage:Stage)
		{
			super(stage);
		}
		
		//--------------------------------------------------------------------------------
		//				Handlers
		//--------------------------------------------------------------------------------
		public function takeAction(event:TouchEvent=null):void
		{
			var bm:BitmapData = layerManager.currentLayerBitmap;
			bm.fillRect(new Rectangle(0,0,bm.width,bm.height),0x00000000);
			layerManager.currentLayer.updateThumbnail();
		}
		
	}
}