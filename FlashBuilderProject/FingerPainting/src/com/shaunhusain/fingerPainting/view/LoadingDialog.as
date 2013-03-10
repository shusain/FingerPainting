package com.shaunhusain.fingerPainting.view
{
	import com.shaunhusain.fingerPainting.model.PaintModel;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import org.bytearray.ScaleBitmap;
	
	public class LoadingDialog extends Sprite
	{
		
		[Embed(source="/logo.png")]
		private var logoClass:Class;
		private var logoBmp:Bitmap = new logoClass();
		
		[Embed(source="/loadingScreenBackground.png")]
		private var loadingScreenClass:Class;
		private var loadingScreenBmp:Bitmap = new loadingScreenClass();
		private var scaledLoadingScreen:ScaleBitmap = new ScaleBitmap(loadingScreenBmp.bitmapData);
		
		public var loadingText:TextField;
		private var createdByText:TextField;
		private var thankYouTitleText:TextField;
		
		private var loadingBarBackground:Sprite;
		private var loadingBar:Sprite;
		
		private var model:PaintModel = PaintModel.getInstance();
		
		public function set percentLoaded(value:Number):void
		{
			if(!stage)
				return;
			loadingBar.graphics.clear();
			loadingBar.graphics.beginFill(0xffff00);
			loadingBar.graphics.drawRect(0,0, (stage.fullScreenWidth - 100 * model.dpiScale) * value, 20*model.dpiScale);
			loadingBar.graphics.endFill();
		}
		public function set text(value:String):void
		{
			loadingText.text = value;
		}
		
		public function LoadingDialog(stage:Stage)
		{
			super();
			
			loadingText = new TextField();
			loadingText.autoSize = TextFieldAutoSize.LEFT;
			var loadingTextFormat:TextFormat = new TextFormat();
			loadingTextFormat.size = model.dpiScale*36;
			loadingTextFormat.font = "myFont";
			loadingTextFormat.color = 0xdfe500;
			loadingText.defaultTextFormat = loadingTextFormat;
			loadingText.y = stage.fullScreenHeight - model.dpiScale * 88;
			loadingText.x = model.dpiScale * 50;
			
			createdByText = new TextField();
			createdByText.autoSize = TextFieldAutoSize.CENTER;
			var createdByTextFormat:TextFormat = new TextFormat();
			createdByTextFormat.size = model.dpiScale*36;
			createdByTextFormat.font = "myFont";
			createdByTextFormat.color = 0xFFFFFF;
			createdByTextFormat.align = "center";
			createdByText.defaultTextFormat = createdByTextFormat;
			createdByText.text = "Made by Shaun Husain\nChiTownGames.com";
			createdByText.x = stage.fullScreenWidth/2 - createdByText.getLineMetrics(0).width/2;
			createdByText.y = stage.fullScreenHeight/2 + logoBmp.height/2 + 110*model.dpiScale;
			
			thankYouTitleText = new TextField();
			thankYouTitleText.autoSize = TextFieldAutoSize.CENTER;
			var thankYouTitleTextFormat:TextFormat = new TextFormat();
			thankYouTitleTextFormat.size = model.dpiScale*36;
			thankYouTitleTextFormat.font = "myFont";
			thankYouTitleTextFormat.color = 0xdfe500;
			thankYouTitleTextFormat.align = "center";
			thankYouTitleText.defaultTextFormat = thankYouTitleTextFormat;
			thankYouTitleText.text = "Thank you for using\nDigital Doodler";
			thankYouTitleText.x = stage.fullScreenWidth/2 - thankYouTitleText.getLineMetrics(0).width/2;
			thankYouTitleText.y = stage.fullScreenHeight/2 + logoBmp.height/2 + 20*model.dpiScale;
			
			scaledLoadingScreen.scale9Grid = new Rectangle(30, 30, 250, 350);
			scaledLoadingScreen.width = stage.fullScreenWidth;
			scaledLoadingScreen.height = stage.fullScreenHeight;
			
			logoBmp.x = stage.fullScreenWidth/2 - logoBmp.width/2;
			logoBmp.y = stage.fullScreenHeight/2 - logoBmp.height/2;
		
			loadingBarBackground = new Sprite();
			loadingBarBackground.graphics.beginFill(0x666666);
			loadingBarBackground.graphics.drawRect(0,0, stage.fullScreenWidth - 100*model.dpiScale, 20*model.dpiScale);
			loadingBarBackground.graphics.endFill();
			
			loadingBar = new Sprite();
			
			loadingBarBackground.y = loadingBar.y = stage.fullScreenHeight - model.dpiScale * 128;
			loadingBarBackground.x = loadingBar.x = model.dpiScale*50;
			
			addChild(scaledLoadingScreen);
			addChild(logoBmp);
			addChild(loadingText);
			addChild(createdByText);
			addChild(thankYouTitleText);
			
			addChild(loadingBarBackground);
			addChild(loadingBar);
		}
	}
}