package com.shaunhusain.fingerPainting.view
{
	import com.eclecticdesignstudio.motion.Actuate;
	import com.shaunhusain.fingerPainting.managers.SecondaryPanelManager;
	import com.shaunhusain.fingerPainting.model.PaintModel;
	import com.shaunhusain.fingerPainting.tools.BlankTool;
	import com.shaunhusain.fingerPainting.tools.BrushTool;
	import com.shaunhusain.fingerPainting.tools.BucketTool;
	import com.shaunhusain.fingerPainting.tools.ColorSpectrumTool;
	import com.shaunhusain.fingerPainting.tools.EraserTool;
	import com.shaunhusain.fingerPainting.tools.ITool;
	import com.shaunhusain.fingerPainting.tools.PipetTool;
	import com.shaunhusain.fingerPainting.tools.RedoTool;
	import com.shaunhusain.fingerPainting.tools.SaveTool;
	import com.shaunhusain.fingerPainting.tools.ShapeTool;
	import com.shaunhusain.fingerPainting.tools.UndoTool;
	import com.shaunhusain.fingerPainting.view.mobileUIControls.RotatingIconButton;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TouchEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.setTimeout;
	
	public class Toolbar extends Sprite
	{
		
		private var model:PaintModel = PaintModel.getInstance();
		
		private var isOpen:Boolean;
		private var _arrowRotation:Number=0;
		
		private var triangleSprite:Sprite;
		
		//Used to hold all the buttons in case they
		//need to be scrolled
		private var menuButtonSprite:Sprite;
		private var menuButtonMask:Sprite;
		private var menuButtons:Array;
		private var menuMoved:Boolean;
		private var menuButtonsTouchStartPoint:Point;
		
		private var mainToolbarStartPoint:Point;
		private var toolbarMoved:Boolean;
		private var secondaryBrushOptions:SecondaryBrushOptions;
		private var secondaryColorOptions:SecondaryColorOptions;
		
		private var secondaryPanelManager:SecondaryPanelManager = SecondaryPanelManager.getIntance();
		
		private var BR:Class = BitmapReference;
		
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
			
			menuButtonSprite = new Sprite();
			menuButtonSprite.addEventListener(TouchEvent.TOUCH_BEGIN, beganTouchingMenu);
			menuButtonSprite.addEventListener(TouchEvent.TOUCH_MOVE, moveTouchingMenu);
			menuButtonSprite.addEventListener(TouchEvent.TOUCH_END, endTouchingMenu);
			menuButtonSprite.addEventListener(TouchEvent.TOUCH_ROLL_OUT, blockEvent);
			menuButtonSprite.y = 100;
			addChild(menuButtonSprite);
			
			menuButtons = 
				[
					
					new RotatingIconButton(BR._saveIconBmp, new SaveTool(), true),
					new RotatingIconButton(BR._blankDocBmp, new BlankTool(), true),
					new RotatingIconButton(BR._undoIconBmp, new UndoTool(), true),
					new RotatingIconButton(BR._redoIconBmp, new RedoTool(), true),
					new RotatingIconButton(BR._pipetIconBmp, new PipetTool()),
					new RotatingIconButton(BR._shapesIconBmp, new ShapeTool(),false,false,true),
					new RotatingIconButton(BR._eraserIconBmp, new EraserTool()),
					new RotatingIconButton(BR._bucketIconBmp, new BucketTool()),
					new RotatingIconButton(BR._brushIconBmp, new BrushTool(), false, true, true),
					new RotatingIconButton(BR._colorSpectrumBmp, new ColorSpectrumTool(),false,false,true)
				];
			
			for( var i:int = 0; i <menuButtons.length; i++)
			{
				var ab:RotatingIconButton = menuButtons[i];
				ab.addEventListener("buttonClicked", deselectAllOthers);
				ab.addEventListener("instantaneousButtonClicked", instantaneousActionHandler);
				if(ab.useSecondaryBackground)
					ab.x=85;
				else
					ab.x = 140;
				
				if(ab.isSelected)
					model.currentTool = menuButtons[i].data;
				
				ab.y = i*125;
				menuButtonSprite.addChild(ab);
			}
			
			
			secondaryBrushOptions = new SecondaryBrushOptions();
			secondaryBrushOptions.x = 100;
			secondaryBrushOptions.y = 100;
			
			secondaryColorOptions = new SecondaryColorOptions();
			secondaryColorOptions.x = 100;
			secondaryColorOptions.y = 100;
			
		}
		
		
		private function instantaneousActionHandler(event:Event):void
		{
			var tempTool:ITool = event.target.data as ITool;
			tempTool.takeAction();
		}
		
		private function deselectAllOthers(event:Event):void
		{
			if(model.currentTool == event.target.data as ITool && model.currentTool is BrushTool)
			{
				if(secondaryPanelManager.currentlyShowing == secondaryBrushOptions)
					secondaryPanelManager.hidePanel();
				else
					secondaryPanelManager.showPanel(secondaryBrushOptions);
			}
			else if(event.target.data is ColorSpectrumTool)
			{
				if(secondaryPanelManager.currentlyShowing == secondaryColorOptions)
					secondaryPanelManager.hidePanel();
				else
					secondaryPanelManager.showPanel(secondaryColorOptions);
			}
			else
			{
				secondaryPanelManager.hidePanel();
			}
			model.currentTool = event.target.data as ITool;
			for( var i:int = 0; i <menuButtons.length; i++)
			{
				var ab:RotatingIconButton = menuButtons[i];
				if(event.target!=ab)
					ab.isSelected = false;
			}
		}
		
		private function beganTouchingMenu(event:TouchEvent):void
		{
			event.stopImmediatePropagation();
			menuMoved = false;
			menuButtonsTouchStartPoint = new Point(event.stageX,event.stageY);
		}
		
		private function moveTouchingMenu(event:TouchEvent):void
		{
			event.stopImmediatePropagation();
			if(!menuButtonsTouchStartPoint)
				return;
			
			var yChange:Number = menuButtonsTouchStartPoint.y - event.stageY;
			if(menuMoved||Math.abs(yChange) > 5)
			{
				if(yChange>0 && menuButtonSprite.y+menuButtonSprite.height<=stage.fullScreenHeight-40)
				{
					
					menuButtonSprite.y = stage.fullScreenHeight-40-menuButtonSprite.height;
					menuButtonsTouchStartPoint.y = event.stageY;
					return;
				}
				model.menuMoving = menuMoved = true;
				menuButtonsTouchStartPoint.y = event.stageY;
				menuButtonSprite.y -= yChange;
				
				if(yChange>0 && menuButtonSprite.y+menuButtonSprite.height<=stage.fullScreenHeight-40)
				{
					
					menuButtonSprite.y = stage.fullScreenHeight-40-menuButtonSprite.height;
					menuButtonsTouchStartPoint.y = event.stageY;
				}
				trace(menuButtonSprite.y);
				
				//secondaryBrushOptions.setConnectionYPosition(menuButtonSprite.y+400);
			}
		}
		
		private function endTouchingMenu(event:TouchEvent):void
		{
			event.stopImmediatePropagation();
			if(menuMoved)
			{
				setTimeout(function():void{model.menuMoving = false},500);
			}
			menuButtonsTouchStartPoint = null;
		}
		
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
				Actuate.tween(this, .5, {arrowRotation:Math.PI, x:stage.fullScreenWidth - 85});
			}
			else
			{
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
				Actuate.tween(this, .5, {arrowRotation:0,x:stage.fullScreenWidth - 270});
			}
			else
			{
				isOpen = false;
				Actuate.tween(this, .5, {arrowRotation:Math.PI, x:stage.fullScreenWidth - 85});
				secondaryPanelManager.hidePanel();
			}
		}
		
		public function set arrowRotation(angleRadians:Number):void
		{
			rotateTriangle(angleRadians);	
		}
		public function get arrowRotation():Number
		{
			return _arrowRotation;
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
		
		private function blockEvent(event:TouchEvent):void
		{
			event.stopImmediatePropagation();
		}
	}
}