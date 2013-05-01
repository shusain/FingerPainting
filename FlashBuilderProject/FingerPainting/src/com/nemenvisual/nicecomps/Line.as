package com.nemenvisual.nicecomps
{
	import com.nemenvisual.nicecomps.IComponent;
	
	/**
	 * ...
	 * @author Ben Foster
	 */
	public class Line extends ComponentBase
	{
		private var _thickness:Number;
		private var _alpha:Number;
		
		public function Line(dispatch:Boolean = true):void
		{
			super(dispatch);
			init();
		}
		
		protected override function init():void
		{
			_thickness 	= 1;
			_alpha 		= 1;
			
			_id			= -1;
			_baseColour	= 0x333333;
			_accent 	= 0x9ADD43;
			_textColour	= 0xFFFFFF;
			_label		= "Label";
			_enabled	= true;
			
			redraw();
		}
		
		protected override function redraw():void
		{
			super.redraw();
			graphics.clear();
			graphics.lineStyle(_thickness, _accent, _alpha);
			graphics.moveTo(0, 0);
			graphics.lineTo(_boxWidth, _boxHeight);
		}
		
		
		//-----------------------SETTERS--------------------------------
		
		public override function set id(c:int):void
		{
			super.id = c;
		}
		
		public override function set baseColour(c:uint):void
		{
			super.baseColour = c;
		}
		
		public override function set accent(c:uint):void
		{
			super.accent = c;
			redraw();
		}
		
		public override function set textColour(c:uint):void
		{
			super.textColour = c;
		}
		
		public override function set boxWidth(n:Number):void
		{
			super.boxWidth = n;
			redraw();
		}
		
		public override function set boxHeight(n:Number):void
		{
			super.boxHeight = n;
			redraw();
		}
		
		public override function set label(s:String):void
		{
			super.label = s;
		}
		
		public override function set enable(b:Boolean):void
		{
			super.enable = b;
		}
		
	}
	
}