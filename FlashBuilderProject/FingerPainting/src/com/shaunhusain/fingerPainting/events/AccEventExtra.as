package com.shaunhusain.fingerPainting.events
{
	import flash.events.AccelerometerEvent;
	
	/**
	 * Added a property to store the current linearRotation pre-computed so
	 * each handler doesn't have to compute it.
	 */
	public class AccEventExtra extends AccelerometerEvent
	{
		
		public var linearRotation:Number;
		
		public function AccEventExtra(type:String, bubbles:Boolean=false, cancelable:Boolean=false,
									  timestamp:Number=0, accelerationX:Number=0,accelerationY:Number=0, accelerationZ:Number=0,
									  linearRotation:Number=0)
		{
			super(type, bubbles, cancelable, timestamp, accelerationX, accelerationY, accelerationZ);
			this.linearRotation = linearRotation;
		}
	}
}