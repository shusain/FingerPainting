package com.shaunhusain.fingerPainting.tools 
{
	import com.shaunhusain.fingerPainting.view.optionPanels.ColorOptionsPanel;
	
	import flash.display.Stage;
	import flash.events.TouchEvent;

	public class ColorSpectrumTool extends ToolBase implements ITool
	{
		public static var NAME:String = "colorSpectrumTool";
		
		//--------------------------------------------------------------------------------
		//				Variables
		//--------------------------------------------------------------------------------
		private var secondaryColorOptions:ColorOptionsPanel;
		
		//--------------------------------------------------------------------------------
		//				Constructor
		//--------------------------------------------------------------------------------
		public function ColorSpectrumTool(stage:Stage)
		{
			super(stage);
			
			secondaryColorOptions = new ColorOptionsPanel();
			secondaryColorOptions.x = 100;
			secondaryColorOptions.y = 100;
		}
		
		//--------------------------------------------------------------------------------
		//				Public Methods
		//--------------------------------------------------------------------------------
		public function toggleSecondaryOptions():void
		{
			if(secondaryPanelManager.currentlyShowing == secondaryColorOptions)
				secondaryPanelManager.hidePanel();
			else
			{
				secondaryPanelManager.showPanel(secondaryColorOptions);
			}
		}
		public function toString():String
		{
			return "Color Chooser";
		}
		
		//--------------------------------------------------------------------------------
		//				Handlers
		//--------------------------------------------------------------------------------
		public function takeAction(event:TouchEvent=null):void
		{
			toggleSecondaryOptions();
		}
	}
}