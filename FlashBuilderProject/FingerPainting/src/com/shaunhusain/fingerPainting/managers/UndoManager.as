package com.shaunhusain.fingerPainting.managers
{
	import com.shaunhusain.fingerPainting.view.managers.HelpManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.system.System;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	/**
	 * Used to deal with calls to undo, redo, making new history elements and
	 * generally managing the history stack.
	 */
	public class UndoManager
	{
		//--------------------------------------------------------------------------------
		//				Constants
		//--------------------------------------------------------------------------------
		private const SAVE_TIMER_DELAY:Number = 1000;
		
		//--------------------------------------------------------------------------------
		//				Variables
		//--------------------------------------------------------------------------------
		private var historyStack:Array;
		private var currentIndex:int = -1;
		private var redoCallback:Function;
		private var undoCallback:Function;
		
		private var redoLoader:Loader;
		private var undoLoader:Loader;
		
		private var loading:Boolean;
		
		private var encodingRect:Rectangle;
		
		private var saveDelayTimer:Timer;
		
		private var tempBD:BitmapData;
		
		private var currentlySaving:Boolean;
		
		//--------------------------------------------------------------------------------
		//				Constructor
		//--------------------------------------------------------------------------------
		/**
		 * Initializes the history stack and loaders for decompressing the PNG
		 * data saved by the encoder.
		 * 
		 * @param se Blocks creation of new managers instead use static method getInstance
		 */
		public function UndoManager(se:SingletonEnforcer)
		{
			historyStack=[];
			redoLoader = new Loader();
			undoLoader = new Loader();
			undoLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, undoLoaderHandler);
			redoLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, redoLoaderHandler);
			PNGEncoder2.level = CompressionLevel.NORMAL;
			
			saveDelayTimer = new Timer(SAVE_TIMER_DELAY,1);
			saveDelayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, actuallySave);
		}
		
		//--------------------------------------------------------------------------------
		//				Singleton
		//--------------------------------------------------------------------------------
		private static var instance:UndoManager;
		public static function getIntance():UndoManager
		{
			if( instance == null ) instance = new UndoManager( new SingletonEnforcer() );
			return instance;
		}
		
		//--------------------------------------------------------------------------------
		//				Public Methods
		//--------------------------------------------------------------------------------
		public function addHistoryElement(bd:BitmapData):void
		{
			tempBD = bd.clone();
			
			if(saveDelayTimer.running)
			{
				saveDelayTimer.stop();
				saveDelayTimer.reset();
			}
			saveDelayTimer.start();
			
		}
		
		public function extendTimer():void
		{
			saveDelayTimer.stop();
			saveDelayTimer.reset();
			saveDelayTimer.start();
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
			
			if(historyStack.length==0)
				return;
			
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
			
			redoLoader.loadBytes(historyStack[currentIndex]);
		}
		
		//--------------------------------------------------------------------------------
		//				Handlers
		//--------------------------------------------------------------------------------
		private function redoLoaderHandler(event:Event):void
		{
			redoCallback(Bitmap(event.target.content).bitmapData);
			loading = false;
			System.gc();
		}
		
		private function undoLoaderHandler(event:Event):void
		{
			undoCallback(Bitmap(event.target.content).bitmapData);
			loading = false;
			System.gc();
		}
		
		private function actuallySave(event:TimerEvent):void
		{
			if(currentlySaving)
			{
				extendTimer();
				return;
			}
			if(!tempBD)
			{
				return;
			}
			if(!encodingRect)
				encodingRect = new Rectangle(0,0,tempBD.width,tempBD.height);
			if(currentIndex<historyStack.length-1)
				historyStack.splice(currentIndex+1);
			
			var byteArray:ByteArray = new ByteArray();
			//bd.encode(encodingRect, encodingOptions, byteArray);
			//byteArray = PNGEncoder2.encode(tempBD);
			currentlySaving = true;
			var pngEncoder:PNGEncoder2 = PNGEncoder2.encodeAsync(tempBD);
			pngEncoder.targetFPS = 45;
			pngEncoder.addEventListener(Event.COMPLETE, function(event:Event):void
			{
				currentlySaving = false;
				byteArray = event.target.png;
				historyStack.push(byteArray);
				currentIndex++;
				if(historyStack.length>50)
				{
					historyStack.shift();
					currentIndex--;
				}
			});
			
		}
		
	}
}

internal class SingletonEnforcer {public function SingletonEnforcer(){}}