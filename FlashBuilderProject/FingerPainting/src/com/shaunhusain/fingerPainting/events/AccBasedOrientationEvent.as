package com.shaunhusain.fingerPainting.events
{
	import flash.events.Event;
	
	/**
	 * Added a property to store the current linearRotation pre-computed so
	 * each handler doesn't have to compute it.
	 */
	public class AccBasedOrientationEvent extends Event
	{
		public var oldOrientation:String;
		public var newOrientation:String;
		public var directionOfChange:String;
		public function AccBasedOrientationEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, oldOrientation:String=null, newOrientation:String=null, directionOfChange:String=null)
		{
			super(type, bubbles, cancelable);
			this.oldOrientation = oldOrientation;
			this.newOrientation = newOrientation;
			this.directionOfChange = directionOfChange;
		}
	}
}