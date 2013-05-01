package com.nemenvisual.nicecomps
{
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import com.nemenvisual.nicecomps.IComponent;
	import flash.ui.Keyboard;
	import flash.text.TextFieldType;
	import flash.events.TextEvent;
	
	/**
	 * ...
	 * @author Ben Foster
	 */
	public class InputBox extends ComponentBase
	{
		private var _inputTxt:TextField;
		private var _inputPromptTF:TextFormat;
		private var _inputTF:TextFormat;
		private var _prompt:String;
		private var _password:Boolean;
		private var _multiline:Boolean;
		private var _maxLines:Number;
		
		public function InputBox(dispatch:Boolean = true):void
		{
			super(dispatch);
			init();
		}
		
		protected override function init():void
		{
			_boxWidth 	= 275;
			_boxHeight 	= 20;
			_enabled	= true;
			_password	= false;
			_multiline	= false;
			_maxLines 	= 1;
			
			_inputTF 				= new TextFormat();
			_inputTF.font 			= "Arial";
			_inputTF.color 			= 0x000000;
			_inputTF.size 			= 12;
			_inputTF.italic 		= false;
			_inputTF.leftMargin 	= 2;
			
			_inputPromptTF 				= new TextFormat();
			_inputPromptTF.font 		= "Arial";
			_inputPromptTF.color 		= 0xCCCCCC;
			_inputPromptTF.size 		= 12;
			_inputPromptTF.italic 		= true;
			_inputPromptTF.leftMargin 	= 2;
			
			_prompt = "search";
			
			_inputTxt 						= new TextField();
			_inputTxt.type 					= TextFieldType.INPUT;
			_inputTxt.defaultTextFormat 	= _inputPromptTF;
			_inputTxt.height 				= 20;
			_inputTxt.width 				= _boxWidth;
			_inputTxt.text 					= _prompt;
			
			_inputTxt.addEventListener(Event.CHANGE, onTextChange);
			
			addChild(_inputTxt);
			
			redraw();
			able();
		}
		
		protected override function redraw():void
		{
			if (!_multiline)
			{
				graphics.clear();
				graphics.beginFill(0xFFFFFF, 1);
				graphics.drawRect(0, 0, _boxWidth, _boxHeight);
				graphics.endFill();
			}
			else
			{
				_boxHeight = _inputTxt.numLines * _inputTxt.getLineMetrics(0).height + 5;
				graphics.clear();
				graphics.beginFill(0xFFFFFF, 1);
				graphics.drawRect(0, 0, _boxWidth,_boxHeight);
				graphics.endFill();
			}
		}
		
		private function onTextChange(e:Event):void
		{
			dispatchEvent(new Event("textChanged"));
		}
		
		private function able():void
		{
			if (_enabled)
			{
				_inputTxt.addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
				_inputTxt.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
				_inputTxt.addEventListener(KeyboardEvent.KEY_UP, onEnter);
				_inputTxt.addEventListener(KeyboardEvent.KEY_DOWN, onKDown);
				//_inputTxt.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, onDragIn);
				//_inputTxt.addEventListener(NativeDragEvent.NATIVE_DRAG_EXIT, onDragExit);
				//_inputTxt.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP, onDragDrop);
				_inputTxt.selectable = true;
				this.alpha = 1;
			}
			else
			{
				_inputTxt.removeEventListener(FocusEvent.FOCUS_IN, onFocusIn);
				_inputTxt.removeEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
				_inputTxt.removeEventListener(KeyboardEvent.KEY_UP, onEnter);
				_inputTxt.removeEventListener(KeyboardEvent.KEY_DOWN, onKDown);
				//_inputTxt.removeEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, onDragIn);
				//_inputTxt.removeEventListener(NativeDragEvent.NATIVE_DRAG_EXIT, onDragExit);
				//_inputTxt.removeEventListener(NativeDragEvent.NATIVE_DRAG_DROP, onDragDrop);
				_inputTxt.selectable = false;
				this.alpha = 0.7;
			}
		}
		
		private function onEnter(e:KeyboardEvent):void
		{
			if (!_multiline)
			{
				switch (e.keyCode)
				{
					case Keyboard.ENTER :
						dispatchEvent(new Event("submit"));
					break;
				}
			}
			else
			{
				_inputTxt.scrollV = 0;
				_inputTxt.height = _inputTxt.textHeight + 5;
				
				redraw();
				
				dispatchEvent(new Event("textExpand"));
			}
		}
		
		private function onKDown(e:KeyboardEvent):void
		{
			if (_multiline)
			{
				_inputTxt.scrollV = 0;
				_inputTxt.height = _inputTxt.textHeight+5;
				
				redraw();
			}
		}
		
		private function onChange(e:TextEvent):void
		{
			if (_multiline)
			{
				_inputTxt.scrollV = 0;
				_inputTxt.height = _inputTxt.textHeight+5;
				
				redraw();
			}
		}
		
		private function onFocusIn(e:FocusEvent):void
		{
			if (_inputTxt.text == _prompt)
			{
				_inputTxt.displayAsPassword = _password;
				_inputTxt.text = "";
				_inputTxt.defaultTextFormat = _inputTF;
				_inputTxt.scrollH = 0;
			}
		}
		
		private function onFocusOut(e:FocusEvent):void
		{
			if (_inputTxt.text == "")
			{
				_inputTxt.displayAsPassword = false;
				_inputTxt.defaultTextFormat = _inputPromptTF;
				_inputTxt.text = _prompt;
				_inputTxt.scrollH = 0;
				dispatchEvent(new Event("cleared"));
			}
		}
		
		public function unFocus():void
		{
			_inputTxt.defaultTextFormat = _inputPromptTF;
			_inputTxt.text = _prompt;
			_inputTxt.scrollH = 0;
		}
		
		public function reset():void
		{
			_inputTxt.scrollV = 0;
			_inputTxt.height = _inputTxt.textHeight + 5;
			redraw();
		}
		
		/*private function onDragIn(e:NativeDragEvent):void
		{
			onFocusIn(null);
		}
		
		private function onDragExit(e:NativeDragEvent):void
		{
			onFocusOut(null);
		}
		
		private function onDragDrop(e:NativeDragEvent):void
		{
			onFocusIn(null);
		}*/
		
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
		}
		
		public override function set textColour(c:uint):void
		{
			super.textColour = c;
		}
		
		public override function set boxWidth(n:Number):void
		{
			super.boxWidth = n;
			
			_inputTxt.width = n;
			redraw();
		}
		
		public override function set boxHeight(n:Number):void
		{
			super.boxHeight = n;
			
			_inputTxt.y = (n - 12) / -2;
			redraw();
		}
		
		public override function set label(s:String):void
		{
			super.label = s;
		}
		
		public override function set enable(b:Boolean):void
		{
			super.enable = b;
			able();
		}
		
		public function set promt(s:String):void
		{
			_prompt = s;
			_inputTxt.defaultTextFormat = _inputPromptTF;
			_inputTxt.text = _prompt;
		}
		
		public function set text(s:String):void
		{
			_inputTxt.defaultTextFormat = _inputTF;
			_inputTxt.text = s;
			
			if (s == "")
			{
				onFocusOut(null);
			}
		}
		
		public function set password(b:Boolean):void
		{
			_password = b;
		}
		
		public function set multiline(b:Boolean):void
		{
			_multiline = b;
			_inputTxt.multiline = b;
			_inputTxt.wordWrap = b;
			
		}
		
		public function set maxLines(n:Number):void
		{
			_maxLines = n;
		}
		
		//---------------GETTERS-------------------------------------
		
		public function get absoluteText():String
		{
			return _inputTxt.text;
		}
		
		public function get text():String
		{
			if (_inputTxt.text != _prompt)
			{
				return _inputTxt.text;
			}
			else
			{
				return "";
			}
		}
		
		public function get textField():TextField
		{
			return _inputTxt;
		}
		
		public function get multiline():Boolean
		{
			return _multiline;
		}
	}
	
}