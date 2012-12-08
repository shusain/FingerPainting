package com.shaunhusain.fingerPainting.managers
{
	import flash.events.AccelerometerEvent;
	import flash.events.EventDispatcher;
	import flash.sensors.Accelerometer;

	public class AccelerometerManager extends EventDispatcher
	{
		private static var instance:AccelerometerManager;
		
		public static function getIntance():AccelerometerManager
		{
			if( instance == null ) instance = new AccelerometerManager( new SingletonEnforcer() );
			return instance;
		}
		
		/**
		 * Used to coordinate all the updates to the buttons without having multiple instances of accelerometer objects.
		 * 
		 * @param se Blocks creation of new managers instead use static method getInstance
		 */
		public function AccelerometerManager(se:SingletonEnforcer)
		{
			var acc:Accelerometer = new Accelerometer();
			acc.addEventListener(AccelerometerEvent.UPDATE, handleAccelerometerChange);
		}
		private function handleAccelerometerChange(event:AccelerometerEvent):void
		{
			dispatchEvent(event);
		}
	}
}

internal class SingletonEnforcer {public function SingletonEnforcer(){}}