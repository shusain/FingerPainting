package com.shaunhusain.fingerPainting.view
{
	import com.shaunhusain.fingerPainting.model.PaintModel;
	import com.shaunhusain.fingerPainting.view.mobileUIControls.CircleButton;
	import com.shaunhusain.fingerPainting.view.mobileUIControls.TouchSlider;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TouchEvent;

	public class SecondaryBrushOptions extends Sprite
	{
		private var model:PaintModel = PaintModel.getInstance();
		private var backgroundSprite:Sprite;
		private var pressureButton:CircleButton;
		private var brushSizeSlider:TouchSlider;
		private var brushOpacitySlider:TouchSlider;
		private var brushSizeExample:Sprite;
		private var registeredEventListeners:Boolean;
		
		public function SecondaryBrushOptions()
		{
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		private function addedToStageHandler(event:Event):void
		{
			if(!backgroundSprite)
			{
				backgroundSprite = new Sprite();
				backgroundSprite.graphics.clear();
				backgroundSprite.graphics.beginFill(0xeeeeee);
				backgroundSprite.graphics.drawRoundRect(0,0,420,stage.fullScreenHeight-200,100,100);
				backgroundSprite.graphics.endFill();
				addChild(backgroundSprite);
			}
			
			if(!pressureButton)
			{
				pressureButton = new CircleButton();
				pressureButton.selected = true;
				pressureButton.x = 20;
				pressureButton.y = 20;
				pressureButton.text = "Pressure\nButton";
				pressureButton.addEventListener("circleButtonClicked", pressureButtonHandler);
				addChild(pressureButton);
			}
			
			
			if(!brushSizeExample)
			{
				brushSizeExample = new Sprite();
				brushSizeExample.y = 440;
				brushSizeExample.x = 200;
				brushSizeExample.mouseEnabled=brushSizeExample.mouseChildren=false;
				brushSizeExample.graphics.clear();
				brushSizeExample.graphics.beginFill(model.currentColor);
				brushSizeExample.graphics.drawCircle(0,0, model.brushCurrentWidth);
				brushSizeExample.graphics.endFill();
				addChild(brushSizeExample);
			}
			
			
			if(!brushSizeSlider)
			{
				brushSizeSlider = new TouchSlider();
				brushSizeSlider.addEventListener(TouchSlider.VALUE_CHANGED, updateBrushSampleSize);
				brushSizeSlider.x = 20;
				brushSizeSlider.y = 220;
				addChild(brushSizeSlider);
			}
			
			if(!brushOpacitySlider)
			{
				brushOpacitySlider = new TouchSlider();
				brushOpacitySlider.addEventListener(TouchSlider.VALUE_CHANGED, updateBrushOpacity);
				brushOpacitySlider.x = 20;
				brushOpacitySlider.y = 640;
				addChild(brushOpacitySlider);
			}
			
			if(!registeredEventListeners)
			{
				addEventListener(TouchEvent.TOUCH_MOVE, blockEvent);
				addEventListener(TouchEvent.TOUCH_TAP, blockEvent);
				addEventListener(TouchEvent.TOUCH_ROLL_OUT, blockEvent);
				registeredEventListeners = true;
			}
			updateValues();
		}
		
		protected function pressureButtonHandler(event:Event):void
		{
			model.isPressureSensitive = pressureButton.selected;
		}
		
		private function updateBrushSampleSize(event:Event):void
		{
			model.brushCurrentWidth = brushSizeSlider.currentValue/3;
			redrawBrush();
		}
		
		private function updateBrushOpacity(event:Event):void
		{
			model.brushOpacity = brushOpacitySlider.currentValue/360;
			redrawBrush();
		}
		
		public function updateValues():void
		{
			if(!pressureButton)
				return;
			pressureButton.selected = model.isPressureSensitive;
			
			brushSizeSlider.currentValue = model.brushCurrentWidth*3;
			brushOpacitySlider.currentValue = model.brushOpacity*360;
			redrawBrush();
		}
		
		private function redrawBrush():void
		{
			brushSizeExample.graphics.clear();
			brushSizeExample.graphics.beginFill(model.currentColor,model.brushOpacity);
			brushSizeExample.graphics.drawCircle(0,0, model.brushCurrentWidth);
			brushSizeExample.graphics.endFill();
		}
		
		private function blockEvent(event:TouchEvent):void
		{
			event.stopImmediatePropagation();
		}
	}
}