package com.shaunhusain.fingerPainting.tools 
{
	import flash.display.BitmapData;
	import flash.events.TouchEvent;

	public interface ITool
	{
		function takeAction(event:TouchEvent=null):void;
	}
}