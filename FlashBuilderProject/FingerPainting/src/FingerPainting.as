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
	import com.shaunhusain.layerdImageVOs.LayeredFileVO;
	import com.shaunhusain.openRaster.OpenRasterReader;
	import com.shaunhusain.openRaster.OpenRasterWriter;
	
	import flash.desktop.NativeApplication;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageAspectRatio;
	import flash.display.StageOrientation;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.InvokeEvent;
	import flash.events.TimerEvent;
	import flash.events.TouchEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.utils.ByteArray;
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
		
		private var helpManager:HelpManager;
		
		private var layerManager:LayerManager = LayerManager.getIntance();
		
		private var toolbar:Toolbar;
		
		private var loadingDialog:LoadingDialog;
		
		private var showToolbarTimer:Timer;
		
		public function FingerPainting()
		{
			super();
			
			NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, onInvoke);
			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, autoSave);
			
			
			var file_ani:File;
			var fs_ani:FileStream;
			
			
			function onInvoke(event:InvokeEvent):void
			{
				
				trace("FileOpenExample.onInvoke(event)");
				if(event.arguments && event.arguments.length)
				{
					
					var contentUri:String = event.arguments[0] as String;
					trace("Content:", contentUri);
					file_ani = new File(contentUri);
					if(file_ani.extension == "png")
					{
						fs_ani = new FileStream();
						fs_ani.openAsync(file_ani, FileMode.READ);
						fs_ani.addEventListener(Event.COMPLETE, onFileComplete, false, 0, true);
					}
					else if(file_ani.extension == "ora")
					{
						var fs:FileStream = new FileStream();
						fs.open(file_ani,FileMode.READ);
						
						var ba:ByteArray = new ByteArray();
						fs.readBytes(ba);
						
						OpenRasterReader.getInstance().read(ba, handleLoadedFile);
					}
				}
			}
			
			function onFileComplete(event:Event):void
			{
				var fs:FileStream = event.target as FileStream;
				
				var ba:ByteArray = new ByteArray();
				fs.readBytes(ba,0,fs.bytesAvailable);
				
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completedLoadingFile);
				loader.loadBytes(ba);
				
				
				/*var fileContent:String = fs.readUTFBytes(fs.bytesAvailable);
				trace(fileContent);
				file_ani = null;
				fs_ani = null;*/
			}
			
			function completedLoadingFile(event:Event):void
			{
				var loaderInfo:LoaderInfo = event.target as LoaderInfo;
				layerManager.addLayer(loaderInfo.loader);
			}
			
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
		
		private function handleLoadedFile(file:LayeredFileVO):void
		{
			layerManager.layers = file.layers;
		}
		
		protected function autoSave(event:Event):void
		{
			if(model.untouched)
				return;
			if(model.disableNextAutosave)
			{
				model.disableNextAutosave = false;
				return;
			}
			var fs:FileStream = new FileStream();
			
			fs.open(File.userDirectory.resolvePath("Digital Doodler/autoSave.ora"),FileMode.WRITE);
			
			var file:LayeredFileVO = new LayeredFileVO();
			
			file.width = stage.fullScreenWidth;
			file.height = stage.fullScreenHeight;
			
			file.layers = layerManager.layers;
			
			var openRaster:OpenRasterWriter = OpenRasterWriter.getInstance();
			var ba:ByteArray = openRaster.write(file);
			ba.position = 0;
			fs.writeBytes(ba);
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
			
			helpManager = HelpManager.getIntance()
			addChild(helpManager);
			
			var startupMessages:Array = [
				new QueuedMessage(2000,"Welcome to Digital Doodler."),
				new QueuedMessage(5000,"Touch the triangle to open or close the toolbar."),
				new QueuedMessage(7000,"Select a tool by touching the icon for it in the toolbar.")]
			helpManager.showMessage(startupMessages);
			
			showToolbarTimer = new Timer(1000,1);
			showToolbarTimer.addEventListener(TimerEvent.TIMER_COMPLETE, showToolbar);
			
			undoManager.addHistoryElement(layerManager.currentLayerBitmap);
			
			/*stage.setOrientation(StageOrientation.ROTATED_LEFT);
			stage.setAspectRatio(StageAspectRatio.LANDSCAPE);*/
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
				/*if(event.target == stage)
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
					}*/
				model.untouched = false;
				model.currentTool.takeAction(event);
			}
		}
	}
}