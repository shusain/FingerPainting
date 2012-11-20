package 
{
	import com.shaunhusain.mobileUIControls.AccelerometerButton;
	
	import flash.display.Bitmap;
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
		[Embed(source="images/brushIcon.png")]
		private var _brushIcon:Class;
		private var _brushIconBmp:Bitmap = new _brushIcon();
		
		[Embed(source="images/eraserIcon.png")]
		private var _eraserIcon:Class;
		private var _eraserIconBmp:Bitmap = new _eraserIcon();
		
		[Embed(source="images/bucketIcon.png")]
		private var _bucketIcon:Class;
		private var _bucketIconBmp:Bitmap = new _bucketIcon();
		
		[Embed(source="images/undoIcon.png")]
		private var _undoIcon:Class;
		private var _undoIconBmp:Bitmap = new _undoIcon();
		
		[Embed(source="images/shapesIcon.png")]
		private var _shapesIcon:Class;
		private var _shapesIconBmp:Bitmap = new _shapesIcon();
		
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
			
			menuButtons = 
						[
							new AccelerometerButton(_brushIconBmp),
							new AccelerometerButton(_eraserIconBmp),
							new AccelerometerButton(_bucketIconBmp),
							new AccelerometerButton(_shapesIconBmp),
							new AccelerometerButton(_undoIconBmp),
							new AccelerometerButton(),
							new AccelerometerButton(),
							new AccelerometerButton()
						];
			
			toolbar = new Toolbar();
			toolbar.x = stage.stageWidth-100;
			toolbar.y = 20;
			addChild(toolbar);
			
			for( var i:int = 0; i <menuButtons.length; i++)
			{
				var ab:AccelerometerButton = menuButtons[i];
				ab.x = 140;
				ab.y = 100+i*120;
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