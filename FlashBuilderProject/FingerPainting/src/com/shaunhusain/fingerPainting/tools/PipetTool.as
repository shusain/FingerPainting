package com.shaunhusain.fingerPainting.tools 
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.TouchEvent;

	public class PipetTool extends ToolBase implements ITool
	{
		protected var pipetSprite:Sprite;
		private var flattenedData:BitmapData;
		
		//--------------------------------------------------------------------------------
		//				Constructor
		//--------------------------------------------------------------------------------
		public function PipetTool(stage:Stage)
		{
			super(stage);
			if(!pipetSprite)
			{
				pipetSprite = new Sprite();
				pipetSprite.mouseEnabled = false;
				pipetSprite.mouseChildren = false;
				stage.addChild(pipetSprite);
			}
		}
		
		//--------------------------------------------------------------------------------
		//				Handlers
		//--------------------------------------------------------------------------------
		public function takeAction(event:TouchEvent=null):void
		{
			if(event.target != stage)
				return;
			switch(event.type)
			{
				case TouchEvent.TOUCH_BEGIN:
					flattenedData = layerM.getFlattenedBitmapData();
					pipetSprite.visible = true;
					break
				case TouchEvent.TOUCH_MOVE:
					break
				case TouchEvent.TOUCH_END:
					pipetSprite.visible = false;
					break
			}
			var curScale:Number = layerM.scaleX;
			var adjustedX:Number = event.stageX/curScale - layerM.x/curScale;
			var adjustedY:Number = event.stageY/curScale - layerM.y/curScale;
			
			model.currentColor = flattenedData.getPixel32(adjustedX,adjustedY);
			pipetSprite.x = event.stageX;
			pipetSprite.y = event.stageY;
			updatePipetSprite();
		}
		public function toString():String
		{
			return "Pipet: Touch in canvas to pick up color under finger for brush or fill";
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