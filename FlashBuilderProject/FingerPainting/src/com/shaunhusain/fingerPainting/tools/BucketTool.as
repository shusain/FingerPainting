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
			if(event && bm)
				bm.floodFill(event.stageX,event.stageY,model.currentColor);
			layerManager.currentLayer.updateThumbnail();
			undoManager.addHistoryElement(bm);
		}
	}
}