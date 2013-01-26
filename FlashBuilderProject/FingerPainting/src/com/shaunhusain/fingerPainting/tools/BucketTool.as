package com.shaunhusain.fingerPainting.tools 
{
	import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.events.TouchEvent;

	public class BucketTool extends ToolBase implements ITool
	{
		public static var NAME:String = "bucketTool";
		
		//--------------------------------------------------------------------------------
		//				Constructor
		//--------------------------------------------------------------------------------
		public function BucketTool(stage:Stage)
		{
			super(stage);
		}
		
		//--------------------------------------------------------------------------------
		//				Handlers
		//--------------------------------------------------------------------------------
		public function takeAction(event:TouchEvent=null):void
		{
			var bm:BitmapData = layerManager.currentLayerBitmap;
			
			var colorSansAlpha:uint = model.currentColor & 0x00FFFFFF;
			
			if(event && bm && event.type == TouchEvent.TOUCH_END)
				bm.floodFill(event.stageX,event.stageY,model.currentColor);
			layerManager.currentLayer.updateThumbnail();
			undoManager.addHistoryElement(bm);
		}
		public function toString():String
		{
			return "Bucket Fill";
		}
	}
}