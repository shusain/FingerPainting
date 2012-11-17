package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.AccelerometerEvent;
	import flash.events.TouchEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.sensors.Accelerometer;
	
	import flashx.textLayout.formats.BackgroundColor;
	
	public class AccelerometerButton extends Sprite
	{
		private var backgroundSprite:Sprite;
		private var iconSprite:Sprite;
		
		private var _previousAngle:Number = 0;
		[Embed(source="images/buttonBackground.png")]
		private var _backgroundImage:Class;
		private var _backgroundBmp:Bitmap = new _backgroundImage();
		
		[Embed(source="images/brushIcon.png")]
		private var _iconImage:Class;
		private var _iconBmp:Bitmap = new _iconImage();
		
		private var _initialX:Number;
		public function set initialX(value:Number):void
		{
			_initialX = value;
			x = value;
		}
		public function get initialX():Number
		{
			return _initialX;
		}
		
		private var _initialY:Number;
		public function set initialY(value:Number):void
		{
			_initialY = value;
			y = value;
		}
		public function get initialY():Number
		{
			return _initialY;
		}
		
		public function AccelerometerButton()
		{
			super();
			
			
			backgroundSprite = new Sprite();
			addChild(backgroundSprite);
			
			iconSprite = new Sprite();
			iconSprite.x = _backgroundBmp.width/2-_iconBmp.width/2;
			iconSprite.y = _backgroundBmp.height/2-_iconBmp.height/2;
			addChild(iconSprite);
			
			backgroundSprite.graphics.beginBitmapFill(_backgroundBmp.bitmapData);
			backgroundSprite.graphics.drawRect(0,0,_backgroundBmp.width,_backgroundBmp.height);
			backgroundSprite.graphics.endFill();
			
			iconSprite.graphics.beginBitmapFill(_iconBmp.bitmapData);
			iconSprite.graphics.drawRect(0,0,_iconBmp.width,_iconBmp.height);
			iconSprite.graphics.endFill();
			
			width = 100;
			height = 100;
			
			
			var acc:Accelerometer = new Accelerometer();
			acc.addEventListener(AccelerometerEvent.UPDATE, handleAccelerometerChange);
			
			addEventListener(TouchEvent.TOUCH_TAP, handleTapped);
		}
		
		private function handleTapped(event:TouchEvent):void
		{
			event.stopImmediatePropagation();
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
		
		private function rotateAroundCenter(angleRadians:Number):void
		{
			rotateAroundPoint(angleRadians,new Point(_backgroundBmp.width/2,_backgroundBmp.height/2));
		}
		
		private function rotateAroundPoint (angleRadians:Number, point:Point):void {
			var adjustedAngle:Number = angleRadians - _previousAngle;
			var m:Matrix=iconSprite.transform.matrix;
			m.translate(-point.x,-point.y);
			m.rotate (adjustedAngle);
			m.translate(point.x,point.y);
			iconSprite.transform.matrix=m;
			_previousAngle = angleRadians;
		}
	}
}