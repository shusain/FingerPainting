package 
{
	import com.shaunhusain.fingerPainting.model.PaintModel;
	import com.shaunhusain.fingerPainting.tools.BlankTool;
	import com.shaunhusain.fingerPainting.tools.BrushTool;
	import com.shaunhusain.fingerPainting.tools.BucketTool;
	import com.shaunhusain.fingerPainting.tools.EraserTool;
	import com.shaunhusain.fingerPainting.tools.ITool;
	import com.shaunhusain.fingerPainting.tools.ShapeTool;
	import com.shaunhusain.fingerPainting.view.Toolbar;
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
		
		private var debugText:TextField;
		private var debugTextFormat:TextFormat;
		
		private var toolbar:Toolbar;
		
		private var bitmapCanvas:Bitmap;
		
		private var model:PaintModel = PaintModel.getInstance();
		
		
		public function FingerPainting()
		{
			super();
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			model.bitmapData = new BitmapData(stage.fullScreenWidth,stage.fullScreenHeight,true,0xFFFFFFFF);
			
			bitmapCanvas = new Bitmap(model.bitmapData);
			bitmapCanvas.smoothing = true;
			stage.addEventListener(TouchEvent.TOUCH_MOVE, touchMoveHandler);
			stage.addEventListener(TouchEvent.TOUCH_TAP, touchMoveHandler);
			addChild(bitmapCanvas);
			
			toolbar = new Toolbar();
			toolbar.x = stage.stageWidth-85;
			toolbar.y = 20;
			addChild(toolbar);
		}
		
		private function touchMoveHandler(event:TouchEvent):void
		{
			if(!model.menuMoving)
				model.currentTool.takeAction(event);
		}
		
	}
}