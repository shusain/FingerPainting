package com.shaunhusain.fingerPainting.tools 
{
	import flash.display.Stage;
	import flash.events.TouchEvent;

	public class PipetTool extends ToolBase implements ITool
	{
		//--------------------------------------------------------------------------------
		//				Constructor
		//--------------------------------------------------------------------------------
		public function PipetTool(stage:Stage)
		{
			super(stage);
		}
		
		//--------------------------------------------------------------------------------
		//				Handlers
		//--------------------------------------------------------------------------------
		public function takeAction(event:TouchEvent=null):void
		{
			model.currentColor = layerManager.currentLayerBitmap.getPixel32(event.stageX,event.stageY);
		}
	}
}