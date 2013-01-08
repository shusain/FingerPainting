package com.shaunhusain.fingerPainting.view.mobileUIControls
{
	import com.eclecticdesignstudio.motion.Actuate;
	import com.shaunhusain.fingerPainting.managers.SecondaryPanelManager;
	import com.shaunhusain.fingerPainting.model.PaintModel;
	import com.shaunhusain.fingerPainting.view.BitmapReference;
	
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TouchEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Transform;
	import flash.utils.setTimeout;
	
	public class ButtonScroller extends Sprite
	{
		private var yChange:Number;
		private var menuButtonSprite:Sprite;
		private var menuButtonMask:Sprite;
		private var menuMoved:Boolean;
		private var menuButtonsTouchStartPoint:Point;
		private var model:PaintModel = PaintModel.getInstance();
		private var secondaryPanelManager:SecondaryPanelManager = SecondaryPanelManager.getIntance();
		private var glowUp:Sprite;
		private var glowDown:Sprite;
		private var scrollAreaBackground:Sprite;
		
		
		private var _glowHeight:Number=31;
		
		//--------------------------------------------------------------------------------
		//				Constructor
		//--------------------------------------------------------------------------------
		public function ButtonScroller()
		{
			super();
			addEventListener(TouchEvent.TOUCH_ROLL_OUT, blockEvent);
			addEventListener(Event.ADDED_TO_STAGE, addedHandler);
			addEventListener(Event.ADDED,addedHandler);
			
			if(!glowUp)
			{
				glowUp = new Sprite();
				glowUp.alpha = 0;
				glowUp.cacheAsBitmap=true;
				addChild(glowUp);
			}
			if(!glowDown)
			{
				glowDown = new Sprite();
				glowDown.alpha = 0;
				glowDown.cacheAsBitmap=true;
				addChild(glowDown);
			}
			
			if(!menuButtonSprite)
			{
				menuButtonSprite = new Sprite();
				menuButtonSprite.y = _glowHeight;
				menuButtonSprite.cacheAsBitmap = true;
				addChild(menuButtonSprite);
			}
			
			if(!scrollAreaBackground)
			{
				scrollAreaBackground = new Sprite();
				menuButtonSprite.addChild(scrollAreaBackground);
			}
			if(!menuButtonMask)
			{
				menuButtonMask = new Sprite();
				menuButtonMask.visible = false;
				addChild(menuButtonMask);
				menuButtonSprite.hitArea = menuButtonMask;
			}
			
		}
		
		//--------------------------------------------------------------------------------
		//				Properties
		//--------------------------------------------------------------------------------
		
		/**
		 * gap
		 */
		private var _gap:Number = 10;

		public function get gap():Number
		{
			return _gap;
		}
		public function set gap(value:Number):void
		{
			_gap = value;
		}

		
		/**
		 * glowXOffset
		 */
		private var _glowXOffset:Number=20;

		public function get glowXOffset():Number
		{
			return _glowXOffset;
		}

		public function set glowXOffset(value:Number):void
		{
			_glowXOffset = value;
			drawGlows(_buttonMaskWidth);
		}
		
		/**
		 * buttonMaskWidth
		 */
		private var _buttonMaskWidth:Number;
		public function get buttonMaskWidth():Number
		{
			return _buttonMaskWidth;
		}
		public function set buttonMaskWidth(value:Number):void
		{
			_buttonMaskWidth = value;
			drawMask();
			drawGlows(value);
		}
		
		
		/**
		 * buttonMaskHeight
		 */
		private var _buttonMaskHeight:Number;
		public function get buttonMaskHeight():Number
		{
			return _buttonMaskHeight;
		}
		public function set buttonMaskHeight(value:Number):void
		{
			glowDown.y = value-_glowHeight-1;
			_buttonMaskHeight = value-_glowHeight*2;
			drawMask();
		}
		
		/**
		 * menuButtons
		 */
		private var _menuButtons:Array;
		public function set menuButtons(value:Array):void{
			if(_menuButtons == value)
				return;
			_menuButtons = value;
			menuButtonSprite.removeChildren();
			menuButtonSprite.addChild(scrollAreaBackground);
			
			for( var i:int = 0; i <menuButtons.length; i++)
			{
				var ab:RotatingIconButton = menuButtons[i];
				ab.y = i*(ab.height+gap);
				menuButtonSprite.addChild(ab);
			}
			
			var sabg:Graphics = scrollAreaBackground.graphics;
			var bounds:Rectangle = getFullBounds(menuButtonSprite);
			sabg.clear();
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(buttonMaskWidth,bounds.height,Math.PI/2);
			sabg.beginGradientFill(GradientType.LINEAR,[0x000000,0x000088,0x000000],[1,1,1],[0,128,255],matrix);
			sabg.drawRect(0,0,buttonMaskWidth,bounds.height);
			sabg.endFill();
			scrollAreaBackground.cacheAsBitmap = true;
		}
		public function get menuButtons():Array
		{
			return _menuButtons;
		}
		
		//--------------------------------------------------------------------------------
		//				Handlers
		//--------------------------------------------------------------------------------
		protected function addedHandler(event:Event):void
		{
			if(!stage)
				return;
			removeEventListener(TouchEvent.TOUCH_BEGIN, beganTouchingMenu);
			removeEventListener(TouchEvent.TOUCH_MOVE, moveTouchingMenu);
			removeEventListener(TouchEvent.TOUCH_END, endTouchingMenu);
			removeEventListener(TouchEvent.TOUCH_BEGIN, blockEvent);
			removeEventListener(TouchEvent.TOUCH_MOVE, blockEvent);
			removeEventListener(TouchEvent.TOUCH_END, blockEvent);
			if(getFullBounds(menuButtonSprite).height>menuButtonSprite.scrollRect.height)
			{
				addEventListener(TouchEvent.TOUCH_BEGIN, beganTouchingMenu);
				addEventListener(TouchEvent.TOUCH_MOVE, moveTouchingMenu);
				addEventListener(TouchEvent.TOUCH_END, endTouchingMenu);
			}
			else
			{
				addEventListener(TouchEvent.TOUCH_BEGIN, blockEvent);
				addEventListener(TouchEvent.TOUCH_MOVE, blockEvent);
				addEventListener(TouchEvent.TOUCH_END, blockEvent);
			}
			
		}
		protected function beganTouchingMenu(event:TouchEvent):void
		{
			event.stopImmediatePropagation();
			menuMoved = false;
			menuButtonsTouchStartPoint = new Point(event.stageX,event.stageY);
		}
		
		protected function moveTouchingMenu(event:TouchEvent):void
		{
			event.stopImmediatePropagation();
			if(!menuButtonsTouchStartPoint)
				return;
			
			yChange = menuButtonsTouchStartPoint.y - event.stageY;
			
			if(yChange>0)
			{
				trace("ychange is positive",yChange);
			}
			else
			{
				trace("ychange is negative",yChange);
			}
			
			if(menuMoved||yChange > 10||yChange<-10)
			{
				model.menuMoving = menuMoved = true;
				menuButtonsTouchStartPoint.y = event.stageY;
				//menuButtonSprite.scrollRect.y += yChange;
				var rect:Rectangle = menuButtonSprite.scrollRect;
				rect.offset(0,yChange);
				menuButtonSprite.scrollRect=rect;
				if(yChange>0 && menuButtonSprite.scrollRect.y>getFullBounds(menuButtonSprite).height-menuButtonSprite.height)
				{
					rect = menuButtonSprite.scrollRect;
					rect.y = getFullBounds(menuButtonSprite).height-menuButtonSprite.height;
					menuButtonSprite.scrollRect = rect;
					menuButtonsTouchStartPoint.y = event.stageY;
					menuMoved = false;
					model.menuMoving=true;
					Actuate.tween(glowDown,1,{alpha:1}).onComplete(function():void{Actuate.tween(glowDown,.5,{alpha:0})});
				}
				else if(yChange<0 && menuButtonSprite.scrollRect.y<0)
				{
					rect = menuButtonSprite.scrollRect;
					rect.y = 0;
					menuButtonSprite.scrollRect = rect;
					
					menuButtonsTouchStartPoint.y = event.stageY;
					menuMoved = false;
					model.menuMoving=true;
					Actuate.tween(glowUp,1,{alpha:1}).onComplete(function():void{Actuate.tween(glowUp,.5,{alpha:0})});
				}
				
				/*if(yChange>0 && y+height<=stage.fullScreenHeight-40)
				{	
				y = stage.fullScreenHeight-40-height;
				menuButtonsTouchStartPoint.y = event.stageY;
				}*/
			}
		}
		
		protected function endTouchingMenu(event:TouchEvent):void
		{
			event.stopImmediatePropagation();
			//if(menuMoved)
			if(model.menuMoving)
			{
				setTimeout(function():void{model.menuMoving = false},100);
			}
			menuButtonsTouchStartPoint = null;
		}
		protected function blockEvent(event:TouchEvent):void
		{
			event.stopImmediatePropagation();
		}
		
		//--------------------------------------------------------------------------------
		//				Helper functions
		//--------------------------------------------------------------------------------
		private function drawMask():void
		{
			if(isNaN(buttonMaskHeight) || isNaN(buttonMaskWidth))
				return;
			menuButtonSprite.scrollRect = new Rectangle(0,0,buttonMaskWidth,buttonMaskHeight);
			
			menuButtonMask.graphics.clear();
			menuButtonMask.graphics.beginFill(0xFF0000);
			menuButtonMask.graphics.drawRect(0,0,buttonMaskWidth,buttonMaskHeight);
		}
		private function drawGlows(widthValue:Number):void
		{
			glowDown.graphics.clear();
			glowDown.graphics.beginBitmapFill(BitmapReference._glowDownSliceBmp.bitmapData);
			glowDown.graphics.drawRect(glowXOffset,0,widthValue-glowXOffset*2,31);
			glowDown.graphics.endFill();
			
			glowUp.graphics.clear();
			glowUp.graphics.beginBitmapFill(BitmapReference._glowUpSliceBmp.bitmapData);
			glowUp.graphics.drawRect(glowXOffset,0,widthValue-glowXOffset*2,31);
			glowUp.graphics.endFill();
		}

		/**
		 * This function works like DisplayObject.getBounds(), except it will find the full
		 * bounds of any display object, even after its scrollRect has been set.
		 *
		 * @param displayObject - a display object that may have a scrollRect applied
		 * @return a rectangle describing the dimensions of the unmasked content
		 */
		public function getFullBounds ( displayObject:DisplayObject ) :Rectangle
		{
			var bounds:Rectangle, transform:Transform,
			toGlobalMatrix:Matrix, currentMatrix:Matrix;
			
			transform = displayObject.transform;
			currentMatrix = transform.matrix;
			toGlobalMatrix = transform.concatenatedMatrix;
			toGlobalMatrix.invert();
			transform.matrix = toGlobalMatrix;
			
			bounds = transform.pixelBounds.clone();
			
			transform.matrix = currentMatrix;
			
			return bounds;
		}
		
	}
}