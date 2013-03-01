package com.shaunhusain.fingerPainting.tools 
{
	import flash.display.Stage;
	import flash.events.TouchEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	/**
	 * Allows the layer manager to be panned and zoomed on, other tools are
	 * responsible for taking into account the current zoom and pan position
	 * when modifying the layers.
	 */
	public class NavigationTool extends MultiTouchTool implements ITool
	{
		private var initialDistance:Number;
		private var newDistance:Number;
		private var layerLocal:Point;
		//--------------------------------------------------------------------------------
		//				Constructor
		//--------------------------------------------------------------------------------
		public function NavigationTool(stage:Stage)
		{
			super(stage);
		}
		
		
		override public function toString():String
		{
			return "Navigation: One finger to pan, two fingers to zoom, touch navigation again to reset pan/zoom.";
		}
		
		//--------------------------------------------------------------------------------
		//				Overrides
		//--------------------------------------------------------------------------------
		override protected function oneFingerMoving(event:TouchEvent):void
		{
			var currentTouchPrevPos:Point = ptsTracked[event.touchPointID];
			layerM.x += event.stageX-currentTouchPrevPos.x;
			layerM.y += event.stageY-currentTouchPrevPos.y;
		}
		override protected function twoFingersMoving(event:TouchEvent):void
		{
			if(isNaN(initialDistance))
			{
				initialDistance = Point.distance(ptsTracked[0],ptsTracked[1]);
				layerLocal = new Point((ptsTracked[0].x+ptsTracked[1].x)/2,(ptsTracked[0].y+ptsTracked[1].y)/2);
			}
			else
			{
				newDistance = Point.distance(ptsTracked[0],ptsTracked[1]);
				var scaleSize:Number = newDistance/initialDistance;
				var matrix:Matrix = layerM.transform.concatenatedMatrix.clone();
				
				matrix.tx -= layerLocal.x;
				matrix.ty -= layerLocal.y;
				matrix.scale(scaleSize,scaleSize);
				matrix.tx += layerLocal.x;
				matrix.ty += layerLocal.y;
				
				layerM.transform.matrix = matrix;
				
				initialDistance = newDistance;
			}
		}
		override protected function twoFingerEnd():void
		{
			initialDistance = NaN;
		}
		
		
		public function resetZoomAndPosition():void
		{
			var matrix:Matrix = new Matrix();
			layerM.transform.matrix = matrix;
		}
	}
}