package com.nemenvisual.nicecomps
{
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import com.nemenvisual.nicecomps.events.AddEvent;
	import com.nemenvisual.nicecomps.IComponent;
	
	/**
	 * ...
	 * @author Ben Foster
	 */
	public class ComponentBase extends MovieClip implements IComponent
	{
		protected var _id:int;
		protected var _baseColour:uint;
		protected var _accent:uint;
		protected var _textColour:uint;
		protected var _boxWidth:Number;
		protected var _boxHeight:Number;
		protected var _label:String;
		protected var _enabled:Boolean;
		protected var _stage:Stage;
		
		public function ComponentBase(dispatch:Boolean = true):void
		{
			if (dispatch)
			{
				this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
			}
		}
		
		private function onAdded(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			stage.dispatchEvent(new AddEvent(AddEvent.COMP_ADDED, this));
		}
		
		protected function init():void
		{
			_id			= -1;
			_baseColour	= 0x333333;
			_accent 	= 0x9ADD43;
			_textColour	= 0xFFFFFF;
			_label		= "Label";
			_enabled	= true;
		}
		
		protected function redraw():void
		{
		}
		
		//-----------------------SETTERS--------------------------------
		
		public function set id(c:int):void
		{
			_id = c;
		}
		
		public function set baseColour(c:uint):void
		{
			_baseColour = c;
		}
		
		public function set accent(c:uint):void
		{
			_accent = c;
		}
		
		public function set textColour(c:uint):void
		{
			_textColour = c;
		}
		
		public function set boxWidth(n:Number):void
		{
			_boxWidth = n;
		}
		
		public function set boxHeight(n:Number):void
		{
			_boxHeight = n;
		}
		
		public function set label(s:String):void
		{
			_label = s;
		}
		
		public function set enable(b:Boolean):void
		{
			_enabled = b;
		}
		
		//-----------------------GETTERS--------------------------------
		
		public function get id():int
		{
			return _id;
		}
		
		public function get baseColour():uint
		{
			return _baseColour;
		}
		
		public function get accent():uint
		{
			return _accent;
		}
		
		public function get textColour():uint
		{
			return _textColour;
		}
		
		public function get boxWidth()	:Number
		{
			return _boxWidth;
		}
		
		public function get boxHeight():Number
		{
			return _boxHeight;
		}
		
		public function get label():String
		{
			return _label;
		}
		
		public function get enable():Boolean
		{
			return _enabled;
		}
		
	}
	
}