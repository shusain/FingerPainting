package com.shaunhusain.fingerPainting.managers
{
	import com.shaunhusain.fingerPainting.events.AccEventExtra;
	
	import flash.events.AccelerometerEvent;
	import flash.events.EventDispatcher;
	import flash.sensors.Accelerometer;
	
	/**
	 * Centralizes the handling of accelerometer changes, limits events
	 * dispatched to avoid extraneous jiggle/dithering.
	 */
	public class AccelerometerManager extends EventDispatcher
	{
		//--------------------------------------------------------------------------------
		//				Variables
		//--------------------------------------------------------------------------------
		private var acc:Accelerometer;
		
		//--------------------------------------------------------------------------------
		//				Constructor
		//--------------------------------------------------------------------------------
		/**
		 * Used to coordinate all the updates to the buttons without having
		 * multiple instances of accelerometer objects.  Creates the handle
		 * to the Accelerometer.
		 * 
		 * @param se Blocks creation of new managers instead use static method getInstance
		 */
		public function AccelerometerManager(se:SingletonEnforcer)
		{
			acc = new Accelerometer();
		}
		
		//--------------------------------------------------------------------------------
		//				Properties
		//--------------------------------------------------------------------------------
		
		private var _currentlyActive:Boolean;
		/**
		 * Allows the manager to be turned on or off from the outside.
		 */
		public function set currentlyActive(value:Boolean):void{
			if(_currentlyActive == value)
				return;
			_currentlyActive = value;
			
			if(_currentlyActive)
				acc.addEventListener(AccelerometerEvent.UPDATE, handleAccelerometerChange);
			else
				acc.removeEventListener(AccelerometerEvent.UPDATE, handleAccelerometerChange);
		}
		
		//--------------------------------------------------------------------------------
		//				Singleton
		//--------------------------------------------------------------------------------
		private static var instance:AccelerometerManager;
		public static function getIntance():AccelerometerManager
		{
			if( instance == null ) instance = new AccelerometerManager( new SingletonEnforcer() );
			return instance;
		}
		
		//--------------------------------------------------------------------------------
		//				Handlers
		//--------------------------------------------------------------------------------
		private function handleAccelerometerChange(event:AccelerometerEvent):void
		{
			if(Math.abs(event.accelerationZ)<.9)
			{
				var angle:Number = Math.atan2(event.accelerationY, event.accelerationX);
				angle-=Math.PI/2;
				angle = -angle;
				
				var accEventExtra:AccEventExtra = new AccEventExtra(event.type,event.bubbles,event.cancelable,event.timestamp,event.accelerationX,event.accelerationY,event.accelerationZ, angle);
				
				dispatchEvent(accEventExtra);
			}
		}
	}
}

internal class SingletonEnforcer {public function SingletonEnforcer(){}}