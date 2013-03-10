package 
{
	import com.shaunhusain.fingerPainting.managers.UndoManager;
	import com.shaunhusain.fingerPainting.model.PaintModel;
	import com.shaunhusain.fingerPainting.model.QueuedMessage;
	import com.shaunhusain.fingerPainting.view.BitmapReference;
	import com.shaunhusain.fingerPainting.view.LoadingDialog;
	import com.shaunhusain.fingerPainting.view.Toolbar;
	import com.shaunhusain.fingerPainting.view.managers.HelpManager;
	import com.shaunhusain.fingerPainting.view.managers.LayerManager;
	import com.shaunhusain.fingerPainting.view.managers.SecondaryPanelManager;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.TimerEvent;
	import flash.events.TouchEvent;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.utils.Timer;
	
	/**
	 * This is the main application file for the FingerPainting app.  This is
	 * the file that creates the toolbar and the layer management/display and
	 * other components of the application.
	 */
	[SWF(frameRate="40")]
	public class FingerPainting extends Sprite
	{
		public static const TOOLBAR_BUTTON_OFFSET_FROM_RIGHT:Number = 180;
		
		public static const TOOLBAR_OFFSET_FROM_RIGHT:Number = 180;
		public static const TOOLBAR_OFFSET_FROM_RIGHT_OPEN:Number = 12;
		public static const TOOLBAR_OFFSET_FROM_TOP:Number = 20;
		
		private var model:PaintModel = PaintModel.getInstance();
		
		private var undoManager:UndoManager = UndoManager.getIntance();
		
		private var secondaryPanelManagerSprite:SecondaryPanelManager = SecondaryPanelManager.getIntance();
		
		private var helpManager:HelpManager = HelpManager.getIntance();
		
		private var layerManager:LayerManager = LayerManager.getIntance();
		
		private var toolbar:Toolbar;
		
		private var loadingDialog:LoadingDialog;
		
		private var showToolbarTimer:Timer;
		
		public function FingerPainting()
		{
			super();
			
			//Setup stage scaling mode to not scale
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			//Turn on multitouch input
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			loadingDialog = new LoadingDialog(stage);
			addChild(loadingDialog);
			
			trace("width: ", stage.fullScreenWidth, "height: " , stage.fullScreenHeight);
			
			BitmapReference.getInstance().loadBitmaps(kickstartApplication, loadingDialog);
		}
		
		private function kickstartApplication():void
		{
			removeChild(loadingDialog);
			var backgroundSprite:Sprite = new Sprite();
			backgroundSprite.mouseChildren = backgroundSprite.mouseEnabled = false;
			backgroundSprite.graphics.beginFill(0x888888);
			backgroundSprite.graphics.drawRect(0,0,stage.fullScreenWidth,stage.fullScreenHeight);
			backgroundSprite.graphics.endFill();
			backgroundSprite.cacheAsBitmap = true;
			addChild(backgroundSprite);
			
			//Adding the layerManager first as it contains all the layers of
			//the canvas.
			addChild(layerManager);
			
			//Adding listeners to the stage for all touch events, handler
			//simply passes these events along to the current tool
			stage.addEventListener(TouchEvent.TOUCH_MOVE, touchMoveHandler);
			stage.addEventListener(TouchEvent.TOUCH_BEGIN, touchMoveHandler);
			stage.addEventListener(TouchEvent.TOUCH_END, touchMoveHandler);
			stage.addEventListener(TouchEvent.TOUCH_ROLL_OUT, touchMoveHandler);
			stage.addEventListener(TouchEvent.TOUCH_TAP, touchMoveHandler);
			
			//Creating positioning and adding the toolbar
			toolbar = new Toolbar();
			toolbar.x = stage.stageWidth-TOOLBAR_BUTTON_OFFSET_FROM_RIGHT*model.dpiScale;
			toolbar.y = TOOLBAR_OFFSET_FROM_TOP*model.dpiScale;
			addChild(toolbar);
			
			addChild(secondaryPanelManagerSprite);
			
			addChild(helpManager);
			
			var startupMessages:Array = [
				new QueuedMessage(2000,"Welcome to Digital Doodler."),
				new QueuedMessage(5000,"Click the triangle to open or close the toolbar."),
				new QueuedMessage(7000,"Select a tool by clicking the icon for it in the toolbar.")]
			helpManager.showMessage(startupMessages);
			
			showToolbarTimer = new Timer(1000,1);
			showToolbarTimer.addEventListener(TimerEvent.TIMER_COMPLETE, showToolbar);
			
			undoManager.addHistoryElement(layerManager.currentLayerBitmap);
		}
		private function showToolbar(event:TimerEvent):void
		{
			toolbar.visible = true;
			secondaryPanelManagerSprite.visible = true;
		}
		
		private function touchMoveHandler(event:TouchEvent):void
		{
			if(!model.menuMoving /*&& !SecondaryPanelManager.getIntance().isShowingPanel*/)
			{
				if(event.target == stage)
					switch(event.type)
					{
						case TouchEvent.TOUCH_BEGIN:
							toolbar.visible = false;
							secondaryPanelManagerSprite.visible = false;
							showToolbarTimer.stop();
							showToolbarTimer.reset();
							break;
						case TouchEvent.TOUCH_END:
							showToolbarTimer.start();
							break;
					}
				model.currentTool.takeAction(event);
			}
		}
	}
}