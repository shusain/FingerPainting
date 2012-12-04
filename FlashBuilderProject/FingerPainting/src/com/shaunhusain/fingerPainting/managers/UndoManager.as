package com.shaunhusain.fingerPainting.managers
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.PNGEncoderOptions;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	public class UndoManager extends EventDispatcher
	{
		private static var instance:UndoManager;
		private var historyStack:Array;
		private var currentIndex:int = -1;
		private var redoCallback:Function;
		private var undoCallback:Function;
		
		private var redoLoader:Loader;
		private var undoLoader:Loader;
		
		private var loading:Boolean;
		
		private var encodingRect:Rectangle;
		private var encodingOptions:PNGEncoderOptions = new flash.display.PNGEncoderOptions();
		
		public static function getIntance():UndoManager
		{
			if( instance == null ) instance = new UndoManager( new SingletonEnforcer() );
			return instance;
		}
		
		/**
		 * Used to deal with calls to undo, redo, making new history elements and
		 * generally managing the history stack.
		 * 
		 * @param se Blocks creation of new managers instead use static method getInstance
		 */
		public function UndoManager(se:SingletonEnforcer)
		{
			historyStack=[];
			redoLoader = new Loader();
			undoLoader = new Loader();
			PNGEncoder2.level = CompressionLevel.GOOD;
		}
		
		public function undo(callback:Function):void
		{
			if(loading)
				return;
			undoCallback = callback;
			loading=true;
			currentIndex--;
			if(currentIndex<0)
				currentIndex=0;
			
			undoLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, undoLoaderHandler);
			undoLoader.loadBytes(historyStack[currentIndex]);
		}
		public function redo(callback:Function):void
		{
			if(loading)
				return;
			loading=true;
			redoCallback = callback;
			currentIndex++;
			if(currentIndex>historyStack.length-1)
				currentIndex = historyStack.length-1;
			
			redoLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, redoLoaderHandler);
			redoLoader.loadBytes(historyStack[currentIndex]);
		}
		
		private function redoLoaderHandler(event:Event):void
		{
			redoCallback(Bitmap(event.target.content).bitmapData);
			loading = false;
		}
		
		private function undoLoaderHandler(event:Event):void
		{
			undoCallback(Bitmap(event.target.content).bitmapData);
			loading = false;
		}
		
		
		public function addHistoryElement(bd:BitmapData):void
		{
			if(!encodingRect)
				encodingRect = new Rectangle(0,0,bd.width,bd.height)
			if(currentIndex<historyStack.length-1)
				historyStack.splice(currentIndex+1);
			
			var byteArray:ByteArray = new ByteArray();
			
			//bd.encode(encodingRect, encodingOptions, byteArray);
			byteArray = PNGEncoder2.encode(bd);
			historyStack.push(byteArray);
			currentIndex++;
			if(historyStack.length>200)
			{
				historyStack.shift();
				currentIndex--;
			}
		}
	}
}

internal class SingletonEnforcer {public function SingletonEnforcer(){}}