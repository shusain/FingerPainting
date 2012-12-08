package com.shaunhusain.fingerPainting.tools 
{
	import flash.display.BitmapData;
	import flash.events.TouchEvent;

	public class BucketTool extends ToolBase implements ITool
	{
		public static var NAME:String = "bucketTool";
		public function BucketTool()
		{
		}
		public function takeAction(event:TouchEvent=null):void
		{
			var bm:BitmapData = model.bitmapData;
			if(event && bm)
				bm.floodFill(event.stageX,event.stageY,model.currentColor);
		}
	}
}