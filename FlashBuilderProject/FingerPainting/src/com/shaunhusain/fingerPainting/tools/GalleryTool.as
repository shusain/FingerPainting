package com.shaunhusain.fingerPainting.tools 
{
	import flash.display.Loader;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MediaEvent;
	import flash.events.TouchEvent;
	import flash.media.CameraRoll;
	import flash.media.CameraUI;
	import flash.media.MediaPromise;
	
	public class GalleryTool extends ToolBase implements ITool
	{
		//--------------------------------------------------------------------------------
		//				Variables
		//--------------------------------------------------------------------------------
		private var mediaSource:CameraRoll = new CameraRoll();
		private var deviceCameraApp:CameraUI = new CameraUI();
		private var imageLoader:Loader; 
		
		//--------------------------------------------------------------------------------
		//				Constructor
		//--------------------------------------------------------------------------------
		public function GalleryTool(stage:Stage) {
			super(stage);
			
			mediaSource.addEventListener( MediaEvent.SELECT, imageSelected );
			mediaSource.addEventListener( Event.CANCEL, browseCanceled );
			
		}
		
		//--------------------------------------------------------------------------------
		//				Handlers
		//--------------------------------------------------------------------------------
		public function takeAction(event:TouchEvent=null):void
		{
			model.disableNextAutosave = true;
			
			if( CameraRoll.supportsBrowseForImage )
			{
				log( "Browsing for image..." );
				
				mediaSource.browseForImage();
			}
			else
			{
				log( "Browsing in camera roll is not supported.");
			}
		}
		
		//--------------------------------------------------------------------------------
		//				Handlers
		//--------------------------------------------------------------------------------
		private function imageSelected( event:MediaEvent ):void
		{
			log( "Image selected..." );
			
			var imagePromise:MediaPromise = event.data;
			
			imageLoader = new Loader();
			if( imagePromise.isAsync )
			{
				log( "Asynchronous media promise." );
				imageLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, imageLoaded );
				imageLoader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, imageLoadFailed );
				imageLoader.loadFilePromise( imagePromise );
			}
			else
			{
				log( "Synchronous media promise." );
				imageLoader.loadFilePromise( imagePromise );
				layerM.addLayer( imageLoader );
			}
		}
		
		private function browseCanceled( event:Event ):void
		{
			log( "Image browse canceled." );
		}
		
		private function imageLoaded( event:Event ):void
		{
			log( "Image loaded asynchronously." );
			layerM.addLayer( imageLoader );
			layerM.currentLayer.updateThumbnail();
		}
		
		private function imageLoadFailed( event:Event ):void
		{
			log( "Image load failed." );
		}
		
		private function log( text:String ):void
		{
			trace( text );
		}
		
		public function toString():String
		{
			return "Gallery";
		}
		
	}
}