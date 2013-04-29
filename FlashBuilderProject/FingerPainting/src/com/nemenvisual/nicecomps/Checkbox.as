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
	public class Checkbox extends ComponentBase
	{
		private var _selected:Boolean;
		private var _labelTxt:TextField;
		private var _tf:TextFormat;
		private var _overtf:TextFormat;
		private var _box:Shape;
		
		public function Checkbox(dispatch:Boolean = true):void
		{
			super(dispatch);
			init();
		}
		
		protected override function init():void
		{
			super.init();
			
			_baseColour		= 0xFFFFFF;
			_selected 		= false;
			_labelTxt 		= new TextField();
			_tf 			= new TextFormat();
			_overtf			= new TextFormat();
			_box 			= new Shape();
			
			_textColour		= 0x000000;
			_boxWidth 		= 15;
			_boxHeight		= _boxWidth;
			
			_tf.color 		= _textColour;
			_tf.size 		= 12;
			_tf.font 		= "Arial";
			
			_overtf.color 	= 0xCCCCCC;
			_overtf.size 	= 12;
			_overtf.font 	= "Arial";
			
			_labelTxt.defaultTextFormat = _tf;
			_labelTxt.selectable 		= false;
			_labelTxt.autoSize 			= "left";
			_labelTxt.x 				= 20;
			_labelTxt.y 				= -2;
			//_labelTxt.text 				= _label;
			
			this.addChild(_box);
			this.addChild(_labelTxt);
			
			this.addEventListener(MouseEvent.CLICK, onCheck);
			this.addEventListener(MouseEvent.MOUSE_OVER, onOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, onOut);
			
			redraw();
		}
		
		protected override function redraw():void
		{
			super.redraw();
			
			_box.graphics.clear();
			
			_labelTxt.x = _boxWidth + 3;
			_labelTxt.y = (_boxHeight / 2) - (_labelTxt.height / 2);
			
			if (!_selected)
			{
				_box.graphics.beginFill(_baseColour, 1);
				_box.graphics.drawRect(0, 0, _boxWidth, _boxHeight);
				_box.graphics.endFill();
			}
			else
			{
				_box.graphics.beginFill(_accent, 1);
				_box.graphics.drawRect(0, 0, _boxWidth, _boxHeight);
				_box.graphics.endFill();
				_box.graphics.lineStyle(1, 0xFFFFFF, 1);
				_box.graphics.moveTo(_boxWidth/5, _boxWidth/1.875);
				_box.graphics.lineTo(_boxWidth/2.5, _boxWidth/1.25);
				_box.graphics.lineTo(_boxWidth/1.25, _boxWidth/3.75);
			}
		}
		
		private function onCheck(e:MouseEvent):void
		{
			if (!_selected)
			{
				_selected = true;
			}
			else
			{
				_selected = false;
			}
			
			redraw();
			dispatchEvent(new Event("onChange"));
		}
		
		public function onOver(e:MouseEvent):void
		{
			if (!_selected)
			{
				_box.graphics.clear();
				_box.graphics.beginFill(_accent, 1);
				_box.graphics.drawRect(0, 0, _boxWidth, _boxHeight);
				_box.graphics.endFill();
			}
			
			_labelTxt.setTextFormat(_overtf, 0, _labelTxt.text.length);
		}
		
		public function onOut(e:MouseEvent):void
		{
			_labelTxt.setTextFormat(_tf, 0, _labelTxt.text.length);
			
			if (!_selected)
			{
				_box.graphics.clear();
				_box.graphics.beginFill(_baseColour, 1);
				_box.graphics.drawRect(0, 0, _boxWidth, _boxHeight);
				_box.graphics.endFill();
			}
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
			
			_tf = new TextFormat();
			_tf.color 		= _textColour;
			_tf.size 		= 12;
			_tf.font 		= "Arial";
			
			if (_labelTxt.text != "" )
			{
				onOut(null);
			}
		}
		
		public override function set boxWidth(n:Number):void
		{
			super.boxWidth = n;
			_boxHeight = _boxWidth;
			redraw();
		}
		
		public override function set boxHeight(n:Number):void
		{
			super.boxHeight = n;
			_boxWidth = _boxHeight;
			redraw();
		}
		
		public override function set label(s:String):void
		{
			super.label = s;
			_labelTxt.text = _label;
			_labelTxt.setTextFormat(_tf, 0, _labelTxt.text.length);
		}
		
		public override function set enable(b:Boolean):void
		{
			super.enable = b;
		}
		
		public function set selected(b:Boolean):void
		{
			_selected = b;
			redraw();
		}
		
		//-------------------------GETTERS-----------------------------
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
	}
	
}