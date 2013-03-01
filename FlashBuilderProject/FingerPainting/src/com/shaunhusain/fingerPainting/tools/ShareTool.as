package com.shaunhusain.fingerPainting.tools 
{
	import com.jam3media.shareExt.ShareExt;
	
	import flash.display.Stage;
	import flash.events.TouchEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	public class ShareTool extends ToolBase implements ITool
	{
		//--------------------------------------------------------------------------------
		//				Variables
		//--------------------------------------------------------------------------------
		private var file:File;
		private var share:ShareExt
		
		//--------------------------------------------------------------------------------
		//				Constructor
		//--------------------------------------------------------------------------------
		public function ShareTool(stage:Stage)
		{
			super(stage);
		}
		
		//--------------------------------------------------------------------------------
		//				Handlers
		//--------------------------------------------------------------------------------
		public function takeAction(event:TouchEvent=null):void
		{
			getFile();
		}
		
		//--------------------------------------------------------------------------------
		//				Helper functions
		//--------------------------------------------------------------------------------
		private function getFile():void
		{
			//find a file to share
			var bytearray:ByteArray = PNGEncoder2.encode(layerM.getFlattenedBitmapData());
			file = File.documentsDirectory.resolvePath("temp.png");
			
			var fs:FileStream = new FileStream();
			fs.open(file,FileMode.WRITE);
			fs.writeBytes(bytearray);
			fs.close();
			shareFile();
		}
		private function shareFile():void
		{
			//list of all valid extensions - more can be added to support new types  - some of these might not even be supported by android 
			var imageExtensions:Array = ["jpg","jpeg","png","gif"];
			var audioExtensions:Array = ["wav","mp3","m4a"];
			var videoExtensions:Array = ["wmv","mp4","avi","flv","f4v"];
			
			//this next chunck of ugly code figures out what the mime type of the file is so that android launches the approprate share list.			
			var ext:String = file.extension;
			var str:String
			
			//if the extension doesn't match any from our arrays it will remain the defauld application/* and be shared as a file. 
			var mimeType:String = "application/*";
			
			for each (str in imageExtensions){
				if(ext==str){
					mimeType = "image/*";
					break;
				}
			}
			for each (str in videoExtensions){
				if(ext==str){
					mimeType = "video/*";
					break;
				}
			}
			for each (str in audioExtensions){
				if(ext==str){
					mimeType = "audio/*";
					break;
				}
			}
			
			/*
			here's the magic:			
			instantiate our Native Extension and share our file
			*/			
			share = new ShareExt();
			share.shareMedia(file.name,file.nativePath, mimeType);
			
		}
		
		public function toString():String
		{
			return "Share: sending flattened PNG to Android system";
		}
	}
}