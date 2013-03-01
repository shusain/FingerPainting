package com.shaunhusain.fingerPainting.view
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.system.Capabilities;
	import flash.text.TextField;

	public class BitmapReference
	{
		private static var instance:BitmapReference;
		
		private var brLookup:Object;
		private var loadingCompleteCallback:Function;
		
		private var filesToLoad:Array;
		private var currentlyLoading:String;
		
		private var debugTextField:TextField;
		
		public static function getInstance():BitmapReference
		{
			if(!instance)
				instance = new BitmapReference(new SingletonEnforcer());
			return instance;
		}
		
		public function BitmapReference(se:SingletonEnforcer)
		{
			brLookup = {};
		}
		
		public function loadBitmaps(callback:Function, debugTextField:TextField):void
		{
			var curDPI:String;
			
			if(Capabilities.screenDPI<=160)
				curDPI = "160";
			else if(Capabilities.screenDPI<=240 || Capabilities.screenResolutionY<1000)
				curDPI = "240";
			else
				curDPI = "320";
			var folderName:String = "images" + curDPI + "/";
			
			this.debugTextField = debugTextField;
			
			loadingCompleteCallback = callback;
			loadFolderOfBitmaps(folderName);
		}
		
		private function loadFolderOfBitmaps(folderName:String):void
		{
			var file:File = File.applicationDirectory.resolvePath(folderName);
			debugTextField.text = "Loading UI" + folderName;
			
			filesToLoad = file.getDirectoryListing();
			iterativeLoading();
		}
		
		private function iterativeLoading():void
		{
			var fileInDir:File = filesToLoad.shift();
			
			if(fileInDir.name == "Thumbs.db")
			{
				iterativeLoading();
				return;
			}
			debugTextField.text = "Loading UI: " + fileInDir.name;
			
			fileInDir.addEventListener(Event.COMPLETE, fileLoadCompleted);
			fileInDir.addEventListener(IOErrorEvent.IO_ERROR, function(event:IOErrorEvent):void {trace ("IOError loading files." + event.type)});
			fileInDir.load();
		}
		
		public function getBitmapByName(value:String):Bitmap
		{
			if(brLookup[value])
				return brLookup[value];
			else
				throw Error("Asset wasn't loaded in advance, be sure the name matches the file name in the images folder");
		}
		
		protected function fileLoadCompleted(event:Event):void
		{
			var loadedFile:File = event.target as File;
			currentlyLoading = loadedFile.name;
			
			//debugTextField.text = "Finished loading: " + loadedFile.name;
			var loader:Loader = brLookup[loadedFile.name] = new Loader();
			
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderCompleted);
			loader.loadBytes(loadedFile.data);
		}	
		
		protected function loaderCompleted(event:Event):void
		{
			brLookup[currentlyLoading] = event.target.content as Bitmap;
			
			if(filesToLoad.length>0)
				iterativeLoading();
			else
				loadingCompleteCallback();
		}
	}
}
internal class SingletonEnforcer {}