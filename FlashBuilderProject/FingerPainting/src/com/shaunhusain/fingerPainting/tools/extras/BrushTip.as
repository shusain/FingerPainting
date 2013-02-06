package com.shaunhusain.fingerPainting.tools.extras
{
	import com.shaunhusain.fingerPainting.model.PaintModel;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class BrushTip
	{
		private var model:PaintModel = PaintModel.getInstance();
		
		protected var brushBitmapData:BitmapData;
		protected var brushPressureAdjustedBitmapData:BitmapData;
		protected var pressureMatrix:Matrix;
		
		[Embed(source="/images/scatterBrush.png")]
		private static var _scatterBrushClass:Class;
		public static var _scatterBrushBmp:Bitmap = new _scatterBrushClass();
		[Embed(source="/images/stippleBrush.png")]
		private static var _stippleBrushClass:Class;
		public static var _stippleBrushBmp:Bitmap = new _stippleBrushClass();
		
		public function BrushTip()
		{
			pressureMatrix = new Matrix();
			generateBrush();
			
			model.addEventListener("currentColorChanged", colorChangeHandler);
		}
		
		protected function colorChangeHandler(event:Event):void
		{
			if(model.currentColor == color)
				return;
			color = model.currentColor;
			generateBrush();
		}
		
		private var _isPressureSensitive:Boolean = true;

		public function get isPressureSensitive():Boolean
		{
			return _isPressureSensitive;
		}

		public function set isPressureSensitive(value:Boolean):void
		{
			if(_isPressureSensitive == value)
				return;
			_isPressureSensitive = value;
			generateBrush();
		}
		private var _isXMirrored:Boolean;

		public function get isXMirrored():Boolean
		{
			return _isXMirrored;
		}

		public function set isXMirrored(value:Boolean):void
		{
			if(_isXMirrored == value)
				return;
			_isXMirrored = value;
		}
		
		
		private var _isYMirrored:Boolean;

		public function get isYMirrored():Boolean
		{
			return _isYMirrored;
		}

		public function set isYMirrored(value:Boolean):void
		{
			if(_isYMirrored == value)
				return;
			_isYMirrored = value;
		}

		
		private var _color:uint = 0x00DDFF;
		
		public function get color():uint
		{
			return _color;
		}

		public function set color(value:uint):void
		{
			if(_color == value)
				return;
			_color = value;
			generateBrush();
		}

		private var _alpha:Number=1;

		public function get alpha():Number
		{
			return _alpha;
		}

		public function set alpha(value:Number):void
		{
			if(_alpha == value)
				return;
			_alpha = value;
			generateBrush();
		}

		private var _width:Number=20;

		public function get width():Number
		{
			return _width;
		}

		public function set width(value:Number):void
		{
			if(_width == value)
				return;
			_width = value;
			generateBrush();
		}

		
		private var _hardness:Number=.2;

		public function get hardness():Number
		{
			return _hardness;
		}

		public function set hardness(value:Number):void
		{
			if(_hardness == value || usePreRenderedBitmapBrush)
				return;
			_hardness = value;
			generateBrush();
		}
		
		private var _usePreRenderedBitmapBrush:Boolean = false;

		public function get usePreRenderedBitmapBrush():Boolean
		{
			return _usePreRenderedBitmapBrush;
		}

		public function set usePreRenderedBitmapBrush(value:Boolean):void
		{
			if(_usePreRenderedBitmapBrush == value)
				return;
			_usePreRenderedBitmapBrush = value;
			generateBrush();
			
		}

		
		public function generateBrush():void
		{
			if(brushBitmapData)
				brushBitmapData.dispose();
			if(brushPressureAdjustedBitmapData)
				brushPressureAdjustedBitmapData.dispose();
			
			if(usePreRenderedBitmapBrush)
			{
				var rgbObj:Object = hexToRGB(color);
				trace(rgbObj.red,rgbObj.green,rgbObj.blue);
				
				var scaleMatrix:Matrix = new Matrix();
				scaleMatrix.scale(width/150,width/150);
				
				brushBitmapData = new BitmapData(width,width,true,0x00000000);
				brushBitmapData.draw(_scatterBrushBmp.bitmapData, scaleMatrix, new ColorTransform(1,1,1,alpha,rgbObj.red,rgbObj.green,rgbObj.blue));
			}
			else
			{
				brushBitmapData = new BitmapData(width,width,true,0x00000000);
				var temp:Sprite = new Sprite();
				var tempMatrix:Matrix = new Matrix();
				tempMatrix.createGradientBox(width,width,0);
				temp.graphics.clear();
				temp.graphics.beginGradientFill(GradientType.RADIAL,[color,color],[alpha,alpha*hardness],[0,255],tempMatrix);
				temp.graphics.drawCircle(width/2,width/2,width/2);
				temp.graphics.endFill();
				brushBitmapData.draw(temp);
			}
			
			brushPressureAdjustedBitmapData = brushBitmapData.clone();
			
		}
		public function stampMaskLine(from:Point, to:Point, leftOverDistance:Number, pressure:Number, destinationBitmap:BitmapData):Number
		{
			// Set the spacing between the stamps. By trail and error, I've 
			//	determined that 1/10 of the brush width (currently hard coded to 20)
			//	is a good interval.
			var spacing:Number = width * pressure * 0.20;
			
			// Anything less that half a pixel is overkill and could hurt performance.
			if ( spacing < .5 )
				spacing = .5;
			if ( spacing > 10 )
				spacing = 10;
			
			// Determine the delta of the x and y. This will determine the slope
			//	of the line we want to draw.
			var deltaX:Number = to.x - from.x;
			var deltaY:Number = to.y - from.y;
			
			// Normalize the delta vector we just computed, and that becomes our step increment
			//	for drawing our line, since the distance of a normalized vector is always 1
			var distance:Number = Math.sqrt( deltaX * deltaX + deltaY * deltaY );
			var stepX:Number = 0.0;
			var stepY:Number = 0.0;
			if ( distance > 0.0 ) {
				var invertDistance:Number = 1.0 / distance;
				stepX = deltaX * invertDistance;
				stepY = deltaY * invertDistance;
			}
			
			var offsetX:Number = 0.0;
			var offsetY:Number = 0.0;
			
			// We're careful to only stamp at the specified interval, so its possible
			//	that we have the last part of the previous line left to draw. Be sure
			//	to add that into the total distance we have to draw.
			var totalDistance:Number = leftOverDistance + distance;
			
			// While we still have distance to cover, stamp
			while ( totalDistance >= spacing ) {
				// Increment where we put the stamp
				if ( leftOverDistance > 0 ) {
					// If we're making up distance we didn't cover the last
					//	time we drew a line, take that into account when calculating
					//	the offset. leftOverDistance is always < spacing.
					offsetX += stepX * (spacing - leftOverDistance);
					offsetY += stepY * (spacing - leftOverDistance);
					
					leftOverDistance -= spacing;
				} else {
					// The normal case. The offset increment is the normalized vector
					//	times the spacing
					offsetX += stepX * spacing;
					offsetY += stepY * spacing;
				}
				
				// Calculate where to put the current stamp at.
				var stampAt:Point = new Point(from.x + offsetX, from.y + offsetY);
				
				// Ka-chunk! Draw the image at the current location
				stampMask(stampAt,pressure,destinationBitmap);
				
				if(_isXMirrored)
				{
					var horizontalMirrorPoint:Number = destinationBitmap.width/2;
					var offsetXFromMirror:Number = horizontalMirrorPoint - stampAt.x;
					var mirrorAt:Point = new Point(horizontalMirrorPoint+offsetXFromMirror,stampAt.y);
					// Ka-chunk! Draw the image at the current location
					stampMask(mirrorAt,pressure,destinationBitmap);
				}
				if(_isYMirrored)
				{
					var verticalMirrorPoint:Number = destinationBitmap.height/2;
					var offsetYFromMirror:Number = verticalMirrorPoint - stampAt.y;
					mirrorAt = new Point(stampAt.x, verticalMirrorPoint + offsetYFromMirror);
					stampMask(mirrorAt,pressure,destinationBitmap);
				}
				if(_isXMirrored && _isYMirrored)
				{
					mirrorAt = new Point(horizontalMirrorPoint + offsetXFromMirror, verticalMirrorPoint + offsetYFromMirror);
					stampMask(mirrorAt,pressure,destinationBitmap);
				}
				// Remove the distance we just covered
				totalDistance -= spacing;
			}
			
			// Return the distance that we didn't get to cover when drawing the line.
			//	It is going to be less than spacing.
			return totalDistance;	
		}
		public function stampMask(point:Point,pressure:Number,destinationBitmap:BitmapData):void
		{
			if(_isPressureSensitive)
			{
				var curBrushWithPressure:Number = width*pressure;
				point.x -= curBrushWithPressure/2;
				point.y -= curBrushWithPressure/2;
				
				pressureMatrix.identity();
				pressureMatrix.scale(pressure,pressure);
				brushPressureAdjustedBitmapData.fillRect(new Rectangle(0,0,width,width),0x00000000);
				brushPressureAdjustedBitmapData.draw(brushBitmapData,pressureMatrix);
				destinationBitmap.copyPixels(brushPressureAdjustedBitmapData,new Rectangle(0,0,curBrushWithPressure,curBrushWithPressure),point,null,null,true);
			}
			else
			{
				point.x -= width/2;
				point.y -= width/2;
				destinationBitmap.copyPixels(brushBitmapData,new Rectangle(0,0,width,width),point,null,null,true);
			}
			
		}
		private function hexToRGB(hex:Number):Object
		{
			var rgbObject:Object = {red:(hex & 0x00FF0000)>>16,
									green:(hex & 0x0000FF00)>>8,
									blue:(hex & 0x000000FF)};
			return rgbObject;
		}
	}
}