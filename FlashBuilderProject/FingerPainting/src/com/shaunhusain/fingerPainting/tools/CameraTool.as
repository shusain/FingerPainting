package com.shaunhusain.fingerPainting.tools 
{
	import flash.display.Loader;
	import flash.display.Stage;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MediaEvent;
	import flash.events.TouchEvent;
	import flash.media.CameraUI;
	import flash.media.MediaPromise;
	import flash.media.MediaType;
	
	public class CameraTool extends ToolBase implements ITool
	{
		//--------------------------------------------------------------------------------
		//				Variables
		//--------------------------------------------------------------------------------
		private var deviceCameraApp:CameraUI = new CameraUI();
		private var imageLoader:Loader; 
		
		//--------------------------------------------------------------------------------
		//				Constructor
		//--------------------------------------------------------------------------------
		public function CameraTool(stage:Stage) {
			super(stage);
			
			if( CameraUI.isSupported )
			{
				trace( "Initializing camera..." );
				
				deviceCameraApp.addEventListener( MediaEvent.COMPLETE, imageCaptured );
				deviceCameraApp.addEventListener( Event.CANCEL, captureCanceled );
				deviceCameraApp.addEventListener( ErrorEvent.ERROR, cameraError );
			}
			else
			{
				trace( "Camera interface is not supported.");
			}
		}
		
		//--------------------------------------------------------------------------------
		//				Handlers
		//--------------------------------------------------------------------------------
		public function takeAction(event:TouchEvent=null):void
		{
			model.disableNextAutosave = true;
			deviceCameraApp.launch( MediaType.IMAGE );
		}
		
		//--------------------------------------------------------------------------------
		//				Camera UI functions
		//--------------------------------------------------------------------------------
		
		private function imageCaptured( event:MediaEvent ):void
		{
			trace( "Media captured..." );
			
			var imagePromise:MediaPromise = event.data;
			
			if( imagePromise.isAsync )
			{
				trace( "Asynchronous media promise." );
				imageLoader = new Loader();
				imageLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, asyncImageLoaded );
				imageLoader.addEventListener( IOErrorEvent.IO_ERROR, cameraError );
				
				imageLoader.loadFilePromise( imagePromise );
			}
			else
			{
				trace( "Synchronous media promise." );
				imageLoader.loadFilePromise( imagePromise );
				showMedia( imageLoader );
			}
		}
		
		private function captureCanceled( event:Event ):void
		{
			trace( "Media capture canceled." );
		}
		
		private function asyncImageLoaded( event:Event ):void
		{
			trace( "Media loaded in memory." );
			showMedia( imageLoader );    
		}
		
		private function showMedia( loader:Loader ):void
		{
			loader.scaleX=-1;
			layerM.addLayer( loader );
		}
		
		private function cameraError( error:ErrorEvent ):void
		{
			trace( "Error:" + error.text );
		}
		
		public function toString():String
		{
			return "Loading CameraUI";
		}
		
	}
}