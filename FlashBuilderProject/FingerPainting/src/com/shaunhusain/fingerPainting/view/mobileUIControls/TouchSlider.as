package com.shaunhusain.fingerPainting.view.mobileUIControls
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TouchEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class TouchSlider extends Sprite
	{
		//--------------------------------------------------------------------------------
		//				Constants
		//--------------------------------------------------------------------------------
		public static const VALUE_CHANGED:String="valueChanged";
		private const BAR_TOP_OFFSET:Number = 60;
		
		//--------------------------------------------------------------------------------
		//				UI Elements
		//--------------------------------------------------------------------------------
		protected var thumb:Sprite;
		protected var slider:Sprite;
		protected var hitAreaSprite:Sprite;
		protected var titleLabel:TextField;
		protected var valueLabel:TextField;
		
		//--------------------------------------------------------------------------------
		//				Variables
		//--------------------------------------------------------------------------------
		private var titleTextFormat:TextFormat;
		private var valueTextFormat:TextFormat;
		private var hasRegisteredListeners:Boolean;
		
		//--------------------------------------------------------------------------------
		//				Constructor
		//--------------------------------------------------------------------------------
		public function TouchSlider()
		{
			super();
			
			if(!slider)
			{
				slider = new Sprite();
				slider.y = BAR_TOP_OFFSET;
				addChild(slider);
			}
			
			if(!thumb)
			{
				thumb = new Sprite();
				thumb.y = BAR_TOP_OFFSET;
				thumb.mouseEnabled = false;
				thumb.mouseChildren = false;
				addChild(thumb);
			}
			
			if(!hitAreaSprite)
			{
				hitAreaSprite = new Sprite();
				hitAreaSprite.visible = false;
				//hitAreaSprite.alpha = .5;
				hitAreaSprite.y = BAR_TOP_OFFSET;
				addChild(hitAreaSprite);
				hitArea = hitAreaSprite;
			}
			
			if(!titleTextFormat)
			{
				titleTextFormat = new TextFormat();
				titleTextFormat.size = 32;
			}
			
			if(!valueTextFormat)
			{
				valueTextFormat = new TextFormat();
				valueTextFormat.size = 24;
			}
			
			if(!titleLabel)
			{
				titleLabel = new TextField();
				titleLabel.mouseEnabled = false;
				titleLabel.autoSize = TextFieldAutoSize.LEFT;
				titleLabel.defaultTextFormat = titleTextFormat;
				addChild(titleLabel);
			}
			
			if(!valueLabel)
			{
				valueLabel = new TextField();
				valueLabel.mouseEnabled = false;
				valueLabel.autoSize = TextFieldAutoSize.CENTER;
				valueLabel.defaultTextFormat = valueTextFormat;
				valueLabel.y = BAR_TOP_OFFSET - 30;
				addChild(valueLabel);
			}
			
			drawGraphics();
			if(!hasRegisteredListeners)
			{
				addEventListener(TouchEvent.TOUCH_MOVE, handleSliding);
				addEventListener(TouchEvent.TOUCH_TAP, blockEvent);
				hasRegisteredListeners = true;
			}
			
		}
		
		//--------------------------------------------------------------------------------
		//				Properties
		//--------------------------------------------------------------------------------
		private var _currentValue:Number;
		public function set currentValue(value:Number):void
		{
			if(_currentValue==value)
				return;
			
			var percentAlongBar:Number = value/barWidth;
			
			//if above 1 or below 0 set within normal range for percent
			percentAlongBar = (percentAlongBar>1) ? 1 : percentAlongBar;
			percentAlongBar = (percentAlongBar<0) ? 0 : percentAlongBar;
			
			//calculate current value based on max/min and current percentage
			_currentValue = minimum + (maximum-minimum)*percentAlongBar;
			
			//position the thumb
			thumb.x = percentAlongBar*barWidth;
			
			//update the label
			valueLabel.x = percentAlongBar*barWidth + thumb.width/2-valueLabel.width/2;
			updateCurrentValueLabel();
			
			//dispatch change event
			dispatchEvent(new Event("valueChanged"));
		}
		public function get currentValue():Number
		{
			return _currentValue;
		}
		
		private var _titleLabelText:String;
		public function set titleLabelText(value:String):void
		{
			if(_titleLabelText==value)
				return;
			titleLabel.text = _titleLabelText = value;
		}
		public function get titleLabelText():String
		{
			return _titleLabelText;
		}
		
		private var _maximum:Number = 100;

		public function get maximum():Number
		{
			return _maximum;
		}

		public function set maximum(value:Number):void
		{
			_maximum = value;
		}

		private var _minimum:Number = 0;
		public function get minimum():Number
		{
			return _minimum;
		}
		public function set minimum(value:Number):void
		{
			_minimum = value;
		}

		private var _barWidth:Number = 360;

		public function get barWidth():Number
		{
			return _barWidth;
		}

		public function set barWidth(value:Number):void
		{
			_barWidth = value;
			drawGraphics();
			thumb.x = currentValue/(maximum-minimum)*_barWidth;
		}
		
		private var _decimalsToShow:Number=0;

		public function get decimalsToShow():Number
		{
			return _decimalsToShow;
		}

		public function set decimalsToShow(value:Number):void
		{
			_decimalsToShow = value;
			updateCurrentValueLabel();
		}
		
		private var _dispAsPercent:Boolean;

		public function get dispAsPercent():Boolean
		{
			return _dispAsPercent;
		}

		public function set dispAsPercent(value:Boolean):void
		{
			_dispAsPercent = value;
		}

		
		//--------------------------------------------------------------------------------
		//				Handlers
		//--------------------------------------------------------------------------------
		private function handleSliding(event:TouchEvent):void
		{
			currentValue = event.localX;
			event.stopImmediatePropagation();
		}
		private function blockEvent(event:TouchEvent):void
		{
			event.stopImmediatePropagation();
		}
		
		//--------------------------------------------------------------------------------
		//				Helper Functions
		//--------------------------------------------------------------------------------
		private function updateCurrentValueLabel():void
		{
			if(dispAsPercent)
				valueLabel.text = Math.floor(_currentValue*100) + "%";
			else	
				valueLabel.text = _currentValue.toFixed(decimalsToShow);
		}
		protected function drawGraphics():void
		{
			var hasg:Graphics = hitAreaSprite.graphics;
			hasg.clear();
			hasg.beginFill(0xFF0000);
			hasg.drawRect(-30,0,barWidth+60,100);
			hasg.endFill();
			
			var sg:Graphics = slider.graphics;
			sg.clear();
			sg.beginFill(0x00aa00);
			sg.drawRect(0,45,barWidth,10);
			sg.endFill();
			
			var tg:Graphics = thumb.graphics;
			tg.clear();
			tg.beginFill(0xFF0000);
			tg.drawRect(0,0,40,100);
			tg.endFill();
			
		}
	}
}