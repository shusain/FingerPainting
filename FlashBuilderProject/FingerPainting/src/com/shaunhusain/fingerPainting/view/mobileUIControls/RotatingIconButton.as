package com.shaunhusain.fingerPainting.view.mobileUIControls
{
	import com.eclecticdesignstudio.motion.Actuate;
	import com.eclecticdesignstudio.motion.actuators.GenericActuator;
	import com.shaunhusain.fingerPainting.events.AccBasedOrientationEvent;
	import com.shaunhusain.fingerPainting.managers.AccelerometerManager;
	
	import flash.display.Bitmap;
	import flash.events.AccelerometerEvent;
	
	public class RotatingIconButton extends BasicButton
	{
		//--------------------------------------------------------------------------------
		//				Variables
		//--------------------------------------------------------------------------------
		private var allowsRotation:Boolean;
		
		
		private var instantaneous:Boolean;
		
		
		
		//--------------------------------------------------------------------------------
		//				Constructor
		//--------------------------------------------------------------------------------
		public function RotatingIconButton(iconBmp:Bitmap = null, data:Object=null, instantaneous:Boolean = false, isSelected:Boolean=false, allowsRotation:Boolean = true, backgroundBitmap:Bitmap=null, backgroundSelectedBitmap:Bitmap = null)
		{
			super(iconBmp,data,instantaneous,isSelected,backgroundBitmap,backgroundSelectedBitmap);
			
			this.allowsRotation = allowsRotation;
			
			rotateAroundCenter=0;
			
			if(allowsRotation)
			{
				var accManager:AccelerometerManager = AccelerometerManager.getIntance();
				accManager.addEventListener(AccelerometerEvent.UPDATE, handleAccelerometerChange);
				
				var locRot:Number;
				switch(accManager.currentOrientation)
				{
					case AccelerometerManager.PORTRAIT_DEFAULT:
						locRot = 0;
						break;
					case AccelerometerManager.PORTRAIT_FLIPPED:
						locRot = Math.PI;
						break;
					case AccelerometerManager.LANDSCAPE_LEFT:
						locRot = Math.PI/2;
						break;
					case AccelerometerManager.LANDSCAPE_RIGHT:
						locRot = -Math.PI/2;
						break;
				}
				
				var ge:GenericActuator = Actuate.tween(this, 1, {rotateAroundCenter:locRot});
			}
		}
		
		//--------------------------------------------------------------------------------
		//				Properties
		//--------------------------------------------------------------------------------
		private var _rotateAroundCenter:Number = NaN;
		public function set rotateAroundCenter (angleRadians:Number):void
		{
			_rotateAroundCenter = angleRadians;
			iconMatrix.identity();
			iconMatrix.translate(-_iconBmp.width/2, -_iconBmp.height/2);
			iconMatrix.rotate (angleRadians);
			iconMatrix.translate(backgroundBitmap.width/2, backgroundBitmap.height/2);
			
			iconSprite.graphics.clear();
			iconSprite.graphics.beginBitmapFill(_iconBmp.bitmapData, iconMatrix, false, true);
			iconSprite.graphics.drawRect(0,0, backgroundBitmap.width,backgroundBitmap.height);
			iconSprite.graphics.endFill();
		}
		public function get rotateAroundCenter():Number
		{
			return _rotateAroundCenter;
		}

		//--------------------------------------------------------------------------------
		//				Handlers
		//--------------------------------------------------------------------------------
		
		private function handleAccelerometerChange(event:AccBasedOrientationEvent):void
		{
			var locRot:Number;
			switch(event.newOrientation)
			{
				case AccelerometerManager.PORTRAIT_DEFAULT:
					locRot = 0;
					break;
				case AccelerometerManager.PORTRAIT_FLIPPED:
					locRot = Math.PI;
					break;
				case AccelerometerManager.LANDSCAPE_LEFT:
					locRot = Math.PI/2;
					break;
				case AccelerometerManager.LANDSCAPE_RIGHT:
					locRot = -Math.PI/2;
					break;
			}
			
			var ge:GenericActuator = Actuate.tween(this, 1, {rotateAroundCenter:locRot});
			//rotateAroundCenter = event.linearRotation;
		}
	}
}