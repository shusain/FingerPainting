package com.shaunhusain.layerdImageVOs
{
	public class LayeredFileVO
	{
		private var _numChannels:int = 4;
		
		public function get numChannels():int
		{
			return _numChannels;
		}
		
		public function set numChannels(value:int):void
		{
			_numChannels = value;
		}
		
		private var _height:int;

		public function get height():int
		{
			return _height;
		}

		public function set height(value:int):void
		{
			_height = value;
		}

		private var _width:int;
		
		public function get width():int
		{
			return _width;
		}
		
		public function set width(value:int):void
		{
			_width = value;
		}

		private var _colorBitDepth:int = 8;
		
		public function get colorBitDepth():int
		{
			return _colorBitDepth;
		}
		
		public function set colorBitDepth(value:int):void
		{
			_colorBitDepth = value;
		}
		
		private var _colorMode:int = 3;

		public function get colorMode():int
		{
			return _colorMode;
		}

		public function set colorMode(value:int):void
		{
			_colorMode = value;
		}
		
		private var _layers:Vector.<LayerVO> = new Vector.<LayerVO>();

		public function get layers():Vector.<LayerVO>
		{
			return _layers;
		}

		public function set layers(value:Vector.<LayerVO>):void
		{
			_layers = value;
		}
				
		
		public function LayeredFileVO()
		{
		}
	}
}