package com.shaunhusain.fingerPainting.view.mobileUIControls
{
	import com.eclecticdesignstudio.motion.Actuate;
	import com.eclecticdesignstudio.motion.actuators.GenericActuator;
	import com.shaunhusain.fingerPainting.events.AccBasedOrientationEvent;
	import com.shaunhusain.fingerPainting.managers.AccelerometerManager;
	import com.shaunhusain.fingerPainting.view.managers.HelpManager;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.AccelerometerEvent;
	import flash.events.Event;
	import flash.events.TouchEvent;
	import flash.geom.Matrix;
	
	/**
	 * Displays two icons in the top and bottom of a single graphic with a
	 * separate hit area for each.
	 */
	public class StackedButtons extends Sprite
	{
		[Embed(source="/images/stackedBackground.png")]
		private var _backgroundClass:Class;
		private var _backgroundBmp:Bitmap = new _backgroundClass();
		
		private var topButtonSprite:Sprite;
		private var bottomButtonSprite:Sprite;
		private var rotationContainer:Sprite;
		
		public function StackedButtons(topIcon:Bitmap, bottomIcon:Bitmap)
		{
			super();
			rotationContainer = new Sprite();
			addChild(rotationContainer);
			
			rotationContainer.addChild(_backgroundBmp);
			
			topIcon.x = _backgroundBmp.width/2-topIcon.width/2;
			topIcon.y = _backgroundBmp.height/4-topIcon.height/2;
			rotationContainer.addChild(topIcon);
			
			bottomIcon.x = _backgroundBmp.width/2 - bottomIcon.width/2;
			bottomIcon.y = 3*_backgroundBmp.height/4 - bottomIcon.height/2;
			rotationContainer.addChild(bottomIcon);
			
			topButtonSprite = new Sprite();
			topButtonSprite.graphics.clear();
			topButtonSprite.graphics.beginFill(0xff0000, 0);
			topButtonSprite.graphics.drawRect(0,0, _backgroundBmp.width,_backgroundBmp.height/2);
			topButtonSprite.addEventListener(TouchEvent.TOUCH_TAP, topButtonHandler);
			rotationContainer.addChild(topButtonSprite);
			
			bottomButtonSprite = new Sprite();
			bottomButtonSprite.y = _backgroundBmp.height/2;
			bottomButtonSprite.graphics.clear();
			bottomButtonSprite.graphics.beginFill(0x00ff00, 0);
			bottomButtonSprite.graphics.drawRect(0,0, _backgroundBmp.width,_backgroundBmp.height/2);
			bottomButtonSprite.addEventListener(TouchEvent.TOUCH_TAP, bottomButtonHandler);
			rotationContainer.addChild(bottomButtonSprite);
			
			
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
		private var _rotateAroundCenter:Number = 0;
		public function set rotateAroundCenter (angleRadians:Number):void
		{
			_rotateAroundCenter = angleRadians;
			
			var thisMatrix:Matrix = rotationContainer.transform.matrix.clone();
			thisMatrix.identity();
			thisMatrix.tx -= 88;
			thisMatrix.ty -= 88;
			thisMatrix.rotate (angleRadians);
			thisMatrix.tx += 88;
			thisMatrix.ty += 88;
			
			rotationContainer.transform.matrix = thisMatrix;
		}
		public function get rotateAroundCenter():Number
		{
			return _rotateAroundCenter;
		}
		
		
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
		
		protected function bottomButtonHandler(event:TouchEvent):void
		{
			dispatchEvent(new Event("bottomButtonTapped"));
		}
		
		protected function topButtonHandler(event:TouchEvent):void
		{
			dispatchEvent(new Event("topButtonTapped"));
		}
	}
}