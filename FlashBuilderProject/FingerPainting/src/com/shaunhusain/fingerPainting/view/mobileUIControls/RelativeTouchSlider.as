package com.shaunhusain.fingerPainting.view.mobileUIControls
{
	import com.eclecticdesignstudio.motion.Actuate;
	import com.eclecticdesignstudio.motion.actuators.GenericActuator;
	import com.shaunhusain.fingerPainting.events.AccBasedOrientationEvent;
	import com.shaunhusain.fingerPainting.managers.AccelerometerManager;
	
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.AccelerometerEvent;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.events.TouchEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	public class RelativeTouchSlider extends Sprite
	{
		[Embed(source="/Roboto-Condensed.ttf", fontName = "myFont", mimeType = "application/x-font", fontStyle="normal", unicodeRange="U+0020-007E", advancedAntiAliasing="true", embedAsCFF="true")]
		private var myEmbeddedFont:Class;
		
		//--------------------------------------------------------------------------------
		//				Constants
		//--------------------------------------------------------------------------------
		public static const VALUE_CHANGED:String="valueChanged";
		private const BAR_TOP_OFFSET:Number = 35;
		
		//--------------------------------------------------------------------------------
		//				Embeds
		//--------------------------------------------------------------------------------
		[Embed(source="/images/relativeSliderThumb.png")]
		private static var _thumbClass:Class;
		public static var _thumbBmp:Bitmap = new _thumbClass();
		[Embed(source="/images/relativeSliderTrack.png")]
		private static var _trackClass:Class;
		public static var _trackBmp:Bitmap = new _trackClass();
		[Embed(source="/images/sliderBackground.png")]
		private static var _sliderBackgroundClass:Class;
		public static var _sliderBackgroundBmp:Bitmap = new _sliderBackgroundClass();
		
		//--------------------------------------------------------------------------------
		//				UI Elements
		//--------------------------------------------------------------------------------
		protected var background:Bitmap;
		protected var rotateContentContainer:Sprite;
		protected var thumb:Bitmap;
		protected var track:Bitmap;
		protected var hitAreaSprite:Sprite;
		protected var titleLabel:TextField;
		protected var valueLabel:TextField;
		
		//--------------------------------------------------------------------------------
		//				Variables
		//--------------------------------------------------------------------------------
		private var titleTextFormat:TextFormat;
		private var valueTextFormat:TextFormat;
		private var hasRegisteredListeners:Boolean;
		private var updateValueTimer:Timer;
		
		//--------------------------------------------------------------------------------
		//				Constructor
		//--------------------------------------------------------------------------------
		public function RelativeTouchSlider()
		{
			super();
			
			if(!background)
			{
				background = new Bitmap();
				background.bitmapData = _sliderBackgroundBmp.bitmapData;
				addChild(background);
			}
			
			if(!rotateContentContainer)
			{
				rotateContentContainer = new Sprite();
				addChild(rotateContentContainer);
			}
			
			if(!track)
			{
				track = new Bitmap();
				track.bitmapData = _trackBmp.bitmapData;
				track.y = BAR_TOP_OFFSET;
				track.x = 112;
				rotateContentContainer.addChild(track);
			}
			
			if(!thumb)
			{
				thumb = new Bitmap();
				thumb.bitmapData = _thumbBmp.bitmapData;
				thumb.x = 112;
				thumb.y = BAR_TOP_OFFSET + _trackBmp.height/2 - _thumbBmp.height/2;
				rotateContentContainer.addChild(thumb);
			}
			
			if(!hitAreaSprite)
			{
				hitAreaSprite = new Sprite();
				hitAreaSprite.visible = false;
				//hitAreaSprite.alpha = .5;
				hitAreaSprite.x = 112;
				hitAreaSprite.y = BAR_TOP_OFFSET;
				hitAreaSprite.mouseEnabled = false;
				rotateContentContainer.addChild(hitAreaSprite);
				this.hitArea = hitAreaSprite;
			}
			
			if(!titleTextFormat)
			{
				titleTextFormat = new TextFormat();
				titleTextFormat.font = "myFont";
				titleTextFormat.color = 0xFFFFFF;
				titleTextFormat.size = 34;
			}
			
			if(!valueTextFormat)
			{
				valueTextFormat = new TextFormat();
				valueTextFormat.font = "myFont";
				valueTextFormat.color = 0xFFFFFF;
				valueTextFormat.size = 42;
			}
			
			if(!titleLabel)
			{
				titleLabel = new TextField();
				titleLabel.cacheAsBitmap = true;
				titleLabel.mouseEnabled = false;
				titleLabel.embedFonts = true;
				titleLabel.autoSize = TextFieldAutoSize.CENTER;
				titleLabel.setTextFormat(titleTextFormat);
				titleLabel.x = 155;
				rotateContentContainer.addChild(titleLabel);
			}
			
			if(!valueLabel)
			{
				valueLabel = new TextField();
				valueLabel.mouseEnabled = false;
				valueLabel.embedFonts = true;
				valueLabel.autoSize = TextFieldAutoSize.LEFT;
				valueLabel.setTextFormat(valueTextFormat);
				valueLabel.y = 112;
				valueLabel.x = 9;
				rotateContentContainer.addChild(valueLabel);
			}
			
			drawGraphics();
			
			if(!hasRegisteredListeners)
			{
				rotateContentContainer.addEventListener(TouchEvent.TOUCH_BEGIN, touchBeginHandler);
				rotateContentContainer.addEventListener(TouchEvent.TOUCH_TAP, blockEvent);
				hasRegisteredListeners = true;
			}
			if(!updateValueTimer)
			{
				updateValueTimer = new Timer(33);
				updateValueTimer.addEventListener(TimerEvent.TIMER, updateValueTimerTicked);
			}
			var accManager:AccelerometerManager = AccelerometerManager.getIntance();
			accManager.addEventListener(AccelerometerEvent.UPDATE, handleAccelerometerChange);
			
			
			var locRot:Number;
			switch(accManager.currentOrientation)
			{
				case AccelerometerManager.PORTRAIT_DEFAULT:
					locRot = 0;
					break;
				case AccelerometerManager.PORTRAIT_FLIPPED:
					locRot = Math.PI;
					break;
				case AccelerometerManager.LANDSCAPE_LEFT:
					locRot = Math.PI/2;
					break;
				case AccelerometerManager.LANDSCAPE_RIGHT:
					locRot = -Math.PI/2;
					break;
			}
			
			var ge:GenericActuator = Actuate.tween(this, 1, {rotateAroundCenter:locRot});
			
			//setTimeout(fixRotation,200);
		}
		/*private function fixRotation():void
		{
			var locRot:Number;
			switch(AccelerometerManager.getIntance().currentOrientation)
			{
				case AccelerometerManager.PORTRAIT_DEFAULT:
					locRot = 0;
					break;
				case AccelerometerManager.PORTRAIT_FLIPPED:
					locRot = Math.PI;
					break;
				case AccelerometerManager.LANDSCAPE_LEFT:
					locRot = Math.PI/2;
					break;
				case AccelerometerManager.LANDSCAPE_RIGHT:
					locRot = -Math.PI/2;
					break;
			}
			rotateAroundCenter = locRot;
		}*/
		//--------------------------------------------------------------------------------
		//				Properties
		//--------------------------------------------------------------------------------
		private var _units:String;

		public function get units():String
		{
			return _units;
		}

		public function set units(value:String):void
		{
			if(_units == value)
				return;
			_units = value;
			
			updateCurrentValueLabel();
		}

		
		private var _currentValue:Number;
		public function set currentValue(value:Number):void
		{
			if(value>maximum)
				value = maximum;
			else if(value<minimum)
				value = minimum;
			
			if(_currentValue==value)
				return;
			
			//calculate current value based on max/min and current percentage
			_currentValue = value;
			
			//update the label
			updateCurrentValueLabel();
			
			//dispatch change event
			if(liveScrolling)
				dispatchEvent(new Event("valueChanged"));
		}
		public function get currentValue():Number
		{
			return _currentValue;
		}
		
		private var _titleLabelText:String;
		public function set titleLabelText(value:String):void
		{
			if(_titleLabelText==value)
				return;
			titleLabel.text = _titleLabelText = value;
			titleLabel.setTextFormat(titleTextFormat);
		}
		public function get titleLabelText():String
		{
			return _titleLabelText;
		}
		
		private var _maximum:Number = 100;

		public function get maximum():Number
		{
			return _maximum;
		}

		public function set maximum(value:Number):void
		{
			_maximum = value;
		}

		private var _minimum:Number = 0;
		public function get minimum():Number
		{
			return _minimum;
		}
		public function set minimum(value:Number):void
		{
			_minimum = value;
		}
		
		private var _decimalsToShow:Number=0;

		public function get decimalsToShow():Number
		{
			return _decimalsToShow;
		}

		public function set decimalsToShow(value:Number):void
		{
			_decimalsToShow = value;
			updateCurrentValueLabel();
		}
		
		private var _dispAsPercent:Boolean;

		public function get dispAsPercent():Boolean
		{
			return _dispAsPercent;
		}

		public function set dispAsPercent(value:Boolean):void
		{
			_dispAsPercent = value;
		}
		
		private var _rotateAroundCenter:Number = 0;
		public function set rotateAroundCenter (angleRadians:Number):void
		{
			_rotateAroundCenter = angleRadians;
			
			var thisMatrix:Matrix = rotateContentContainer.transform.matrix.clone();
			thisMatrix.identity();
			thisMatrix.tx -= 122;
			thisMatrix.ty -= 122;
			thisMatrix.rotate (angleRadians);
			thisMatrix.tx += 122;
			thisMatrix.ty += 122;
			
			rotateContentContainer.transform.matrix = thisMatrix;
		}
		public function get rotateAroundCenter():Number
		{
			return _rotateAroundCenter;
		}
		
		private var _liveScrolling:Boolean = true;

		public function get liveScrolling():Boolean
		{
			return _liveScrolling;
		}

		public function set liveScrolling(value:Boolean):void
		{
			_liveScrolling = value;
		}

		
		//--------------------------------------------------------------------------------
		//				Handlers
		//--------------------------------------------------------------------------------
		private function handleAccelerometerChange(event:AccBasedOrientationEvent):void
		{
			var locRot:Number;
			switch(event.newOrientation)
			{
				case AccelerometerManager.PORTRAIT_DEFAULT:
					locRot = 0;
					break;
				case AccelerometerManager.PORTRAIT_FLIPPED:
					locRot = Math.PI;
					break;
				case AccelerometerManager.LANDSCAPE_LEFT:
					locRot = Math.PI/2;
					break;
				case AccelerometerManager.LANDSCAPE_RIGHT:
					locRot = -Math.PI/2;
					break;
			}
			
			//rotateAroundCenter = locRot;
			var ge:GenericActuator = Actuate.tween(this, 1, {rotateAroundCenter:locRot});
			//rotateAroundCenter = event.linearRotation;
		}
		
		protected function updateValueTimerTicked(event:TimerEvent):void
		{
			var offsetY:Number = BAR_TOP_OFFSET+track.height/2 - (thumb.y+thumb.height/2);
			
			currentValue += offsetY * (maximum-minimum)/10000;
		}
		
		private function handleSliding(event:TouchEvent):void
		{
			Actuate.stop(thumb, ["y"]);
			thumb.y = getThumbPosition(event);
			event.stopImmediatePropagation();
		}
		
		protected function touchEndHandler(event:TouchEvent):void
		{
			stage.removeEventListener(TouchEvent.TOUCH_MOVE, handleSliding);
			stage.removeEventListener(TouchEvent.TOUCH_END, touchEndHandler);
			updateValueTimer.stop();
			
			if(!liveScrolling)
				dispatchEvent(new Event("valueChanged"));
			
			var ge:GenericActuator = Actuate.tween(thumb, .5, {y:track.height/2 - thumb.height/2+BAR_TOP_OFFSET});
			
		}
		
		protected function touchBeginHandler(event:TouchEvent):void
		{
			if(updateValueTimer.running)
				return;
			stage.addEventListener(TouchEvent.TOUCH_MOVE, handleSliding);
			stage.addEventListener(TouchEvent.TOUCH_END, touchEndHandler);
			
			updateValueTimer.start();
			
			Actuate.stop(thumb, ["y"]);
			
			Actuate.tween(thumb, .5, {y:getThumbPosition(event)});
		}		
		
		private function getThumbPosition(event:TouchEvent):Number
		{
			var adjustedPoint:Point = rotateContentContainer.globalToLocal(new Point(event.stageX,event.stageY));
			var propertyToChange:String;
			
			var correctedY:Number = adjustedPoint.y;
			
			if(correctedY<BAR_TOP_OFFSET-_thumbBmp.height/2)
				correctedY = BAR_TOP_OFFSET-_thumbBmp.height/2;
			if(correctedY>track.height+BAR_TOP_OFFSET-_thumbBmp.height/2)
				correctedY = track.height+BAR_TOP_OFFSET-_thumbBmp.height/2;
			return correctedY;
		}
		private function blockEvent(event:TouchEvent):void
		{
			event.stopImmediatePropagation();
		}
		//--------------------------------------------------------------------------------
		//				Helper Functions
		//--------------------------------------------------------------------------------
		private function updateCurrentValueLabel():void
		{
			if(dispAsPercent)
				valueLabel.text = Math.floor(_currentValue*100) + "%";
			else	
				valueLabel.text = _currentValue.toFixed(decimalsToShow);
			if(units)
				valueLabel.text += units;
			valueLabel.setTextFormat(valueTextFormat);
		}
		
		protected function drawGraphics():void
		{
			var hasg:Graphics = hitAreaSprite.graphics;
			hasg.clear();
			hasg.beginFill(0xFF0000);
			hasg.drawRect(0,0, _trackBmp.width,_trackBmp.height);
			hasg.endFill();
		}
	}
}