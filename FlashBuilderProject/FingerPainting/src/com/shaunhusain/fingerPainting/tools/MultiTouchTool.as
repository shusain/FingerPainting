package com.shaunhusain.fingerPainting.tools
{
	import flash.display.Stage;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	
	public class MultiTouchTool extends ToolBase implements ITool
	{
		protected var pointsTracked:Number = 0;
		protected var ptsTracked:Object;
		protected var eventIds:Array;
		
		public function MultiTouchTool(stage:Stage)
		{
			super(stage);
			eventIds = [];
			ptsTracked = {};
		}
		
		public function takeAction(event:TouchEvent=null):void
		{
			switch(event.type)
			{
				case TouchEvent.TOUCH_BEGIN:
					eventIds.unshift(event.touchPointID);
					ptsTracked[event.touchPointID] =  new Point(event.stageX, event.stageY);
					pointsTracked++;
					if(pointsTracked>1)
						secondFingerDown();
					break;
				
				case TouchEvent.TOUCH_MOVE:
					switch(pointsTracked)
					{
						case 1:
							oneFingerMoving(event);
							break;
						case 2:
							twoFingersMoving(event);
							break;
						
					}
					ptsTracked[event.touchPointID] =  new Point(event.stageX, event.stageY);
					break;
				
				case TouchEvent.TOUCH_END:
				case TouchEvent.TOUCH_ROLL_OUT:
					switch(pointsTracked)
					{
						case 1:
							oneFingerEnd();
							break;
						case 2:
							twoFingerEnd();
							break;
					}
					
					
					ptsTracked[event.touchPointID] = null;
					pointsTracked--;
					if(pointsTracked<0)
						pointsTracked = 0;
					break;
			}
		}
		
		protected function oneFingerEnd():void
		{
			trace("default handler for one finger end, not overridden");
		}
		protected function twoFingerEnd():void
		{
			trace("default handler for two finger end, not overridden");
		}
		protected function oneFingerMoving(event:TouchEvent):void
		{
			trace("default handler for one finger moving, not overridden");
		}
		protected function twoFingersMoving(event:TouchEvent):void
		{
			trace("default handler for two fingers moving, not overridden");
		}
		protected function secondFingerDown():void
		{
			trace("default handler for second finger down, not overridden");
		}
		
		public function toString():String
		{
			return "Multi-Touch tool";
		}
	}
}