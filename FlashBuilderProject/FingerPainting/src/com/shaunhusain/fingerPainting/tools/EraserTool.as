package com.shaunhusain.fingerPainting.tools 
{
	import com.shaunhusain.fingerPainting.tools.extras.EraserTip;
	import com.shaunhusain.fingerPainting.view.optionPanels.BrushOptionsPanel;
	
	import flash.display.Stage;
	import flash.utils.ByteArray;
	
	public class EraserTool extends BrushTool
	{
		//--------------------------------------------------------------------------------
		//				Variables
		//--------------------------------------------------------------------------------
		private var touchSamples:ByteArray
		
		//--------------------------------------------------------------------------------
		//				Constructor
		//--------------------------------------------------------------------------------
		public function EraserTool(stage:Stage)
		{
			super(stage);
			
			brushTip = new EraserTip();
			
			secondaryBrushOptions = new BrushOptionsPanel(brushTip);
		}
		
		//--------------------------------------------------------------------------------
		//				Overrides
		//--------------------------------------------------------------------------------
		
		override public function toString():String
		{
			return "Eraser: Touch again to toggle eraser options";
		}
	}
}