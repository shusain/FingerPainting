package com.shaunhusain.fingerPainting.view
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * Basically acts like a Box from the Flex framework with one caveat.
	 * Since there is no layout manager or component lifecycle this class deals
	 * with running the layout after children are added to it.
	 */
	public class Box extends Sprite
	{
		//--------------------------------------------------------------------------------
		//				Constructor
		//--------------------------------------------------------------------------------
		public function Box()
		{
			super();
			
			addEventListener(Event.ADDED, elementsModifiedHandler);
			addEventListener(Event.REMOVED, elementsModifiedHandler);
		}
		
		//--------------------------------------------------------------------------------
		//				Properties
		//--------------------------------------------------------------------------------
		private var _direction:String = "vertical";
		
		public function get direction():String
		{
			return _direction;
		}
		
		public function set direction(value:String):void
		{
			if(_direction==value)
				return;
			_direction = value;
			elementsModifiedHandler();
		}
		
		private var _gap:Number = 0;
		
		public function get gap():Number
		{
			return _gap;
		}
		
		public function set gap(value:Number):void
		{
			if(_gap==value)
				return;
			_gap = value;
			elementsModifiedHandler();
		}
		
		private var _startPadding:Number = 0;

		public function get startPadding():Number
		{
			return _startPadding;
		}

		public function set startPadding(value:Number):void
		{
			if(_startPadding==value)
				return;
			_startPadding = value;
			elementsModifiedHandler();
		}

		
		//--------------------------------------------------------------------------------
		//				Handlers
		//--------------------------------------------------------------------------------
		protected function elementsModifiedHandler(event:Event=null):void
		{
			//Fix the layout
			var property1:String = "y";
			var property2:String = "height";
			
			if(direction != "vertical")
			{
				property1 = "x";
				property2 = "width";
			}
			
			var curOffset:Number = startPadding;
			for(var i:int = 0; i < numChildren; i++)
			{
				var curChild:DisplayObject = getChildAt(i);
				curChild[property1] = curOffset;
				curOffset+=curChild[property2]+gap;
			}
		}
		
	}
}