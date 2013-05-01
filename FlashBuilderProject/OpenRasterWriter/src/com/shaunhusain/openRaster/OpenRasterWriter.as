package com.shaunhusain.openRaster
{
	import com.adobe.images.PNGEncoder;
	import com.shaunhusain.layerdImageVOs.LayeredFileVO;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import deng.fzip.FZip;

	public class OpenRasterWriter
	{
		private static var instance:OpenRasterWriter;
		
		public function OpenRasterWriter(se:SE){}
		
		public static function getInstance():OpenRasterWriter
		{
			if(!instance) instance = new OpenRasterWriter(new SE()); return instance;
		}
		
		public function write(file:LayeredFileVO):ByteArray
		{
			var fzip:FZip = new FZip();
			
			var stackXML:XML = 	<image w={file.width} h={file.height}>
									<stack>
										
									</stack>
								</image>;
			
			//top layer comes first
			for(var i:int = file.layers.length-1; i>=0; i--)
			{
				var tempBDRect:Rectangle = getVisibleBounds(file.layers[i].bitmap);
				
				//currently skipping transparent layers (no visible width or height)
				if(tempBDRect.width==0||tempBDRect.height==0)
					continue
				var tempBD:BitmapData = new BitmapData(tempBDRect.width,tempBDRect.height,true,0);
				tempBD.copyPixels(file.layers[i].bitmapData,tempBDRect,new Point(0,0));
				trace("copied pixels");
				
				var layerSrc:String = "data/layer"+i+".png";
				
				
				fzip.addFile(layerSrc, PNGEncoder.encode(tempBD));
				
				tempBD.dispose();
				
				var layerXML:XML = 	<layer src={layerSrc} x={tempBDRect.x} y={tempBDRect.y} alpha={file.layers[i].bitmap.alpha}>
									</layer>
				stackXML.stack.appendChild(layerXML);
				trace("wrote layer");
			}
			
			var stackString:String = "<?xml version='1.0' encoding='UTF-8'?>\n"+stackXML.toXMLString();
			trace(stackString);
			
			fzip.addFileFromString("mimetype", "image/openraster", "utf-8", false);
			fzip.addFileFromString("stack.xml", stackString, "utf-8");
			
			var ba:ByteArray = new ByteArray();
			fzip.serialize(ba,true);
			return ba;
		}
		
		public function getVisibleBounds(source:DisplayObject):Rectangle
		{
			var matrix:Matrix = new Matrix()
			matrix.tx = -source.getBounds(null).x;
			matrix.ty = -source.getBounds(null).y;
			
			var data:BitmapData = new BitmapData(source.width, source.height, true, 0x00000000);
			data.draw(source, matrix);
			var bounds : Rectangle = data.getColorBoundsRect(0xFFFFFFFF, 0x000000, false);
			data.dispose();
			return bounds;
		}
	}
}
class SE{}