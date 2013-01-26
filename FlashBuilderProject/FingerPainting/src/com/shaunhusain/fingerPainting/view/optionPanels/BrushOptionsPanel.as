package com.shaunhusain.fingerPainting.view.optionPanels
{
	import com.shaunhusain.fingerPainting.tools.extras.BrushTip;
	import com.shaunhusain.fingerPainting.view.Box;
	import com.shaunhusain.fingerPainting.view.mobileUIControls.RelativeTouchSlider;
	import com.shaunhusain.fingerPainting.view.mobileUIControls.RotatingIconButton;
	import com.shaunhusain.fingerPainting.view.mobileUIControls.TouchSlider;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.utils.Timer;

	public class BrushOptionsPanel extends PanelBase
	{
		//--------------------------------------------------------------------------------
		//				Embeds
		//--------------------------------------------------------------------------------
		[Embed(source="/images/transparencyFill.png")]
		private static var _transparencyFillClass:Class;
		public static var _transparencyFillBmp:Bitmap = new _transparencyFillClass();
		[Embed(source="/images/circleBackground.png")]
		private static var _circleBackgroundClass:Class;
		public static var _circleBackgroundBmp:Bitmap = new _circleBackgroundClass();
		[Embed(source="/images/circleBackgroundSelected.png")]
		private static var _circleBackgroundSelectedClass:Class;
		public static var _circleBackgroundSelectedBmp:Bitmap = new _circleBackgroundSelectedClass();
		[Embed(source="/images/pressureSensitive.png")]
		private static var _pressureSensitiveClass:Class;
		public static var _pressureSensitiveBmp:Bitmap = new _pressureSensitiveClass();
		[Embed(source="/images/xMirror.png")]
		private static var _xMirrorClass:Class;
		public static var _xMirrorBmp:Bitmap = new _xMirrorClass();
		[Embed(source="/images/yMirror.png")]
		private static var _yMirrorClass:Class;
		public static var _yMirrorBmp:Bitmap = new _yMirrorClass();
		
		//--------------------------------------------------------------------------------
		//				Variables
		//--------------------------------------------------------------------------------
		protected var pressureButton:RotatingIconButton;
		protected var xMirrorButton:RotatingIconButton;
		protected var yMirrorButton:RotatingIconButton;
		protected var brushSizeSlider:RelativeTouchSlider;
		protected var brushOpacitySlider:RelativeTouchSlider;
		protected var brushHardnessSlider:RelativeTouchSlider;
		protected var brushSizeExample:Bitmap;
		protected var brushSizeExampleData:BitmapData;
		protected var registeredEventListeners:Boolean;
		protected var exampleContainer:Box;
		protected var toggleButtonsContainer:Box;
		protected var outerContainer:Box;
		protected var controlContainer:Box;
		private var brushTip:BrushTip;
		private var isBrushDirty:Boolean;
		private var updateBrushTimer:Timer;
		
		//--------------------------------------------------------------------------------
		//				Constructor
		//--------------------------------------------------------------------------------
		public function BrushOptionsPanel(brushTip:BrushTip)
		{
			super();
			
			titleBackground.text = "Brush\nOptions";
			this.brushTip = brushTip;
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			updateBrushTimer = new Timer(100);
			updateBrushTimer.addEventListener(TimerEvent.TIMER,enterFrameHandler);
			updateBrushTimer.start();
		}
		
		
		//--------------------------------------------------------------------------------
		//				Handlers
		//--------------------------------------------------------------------------------
		private function addedToStageHandler(event:Event):void
		{
			
			if(!outerContainer)
			{
				outerContainer = new Box();
				outerContainer.gap = 10;
				outerContainer.x = 50;
				outerContainer.y = 50;
				addChild(outerContainer);
			}
			
			if(!toggleButtonsContainer)
			{
				toggleButtonsContainer = new Box();
				toggleButtonsContainer.gap = 10;
				toggleButtonsContainer.direction = "horizontal"
				outerContainer.addChild(toggleButtonsContainer);
			}
			
			
			if(!xMirrorButton)
			{
				xMirrorButton = new RotatingIconButton(_xMirrorBmp, null, false, true, true, _circleBackgroundBmp, _circleBackgroundSelectedBmp);
				xMirrorButton.toggles = true;
				xMirrorButton.addEventListener("buttonClicked", xMirrorButtonHandler);
				toggleButtonsContainer.addChild(xMirrorButton);
			}
			
			if(!yMirrorButton)
			{
				yMirrorButton = new RotatingIconButton(_yMirrorBmp, null, false, true, true, _circleBackgroundBmp, _circleBackgroundSelectedBmp);
				yMirrorButton.toggles = true;
				yMirrorButton.addEventListener("buttonClicked", yMirrorButtonHandler);
				toggleButtonsContainer.addChild(yMirrorButton);
			}
			
			if(!pressureButton)
			{
				pressureButton = new RotatingIconButton(_pressureSensitiveBmp, null, false, true, true, _circleBackgroundBmp, _circleBackgroundSelectedBmp);
				pressureButton.toggles = true;
				pressureButton.addEventListener("buttonClicked", pressureButtonHandler);
				toggleButtonsContainer.addChild(pressureButton);
			}
			
			if(!exampleContainer)
			{
				exampleContainer = new Box();
				exampleContainer.gap = 80;
				exampleContainer.direction = "horizontal"
				outerContainer.addChild(exampleContainer);
			}
			
			if(!controlContainer)
			{
				controlContainer = new Box();
				controlContainer.gap = 20;
				exampleContainer.addChild(controlContainer);
			}
			
			if(!brushSizeSlider)
			{
				brushSizeSlider = new RelativeTouchSlider();
				brushSizeSlider.addEventListener(TouchSlider.VALUE_CHANGED, updateBrushSampleSize);
				brushSizeSlider.minimum = 1;
				brushSizeSlider.maximum = 150;
				brushSizeSlider.titleLabelText = "Size";
				brushSizeSlider.units = "px";
				controlContainer.addChild(brushSizeSlider);
			}
			
			if(!brushOpacitySlider)
			{
				brushOpacitySlider = new RelativeTouchSlider();
				brushOpacitySlider.addEventListener(TouchSlider.VALUE_CHANGED, updateBrushOpacity);
				brushOpacitySlider.maximum = 1;
				brushOpacitySlider.decimalsToShow = 2;
				brushOpacitySlider.dispAsPercent = true;
				brushOpacitySlider.titleLabelText = "Opacity";
				controlContainer.addChild(brushOpacitySlider);
			}
			
			if(!brushHardnessSlider)
			{
				brushHardnessSlider = new RelativeTouchSlider();
				brushHardnessSlider.addEventListener(TouchSlider.VALUE_CHANGED, updateBrushHardness);
				brushHardnessSlider.maximum = 1;
				brushHardnessSlider.decimalsToShow = 2;
				brushHardnessSlider.dispAsPercent = true;
				brushHardnessSlider.titleLabelText = "Hardness";
				controlContainer.addChild(brushHardnessSlider);
			}
			
			if(!brushSizeExample)
			{
				brushSizeExampleData = new BitmapData(150,400);
				brushSizeExample = new Bitmap(brushSizeExampleData);
				
				exampleContainer.addChild(brushSizeExample);
			}
			
			if(!registeredEventListeners)
			{
				addEventListener(TouchEvent.TOUCH_TAP, blockEvent);
				addEventListener(TouchEvent.TOUCH_ROLL_OUT, blockEvent);
				registeredEventListeners = true;
			}
			
			drawBrush();
			updateValues();
		}
		
		protected function enterFrameHandler(event:Event):void
		{
			if(isBrushDirty)
			{
				drawBrush();
				isBrushDirty = false;
			}
		}
		
		protected function pressureButtonHandler(event:Event):void
		{
			brushTip.isPressureSensitive = pressureButton.isSelected;
			isBrushDirty = true;
		}
		
		protected function yMirrorButtonHandler(event:Event):void
		{
			brushTip.isYMirrored = yMirrorButton.isSelected;
		}
		
		protected function xMirrorButtonHandler(event:Event):void
		{
			brushTip.isXMirrored = xMirrorButton.isSelected;
		}
		
		private function updateBrushSampleSize(event:Event):void
		{
			brushTip.width = brushSizeSlider.currentValue;
			isBrushDirty = true;
		}
		
		private function updateBrushOpacity(event:Event):void
		{
			brushTip.alpha = brushOpacitySlider.currentValue;
			isBrushDirty = true;
		}
		
		protected function updateBrushHardness(event:Event):void
		{
			brushTip.hardness = brushHardnessSlider.currentValue;
			isBrushDirty = true;
		}
		
		private function blockEvent(event:TouchEvent):void
		{
			event.stopImmediatePropagation();
		}
		
		//--------------------------------------------------------------------------------
		//				Helper functions
		//--------------------------------------------------------------------------------
		private function updateValues():void
		{
			if(!pressureButton)
				return;
			pressureButton.isSelected = brushTip.isPressureSensitive;
			xMirrorButton.isSelected = brushTip.isXMirrored;
			yMirrorButton.isSelected = brushTip.isYMirrored;
			
			brushSizeSlider.currentValue = brushTip.width;
			brushOpacitySlider.currentValue = brushTip.alpha;
			brushHardnessSlider.currentValue = brushTip.hardness;
			
			drawBrush();
		}
		
		private function drawBrush():void
		{
			//brushTip.stampMask(new Point(75,75),1,brushSizeExampleData);
			var tempSprite:Sprite = new Sprite();
			tempSprite.graphics.beginBitmapFill(_transparencyFillBmp.bitmapData);
			tempSprite.graphics.drawRect(0,0,brushSizeExampleData.width, brushSizeExampleData.height);
			brushSizeExampleData.draw(tempSprite);
			
			var gapBetweenChanges:Number = 20;
			var halfExampleHeight:Number = (brushSizeExample.height-150)/2;
			var leftOverDistance:Number = 0;
			var i:int;
			for(i=0; i < halfExampleHeight; i+=gapBetweenChanges)
			{
				leftOverDistance = brushTip.stampMaskLine(new Point(75,75+i), new Point(75,75+i+gapBetweenChanges), leftOverDistance, .3+.4*i/halfExampleHeight,brushSizeExampleData);
			}
			for(; i < halfExampleHeight*2; i+=gapBetweenChanges)
			{
				leftOverDistance = brushTip.stampMaskLine(new Point(75,75+i), new Point(75,75+i+gapBetweenChanges), leftOverDistance, .7-.4*(i-halfExampleHeight)/halfExampleHeight,brushSizeExampleData);
			}
		}
		
	}
}