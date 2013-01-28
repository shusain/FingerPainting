package com.shaunhusain.fingerPainting.managers
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
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
			if(historyStack.length-1>currentIndex && currentIndex+1 < historyStack.length)
			{
				historyStack.splice(currentIndex+1);
			}
			
			tempBD = bd.clone();
			historyStack.push(tempBD);
			
			currentIndex++;
			
			if(historyStack.length>10)
			{
				historyStack.shift();
				currentIndex--;
			}
		}
		
		public function undo(callback:Function):void
		{
			undoCallback = callback;
			currentIndex--;
			if(currentIndex<0)
				currentIndex=0;
			
			if(historyStack.length==0)
				return;
			
			undoCallback(historyStack[currentIndex]);
		}
		
		public function redo(callback:Function):void
		{
			redoCallback = callback;
			currentIndex++;
			if(currentIndex>historyStack.length-1)
				currentIndex = historyStack.length-1;
			
			redoCallback(historyStack[currentIndex]);
		}
		
	}
}

internal class SingletonEnforcer {public function SingletonEnforcer(){}}