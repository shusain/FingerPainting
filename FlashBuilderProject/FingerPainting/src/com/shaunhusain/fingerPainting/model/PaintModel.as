package com.shaunhusain.fingerPainting.model
{
	import com.shaunhusain.fingerPainting.tools.ITool;
	
	import flash.display.BitmapData;

	public class PaintModel
	{
		public var bitmapData:BitmapData;
		public var currentTool:ITool;
		
		//Color Options
		public var currentColor:uint = 0xFF000000;
		
		//Brush Options
		public var brushCurrentWidth:Number = 20;
		public var brushObservePressure:Boolean;
		public var brushOpacity:Number;
		
		public var menuMoving:Boolean;
		
		private static var instance:PaintModel;
		
		public static function getInstance():PaintModel
		{
			if(!instance)
				instance = new PaintModel(new SingletonEnforcer);
			return instance;
		}
		
		public function PaintModel(se:SingletonEnforcer)
		{
		}
	}
}

internal class SingletonEnforcer{}