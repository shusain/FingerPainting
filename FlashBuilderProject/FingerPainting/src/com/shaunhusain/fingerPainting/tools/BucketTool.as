package com.shaunhusain.fingerPainting.tools 
{
	import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.events.TouchEvent;

	public class BucketTool extends ToolBase implements ITool
	{
		public static var NAME:String = "bucketTool";
		
		//--------------------------------------------------------------------------------
		//				Constructor
		//--------------------------------------------------------------------------------
		public function BucketTool(stage:Stage)
		{
			super(stage);
		}
		
		//--------------------------------------------------------------------------------
		//				Handlers
		//--------------------------------------------------------------------------------
		public function takeAction(event:TouchEvent=null):void
		{
			var bm:BitmapData = layerManager.currentLayerBitmap;
			
			if(event && event.target == stage && bm && event.type == TouchEvent.TOUCH_END)
			{
				bm.floodFill(event.stageX,event.stageY,model.currentColor);
				
				layerManager.currentLayer.updateThumbnail();
				undoManager.addHistoryElement(bm);
			}
		}
		public function toString():String
		{
			return "Bucket Fill";
		}
		
		
		//This idea won't work due to bit order
		private function bucketFillTake2(event:TouchEvent):void
		{
			var x:Number = event.stageX;
			var y:Number = event.stageY;
			var b:BitmapData = layerManager.currentLayerBitmap;
			
			//take upper bound threshold, produce a new bitmapData with the pixels
			//below the threshold colored grey 0xaa (intialized black)
			
			//take lower bound threshold, produce a new bitmapData with the pixels
			//above the threshold colored grey 0xaa (intialized black)
			
			//blend the two bitmapImages using BlendMode.ADD
			
			//threshold the last bitmapData to get the pixels to fill with the target color
			//anything white in the blended bitmapData will be filled with the target color
		}
		
		//This idea doesn't work due to excessive time in checks
		private function bucketFillWithThreshold(event:TouchEvent):void
		{
			var x:Number = event.stageX;
			var y:Number = event.stageY;
			var b:BitmapData = layerManager.currentLayerBitmap;
			b.lock();
			
			var from:uint = b.getPixel(x,y);
			
			
			var q:Array = [];
			
			
			var curX:int;
			var curY:int;
			var w:int = b.width;
			var h:int = b.height;
			q.push(y*w + x);
			trace("total checks to do possibly",w*h);
			var curChecks:int =0;
			var alreadyChecked:Object = {};
			while (q.length != 0) {
				trace("Num:",curChecks++);
				var xy:int = q.shift();
				curX = xy % w;
				curY = (xy - curX) / w;
				trace("Checking: ",curX,", ",curY);
				alreadyChecked[xy]=true;
				if (b.getPixel(curX,curY) == from) { //<- want to replace this line
					b.setPixel(curX,curY,model.currentColor);
					if (!alreadyChecked[xy-1] && curX != 0) q.push(xy-1);
					if (!alreadyChecked[xy+1] && curX != w-1) q.push(xy+1);
					if (!alreadyChecked[xy-w] && curY != 0) q.push(xy-w);
					if (!alreadyChecked[xy+w] && curY != h-1) q.push(xy+w);
				}
			}
			b.unlock(null);
		}
	}
}