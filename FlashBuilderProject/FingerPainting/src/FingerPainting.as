package 
{
	import com.shaunhusain.fingerPainting.managers.UndoManager;
	import com.shaunhusain.fingerPainting.model.PaintModel;
	import com.shaunhusain.fingerPainting.model.QueuedMessage;
	import com.shaunhusain.fingerPainting.view.Toolbar;
	import com.shaunhusain.fingerPainting.view.managers.HelpManager;
	import com.shaunhusain.fingerPainting.view.managers.LayerManager;
	import com.shaunhusain.fingerPainting.view.managers.SecondaryPanelManager;
	import com.shaunhusain.fingerPainting.view.managers.helpComponents.SimpleHelpDisplay;
	
	import flash.display.Screen;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.TouchEvent;
	import flash.system.Capabilities;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	/**
	 * This is the main application file for the FingerPainting app.  This is
	 * the file that creates the toolbar and the layer management/display and
	 * other components of the application.
	 */
	[SWF(frameRate="40")]
	public class FingerPainting extends Sprite
	{	
		public static const TOOLBAR_OFFSET_FROM_RIGHT:Number = 85;
		public static const TOOLBAR_OFFSET_FROM_RIGHT_OPEN:Number = 270;
		public static const TOOLBAR_OFFSET_FROM_TOP:Number = 20;
		
		private var model:PaintModel = PaintModel.getInstance();
		
		private var undoManager:UndoManager = UndoManager.getIntance();
		
		private var secondaryPanelManagerSprite:SecondaryPanelManager = SecondaryPanelManager.getIntance();
		
		private var helpManager:HelpManager = HelpManager.getIntance();
		
		private var layerManager:LayerManager = LayerManager.getIntance();
		
		private var toolbar:Toolbar;
		
		public function FingerPainting()
		{
			super();
			
			//Setup stage scaling mode to not scale
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			//Turn on multitouch input
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			trace("dpi",Capabilities.screenDPI);
			
			//Setup an overlay for temporary drawing of vector data.
			//Used to create lines between touch point data
			model.currentDrawingOverlay = new Sprite();
			model.currentDrawingOverlay.mouseChildren = model.currentDrawingOverlay.mouseEnabled = false;
			
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
			
			//Adding the sprite overlay used for vector drawing.
			addChild(model.currentDrawingOverlay);
			
			//Creating positioning and adding the toolbar
			toolbar = new Toolbar();
			toolbar.x = stage.stageWidth-TOOLBAR_OFFSET_FROM_RIGHT;
			toolbar.y = TOOLBAR_OFFSET_FROM_TOP;
			addChild(toolbar);
			
			addChild(secondaryPanelManagerSprite);
			
			addChild(helpManager);
			
			var startupMessages:Array = [
				new QueuedMessage(2000,"Welcome to Digital Doodler."),
				new QueuedMessage(5000,"Click the triangle to open or close the toolbar."),
				new QueuedMessage(7000,"Select a tool by clicking the icon for it in the toolbar.")]
			helpManager.showMessage(startupMessages);
			
			trace("stage size:",stage.fullScreenHeight, stage.fullScreenWidth);
		}
		
		private function touchMoveHandler(event:TouchEvent):void
		{
			if(!model.menuMoving && !SecondaryPanelManager.getIntance().isShowingPanel)
				model.currentTool.takeAction(event);
		}
	}
}