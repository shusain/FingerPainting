package com.nemenvisual.nicecomps
{
	import flash.display.Shape;
	import com.nemenvisual.nicecomps.IComponent;
	
	/**
	 * ...
	 * @author Ben Foster
	 */
	public class ProgressBar extends ComponentBase
	{
		private var _prog:Shape;
		private var _percent:Number;
		
		public function ProgressBar(dispatch:Boolean = true):void
		{
			super(dispatch);
			init();
		}
		
		protected override function init():void
		{
			_prog = new Shape();
			addChild(_prog);
			
			_percent = 0;
			_boxWidth = 100;
			_boxHeight = 10;
			_baseColour = 0x666666;
			
		}
		
		protected override function redraw():void
		{
			super.redraw();
			
			graphics.clear();
			graphics.beginFill(_baseColour, 1);
			graphics.drawRect(0, 0, _boxWidth, _boxHeight);
			graphics.endFill();
			
			_prog.graphics.clear();
			_prog.graphics.beginFill(_accent, 1);
			_prog.graphics.drawRect(0, 0, _percent*_boxWidth, _boxHeight);
			_prog.graphics.endFill();
			
		}
		
		public function setProgress(prog:Number, total:Number):void
		{
			_percent = prog / total;
			
			redraw();
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