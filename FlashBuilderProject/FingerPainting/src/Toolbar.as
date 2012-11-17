package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TouchEvent;
	
	public class Toolbar extends Sprite
	{
		[Embed(source="images/toolbarBackground.png")]
		private var toolbarBmpClass:Class;
		private var toolbarBmp:Bitmap = new toolbarBmpClass();
		private var isOpen:Boolean;
		
		public function Toolbar()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
			
			addEventListener(TouchEvent.TOUCH_TAP, handleTapped);
		}
		
		private function handleAddedToStage(event:Event):void
		{
			toolbarBmp.height = stage.stageHeight - y;
			toolbarBmp.scaleX = toolbarBmp.scaleY;
			addChild(toolbarBmp);
		}
		
		private function handleTapped(event:TouchEvent):void
		{
			if(isOpen)
			{
				x = stage.stageWidth - 50;
			}
			else
				x = stage.stageWidth - 175;
			
			isOpen = !isOpen;
		}
	}
}