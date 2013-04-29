package com.nemenvisual.nicecomps
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author Ben Foster
	 */
	public class Button extends ComponentBase
	{
		private var _graphicBMD:BitmapData;
		private var _graphic:Bitmap;
		private var _graphicSet:Boolean;
		private var _toggle:Boolean;
		private var _selected:Boolean;
		private var _toggleIndicator:Shape;
		private var _labelTxt:TextField;
		private var _tf:TextFormat;
		private var _drawBackground:Boolean;
		private var _tint:Boolean;
		private var _alphaChannel:BitmapData;
		
		public function Button(dispatch:Boolean = true):void
		{
			super(dispatch);
			init();
		}
		
		protected override function init():void
		{
			super.init();
			
			//TweenPlugin.activate([TintPlugin]);
			
			_graphicSet 		= false;
			_toggle				= false;
			_selected			= false;
			_toggleIndicator	= new Shape();
			_labelTxt			= new TextField();
			_tf					= new TextFormat();
			_textColour			= 0x000000;
			_drawBackground		= false;
			_tint 				= false;
			
			_tf.color 			= _textColour;
			_tf.font 			= "Arial";
			_tf.align 			= "center";
			
			_boxWidth 			= 100;
			_boxHeight			= 22;
			
			_labelTxt.autoSize 			= TextFieldAutoSize.CENTER;
			_labelTxt.text 				= _label;
			_labelTxt.defaultTextFormat	= _tf;
			_labelTxt.x 				= 5;
			_labelTxt.y 				= 2;
			_labelTxt.selectable 		= false;
			_labelTxt.width 			= 100;
			
			this.addChild(_labelTxt);
			
			this.addEventListener(MouseEvent.MOUSE_OVER, onOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, onOut);
			
			redraw();
		}
		
		protected override function redraw():void
		{
			super.redraw();
			
			this.graphics.clear();
			this.graphics.beginFill(_accent, 1);
			this.graphics.drawRect( 0, 0,_boxWidth, _boxHeight);
			this.graphics.endFill();
			
			_labelTxt.width = _labelTxt.textWidth;
			_labelTxt.x = (_boxWidth / 2) - (_labelTxt.width / 2);
			_labelTxt.y = (_boxHeight / 2) - (_labelTxt.height / 2);
			
			if (_toggle)
			{
				_toggleIndicator.graphics.clear();
				_toggleIndicator.graphics.beginFill(0x000000, 0.3);
				_toggleIndicator.graphics.drawRect(0, 0, 3, _boxHeight-2);
				_toggleIndicator.graphics.endFill();
				_toggleIndicator.y = 1;
				_toggleIndicator.x = 1;
			}
			
			if (_tint && _graphicSet)
			{
				this.graphics.clear();
				
				var argb:uint = 0;
				argb += (255 << 24);
				argb += _accent;
				
				_graphicBMD.fillRect(_graphicBMD.rect, argb);
				_graphicBMD.copyChannel(_alphaChannel, _graphicBMD.rect, new Point(0,0), BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA);
			}
		}
		
		private function onOver(e:MouseEvent):void
		{
			this.alpha = 0.9;
		}
		
		private function onOut(e:MouseEvent):void
		{
			this.alpha = 1;
		}
		
		private function onClick(e:MouseEvent):void
		{
			if (_toggle)
			{
				_selected = !_selected;
				
				if (_selected)
				{
					_toggleIndicator.visible = true;
				}
				else
				{
					_toggleIndicator.visible = false;
				}
			}
		}
		
		//-----------------------SETTERS--------------------------------
		
		public override function set id(c:int):void
		{
			super.id = c;
		}
		
		public override function set baseColour(c:uint):void
		{
			super.baseColour = c;
		}
		
		public override function set accent(c:uint):void
		{
			super.accent = c;
			if (_drawBackground || !_graphicSet || _tint)
			{
				redraw();
			}
		}
		
		public override function set textColour(c:uint):void
		{
			super.textColour = c;
		}
		
		public override function set boxWidth(n:Number):void
		{
			super.boxWidth = n;
			redraw();
		}
		
		public override function set boxHeight(n:Number):void
		{
			super.boxHeight = n;
			redraw();
		}
		
		public override function set label(s:String):void
		{
			super.label = s;
			
			if (s != null)
			{
				_labelTxt.text = _label;
				_labelTxt.setTextFormat(_tf, 0, _labelTxt.text.length);
			}
			else
			{
				this.removeChild(_labelTxt);
			}
		}
		
		public override function set enable(b:Boolean):void
		{
			super.enable = b;
		}
		
		public function set graphic(d:DisplayObject):void
		{
			if (!_graphicSet)
			{
				this.graphics.clear();
				
				_graphicSet = true;
				_graphicBMD = new BitmapData(d.width, d.height, true, 0x00000000);
				_graphicBMD.draw(d);
				
				_graphic = new Bitmap(_graphicBMD);
				
				_boxWidth = _graphic.width;
				_boxHeight = _graphic.height;
				
				_alphaChannel = new BitmapData(_graphicBMD.width, _graphicBMD.height, true, 0xFFFFFFFF);
				_alphaChannel.copyChannel(_graphicBMD, _graphicBMD.rect, new Point(0, 0), BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA);
				
				if (_toggle)
				{
					this.addChildAt(_graphic, this.getChildIndex(_toggleIndicator));
				}
				else
				{
					this.addChild(_graphic);
				}
			}
		}
		
		public function set labelSize(n:Number):void
		{
			_tf.size = n;
			_labelTxt.setTextFormat(_tf, 0, _labelTxt.text.length);
			_labelTxt.y = (_boxHeight / 2) - (_labelTxt.height / 2);
		}
		
		public function set toggle(b:Boolean):void
		{
			if (b)
			{
				this.addChild(_toggleIndicator);
				_toggleIndicator.visible = false;
				this.addEventListener(MouseEvent.CLICK, onClick);
			}
			else
			{
				if (_toggle)
				{
					this.removeChild(_toggleIndicator);
					_toggleIndicator.visible = false;
					this.removeEventListener(MouseEvent.CLICK, onClick);
				}
			}
			_toggle = b;
		}
		
		public function set selected(b:Boolean):void
		{
			if (_toggle)
			{
				_selected = b;
				_toggleIndicator.visible = b;
			}
		}
		
		public function set disableRollover(b:Boolean):void
		{
			if (b)
			{
				this.alpha = 1;
				if (this.hasEventListener(MouseEvent.MOUSE_OVER))
				{
					this.removeEventListener(MouseEvent.MOUSE_OVER, onOver);
					this.removeEventListener(MouseEvent.MOUSE_OUT, onOut);
				}
			}
			else
			{
				if (!this.hasEventListener(MouseEvent.MOUSE_OVER))
				{
					this.addEventListener(MouseEvent.MOUSE_OVER, onOver);
					this.addEventListener(MouseEvent.MOUSE_OUT, onOut);
				}
			}
			
		}
		
		public function set drawBackground(b:Boolean):void
		{
			_drawBackground = b;
			
			if (b)
			{
				redraw();
			}
			
		}
		
		public function set allowTint(b:Boolean):void
		{
			_tint = b;
			
			if (b)
			{
				redraw();
			}
			
		}
		
		//--------------------GETTERS-------------------------------------
		
		public function get selected():Boolean
		{
			if (_toggle)
			{
				return _selected;
			}
			return false;
		}
		
	}
	
}