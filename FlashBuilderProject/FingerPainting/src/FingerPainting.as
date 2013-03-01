package 
{
	import com.shaunhusain.fingerPainting.managers.UndoManager;
	import com.shaunhusain.fingerPainting.model.PaintModel;
	import com.shaunhusain.fingerPainting.model.QueuedMessage;
	import com.shaunhusain.fingerPainting.view.BitmapReference;
	import com.shaunhusain.fingerPainting.view.Toolbar;
	import com.shaunhusain.fingerPainting.view.managers.HelpManager;
	import com.shaunhusain.fingerPainting.view.managers.LayerManager;
	import com.shaunhusain.fingerPainting.view.managers.SecondaryPanelManager;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.TouchEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	import org.bytearray.ScaleBitmap;
	
	/**
	 * This is the main application file for the FingerPainting app.  This is
	 * the file that creates the toolbar and the layer management/display and
	 * other components of the application.
	 */
	[SWF(frameRate="40")]
	public class FingerPainting extends Sprite
	{	public static const TOOLBAR_OFFSET_FROM_RIGHT:Number = 85;
		public static const TOOLBAR_OFFSET_FROM_RIGHT_OPEN:Number = 270;
		public static const TOOLBAR_OFFSET_FROM_TOP:Number = 20;
		
		private var model:PaintModel = PaintModel.getInstance();
		
		private var undoManager:UndoManager = UndoManager.getIntance();
		
		private var secondaryPanelManagerSprite:SecondaryPanelManager = SecondaryPanelManager.getIntance();
		
		private var helpManager:HelpManager = HelpManager.getIntance();
		
		private var layerManager:LayerManager = LayerManager.getIntance();
		
		private var toolbar:Toolbar;
		
		[Embed(source="/logo.png")]
		private var logoClass:Class;
		private var logoBmp:Bitmap = new logoClass();
		
		[Embed(source="/loadingScreenBackground.png")]
		private var loadingScreenClass:Class;
		private var loadingScreenBmp:Bitmap = new loadingScreenClass();
		private var scaledLoadingScreen:ScaleBitmap = new ScaleBitmap(loadingScreenBmp.bitmapData);
		
		private var loadingText:TextField;
		private var createdByText:TextField;
		private var thankYouTitleText:TextField;
		
		public function FingerPainting()
		{
			super();
			
			//Setup stage scaling mode to not scale
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			//Turn on multitouch input
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			loadingText = new TextField();
			loadingText.autoSize = TextFieldAutoSize.LEFT;
			var loadingTextFormat:TextFormat = new TextFormat();
			loadingTextFormat.size = model.dpiScale*36;
			loadingTextFormat.font = "myFont";
			loadingTextFormat.color = 0xdfe500;
			loadingText.defaultTextFormat = loadingTextFormat;
			loadingText.y = stage.fullScreenHeight - model.dpiScale * 38 - 50;
			loadingText.x = stage.fullScreenWidth/2-model.dpiScale*350;
			
			createdByText = new TextField();
			createdByText.autoSize = TextFieldAutoSize.CENTER;
			var createdByTextFormat:TextFormat = new TextFormat();
			createdByTextFormat.size = model.dpiScale*36;
			createdByTextFormat.font = "myFont";
			createdByTextFormat.color = 0xFFFFFF;
			createdByTextFormat.align = "center";
			createdByText.defaultTextFormat = createdByTextFormat;
			createdByText.text = "Made by Shaun Husain\nChiTownGames.com";
			createdByText.x = stage.fullScreenWidth/2 - createdByText.getLineMetrics(0).width/2;
			createdByText.y = stage.fullScreenHeight/2 - logoBmp.height/2 + 350*model.dpiScale;
			
			thankYouTitleText = new TextField();
			thankYouTitleText.autoSize = TextFieldAutoSize.CENTER;
			var thankYouTitleTextFormat:TextFormat = new TextFormat();
			thankYouTitleTextFormat.size = model.dpiScale*36;
			thankYouTitleTextFormat.font = "myFont";
			thankYouTitleTextFormat.color = 0xdfe500;
			thankYouTitleTextFormat.align = "center";
			thankYouTitleText.defaultTextFormat = thankYouTitleTextFormat;
			thankYouTitleText.text = "Thank you for using\nDigital Doodler";
			thankYouTitleText.x = stage.fullScreenWidth/2 - thankYouTitleText.getLineMetrics(0).width/2;
			thankYouTitleText.y = stage.fullScreenHeight/2 - logoBmp.height/2 + 170*model.dpiScale;
			
			scaledLoadingScreen.scale9Grid = new Rectangle(30, 30, 250, 350);
			scaledLoadingScreen.width = stage.fullScreenWidth;
			scaledLoadingScreen.height = stage.fullScreenHeight;
			
			logoBmp.x = stage.fullScreenWidth/2 - logoBmp.width/2;
			logoBmp.y = stage.fullScreenHeight/2 - logoBmp.height/2;
			
			addChild(scaledLoadingScreen);
			addChild(logoBmp);
			addChild(loadingText);
			addChild(createdByText);
			addChild(thankYouTitleText);
			
			BitmapReference.getInstance().loadBitmaps(kickstartApplication, loadingText);
		}
		
		private function kickstartApplication():void
		{
			removeChild(scaledLoadingScreen);
			removeChild(loadingText);
			removeChild(createdByText);
			removeChild(thankYouTitleText);
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
			toolbar.x = stage.stageWidth-TOOLBAR_OFFSET_FROM_RIGHT*model.dpiScale;
			toolbar.y = TOOLBAR_OFFSET_FROM_TOP*model.dpiScale;
			addChild(toolbar);
			
			addChild(secondaryPanelManagerSprite);
			
			addChild(helpManager);
			
			var startupMessages:Array = [
				new QueuedMessage(2000,"Welcome to Digital Doodler."),
				new QueuedMessage(5000,"Click the triangle to open or close the toolbar."),
				new QueuedMessage(7000,"Select a tool by clicking the icon for it in the toolbar.")]
			helpManager.showMessage(startupMessages);
			
			undoManager.addHistoryElement(layerManager.currentLayerBitmap);
		}
		
		private function touchMoveHandler(event:TouchEvent):void
		{
			if(!model.menuMoving /*&& !SecondaryPanelManager.getIntance().isShowingPanel*/)
				model.currentTool.takeAction(event);
		}
	}
}