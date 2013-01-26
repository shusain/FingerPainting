package com.shaunhusain.fingerPainting.tools 
{
	import com.shaunhusain.fingerPainting.view.optionPanels.LayerOptionsPanel;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.TouchEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class LayerTool extends ToolBase implements ITool
	{
		//--------------------------------------------------------------------------------
		//				Variables
		//--------------------------------------------------------------------------------
		private var secondaryLayerOptions:LayerOptionsPanel;
		
		private var pointsTracked:Number = 0;
		private var ptsTracked:Object;
		private var initialScale:Number;
		private var initialAngle:Number;
		
		private var floatingLayer:BitmapData;
		private var floatingLayerMatrix:Matrix;
		
		private var currentRotation:Number;
		private var currentScale:Number;
		
		private var visibleDrawingRect:Rectangle;
		
		
		//--------------------------------------------------------------------------------
		//				Constructor
		//--------------------------------------------------------------------------------
		public function LayerTool(stage:Stage)
		{
			super(stage);
			secondaryLayerOptions = new LayerOptionsPanel();
			
			secondaryLayerOptions.x = 100;
			secondaryLayerOptions.y = 100;
			ptsTracked = {};
		}
		
		//--------------------------------------------------------------------------------
		//				Handlers
		//--------------------------------------------------------------------------------
		public function takeAction(event:TouchEvent=null):void
		{
			switch(event.type)
			{
				case TouchEvent.TOUCH_BEGIN:
					ptsTracked[event.touchPointID] =  new Point(event.stageX, event.stageY);
					pointsTracked++;
					if(pointsTracked>1)
						completeMovement();
					break;
				
				case TouchEvent.TOUCH_MOVE:
					switch(pointsTracked)
					{
						case 1:
							moveBitmap(event);
							break;
						case 2:
							scaleRotateBitmap(event);
							break;
						
					}
					ptsTracked[event.touchPointID] =  new Point(event.stageX, event.stageY);
					break;
				
				case TouchEvent.TOUCH_END:
				case TouchEvent.TOUCH_ROLL_OUT:
					switch(pointsTracked)
					{
						case 1:
							completeMovement();
							break;
						case 2:
							completeRotateScale();
							break;
					}
					
					
					ptsTracked[event.touchPointID] = null;
					pointsTracked--;
					if(pointsTracked<0)
						pointsTracked = 0;
					break;
			}
		}
		private function moveBitmap(event:TouchEvent):void
		{
			var currentTouchPrevPos:Point = ptsTracked[event.touchPointID];
			var offset:Point = new Point(event.stageX-currentTouchPrevPos.x,event.stageY-currentTouchPrevPos.y);
			layerManager.currentLayer.bitmap.x += offset.x;
			layerManager.currentLayer.bitmap.y += offset.y;
		}
		
		//--------------------------------------------------------------------------------
		//				Public Methods
		//--------------------------------------------------------------------------------
		public function toggleSecondaryOptions():void
		{
			if(secondaryPanelManager.currentlyShowing == secondaryLayerOptions)
				secondaryPanelManager.hidePanel();
			else
				secondaryPanelManager.showPanel(secondaryLayerOptions);
		}
		public function completeMovement():void
		{
			var clbd:BitmapData = layerManager.currentLayerBitmap;
			var matrix:Matrix = new Matrix();
			matrix.tx = layerManager.currentLayer.bitmap.x;
			matrix.ty = layerManager.currentLayer.bitmap.y;
			var temp:BitmapData = new BitmapData(clbd.width,clbd.height,true,0x00000000);
			temp.draw(clbd,matrix,null,null,null,true);
			layerManager.currentLayer.bitmapData = temp;
			layerManager.currentLayer.bitmap.bitmapData = temp;
			
			layerManager.currentLayer.bitmap.x = layerManager.currentLayer.bitmap.y = 0;
			layerManager.currentLayer.updateThumbnail();
			
			undoManager.addHistoryElement(layerManager.currentLayerBitmap);
		}
		
		public function completeRotateScale():void
		{
			var clbd:BitmapData = layerManager.currentLayerBitmap;
			
			var temp:BitmapData = new BitmapData(clbd.width,clbd.height,true,0x00000000);
			temp.draw(clbd,floatingLayerMatrix,null,null,null,true);
			layerManager.currentLayer.bitmapData = temp;
			layerManager.currentLayer.bitmap.bitmapData = temp;
			
			layerManager.currentLayer.bitmap.x = layerManager.currentLayer.bitmap.y = 0;
			
			initialAngle = initialScale = NaN;
			layerManager.currentLayer.updateThumbnail();
			
			undoManager.addHistoryElement(layerManager.currentLayerBitmap);
		}
		
		public function toString():String
		{
			return "Layer";
		}
		
		//--------------------------------------------------------------------------------
		//				Helper functions
		//--------------------------------------------------------------------------------
		private function scaleRotateBitmap(event:TouchEvent):void
		{
			if(isNaN(initialScale)||isNaN(initialAngle))
			{
				visibleDrawingRect = getVisibleBounds(layerManager.currentLayer.bitmap);
				initialScale = Point.distance(ptsTracked[0],ptsTracked[1]);
				initialAngle = Math.atan2(ptsTracked[0].y - ptsTracked[1].y,	ptsTracked[0].x - ptsTracked[1].x);
				floatingLayer = layerManager.currentLayer.bitmapData.clone();
				floatingLayerMatrix = new Matrix();
				layerManager.currentLayer.bitmap.bitmapData = floatingLayer;
			}
			else
			{
				var angle2:Number = Math.atan2(ptsTracked[0].y - ptsTracked[1].y,	ptsTracked[0].x - ptsTracked[1].x);
				var newScale:Number = Point.distance(ptsTracked[0],ptsTracked[1]);
				
				floatingLayerMatrix.tx -= visibleDrawingRect.x + visibleDrawingRect.width/2;
				floatingLayerMatrix.ty -= visibleDrawingRect.y + visibleDrawingRect.height/2;
				
				floatingLayerMatrix.rotate(angle2-initialAngle);
				floatingLayerMatrix.scale(newScale/initialScale,newScale/initialScale);
				
				floatingLayerMatrix.tx += visibleDrawingRect.x + visibleDrawingRect.width/2;
				floatingLayerMatrix.ty += visibleDrawingRect.y + visibleDrawingRect.height/2;
				
				floatingLayer.fillRect(new Rectangle(0,0,floatingLayer.width,floatingLayer.height),0x00000000);
				floatingLayer.draw(layerManager.currentLayer.bitmapData,floatingLayerMatrix);
				
				currentRotation = initialAngle = angle2;
				currentScale = initialScale = newScale;
				
			}
		}
		private function angleBetween2Lines(line1a:Point, line1b:Point, line2a:Point, line2b:Point):Number
		{
			var angle1:Number = Math.atan2(line1a.y - line1b.y,	line1a.x - line1b.x);
			var angle2:Number = Math.atan2(line2a.y - line2b.y,	line2b.x - line2b.x);
			return angle1-angle2;
		}
		
		//sourced from: http://plasticsturgeon.com/2010/09/as3-get-visible-bounds-of-transparent-display-object/
		public function getVisibleBounds(source:DisplayObject):Rectangle
		{
			var matrix:Matrix = new Matrix()
			matrix.tx = -source.getBounds(null).x;
			matrix.ty = -source.getBounds(null).y;
			
			var data:BitmapData = new BitmapData(source.width, source.height, true, 0x00000000);
			data.draw(source, matrix);
			var bounds : Rectangle = data.getColorBoundsRect(0xFFFFFFFF, 0x000000, false);
			data.dispose();
			return bounds;
		}
	}
}