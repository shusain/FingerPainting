package com.shaunhusain.fingerPainting.model
{
	import flash.display.DisplayObject;

	public class QueuedMessage
	{
		public var displayObject:DisplayObject;
		public var duration:Number;
		public var showDismiss:Boolean;
		public var displayText:String;
		
		public function QueuedMessage(duration:Number, displayText:String = null, displayObject:DisplayObject = null, showDismiss:Boolean = true)
		{
			this.displayObject = displayObject;
			this.duration = duration;
			this.displayText = displayText;
			this.showDismiss = showDismiss;
		}
	}
}