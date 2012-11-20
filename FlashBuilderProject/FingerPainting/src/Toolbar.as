package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TouchEvent;
	import flash.geom.Rectangle;
	
	public class Toolbar extends Sprite
	{
		[Embed(source="images/toolbarBackground.png")]
		private var toolbarBmpClass:Class;
		private var toolbarBmp:Bitmap = new toolbarBmpClass();
		private var scaledBitmap:ScaleBitmap = new ScaleBitmap(toolbarBmp.bitmapData);
		private var isOpen:Boolean;
		
		public function Toolbar()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
			
			addEventListener(TouchEvent.TOUCH_TAP, handleTapped);
		}
		
		private function handleAddedToStage(event:Event):void
		{
			scaledBitmap.scale9Grid = new Rectangle(118, 100, 271, 2286);
			scaledBitmap.height = stage.fullScreenHeight - y;
			//toolbarBmp.width = toolbarBmp.scaleY*toolbarBmp.width;
			addChild(scaledBitmap);
		}
		
		private function handleTapped(event:TouchEvent):void
		{
			if(isOpen)
			{
				x = stage.fullScreenWidth - 100;
			}
			else
				x = stage.fullScreenWidth - 270;
			
			isOpen = !isOpen;
		}
	}
}