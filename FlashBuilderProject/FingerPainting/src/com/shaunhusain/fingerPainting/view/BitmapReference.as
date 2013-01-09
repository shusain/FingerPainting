package com.shaunhusain.fingerPainting.view
{
	import flash.display.Bitmap;
	
	import org.bytearray.ScaleBitmap;

	public class BitmapReference
	{
		/** Main menu items **/
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
		
		[Embed(source="/images/cameraIconClipped.png")]
		private static var _cameraIcon:Class;
		public static var _cameraBmp:Bitmap = new _cameraIcon();
		
		[Embed(source="/images/layersIcon.png")]
		private static var _layersIcon:Class;
		public static var _layersBmp:Bitmap = new _layersIcon();
		
		[Embed(source="/images/shareIcon.png")]
		private static var _shareIcon:Class;
		public static var _shareBmp:Bitmap = new _shareIcon();
		
		/** Layer option buttons **/
		[Embed(source="/images/add.png")]
		private static var _addIcon:Class;
		public static var _addBmp:Bitmap = new _addIcon();
		
		[Embed(source="/images/remove.png")]
		private static var _removeIcon:Class;
		public static var _removeBmp:Bitmap = new _removeIcon();
		
		[Embed(source="/images/moveUp.png")]
		private static var _moveUpIcon:Class;
		public static var _moveUpBmp:Bitmap = new _moveUpIcon();
		
		[Embed(source="/images/moveDown.png")]
		private static var _moveDownIcon:Class;
		public static var _moveDownBmp:Bitmap = new _moveDownIcon();
		
		/** Toolbar Images **/
		[Embed(source="/images/triangleIcon.png")]
		private static var _triangleIcon:Class;
		public static var _triangleIconBmp:Bitmap = new _triangleIcon();
		
		[Embed(source="/images/glowDownSlice.png")]
		private static var _glowDownSliceIcon:Class;
		public static var _glowDownSliceBmp:Bitmap = new _glowDownSliceIcon();
		
		[Embed(source="/images/glowUpSlice.png")]
		private static var _glowUpSliceIcon:Class;
		public static var _glowUpSliceBmp:Bitmap = new _glowUpSliceIcon();
		
		[Embed(source="/images/toolbarBackground.png")]
		private static var toolbarBmpClass:Class;
		public static var toolbarBmp:Bitmap = new toolbarBmpClass();
		public static var scaledBitmap:ScaleBitmap = new ScaleBitmap(toolbarBmp.bitmapData);
		
		
		/** Toolbar Button Images **/
		//background image for button when deselected
		[Embed(source="/images/buttonBackgroundTrans.png")]
		private static var _firstBackgroundImage:Class;
		public static var _firstBackgroundBmp:Bitmap = new _firstBackgroundImage();
		
		//background image for button when selected
		[Embed(source="/images/buttonBackgroundSelectedYellow.png")]
		private static var _firstBackgroundImageSelected:Class;
		public static var _firstBackgroundSelectedBmp:Bitmap = new _firstBackgroundImageSelected();
		
		[Embed(source="/images/secondaryButtonBackground.png")]
		private static var _secondBackgroundImage:Class;
		public static var _secondBackgroundBmp:Bitmap = new _secondBackgroundImage();
		
		[Embed(source="/images/secondaryButtonSelectedBackground.png")]
		private static var _secondBackgroundSelectedImage:Class;
		public static var _secondBackgroundSelectedBmp:Bitmap = new _secondBackgroundSelectedImage();
	}
}