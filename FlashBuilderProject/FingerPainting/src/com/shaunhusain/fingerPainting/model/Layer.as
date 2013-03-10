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
		private var model:PaintModel = PaintModel.getInstance();
		
		//--------------------------------------------------------------------------------
		//				Constructor
		//--------------------------------------------------------------------------------
		public function Layer(bitmapData:BitmapData,bitmap:Bitmap)
		{
			this.bitmapData = bitmapData;
			this.bitmap = bitmap;
			thumbnailBitmapData = new BitmapData(150*model.dpiScale,150*bitmapData.height/bitmapData.width*model.dpiScale,true,0x00000000);
			thumbnailBitmap = new Bitmap(thumbnailBitmapData);
		}
		
		//--------------------------------------------------------------------------------
		//				Public Methods
		//--------------------------------------------------------------------------------
		public function updateThumbnail():void
		{
			var matrix:Matrix = new Matrix();
			matrix.scale(150/bitmapData.width*model.dpiScale,150/bitmapData.width*model.dpiScale);
			thumbnailBitmapData.fillRect(new Rectangle(0,0,thumbnailBitmapData.width,thumbnailBitmapData.height),0x00000000);
			thumbnailBitmapData.draw(bitmapData,matrix);
		}
		
		
		
	}
}