package com.shaunhusain.fingerPainting.tools 
{
	import com.shaunhusain.fingerPainting.view.SecondaryColorOptions;
	
	import flash.display.Stage;
	import flash.events.TouchEvent;

	public class ColorSpectrumTool extends ToolBase implements ITool
	{
		public static var NAME:String = "colorSpectrumTool";
		private var secondaryColorOptions:SecondaryColorOptions;
		public function ColorSpectrumTool(stage:Stage)
		{
			super(stage);
			
			secondaryColorOptions = new SecondaryColorOptions();
			secondaryColorOptions.x = 100;
			secondaryColorOptions.y = 100;
		}
		public function takeAction(event:TouchEvent=null):void
		{
			toggleSecondaryOptions();
		}
		
		public function toggleSecondaryOptions():void
		{
			if(secondaryPanelManager.currentlyShowing == secondaryColorOptions)
				secondaryPanelManager.hidePanel();
			else
			{
				secondaryPanelManager.showPanel(secondaryColorOptions);
			}
		}
	}
}