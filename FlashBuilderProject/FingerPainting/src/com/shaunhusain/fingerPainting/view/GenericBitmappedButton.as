package com.shaunhusain.fingerPainting.view
{
	import com.shaunhusain.fingerPainting.view.mobileUIControls.CircleButton;
	
	import flash.display.Bitmap;
	import flash.text.TextFormat;
	
	public class GenericBitmappedButton extends CircleButton
	{
		private var br:BitmapReference = BitmapReference.getInstance();
		
		private var _buttonSelected:Bitmap;
		private var _buttonDeselected:Bitmap;
		
		public function GenericBitmappedButton(textFormat:TextFormat=null, toggle:Boolean=true)
		{
			_buttonSelected = br.getBitmapByName("buttonSelected.png");
			_buttonDeselected = br.getBitmapByName("buttonDeselected.png");
			super(_buttonDeselected.bitmapData, _buttonSelected.bitmapData, textFormat, toggle);
		}
	}
}