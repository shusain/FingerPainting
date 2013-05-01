package com.shaunhusain.fingerPainting.tools 
{
	import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.events.TouchEvent;
	import flash.geom.Rectangle;
	
	public class RedoTool extends ToolBase implements ITool
	{
		//--------------------------------------------------------------------------------
		//				Constructor
		//--------------------------------------------------------------------------------
		public function RedoTool(stage:Stage)
		{
			super(stage);
		}
		
		//--------------------------------------------------------------------------------
		//				Handlers
		//--------------------------------------------------------------------------------
		public function takeAction(event:TouchEvent=null):void
		{
			layerM.currentLayerBitmap.fillRect(new Rectangle(0,0,layerM.currentLayerBitmap.width,layerM.currentLayerBitmap.height),0x00FFFFFF);
			undoManager.redo(redoCallback)
		}
		
		//--------------------------------------------------------------------------------
		//				Helper functions
		//--------------------------------------------------------------------------------
		private function redoCallback(bd:BitmapData):void
		{
			layerM.currentLayerBitmap.draw(bd);
			layerM.currentLayer.updateThumbnail();
		}
		public function toString():String
		{
			return "Redo";
		}
	}
}