package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.AccelerometerEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.sensors.Accelerometer;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	public class FingerPainting extends Sprite
	{
		private var paintBrushButton:AccelerometerButton;
		
		private var debugText:TextField;
		private var debugTextFormat:TextFormat;
		private var _previousAngle:Number = 0;
		
		public function FingerPainting()
		{
			super();
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			setupDebugText();
			
			var acc:Accelerometer = new Accelerometer();
			acc.addEventListener(AccelerometerEvent.UPDATE, function(event:AccelerometerEvent):void
			{
				//debugText.text = Math.floor(1000*event.accelerationX) +","+Math.floor(1000*event.accelerationY)+","+Math.floor(1000*event.accelerationZ);
				
				//debugText.setTextFormat(debugTextFormat);
				
				var angle:Number = Math.atan2(event.accelerationY, event.accelerationX);
				angle-=Math.PI/2;
				angle = -angle;
				if(paintBrushButton && Math.abs(event.accelerationZ)<.7)
				{
					rotateAroundCenter(paintBrushButton,angle);
				}
				
				
			});
			
			paintBrushButton = new AccelerometerButton();
			paintBrushButton.x = 100;
			paintBrushButton.y = 100;
			paintBrushButton.width = 100;
			paintBrushButton.height = 100;
			addChild(paintBrushButton);
		}
		
		private function rotateAroundCenter(ob:*,angleRadians:Number):void
		{
			rotateAroundPoint(ob,angleRadians,new Point(150,150));
		}
		
		private function rotateAroundPoint (ob:*, angleRadians:Number, point:Point):void {
			var adjustedAngle:Number = angleRadians - _previousAngle;
			trace("Point to rotate about: " + point);
			var m:Matrix=ob.transform.matrix;
			m.translate(-point.x,-point.y);
			m.rotate (adjustedAngle);
			m.translate(point.x,point.y);
			ob.transform.matrix=m;
			_previousAngle = angleRadians;
		}
		
		
		private function setupDebugText():void
		{
			debugTextFormat = new TextFormat();
			debugTextFormat.size = 36;
			
			debugText = new TextField();
			debugText.autoSize = TextFieldAutoSize.LEFT;
			debugText.setTextFormat(debugTextFormat);
			addChild(debugText);
		}
	}
}