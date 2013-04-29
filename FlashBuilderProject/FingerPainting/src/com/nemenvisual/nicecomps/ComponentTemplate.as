package com.nemenvisual.nicecomps
{
	import com.nemenvisual.nicecomps.IComponent;
	
	/**
	 * ...
	 * @author Ben Foster
	 */
	public class ComponentTemplate extends ComponentBase
	{
		
		
		public function ComponentTemplate(dispatch:Boolean = true):void
		{
			super(dispatch);
			init();
		}
		
		protected override function init():void
		{
			
		}
		
		protected override function redraw():void
		{
			super.redraw();
			
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
		}
		
		public override function set textColour(c:uint):void
		{
			super.textColour = c;
		}
		
		public override function set boxWidth(n:Number):void
		{
			super.boxWidth = n;
		}
		
		public override function set boxHeight(n:Number):void
		{
			super.boxHeight = n;
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