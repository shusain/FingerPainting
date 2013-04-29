package com.nemenvisual.nicecomps
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import com.nemenvisual.nicecomps.IComponent;
	
	/**
	 * ...
	 * @author Ben Foster
	 */
	public class NumericStepper extends ComponentBase
	{
		private var _up:Sprite;
		private var _down:Sprite;
		private var _text:Text;
		private var _value:Number;
		private var _increment:Number;
		private var _min:Number;
		private var _max:Number;
		
		public function NumericStepper(dispatch:Boolean = true):void
		{
			super(dispatch);
			init();
		}
		
		protected override function init():void
		{
			_up = new Sprite();
			_down = new Sprite();
			_text = new Text();
			_boxWidth = 40;
			_boxHeight = 16;
			_baseColour = 0xFFFFFF;
			_value = 0;
			_increment = 1;
			_min = 0;
			_max = 10;
			
			_text.textColour = 0x000000;
			_text.y = -2;
			_text.x = 2;
			_text.size = 12;
			_text.selectable = false;
			_text.boxWidth = _boxWidth - 20;
			_text.boxHeight = 16;
			_text.text = "0";
			
			addChild(_text);
			
			_up.y = _boxHeight/2;
			_up.x = _boxWidth;
			_up.rotation = 180;
			
			_down.y = _boxHeight/2;
			_down.x = _boxWidth - 16;
			
			_up.addEventListener(MouseEvent.MOUSE_OVER, onArrowOver);
			_up.addEventListener(MouseEvent.MOUSE_OUT, onArrowOut);
			
			_down.addEventListener(MouseEvent.MOUSE_OVER, onArrowOver);
			_down.addEventListener(MouseEvent.MOUSE_OUT, onArrowOut);
			
			_up.addEventListener(MouseEvent.CLICK, onUpClick);
			_down.addEventListener(MouseEvent.CLICK, onDownClick);
			
			
			addChild(_up);
			addChild(_down);
			
			redraw();
			drawArrowButtons(_up,0x7C7C7C,_baseColour);
			drawArrowButtons(_down,0x7C7C7C,_baseColour);
		}
		
		protected override function redraw():void
		{
			super.redraw();
			
			_up.x = _boxWidth;
			_up.y = _boxHeight / 2;
			
			_down.y = _boxHeight/2;
			_down.x = _boxWidth - 16;
			
			graphics.beginFill(_baseColour, 1);
			graphics.drawRect(0, 0, _boxWidth, _boxHeight);
			graphics.endFill();
			
			
		}
		
		private function drawArrowButtons(s:Sprite,clr:uint,base:uint):void
		{
			s.graphics.clear();
			s.graphics.beginFill(base, 1);
			s.graphics.drawRect(0, 0, 16, _boxHeight/2);
			s.graphics.endFill();
			
			s.graphics.beginFill(clr, 1);
			s.graphics.moveTo(5, 3);
			s.graphics.lineTo(11, 3);
			s.graphics.lineTo(8, 6);
			s.graphics.lineTo(5, 3);
			s.graphics.endFill();
		}
		
		private function onArrowOver(e:MouseEvent):void
		{
			drawArrowButtons(e.currentTarget as Sprite,_accent,_baseColour);
		}
		
		private function onArrowOut(e:MouseEvent):void
		{
			drawArrowButtons(e.currentTarget as Sprite,0x7C7C7C,_baseColour);
		}
		
		private function onUpClick(e:MouseEvent):void
		{
			_value += _increment;
			
			_value = _value > _max ? _value = _max : _value;
			
			_text.text = String(_value);
		}
		
		private function onDownClick(e:MouseEvent):void
		{
			_value -= _increment;
			
			_value = _value < _min ? _value = _min : _value;
			
			_text.text = String(_value);
		}
		
		
		//-----------------------SETTERS--------------------------------
		
		public override function set id(c:int):void
		{
			super.id = c;
		}
		
		public override function set baseColour(c:uint):void
		{
			super.baseColour = c;
		}
		
		public override function set accent(c:uint):void
		{
			super.accent = c;
			redraw();
			drawArrowButtons(_up,0x7C7C7C,_baseColour);
			drawArrowButtons(_down,0x7C7C7C,_baseColour);
		}
		
		public override function set textColour(c:uint):void
		{
			super.textColour = c;
		}
		
		public override function set boxWidth(n:Number):void
		{
			super.boxWidth = n;
			redraw();
		}
		
		public override function set boxHeight(n:Number):void
		{
			super.boxHeight = n;
			redraw();
		}
		
		public override function set label(s:String):void
		{
			super.label = s;
		}
		
		public override function set enable(b:Boolean):void
		{
			super.enable = b;
		}
		
		public function set increment(b:Number):void
		{
			_increment = b;
		}
		
		public function set minValue(b:Number):void
		{
			_min = b;
		}
		
		public function set maxValue(b:Number):void
		{
			_max = b;
		}
		
		public function set value(b:Number):void
		{
			_value = b;
			_text.text = String(_value);
		}
		
		//-----------------------------GETTERS-----------------
		
		public function get value():Number
		{
			return _value;
		}
	}
	
}