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
	
	public class LayerTool extends MultiTouchTool implements ITool
	{
		//--------------------------------------------------------------------------------
		//				Variables
		//--------------------------------------------------------------------------------
		private var secondaryLayerOptions:LayerOptionsPanel;
		
		private var initialScale:Number;
		protected var newScale:Number;
		private var initialAngle:Number;
		protected var newAngle:Number;
		
		private var floatingLayer:BitmapData;
		private var floatingLayerMatrix:Matrix;
		
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
		}
		
		//--------------------------------------------------------------------------------
		//				Handlers
		//--------------------------------------------------------------------------------
		private function moveBitmap(event:TouchEvent):void
		{
			var currentTouchPrevPos:Point = ptsTracked[event.touchPointID];
			var offset:Point = new Point(event.stageX-currentTouchPrevPos.x,event.stageY-currentTouchPrevPos.y);
			layerM.currentLayer.bitmap.x += offset.x/layerM.scaleX;
			layerM.currentLayer.bitmap.y += offset.y/layerM.scaleX;
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
			var clbd:BitmapData = layerM.currentLayerBitmap;
			var matrix:Matrix = new Matrix();
			matrix.tx = layerM.currentLayer.bitmap.x;
			matrix.ty = layerM.currentLayer.bitmap.y;
			
			var temp:BitmapData = new BitmapData(clbd.width,clbd.height,true,0x00000000);
			temp.draw(clbd,matrix,null,null,null,true);
			layerM.currentLayer.bitmapData = temp;
			layerM.currentLayer.bitmap.bitmapData = temp;
			
			layerM.currentLayer.bitmap.x = layerM.currentLayer.bitmap.y = 0;
			layerM.currentLayer.updateThumbnail();
			
			undoManager.addHistoryElement(layerM.currentLayerBitmap);
		}
		
		public function completeRotateScale():void
		{
			var clbd:BitmapData = layerM.currentLayerBitmap;
			
			var temp:BitmapData = new BitmapData(clbd.width,clbd.height,true,0x00000000);
			temp.draw(clbd,floatingLayerMatrix,null,null,null,true);
			layerM.currentLayer.bitmapData = temp;
			layerM.currentLayer.bitmap.bitmapData = temp;
			
			layerM.currentLayer.bitmap.x = layerM.currentLayer.bitmap.y = 0;
			
			initialAngle = initialScale = NaN;
			layerM.currentLayer.updateThumbnail();
			floatingLayer = null;
			
			undoManager.addHistoryElement(layerM.currentLayerBitmap);
		}
		
		//--------------------------------------------------------------------------------
		//				Overrides
		//--------------------------------------------------------------------------------
		override public function toString():String
		{
			return "Layer";
		}
		override protected function secondFingerDown():void
		{
			completeMovement();
		}
		override protected function oneFingerEnd():void
		{
			completeMovement();
		}
		override protected function twoFingerEnd():void
		{
			completeRotateScale();
		}
		override protected function oneFingerMoving(event:TouchEvent):void
		{
			moveBitmap(event);
		}
		override protected function twoFingersMoving(event:TouchEvent):void
		{
			scaleRotateBitmap(event);
		}
		
		//--------------------------------------------------------------------------------
		//				Helper functions
		//--------------------------------------------------------------------------------
		private function scaleRotateBitmap(event:TouchEvent):void
		{
			if(!floatingLayer)
			{
				visibleDrawingRect = getVisibleBounds(layerM.currentLayer.bitmap);
				initialScale = Point.distance(ptsTracked[0],ptsTracked[1]);
				initialAngle = Math.atan2(ptsTracked[0].y - ptsTracked[1].y,	ptsTracked[0].x - ptsTracked[1].x);
				floatingLayer = layerM.currentLayer.bitmapData.clone();
				floatingLayerMatrix = new Matrix();
				layerM.currentLayer.bitmap.bitmapData = floatingLayer;
			}
			else
			{
				newAngle = Math.atan2(ptsTracked[0].y - ptsTracked[1].y,	ptsTracked[0].x - ptsTracked[1].x);
				newScale = Point.distance(ptsTracked[0],ptsTracked[1]);
				
				//Doing rotation around the visible part in the layer
				//initially moving back and up to get the center at the
				//origin (registration point)
				floatingLayerMatrix.tx -= visibleDrawingRect.x + visibleDrawingRect.width/2;
				floatingLayerMatrix.ty -= visibleDrawingRect.y + visibleDrawingRect.height/2;
				
				//Rotating based on the change from the initial angle to the
				//current angle
				floatingLayerMatrix.rotate(newAngle-initialAngle);
				floatingLayerMatrix.scale(newScale/initialScale,newScale/initialScale);
				
				floatingLayerMatrix.tx += visibleDrawingRect.x + visibleDrawingRect.width/2;
				floatingLayerMatrix.ty += visibleDrawingRect.y + visibleDrawingRect.height/2;
				
				floatingLayer.fillRect(new Rectangle(0,0,floatingLayer.width,floatingLayer.height),0x00000000);
				floatingLayer.draw(layerM.currentLayer.bitmapData,floatingLayerMatrix);
				
				initialAngle = newAngle;
				initialScale = newScale;
				
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