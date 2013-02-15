package com.shaunhusain.fingerPainting.view.managers
{
	import com.shaunhusain.fingerPainting.managers.UndoManager;
	import com.shaunhusain.fingerPainting.model.Layer;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.system.System;
	

	public class LayerManager extends Sprite
	{
		//--------------------------------------------------------------------------------
		//				Variables
		//--------------------------------------------------------------------------------
		private var undoManager:UndoManager = UndoManager.getIntance();
		
		//--------------------------------------------------------------------------------
		//				Constructor
		//--------------------------------------------------------------------------------
		public function LayerManager(se:SingletonEnforcer)
		{
			layers = new Vector.<Layer>();
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			mouseChildren = false;
			mouseEnabled = false;
		}
		
		//--------------------------------------------------------------------------------
		//				Singleton
		//--------------------------------------------------------------------------------
		private static var instance:LayerManager;
		public static function getIntance():LayerManager
		{
			if( instance == null ) instance = new LayerManager( new SingletonEnforcer() );
			return instance;
		}
		
		//--------------------------------------------------------------------------------
		//				Properties
		//--------------------------------------------------------------------------------
		private var _currentLayerIndex:int = 1;
		/**
		 * The index of the currently selected layer.
		 */
		public function get currentLayerIndex():int
		{
			return _currentLayerIndex;
		}
		public function set currentLayerIndex(value:int):void
		{
			_currentLayerIndex = value;
		}
		
		/**
		 * The currently selected @see Layer
		 */
		public function get currentLayer():Layer
		{
			return layers[currentLayerIndex];
		}
		public function set currentLayer(layer:Layer):void
		{
			_currentLayerIndex = layers.indexOf(layer);
		}
		
		private var _layers:Vector.<Layer>;
		public function get layers():Vector.<Layer>
		{
			return _layers;
		}
		public function set layers(value:Vector.<Layer>):void
		{
			_layers = value;
		}
		
		public function get currentLayerBitmap():BitmapData
		{
			return layers[_currentLayerIndex].bitmapData;
		}
		
		//--------------------------------------------------------------------------------
		//				Public Methods
		//--------------------------------------------------------------------------------
		public function addLayer(drawable:DisplayObject = null):void
		{
			var bitmapData:BitmapData = new BitmapData(stage.fullScreenWidth,stage.fullScreenHeight, true,0x0000000);
			var bitmapCanvas:Bitmap = new Bitmap(bitmapData);
			var scaleMatrix:Matrix = new Matrix();
			if(drawable)
			{
				if(drawable.height>stage.fullScreenHeight || drawable.width > stage.fullScreenWidth)
				{
					if(drawable.height/drawable.width > stage.fullScreenHeight/stage.fullScreenWidth)
						scaleMatrix.scale(stage.fullScreenHeight/drawable.height,stage.fullScreenHeight/drawable.height);
					else
						scaleMatrix.scale(stage.fullScreenWidth/drawable.width,stage.fullScreenWidth/drawable.width);
				}
				bitmapData.draw(drawable,scaleMatrix);
			}
			var layer:Layer = new Layer(bitmapData,bitmapCanvas);
			addChild(bitmapCanvas);
			
			layers.push(layer);
			currentLayerIndex = layers.length-1;
			trace(layers.length);
		}
		public function removeLayer():void
		{
			if(currentLayerIndex>=layers.length||currentLayerIndex<0)
				return;
			layers.splice(currentLayerIndex,1);
			
			var removedLayer:Bitmap = removeChildAt(currentLayerIndex) as Bitmap;
			
			if(currentLayerIndex>layers.length-1)
				currentLayerIndex--;
			
			if(layers.length == 0)
			{
				addLayer();
			}
			
			removedLayer.bitmapData.dispose();
			removedLayer = null;
			System.gc();
		}
		public function moveLayerUp():void
		{
			if(currentLayerIndex<layers.length - 1)
			{
				var temp:Layer = layers[currentLayerIndex];
				layers[currentLayerIndex] = layers[currentLayerIndex+1];
				layers[currentLayerIndex+1] = temp;
				addChildAt(removeChildAt(currentLayerIndex),currentLayerIndex+1);
				currentLayerIndex++;
			}
		}
		public function moveLayerDown():void
		{
			if(currentLayerIndex>0)
			{
				var temp:Layer = layers[currentLayerIndex];
				layers[currentLayerIndex] = layers[currentLayerIndex-1];
				layers[currentLayerIndex-1] = temp;
				addChildAt(removeChildAt(currentLayerIndex),currentLayerIndex-1);
				currentLayerIndex--;
			}
		}
		public function getFlattenedBitmapData():BitmapData
		{
			var temp:BitmapData = new BitmapData(stage.fullScreenWidth,stage.fullScreenHeight);
			for each(var layer:Layer in layers)
			{
				if(layer.bitmap.visible)
					temp.draw(layer.bitmapData);
			}
			return temp;
		}
		
		//--------------------------------------------------------------------------------
		//				Handlers
		//--------------------------------------------------------------------------------
		public function addedToStageHandler(event:Event):void
		{
			var bitmapData:BitmapData = new BitmapData(stage.fullScreenWidth,stage.fullScreenHeight, true,0xFFFFFFFF);
			var bitmapCanvas:Bitmap = new Bitmap(bitmapData);
			addChild(bitmapCanvas);
			layers.push(new Layer(bitmapData,bitmapCanvas));
			
			bitmapData = new BitmapData(stage.fullScreenWidth,stage.fullScreenHeight, true,0x00000000);
			bitmapCanvas = new Bitmap(bitmapData);
			addChild(bitmapCanvas);
			layers.push(new Layer(bitmapData,bitmapCanvas));
			
		}
	}
}
internal class SingletonEnforcer {public function SingletonEnforcer(){}}