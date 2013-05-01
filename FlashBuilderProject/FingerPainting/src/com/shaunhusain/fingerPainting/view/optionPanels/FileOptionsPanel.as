package com.shaunhusain.fingerPainting.view.optionPanels
{
	import com.shaunhusain.fingerPainting.model.PaintModel;
	import com.shaunhusain.fingerPainting.view.Box;
	import com.shaunhusain.fingerPainting.view.GenericBitmappedButton;
	import com.shaunhusain.fingerPainting.view.managers.LayerManager;
	import com.shaunhusain.fingerPainting.view.managers.SecondaryPanelManager;
	import com.shaunhusain.layerdImageVOs.LayeredFileVO;
	import com.shaunhusain.openRaster.OpenRasterReader;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;

	public class FileOptionsPanel extends PanelBase
	{
		//--------------------------------------------------------------------------------
		//				Variables
		//--------------------------------------------------------------------------------
		private var model:PaintModel = PaintModel.getInstance();
		private var layerManager:LayerManager = LayerManager.getIntance();
		private var bitmapData:BitmapData;
		private var saveButtonsBox:Box;
		private var saveOptions:SaveOptions;
		private var openOptions:FileListPanel;
		
		public var _buttonSelected:Bitmap;
		public var _buttonDeselected:Bitmap;
		
		//--------------------------------------------------------------------------------
		//				Constructor
		//--------------------------------------------------------------------------------
		public function FileOptionsPanel()
		{
			super();
			_buttonSelected = br.getBitmapByName("buttonSelected.png");
			_buttonDeselected = br.getBitmapByName("buttonDeselected.png");
			
			titleBackground.text = "File\nOptions";
			
			saveOptions = new SaveOptions();
			openOptions = new FileListPanel();
			
			saveButtonsBox = new Box();
			saveButtonsBox.x = backgroundSprite.width - _buttonSelected.width - 20*model.dpiScale;
			saveButtonsBox.y = backgroundSprite.height/2 - _buttonSelected.width*2.5;
			saveButtonsBox.gap = model.dpiScale*20;
			addChild(saveButtonsBox);
			
			saveButtonsBox.addChild(buildButton("New", handleNewClicked));
			saveButtonsBox.addChild(buildButton("Save", handleSaveClicked));
			saveButtonsBox.addChild(buildButton("Open", handleOpenClicked));
			saveButtonsBox.addChild(buildButton("Recover", handleRecoverClicked));
		}
		
		//--------------------------------------------------------------------------------
		//				Handlers
		//--------------------------------------------------------------------------------
		private function handleOpenClicked(event:Event):void
		{
			SecondaryPanelManager.getIntance().showPanel(openOptions);
		}
		
		private function handleSaveClicked(event:Event):void
		{
			SecondaryPanelManager.getIntance().showPanel(saveOptions);
		}
		
		private function handleNewClicked(event:Event):void
		{
			layerManager.buildDefaultLayers();
		}
		
		private function handleRecoverClicked(event:Event):void
		{
			var fs:FileStream = new FileStream();
			fs.open(File.userDirectory.resolvePath("Digital Doodler/autoSave.ora"),FileMode.READ);
			
			var ba:ByteArray = new ByteArray();
			fs.readBytes(ba);
			
			OpenRasterReader.getInstance().read(ba, handleLoadedFile);
		}
		
		private function handleOpenFromOpenRasterClicked(event:Event):void
		{
			
			var fs:FileStream = new FileStream();
			fs.open(File.userDirectory.resolvePath("Digital Doodler/test.ora"),FileMode.READ);
			
			var ba:ByteArray = new ByteArray();
			fs.readBytes(ba);
			
			OpenRasterReader.getInstance().read(ba, handleLoadedFile);
		}
		
		private function handleLoadedFile(file:LayeredFileVO):void
		{
			layerManager.layers = file.layers;
		}
		
		private function buildButton(label:String, handler:Function):GenericBitmappedButton
		{
			var button:GenericBitmappedButton=new GenericBitmappedButton(null,false);
			button.text = label;
			button.addEventListener("circleButtonClicked", handler);
			return button;
		}
		
	}
}