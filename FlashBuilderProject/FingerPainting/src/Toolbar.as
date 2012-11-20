package
{
	import com.eclecticdesignstudio.motion.Actuate;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TouchEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import org.bytearray.ScaleBitmap;
	
	public class Toolbar extends Sprite
	{
		[Embed(source="images/triangleIcon.png")]
		private var _triangleIcon:Class;
		private var _triangleIconBmp:Bitmap = new _triangleIcon();
		
		[Embed(source="images/toolbarBackground.png")]
		private var toolbarBmpClass:Class;
		private var toolbarBmp:Bitmap = new toolbarBmpClass();
		private var scaledBitmap:ScaleBitmap = new ScaleBitmap(toolbarBmp.bitmapData);
		private var isOpen:Boolean;
		private var _arrowRotation:Number=0;
		
		private var triangleSprite:Sprite;
		
		private var hitAreaSprite:Sprite;
		
		public function Toolbar()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
			addEventListener(TouchEvent.TOUCH_TAP, handleTapped);
			addEventListener(TouchEvent.TOUCH_MOVE, touchMoveHandler);
		}
		
		private function handleAddedToStage(event:Event):void
		{
			scaledBitmap.scale9Grid = new Rectangle(118, 100, 271, 2286);
			scaledBitmap.height = stage.fullScreenHeight - y;
			//toolbarBmp.width = toolbarBmp.scaleY*toolbarBmp.width;
			addChild(scaledBitmap);
			
			rotateTriangle(Math.PI);
			triangleSprite = new Sprite();
			triangleSprite.x = 41;
			triangleSprite.y = 35;
			addChild(triangleSprite);
			
			triangleSprite.addChild(_triangleIconBmp);
			
			hitAreaSprite = new Sprite();
			hitAreaSprite.graphics.beginFill(0x000000);
			hitAreaSprite.graphics.drawRect(0,0,1000,100);
			hitAreaSprite.graphics.endFill();
			hitAreaSprite.visible = false;
			hitArea = hitAreaSprite;
			
			
			addChild(hitAreaSprite);
		}
		
		private function handleTapped(event:TouchEvent):void
		{
			event.stopImmediatePropagation();
			trace("handling tapped");
			
			if(isOpen)
			{
				Actuate.tween(this, .5, {arrowRotation:Math.PI, x:stage.fullScreenWidth - 100});
			}
			else
			{
				Actuate.tween(this, .5, {arrowRotation:0,x:stage.fullScreenWidth - 270});
			}
			isOpen = !isOpen;
		}
		
		public function set arrowRotation(angleRadians:Number):void
		{
			rotateTriangle(angleRadians);	
		}
		public function get arrowRotation():Number
		{
			return _arrowRotation;
		}
		private function touchMoveHandler(event:TouchEvent):void
		{
			event.stopImmediatePropagation();
		}
		private function rotateTriangle(angleRadians:Number):void
		{
			_arrowRotation = angleRadians;
			var m:Matrix = _triangleIconBmp.transform.matrix;
			m.identity();
			m.translate(-_triangleIconBmp.width/2,-_triangleIconBmp.height/2);
			m.rotate(angleRadians);
			m.translate(_triangleIconBmp.width/2,_triangleIconBmp.height/2);
			_triangleIconBmp.transform.matrix = m;
		}
	}
}