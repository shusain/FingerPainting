package com.shaunhusain.fingerPainting.view.optionPanels
{
	import com.shaunhusain.fingerPainting.model.Layer;
	import com.shaunhusain.fingerPainting.model.PaintModel;
	import com.shaunhusain.fingerPainting.view.BitmapReference;
	import com.shaunhusain.fingerPainting.view.Box;
	import com.shaunhusain.fingerPainting.view.managers.LayerManager;
	import com.shaunhusain.fingerPainting.view.mobileUIControls.ButtonScroller;
	import com.shaunhusain.fingerPainting.view.mobileUIControls.RelativeTouchSlider;
	import com.shaunhusain.fingerPainting.view.mobileUIControls.RotatingIconButton;
	import com.shaunhusain.fingerPainting.view.mobileUIControls.TouchSlider;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.TouchEvent;
	import flash.geom.Matrix;

	public class LayerOptionsPanel extends PanelBase
	{
		//--------------------------------------------------------------------------------
		//				UI Components
		//--------------------------------------------------------------------------------
		protected var mainContainer:Box;
		protected var controlContainer:Box;
		protected var addButton:RotatingIconButton;
		protected var removeButton:RotatingIconButton;
		protected var upButton:RotatingIconButton;
		protected var downButton:RotatingIconButton;
		protected var mergeButton:RotatingIconButton;
		protected var duplicateButton:RotatingIconButton;
		protected var mirrorButton:RotatingIconButton;
		protected var opacitySlider:RelativeTouchSlider;
		
		private var layerBackground:Bitmap
		private var selectedLayerBackground:Bitmap
		//--------------------------------------------------------------------------------
		//				Variables
		//--------------------------------------------------------------------------------
		
		private var model:PaintModel = PaintModel.getInstance();
		private var layerManager:LayerManager = LayerManager.getIntance();
		private var layersDisplay:ButtonScroller;
		
		//--------------------------------------------------------------------------------
		//				Constructor
		//--------------------------------------------------------------------------------
		public function LayerOptionsPanel()
		{
			super();
			
			titleBackground.text = "Layer\nOptions";
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		//--------------------------------------------------------------------------------
		//				Handlers
		//--------------------------------------------------------------------------------
		private function addedToStageHandler(event:Event):void
		{
			if(!layerBackground)
				layerBackground = new Bitmap(new BitmapData(stage.fullScreenWidth/10,stage.fullScreenHeight/10,false,0xFFFFFFFF));
			if(!selectedLayerBackground)
				selectedLayerBackground = new Bitmap(new BitmapData(stage.fullScreenWidth/10,stage.fullScreenHeight/10,false,0xFFDDDDFF));
			
			if(!mainContainer)
			{
				mainContainer = new Box();
				mainContainer.y = 30;
				mainContainer.x = 10;
				mainContainer.gap = 10;
				mainContainer.direction = "horizontal";
				addChild(mainContainer);
			}
			
			if(!controlContainer)
			{
				controlContainer = new Box();
				mainContainer.addChild(controlContainer);
			}
			
			if(!addButton)
			{
				addButton = new RotatingIconButton(BitmapReference._addBmp,null,true);
				addButton.addEventListener("instantaneousButtonClicked", addButtonClickHandler);
				
				controlContainer.addChild(addButton);
			}
			if(!removeButton)
			{
				removeButton = new RotatingIconButton(BitmapReference._removeBmp,null,true);
				removeButton.addEventListener("instantaneousButtonClicked", removeButtonClickHandler);
				
				controlContainer.addChild(removeButton);
			}
			if(!upButton)
			{
				upButton = new RotatingIconButton(BitmapReference._moveUpBmp,null,true);
				upButton.addEventListener("instantaneousButtonClicked", upButtonClickHandler);
				
				controlContainer.addChild(upButton);
			}
			if(!downButton)
			{
				downButton = new RotatingIconButton(BitmapReference._moveDownBmp,null,true);
				downButton.addEventListener("instantaneousButtonClicked", downButtonClickHandler);
				
				controlContainer.addChild(downButton);
			}
			if(!duplicateButton)
			{
				duplicateButton = new RotatingIconButton(BitmapReference._dupBmp,null,true);
				duplicateButton.addEventListener("instantaneousButtonClicked", duplicateClickedHandler);
				
				controlContainer.addChild(duplicateButton);
			}
			if(!mergeButton)
			{
				mergeButton = new RotatingIconButton(BitmapReference._mergeBmp,null,true);
				mergeButton.addEventListener("instantaneousButtonClicked", mergeClickedHandler);
				
				controlContainer.addChild(mergeButton);
			}
			if(!mirrorButton)
			{
				mirrorButton = new RotatingIconButton(BitmapReference._mirrorBmp,null,true);
				mirrorButton.addEventListener("instantaneousButtonClicked", mirrorClickedHandler);
				
				controlContainer.addChild(mirrorButton);
			}
			if(!opacitySlider)
			{
				opacitySlider = new RelativeTouchSlider();
				opacitySlider.addEventListener(TouchSlider.VALUE_CHANGED, updateLayerOpacity);
				opacitySlider.dispAsPercent = true;
				opacitySlider.maximum = 1;
				opacitySlider.decimalsToShow = 2;
				opacitySlider.titleLabelText = "Opacity"
				opacitySlider.liveScrolling = false;
				controlContainer.addChild(opacitySlider);
			}
			
			if(!layersDisplay)
			{
				layersDisplay = new ButtonScroller();
				layersDisplay.buttonMaskHeight = backgroundSprite.height - 200;
				layersDisplay.buttonMaskWidth = stage.fullScreenWidth/10;
				mainContainer.addChild(layersDisplay);
				
				layersDisplay.addEventListener("buttonClicked",layerClickedHandler);
			}
			
			opacitySlider.currentValue = layerManager.currentLayer.bitmap.alpha;
			
			beingShown();
		}
		
		protected function mirrorClickedHandler(event:Event):void
		{
			var layWidth:Number = layerManager.currentLayerBitmap.width;
			var layHeight:Number = layerManager.currentLayerBitmap.height;
			
			var matrix:Matrix = new Matrix();
			matrix.tx -= layWidth/2;
			matrix.ty -= layHeight/2;
			matrix.scale(-1,1);
			matrix.tx += layWidth/2;
			matrix.ty += layHeight/2;
			
			var tempBD:BitmapData = new BitmapData(layWidth, layHeight,true, 0x000000000);
			tempBD.draw(layerManager.currentLayerBitmap,matrix);
			layerManager.currentLayer.bitmapData = tempBD;
			layerManager.currentLayer.bitmap.bitmapData = tempBD;
			layerManager.currentLayer.updateThumbnail();
			beingShown();
		}
		
		protected function duplicateClickedHandler(event:Event):void
		{
			layerManager.addLayer(layerManager.currentLayer.bitmap);
			layerManager.currentLayer.updateThumbnail();
			beingShown();
		}
		
		protected function mergeClickedHandler(event:Event):void
		{
			if(layerManager.currentLayerIndex-1<0)
				return;
			layerManager.layers[layerManager.currentLayerIndex-1].bitmapData.draw(layerManager.currentLayerBitmap);
			layerManager.removeLayer();
			layerManager.currentLayer.updateThumbnail();
			beingShown();
		}
		
		protected function layerClickedHandler(event:Event):void
		{
			layerManager.currentLayer = (event.target as RotatingIconButton).data as Layer;
			beingShown();
		}
		
		protected function downButtonClickHandler(event:Event):void
		{
			layerManager.moveLayerDown();	
			beingShown();
		}
		
		protected function upButtonClickHandler(event:Event):void
		{
			layerManager.moveLayerUp();	
			beingShown();
		}
		
		protected function removeButtonClickHandler(event:Event):void
		{
			layerManager.removeLayer();
			beingShown();
		}
		
		protected function addButtonClickHandler(event:Event):void
		{
			layerManager.addLayer();
			beingShown();
		}
		private function blockEvent(event:TouchEvent):void
		{
			event.stopImmediatePropagation();
		}
		
		protected function updateLayerOpacity(event:Event):void
		{
			layerManager.currentLayer.bitmap.alpha = opacitySlider.currentValue;
		}
		
		//--------------------------------------------------------------------------------
		//				Helper functions
		//--------------------------------------------------------------------------------
		private function beingShown():void
		{
			var tempArray:Array = [];
			var curIndex:int = 0;
			for each(var layer:Layer in layerManager.layers)
			{
				var selected:Boolean = (curIndex++==layerManager.currentLayerIndex);
				
				tempArray.unshift(new RotatingIconButton(layer.thumbnailBitmap,layer,false,selected,false,layerBackground,selectedLayerBackground));
			}
			layersDisplay.menuButtons = tempArray;
		}
	}
}