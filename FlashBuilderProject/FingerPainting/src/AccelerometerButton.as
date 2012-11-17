package
{
	import flash.display.Sprite;
	import flash.events.AccelerometerEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.sensors.Accelerometer;
	
	public class AccelerometerButton extends Sprite
	{
		private var _previousAngle:Number = 0;
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
			
			graphics.beginFill(0xFF0000);
			graphics.drawRect(0,0,100,50);
			graphics.beginFill(0x00FF00);
			graphics.drawRect(0,50,100,50);
			graphics.endFill();
			
			width = 100;
			height = 100;
			
			
			var acc:Accelerometer = new Accelerometer();
			acc.addEventListener(AccelerometerEvent.UPDATE, handleAccelerometerChange);
		}
		
		private function handleAccelerometerChange(event:AccelerometerEvent):void
		{
			var angle:Number = Math.atan2(event.accelerationY, event.accelerationX);
			angle-=Math.PI/2;
			angle = -angle;
			if(Math.abs(event.accelerationZ)<.7)
			{
				rotateAroundCenter(angle);
			}
		}
		
		private function rotateAroundCenter(angleRadians:Number):void
		{
			rotateAroundPoint(angleRadians,new Point(50+initialX,50+initialY));
		}
		
		private function rotateAroundPoint (angleRadians:Number, point:Point):void {
			var adjustedAngle:Number = angleRadians - _previousAngle;
			var m:Matrix=transform.matrix;
			m.translate(-point.x,-point.y);
			m.rotate (adjustedAngle);
			m.translate(point.x,point.y);
			transform.matrix=m;
			_previousAngle = angleRadians;
		}
	}
}