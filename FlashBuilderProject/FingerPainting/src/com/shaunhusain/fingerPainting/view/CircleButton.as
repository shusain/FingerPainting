package com.shaunhusain.fingerPainting.view
{
	import com.shaunhusain.fingerPainting.model.PaintModel;
	import com.shaunhusain.mobileUIControls.AccelerometerManager;
	
	import flash.display.Sprite;
	import flash.events.AccelerometerEvent;
	import flash.events.TouchEvent;
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
		[Embed(systemFont="Arial", fontName = "myFont", mimeType = "application/x-font", fontWeight="normal", fontStyle="normal", unicodeRange="U+0020-007E", advancedAntiAliasing="true", embedAsCFF="false")]
		private var myEmbeddedFont:Class;
		
		
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
			textField.text = "Pressure\nSensitive";
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.embedFonts = true;
			textField.setTextFormat(textFormat);
			var textLineMetrics:TextLineMetrics = textField.getLineMetrics(0);
			textField.x = -textLineMetrics.width/2;
			textField.y = -textLineMetrics.height;
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