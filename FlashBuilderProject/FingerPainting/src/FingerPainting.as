package 
{
	import com.shaunhusain.mobileUIControls.AccelerometerButton;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.TouchEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.utils.ByteArray;
	
	public class FingerPainting extends Sprite
	{
		[Embed(source="images/brushIcon.png")]
		private var _brushIcon:Class;
		private var _brushIconBmp:Bitmap = new _brushIcon();
		
		[Embed(source="images/eraserIcon.png")]
		private var _eraserIcon:Class;
		private var _eraserIconBmp:Bitmap = new _eraserIcon();
		
		[Embed(source="images/bucketIcon.png")]
		private var _bucketIcon:Class;
		private var _bucketIconBmp:Bitmap = new _bucketIcon();
		
		[Embed(source="images/undoIcon.png")]
		private var _undoIcon:Class;
		private var _undoIconBmp:Bitmap = new _undoIcon();
		
		[Embed(source="images/shapesIcon.png")]
		private var _shapesIcon:Class;
		private var _shapesIconBmp:Bitmap = new _shapesIcon();
		
		private var menuButtons:Array;
		
		private var debugText:TextField;
		private var debugTextFormat:TextFormat;
		
		private var toolbar:Toolbar;
		
		private var bitmapCanvas:Bitmap;
		
		private var touchSamples:ByteArray;
		
		private var currentTool:String = "brush";
		
		public function FingerPainting()
		{
			super();
			
			touchSamples = new ByteArray();
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			bitmapCanvas = new Bitmap(new BitmapData(stage.fullScreenWidth,stage.fullScreenHeight));
			stage.addEventListener(TouchEvent.TOUCH_MOVE, touchMoveHandler);
			stage.addEventListener(TouchEvent.TOUCH_TAP, touchMoveHandler);
			addChild(bitmapCanvas);
			
			
			menuButtons = 
						[
							new AccelerometerButton(_brushIconBmp, "brush", true),
							new AccelerometerButton(_eraserIconBmp, "eraser"),
							new AccelerometerButton(_bucketIconBmp, "bucket"),
							new AccelerometerButton(_shapesIconBmp, "shapes"),
							new AccelerometerButton(_undoIconBmp, "undo"),
							new AccelerometerButton(),
							new AccelerometerButton(),
							new AccelerometerButton()
						];
			
			toolbar = new Toolbar();
			toolbar.x = stage.stageWidth-100;
			toolbar.y = 20;
			addChild(toolbar);
			
			for( var i:int = 0; i <menuButtons.length; i++)
			{
				var ab:AccelerometerButton = menuButtons[i];
				ab.addEventListener("buttonClicked", deselectAllOthers);
				ab.x = 140;
				ab.y = 100+i*120;
				toolbar.addChild(ab);
			}
			
			
		}
		
		private function deselectAllOthers(event:Event):void
		{
			currentTool = event.target.data as String;
			for( var i:int = 0; i <menuButtons.length; i++)
			{
				var ab:AccelerometerButton = menuButtons[i];
				if(event.target!=ab)
					ab.isSelected = false;
			}
		}
		
/*		private function setupDebugText():void
		{
			debugTextFormat = new TextFormat();
			debugTextFormat.size = 36;
			
			debugText = new TextField();
			debugText.autoSize = TextFieldAutoSize.LEFT;
			debugText.setTextFormat(debugTextFormat);
			addChild(debugText);
		}*/
		private function touchMoveHandler(event:TouchEvent):void
		{
			switch(currentTool)
			{
				case "brush":
					drawWithBrush(event);
					break;
				case "eraser":
					erase(event);
					break;
				case "bucket":
					bucketFill(event);
					break;
					
				default:
					break;
			}
		}
		
		private function erase(event:TouchEvent):void
		{
			var result:uint = event.getSamples(touchSamples,false);
			touchSamples.position = 0;     // rewind to beginning of array before reading
			
			var xCoord:Number, yCoord:Number, pressure:Number;
			
			while( touchSamples.bytesAvailable > 0 )
			{
				xCoord = touchSamples.readFloat();
				yCoord = touchSamples.readFloat();
				pressure = touchSamples.readFloat();
				
				bitmapCanvas.bitmapData.fillRect(new Rectangle(xCoord,yCoord,pressure*30,pressure*30),0x00000000);
				//do something with the sample data
			}
		}
		
		private function bucketFill(event:TouchEvent):void
		{
			bitmapCanvas.bitmapData.floodFill(event.stageX,event.stageY,0xff000000);
		}
		
		private function drawWithBrush(event:TouchEvent):void
		{
			var result:uint = event.getSamples(touchSamples,false);
			touchSamples.position = 0;     // rewind to beginning of array before reading
			
			var xCoord:Number, yCoord:Number, pressure:Number;
			
			while( touchSamples.bytesAvailable > 0 )
			{
				xCoord = touchSamples.readFloat();
				yCoord = touchSamples.readFloat();
				pressure = touchSamples.readFloat();
				
				bitmapCanvas.bitmapData.fillRect(new Rectangle(xCoord,yCoord,pressure*30,pressure*30),0xFF000000);
				//do something with the sample data
			}
		}
	}
}