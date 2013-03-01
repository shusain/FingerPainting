package com.shaunhusain.fingerPainting.model
{
	import com.shaunhusain.fingerPainting.tools.ITool;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;

	public class PaintModel extends EventDispatcher
	{
		//--------------------------------------------------------------------------------
		//				Variables
		//--------------------------------------------------------------------------------
		public var currentTool:ITool;
		
		public var currentColorBitmap:Bitmap;
		
		public var menuMoving:Boolean;
		public var toolbarMoving:Boolean;
		
		public function get dpiScale():Number
		{
			return Capabilities.screenDPI>320&&Capabilities.screenResolutionY<1000?.75:Capabilities.screenDPI/320;
		}
		
		//--------------------------------------------------------------------------------
		//				Constructor
		//--------------------------------------------------------------------------------
		public function PaintModel(se:SingletonEnforcer)
		{
		}
		
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
		private var _currentColor:uint = 0xFF00DDFF;
		public function set currentColor(value:uint):void
		{
			if(value == _currentColor)
				return;
			_currentColor = value;
			if(currentColorBitmap)
			{
				currentColorBitmap.bitmapData.fillRect(new Rectangle(20*dpiScale,20*dpiScale,42*dpiScale,42*dpiScale),_currentColor);
			}
			dispatchEvent(new Event("currentColorChanged"));
		}
		public function get currentColor():uint
		{
			return _currentColor;
		}
		
	}
}

internal class SingletonEnforcer{}