package com.shaunhusain.fingerPainting.view
{
	import com.eclecticdesignstudio.motion.Actuate;
	import com.shaunhusain.fingerPainting.model.PaintModel;
	import com.shaunhusain.fingerPainting.tools.*;
	import com.shaunhusain.fingerPainting.view.mobileUIControls.RotatingIconButton;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TouchEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.setTimeout;
	
	import org.bytearray.ScaleBitmap;
	
	public class Toolbar extends Sprite
	{
		[Embed(source="/images/brushIcon.png")]
		private var _brushIcon:Class;
		private var _brushIconBmp:Bitmap = new _brushIcon();
		
		[Embed(source="/images/eraserIcon.png")]
		private var _eraserIcon:Class;
		private var _eraserIconBmp:Bitmap = new _eraserIcon();
		
		[Embed(source="/images/bucketIcon.png")]
		private var _bucketIcon:Class;
		private var _bucketIconBmp:Bitmap = new _bucketIcon();
		
		[Embed(source="/images/undoIcon.png")]
		private var _undoIcon:Class;
		private var _undoIconBmp:Bitmap = new _undoIcon();
		
		[Embed(source="/images/redoIcon.png")]
		private var _redoIcon:Class;
		private var _redoIconBmp:Bitmap = new _redoIcon();
		
		[Embed(source="/images/shapesIcon.png")]
		private var _shapesIcon:Class;
		private var _shapesIconBmp:Bitmap = new _shapesIcon();
		
		[Embed(source="/images/pipetIcon.png")]
		private var _pipetIcon:Class;
		private var _pipetIconBmp:Bitmap = new _pipetIcon();
		
		[Embed(source="/images/colorSpectrumIcon.png")]
		private var _colorSpectrumIcon:Class;
		private var _colorSpectrumBmp:Bitmap = new _colorSpectrumIcon();
		
		[Embed(source="/images/blankDocIcon.png")]
		private var _blankDocIcon:Class;
		private var _blankDocBmp:Bitmap = new _blankDocIcon();
		
		[Embed(source="/images/triangleIcon.png")]
		private var _triangleIcon:Class;
		private var _triangleIconBmp:Bitmap = new _triangleIcon();
		
		[Embed(source="/images/toolbarBackground.png")]
		private var toolbarBmpClass:Class;
		private var toolbarBmp:Bitmap = new toolbarBmpClass();
		private var scaledBitmap:ScaleBitmap = new ScaleBitmap(toolbarBmp.bitmapData);
		
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
			
			model.currentColorBitmap = _colorSpectrumBmp;
		}
		
		private function handleAddedToStage(event:Event):void
		{
			//Setting up the background scale9Grid and scaling
			scaledBitmap.scale9Grid = new Rectangle(118, 100, 271, 2286);
			scaledBitmap.height = stage.fullScreenHeight - y;
			//toolbarBmp.width = toolbarBmp.scaleY*toolbarBmp.width;
			addChild(scaledBitmap);
			
			//Setting up the triangle button that spins when opening
			rotateTriangle(Math.PI);
			triangleSprite = new Sprite();
			triangleSprite.x = 41;
			triangleSprite.y = 35;
			addChild(triangleSprite);
			
			triangleSprite.addChild(_triangleIconBmp);
			
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
			menuButtonSprite.y = 100;
			addChild(menuButtonSprite);
			
			menuButtons = 
				[
					
					new RotatingIconButton(_blankDocBmp, new BlankTool(), true),
					new RotatingIconButton(_undoIconBmp, new UndoTool(), true),
					new RotatingIconButton(_redoIconBmp, new RedoTool(), true),
					new RotatingIconButton(_pipetIconBmp, new PipetTool()),
					new RotatingIconButton(_shapesIconBmp, new ShapeTool(),false,false,true),
					new RotatingIconButton(_eraserIconBmp, new EraserTool()),
					new RotatingIconButton(_bucketIconBmp, new BucketTool()),
					new RotatingIconButton(_brushIconBmp, new BrushTool(), false, true, true),
					new RotatingIconButton(_colorSpectrumBmp, new ColorSpectrumTool(),false,false,true)
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
			secondaryBrushOptions.x = -400;
			secondaryBrushOptions.y = 100;
			secondaryBrushOptions.visible = false;
			addChild(secondaryBrushOptions);
			
			secondaryColorOptions = new SecondaryColorOptions();
			secondaryColorOptions.x = -400;
			secondaryColorOptions.y = 100;
			secondaryColorOptions.visible = false;
			addChild(secondaryColorOptions);
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
				secondaryBrushOptions.visible = !secondaryBrushOptions.visible;
				secondaryColorOptions.visible = false;
			}
			else if(event.target.data is ColorSpectrumTool)
			{
				secondaryColorOptions.visible = !secondaryColorOptions.visible;
				secondaryBrushOptions.visible = false;
			}
			else
			{
				secondaryColorOptions.visible = false;
				secondaryBrushOptions.visible = false;
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
			if((menuMoved||Math.abs(yChange) > 5) && (menuButtonSprite.y>10||yChange<0))
			{
				model.menuMoving = menuMoved = true;
				menuButtonsTouchStartPoint.y = event.stageY;
				menuButtonSprite.y -= yChange;
				
				trace(menuButtonSprite.y);
				
				//secondaryBrushOptions.setConnectionYPosition(menuButtonSprite.y+400);
			}
			if(menuButtonSprite.y<10)
				menuButtonSprite.y = 10;
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
			trace("handling tapped");
			
			if(isOpen)
			{
				Actuate.tween(this, .5, {arrowRotation:Math.PI, x:stage.fullScreenWidth - 85});
			}
			else
			{
				Actuate.tween(this, .5, {arrowRotation:0,x:stage.fullScreenWidth - 270});
			}
			isOpen = !isOpen;
			secondaryColorOptions.visible = false;
			secondaryBrushOptions.visible = false;
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
			var m:Matrix = _triangleIconBmp.transform.matrix;
			m.identity();
			m.translate(-_triangleIconBmp.width/2,-_triangleIconBmp.height/2);
			m.rotate(angleRadians);
			m.translate(_triangleIconBmp.width/2,_triangleIconBmp.height/2);
			_triangleIconBmp.transform.matrix = m;
		}
	}
}