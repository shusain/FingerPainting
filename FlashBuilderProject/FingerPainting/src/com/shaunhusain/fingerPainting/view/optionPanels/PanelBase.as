package com.shaunhusain.fingerPainting.view.optionPanels
{
	import com.shaunhusain.fingerPainting.model.PaintModel;
	import com.shaunhusain.fingerPainting.view.BitmapReference;
	import com.shaunhusain.fingerPainting.view.managers.SecondaryPanelManager;
	import com.shaunhusain.fingerPainting.view.mobileUIControls.CircleButton;
	import com.shaunhusain.fingerPainting.view.mobileUIControls.RotatingIconButton;
	
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
		protected var br:BitmapReference = BitmapReference.getInstance();
		
		public var _panelBackgroundBmp:Bitmap = br.getBitmapByName("panelBackground.png");
		public var _titleBackgroundBmp:Bitmap = br.getBitmapByName("titleBackground.png");
		public var _closeButtonBmp:Bitmap = br.getBitmapByName("closeButton.png");
		
		[Embed(source="/Roboto-Black.ttf", fontName = "robotoBlack", mimeType = "application/x-font", fontStyle="normal", unicodeRange="U+0020-007E", advancedAntiAliasing="true", embedAsCFF="false")]
		private var myEmbeddedFont:Class;
		
		
		protected var backgroundSprite:Sprite;
		protected var titleBackground:CircleButton;
		protected var closeButton:RotatingIconButton;
		protected var model:PaintModel = PaintModel.getInstance();
		
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
				titleTextFormat.size = 36 * model.dpiScale;
				titleTextFormat.font = "robotoBlack";
				titleBackground = new CircleButton(_titleBackgroundBmp.bitmapData,_titleBackgroundBmp.bitmapData, titleTextFormat);
				titleBackground.x = _panelBackgroundBmp.width-titleBackground.width-12*model.dpiScale;
				titleBackground.y = _panelBackgroundBmp.height-titleBackground.height-12*model.dpiScale;
				addChild(titleBackground);
			}
			if(!closeButton)
			{
				closeButton = new RotatingIconButton(_closeButtonBmp,null,null,true);
				closeButton.addEventListener("instantaneousButtonClicked", closeButtonHandler);
				closeButton.x = _panelBackgroundBmp.width - closeButton.width - 12*model.dpiScale;
				closeButton.y = 12*model.dpiScale;
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