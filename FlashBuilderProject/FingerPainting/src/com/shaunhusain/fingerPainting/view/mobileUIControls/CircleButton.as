package com.shaunhusain.fingerPainting.view.mobileUIControls
{
	import com.shaunhusain.fingerPainting.managers.AccelerometerManager;
	import com.shaunhusain.fingerPainting.model.PaintModel;
	
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.AccelerometerEvent;
	import flash.events.TouchEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextLineMetrics;
	
	public class CircleButton extends Sprite
	{
		private var buttonBackground:Sprite;
		
		private var textField:TextField;
		private var textFormat:TextFormat;
		private var textContainer:Sprite;
		
		// to embed a system font
		[Embed(source="/SourceCodePro-Bold.ttf", fontName = "myFont", mimeType = "application/x-font", fontStyle="normal", unicodeRange="U+0020-007E", advancedAntiAliasing="true", embedAsCFF="false")]
		private var myEmbeddedFont:Class;
		
		private var _text:String;
		public function set text(value:String):void
		{
			if(value==_text)
				return;
			
			_text = value;
			
			textField.text = _text;
			textField.setTextFormat(textFormat);
			var textLineMetrics:TextLineMetrics = textField.getLineMetrics(0);
			var boundsRect:Rectangle = textField.getBounds(this);
			textField.x = -boundsRect.width/2;
			textField.y = -boundsRect.height/2;
		}
		
		private var _selected:Boolean;
		public function set selected(value:Boolean):void
		{
			_selected=value;
			buttonBackground.graphics.clear();
			if(value)
				buttonBackground.graphics.beginFill(0x00FF00);
			else
				buttonBackground.graphics.beginFill(0xFF0000);
			buttonBackground.graphics.drawCircle(90,90,90);
			buttonBackground.graphics.endFill();
		}
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function CircleButton()
		{
			super();
			
			buttonBackground = new Sprite();
			
			buttonBackground.graphics.clear();
			buttonBackground.graphics.beginFill(0xFF0000);
			buttonBackground.graphics.drawCircle(90,90,90);
			buttonBackground.graphics.endFill();
			addChild(buttonBackground);
			
			textContainer = new Sprite();
			
			textFormat = new TextFormat();
			textFormat.size = 36;
			textFormat.font = "myFont";
			
			textField = new TextField();
			textField.blendMode = BlendMode.INVERT;
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.embedFonts = true;
			textContainer.addChild(textField);
			
			textContainer.x = 90;
			textContainer.y = 90;
			addChild(textContainer);
			textContainer.rotation=45;
			
			var accManager:AccelerometerManager = AccelerometerManager.getIntance();
			accManager.addEventListener(AccelerometerEvent.UPDATE, handleAccelerometerChange);
			
			addEventListener(TouchEvent.TOUCH_TAP, handleButtonTapped);
			
		}
		
		private function handleButtonTapped(event:TouchEvent):void
		{
			PaintModel.getInstance().isPressureSensitive = selected = !selected;
			event.stopImmediatePropagation();
		}
		
		private function handleAccelerometerChange(event:AccelerometerEvent):void
		{
			if(Math.abs(event.accelerationZ)<.9)
			{
				var angle:Number = Math.atan2(event.accelerationY, event.accelerationX);
				angle-=Math.PI/2;
				angle = -angle;
				textContainer.rotation = angle*180/Math.PI;
			}
		}
	}
}