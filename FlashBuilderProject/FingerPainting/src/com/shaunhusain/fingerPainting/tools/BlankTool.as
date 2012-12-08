package com.shaunhusain.fingerPainting.tools 
{
	import flash.display.BitmapData;
	import flash.events.TouchEvent;
	import flash.geom.Rectangle;
	
	public class BlankTool extends ToolBase implements ITool
	{
		public function BlankTool()
		{
		}
		public function takeAction(event:TouchEvent=null):void
		{
			var bm:BitmapData = model.bitmapData;
			bm.fillRect(new Rectangle(0,0,bm.width,bm.height),0xFFFFFFFF);
		}
	}
}