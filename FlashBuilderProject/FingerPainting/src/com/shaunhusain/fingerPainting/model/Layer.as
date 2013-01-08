package com.shaunhusain.fingerPainting.model
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	/**
	 * Holds the bitmapData and thumnails bitmapData for each layer.
	 */
	public class Layer
	{
		public var bitmap:Bitmap;
		public var bitmapData:BitmapData;
		public var thumbnailBitmap:Bitmap;
		public var thumbnailBitmapData:BitmapData;
		
		public function Layer(bitmapData:BitmapData,bitmap:Bitmap)
		{
			this.bitmapData = bitmapData;
			this.bitmap = bitmap;
			thumbnailBitmapData = new BitmapData(bitmapData.width/5,bitmapData.height/5,true,0x00000000);
			thumbnailBitmap = new Bitmap(thumbnailBitmapData);
		}
		public function updateThumbnail():void
		{
			var matrix:Matrix = new Matrix();
			matrix.scale(.2,.2);
			thumbnailBitmapData.fillRect(new Rectangle(0,0,thumbnailBitmapData.width,thumbnailBitmapData.height),0x00000000);
			thumbnailBitmapData.draw(bitmapData,matrix);
		}
	}
}