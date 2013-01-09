package com.shaunhusain.fingerPainting.tools 
{
	import flash.display.Loader;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MediaEvent;
	import flash.events.TouchEvent;
	import flash.media.CameraRoll;
	import flash.media.MediaPromise;
	
	public class CameraTool extends ToolBase implements ITool
	{
		//--------------------------------------------------------------------------------
		//				Variables
		//--------------------------------------------------------------------------------
		private var mediaSource:CameraRoll = new CameraRoll();
		private var imageLoader:Loader; 
		
		//--------------------------------------------------------------------------------
		//				Constructor
		//--------------------------------------------------------------------------------
		public function CameraTool(stage:Stage) {
			super(stage);
			
		}
		
		//--------------------------------------------------------------------------------
		//				Handlers
		//--------------------------------------------------------------------------------
		public function takeAction(event:TouchEvent=null):void
		{
			if( CameraRoll.supportsBrowseForImage )
			{
				log( "Browsing for image..." );
				mediaSource.addEventListener( MediaEvent.SELECT, imageSelected );
				mediaSource.addEventListener( Event.CANCEL, browseCanceled );
				
				mediaSource.browseForImage();
			}
			else
			{
				log( "Browsing in camera roll is not supported.");
			}
			/*if(!frontCamera)
			{
			trace(Camera.names);
			backCamera = Camera.getCamera("0");
			backCamera.setMode(640,360,5);
			frontCamera = Camera.getCamera("1");
			frontCamera.setMode(640,360,5);
			video = new Video(stage.fullScreenHeight,stage.fullScreenWidth);
			video.x = -stage.fullScreenHeight/2;
			video.y = -stage.fullScreenWidth/2;
			video.attachCamera(frontCamera);
			video.visible = false;
			model.cameraWrapper.addChild(video);
			model.cameraWrapper.scaleX = -1;
			model.cameraWrapper.rotation = -90;
			model.video = video;
			
			showingFrontCamera = true;
			}
			video.visible = !video.visible;*/
			
		}
		
		//--------------------------------------------------------------------------------
		//				Helper functions
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
				layerManager.addLayer( imageLoader );
			}
		}
		
		private function browseCanceled( event:Event ):void
		{
			log( "Image browse canceled." );
		}
		
		private function imageLoaded( event:Event ):void
		{
			log( "Image loaded asynchronously." );
			layerManager.addLayer( imageLoader );
			layerManager.currentLayer.updateThumbnail();
		}
		
		private function imageLoadFailed( event:Event ):void
		{
			log( "Image load failed." );
		}
		
		private function log( text:String ):void
		{
			trace( text );
		}
		
	}
}