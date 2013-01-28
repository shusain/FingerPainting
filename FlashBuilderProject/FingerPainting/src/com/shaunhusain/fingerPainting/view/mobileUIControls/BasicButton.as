package com.shaunhusain.fingerPainting.view.mobileUIControls
{
	import com.shaunhusain.fingerPainting.model.PaintModel;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TouchEvent;
	import flash.geom.Matrix;
	import flash.utils.setTimeout;
	
	/**
	 * Just a Button that has a background with two states for selected
	 * or deselected and an icon.
	 */
	public class BasicButton extends Sprite
	{
		//--------------------------------------------------------------------------------
		//				Variables
		//--------------------------------------------------------------------------------
		private var model:PaintModel = PaintModel.getInstance();
		//Sprites for layering the background and the icon
		protected var backgroundSprite:Sprite;
		protected var iconSprite:Sprite;
		
		protected var _iconBmp:Bitmap;
		protected var _iconSelectedBmp:Bitmap;
		
		protected var iconMatrix:Matrix;
		
		private var instantaneous:Boolean;
		
		//--------------------------------------------------------------------------------
		//				Constructor
		//--------------------------------------------------------------------------------
		public function BasicButton(iconBmp:Bitmap = null, iconSelectedBmp:Bitmap = null, data:Object=null, instantaneous:Boolean = false, isSelected:Boolean=false, backgroundBitmap:Bitmap=null, backgroundSelectedBitmap:Bitmap = null)
		{
			super();
			
			iconMatrix = new Matrix();
			
			this._iconBmp = iconBmp;
			this._iconSelectedBmp = iconSelectedBmp;
			this.backgroundSelectedBitmap = backgroundSelectedBitmap;
			this.backgroundBitmap = backgroundBitmap;
			this.data = data;
			this.instantaneous = instantaneous;
			
			backgroundSprite = new Sprite();
			addChild(backgroundSprite);
			
			iconSprite = new Sprite();
			addChild(iconSprite);
			
			this.isSelected = isSelected;
			
			addEventListener(TouchEvent.TOUCH_TAP, handleTapped);
		}
		
		//--------------------------------------------------------------------------------
		//				Properties
		//--------------------------------------------------------------------------------
		private var _toggles:Boolean;

		public function get toggles():Boolean
		{
			return _toggles;
		}

		public function set toggles(value:Boolean):void
		{
			_toggles = value;
		}

		
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
			drawIcon();
		}
		
		//--------------------------------------------------------------------------------
		//				Handlers
		//--------------------------------------------------------------------------------
		private function handleTapped(event:TouchEvent):void
		{
			event.stopImmediatePropagation();
			
			if(model.menuMoving)
				return;
			
			if(toggles)
				isSelected = !isSelected;
			else
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
		
		
		//--------------------------------------------------------------------------------
		//				Helper functions
		//--------------------------------------------------------------------------------
		
		public function drawIcon():void
		{
			var bmpToUse:Bitmap = isSelected&&_iconSelectedBmp?_iconSelectedBmp:_iconBmp;
			
			var widthToCenter:Number = backgroundBitmap?backgroundBitmap.width/2:bmpToUse.width/2;
			var heightToCenter:Number = backgroundBitmap?backgroundBitmap.height/2:bmpToUse.height/2;
			
			iconMatrix.identity();
			iconMatrix.translate(-bmpToUse.width/2, -bmpToUse.height/2);
			iconMatrix.translate(widthToCenter, heightToCenter);
			
			iconSprite.graphics.clear();
			iconSprite.graphics.beginBitmapFill(_iconBmp.bitmapData, iconMatrix, false, true);
			iconSprite.graphics.drawRect(0,0, bmpToUse.width,bmpToUse.height);
			iconSprite.graphics.endFill();
		}
		private function resetBackground():void
		{
			isSelected = false;
		}
		
		private function showAppropriateBackground():void
		{
			if(!backgroundSprite)
				return;
			backgroundSprite.graphics.clear();
			if(isSelected && backgroundSelectedBitmap)
			{
				backgroundSprite.graphics.beginBitmapFill(backgroundSelectedBitmap.bitmapData);
				backgroundSprite.graphics.drawRect(0,0,backgroundSelectedBitmap.width,backgroundSelectedBitmap.height);
			}
			else if(backgroundBitmap)
			{
				backgroundSprite.graphics.beginBitmapFill(backgroundBitmap.bitmapData);
				backgroundSprite.graphics.drawRect(0,0,backgroundBitmap.width,backgroundBitmap.height);
			}
			backgroundSprite.graphics.endFill();
		}
		
		
		
	}
}