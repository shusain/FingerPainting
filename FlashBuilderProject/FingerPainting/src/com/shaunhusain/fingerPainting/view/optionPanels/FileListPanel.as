package com.shaunhusain.fingerPainting.view.optionPanels
{
	import com.shaunhusain.fingerPainting.view.managers.LayerManager;
	import com.shaunhusain.fingerPainting.view.managers.SecondaryPanelManager;
	import com.shaunhusain.fingerPainting.view.mobileUIControls.ButtonScroller;
	import com.shaunhusain.layerdImageVOs.LayeredFileVO;
	import com.shaunhusain.openRaster.OpenRasterReader;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;

	public class FileListPanel extends PanelBase
	{
		private var fileListScroller:ButtonScroller;
		private var layerManager:LayerManager = LayerManager.getIntance();
		
		public function FileListPanel()
		{
			super();
			titleBackground.text = "File\nList";
			
			fileListScroller = new ButtonScroller();
			fileListScroller.buttonMaskHeight = backgroundSprite.height-24*model.dpiScale;
			fileListScroller.buttonMaskWidth = backgroundSprite.width - titleBackground.width;
			fileListScroller.addEventListener("fileChosen", fileChosenHandler);
			
			addChild(fileListScroller);
			
			
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		protected function fileChosenHandler(event:Event):void
		{
			var file_ani:File = (event.target as FileListRenderer).file;
			var fs_ani:FileStream;
			
			if(file_ani.extension == "png")
			{
				fs_ani = new FileStream();
				fs_ani.openAsync(file_ani, FileMode.READ);
				fs_ani.addEventListener(Event.COMPLETE, onFileComplete, false, 0, true);
			}
			else if(file_ani.extension == "ora")
			{
				var fs:FileStream = new FileStream();
				fs.open(file_ani,FileMode.READ);
				
				var ba:ByteArray = new ByteArray();
				fs.readBytes(ba);
				
				OpenRasterReader.getInstance().read(ba, handleLoadedFile);
			}
			SecondaryPanelManager.getIntance().hidePanel();
		}
		
		
		private function handleLoadedFile(file:LayeredFileVO):void
		{
			layerManager.layers = file.layers;
		}
		
		private function onFileComplete(event:Event):void
		{
			var fs:FileStream = event.target as FileStream;
			
			var ba:ByteArray = new ByteArray();
			fs.readBytes(ba,0,fs.bytesAvailable);
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completedLoadingFile);
			loader.loadBytes(ba);
			
			
			/*var fileContent:String = fs.readUTFBytes(fs.bytesAvailable);
			trace(fileContent);
			file_ani = null;
			fs_ani = null;*/
		}
		private function completedLoadingFile(event:Event):void
		{
			var loaderInfo:LoaderInfo = event.target as LoaderInfo;
			layerManager.addLayer(loaderInfo.loader);
		}
		
		protected function addedToStageHandler(event:Event):void
		{
			var fileList:Array = File.userDirectory.resolvePath("Digital Doodler").getDirectoryListing();
			
			var tempArray:Array = [];
			
			for each(var file:File in fileList)
			{
				if(file.extension == "png" || file.extension == "ora" || file.extension =="jpg" || file.extension== "gif")
				tempArray.push(new FileListRenderer(file));
			}	
			fileListScroller.menuButtons = tempArray;
		}		
		
	}
}