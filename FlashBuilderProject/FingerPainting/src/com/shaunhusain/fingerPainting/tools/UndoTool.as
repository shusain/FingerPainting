package com.shaunhusain.fingerPainting.tools 
{
	import flash.display.BitmapData;
	import flash.events.TouchEvent;
	import flash.geom.Rectangle;
	
	public class UndoTool extends ToolBase implements ITool
	{
		public function UndoTool()
		{
		}
		public function takeAction(event:TouchEvent=null):void
		{
			model.bitmapData.fillRect(new Rectangle(0,0,model.bitmapData.width,model.bitmapData.height),0x00FFFFFF);
			undoManager.undo(undoCallback);
		}
		private function undoCallback(bd:BitmapData):void
		{
			model.bitmapData.draw(bd);
		}
	}
}