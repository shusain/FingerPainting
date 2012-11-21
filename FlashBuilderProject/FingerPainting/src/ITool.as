package 
{
	import flash.display.BitmapData;
	import flash.events.TouchEvent;

	public interface ITool
	{
		function takeAction(event:TouchEvent=null, bitmapData:BitmapData=null, currentColor:uint=NaN):void;
	}
}