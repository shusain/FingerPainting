package com.shaunhusain.fingerPainting.tools 
{
	import com.shaunhusain.fingerPainting.view.SecondaryColorOptions;
	
	import flash.display.Stage;
	import flash.events.TouchEvent;

	public class ColorSpectrumTool extends ToolBase implements ITool
	{
		public static var NAME:String = "colorSpectrumTool";
		
		//--------------------------------------------------------------------------------
		//				Variables
		//--------------------------------------------------------------------------------
		private var secondaryColorOptions:SecondaryColorOptions;
		
		//--------------------------------------------------------------------------------
		//				Constructor
		//--------------------------------------------------------------------------------
		public function ColorSpectrumTool(stage:Stage)
		{
			super(stage);
			
			secondaryColorOptions = new SecondaryColorOptions();
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
		
		//--------------------------------------------------------------------------------
		//				Handlers
		//--------------------------------------------------------------------------------
		public function takeAction(event:TouchEvent=null):void
		{
			toggleSecondaryOptions();
		}
	}
}