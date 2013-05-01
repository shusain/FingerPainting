package com.shaunhusain.fingerPainting.model.color
{
	/**
	 * Value object for holding Alpha, Red, Green, and Blue.  Values should be
	 * in the range of 0-255 but this restriction is not enforced.
	 */
	public class ARGB
	{
		public var alpha:uint=0;
		public var red:uint=0;
		public var green:uint=0;
		public var blue:uint=0;
		
		public function ARGB(alpha:uint=0,red:uint=0,green:uint=0,blue:uint=0)
		{
			this.alpha = alpha;
			this.red = red;
			this.green = green;
			this.blue = blue;
		}
		
		public function toString():String
		{
			return "ARGB: (" + alpha + ", " + red + ", " + green + ", " + blue + ")"; 
		}
	}
}