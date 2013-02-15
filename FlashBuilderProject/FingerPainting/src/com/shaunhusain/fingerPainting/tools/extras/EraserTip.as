package com.shaunhusain.fingerPainting.tools.extras
{
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class EraserTip extends BrushTip
	{
		public function EraserTip()
		{
			isPressureSensitive = false;
		}
		
		override public function generateBrush():void
		{
			if(brushBitmapData)
				brushBitmapData.dispose();
			if(brushPressureAdjustedBitmapData)
				brushPressureAdjustedBitmapData.dispose();
			
			brushBitmapData = new BitmapData(width,width,true,0xFFFFFFFF);
			var temp:Sprite = new Sprite();
			var tempMatrix:Matrix = new Matrix();
			tempMatrix.createGradientBox(width,width,0);
			temp.graphics.clear();
			/*temp.graphics.beginFill(0x00FFFF);
			temp.graphics.drawRect(0,0,width,width);
			temp.graphics.drawCircle(width/2,width/2,width/2);
			temp.graphics.endFill();*/
			
			temp.graphics.beginGradientFill(GradientType.RADIAL,[0x000000,0x000000],[1,hardness],[0,255],tempMatrix);
			temp.graphics.drawCircle(width/2,width/2,width/2);
			temp.graphics.endFill();
			
			brushBitmapData.draw(temp);
			brushBitmapData.copyChannel(brushBitmapData, brushBitmapData.rect, new Point(0,0), 1, 8);
			
			brushPressureAdjustedBitmapData = brushBitmapData.clone();
		}
		
		override public function stampMask(point:Point,pressure:Number, destinationBitmap:BitmapData):void
		{
			if(isPressureSensitive)
			{
				var curBrushWithPressure:Number = width*pressure;
				point.x -= Math.floor(curBrushWithPressure/2);
				point.y -= Math.floor(curBrushWithPressure/2);
				
				pressureMatrix.identity();
				pressureMatrix.scale(pressure,pressure);
				brushPressureAdjustedBitmapData.fillRect(new Rectangle(0,0,width,width),0x00000000);
				brushPressureAdjustedBitmapData.draw(brushBitmapData,pressureMatrix);
				destinationBitmap.copyPixels(destinationBitmap,new Rectangle(point.x,point.y,curBrushWithPressure,curBrushWithPressure),point,brushPressureAdjustedBitmapData,new Point(0,0),false);
			}
			else
			{
				point.x -= Math.floor(width/2);
				point.y -= Math.floor(width/2);
				
				destinationBitmap.copyPixels(destinationBitmap,new Rectangle(point.x,point.y,width,width),point,brushBitmapData,new Point(0,0),false);
			}
			
		}
	}
}