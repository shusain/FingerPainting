package com.shaunhusain.fingerPainting.managers
{
	import flash.display.BitmapData;
	
	import org.bytearray.gif.encoder.GIFEncoder;

	public class GIFAnimationManager
	{
		private static var instance:GIFAnimationManager;
		private var gifEncoder:GIFEncoder;
		public function GIFAnimationManager(se:SingletonEnforcer)
		{
			gifEncoder = new GIFEncoder();
			gifEncoder.start();
			gifEncoder.setFrameRate(3);
		}
		
		public static function getIntance():GIFAnimationManager
		{
			if( instance == null ) instance = new GIFAnimationManager( new SingletonEnforcer() );
			return instance;
		}
		
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