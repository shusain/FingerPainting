package com.shaunhusain.fingerPainting.view.optionPanels
{
	import com.christiancantrell.NativeText;
	import com.shaunhusain.fingerPainting.view.Box;
	import com.shaunhusain.fingerPainting.view.GenericBitmappedButton;
	import com.shaunhusain.fingerPainting.view.managers.HelpManager;
	import com.shaunhusain.fingerPainting.view.managers.LayerManager;
	import com.shaunhusain.fingerPainting.view.managers.SecondaryPanelManager;
	import com.shaunhusain.layerdImageVOs.LayeredFileVO;
	import com.shaunhusain.openRaster.OpenRasterWriter;
	
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.media.CameraRoll;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;

	public class SaveOptions extends PanelBase
	{
		private var textInput:NativeText;
		private var saveButton:GenericBitmappedButton;
		private var layerManager:LayerManager = LayerManager.getIntance();
		private var chosenOption:String = "ORA";
		
		private var wrapperBox:Box = new Box();
		
		public function SaveOptions()
		{
			super();
			titleBackground.text = "Save\nOptions";
			
			wrapperBox = new Box();
			wrapperBox.y = model.dpiScale*20;
			wrapperBox.x = model.dpiScale*20;
			
			wrapperBox.direction = "horizontal";
			wrapperBox.addChild(buildButton("Gallery", saveOptionChanged));
			var oraButton:GenericBitmappedButton = buildButton("ORA", saveOptionChanged);
			oraButton.selected = true;
			wrapperBox.addChild(oraButton);
			wrapperBox.addChild(buildButton("PNG", saveOptionChanged));
			
			
			addChild(wrapperBox);
			
			
			graphics.beginFill(0xcccccc);
			graphics.drawRect(0,0,400*model.dpiScale,1000*model.dpiScale);
			
			textInput = new NativeText();
			textInput.borderThickness = 1;
			textInput.width = 300*model.dpiScale;
			textInput.fontSize = 36*model.dpiScale;
			
			textInput.x = 20 * model.dpiScale;
			textInput.y = 140 * model.dpiScale;
			
			textInput.addEventListener(Event.ADDED_TO_STAGE, function(event:Event):void
			{
				textInput.assignFocus();
			}
			);
			
			saveButton = new GenericBitmappedButton(null,false);
			saveButton.addEventListener("circleButtonClicked", saveButtonHandler);
			saveButton.text = "Save";
			saveButton.x = 20 * model.dpiScale;
			saveButton.y = 200 * model.dpiScale;
			
			addChild(saveButton);
			
			addChild(textInput);
		}
		
		private function saveOptionChanged(event:Event):void
		{
			for(var i:int = 0; i<wrapperBox.numChildren; i++)
			{
				var circButton:GenericBitmappedButton = wrapperBox.getChildAt(i) as GenericBitmappedButton;
				if(event.target != circButton)
					circButton.selected = false;
			}
			
			chosenOption = (event.target as GenericBitmappedButton).text;
		}
		
		protected function saveButtonHandler(event:Event):void
		{
			switch(chosenOption)
			{
				case "Gallery":
				{
					saveToGallery();
					break;
				}
				case "PNG":
				{
					savePNG()
					break;
				}
				case "ORA":
				{
					saveORA();
					break;
				}
					
				default:
				{
					break;
				}
			}
			
		}
		
		private function saveORA():void
		{
			HelpManager.getIntance().showMessage("Beginning save", 500);
			
			setTimeout(function():void
			{
				var fs:FileStream = new FileStream();
				fs.open(File.userDirectory.resolvePath("Digital Doodler/"+textInput.text+".ora"),FileMode.WRITE);
				
				var file:LayeredFileVO = new LayeredFileVO();
				
				file.width = stage.fullScreenWidth;
				file.height = stage.fullScreenHeight;
				
				file.layers = layerManager.layers;
				
				var openRaster:OpenRasterWriter = OpenRasterWriter.getInstance();
				var ba:ByteArray = openRaster.write(file);
				ba.position = 0;
				fs.writeBytes(ba);
				SecondaryPanelManager.getIntance().hidePanel();
				HelpManager.getIntance().showMessage("Save Completed", 500);
			},500);
		}
		
		protected function savePNG():void
		{
			var newFile:File = File.applicationStorageDirectory.resolvePath("Digital Doodler/DD"+new Date().time+".png");
			newFile.browseForSave("Type a path to save your file");
			newFile.addEventListener(Event.SELECT, handleFileSelected);
		}
		
		protected function handleFileSelected(event:Event):void
		{
			var newFile:File = event.target as File;
			if (!newFile.exists)
			{
				var stream:FileStream = new FileStream();
				stream.open(newFile, FileMode.WRITE);
				stream.writeBytes(PNGEncoder2.encode(layerManager.getFlattenedBitmapData()))
				stream.close();
			}
		}
		
		protected function saveToGallery():void
		{
			var cameraRoll:CameraRoll = new CameraRoll();
			cameraRoll.addBitmapData(layerManager.getFlattenedBitmapData());
		}
		
		private function buildButton(label:String, handler:Function):GenericBitmappedButton
		{
			var button:GenericBitmappedButton=new GenericBitmappedButton();
			button.text = label;
			button.addEventListener("circleButtonClicked", handler);
			return button;
		}
	}
}