package com.nemenvisual.nicecomps
{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import com.nemenvisual.nicecomps.IComponent;
	
	/**
	 * ...
	 * @author Ben Foster
	 */
	public class SwatchListItem extends ComponentBase
	{
		private var _data:String;
		private var _labelTxt:TextField;
		private var _background:Shape;
		private var _tf:TextFormat;
		private var _overColour:uint;
		private var _bgOverColour:uint;
		private var _selected:Boolean;
		private var _index:int;
		private var _colour:uint;
		private var _swatch:Shape;
		
		public function SwatchListItem(dispatch:Boolean = true):void
		{
			super(dispatch);
			init();
		}
		
		protected override function init():void
		{
			super.init();
			
			_selected 			= false;
			
			_background 		= new Shape();
			_swatch 			= new Shape();
			_labelTxt 			= new TextField();
			_tf 				= new TextFormat();
			
			_swatch.x			= 2;
			_swatch.y			= 2;
			_colour				= 0x000000;
			_bgOverColour 		= 0xFFFFFF;
			_textColour			= 0x000000;
			_label 				= "New Button";
			_boxWidth 			= 100;
			_boxHeight			= 22;
			
			_tf.color 			= _textColour;
			_tf.size 			= 14;
			_tf.font 			= "Arial";
			
			_labelTxt.defaultTextFormat = _tf;
			_labelTxt.autoSize 			= TextFieldAutoSize.LEFT;
			_labelTxt.text 				= _label;
			_labelTxt.antiAliasType 	= "advanced";
			_labelTxt.selectable 		= false;
			_labelTxt.mouseEnabled		= false;
			_labelTxt.width				= 100;
			_labelTxt.x 				= 25;
			_labelTxt.y 				= 2;
			
			this.addChild(_background);
			this.addChild(_labelTxt);
			this.addChild(_swatch);
			
			this.addEventListener(MouseEvent.MOUSE_OVER, onOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, onOut);
			this.addEventListener(MouseEvent.MOUSE_DOWN, onClick);
			
			redraw();
			drawSwatch();
		}
		
		protected override function redraw():void
		{
			super.redraw();
			
			_labelTxt.width = _labelTxt.textWidth - 25;
			_labelTxt.y = (_boxHeight / 2) - (_labelTxt.height / 2);
			
			_background.graphics.clear();
			_background.graphics.beginFill(_bgOverColour, 1);
			_background.graphics.drawRect(0, 0, _boxWidth, _boxHeight);
			_background.graphics.endFill();
		}
		
		private function drawSwatch():void
		{
			_swatch.graphics.clear();
			_swatch.graphics.beginFill(_colour);
			_swatch.graphics.drawRect(0, 0, _boxHeight - 4, _boxHeight - 4);
			_swatch.graphics.endFill();
		}
		
		private function onOver(e:MouseEvent):void
		{
			if (!_selected)
			{
				var tf:TextFormat = new TextFormat();
				tf.color = _accent;
				tf.size = 14;
				tf.font = "Arial";
				_labelTxt.setTextFormat(tf, 0, _labelTxt.length);
			}
		}
		
		private function onOut(e:MouseEvent):void
		{
			if (!_selected)
			{
				var tf:TextFormat = new TextFormat();
				tf.color = _textColour;
				tf.size = 14;
				tf.font = "Arial";
				_labelTxt.setTextFormat(tf, 0, _labelTxt.length);
				
			}
		}
		
		private function onClick(e:MouseEvent):void
		{
			_selected = true;
			dispatchEvent(new Event("itemSelected"));
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
			//super.boxHeight = n;
		}
		
		public override function set label(s:String):void
		{
			super.label = s;
			_labelTxt.text = _label;
			redraw();
		}
		
		public override function set enable(b:Boolean):void
		{
			super.enable = b;
		}
		
		public function set overColour(c:uint):void
		{
			_overColour = c;
		}
		
		public function set selected(s:Boolean):void
		{
			var tf:TextFormat = new TextFormat();
			
			if (s)
			{	
				tf.color = _accent;
				tf.size = 14;
				tf.font = "Arial";
				_labelTxt.setTextFormat(tf, 0, _labelTxt.length);
			}
			else
			{
				tf.color = _textColour;
				tf.size = 14;
				tf.font = "Arial";
				_labelTxt.setTextFormat(tf, 0, _labelTxt.length);
			}
			
			_selected = s;
		}
		
		public function set data(d:String):void
		{
			_data = d;
		}
		
		public function set index(i:int):void
		{
			_index = i;
		}
		
		public function set colour(c:uint):void
		{
			_colour = c;
			drawSwatch();
		}
		
		//-------------------------GETTERS--------------------------
		
		public override function get boxHeight():Number
		{
			return _boxHeight;
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function get data():String
		{
			return _data;
		}
		
		public function get index():int
		{
			return _index;
		}
		
		public function get colour():uint
		{
			return _colour;
		}
		
	}
	
}