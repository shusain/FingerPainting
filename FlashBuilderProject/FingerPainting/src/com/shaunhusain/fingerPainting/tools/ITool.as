package com.shaunhusain.fingerPainting.tools 
{
	import flash.events.TouchEvent;

	public interface ITool
	{
		function takeAction(event:TouchEvent=null):void;
		function toString():String;
	}
}