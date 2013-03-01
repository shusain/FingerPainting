package com.shaunhusain.fingerPainting.view.optionPanels
{
	import com.shaunhusain.fingerPainting.model.PaintModel;
	import com.shaunhusain.fingerPainting.view.managers.HelpManager;
	import com.shaunhusain.fingerPainting.view.managers.LayerManager;
	import com.shaunhusain.fingerPainting.view.mobileUIControls.CircleButton;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.media.CameraRoll;
	import flash.utils.ByteArray;

	public class SavePanel extends PanelBase
	{
		//--------------------------------------------------------------------------------
		//				Variables
		//--------------------------------------------------------------------------------
		private var model:PaintModel = PaintModel.getInstance();
		private var layerManager:LayerManager = LayerManager.getIntance();
		private var bitmapData:BitmapData;
		private var saveButton:CircleButton;
		
		//--------------------------------------------------------------------------------
		//				Constructor
		//--------------------------------------------------------------------------------
		public function SavePanel()
		{
			titleText = "Save\nOptions";
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		//--------------------------------------------------------------------------------
		//				Handlers
		//--------------------------------------------------------------------------------
		private function addedToStageHandler(event:Event):void
		{
			saveButton = new CircleButton();
			saveButton.text = "Save";
			saveButton.x = 20;
			saveButton.y = 20;
			saveButton.addEventListener("circleButtonClicked", handleSaveClicked);
			addChild(saveButton);
		}
		
		protected function handleSaveClicked(event:Event):void
		{
			/*var newFile:File = File.applicationDirectory.resolvePath("DD"+new Date().milliseconds.toString()+".png");
			var str:String = "Hello.";
			if (!newFile.exists)
			{
				var stream:FileStream = new FileStream();
				stream.open(newFile, FileMode.WRITE);
				stream.writeBytes(PNGEncoder2.encode(layerManager.getFlattenedBitmapData()))
				stream.close();
			}*/
			var cameraRoll:CameraRoll = new CameraRoll();
			cameraRoll.addBitmapData(layerManager.getFlattenedBitmapData());
		}
		
		protected function saveData(event:Event):void
		{
			HelpManager.getIntance().showMessage("File Saving", 750, false);
			
		}
		
	}
}