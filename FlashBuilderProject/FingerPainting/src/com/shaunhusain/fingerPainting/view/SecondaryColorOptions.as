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
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.Timer;

	public class SecondaryColorOptions extends Sprite
	{
		//--------------------------------------------------------------------------------
		//				Variables
		//--------------------------------------------------------------------------------
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
		
		protected var eventHandlersRegistered:Boolean;
		
		//--------------------------------------------------------------------------------
		//				Constructor
		//--------------------------------------------------------------------------------
		public function SecondaryColorOptions()
		{
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		//--------------------------------------------------------------------------------
		//				Handlers
		//--------------------------------------------------------------------------------
		private function addedToStageHandler(event:Event):void
		{
			if(!eventHandlersRegistered)
			{
				addEventListener(TouchEvent.TOUCH_MOVE, blockEvent);
				addEventListener(TouchEvent.TOUCH_END, blockEvent);
				addEventListener(TouchEvent.TOUCH_BEGIN, blockEvent);
				addEventListener(TouchEvent.TOUCH_TAP, blockEvent);
				addEventListener(TouchEvent.TOUCH_ROLL_OUT, blockEvent);
				eventHandlersRegistered=true;
			}
			
			if(!backgroundSprite)
			{
				backgroundSprite = new Sprite();
				backgroundSprite.graphics.clear();
				backgroundSprite.graphics.beginFill(0xeeeeee,.5);
				backgroundSprite.graphics.drawRoundRect(0,0,600,stage.fullScreenHeight-200,50,50);
				backgroundSprite.graphics.endFill();
				addChild(backgroundSprite);
			}
			
			if(!hueBar)
			{
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
				hueBarSprite.x = 100;
				hueBarSprite.y = 40;
				hueBarSprite.cacheAsBitmap = true;
				
				hueBarSprite.addChild(hueBar);
				selectedHueBar = new Bitmap(new BitmapData(2,100,false,0xff000000));
				selectedHueBar.blendMode = BlendMode.INVERT;
				hueBarSprite.addChild(selectedHueBar);
			}
			
			
			
			
			if(!lightAndSatGradient)
			{
				lightAndSatGradient = new Bitmap(new BitmapData(90,90));
				lightAndSatGradient.cacheAsBitmap = true;
				lightAndSatGradientSprite = new Sprite();
				lightAndSatGradientSprite.addChild(lightAndSatGradient);
				lightAndSatGradient.scaleX = lightAndSatGradient.scaleY = 4;
				lightAndSatGradientSprite.y = 200;
				lightAndSatGradientSprite.x = 100;
				addChild(lightAndSatGradientSprite);
				lightAndSatGradientSprite.addEventListener(TouchEvent.TOUCH_BEGIN, lightAndSatGradientTouchBeginHandler);
				lightAndSatGradientSprite.addEventListener(TouchEvent.TOUCH_END, lightAndSatGradientTouchEndHandler);
				
				selectedColorHBar = new Bitmap(new BitmapData(360,2,false,0xff000000));
				selectedColorHBar.blendMode = BlendMode.INVERT;
				lightAndSatGradientSprite.addChild(selectedColorHBar);
				
				selectedColorVBar = new Bitmap(new BitmapData(2,360,false,0xff000000));
				selectedColorVBar.x=359;
				selectedColorVBar.blendMode = BlendMode.INVERT;
				lightAndSatGradientSprite.addChild(selectedColorVBar);
			}
			
			
			if(!colorSample)
			{
				colorSample = new Bitmap(new BitmapData(200,100,false,model.currentColor));
				colorSample.y = 660;
				colorSample.x = 100;
				addChild(colorSample);
			}
			
			/*hueText = new TextField();
			addChild(hueText)
			hueText.autoSize = TextFieldAutoSize.LEFT;
			hueText.y = 140;
			hueText.text = "testing";*/
			
			updateHSVTimer = new Timer(50);
			updateHSVTimer.addEventListener(TimerEvent.TIMER, timerHandler);
			updateHSVTimer.start();
			
			requiresUpdate=true;
		}
		protected function lightAndSatGradientTouchEndHandler(event:TouchEvent):void
		{
			removeEventListener(TouchEvent.TOUCH_MOVE, lightAndSatGradientTouchMoveHandler);
		}
		
		protected function lightAndSatGradientTouchBeginHandler(event:TouchEvent):void
		{
			addEventListener(TouchEvent.TOUCH_MOVE, lightAndSatGradientTouchMoveHandler,false,int.MAX_VALUE);
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
			requiresUpdate=true;
		}
		private function lightAndSatGradientTouchMoveHandler(event:TouchEvent):void
		{
			//hueText.text = allPossibleColors.bitmapData.getPixel32(event.localX,event.localY).toString(); 
			//trace("got to move handler");
			var pointToUse:Point = new Point();
			if(event.target != lightAndSatGradientSprite)
			{
				pointToUse = lightAndSatGradientSprite.globalToLocal(new Point(event.stageX, event.stageY));
			}
			else
			{
				pointToUse.x = event.localX;
				pointToUse.y = event.localY;
			}
			
			if(pointToUse.x<0)
				pointToUse.x = 0;
			if(pointToUse.x>=360)
				pointToUse.x = 359;
			
			if(pointToUse.y<0)
				pointToUse.y = 0;
			if(pointToUse.y>=360)
				pointToUse.y = 359;
			
			selectedColorVBar.x = pointToUse.x;
			selectedColorHBar.y = pointToUse.y;
			
			event.stopImmediatePropagation();
			requiresUpdate=true;
		}
		private function blockEvent(event:TouchEvent):void
		{
			event.stopImmediatePropagation();
		}
		//--------------------------------------------------------------------------------
		//				Helper functions
		//--------------------------------------------------------------------------------
		private function drawLightAndSatGradient():void
		{
			//trace("drawingLightAndSatGradient");
			lightAndSatGradient.bitmapData.lock();
			for(var i:Number = 90; i >= 0; i--)
				for(var j:Number= 90; j >= 0; j--)
					lightAndSatGradient.bitmapData.setPixel32(i,90-j,HSVtoRGB(1,selectedHueBar.x,i/90,j/90));
			lightAndSatGradient.bitmapData.unlock();
			model.currentColor = lightAndSatGradient.bitmapData.getPixel32(selectedColorVBar.x/4,selectedColorHBar.y/4);
			colorSample.bitmapData.floodFill(0,0,model.currentColor);
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
	}
}