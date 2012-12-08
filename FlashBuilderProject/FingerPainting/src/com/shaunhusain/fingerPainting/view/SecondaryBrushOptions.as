package com.shaunhusain.fingerPainting.view
{
	import com.shaunhusain.fingerPainting.model.PaintModel;
	import com.shaunhusain.fingerPainting.view.mobileUIControls.TouchSlider;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TouchEvent;
	import com.shaunhusain.fingerPainting.view.mobileUIControls.CircleButton;

	public class SecondaryBrushOptions extends Sprite
	{
		private var model:PaintModel = PaintModel.getInstance();
		
		private var backgroundSprite:Sprite;
		
		private var pressureButton:CircleButton;
		
		private var brushSizeSlider:TouchSlider;
		
		private var brushOpacitySlider:TouchSlider;
		
		private var brushSizeExample:Sprite;
		
		public function SecondaryBrushOptions()
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
			
			pressureButton = new CircleButton();
			pressureButton.x = 20;
			pressureButton.y = 20;
			pressureButton.text = "Pressure\nButton";
			addChild(pressureButton);
			
			brushSizeSlider = new TouchSlider();
			brushSizeSlider.x = 20;
			brushSizeSlider.y = 220;
			addChild(brushSizeSlider);
			
			
			brushSizeExample = new Sprite();
			brushSizeExample.y = 440;
			brushSizeExample.x = 200;
			brushSizeExample.mouseEnabled=brushSizeExample.mouseChildren=false;
			brushSizeExample.graphics.clear();
			brushSizeExample.graphics.beginFill(model.currentColor);
			brushSizeExample.graphics.drawCircle(0,0, model.brushCurrentWidth);
			brushSizeExample.graphics.endFill();
			addChild(brushSizeExample);
			
			brushSizeSlider.addEventListener(TouchSlider.VALUE_CHANGED, updateBrushSampleSize);
			
			brushOpacitySlider = new TouchSlider();
			brushOpacitySlider.x = 20;
			brushOpacitySlider.y = 640;
			addChild(brushOpacitySlider);
			brushOpacitySlider.addEventListener(TouchSlider.VALUE_CHANGED, updateBrushOpacity);
			
			addEventListener(TouchEvent.TOUCH_MOVE, blockEvent);
			addEventListener(TouchEvent.TOUCH_TAP, blockEvent);
			addEventListener(TouchEvent.TOUCH_ROLL_OUT, blockEvent);
		}
		
		private function updateBrushSampleSize(event:Event):void
		{
			model.brushCurrentWidth = brushSizeSlider.currentValue/3;
			brushSizeExample.graphics.clear();
			brushSizeExample.graphics.beginFill(model.currentColor,model.brushOpacity);
			brushSizeExample.graphics.drawCircle(0,0, model.brushCurrentWidth);
			brushSizeExample.graphics.endFill();
		}
		
		private function updateBrushOpacity(event:Event):void
		{
			model.brushOpacity = brushOpacitySlider.currentValue/360;
			brushSizeExample.graphics.clear();
			brushSizeExample.graphics.beginFill(model.currentColor,model.brushOpacity);
			brushSizeExample.graphics.drawCircle(0,0, model.brushCurrentWidth);
			brushSizeExample.graphics.endFill();
		}
		
		public function setConnectionYPosition(value:Number):void
		{
			backgroundSprite.graphics.clear();
			backgroundSprite.graphics.beginFill(0xeeeeee,.5);
			backgroundSprite.graphics.drawRoundRect(0,0,420,stage.fullScreenHeight-200,100,100);
			backgroundSprite.graphics.drawRect(420,value,300,130);
			backgroundSprite.graphics.endFill();
		}
		
		private function blockEvent(event:TouchEvent):void
		{
			event.stopImmediatePropagation();
		}
	}
}