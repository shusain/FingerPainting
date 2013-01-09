package com.shaunhusain.fingerPainting.view
{
	import com.eclecticdesignstudio.motion.Actuate;
	import com.shaunhusain.fingerPainting.managers.AccelerometerManager;
	import com.shaunhusain.fingerPainting.managers.SecondaryPanelManager;
	import com.shaunhusain.fingerPainting.model.PaintModel;
	import com.shaunhusain.fingerPainting.tools.*;
	import com.shaunhusain.fingerPainting.view.mobileUIControls.ButtonScroller;
	import com.shaunhusain.fingerPainting.view.mobileUIControls.RotatingIconButton;
	
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
		
		private var BR:Class = BitmapReference;
		
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
			
			model.currentColorBitmap = BR._colorSpectrumBmp;
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
			BitmapReference.scaledBitmap.scale9Grid = new Rectangle(118, 100, 271, 2286);
			BitmapReference.scaledBitmap.height = stage.fullScreenHeight - y;
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
			menuButtonSprite.buttonMaskWidth = 300;
			menuButtonSprite.y = 100;
			menuButtonSprite.x = 140;
			addChild(menuButtonSprite);
			menuButtonSprite.addEventListener("instantaneousButtonClicked", instantaneousActionHandler);
			menuButtonSprite.addEventListener("buttonClicked", deselectAllOthers);
			
			
			var brushTool:BrushTool = new BrushTool(stage);
			model.currentTool = brushTool;
			menuButtonSprite.menuButtons = 
				[
					
					new RotatingIconButton(BR._colorSpectrumBmp, new ColorSpectrumTool(stage),true,false),
					new RotatingIconButton(BR._brushIconBmp, brushTool, false, true),
					new RotatingIconButton(BR._eraserIconBmp, new EraserTool(stage)),
					new RotatingIconButton(BR._bucketIconBmp, new BucketTool(stage)),
					new RotatingIconButton(BR._pipetIconBmp, new PipetTool(stage)),
					new RotatingIconButton(BR._undoIconBmp, new UndoTool(stage), true),
					new RotatingIconButton(BR._redoIconBmp, new RedoTool(stage), true),
					new RotatingIconButton(BR._blankDocBmp, new BlankTool(stage), true),
					new RotatingIconButton(BR._layersBmp, new LayerTool(stage)),
					new RotatingIconButton(BR._cameraBmp, new CameraTool(stage), true),
					new RotatingIconButton(BR._shareBmp, new ShareTool(stage), true),
					new RotatingIconButton(BR._saveIconBmp, new SaveTool(stage), true)
				];
			
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
				Actuate.tween(this, .5, {arrowRotation:Math.PI, x:stage.fullScreenWidth - 85});
			}
			else
			{
				AccelerometerManager.getIntance().currentlyActive = true;
				Actuate.tween(this, .5, {arrowRotation:0,x:stage.fullScreenWidth - 270});
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
			tempTool.takeAction();
		}
		
		//--------------------------------------------------------------------------------
		//				Helper functions
		//--------------------------------------------------------------------------------
		private function deselectAllOthers(event:Event):void
		{
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