package com.nemenvisual.nicecomps
{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import com.nemenvisual.nicecomps.IComponent;
	
	/**
	 * ...
	 * @author Ben Foster
	 */
	public class HSlider extends ComponentBase
	{
		private var thumb:Shape = new Shape();
		private var _value:Number = 1;
		private var _labelTxt:TextField = new TextField();
		private var _tf:TextFormat = new TextFormat();
		private var _ref:String;
		private var _multiplier:Number = 1;
		
		public function HSlider(dispatch:Boolean = true):void
		{
			super(dispatch);
			init();
		}
		
		protected override function init():void
		{
			_boxWidth = 200;
			_boxHeight = 10;
			_baseColour = 0x666666;
			
			thumb.x = _boxWidth-(_boxHeight/2);
			thumb.y = _boxHeight/2;
			addChild(thumb);
			
			redraw();
			
			_tf.align = "right";
			_tf.color = 0xFFFFFF;
			_tf.size = 12;
			_tf.font = "Arial";
			
			_labelTxt.x = -110;
			_labelTxt.autoSize = "right";
			_labelTxt.defaultTextFormat = _tf;
			_labelTxt.text = "label label";
			_labelTxt.height = _labelTxt.textHeight + 2;
			_labelTxt.y = (_boxHeight/2)-(_labelTxt.height/2);
			
			addChild(_labelTxt);
			
			addEventListener(MouseEvent.MOUSE_DOWN, onDown);
		}
		
		protected override function redraw():void
		{
			super.redraw();
			
			thumb.x = _boxWidth-(_boxHeight/2);
			thumb.y = _boxHeight/2;
			
			graphics.clear();
			graphics.beginFill(_baseColour, 1);
			graphics.drawRect( 0, 0, _boxWidth, _boxHeight);
			graphics.endFill();
			
			thumb.graphics.clear();
			thumb.graphics.beginFill(_accent, 1);
			thumb.graphics.drawRect( -_boxHeight/2, -_boxHeight/2, _boxHeight, _boxHeight);
			thumb.graphics.endFill();
		}
		
		private function onDown(e:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onUp);
			
			thumb.x = mouseX;
			
			calculate();
			
			dispatchEvent(new Event("CHANGED"));
		}
		
		private function onMove(e:MouseEvent):void
		{
			thumb.x = mouseX;
			
			calculate();
			
			dispatchEvent(new Event("CHANGED"));
			
			e.updateAfterEvent();
		}
		
		private function calculate():void
		{
			if (thumb.x < _boxHeight/2)
			{
				thumb.x = _boxHeight/2;
			}
			if (thumb.x > _boxWidth-(_boxHeight/2))
			{
				thumb.x = _boxWidth-(_boxHeight/2);
			}
			
			_value = (thumb.x - (_boxHeight/2)) / (_boxWidth-_boxHeight);
		}
		
		private function onUp(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onUp);
		}
		
		
		//-----------------------SETTERS--------------------------------
		
		public override function set id(c:int):void
		{
			super.id = c;
		}
		
		public override function set baseColour(c:uint):void
		{
			super.baseColour = c;
			redraw();
		}
		
		public override function set accent(c:uint):void
		{
			super.accent = c;
			redraw();
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
			_labelTxt.text = s;
		}
		
		public override function set enable(b:Boolean):void
		{
			super.enable = b;
		}
		
		public function set value(n:Number):void
		{
			_value = n;
			thumb.x = n * (_boxWidth-_boxHeight) + (_boxHeight/2);
		}
		
		public function set multiplier(n:Number):void
		{
			_multiplier = n;
		}
		
		//----------------------GETTERS----------------------------
		
		public function get value():Number
		{
			return _value * multiplier;
		}
		
		public function get multiplier():Number
		{
			return _multiplier;
		}
		
	}
	
}