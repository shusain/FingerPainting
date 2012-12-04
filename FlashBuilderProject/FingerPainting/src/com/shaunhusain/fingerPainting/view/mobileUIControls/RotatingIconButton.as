package com.shaunhusain.fingerPainting.view.mobileUIControls
{
	import com.shaunhusain.fingerPainting.managers.AccelerometerManager;
	import com.shaunhusain.fingerPainting.model.PaintModel;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.AccelerometerEvent;
	import flash.events.Event;
	import flash.events.TouchEvent;
	import flash.geom.Matrix;
	import flash.utils.setTimeout;
	
	public class RotatingIconButton extends Sprite
	{
		private var model:PaintModel = PaintModel.getInstance();
		//Sprites for layering the background and the icon
		private var backgroundSprite:Sprite;
		private var iconSprite:Sprite;
		
		public var useSecondaryBackground:Boolean;
		
		//background image for button when deselected
		[Embed(source="/images/buttonBackground.png")]
		private var _firstBackgroundImage:Class;
		private var _firstBackgroundBmp:Bitmap = new _firstBackgroundImage();
		
		//background image for button when selected
		[Embed(source="/images/buttonBackgroundSelected.png")]
		private var _firstBackgroundImageSelected:Class;
		private var _firstBackgroundSelectedBmp:Bitmap = new _firstBackgroundImageSelected();
		
		[Embed(source="/images/secondaryButtonBackground.png")]
		private var _secondBackgroundImage:Class;
		private var _secondBackgroundBmp:Bitmap = new _secondBackgroundImage();
		
		[Embed(source="/images/secondaryButtonSelectedBackground.png")]
		private var _secondBackgroundSelectedImage:Class;
		private var _secondBackgroundSelectedBmp:Bitmap = new _secondBackgroundSelectedImage();
		
		
		
		[Embed(source="/images/brushIcon.png")]
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
			
			if(model.menuMoving)
				return;
			
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
		
		public function RotatingIconButton(iconBmp:Bitmap = null, data:Object=null, instantaneous:Boolean = false, isSelected:Boolean=false, useSecondaryBackground:Boolean=false)
		{
			super();
			
			
			if(iconBmp)
				_iconBmp = iconBmp;
			if(useSecondaryBackground)
			{
				_firstBackgroundBmp = _secondBackgroundBmp;
				_firstBackgroundSelectedBmp = _secondBackgroundSelectedBmp;
			}
			this.useSecondaryBackground = useSecondaryBackground
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
			backgroundSprite.graphics.clear();
			if(isSelected)
			{
				backgroundSprite.graphics.beginBitmapFill(_firstBackgroundSelectedBmp.bitmapData);
				backgroundSprite.graphics.drawRect(0,0,_firstBackgroundSelectedBmp.width,_firstBackgroundSelectedBmp.height);
			}
			else
			{
				backgroundSprite.graphics.beginBitmapFill(_firstBackgroundBmp.bitmapData);
				backgroundSprite.graphics.drawRect(0,0,_firstBackgroundBmp.width,_firstBackgroundBmp.height);
			}
			backgroundSprite.graphics.endFill();
		}
		
		private function handleAccelerometerChange(event:AccelerometerEvent):void
		{
			if(Math.abs(event.accelerationZ)<.9)
			{
				var angle:Number = Math.atan2(event.accelerationY, event.accelerationX);
				angle-=Math.PI/2;
				angle = -angle;
				rotateAroundCenter(angle);
			}
		}
		
		private function rotateAroundCenter (angleRadians:Number):void
		{
			_iconMatrix.identity();
			_iconMatrix.translate(-_iconBmp.width/2, -_iconBmp.height/2);
			_iconMatrix.rotate (angleRadians);
			_iconMatrix.translate(_firstBackgroundBmp.width/2, _firstBackgroundBmp.height/2);
			
			iconSprite.graphics.clear();
			iconSprite.graphics.beginBitmapFill(_iconBmp.bitmapData, _iconMatrix, false, true);
			iconSprite.graphics.drawRect(0,0, _firstBackgroundBmp.width,_firstBackgroundBmp.height);
			iconSprite.graphics.endFill();
		}
	}
}