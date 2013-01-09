package com.shaunhusain.fingerPainting.model
{
	import com.shaunhusain.fingerPainting.tools.ITool;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;

	public class PaintModel extends EventDispatcher
	{
		//--------------------------------------------------------------------------------
		//				Variables
		//--------------------------------------------------------------------------------
		public var currentDrawingOverlay:Sprite;
		public var currentTool:ITool;
		
		public var currentColorBitmap:Bitmap;
		
		//Brush Options
		public var brushCurrentWidth:Number = 20;
		public var brushObservePressure:Boolean;
		public var brushOpacity:Number=1;
		
		public var menuMoving:Boolean;
		public var toolbarMoving:Boolean;
		
		public var isPressureSensitive:Boolean=true;
		
		//--------------------------------------------------------------------------------
		//				Constructor
		//--------------------------------------------------------------------------------
		public function PaintModel(se:SingletonEnforcer){}
		
		//--------------------------------------------------------------------------------
		//				Singleton
		//--------------------------------------------------------------------------------
		private static var instance:PaintModel;
		public static function getInstance():PaintModel
		{
			if(!instance)
				instance = new PaintModel(new SingletonEnforcer);
			return instance;
		}
		
		//--------------------------------------------------------------------------------
		//				Properties
		//--------------------------------------------------------------------------------
		private var _currentColor:uint = 0xFF000000;
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