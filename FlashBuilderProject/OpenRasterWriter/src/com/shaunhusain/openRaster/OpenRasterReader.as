package com.shaunhusain.openRaster
{
	import com.shaunhusain.layerdImageVOs.LayerVO;
	import com.shaunhusain.layerdImageVOs.LayeredFileVO;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.utils.ByteArray;
	
	import deng.fzip.FZip;
	import deng.fzip.FZipFile;
	
	public class OpenRasterReader
	{
		private static var instance:OpenRasterReader;
		private var _callback:Function;
		private var _layersQueue:Vector.<Object>;
		private var _layeredFileVO:LayeredFileVO;
		private var _origWidth:int;
		private var _origHeight:int;
		private var _offsetX:int;
		private var _offsetY:int;
		private var _alpha:Number;
		
		
		public function OpenRasterReader(se:SE){}
		
		public static function getInstance():OpenRasterReader
		{
			if(!instance) instance = new OpenRasterReader(new SE()); return instance;
		}
		
		public function read(ba:ByteArray, callback:Function):void
		{
			_layeredFileVO = new LayeredFileVO();
			_layersQueue = new Vector.<Object>();
			_callback = callback;
			var fzip:FZip = new FZip();
			fzip.loadBytes(ba);
			
			var stackFile:FZipFile = fzip.getFileByName("stack.xml");
			var stackFileBA:ByteArray = stackFile.content;
			
			var stackXML:XML = 	new XML(stackFileBA.readUTFBytes(stackFileBA.bytesAvailable));
			
			_origWidth = parseInt(stackXML.@w);
			_origHeight = parseInt(stackXML.@h);
			
			for each(var layer:XML in stackXML..layer)
			{
				var layerImgFile:FZipFile = fzip.getFileByName(layer.@src);
				
				var layerQueueObj:Object = {fzipFile:layerImgFile, offsetX: layer.@x, offsetY: layer.@y};
				
				if(layer.hasOwnProperty("@alpha"))
					layerQueueObj.alpha = layer.@alpha;
				_layersQueue.push(layerQueueObj);
			}
			loadLayers();
		}
		
		private function loadLayers():void
		{
			if(_layersQueue.length == 0)
			{
				_callback(_layeredFileVO);
				return;
			}
			var layerQueueObj:Object = _layersQueue.pop();
			var layerImgFile:FZipFile = layerQueueObj.fzipFile;
			_offsetX = layerQueueObj.offsetX;
			_offsetY = layerQueueObj.offsetY;
			
			if(layerQueueObj.hasOwnProperty("alpha"))
				_alpha = layerQueueObj.alpha;
			else 
				_alpha = 1;
			
			var loader:Loader = new Loader();
			loader.loadBytes(layerImgFile.content);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, finishedLoadingBytes);
		}
		
		protected function finishedLoadingBytes(event:Event):void
		{
			var loaderInfo:LoaderInfo = (event.target as LoaderInfo);
			var bd:BitmapData = new BitmapData(_origWidth, _origHeight,true, 0);
			
			var offsetMatrix:Matrix = new Matrix();
			offsetMatrix.tx = _offsetX;
			offsetMatrix.ty = _offsetY;
			
			var bmp:Bitmap = new Bitmap(bd);
			bmp.alpha = _alpha;
			
			bd.draw(loaderInfo.content,offsetMatrix);
			_layeredFileVO.layers.push(new LayerVO(bd,bmp));
			loadLayers();
		}
	}
}


class SE{}