package com.nemenvisual.nicecomps
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * ...
	 * @author Ben Foster
	 */
	public class RadioGroup 
	{
		private var _name:String;
		private var _group:Vector.<RadioButton>;
		private var _selected:RadioButton;
		private var _eventDispatcher:EventDispatcher;
		
		public function RadioGroup():void
		{
			_group = new Vector.<RadioButton>();
			_eventDispatcher = new EventDispatcher();
			_name = "radioGroup1";
		}
		
		public function addRadio(rb:RadioButton):void
		{
			_group.push(rb);
			rb.addEventListener(Event.CHANGE, onSelect);
		}
		
		private function onSelect(e:Event):void
		{
			_selected = e.target as RadioButton;
			
			for (var i:int = 0; i < _group.length; i++)
			{
				if (_group[i] != e.target)
				{
					_group[i].selected = false;
				}
			}
			
			_eventDispatcher.dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function set name(n:String):void
		{
			_name = n;
		}
		
		public function get eventDispatcher():EventDispatcher
		{
			return _eventDispatcher;
		}
		
		public function get selectedItem():RadioButton
		{
			return _selected;
		}
		
		public function get name():String
		{
			return _name;
		}
	}
	
}