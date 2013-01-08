package com.shaunhusain.fingerPainting.view
{
	import com.shaunhusain.fingerPainting.model.PaintModel;
	import com.shaunhusain.fingerPainting.view.mobileUIControls.CircleButton;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TouchEvent;
	import flash.filesystem.File;
	import flash.utils.ByteArray;

	public class SavePanel extends Sprite
	{
		private var bitmapData:BitmapData;
		
		private var model:PaintModel = PaintModel.getInstance();
		
		private var backgroundSprite:Sprite;
		
		private var saveButton:CircleButton;
		
		public function SavePanel(bitmapData:BitmapData)
		{
			this.bitmapData = bitmapData;
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
			saveButton.addEventListener("circleButtonClicked", handleSaveClicked);
			addChild(saveButton);
			
			addEventListener(TouchEvent.TOUCH_MOVE, blockEvent);
			addEventListener(TouchEvent.TOUCH_TAP, blockEvent);
			addEventListener(TouchEvent.TOUCH_ROLL_OUT, blockEvent);
		}
		
		protected function handleSaveClicked(event:Event):void
		{
			var fr:File = new File();
			var bytearray:ByteArray = PNGEncoder2.encode(bitmapData);
			
			fr.save(bytearray, "testing.png");
			fr.addEventListener(Event.COMPLETE, fileChosenHandler);
		}
		
		protected function fileChosenHandler(event:Event):void
		{
		}
		
		private function blockEvent(event:TouchEvent):void
		{
			event.stopImmediatePropagation();
		}
	}
}