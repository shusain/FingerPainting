package com.shaunhusain.fingerPainting.view
{
	import com.eclecticdesignstudio.motion.Actuate;
	import com.shaunhusain.fingerPainting.managers.AccelerometerManager;
	import com.shaunhusain.fingerPainting.model.PaintModel;
	import com.shaunhusain.fingerPainting.tools.BlankTool;
	import com.shaunhusain.fingerPainting.tools.BrushTool;
	import com.shaunhusain.fingerPainting.tools.BucketTool;
	import com.shaunhusain.fingerPainting.tools.CameraTool;
	import com.shaunhusain.fingerPainting.tools.ColorSpectrumTool;
	import com.shaunhusain.fingerPainting.tools.EraserTool;
	import com.shaunhusain.fingerPainting.tools.ITool;
	import com.shaunhusain.fingerPainting.tools.LayerTool;
	import com.shaunhusain.fingerPainting.tools.PipetTool;
	import com.shaunhusain.fingerPainting.tools.RedoTool;
	import com.shaunhusain.fingerPainting.tools.SaveTool;
	import com.shaunhusain.fingerPainting.tools.ShareTool;
	import com.shaunhusain.fingerPainting.tools.UndoTool;
	import com.shaunhusain.fingerPainting.view.managers.HelpManager;
	import com.shaunhusain.fingerPainting.view.managers.SecondaryPanelManager;
	import com.shaunhusain.fingerPainting.view.mobileUIControls.ButtonScroller;
	import com.shaunhusain.fingerPainting.view.mobileUIControls.RotatingIconButton;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TouchEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.setTimeout;
	
	/**
	 * Contains the setup for the scrolling menu buttons for the main toolbar
	 * and handler code.  Also contains the code for opening/closing the
	 * toolbar and animating the open/close arrow.
	 */
	public class Toolbar extends Sprite
	{
		
		[Embed(source="/images/saveIcon.png")]
		private static var _saveIcon:Class;
		public static var _saveIconBmp:Bitmap = new _saveIcon();
		
		[Embed(source="/images/brushIcon.png")]
		private static var _brushIcon:Class;
		public static var _brushIconBmp:Bitmap = new _brushIcon();
		
		[Embed(source="/images/eraserIcon.png")]
		private static var _eraserIcon:Class;
		public static var _eraserIconBmp:Bitmap = new _eraserIcon();
		
		[Embed(source="/images/bucketIcon.png")]
		private static var _bucketIcon:Class;
		public static var _bucketIconBmp:Bitmap = new _bucketIcon();
		
		[Embed(source="/images/undoIcon.png")]
		private static var _undoIcon:Class;
		public static var _undoIconBmp:Bitmap = new _undoIcon();
		
		[Embed(source="/images/redoIcon.png")]
		private static var _redoIcon:Class;
		public static var _redoIconBmp:Bitmap = new _redoIcon();
		
		[Embed(source="/images/shapesIcon.png")]
		private static var _shapesIcon:Class;
		public static var _shapesIconBmp:Bitmap = new _shapesIcon();
		
		[Embed(source="/images/pipetIcon.png")]
		private static var _pipetIcon:Class;
		public static var _pipetIconBmp:Bitmap = new _pipetIcon();
		
		[Embed(source="/images/colorSpectrumIcon.png")]
		private static var _colorSpectrumIcon:Class;
		public static var _colorSpectrumBmp:Bitmap = new _colorSpectrumIcon();
		
		[Embed(source="/images/blankDocIcon.png")]
		private static var _blankDocIcon:Class;
		public static var _blankDocBmp:Bitmap = new _blankDocIcon();
		
		[Embed(source="/images/cameraIcon.png")]
		private static var _cameraIcon:Class;
		public static var _cameraBmp:Bitmap = new _cameraIcon();
		
		[Embed(source="/images/layersIcon.png")]
		private static var _layersIcon:Class;
		public static var _layersBmp:Bitmap = new _layersIcon();
		
		[Embed(source="/images/shareIcon.png")]
		private static var _shareIcon:Class;
		public static var _shareBmp:Bitmap = new _shareIcon();
		
		private var model:PaintModel = PaintModel.getInstance();
		
		private var secondaryPanelManager:SecondaryPanelManager = SecondaryPanelManager.getIntance();
		
		private var isOpen:Boolean;
		
		private var _arrowRotation:Number=0;
		
		private var triangleSprite:Sprite;
		
		//Used to hold all the buttons in case they
		//need to be scrolled
		private var menuButtonSprite:ButtonScroller;
		
		private var mainToolbarStartPoint:Point;
		private var toolbarMoved:Boolean;
		
		//--------------------------------------------------------------------------------
		//				Constructor
		//--------------------------------------------------------------------------------
		public function Toolbar()
		{
			super();
			//waiting for added to stage to add the rest of children so
			//the full screen size can be accounted for
			addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
			
			addEventListener(TouchEvent.TOUCH_BEGIN, handleTouchBegin);
			addEventListener(TouchEvent.TOUCH_END, handleTouchEnd);
			addEventListener(TouchEvent.TOUCH_TAP, handleTapped);
			addEventListener(TouchEvent.TOUCH_MOVE, touchMoveHandler);
			addEventListener(TouchEvent.TOUCH_ROLL_OUT, handleRollout);
			
			model.currentColorBitmap = _colorSpectrumBmp;
		}
		
		//--------------------------------------------------------------------------------
		//				Properties
		//--------------------------------------------------------------------------------
		public function set arrowRotation(angleRadians:Number):void
		{
			rotateTriangle(angleRadians);	
		}
		public function get arrowRotation():Number
		{
			return _arrowRotation;
		}
		
		//--------------------------------------------------------------------------------
		//				Handlers
		//--------------------------------------------------------------------------------
		private function handleAddedToStage(event:Event):void
		{
			//Setting up the background scale9Grid and scaling
			BitmapReference.scaledBitmap.scale9Grid = new Rectangle(107, 102, 188, 2325);
			BitmapReference.scaledBitmap.height = stage.fullScreenHeight - y - 20;
			//toolbarBmp.width = toolbarBmp.scaleY*toolbarBmp.width;
			addChild(BitmapReference.scaledBitmap);
			
			//Setting up the triangle button that spins when opening
			rotateTriangle(Math.PI);
			triangleSprite = new Sprite();
			triangleSprite.x = 41;
			triangleSprite.y = 35;
			addChild(triangleSprite);
			
			triangleSprite.addChild(BitmapReference._triangleIconBmp);
			
			//Setting up the hit area so the entire toolbar doesn't respond to events
			var hitAreaSprite:Sprite = new Sprite();
			hitAreaSprite.graphics.clear();
			hitAreaSprite.graphics.beginFill(0x000000);
			hitAreaSprite.graphics.drawRect(0,0,1000,100);
			hitAreaSprite.graphics.endFill();
			hitAreaSprite.visible = false;
			addChild(hitAreaSprite);
			hitArea = hitAreaSprite;
			
			menuButtonSprite = new ButtonScroller();
			menuButtonSprite.buttonMaskHeight = stage.fullScreenHeight-180;
			menuButtonSprite.buttonMaskWidth = 175;
			menuButtonSprite.y = 100;
			menuButtonSprite.x = 120;
			addChild(menuButtonSprite);
			menuButtonSprite.addEventListener("instantaneousButtonClicked", instantaneousActionHandler);
			menuButtonSprite.addEventListener("buttonClicked", deselectAllOthers);
			
			
			var bg:Bitmap = BitmapReference._firstBackgroundBmp;
			var bgs:Bitmap = BitmapReference._firstBackgroundSelectedBmp;
			
			var brushTool:BrushTool = new BrushTool(stage);
			model.currentTool = brushTool;
			menuButtonSprite.menuButtons = 
				[
					new RotatingIconButton(_colorSpectrumBmp, null, new ColorSpectrumTool(stage), true, false, true,bg,bgs),
					new RotatingIconButton(_brushIconBmp, null, brushTool, false, true, true, bg, bgs),
					new RotatingIconButton(_eraserIconBmp, null, new EraserTool(stage), false, false, true, bg, bgs),
					new RotatingIconButton(_bucketIconBmp, null, new BucketTool(stage), false, false, true, bg, bgs),
					new RotatingIconButton(_pipetIconBmp, null, new PipetTool(stage), false, false, true, bg, bgs),
					new RotatingIconButton(_undoIconBmp, null, new UndoTool(stage), true, false, true, bg, bgs),
					new RotatingIconButton(_redoIconBmp, null, new RedoTool(stage), true, false, true, bg, bgs),
					new RotatingIconButton(_blankDocBmp, null, new BlankTool(stage), true, false, true, bg, bgs),
					new RotatingIconButton(_layersBmp, null, new LayerTool(stage), false, false, true, bg, bgs),
					new RotatingIconButton(_cameraBmp, null, new CameraTool(stage), true, false, true, bg, bgs),
					new RotatingIconButton(_shareBmp, null, new ShareTool(stage), true, false, true, bg, bgs),
					new RotatingIconButton(_saveIconBmp, null, new SaveTool(stage), true, false, true, bg, bgs)
				];
			trace("toolbar added to stage");
		}
		
		//--------------------------------------------------------------------------------
		//				Handlers
		//--------------------------------------------------------------------------------
		private function handleTouchBegin(event:TouchEvent):void
		{
			event.stopImmediatePropagation();
			toolbarMoved = false;
			mainToolbarStartPoint = new Point(event.stageX,event.stageY);
		}
		
		private function touchMoveHandler(event:TouchEvent):void
		{
			event.stopImmediatePropagation();
			if(!mainToolbarStartPoint)
				return;
			
			var xChange:Number = mainToolbarStartPoint.x - event.stageX;
			if(toolbarMoved||Math.abs(xChange) > 5)
			{
				model.toolbarMoving = toolbarMoved = true;
				mainToolbarStartPoint.x = event.stageX;
				x -= xChange;
				if(x<stage.fullScreenWidth - 270)
					x = stage.fullScreenWidth - 270;
			}
		}
		
		private function handleTouchEnd(event:TouchEvent):void
		{
			event.stopImmediatePropagation();
			if(toolbarMoved)
			{
				setTimeout(function():void{model.toolbarMoving = false},500);
			}
			mainToolbarStartPoint = null;
		}
		
		private function handleTapped(event:TouchEvent):void
		{
			event.stopImmediatePropagation();
			
			if(isOpen)
			{
				AccelerometerManager.getIntance().currentlyActive = false;
				Actuate.tween(this, .5, {arrowRotation:Math.PI, x:stage.fullScreenWidth - FingerPainting.TOOLBAR_OFFSET_FROM_RIGHT});
			}
			else
			{
				AccelerometerManager.getIntance().currentlyActive = true;
				Actuate.tween(this, .5, {arrowRotation:0,x:stage.fullScreenWidth - FingerPainting.TOOLBAR_OFFSET_FROM_RIGHT_OPEN});
			}
			isOpen = !isOpen;
			secondaryPanelManager.hidePanel();
		}
		
		protected function handleRollout(event:TouchEvent):void
		{
			if(!mainToolbarStartPoint)
				return;
			var xChange:Number = mainToolbarStartPoint.x - event.stageX;
			if(xChange<0)
			{
				isOpen = true;
				AccelerometerManager.getIntance().currentlyActive = true;
				Actuate.tween(this, .5, {arrowRotation:0,x:stage.fullScreenWidth - 270});
			}
			else
			{
				isOpen = false;
				AccelerometerManager.getIntance().currentlyActive = false;
				Actuate.tween(this, .5, {arrowRotation:Math.PI, x:stage.fullScreenWidth - 85});
				secondaryPanelManager.hidePanel();
			}
		}
		
		private function blockEvent(event:TouchEvent):void
		{
			event.stopImmediatePropagation();
		}
		
		protected function instantaneousActionHandler(event:Event):void
		{
			var tempTool:ITool = event.target.data as ITool;
			HelpManager.getIntance().showMessage((event.target.data as ITool).toString(),250,false);
			tempTool.takeAction();
		}
		
		//--------------------------------------------------------------------------------
		//				Helper functions
		//--------------------------------------------------------------------------------
		private function deselectAllOthers(event:Event):void
		{
			if(model.currentTool != event.target.data as ITool)
				HelpManager.getIntance().showMessage((event.target.data as ITool).toString(),750,false);
			
			if(model.currentTool == event.target.data as ITool && model.currentTool is BrushTool)
			{
				var bt:BrushTool = model.currentTool as BrushTool;
				bt.toggleSecondaryOptions();
			}
			else if(model.currentTool == event.target.data as ITool && model.currentTool is LayerTool)
			{
				var yt:LayerTool = model.currentTool as LayerTool;
				yt.toggleSecondaryOptions();
			}
			else
			{
				secondaryPanelManager.hidePanel();
			}
			
			model.currentTool = event.target.data as ITool;
			
			
			for( var i:int = 0; i <menuButtonSprite.menuButtons.length; i++)
			{
				var ab:RotatingIconButton = menuButtonSprite.menuButtons[i];
				if(event.target!=ab)
					ab.isSelected = false;
			}
		}
		
		private function rotateTriangle(angleRadians:Number):void
		{
			var BR:Class = BitmapReference;
			_arrowRotation = angleRadians;
			var m:Matrix = BR._triangleIconBmp.transform.matrix;
			m.identity();
			m.translate(-BR._triangleIconBmp.width/2,-BR._triangleIconBmp.height/2);
			m.rotate(angleRadians);
			m.translate(BR._triangleIconBmp.width/2,BR._triangleIconBmp.height/2);
			BR._triangleIconBmp.transform.matrix = m;
		}
	}
}