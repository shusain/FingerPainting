package com.shaunhusain.fingerPainting.tools 
{
	import com.shaunhusain.fingerPainting.view.managers.SecondaryPanelManager;
	import com.shaunhusain.fingerPainting.view.optionPanels.SavePanel;
	
	import flash.display.Stage;
	import flash.events.TouchEvent;
	
	public class SaveTool extends ToolBase implements ITool
	{
		//--------------------------------------------------------------------------------
		//				Variables
		//--------------------------------------------------------------------------------
		private var secondaryPanelManager:SecondaryPanelManager = SecondaryPanelManager.getIntance();
		private var savePanel:SavePanel;
		
		//--------------------------------------------------------------------------------
		//				Constructor
		//--------------------------------------------------------------------------------
		public function SaveTool(stage:Stage)
		{
			super(stage);
			savePanel = new SavePanel();
			savePanel.x = 100;
			savePanel.y = 100;
		}
		
		//--------------------------------------------------------------------------------
		//				Handlers
		//--------------------------------------------------------------------------------
		public function takeAction(event:TouchEvent=null):void
		{
			if(secondaryPanelManager.currentlyShowing == savePanel)
				secondaryPanelManager.hidePanel();
			else
				secondaryPanelManager.showPanel(savePanel);
		}
		public function toString():String
		{
			return "Save: Saves flattened layers as PNG to a file for on device storage";
		}
	}
}