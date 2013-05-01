package com.shaunhusain.fingerPainting.view.optionPanels
{
	import com.shaunhusain.fingerPainting.model.PaintModel;
	import com.shaunhusain.fingerPainting.view.GenericBitmappedButton;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class FileListRenderer extends Sprite
	{
		private var openButton:GenericBitmappedButton;
		private var textField:TextField;
		private var model:PaintModel = PaintModel.getInstance();
		private var _file:File;
		
		public function FileListRenderer(file:File)
		{
			super();
			_file = file;
			
			openButton = new GenericBitmappedButton();
			openButton.text = "Open";
			openButton.addEventListener("circleButtonClicked", handleClicked);
			addChild(openButton);
			
			textField = new TextField();
			textField.textColor = 0xFFFFFF;
			
			var textFormat:TextFormat = new TextFormat();
			textFormat.size = 36 * model.dpiScale;
			textField.defaultTextFormat = textFormat;  
			textField.text = file.name;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.x = openButton.width + 20*model.dpiScale;
			textField.y = 20*model.dpiScale;
			
			addChild(textField);
			
			graphics.beginFill(0xffffff);
			graphics.drawRect(0,0, 300,2);
		}
		
		public function get file():File
		{
			return _file;
		}
		
		protected function handleClicked(event:Event):void
		{
			dispatchEvent(new Event("fileChosen",true));
		}
	}
}