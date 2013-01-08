package com.shaunhusain.fingerPainting.tools 
{
	import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.events.TouchEvent;

	public class PipetTool extends ToolBase implements ITool
	{
		public function PipetTool(stage:Stage)
		{
			super(stage);
		}
		public function takeAction(event:TouchEvent=null):void
		{
			/*if(model.video.visible)
			{
				var tempBD:BitmapData = new BitmapData(model.cameraWrapper.width,model.cameraWrapper.height);
				var matrix:Matrix = new Matrix;
				matrix.tx = stage.fullScreenWidth/2;
				matrix.ty = stage.fullScreenHeight/2;
				tempBD.draw(model.cameraWrapper, matrix);
				
				model.currentColor = tempBD.getPixel32(event.stageX,event.stageY);
			}
			else
			{*/
				model.currentColor = layerManager.currentLayerBitmap.getPixel32(event.stageX,event.stageY);
			/*}*/
		}
	}
}