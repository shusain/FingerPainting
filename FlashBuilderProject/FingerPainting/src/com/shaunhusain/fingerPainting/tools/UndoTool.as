package com.shaunhusain.fingerPainting.tools 
{
	import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.events.TouchEvent;
	import flash.geom.Rectangle;
	
	public class UndoTool extends ToolBase implements ITool
	{
		//--------------------------------------------------------------------------------
		//				Constructor
		//--------------------------------------------------------------------------------
		public function UndoTool(stage:Stage )
		{
			super(stage);
		}
		//--------------------------------------------------------------------------------
		//				Handlers
		//--------------------------------------------------------------------------------
		public function takeAction(event:TouchEvent=null):void
		{
			layerManager.currentLayerBitmap.fillRect(new Rectangle(0,0,layerManager.currentLayerBitmap.width,layerManager.currentLayerBitmap.height),0x00FFFFFF);
			undoManager.undo(undoCallback);
		}
		
		//--------------------------------------------------------------------------------
		//				Helper functions
		//--------------------------------------------------------------------------------
		private function undoCallback(bd:BitmapData):void
		{
			layerManager.currentLayerBitmap.draw(bd);
			layerManager.currentLayer.updateThumbnail();
		}
		public function toString():String
		{
			return "Undo";
		}
		
	}
}