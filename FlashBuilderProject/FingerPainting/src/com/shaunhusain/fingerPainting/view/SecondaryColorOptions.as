package com.shaunhusain.fingerPainting.view
{
	import com.shaunhusain.fingerPainting.model.PaintModel;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.events.TouchEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;

	public class SecondaryColorOptions extends Sprite
	{
		private var backgroundSprite:Sprite;
		
		private var hueBarSprite:Sprite;
		private var hueBar:Bitmap;
		private var hueText:TextField;
		
		private var lightAndSatGradientSprite:Sprite;
		private var lightAndSatGradient:Bitmap;
		
		private var model:PaintModel = PaintModel.getInstance();
		private var selectedHueBar:Bitmap;
		
		private var selectedColorHBar:Bitmap;
		private var selectedColorVBar:Bitmap;
		
		private var colorSample:Bitmap;
		
		private var requiresUpdate:Boolean;
		private var updateHSVTimer:Timer;
		
		public function SecondaryColorOptions()
		{
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		private function addedToStageHandler(event:Event):void
		{
			addEventListener(TouchEvent.TOUCH_MOVE, blockEvent);
			addEventListener(TouchEvent.TOUCH_TAP, blockEvent);
			addEventListener(TouchEvent.TOUCH_ROLL_OUT, blockEvent);
			
			backgroundSprite = new Sprite();
			backgroundSprite.graphics.clear();
			backgroundSprite.graphics.beginFill(0xeeeeee,.5);
			backgroundSprite.graphics.drawRoundRect(0,0,420,stage.fullScreenHeight-200,50,50);
			backgroundSprite.graphics.endFill();
			addChild(backgroundSprite);
			
			hueBar = new Bitmap(new BitmapData(360,100));
			hueBar.bitmapData.lock();
			var huesRect:Rectangle = new Rectangle(0,0,1,100); 
			for(var hue:int = 0,xPos:int = 0; hue <= 360; hue++,xPos+=1)
			{
				huesRect.x = xPos;
				hueBar.bitmapData.fillRect(huesRect,HSLtoRGB(1,hue,1,.5));
			}
			
			hueBar.bitmapData.unlock();
			
			hueBarSprite = new Sprite();
			hueBarSprite.addEventListener(TouchEvent.TOUCH_MOVE, hueBarTouchMoveHandler);
			addChild(hueBarSprite);
			hueBarSprite.x = 20;
			hueBarSprite.y = 20;
			
			hueBarSprite.addChild(hueBar);
			
			selectedHueBar = new Bitmap(new BitmapData(2,100,false,0xff000000));
			selectedHueBar.blendMode = BlendMode.INVERT;
			hueBarSprite.addChild(selectedHueBar);
			
			lightAndSatGradient = new Bitmap(new BitmapData(90,90));
			lightAndSatGradientSprite = new Sprite();
			lightAndSatGradientSprite.addChild(lightAndSatGradient);
			lightAndSatGradient.scaleX = lightAndSatGradient.scaleY = 4;
			lightAndSatGradientSprite.y = 140;
			lightAndSatGradientSprite.x = 20;
			addChild(lightAndSatGradientSprite);
			lightAndSatGradientSprite.addEventListener(TouchEvent.TOUCH_MOVE, lightAndSatGradientTouchMoveHandler);
			
			selectedColorHBar = new Bitmap(new BitmapData(360,2,false,0xff000000));
			selectedColorHBar.blendMode = BlendMode.INVERT;
			lightAndSatGradientSprite.addChild(selectedColorHBar);
			
			selectedColorVBar = new Bitmap(new BitmapData(2,360,false,0xff000000));
			selectedColorVBar.blendMode = BlendMode.INVERT;
			lightAndSatGradientSprite.addChild(selectedColorVBar);
			
			colorSample = new Bitmap(new BitmapData(200,100,false,model.currentColor));
			colorSample.y = 520;
			colorSample.x = 20;
			addChild(colorSample);
			/*hueText = new TextField();
			addChild(hueText)
			hueText.autoSize = TextFieldAutoSize.LEFT;
			hueText.y = 140;
			hueText.text = "testing";*/
			
			updateHSVTimer = new Timer(100);
			updateHSVTimer.addEventListener(TimerEvent.TIMER, timerHandler);
			updateHSVTimer.start();
		}
		
		private function timerHandler(event:Event):void
		{
			if(requiresUpdate)
			{
				drawLightAndSatGradient();
				requiresUpdate = false;
			}
		}
		
		private function hueBarTouchMoveHandler(event:TouchEvent):void
		{
			//hueText.text = allPossibleColors.bitmapData.getPixel32(event.localX,event.localY).toString();
			selectedHueBar.x = event.localX;
			event.stopImmediatePropagation();
			model.currentColor = lightAndSatGradient.bitmapData.getPixel32(selectedColorVBar.x/4,selectedColorHBar.y/4);
			colorSample.bitmapData.floodFill(0,0,model.currentColor);
			requiresUpdate=true;
		}
		private function lightAndSatGradientTouchMoveHandler(event:TouchEvent):void
		{
			//hueText.text = allPossibleColors.bitmapData.getPixel32(event.localX,event.localY).toString(); 
			selectedColorVBar.x = event.localX;
			selectedColorHBar.y = event.localY;
			model.currentColor = lightAndSatGradient.bitmapData.getPixel32(selectedColorVBar.x/4,selectedColorHBar.y/4);
			colorSample.bitmapData.floodFill(0,0,model.currentColor);
			event.stopImmediatePropagation();
		}
		private function blockEvent(event:TouchEvent):void
		{
			event.stopImmediatePropagation();
		}
		
		private function drawLightAndSatGradient():void
		{
			trace("drawingLightAndSatGradient");
			lightAndSatGradient.bitmapData.lock();
			for(var i:Number = 90; i >= 0; i--)
				for(var j:Number= 90; j >= 0; j--)
					lightAndSatGradient.bitmapData.setPixel32(i,90-j,HSVtoRGB(1,selectedHueBar.x,i/90,j/90));
			lightAndSatGradient.bitmapData.unlock();
		}
		
		private function HSLtoRGB(a:Number=1,hue:Number=0,saturation:Number=0.5,lightness:Number=1):uint{
			a = Math.max(0,Math.min(1,a));
			saturation = Math.max(0,Math.min(1,saturation));
			lightness = Math.max(0,Math.min(1,lightness));
			hue = hue%360;
			if(hue<0)hue+=360;
			hue/=60;
			var C:Number = (1-Math.abs(2*lightness-1))*saturation;
			var X:Number = C*(1-Math.abs((hue%2)-1));
			var m:Number = lightness-0.5*C;
			C=(C+m)*255;
			X=(X+m)*255;
			m*=255;
			if(hue<1) return (Math.round(a*255)<<24)+(C<<16)+(X<<8)+m;
			if(hue<2) return (Math.round(a*255)<<24)+(X<<16)+(C<<8)+m;
			if(hue<3) return (Math.round(a*255)<<24)+(m<<16)+(C<<8)+X;
			if(hue<4) return (Math.round(a*255)<<24)+(m<<16)+(X<<8)+C;
			if(hue<5) return (Math.round(a*255)<<24)+(X<<16)+(m<<8)+C;
			return (Math.round(a*255)<<24)+(C<<16)+(m<<8)+X;
		}
		
		private function HSVtoRGB(a:Number=1,hue:Number=0,saturation:Number=.5, value:Number = 1):uint
		{
			a = Math.max(0,Math.min(1,a));
			saturation = Math.max(0,Math.min(1,saturation));
			value = Math.max(0,Math.min(1,value));
			hue = hue%360;
			if(hue<0)hue+=360;
			hue/=60;
			var C:Number = value*saturation;
			var X:Number = C*(1-Math.abs((hue%2)-1));
			var m:Number = value-C;
			C=(C+m)*255;
			X=(X+m)*255;
			m*=255;
			if(hue<1) return (Math.round(a*255)<<24)+(C<<16)+(X<<8)+m;
			if(hue<2) return (Math.round(a*255)<<24)+(X<<16)+(C<<8)+m;
			if(hue<3) return (Math.round(a*255)<<24)+(m<<16)+(C<<8)+X;
			if(hue<4) return (Math.round(a*255)<<24)+(m<<16)+(X<<8)+C;
			if(hue<5) return (Math.round(a*255)<<24)+(X<<16)+(m<<8)+C;
			return (Math.round(a*255)<<24)+(C<<16)+(m<<8)+X;
		}
		
		public function setConnectionYPosition(value:Number):void
		{
			backgroundSprite.graphics.clear();
			backgroundSprite.graphics.beginFill(0xeeeeee);
			backgroundSprite.graphics.drawRoundRect(0,0,638,stage.fullScreenHeight-200,100,100);
			backgroundSprite.graphics.drawRect(638,value,300,130);
			backgroundSprite.graphics.endFill();
		}
	}
}