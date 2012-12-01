package com.shaunhusain.fingerPainting.view
{
	import flash.display.Sprite;
	import flash.events.Event;

	public class SecondaryBrushOptions extends Sprite
	{
		private var backgroundSprite:Sprite;
		
		private var pressureButton:CircleButton = new CircleButton();
		
		public function SecondaryBrushOptions()
		{
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		private function addedToStageHandler(event:Event):void
		{
			backgroundSprite = new Sprite();
			backgroundSprite.graphics.clear();
			backgroundSprite.graphics.beginFill(0xeeeeee,.5);
			backgroundSprite.graphics.drawRoundRect(0,0,638,stage.fullScreenHeight-200,100,100);
			backgroundSprite.graphics.endFill();
			addChild(backgroundSprite);
			
			addChild(pressureButton);
		}
		
		public function setConnectionYPosition(value:Number):void
		{
			backgroundSprite.graphics.clear();
			backgroundSprite.graphics.beginFill(0xeeeeee,.5);
			backgroundSprite.graphics.drawRoundRect(0,0,638,stage.fullScreenHeight-200,100,100);
			backgroundSprite.graphics.drawRect(638,value,300,130);
			backgroundSprite.graphics.endFill();
		}
	}
}