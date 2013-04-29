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
	public class CheckListItem extends ComponentBase
	{
		private var _data:String;
		//private var _labelTxt:TextField;
		private var _background:Shape;
		//private var _tf:TextFormat;
		private var _overColour:uint;
		private var _bgOverColour:uint;
		private var _selected:Boolean;
		private var _index:int;
		private var _checkbox:Checkbox;
		
		public function CheckListItem(dispatch:Boolean = true):void
		{
			super(dispatch);
			init();
		}
		
		protected override function init():void
		{
			super.init();
			
			_selected 			= false;
			
			_background 		= new Shape();
			
			_bgOverColour 		= 0xFFFFFF;
			_textColour			= 0x000000;
			_label 				= "New Button";
			_boxWidth 			= 100;
			_boxHeight			= 22;
			
			_checkbox = new Checkbox(false);
			_checkbox.label = "label";
			_checkbox.x = 2;
			_checkbox.y = 2;
			_checkbox.boxWidth = 18;
			_checkbox.boxHeight = 18;
			_checkbox.textColour = _textColour;
			_checkbox.baseColour = 0xCCCCCC;
			
			this.addChild(_background);
			this.addChild(_checkbox);
			
			_checkbox.addEventListener("onChange", onClick);
			this.addEventListener(MouseEvent.MOUSE_OVER, onOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, onOut);
			
			redraw();
		}
		
		protected override function redraw():void
		{
			super.redraw();
			
			_background.graphics.clear();
			_background.graphics.beginFill(_bgOverColour, 1);
			_background.graphics.drawRect(0, 0, _boxWidth, _boxHeight);
			_background.graphics.endFill();
		}
		
		private function onOver(e:MouseEvent):void
		{
			_checkbox.onOver(e);
		}
		
		private function onOut(e:MouseEvent):void
		{
			_checkbox.onOut(e);
		}
		
		private function onClick(e:Event):void
		{
			_selected = e.currentTarget.selected;
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
			_checkbox.accent = c;
		}
		
		public override function set textColour(c:uint):void
		{
			super.textColour = c;
			_checkbox.textColour = _textColour;
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
			_checkbox.label = _label;
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
			_selected = s;
			_checkbox.selected = s;
			//dispatchEvent(new Event("itemSelected"));
		}
		
		public function set data(d:String):void
		{
			_data = d;
		}
		
		public function set index(i:int):void
		{
			_index = i;
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
		
	}
	
}