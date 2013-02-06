package com.shaunhusain.fingerPainting.model.color
{
	/**
	 * Value object for holding Hue, Saturation, and Value for convenience.
	 */
	public class HSV
	{
		public var alpha:Number=0;
		public var hue:Number=0;
		public var saturation:Number=0;
		public var value:Number=0;
		
		public function HSV()
		{
		}
		
		public function toString():String
		{
			return "ARGB: (" + alpha + ", " + hue + ", " + saturation + ", " + value + ")"; 
		}
	}
}