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
		//--------------------------------------------------------------------------------
		//				Variables
		//--------------------------------------------------------------------------------
		public var bitmap:Bitmap;
		public var bitmapData:BitmapData;
		public var thumbnailBitmap:Bitmap;
		public var thumbnailBitmapData:BitmapData;
		
		//--------------------------------------------------------------------------------
		//				Constructor
		//--------------------------------------------------------------------------------
		public function Layer(bitmapData:BitmapData,bitmap:Bitmap)
		{
			this.bitmapData = bitmapData;
			this.bitmap = bitmap;
			thumbnailBitmapData = new BitmapData(170,170*bitmapData.height/bitmapData.width,true,0x00000000);
			thumbnailBitmap = new Bitmap(thumbnailBitmapData);
		}
		
		//--------------------------------------------------------------------------------
		//				Public Methods
		//--------------------------------------------------------------------------------
		public function updateThumbnail():void
		{
			var matrix:Matrix = new Matrix();
			matrix.scale(170/bitmapData.width,170/bitmapData.width);
			thumbnailBitmapData.fillRect(new Rectangle(0,0,thumbnailBitmapData.width,thumbnailBitmapData.height),0x00000000);
			thumbnailBitmapData.draw(bitmapData,matrix);
		}
		
		
		
	}
}