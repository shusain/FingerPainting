package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	public class FingerPainting extends Sprite
	{
		private var paintBrushButton:AccelerometerButton;
		private var paintBrushButton2:AccelerometerButton;
		
		private var menuButtons:Array;
		
		private var debugText:TextField;
		private var debugTextFormat:TextFormat;
		
		private var toolbar:Toolbar;
		
		public function FingerPainting()
		{
			super();
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			//setupDebugText();
			
			menuButtons = [new AccelerometerButton(),new AccelerometerButton(),new AccelerometerButton(),new AccelerometerButton(),new AccelerometerButton(),new AccelerometerButton(),new AccelerometerButton(),new AccelerometerButton()];
			
			toolbar = new Toolbar();
			toolbar.x = stage.stageWidth-50;
			toolbar.y = 20;
			addChild(toolbar);
			
			for( var i:int = 0; i <menuButtons.length; i++)
			{
				var ab:AccelerometerButton = menuButtons[i];
				ab.initialX = 50;
				ab.initialY = 100+i*120;
				toolbar.addChild(ab);
			}
			
		}
		
		
		private function setupDebugText():void
		{
			debugTextFormat = new TextFormat();
			debugTextFormat.size = 36;
			
			debugText = new TextField();
			debugText.autoSize = TextFieldAutoSize.LEFT;
			debugText.setTextFormat(debugTextFormat);
			addChild(debugText);
		}
	}
}