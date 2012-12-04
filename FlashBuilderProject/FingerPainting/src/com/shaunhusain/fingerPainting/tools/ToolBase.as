package com.shaunhusain.fingerPainting.tools
{
	import com.shaunhusain.fingerPainting.managers.UndoManager;
	import com.shaunhusain.fingerPainting.model.PaintModel;

	public class ToolBase
	{
		protected var model:PaintModel = PaintModel.getInstance();
		protected var undoManager:UndoManager = UndoManager.getIntance();
		public function ToolBase()
		{
		}
	}
}