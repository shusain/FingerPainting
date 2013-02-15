package com.shaunhusain.fingerPainting.tools
{
	import com.shaunhusain.fingerPainting.view.managers.LayerManager;
	import com.shaunhusain.fingerPainting.view.managers.SecondaryPanelManager;
	import com.shaunhusain.fingerPainting.managers.UndoManager;
	import com.shaunhusain.fingerPainting.model.PaintModel;
	
	import flash.display.Stage;

	/**
	 * Base class for tools to give them all easy access to the Singletons and
	 * the Stage.
	 */
	public class ToolBase
	{
		//--------------------------------------------------------------------------------
		//				Variables
		//--------------------------------------------------------------------------------
		protected var model:PaintModel = PaintModel.getInstance();
		protected var undoManager:UndoManager = UndoManager.getIntance();
		protected var secondaryPanelManager:SecondaryPanelManager = SecondaryPanelManager.getIntance();
		protected var layerM:LayerManager = LayerManager.getIntance();
		protected var stage:Stage;
		
		//--------------------------------------------------------------------------------
		//				Constructor
		//--------------------------------------------------------------------------------
		public function ToolBase(stage:Stage)
		{
			this.stage = stage;
		}
	}
}