package com.shaunhusain.fingerPainting.view
{
	import com.shaunhusain.fingerPainting.model.PaintModel;
	import com.shaunhusain.fingerPainting.view.mobileUIControls.CircleButton;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TouchEvent;

	public class SavePanel extends Sprite
	{
		private var model:PaintModel = PaintModel.getInstance();
		
		private var backgroundSprite:Sprite;
		
		private var saveButton:CircleButton;
		
		public function SavePanel()
		{
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		private function addedToStageHandler(event:Event):void
		{
			backgroundSprite = new Sprite();
			backgroundSprite.graphics.clear();
			backgroundSprite.graphics.beginFill(0xeeeeee);
			backgroundSprite.graphics.drawRoundRect(0,0,420,stage.fullScreenHeight-200,100,100);
			backgroundSprite.graphics.endFill();
			addChild(backgroundSprite);
			
			saveButton = new CircleButton();
			saveButton.text = "Save";
			saveButton.x = 20;
			saveButton.y = 20;
			addChild(saveButton);
			
			addEventListener(TouchEvent.TOUCH_MOVE, blockEvent);
			addEventListener(TouchEvent.TOUCH_TAP, blockEvent);
			addEventListener(TouchEvent.TOUCH_ROLL_OUT, blockEvent);
		}
		
		private function blockEvent(event:TouchEvent):void
		{
			event.stopImmediatePropagation();
		}
	}
}