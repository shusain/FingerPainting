package com.shaunhusain.fingerPainting.view.mobileUIControls
{
	import com.shaunhusain.fingerPainting.events.AccEventExtra;
	import com.shaunhusain.fingerPainting.managers.AccelerometerManager;
	import com.shaunhusain.fingerPainting.model.PaintModel;
	import com.shaunhusain.fingerPainting.view.BitmapReference;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.AccelerometerEvent;
	import flash.events.Event;
	import flash.events.TouchEvent;
	import flash.geom.Matrix;
	import flash.utils.setTimeout;
	
	public class RotatingIconButton extends Sprite
	{
		//--------------------------------------------------------------------------------
		//				Variables
		//--------------------------------------------------------------------------------
		private var model:PaintModel = PaintModel.getInstance();
		//Sprites for layering the background and the icon
		private var backgroundSprite:Sprite;
		private var iconSprite:Sprite;
		private var allowsRotation:Boolean;
		[Embed(source="/images/brushIcon.png")]
		private var _iconImage:Class;
		private var _iconBmp:Bitmap = new _iconImage();
		
		private var _iconMatrix:Matrix;
		
		private var instantaneous:Boolean;
		
		
		
		//--------------------------------------------------------------------------------
		//				Constructor
		//--------------------------------------------------------------------------------
		public function RotatingIconButton(iconBmp:Bitmap = null, data:Object=null, instantaneous:Boolean = false, isSelected:Boolean=false, allowsRotation:Boolean = true, backgroundBitmap:Bitmap=null, backgroundSelectedBitmap:Bitmap = null)
		{
			super();
			
			if(iconBmp)
				_iconBmp = iconBmp;
			
			this.backgroundSelectedBitmap = backgroundSelectedBitmap;
			this.backgroundBitmap = backgroundBitmap;
			this.isSelected = isSelected;
			this.data = data;
			this.instantaneous = instantaneous;
			this.allowsRotation = allowsRotation;
			
			if(!backgroundBitmap)
				this.backgroundBitmap = BitmapReference._firstBackgroundBmp;
			if(!backgroundSelectedBitmap)
				this.backgroundSelectedBitmap = BitmapReference._firstBackgroundSelectedBmp;
			
			backgroundSprite = new Sprite();
			addChild(backgroundSprite);
			
			iconSprite = new Sprite();
			addChild(iconSprite);
			
			showAppropriateBackground();
			
			_iconMatrix = new Matrix();
			
			rotateAroundCenter=0;
			
			if(allowsRotation)
			{
				var accManager:AccelerometerManager = AccelerometerManager.getIntance();
				accManager.addEventListener(AccelerometerEvent.UPDATE, handleAccelerometerChange);
			}
			addEventListener(TouchEvent.TOUCH_TAP, handleTapped);
		}
		
		//--------------------------------------------------------------------------------
		//				Properties
		//--------------------------------------------------------------------------------
		private var _backgroundBitmap:Bitmap;
		public function get backgroundBitmap():Bitmap
		{
			return _backgroundBitmap;
		}
		
		public function set backgroundBitmap(value:Bitmap):void
		{
			_backgroundBitmap = value;
		}
		
		private var _backgroundSelectedBitmap:Bitmap;
		
		public function get backgroundSelectedBitmap():Bitmap
		{
			return _backgroundSelectedBitmap;
		}
		
		public function set backgroundSelectedBitmap(value:Bitmap):void
		{
			_backgroundSelectedBitmap = value;
		}
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
		
		private var _rotateAroundCenter:Number = NaN;
		public function set rotateAroundCenter (angleRadians:Number):void
		{
			if(!isNaN(_rotateAroundCenter) && Math.abs(angleRadians-_rotateAroundCenter)<.03)
				return;
			
			_rotateAroundCenter = angleRadians;
			_iconMatrix.identity();
			_iconMatrix.translate(-_iconBmp.width/2, -_iconBmp.height/2);
			_iconMatrix.rotate (angleRadians);
			_iconMatrix.translate(backgroundBitmap.width/2, backgroundBitmap.height/2);
			
			iconSprite.graphics.clear();
			iconSprite.graphics.beginBitmapFill(_iconBmp.bitmapData, _iconMatrix, false, true);
			iconSprite.graphics.drawRect(0,0, backgroundBitmap.width,backgroundBitmap.height);
			iconSprite.graphics.endFill();
		}
		public function get rotateAroundCenter():Number
		{
			return _rotateAroundCenter;
		}

		//--------------------------------------------------------------------------------
		//				Public Methods
		//--------------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------------
		//				Handlers
		//--------------------------------------------------------------------------------
		private function handleTapped(event:TouchEvent):void
		{
			event.stopImmediatePropagation();
			
			if(model.menuMoving)
				return;
			
			isSelected = true;
			
			if(instantaneous)
			{
				dispatchEvent(new Event("instantaneousButtonClicked",true));
				setTimeout(resetBackground,250);
			}
			else
			{
				dispatchEvent(new Event("buttonClicked",true));
			}
		}
		
		private function handleAccelerometerChange(event:AccEventExtra):void
		{
			rotateAroundCenter = event.linearRotation;
		}
		
		//--------------------------------------------------------------------------------
		//				Helper functions
		//--------------------------------------------------------------------------------
		private function resetBackground():void
		{
			isSelected = false;
			showAppropriateBackground();
		}
		
		private function showAppropriateBackground():void
		{
			if(!backgroundSprite)
				return;
			backgroundSprite.graphics.clear();
			if(isSelected)
			{
				backgroundSprite.graphics.beginBitmapFill(backgroundSelectedBitmap.bitmapData);
				backgroundSprite.graphics.drawRect(0,0,backgroundSelectedBitmap.width,backgroundSelectedBitmap.height);
			}
			else
			{
				backgroundSprite.graphics.beginBitmapFill(backgroundBitmap.bitmapData);
				backgroundSprite.graphics.drawRect(0,0,backgroundBitmap.width,backgroundBitmap.height);
			}
			backgroundSprite.graphics.endFill();
		}
		
		
		
	}
}