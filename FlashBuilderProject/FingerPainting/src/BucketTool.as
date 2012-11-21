package 
{
	import flash.display.BitmapData;
	import flash.events.TouchEvent;

	public class BucketTool implements ITool
	{
		public static var NAME:String = "bucketTool";
		public function BucketTool()
		{
		}
		public function takeAction(event:TouchEvent=null, bitmapData:BitmapData=null, currentColor:uint=NaN):void
		{
			if(event && bitmapData)
				bitmapData.floodFill(event.stageX,event.stageY,0xff000000);
		}
	}
}