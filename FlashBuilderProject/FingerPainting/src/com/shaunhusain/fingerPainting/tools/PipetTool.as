package com.shaunhusain.fingerPainting.tools 
{
	import flash.display.BitmapData;
	import flash.events.TouchEvent;

	public class PipetTool extends ToolBase implements ITool
	{
		public function PipetTool()
		{
		}
		public function takeAction(event:TouchEvent=null):void
		{
			model.currentColor = model.bitmapData.getPixel32(event.stageX,event.stageY);
		}
	}
}