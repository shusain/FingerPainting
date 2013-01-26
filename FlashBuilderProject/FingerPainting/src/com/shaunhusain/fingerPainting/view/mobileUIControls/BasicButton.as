package com.shaunhusain.fingerPainting.view.mobileUIControls
{
	import com.shaunhusain.fingerPainting.model.PaintModel;
	import com.shaunhusain.fingerPainting.view.BitmapReference;
	
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
		
		protected var iconMatrix:Matrix;
		
		private var instantaneous:Boolean;
		
		//--------------------------------------------------------------------------------
		//				Constructor
		//--------------------------------------------------------------------------------
		public function BasicButton(iconBmp:Bitmap = null, data:Object=null, instantaneous:Boolean = false, isSelected:Boolean=false, backgroundBitmap:Bitmap=null, backgroundSelectedBitmap:Bitmap = null)
		{
			super();
			
			iconMatrix = new Matrix();
			
			this._iconBmp = iconBmp;
			this.backgroundSelectedBitmap = backgroundSelectedBitmap;
			this.backgroundBitmap = backgroundBitmap;
			this.isSelected = isSelected;
			this.data = data;
			this.instantaneous = instantaneous;
			
			if(!backgroundBitmap)
				this.backgroundBitmap = BitmapReference._firstBackgroundBmp;
			if(!backgroundSelectedBitmap)
				this.backgroundSelectedBitmap = BitmapReference._firstBackgroundSelectedBmp;
			
			backgroundSprite = new Sprite();
			addChild(backgroundSprite);
			
			iconSprite = new Sprite();
			addChild(iconSprite);
			
			showAppropriateBackground();
			centerIcon();
			
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
		
		public function centerIcon():void
		{
			iconMatrix.identity();
			iconMatrix.translate(-_iconBmp.width/2, -_iconBmp.height/2);
			iconMatrix.translate(backgroundBitmap.width/2, backgroundBitmap.height/2);
			
			iconSprite.graphics.clear();
			iconSprite.graphics.beginBitmapFill(_iconBmp.bitmapData, iconMatrix, false, true);
			iconSprite.graphics.drawRect(0,0, backgroundBitmap.width,backgroundBitmap.height);
			iconSprite.graphics.endFill();
		}
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