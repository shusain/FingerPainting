package com.nemenvisual.nicecomps
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	import com.nemenvisual.nicecomps.IComponent;
	
	/**
	 * ...
	 * @author Ben Foster
	 */
	public class Text extends ComponentBase
	{
		private var _textField:TextField;
		private var _tf:TextFormat;
		private var _accenttf:TextFormat;
		private var _useAccent:Boolean;
		private var _size:Number;
		private var _font:String;
		private var _align:String;
		private var _italic:Boolean;
		private var _bold:Boolean;
		private var _underline:Boolean;
		private var _indent:Number;
		
		public function Text(dispatch:Boolean = true):void
		{
			super(dispatch);
			init();
		}
		
		protected override function init():void
		{
			_useAccent = false;
			_size = 12;
			_font = "Arial";
			_align = "left";
			_italic = false;
			_bold = false;
			_underline = false;
			_indent = 0;
			
			_tf = new TextFormat();
			_tf.color = 0xFFFFFF;
			_tf.size = _size;
			_tf.font = _font;
			_tf.align = _align;
			_tf.bold = _bold;
			_tf.italic = _bold;
			_tf.underline = _underline;
			_tf.indent = _indent;
			
			_accenttf = new TextFormat();
			_accenttf.color = _accent;
			_accenttf.size = _size;
			_accenttf.font = _font;
			_accenttf.align = _align;
			_accenttf.bold = _bold;
			_accenttf.italic = _bold;
			_accenttf.underline = _underline;
			_accenttf.indent = _indent;
			
			_textField = new TextField();
			_textField.text = " ";
			_textField.multiline = true;
			_textField.wordWrap = true;
			_textField.defaultTextFormat = _tf;
			_textField.height = 14;
			_textField.width = 100;
			addChild(_textField);
		}
		
		protected override function redraw():void
		{
			super.redraw();
			
			if (_textField.text.length > 0)
			{
				if (_useAccent)
				{
					_textField.setTextFormat(_accenttf, 0, _textField.text.length);
				}
				else
				{
					_textField.setTextFormat(_tf, 0, _textField.text.length);
				}
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
		}
		
		public override function set accent(c:uint):void
		{
			super.accent = c;
			_accenttf.color = _accent;
			redraw();
		}
		
		public override function set textColour(c:uint):void
		{
			super.textColour = c;
			_tf.color = c;
			redraw();
		}
		
		public override function set boxWidth(n:Number):void
		{
			super.boxWidth = n;
			_textField.width = n;
		}
		
		public override function set boxHeight(n:Number):void
		{
			super.boxHeight = n;
			_textField.height = n;
		}
		
		public override function set label(s:String):void
		{
			super.label = s;
		}
		
		public override function set enable(b:Boolean):void
		{
			super.enable = b;
		}
		
		public function set useAccent(b:Boolean):void
		{
			_useAccent = b;
			redraw();
		}
		
		public function set size(n:Number):void
		{
			_size = n;
			_tf.size = n;
			_accenttf.size = n;
			_textField.height = _textField.textHeight + 2;
			redraw();
		}
		
		public function set font(n:String):void
		{
			_font = n;
			_tf.font = n;
			_accenttf.font = n;
			redraw();
		}
		
		public function set text(s:String):void
		{
			_textField.text = s;
			redraw();
		}
		
		public function set align(s:String):void
		{
			_align = s;
			_tf.align = s;
			_accenttf.align = s;
			redraw();
		}
		
		public function set bold(s:Boolean):void
		{
			_bold = s;
			_tf.bold = s;
			_accenttf.bold = s;
			redraw();
		}
		
		public function set italic(s:Boolean):void
		{
			_italic = s;
			_tf.italic = s;
			_accenttf.italic = s;
			redraw();
		}
		
		public function set underline(s:Boolean):void
		{
			_underline = s;
			_tf.underline = s;
			_accenttf.underline = s;
			redraw();
		}
		
		public function set multiline(s:Boolean):void
		{
			_textField.multiline = s;
		}
		
		public function set selectable(s:Boolean):void
		{
			_textField.selectable = s;
		}
		
		/////////----------------GETTERS----------------------
		
		public function get textField():TextField
		{
			return _textField;
		}
		
		public function get text():String
		{
			return _textField.text;
		}
	}
	
}