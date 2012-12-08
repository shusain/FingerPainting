package com.shaunhusain.fingerPainting.view
{
	import flash.display.Bitmap;
	
	import org.bytearray.ScaleBitmap;

	public class BitmapReference
	{
		[Embed(source="/images/saveIcon.png")]
		private static var _saveIcon:Class;
		public static var _saveIconBmp:Bitmap = new _saveIcon();
		
		[Embed(source="/images/brushIcon.png")]
		private static var _brushIcon:Class;
		public static var _brushIconBmp:Bitmap = new _brushIcon();
		
		[Embed(source="/images/eraserIcon.png")]
		private static var _eraserIcon:Class;
		public static var _eraserIconBmp:Bitmap = new _eraserIcon();
		
		[Embed(source="/images/bucketIcon.png")]
		private static var _bucketIcon:Class;
		public static var _bucketIconBmp:Bitmap = new _bucketIcon();
		
		[Embed(source="/images/undoIcon.png")]
		private static var _undoIcon:Class;
		public static var _undoIconBmp:Bitmap = new _undoIcon();
		
		[Embed(source="/images/redoIcon.png")]
		private static var _redoIcon:Class;
		public static var _redoIconBmp:Bitmap = new _redoIcon();
		
		[Embed(source="/images/shapesIcon.png")]
		private static var _shapesIcon:Class;
		public static var _shapesIconBmp:Bitmap = new _shapesIcon();
		
		[Embed(source="/images/pipetIcon.png")]
		private static var _pipetIcon:Class;
		public static var _pipetIconBmp:Bitmap = new _pipetIcon();
		
		[Embed(source="/images/colorSpectrumIcon.png")]
		private static var _colorSpectrumIcon:Class;
		public static var _colorSpectrumBmp:Bitmap = new _colorSpectrumIcon();
		
		[Embed(source="/images/blankDocIcon.png")]
		private static var _blankDocIcon:Class;
		public static var _blankDocBmp:Bitmap = new _blankDocIcon();
		
		[Embed(source="/images/triangleIcon.png")]
		private static var _triangleIcon:Class;
		public static var _triangleIconBmp:Bitmap = new _triangleIcon();
		
		[Embed(source="/images/toolbarBackground.png")]
		private static var toolbarBmpClass:Class;
		public static var toolbarBmp:Bitmap = new toolbarBmpClass();
		public static var scaledBitmap:ScaleBitmap = new ScaleBitmap(toolbarBmp.bitmapData);
		public function BitmapReference()
		{
		}
	}
}