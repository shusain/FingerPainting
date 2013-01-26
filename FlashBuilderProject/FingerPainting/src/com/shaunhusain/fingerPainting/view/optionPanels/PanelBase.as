package com.shaunhusain.fingerPainting.view.optionPanels
{
	import com.shaunhusain.fingerPainting.view.managers.SecondaryPanelManager;
	import com.shaunhusain.fingerPainting.view.mobileUIControls.CircleButton;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextFormat;
	
	/**
	 * Draws the components common to all pop-ups, namely the background, close
	 * button, and title.
	 */
	public class PanelBase extends Sprite
	{
		[Embed(source="/images/panelBackground.png")]
		private static var _panelBackgroundClass:Class;
		public static var _panelBackgroundBmp:Bitmap = new _panelBackgroundClass();
		[Embed(source="/images/titleBackground.png")]
		private static var _titleBackgroundClass:Class;
		public static var _titleBackgroundBmp:Bitmap = new _titleBackgroundClass();
		[Embed(source="/images/closeButton.png")]
		private static var _closeButtonClass:Class;
		public static var _closeButtonBmp:Bitmap = new _closeButtonClass();
		
		[Embed(source="/Roboto-Black.ttf", fontName = "robotoBlack", mimeType = "application/x-font", fontStyle="normal", unicodeRange="U+0020-007E", advancedAntiAliasing="true", embedAsCFF="false")]
		private var myEmbeddedFont:Class;
		
		
		protected var backgroundSprite:Sprite;
		protected var titleBackground:CircleButton;
		protected var closeButton:CircleButton;
		
		public function PanelBase()
		{
			super();
			
			if(!backgroundSprite)
			{
				backgroundSprite = new Sprite();
				backgroundSprite.graphics.clear();
				backgroundSprite.graphics.beginBitmapFill(_panelBackgroundBmp.bitmapData);
				backgroundSprite.graphics.drawRect(0,0,_panelBackgroundBmp.width,_panelBackgroundBmp.height);
				backgroundSprite.graphics.endFill();
				addChild(backgroundSprite);
			}
			if(!titleBackground)
			{
				var titleTextFormat:TextFormat;
				titleTextFormat = new TextFormat();
				titleTextFormat.size = 36;
				titleTextFormat.font = "robotoBlack";
				titleBackground = new CircleButton(_titleBackgroundBmp.bitmapData,_titleBackgroundBmp.bitmapData, titleTextFormat);
				titleBackground.x = 375;
				titleBackground.y = 888;
				addChild(titleBackground);
			}
			if(!closeButton)
			{
				closeButton = new CircleButton(_closeButtonBmp.bitmapData,_closeButtonBmp.bitmapData, titleTextFormat);
				closeButton.addEventListener("circleButtonClicked", closeButtonHandler);
				closeButton.x = 448;
				closeButton.y = 12;
				addChild(closeButton);
			}
		}
		
		protected function closeButtonHandler(event:Event):void
		{
			SecondaryPanelManager.getIntance().hidePanel();
		}
		private var _titleText:String;

		public function get titleText():String
		{
			return _titleText;
		}

		public function set titleText(value:String):void
		{
			if(value == _titleText)
				return;
			
			_titleText = value;
			titleBackground.text = _titleText;
		}

	}
}