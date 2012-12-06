package com.shaunhusain.fingerPainting.tools 
{
	import com.shaunhusain.fingerPainting.managers.SecondaryPanelManager;
	import com.shaunhusain.fingerPainting.view.SavePanel;
	
	import flash.events.TouchEvent;
	
	public class SaveTool extends ToolBase implements ITool
	{
		private var secondaryPanelManager:SecondaryPanelManager = SecondaryPanelManager.getIntance();
		private var savePanel:SavePanel;
		public function SaveTool()
		{
			savePanel = new SavePanel();
			savePanel.x = 100;
			savePanel.y = 100;
		}
		public function takeAction(event:TouchEvent=null):void
		{
			if(secondaryPanelManager.currentlyShowing == savePanel)
				secondaryPanelManager.hidePanel();
			else
				secondaryPanelManager.showPanel(savePanel);
		}
	}
}