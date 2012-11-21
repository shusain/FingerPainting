package 
{
	import com.shaunhusain.mobileUIControls.RotatingIconButton;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.TouchEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.utils.ByteArray;
	
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
		
		[Embed(source="images/redoIcon.png")]
		private var _redoIcon:Class;
		private var _redoIconBmp:Bitmap = new _redoIcon();
		
		[Embed(source="images/shapesIcon.png")]
		private var _shapesIcon:Class;
		private var _shapesIconBmp:Bitmap = new _shapesIcon();
		
		[Embed(source="images/pipetIcon.png")]
		private var _pipetIcon:Class;
		private var _pipetIconBmp:Bitmap = new _pipetIcon();
		
		[Embed(source="images/colorSpectrumIcon.png")]
		private var _colorSpectrumIcon:Class;
		private var _colorSpectrumBmp:Bitmap = new _colorSpectrumIcon();
		
		[Embed(source="images/blankDocIcon.png")]
		private var _blankDocIcon:Class;
		private var _blankDocBmp:Bitmap = new _blankDocIcon();
		
		private var menuButtons:Array;
		
		private var debugText:TextField;
		private var debugTextFormat:TextFormat;
		
		private var toolbar:Toolbar;
		
		private var bitmapCanvas:Bitmap;
		
		private var touchSamples:ByteArray;
		
		private var currentTool:ITool;
		
		private var currentColor:uint = 0xFF000000;
		
		public function FingerPainting()
		{
			super();
			
			touchSamples = new ByteArray();
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			bitmapCanvas = new Bitmap(new BitmapData(stage.fullScreenWidth,stage.fullScreenHeight));
			bitmapCanvas.smoothing = true;
			stage.addEventListener(TouchEvent.TOUCH_MOVE, touchMoveHandler);
			stage.addEventListener(TouchEvent.TOUCH_TAP, touchMoveHandler);
			addChild(bitmapCanvas);
			
			
			menuButtons = 
						[
							new RotatingIconButton(_brushIconBmp, new BrushTool(), false, true, true),
							new RotatingIconButton(_eraserIconBmp, new EraserTool()),
							new RotatingIconButton(_bucketIconBmp, new BucketTool()),
							new RotatingIconButton(_shapesIconBmp, new ShapeTool(),false,false,true),
							new RotatingIconButton(_undoIconBmp, "undo", true),
							new RotatingIconButton(_redoIconBmp, "redo", true),
							new RotatingIconButton(_pipetIconBmp, "pipet"),
							new RotatingIconButton(_colorSpectrumBmp, "colorSpectrum"),
							new RotatingIconButton(_blankDocBmp, new BlankTool(), true)
						];
			
			toolbar = new Toolbar();
			toolbar.x = stage.stageWidth-85;
			toolbar.y = 20;
			addChild(toolbar);
			
			for( var i:int = 0; i <menuButtons.length; i++)
			{
				var ab:RotatingIconButton = menuButtons[i];
				ab.addEventListener("buttonClicked", deselectAllOthers);
				ab.addEventListener("instantaneousButtonClicked", instantaneousActionHandler);
				if(ab.useSecondaryBackground)
					ab.x=85;
				else
					ab.x = 140;
				ab.y = 100+i*120;
				toolbar.addChild(ab);
			}
			
			currentTool = menuButtons[0].data;
			
		}
		
		private function deselectAllOthers(event:Event):void
		{
			currentTool = event.target.data as ITool;
			for( var i:int = 0; i <menuButtons.length; i++)
			{
				var ab:RotatingIconButton = menuButtons[i];
				if(event.target!=ab)
					ab.isSelected = false;
			}
		}
		
		private function instantaneousActionHandler(event:Event):void
		{
			var tempTool:ITool = event.target.data as ITool;
			tempTool.takeAction(null,bitmapCanvas.bitmapData,currentColor);
		}
		
		private function touchMoveHandler(event:TouchEvent):void
		{
			currentTool.takeAction(event,bitmapCanvas.bitmapData,currentColor);
		}
	}
}