package com.shaunhusain.fingerPainting.tools
{
	import com.shaunhusain.fingerPainting.managers.LayerManager;
	import com.shaunhusain.fingerPainting.managers.SecondaryPanelManager;
	import com.shaunhusain.fingerPainting.managers.UndoManager;
	import com.shaunhusain.fingerPainting.model.PaintModel;
	
	import flash.display.Stage;

	public class ToolBase
	{
		protected var model:PaintModel = PaintModel.getInstance();
		protected var undoManager:UndoManager = UndoManager.getIntance();
		protected var secondaryPanelManager:SecondaryPanelManager = SecondaryPanelManager.getIntance();
		protected var layerManager:LayerManager = LayerManager.getIntance();
		protected var stage:Stage;
		public function ToolBase(stage:Stage)
		{
			this.stage = stage;
		}
	}
}