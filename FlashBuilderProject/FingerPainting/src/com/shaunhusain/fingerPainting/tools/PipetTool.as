package com.shaunhusain.fingerPainting.tools 
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.TouchEvent;

	public class PipetTool extends ToolBase implements ITool
	{
		protected var pipetSprite:Sprite;
		
		//--------------------------------------------------------------------------------
		//				Constructor
		//--------------------------------------------------------------------------------
		public function PipetTool(stage:Stage)
		{
			super(stage);
			if(!pipetSprite)
			{
				pipetSprite = new Sprite();
				stage.addChild(pipetSprite);
			}
		}
		
		//--------------------------------------------------------------------------------
		//				Handlers
		//--------------------------------------------------------------------------------
		public function takeAction(event:TouchEvent=null):void
		{
			switch(event.type)
			{
				case TouchEvent.TOUCH_BEGIN:
					pipetSprite.visible = true;
					break
				case TouchEvent.TOUCH_MOVE:
					break
				case TouchEvent.TOUCH_END:
					pipetSprite.visible = false;
					break
			}
			model.currentColor = layerManager.currentLayerBitmap.getPixel32(event.stageX,event.stageY);
			pipetSprite.x = event.stageX;
			pipetSprite.y = event.stageY;
			updatePipetSprite();
		}
		public function toString():String
		{
			return "Pipet";
		}
		
		private function updatePipetSprite():void
		{
			pipetSprite.graphics.clear();
			pipetSprite.graphics.beginFill(0x808080);
			pipetSprite.graphics.drawCircle(0,0,120);
			pipetSprite.graphics.drawCircle(0,0,100);
			pipetSprite.graphics.endFill();
			pipetSprite.graphics.beginFill(model.currentColor);
			pipetSprite.graphics.drawCircle(0,0,100);
			pipetSprite.graphics.drawCircle(0,0,80);
			pipetSprite.graphics.endFill();
			
		}
	}
}