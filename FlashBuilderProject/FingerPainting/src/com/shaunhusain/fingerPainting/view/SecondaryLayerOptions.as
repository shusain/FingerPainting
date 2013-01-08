package com.shaunhusain.fingerPainting.view
{
	import com.shaunhusain.fingerPainting.managers.LayerManager;
	import com.shaunhusain.fingerPainting.model.Layer;
	import com.shaunhusain.fingerPainting.model.PaintModel;
	import com.shaunhusain.fingerPainting.tools.BlankTool;
	import com.shaunhusain.fingerPainting.view.mobileUIControls.ButtonScroller;
	import com.shaunhusain.fingerPainting.view.mobileUIControls.RotatingIconButton;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TouchEvent;

	public class SecondaryLayerOptions extends Sprite
	{
		private var backgroundSprite:Sprite;
						
		private var model:PaintModel = PaintModel.getInstance();
		private var layerManager:LayerManager = LayerManager.getIntance();
		private var layersDisplay:ButtonScroller;
		
		protected var eventHandlersRegistered:Boolean;
		
		protected var addButton:RotatingIconButton;
		protected var removeButton:RotatingIconButton;
		protected var upButton:RotatingIconButton;
		protected var downButton:RotatingIconButton;
		
		private var layerBackground:Bitmap
		private var selectedLayerBackground:Bitmap
		
		public function SecondaryLayerOptions()
		{
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			
		}
		private function addedToStageHandler(event:Event):void
		{
			if(!eventHandlersRegistered)
			{
				addEventListener(TouchEvent.TOUCH_MOVE, blockEvent);
				addEventListener(TouchEvent.TOUCH_TAP, blockEvent);
				addEventListener(TouchEvent.TOUCH_ROLL_OUT, blockEvent);
				eventHandlersRegistered = true;
			}
			
			if(!layerBackground)
				layerBackground = new Bitmap(new BitmapData(stage.fullScreenWidth/5,stage.fullScreenHeight/5,false,0xFFFFFFFF));
			if(!selectedLayerBackground)
				selectedLayerBackground = new Bitmap(new BitmapData(stage.fullScreenWidth/5,stage.fullScreenHeight/5,false,0xFFDDDDFF));
			
			
			if(!backgroundSprite)
			{
				backgroundSprite = new Sprite();
				backgroundSprite.graphics.clear();
				backgroundSprite.graphics.beginFill(0xeeeeee,.5);
				backgroundSprite.graphics.drawRoundRect(0,0,420,stage.fullScreenHeight-200,50,50);
				backgroundSprite.graphics.endFill();
				addChild(backgroundSprite);
			}
			if(!addButton)
			{
				addButton = new RotatingIconButton(BitmapReference._addBmp,null,true);
				addButton.x = 20;
				addButton.y = 20;
				addButton.addEventListener("instantaneousButtonClicked", addButtonClickHandler);
				
				addChild(addButton);
			}
			if(!removeButton)
			{
				removeButton = new RotatingIconButton(BitmapReference._removeBmp,null,true);
				removeButton.addEventListener("instantaneousButtonClicked", removeButtonClickHandler);
				removeButton.x = 189;
				removeButton.y = 20;
				
				addChild(removeButton);
			}
			if(!upButton)
			{
				upButton = new RotatingIconButton(BitmapReference._moveUpBmp,null,true);
				upButton.addEventListener("instantaneousButtonClicked", upButtonClickHandler);
				upButton.x = 20;
				upButton.y = 163;
				
				addChild(upButton);
			}
			if(!downButton)
			{
				downButton = new RotatingIconButton(BitmapReference._moveDownBmp,null,true);
				downButton.addEventListener("instantaneousButtonClicked", downButtonClickHandler);
				downButton.x = 189;
				downButton.y = 163;
				
				addChild(downButton);
			}
			
			if(!layersDisplay)
			{
				layersDisplay = new ButtonScroller();
				layersDisplay.x = 20;
				layersDisplay.y = 300;
				layersDisplay.buttonMaskHeight = stage.fullScreenHeight/2;
				layersDisplay.buttonMaskWidth = stage.fullScreenWidth/5;
				addChild(layersDisplay);
				
				layersDisplay.addEventListener("buttonClicked",layerClickedHandler);
			}
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
		
		public function beingShown():void
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
		
		private function blockEvent(event:TouchEvent):void
		{
			event.stopImmediatePropagation();
		}
	}
}