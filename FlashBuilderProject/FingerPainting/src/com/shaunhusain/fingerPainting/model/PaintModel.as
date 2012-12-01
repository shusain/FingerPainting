package com.shaunhusain.fingerPainting.model
{
	import com.shaunhusain.fingerPainting.tools.ITool;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	import flash.net.dns.AAAARecord;

	public class PaintModel extends EventDispatcher
	{
		public var bitmapData:BitmapData;
		public var currentTool:ITool;
		
		//Color Options
		private var _currentColor:uint = 0xFF000000;
		public var currentColorBitmap:Bitmap;
		
		//Brush Options
		public var brushCurrentWidth:Number = 20;
		public var brushObservePressure:Boolean;
		public var brushOpacity:Number;
		
		public var menuMoving:Boolean;
		public var toolbarMoving:Boolean;
		
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
		
		public function set currentColor(value:Number):void
		{
			_currentColor = value;
			if(currentColorBitmap)
			{
				currentColorBitmap.bitmapData.fillRect(new Rectangle(20,20,42,42),_currentColor);
			}
			dispatchEvent(new Event("currentColorChanged"));
		}
		public function get currentColor():Number
		{
			return _currentColor;
		}
	}
}

internal class SingletonEnforcer{}