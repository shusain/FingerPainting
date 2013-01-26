package com.shaunhusain.fingerPainting.view.mobileUIControls
{
	import com.eclecticdesignstudio.motion.Actuate;
	import com.shaunhusain.fingerPainting.events.AccBasedOrientationEvent;
	import com.shaunhusain.fingerPainting.managers.AccelerometerManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.AccelerometerEvent;
	import flash.events.Event;
	import flash.events.TouchEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextLineMetrics;
	
	public class CircleButton extends Sprite
	{
		
		//--------------------------------------------------------------------------------
		//				Variables
		//--------------------------------------------------------------------------------
		private var buttonBackground:Bitmap;
		
		private var textField:TextField;
		private var textContainer:Sprite;
		
		// to embed a system font
		[Embed(source="/Roboto-Condensed.ttf", fontName = "myFont", mimeType = "application/x-font", fontStyle="normal", unicodeRange="U+0020-007E", advancedAntiAliasing="true", embedAsCFF="false")]
		private var myEmbeddedFont:Class;
		
		//--------------------------------------------------------------------------------
		//				Constructor
		//--------------------------------------------------------------------------------
		public function CircleButton(backgroundBitmap:BitmapData = null, backgroundBitmapSelected:BitmapData = null, textFormat:TextFormat = null)
		{
			super();
			
			if(backgroundBitmap)
				this.backgroundBitmap = backgroundBitmap;
			if(backgroundBitmapSelected)
				this.backgroundBitmapSelected = backgroundBitmapSelected;
			
			drawBackground();
			
			buttonBackground = new Bitmap();
			buttonBackground.bitmapData = this.backgroundBitmap;
			
			addChild(buttonBackground);
			
			textContainer = new Sprite();
			
			if(textFormat)
			{
				this.textFormat = textFormat;
			}
			else
			{
				this.textFormat = new TextFormat();
				this.textFormat.size = 24;
				this.textFormat.font = "myFont";
			}
			
			textField = new TextField();
			textField.blendMode = BlendMode.INVERT;
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.mouseEnabled = false;
			textField.embedFonts = true;
			textContainer.addChild(textField);
			
			textContainer.x = this.backgroundBitmap.width/2;
			textContainer.y = this.backgroundBitmap.width/2;
			addChild(textContainer);
			
			var accManager:AccelerometerManager = AccelerometerManager.getIntance();
			accManager.addEventListener(AccelerometerEvent.UPDATE, handleAccelerometerChange);
			
			var locRot:Number;
			switch(accManager.currentOrientation)
			{
				case AccelerometerManager.PORTRAIT_DEFAULT:
					locRot = 0;
					break;
				case AccelerometerManager.PORTRAIT_FLIPPED:
					locRot = 180;
					break;
				case AccelerometerManager.LANDSCAPE_LEFT:
					locRot = 90;
					break;
				case AccelerometerManager.LANDSCAPE_RIGHT:
					locRot = -90;
					break;
			}
			textContainer.rotation = locRot;
			
			addEventListener(TouchEvent.TOUCH_TAP, handleButtonTapped);
			
		}
		
		//--------------------------------------------------------------------------------
		//				Properties
		//--------------------------------------------------------------------------------
		private var _text:String;
		public function set text(value:String):void
		{
			if(_text==value)
				return;
			
			_text = value;
			
			
			textField.text = _text;
			textField.setTextFormat(textFormat);
			
			var maxWidth:Number = 0;
			for(var i:int = 0; i<textField.numLines; i++)
			{
				
				var textLineMetrics:TextLineMetrics = textField.getLineMetrics(i);
				maxWidth = Math.max(maxWidth, textLineMetrics.width);
			}
			
			textField.x = -maxWidth/2;
			textField.y = -textLineMetrics.height*textField.numLines/2;
		}
		
		private var _selected:Boolean;
		public function set selected(value:Boolean):void
		{
			if(_selected == value)
				return;
			_selected=value;
			buttonBackground.bitmapData = selected?backgroundBitmapSelected:backgroundBitmap;
		}
		public function get selected():Boolean
		{
			return _selected;
		}
		
		private var _circleRadius:Number = 55;

		public function get circleRadius():Number
		{
			return _circleRadius;
		}

		public function set circleRadius(value:Number):void
		{
			if(_circleRadius == value)
				return;
			_circleRadius = value;
			textContainer.x = textContainer.y = value;
			backgroundBitmap.dispose();
			backgroundBitmap = null;
			backgroundBitmapSelected.dispose();
			backgroundBitmapSelected = null;
			drawBackground();
		}
		private var _backgroundBitmap:BitmapData;

		public function get backgroundBitmap():BitmapData
		{
			return _backgroundBitmap;
		}

		public function set backgroundBitmap(value:BitmapData):void
		{
			_backgroundBitmap = value;
		}

		private var _backgroundBitmapSelected:BitmapData;

		public function get backgroundBitmapSelected():BitmapData
		{
			return _backgroundBitmapSelected;
		}

		public function set backgroundBitmapSelected(value:BitmapData):void
		{
			_backgroundBitmapSelected = value;
		}
		
		private var _textFormat:TextFormat;

		public function get textFormat():TextFormat
		{
			return _textFormat;
		}

		public function set textFormat(value:TextFormat):void
		{
			_textFormat = value;
		}
		

		
		//--------------------------------------------------------------------------------
		//				Handlers
		//--------------------------------------------------------------------------------
		private function handleButtonTapped(event:TouchEvent):void
		{
			selected = !selected;
			event.stopImmediatePropagation();
			dispatchEvent(new Event("circleButtonClicked"));
		}
		private function handleAccelerometerChange(event:AccBasedOrientationEvent):void
		{
			
			var locRot:Number;
			switch(event.newOrientation)
			{
				case AccelerometerManager.PORTRAIT_DEFAULT:
					locRot = 0;
					break;
				case AccelerometerManager.PORTRAIT_FLIPPED:
					locRot = 180;
					break;
				case AccelerometerManager.LANDSCAPE_LEFT:
					locRot = 90;
					break;
				case AccelerometerManager.LANDSCAPE_RIGHT:
					locRot = -90;
					break;
			}
			//textContainer.rotation = locRot;
			
			Actuate.tween(textContainer, 1, {rotation:locRot});
		}
		private function drawBackground():void
		{
			//Already has data to use for backgrounds
			if(backgroundBitmap && backgroundBitmapSelected)
				return;
			
			var tempSprite:Sprite = new Sprite();
			if(!backgroundBitmap)
			{
				tempSprite.graphics.clear();
				tempSprite.graphics.beginFill(0xFF0000);
				tempSprite.graphics.drawCircle(circleRadius,circleRadius,circleRadius);
				tempSprite.graphics.endFill();
				backgroundBitmap = new BitmapData(circleRadius*2,circleRadius*2, true, 0x00000000);
				backgroundBitmap.draw(tempSprite);
			}
			
			if(!backgroundBitmapSelected)
			{
				tempSprite.graphics.clear();
				tempSprite.graphics.beginFill(0x00FF00);
				tempSprite.graphics.drawCircle(circleRadius,circleRadius,circleRadius);
				tempSprite.graphics.endFill();
				backgroundBitmapSelected = new BitmapData(circleRadius*2,circleRadius*2, true, 0x00000000);
				backgroundBitmapSelected.draw(tempSprite);
			}
		}
	}
}