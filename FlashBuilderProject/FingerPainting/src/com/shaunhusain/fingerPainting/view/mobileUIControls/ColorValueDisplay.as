package com.shaunhusain.fingerPainting.view.mobileUIControls
{
	import com.eclecticdesignstudio.motion.Actuate;
	import com.shaunhusain.fingerPainting.events.AccBasedOrientationEvent;
	import com.shaunhusain.fingerPainting.managers.AccelerometerManager;
	import com.shaunhusain.fingerPainting.model.PaintModel;
	import com.shaunhusain.fingerPainting.model.color.ARGB;
	import com.shaunhusain.fingerPainting.view.optionPanels.ColorConversionFunctions;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.AccelerometerEvent;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class ColorValueDisplay extends Sprite
	{
		//--------------------------------------------------------------------------------
		//				UI Components
		//--------------------------------------------------------------------------------
		private var colorSampleContainer:Sprite;
		private var colorSampleText:TextField;
		private var colorSample:Bitmap;
		private var background:Sprite;
		private var colorSampleTextFormat:TextFormat;
		private var model:PaintModel = PaintModel.getInstance();
		
		//--------------------------------------------------------------------------------
		//				Constructor
		//--------------------------------------------------------------------------------
		public function ColorValueDisplay()
		{
			super();
			
			if(!background)
			{
				background = new Sprite();
				background.graphics.clear();
				background.graphics.beginFill(0x000000, .8);
				background.graphics.drawRect(0,0,150*model.dpiScale,150*model.dpiScale);
				background.graphics.endFill();
				addChild(background);
			}
			
			if(!colorSampleContainer)
			{
				colorSampleContainer = new Sprite();
				addChild(colorSampleContainer);
			}
			
			if(!colorSampleText)
			{
				colorSampleTextFormat = new TextFormat();
				colorSampleTextFormat.color = 0xFFFFFF;
				colorSampleTextFormat.size = 26 * model.dpiScale;
				
				colorSampleText = new TextField();
				colorSampleText.autoSize = TextFieldAutoSize.LEFT;
				colorSampleText.text = "R: 255\nG: 0\nB: 0\nHex:0xFF0000";
				colorSampleTextFormat.font = "myFont";
				colorSampleText.defaultTextFormat = colorSampleTextFormat;
				colorSampleText.embedFonts = true;
				colorSampleContainer.addChild(colorSampleText);
			}
			
			if(!colorSample)
			{
				colorSample = new Bitmap(new BitmapData(50*model.dpiScale,50 * model.dpiScale,false,color));
				colorSample.x = 95 * model.dpiScale;
				colorSample.y = 15 * model.dpiScale;
				colorSampleContainer.addChild(colorSample);
			}
			
			
			var accManager:AccelerometerManager = AccelerometerManager.getIntance();
			accManager.addEventListener(AccelerometerEvent.UPDATE, handleAccelerometerChange);
			
			var locRot:Number;
			switch(accManager.currentOrientation)
			{
				case AccelerometerManager.PORTRAIT_DEFAULT:
					locRot = 0;
					break;
				case AccelerometerManager.PORTRAIT_FLIPPED:
					locRot = Math.PI;
					break;
				case AccelerometerManager.LANDSCAPE_LEFT:
					locRot = Math.PI/2;
					break;
				case AccelerometerManager.LANDSCAPE_RIGHT:
					locRot = -Math.PI/2;
					break;
			}
			Actuate.tween(this, 1, {rotateAroundCenter:locRot});
		}
		
		//--------------------------------------------------------------------------------
		//				Properties
		//--------------------------------------------------------------------------------
		private var _rotateAroundCenter:Number = 0;
		public function set rotateAroundCenter (angleRadians:Number):void
		{
			_rotateAroundCenter = angleRadians;
			
			var thisMatrix:Matrix = colorSampleContainer.transform.matrix.clone();
			thisMatrix.identity();
			thisMatrix.tx -= 75 * model.dpiScale;
			thisMatrix.ty -= 75 * model.dpiScale;
			thisMatrix.rotate (angleRadians);
			thisMatrix.tx += 75 * model.dpiScale;
			thisMatrix.ty += 75 * model.dpiScale;
			
			colorSampleContainer.transform.matrix = thisMatrix;
		}
		public function get rotateAroundCenter():Number
		{
			return _rotateAroundCenter;
		}

		
		//--------------------------------------------------------------------------------
		//				Handlers
		//--------------------------------------------------------------------------------
		private function handleAccelerometerChange(event:AccBasedOrientationEvent):void
		{
			
			var locRot:Number;
			switch(event.newOrientation)
			{
				case AccelerometerManager.PORTRAIT_DEFAULT:
					locRot = 0;
					break;
				case AccelerometerManager.PORTRAIT_FLIPPED:
					locRot = Math.PI;
					break;
				case AccelerometerManager.LANDSCAPE_LEFT:
					locRot = Math.PI/2;
					break;
				case AccelerometerManager.LANDSCAPE_RIGHT:
					locRot = -Math.PI/2;
					break;
			}
			
			Actuate.tween(this, 1, {rotateAroundCenter:locRot});
		}
		
		private var _color:uint;
		public function set color(value:uint):void
		{
			if(_color == value)
				return;
			
			_color = value;
			colorSample.bitmapData.floodFill(0,0,_color);
			
			var argb:ARGB = ColorConversionFunctions.parseARGBuint(_color);
			
			colorSampleText.text = "R: "+argb.red+"\nG: "+argb.green+"\nB: "+argb.blue+"\nHex:"+(_color&0x00FFFFFF).toString(16);
		}
		public function get color():uint
		{
			return _color;
		}
	}
}