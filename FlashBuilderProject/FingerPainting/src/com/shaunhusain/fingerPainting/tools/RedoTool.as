package com.shaunhusain.fingerPainting.tools 
{
	import flash.display.BitmapData;
	import flash.events.TouchEvent;
	import flash.geom.Rectangle;
	
	public class RedoTool extends ToolBase implements ITool
	{
		public function RedoTool()
		{
		}
		public function takeAction(event:TouchEvent=null):void
		{
			model.bitmapData.fillRect(new Rectangle(0,0,model.bitmapData.width,model.bitmapData.height),0x00FFFFFF);
			undoManager.redo(redoCallback)
		}
		private function redoCallback(bd:BitmapData):void
		{
			model.bitmapData.draw(bd);
		}
	}
}