package com.shaunhusain.fingerPainting.view.optionPanels
{
	import com.shaunhusain.fingerPainting.model.PaintModel;
	import com.shaunhusain.fingerPainting.view.Box;
	import com.shaunhusain.fingerPainting.view.managers.LayerManager;
	import com.shaunhusain.fingerPainting.view.mobileUIControls.ButtonScroller;
	import com.shaunhusain.fingerPainting.view.mobileUIControls.RelativeTouchSlider;
	import com.shaunhusain.fingerPainting.view.mobileUIControls.RotatingIconButton;
	import com.shaunhusain.fingerPainting.view.mobileUIControls.StackedButtons;
	import com.shaunhusain.fingerPainting.view.mobileUIControls.TouchSlider;
	import com.shaunhusain.layerdImageVOs.LayerVO;
	
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
		protected var layerButtonsContainer:Box;
		protected var mirrorDuplicateContainer:Box;
		protected var mirrorButton:RotatingIconButton;
		protected var duplicateButton:RotatingIconButton;
		protected var visibilityMergeContainer:Box;
		protected var visibilityButton:RotatingIconButton;
		protected var mergeButton:RotatingIconButton;
		protected var opacitySlider:RelativeTouchSlider;
		protected var addRemoveButton:StackedButtons;
		protected var moveUpDownButton:StackedButtons;
		
		private var layerBackground:Bitmap
		private var selectedLayerBackground:Bitmap
		
		protected var layersDisplayContainer:Box;
		protected var layersDisplay:ButtonScroller;
		
		//--------------------------------------------------------------------------------
		//				Variables
		//--------------------------------------------------------------------------------
		private var model:PaintModel = PaintModel.getInstance();
		private var layerManager:LayerManager = LayerManager.getIntance();
		
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
				layerBackground = new Bitmap(new BitmapData(150*model.dpiScale,150*stage.fullScreenHeight/stage.fullScreenWidth*model.dpiScale,false,0xFFFFFFFF));
			if(!selectedLayerBackground)
				selectedLayerBackground = new Bitmap(new BitmapData(150*model.dpiScale,150*stage.fullScreenHeight/stage.fullScreenWidth*model.dpiScale,false,0xFFDDDDFF));
			
			if(!mainContainer)
			{
				mainContainer = new Box();
				mainContainer.y = 20 * model.dpiScale;
				mainContainer.x = 12 * model.dpiScale;
				mainContainer.gap = 20 * model.dpiScale;
				mainContainer.direction = "horizontal";
				addChild(mainContainer);
			}
			
			if(!controlContainer)
			{
				controlContainer = new Box();
				controlContainer.gap = 20 * model.dpiScale;
				mainContainer.addChild(controlContainer);
			}
			
			if(!addRemoveButton)
			{
				addRemoveButton = new StackedButtons(br.getBitmapByName("addIcon.png"),br.getBitmapByName("removeIcon.png"));
				addRemoveButton.addEventListener("topButtonTapped", addButtonClickHandler);
				addRemoveButton.addEventListener("bottomButtonTapped", removeButtonClickHandler);
				controlContainer.addChild(addRemoveButton);
			}
			if(!moveUpDownButton)
			{
				moveUpDownButton = new StackedButtons(br.getBitmapByName("moveUpIcon.png"), br.getBitmapByName("moveDownIcon.png"));
				moveUpDownButton.addEventListener("topButtonTapped", upButtonClickHandler);
				moveUpDownButton.addEventListener("bottomButtonTapped", downButtonClickHandler);
				controlContainer.addChild(moveUpDownButton);
			}	
			if(!layerButtonsContainer)
			{
				layerButtonsContainer = new Box();
				controlContainer.addChild(layerButtonsContainer);
			}
			if(!mirrorDuplicateContainer)
			{
				mirrorDuplicateContainer = new Box();
				mirrorDuplicateContainer.direction = "horizontal";
				layerButtonsContainer.addChild(mirrorDuplicateContainer);
			}
			if(!mirrorButton)
			{
				mirrorButton = new RotatingIconButton(br.getBitmapByName("mirror.png"),null,null,true);
				mirrorButton.addEventListener("instantaneousButtonClicked", mirrorClickedHandler);
				
				mirrorDuplicateContainer.addChild(mirrorButton);
			}
			if(!duplicateButton)
			{
				duplicateButton = new RotatingIconButton(br.getBitmapByName("duplicate.png"),null,null,true);
				duplicateButton.addEventListener("instantaneousButtonClicked", duplicateClickedHandler);
				
				mirrorDuplicateContainer.addChild(duplicateButton);
			}
			
			if(!visibilityMergeContainer)
			{
				visibilityMergeContainer = new Box();
				visibilityMergeContainer.direction = "horizontal";
				layerButtonsContainer.addChild(visibilityMergeContainer);
			}
			if(!visibilityButton)
			{
				visibilityButton = new RotatingIconButton(br.getBitmapByName("visibility.png"),br.getBitmapByName("visibilitySelected.png"),null,false,true);
				visibilityButton.toggles = true;
				visibilityButton.addEventListener("buttonClicked", visibilityClickedHandler);
				
				visibilityMergeContainer.addChild(visibilityButton);
			}
			if(!mergeButton)
			{
				mergeButton = new RotatingIconButton(br.getBitmapByName("merge.png"),null,null,true);
				mergeButton.addEventListener("instantaneousButtonClicked", mergeClickedHandler);
				
				visibilityMergeContainer.addChild(mergeButton);
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
		
			if(!layersDisplayContainer)
			{
				layersDisplayContainer = new Box();
				layersDisplayContainer.startPadding = 60 * model.dpiScale;
				mainContainer.addChild(layersDisplayContainer);
			}
			if(!layersDisplay)
			{
				layersDisplay = new ButtonScroller();
				layersDisplay.gap = 20 * model.dpiScale;
				layersDisplay.buttonMaskHeight = backgroundSprite.height - 260*model.dpiScale;
				layersDisplay.buttonMaskWidth = 150*model.dpiScale;
				layersDisplay.addEventListener("buttonClicked",layerClickedHandler);
				layersDisplayContainer.addChild(layersDisplay);
			}
			
			opacitySlider.currentValue = layerManager.currentLayer.bitmap.alpha;
			
			beingShown();
		}
		
		protected function visibilityClickedHandler(event:Event):void
		{
			layerManager.currentLayer.bitmap.visible = visibilityButton.isSelected;
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
			layerManager.currentLayer = (event.target as RotatingIconButton).data as LayerVO;
			
			opacitySlider.currentValue = layerManager.currentLayer.bitmap.alpha;
			visibilityButton.isSelected = layerManager.currentLayer.bitmap.visible;
			
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
			for each(var layer:LayerVO in layerManager.layers)
			{
				layer.updateThumbnail();
				var selected:Boolean = (curIndex++==layerManager.currentLayerIndex);
				
				tempArray.unshift(new RotatingIconButton(layer.thumbnailBitmap,null,layer,false,selected,false,layerBackground,selectedLayerBackground));
			}
			layersDisplay.menuButtons = tempArray;
		}
	}
}