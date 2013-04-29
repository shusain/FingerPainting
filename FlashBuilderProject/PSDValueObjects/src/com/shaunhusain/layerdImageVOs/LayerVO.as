package com.shaunhusain.layerdImageVOs
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	
	/**
	 * Holds the bitmapData and thumnails bitmapData for each layer.
	 */
	public class LayerVO
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
		public function LayerVO(bitmapData:BitmapData,bitmap:Bitmap)
		{
			this.bitmapData = bitmapData;
			this.bitmap = bitmap;
			thumbnailBitmapData = new BitmapData(150*dpiScale,150*bitmapData.height/bitmapData.width*dpiScale,true,0x00000000);
			thumbnailBitmap = new Bitmap(thumbnailBitmapData);
		}
		
		//--------------------------------------------------------------------------------
		//				Public Methods
		//--------------------------------------------------------------------------------
		public function updateThumbnail():void
		{
			var matrix:Matrix = new Matrix();
			matrix.scale(150/bitmapData.width*dpiScale,150/bitmapData.width*dpiScale);
			thumbnailBitmapData.fillRect(new Rectangle(0,0,thumbnailBitmapData.width,thumbnailBitmapData.height),0x00000000);
			thumbnailBitmapData.draw(bitmapData,matrix);
		}
		
		private function get dpiScale():Number
		{
			return Capabilities.screenDPI>320&&Capabilities.screenResolutionY<1000?1:Capabilities.screenDPI/320;
		}
		
		
	}
}


