package com.shaunhusain.fingerPainting.view.mobileUIControls
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TouchEvent;
	
	public class TouchSlider extends Sprite
	{
		public static const VALUE_CHANGED:String="valueChanged";
		
		public var thumb:Sprite;
		public var slider:Sprite;
		public var hitAreaSprite:Sprite;
		
		private var _currentValue:Number;
		public function set currentValue(value:Number):void
		{
			if(_currentValue==value)
				return;
			_currentValue = value;
			
			dispatchEvent(new Event("valueChanged"));
		}
		public function get currentValue():Number
		{
			return _currentValue;
		}
		
		public function TouchSlider()
		{
			super();
			slider = new Sprite();
			var sg:Graphics = slider.graphics;
			sg.clear();
			sg.beginFill(0x00FF00);
			sg.drawRect(0,25,360,50);
			sg.endFill();
			addChild(slider);
			
			thumb = new Sprite();
			thumb.mouseEnabled = false;
			thumb.mouseChildren = false;
			var tg:Graphics = thumb.graphics;
			tg.clear();
			tg.beginFill(0xFF0000);
			tg.drawRect(0,0,40,100);
			tg.endFill();
			addChild(thumb);
			
			
			hitAreaSprite = new Sprite();
			var hasg:Graphics = hitAreaSprite.graphics;
			hasg.clear();
			hasg.beginFill(0xFF0000);
			hasg.drawRect(0,0,360,100);
			hasg.endFill();
			hitAreaSprite.visible = false;
			addChild(hitAreaSprite);
			hitArea = hitAreaSprite;
			
			addEventListener(TouchEvent.TOUCH_MOVE, handleSliding);
			addEventListener(TouchEvent.TOUCH_TAP, blockEvent);
			
		}
		
		private function handleSliding(event:TouchEvent):void
		{
			currentValue = thumb.x = event.localX;
			event.stopImmediatePropagation();
		}
		private function blockEvent(event:TouchEvent):void
		{
			event.stopImmediatePropagation();
		}
	}
}