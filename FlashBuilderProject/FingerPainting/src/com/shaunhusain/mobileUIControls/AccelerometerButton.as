package com.shaunhusain.mobileUIControls
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.AccelerometerEvent;
	import flash.events.Event;
	import flash.events.TouchEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.sensors.Accelerometer;
	import flash.utils.setTimeout;
	
	import flashx.textLayout.formats.BackgroundColor;
	
	public class AccelerometerButton extends Sprite
	{
		//Sprites for layering the background and the icon
		private var backgroundSprite:Sprite;
		private var iconSprite:Sprite;
		
		//background image for button when deselected
		[Embed(source="images/buttonBackground.png")]
		private var _backgroundImage:Class;
		private var _backgroundBmp:Bitmap = new _backgroundImage();
		
		//background image for button when selected
		[Embed(source="images/buttonBackgroundSelected.png")]
		private var _backgroundImageSelected:Class;
		private var _backgroundSelectedBmp:Bitmap = new _backgroundImageSelected();
		
		
		[Embed(source="images/brushIcon.png")]
		private var _iconImage:Class;
		private var _iconBmp:Bitmap = new _iconImage();
		
		private var _iconMatrix:Matrix;
		
		private var instantaneous:Boolean;
		
		private var _data:Object;
		public function get data():Object
		{
			return _data;
		}

		public function set data(value:Object):void
		{
			_data = value;
		}

		
		private var _isSelected:Boolean;
		public function get isSelected():Boolean
		{
			return _isSelected;
		}
		
		public function set isSelected(value:Boolean):void
		{
			_isSelected = value;
			showAppropriateBackground();
		}
		
		private function handleTapped(event:TouchEvent):void
		{
			event.stopImmediatePropagation();
			
			isSelected = true;
			
			if(instantaneous)
			{
				dispatchEvent(new Event("instantaneousButtonClicked"));
				setTimeout(resetBackground,250);
			}
			else
			{
				dispatchEvent(new Event("buttonClicked"));
			}
		}
		
		private function resetBackground():void
		{
			isSelected = false;
			showAppropriateBackground();
		}
		
		public function AccelerometerButton(iconBmp:Bitmap = null, data:Object=null, instantaneous:Boolean = false, isSelected:Boolean=false)
		{
			super();
			
			
			if(iconBmp)
				_iconBmp = iconBmp;
			this.isSelected = isSelected;
			this.data = data;
			this.instantaneous = instantaneous;
			
			backgroundSprite = new Sprite();
			addChild(backgroundSprite);
			
			iconSprite = new Sprite();
			addChild(iconSprite);
			
			showAppropriateBackground();
			
			_iconMatrix = new Matrix();
			
			rotateAroundCenter(Math.PI);
			
			var accManager:AccelerometerManager = AccelerometerManager.getIntance();
			accManager.addEventListener(AccelerometerEvent.UPDATE, handleAccelerometerChange);
			
			addEventListener(TouchEvent.TOUCH_TAP, handleTapped);
		}
		
		private function showAppropriateBackground():void
		{
			if(!backgroundSprite)
				return;
			if(isSelected)
			{
				backgroundSprite.graphics.beginBitmapFill(_backgroundSelectedBmp.bitmapData);
				backgroundSprite.graphics.drawRect(0,0,_backgroundSelectedBmp.width,_backgroundSelectedBmp.height);
			}
			else
			{
				backgroundSprite.graphics.beginBitmapFill(_backgroundBmp.bitmapData);
				backgroundSprite.graphics.drawRect(0,0,_backgroundBmp.width,_backgroundBmp.height);
			}
			backgroundSprite.graphics.endFill();
		}
		
		private function handleAccelerometerChange(event:AccelerometerEvent):void
		{
			var angle:Number = Math.atan2(event.accelerationY, event.accelerationX);
			angle-=Math.PI/2;
			angle = -angle;
			if(Math.abs(event.accelerationZ)<.9)
			{
				rotateAroundCenter(angle);
			}
		}
		
		private function rotateAroundCenter (angleRadians:Number):void
		{
			_iconMatrix.identity();
			_iconMatrix.translate(-_iconBmp.width/2, -_iconBmp.height/2);
			_iconMatrix.rotate (angleRadians);
			_iconMatrix.translate(_backgroundBmp.width/2, _backgroundBmp.height/2);
			
			iconSprite.graphics.clear();
			iconSprite.graphics.beginBitmapFill(_iconBmp.bitmapData, _iconMatrix, false, true);
			iconSprite.graphics.drawRect(0,0, _backgroundBmp.width,_backgroundBmp.height);
			iconSprite.graphics.endFill();
		}
	}
}