package com.shaunhusain.fingerPainting.view
{
	import flash.display.Bitmap;
	
	import org.bytearray.ScaleBitmap;

	public class BitmapReference
	{
		/** Layer option buttons **/
		[Embed(source="/images/addIcon.png")]
		private static var _addIcon:Class;
		public static var _addBmp:Bitmap = new _addIcon();
		
		[Embed(source="/images/removeIcon.png")]
		private static var _removeIcon:Class;
		public static var _removeBmp:Bitmap = new _removeIcon();
		
		[Embed(source="/images/moveUpIcon.png")]
		private static var _moveUpIcon:Class;
		public static var _moveUpBmp:Bitmap = new _moveUpIcon();
		
		[Embed(source="/images/moveDownIcon.png")]
		private static var _moveDownIcon:Class;
		public static var _moveDownBmp:Bitmap = new _moveDownIcon();
		
		[Embed(source="/images/merge.png")]
		private static var _mergeIcon:Class;
		public static var _mergeBmp:Bitmap = new _mergeIcon();
		
		[Embed(source="/images/duplicate.png")]
		private static var _dupIcon:Class;
		public static var _dupBmp:Bitmap = new _dupIcon();
		
		[Embed(source="/images/mirror.png")]
		private static var _mirrorIcon:Class;
		public static var _mirrorBmp:Bitmap = new _mirrorIcon();
		
		[Embed(source="/images/visibility.png")]
		private static var _visiblityIcon:Class;
		public static var _visibilityBmp:Bitmap = new _visiblityIcon();
		
		[Embed(source="/images/visibilitySelected.png")]
		private static var _visiblitySelectedIcon:Class;
		public static var _visibilitySelectedBmp:Bitmap = new _visiblitySelectedIcon();
		
		
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