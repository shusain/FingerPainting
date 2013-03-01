package com.shaunhusain.fingerPainting.managers
{
	import com.shaunhusain.fingerPainting.events.AccBasedOrientationEvent;
	
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
		//				Constants
		//--------------------------------------------------------------------------------
		public static const LANDSCAPE_LEFT:String = "landscapeLeft";
		public static const LANDSCAPE_RIGHT:String = "landscapeRight";
		public static const PORTRAIT_DEFAULT:String = "portraitDefault";
		public static const PORTRAIT_FLIPPED:String = "portraitFlipped";
		
		public static const TURNED_RIGHT:String = "turnedRight";
		public static const TURNED_LEFT:String = "turnedLeft";
		public static const FLIPPED:String = "flipped";
		
		//--------------------------------------------------------------------------------
		//				Variables
		//--------------------------------------------------------------------------------
		private var acc:Accelerometer;
		private var registeredStageListener:Boolean;
		private var previousOrientation:String=PORTRAIT_DEFAULT;
		private var degreeAllowance:Number = 20;
		private var previousAngle:Number=270;
		
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
		//				Singleton
		//--------------------------------------------------------------------------------
		private static var instance:AccelerometerManager;
		public static function getIntance():AccelerometerManager
		{
			if( instance == null ) instance = new AccelerometerManager( new SingletonEnforcer() );
			return instance;
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
		
		private var _currentOrientation:String = AccelerometerManager.PORTRAIT_DEFAULT;
		public function get currentOrientation():String
		{
			return _currentOrientation;
		}

		public function set currentOrientation(value:String):void
		{
			_currentOrientation = value;
		}

		
		//--------------------------------------------------------------------------------
		//				Handlers
		//--------------------------------------------------------------------------------	
		private function handleAccelerometerChange(event:AccelerometerEvent):void
		{
			if(Math.abs(event.accelerationZ)<.75)
			{
				var angle:Number = Math.atan2(event.accelerationY, event.accelerationX);
				var degrees:Number = angle*180/Math.PI+180;
				
				if(Math.abs(degrees - previousAngle)<degreeAllowance)
					return;
				
				previousAngle = degrees;
				
				var accEventExtra:AccBasedOrientationEvent = new AccBasedOrientationEvent(event.type,event.bubbles,event.cancelable);
				if(degrees>225&&degrees<315)
					currentOrientation = PORTRAIT_DEFAULT;
				else if(degrees>45&&degrees<135)
					currentOrientation = PORTRAIT_FLIPPED;
				else if(degrees>=135&&degrees<=225)
					currentOrientation = LANDSCAPE_LEFT;
				else if(degrees>=315||degrees<=45)
					currentOrientation = LANDSCAPE_RIGHT;
				
				if(currentOrientation == previousOrientation)
					return;
				
				accEventExtra.oldOrientation = previousOrientation;
				accEventExtra.newOrientation = currentOrientation;
				accEventExtra.directionOfChange = determineDirectionOfChange(previousOrientation,currentOrientation);
				
				previousOrientation = currentOrientation;
				
				dispatchEvent(accEventExtra);
			}
		}
		private function determineDirectionOfChange(oldOrientation:String, newOrientation:String):String
		{
			var turned:String;
			switch(oldOrientation)
			{
				case PORTRAIT_DEFAULT:
					switch(newOrientation)
					{
						case LANDSCAPE_LEFT:
							turned = TURNED_LEFT;
							break;
						case LANDSCAPE_RIGHT:
							turned = TURNED_RIGHT;
							break;
						case PORTRAIT_FLIPPED:
							turned = FLIPPED;
							break;
					}
				break;
				case LANDSCAPE_LEFT:
					switch(newOrientation)
					{
						case PORTRAIT_DEFAULT:
							turned = TURNED_RIGHT;
							break;
						case LANDSCAPE_RIGHT:
							turned = FLIPPED;
							break;
						case PORTRAIT_FLIPPED:
							turned = TURNED_LEFT;
							break;
					}
					break;
				case LANDSCAPE_RIGHT:
					switch(newOrientation)
					{
						case LANDSCAPE_LEFT:
							turned = FLIPPED;
							break;
						case PORTRAIT_DEFAULT:
							turned = TURNED_LEFT;
							break;
						case PORTRAIT_FLIPPED:
							turned = TURNED_RIGHT;
							break;
					}
					break;
				case PORTRAIT_FLIPPED:
					switch(newOrientation)
					{
						case LANDSCAPE_LEFT:
							turned = TURNED_RIGHT;
							break;
						case LANDSCAPE_RIGHT:
							turned = TURNED_LEFT;
							break;
						case PORTRAIT_DEFAULT:
							turned = FLIPPED;
							break;
					}
					break;
				
			}
			return turned;
		}
	}
}

internal class SingletonEnforcer {public function SingletonEnforcer(){}}