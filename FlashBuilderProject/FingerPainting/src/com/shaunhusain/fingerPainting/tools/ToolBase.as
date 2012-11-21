package com.shaunhusain.fingerPainting.tools
{
	import com.shaunhusain.fingerPainting.model.PaintModel;

	public class ToolBase
	{
		protected var model:PaintModel = PaintModel.getInstance();
		public function ToolBase()
		{
		}
	}
}