package com.shaunhusain.fingerPainting.tools 
{
	import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.events.TouchEvent;
	import flash.geom.Rectangle;
	
	public class BlankTool extends ToolBase implements ITool
	{
		public function BlankTool(stage:Stage)
		{
			super(stage);
		}
		public function takeAction(event:TouchEvent=null):void
		{
			var bm:BitmapData = layerManager.currentLayerBitmap;
			bm.fillRect(new Rectangle(0,0,bm.width,bm.height),0x00000000);
			layerManager.currentLayer.updateThumbnail();
		}
	}
}