package com.shaunhusain.fingerPainting.view.optionPanels
{
	import com.shaunhusain.fingerPainting.model.color.ARGB;
	import com.shaunhusain.fingerPainting.model.color.HSV;

	public class ColorConversionFunctions
	{
		public function ColorConversionFunctions()
		{
		}
		
		public static function parseARGBuint(color:uint):ARGB
		{
			trace("Parsing ARGB");
			trace(color.toString(16));
			var returnARGB:ARGB = new ARGB(color>>24 & 0xFF,color>>16 & 0xFF,color>>8 & 0xFF,color & 0xFF);
			trace(returnARGB);
			return returnARGB;
		}
		
		public static function RGBtoHSV(argb:ARGB):HSV
		{
			trace("Converting ARGB to HSV");
			trace("ARGB Original:", argb);
			var returnHSV:HSV = new HSV();
			var cMax:Number, cMin:Number;
			
			var r:Number = argb.red;
			var g:Number = argb.green;
			var b:Number = argb.blue;
			
			r = r/255;
			g = g/255;
			b = b/255;
			cMax = Math.max(r,g,b);
			cMin = Math.min(r,g,b);
			
			//if grayscale
			if(cMin == cMax)
			{
				returnHSV.value = cMin;
				returnHSV.hue = returnHSV.saturation = 0;
			} //if color
			else
			{
				var d:Number = (r==cMin) ? g-b : ((b==cMin) ? r-g : b-r);
				var h:Number = (r==cMin) ? 3 : ((b==cMin) ? 1 : 5);
				returnHSV.hue = 60*(h - d/(cMax - cMin));
				returnHSV.saturation = (cMax - cMin)/cMax;
				returnHSV.value = cMax;
			}
			
			trace("HSV Converted: ", returnHSV);
			
			return returnHSV;
		}
		
		public static function AHSVtoARGB(a:Number=1,hue:Number=0,saturation:Number=.5, value:Number = 1):uint
		{
			a = Math.max(0,Math.min(1,a));
			saturation = Math.max(0,Math.min(1,saturation));
			value = Math.max(0,Math.min(1,value));
			hue = hue%360;
			if(hue<0)hue+=360;
			hue/=60;
			var C:Number = value*saturation;
			var X:Number = C*(1-Math.abs((hue%2)-1));
			var m:Number = value-C;
			C=(C+m)*255;
			X=(X+m)*255;
			m*=255;
			if(hue<1) return (Math.round(a*255)<<24)+(C<<16)+(X<<8)+m;
			if(hue<2) return (Math.round(a*255)<<24)+(X<<16)+(C<<8)+m;
			if(hue<3) return (Math.round(a*255)<<24)+(m<<16)+(C<<8)+X;
			if(hue<4) return (Math.round(a*255)<<24)+(m<<16)+(X<<8)+C;
			if(hue<5) return (Math.round(a*255)<<24)+(X<<16)+(m<<8)+C;
			return (Math.round(a*255)<<24)+(C<<16)+(m<<8)+X;
		}
		
		
		
		/**
		 * Converts Alpha, Hue, Saturation, Lightness, to ARGB
		 */
		public static function AHSLtoARGB(a:Number=1,hue:Number=0,saturation:Number=0.5,lightness:Number=1):uint{
			a = Math.max(0,Math.min(1,a));
			saturation = Math.max(0,Math.min(1,saturation));
			lightness = Math.max(0,Math.min(1,lightness));
			hue = hue%360;
			if(hue<0)hue+=360;
			hue/=60;
			var C:Number = (1-Math.abs(2*lightness-1))*saturation;
			var X:Number = C*(1-Math.abs((hue%2)-1));
			var m:Number = lightness-0.5*C;
			C=(C+m)*255;
			X=(X+m)*255;
			m*=255;
			if(hue<1) return (Math.round(a*255)<<24)+(C<<16)+(X<<8)+m;
			if(hue<2) return (Math.round(a*255)<<24)+(X<<16)+(C<<8)+m;
			if(hue<3) return (Math.round(a*255)<<24)+(m<<16)+(C<<8)+X;
			if(hue<4) return (Math.round(a*255)<<24)+(m<<16)+(X<<8)+C;
			if(hue<5) return (Math.round(a*255)<<24)+(X<<16)+(m<<8)+C;
			return (Math.round(a*255)<<24)+(C<<16)+(m<<8)+X;
		}
		
		public static function RGBtoHSL(r:Number, g:Number, b:Number):void
		{
			r = r/255;
			g = g/255;
			b = b/255;
			var cMax:Number = Math.max(r,g,b);
			var cMin:Number = Math.min(r,g,b);
			var delta:Number = cMax - cMin;
			
			var hue:Number;
			var saturation:Number;
			var lightness:Number = cMax+cMin/2;
			switch(cMax)
			{
				case r:
					hue = 60*(((g-b)/delta)%6);
					break;
				case g:
					hue = 60*(((b-r)/delta)+2);
					break;
				case b:
					hue = 60*(((r-g)/delta)+4);
					break;
			}
			
			if(delta == 0)
				saturation = 0;
			else
				saturation = delta/(1-Math.abs(2*lightness-1));
			trace("hue: ",hue," saturation:",saturation," lightness:",lightness);
		}
	}
}