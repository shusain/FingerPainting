package com.shaunhusain.fingerPainting.managers
{
	import flash.display.BitmapData;
	
	import org.bytearray.gif.encoder.GIFEncoder;
	
	/**
	 * Setup to offload the work of putting together GIFs (not yet in use).
	 */
	public class GIFAnimationManager
	{
		//--------------------------------------------------------------------------------
		//				Variables
		//--------------------------------------------------------------------------------
		private var gifEncoder:GIFEncoder;
		
		//--------------------------------------------------------------------------------
		//				Constructor
		//--------------------------------------------------------------------------------
		public function GIFAnimationManager(se:SingletonEnforcer)
		{
			gifEncoder = new GIFEncoder();
			gifEncoder.start();
			gifEncoder.setFrameRate(3);
		}
		
		//--------------------------------------------------------------------------------
		//				Singleton
		//--------------------------------------------------------------------------------
		private static var instance:GIFAnimationManager;
		public static function getIntance():GIFAnimationManager
		{
			if( instance == null ) instance = new GIFAnimationManager( new SingletonEnforcer() );
			return instance;
		}
		
		//--------------------------------------------------------------------------------
		//				Public Methods
		//--------------------------------------------------------------------------------
		public function addFrame(bd:BitmapData):void
		{
			gifEncoder.addFrame(bd);
		}
		public function finish():void
		{
			gifEncoder.finish();
		}
	}
}

internal class SingletonEnforcer {public function SingletonEnforcer(){}}