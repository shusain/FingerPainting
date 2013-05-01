package com.nemenvisual.nicecomps
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.nemenvisual.nicecomps.IComponent;
	import com.greensock.*;
	import com.greensock.easing.*;
	
	/**
	 * ...
	 * @author Ben Foster
	 */
	
	public class DisplayScroller extends ComponentBase
	{
		private var _upArrow:Sprite;
		private var _dnArrow:Sprite;
		private var _thumb:Sprite;
		private var _thumbHeight:Number;
		private var _offset:Number;
		private var _target:DisplayObject;
		private var _scrolling:Boolean;
		private var _windowHeight:Number;
		private var _yoffset:Number;
		private var _scrollPos:Number;
		
		public function DisplayScroller(dispatch:Boolean = true):void
		{
			super(dispatch);
			init();
		}
		
		protected override function init():void
		{
			_boxHeight = 150;
			_boxWidth = 10;
			_thumbHeight = (_boxHeight-(2*_boxWidth))/2;
			_textColour = 0x999999;
			_baseColour = 0x333333;
			_enabled = true;
			_scrolling = false;
			_scrollPos = 0;
			
			_upArrow = new Sprite();
			_dnArrow = new Sprite();
			_thumb = new Sprite();
			
			drawArrowButton(_upArrow,_textColour);
			drawArrowButton(_dnArrow,_textColour);
			drawThumb(_textColour);
			
			_dnArrow.y = _boxHeight - _boxWidth;
			
			_upArrow.rotation = 180;
			_upArrow.x = _boxWidth;
			_upArrow.y = _boxWidth;
			
			_thumb.y = (_thumbHeight/2)+_boxWidth;
			
			setListeners();
			
			this.addChild(_upArrow);
			this.addChild(_dnArrow);
			this.addChild(_thumb);
			
			redraw();
		}
		
		protected override function redraw():void
		{
			super.redraw();
			drawThumb(_textColour);
			drawArrowButton(_upArrow, _textColour);
			drawArrowButton(_dnArrow, _textColour);
			_thumb.y = (_thumbHeight/2)+_boxWidth;
			_dnArrow.y = _boxHeight - _boxWidth;
			graphics.clear();
			graphics.beginFill(_baseColour,1);
			graphics.drawRect(0, 0, _boxWidth, _boxHeight);
			graphics.endFill();
		}
		
		private function setListeners():void
		{
			if (_enabled)
			{
				_thumb.addEventListener(MouseEvent.MOUSE_DOWN, thumbDown);
				_thumb.addEventListener(MouseEvent.MOUSE_OVER, thumbOver);
				_thumb.addEventListener(MouseEvent.MOUSE_OUT, thumbOut);
				
				_upArrow.addEventListener(MouseEvent.MOUSE_OVER, arrowOver);
				_upArrow.addEventListener(MouseEvent.MOUSE_OUT, arrowOut);
				_dnArrow.addEventListener(MouseEvent.MOUSE_OVER, arrowOver);
				_dnArrow.addEventListener(MouseEvent.MOUSE_OUT, arrowOut);
				
				_upArrow.addEventListener(MouseEvent.MOUSE_UP, upClick);
				_dnArrow.addEventListener(MouseEvent.MOUSE_UP, dnClick);
				this.addEventListener(MouseEvent.MOUSE_WHEEL, onScrollWheel);
				
				if (_target != null)
				{
					_target.addEventListener(MouseEvent.MOUSE_WHEEL, onScrollWheel);
				}
				
			}
			else
			{
				_thumb.removeEventListener(MouseEvent.MOUSE_DOWN, thumbDown);
				_thumb.removeEventListener(MouseEvent.MOUSE_OVER, thumbOver);
				_thumb.removeEventListener(MouseEvent.MOUSE_OUT, thumbOut);
				
				_upArrow.removeEventListener(MouseEvent.MOUSE_OVER, arrowOver);
				_upArrow.removeEventListener(MouseEvent.MOUSE_OUT, arrowOut);
				_dnArrow.removeEventListener(MouseEvent.MOUSE_OVER, arrowOver);
				_dnArrow.removeEventListener(MouseEvent.MOUSE_OUT, arrowOut);
				
				_upArrow.removeEventListener(MouseEvent.MOUSE_UP, upClick);
				_dnArrow.removeEventListener(MouseEvent.MOUSE_UP, dnClick);
				this.removeEventListener(MouseEvent.MOUSE_WHEEL, onScrollWheel);
				
				if (_target != null)
				{
					_target.removeEventListener(MouseEvent.MOUSE_WHEEL, onScrollWheel);
				}
			}
		}
		
		private function thumbOver(e:MouseEvent):void
		{
			drawThumb(_accent);
		}
		
		private function thumbOut(e:MouseEvent):void
		{
			drawThumb(_textColour);
		}
		
		private function arrowOver(e:MouseEvent):void
		{
			drawArrowButton(e.target as Sprite,_accent);
		}
		
		private function arrowOut(e:MouseEvent):void
		{
			drawArrowButton(e.target as Sprite,_textColour);
		}
		
		private function thumbDown(e:MouseEvent):void
		{
			e.stopPropagation();
			_scrolling = true;
			_offset = _thumb.y - this.mouseY;
			_thumb.removeEventListener(MouseEvent.MOUSE_OUT, thumbOut);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onUp);
		}
		
		private function onMove(e:MouseEvent):void
		{
			e.stopImmediatePropagation();
			
		
			_thumb.y = this.mouseY + _offset;
			
			if (_thumb.y < (_thumbHeight/2)+_boxWidth)
			{
				_thumb.y = (_thumbHeight/2)+_boxWidth;
			}
			else if (_thumb.y > _boxHeight - ((_thumbHeight / 2) + _boxWidth))
			{
				_thumb.y = _boxHeight - ((_thumbHeight / 2) + _boxWidth);
			}
			
			e.updateAfterEvent();
			calculateScroll();
		}
		
		private function upClick(e:MouseEvent):void
		{
			e.stopPropagation();
			
			if (_scrolling)
			{
				onUp(null);
			}
			
			_scrolling = false;
			if (_thumb.y > (_thumbHeight/2)+_boxWidth)
			{
				_thumb.y -= 10;
			}
			else
			{
				
				_thumb.y = (_thumbHeight/2)+_boxWidth;
			}
			
			if (_thumb.y < (_thumbHeight/2)+_boxWidth)
			{
				_thumb.y = (_thumbHeight/2)+_boxWidth;
			}
			
			calculateScroll();
		}
		
		private function dnClick(e:MouseEvent):void
		{
			e.stopPropagation();
			
			if (_scrolling)
			{
				onUp(null);
			}
			
			_scrolling = false;
			if (_thumb.y < _boxHeight - ((_thumbHeight / 2) + _boxWidth))
			{
				_thumb.y += 10;
			}
			else
			{
				_thumb.y = _boxHeight - ((_thumbHeight / 2) + _boxWidth);
				
			}
			
			if (_thumb.y > _boxHeight - ((_thumbHeight / 2) + _boxWidth))
			{
				_thumb.y = _boxHeight - ((_thumbHeight / 2) + _boxWidth);
			}
			calculateScroll();
		}
		
		private function calculateScroll():void
		{
			var sMax:Number = _boxHeight - ((_thumbHeight / 2) + _boxWidth);
			var sMin:Number = (_thumbHeight / 2) + _boxWidth;
			var total:Number = sMax - sMin;
			var perc:Number = (_thumb.y - sMin) / total;
			
			_scrollPos = perc;
			
			if (_target != null)
			{
				var yt:Number = _yoffset + ((_target.height - _windowHeight)  * -perc);
				TweenLite.to(_target, 0.5, { y:yt, ease:Quint.easeOut, overwrite:true } );
				//_target.y = _yoffset + ((_target.height - _windowHeight)  * -perc);
			
			}
		}
		
		private function onUp(e:MouseEvent):void
		{
			_scrolling = false;
			_thumb.addEventListener(MouseEvent.MOUSE_OUT, thumbOut);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onUp);
			
			if (e != null)
			{
				if (e.target != _thumb)
				{
					thumbOut(null);
				}
			}
			else
			{
				thumbOut(null);
			}
		}
		
		private function drawThumb(c:uint):void
		{
			_thumb.graphics.clear();
			_thumb.graphics.beginFill(c, 1);
			_thumb.graphics.drawRect( 0, _thumbHeight / -2, _boxWidth, _thumbHeight);
			_thumb.graphics.endFill();
		}
		
		private function drawArrowButton(s:Sprite,c:uint):void
		{
			s.graphics.clear();
			s.graphics.beginFill(_baseColour, 1);
			s.graphics.drawRect(0, 0, _boxWidth, _boxWidth);
			s.graphics.endFill();
			s.graphics.beginFill(c, 1);
			s.graphics.moveTo(0, 3);
			s.graphics.lineTo(10, 3);
			s.graphics.lineTo(5, 8);
			s.graphics.lineTo(0, 3);
			s.graphics.endFill();
		}
		
		private function scrollBar():void
		{
			var sMax:Number	= _boxHeight - ((_thumbHeight / 2) + _boxWidth);
			var sMin:Number = (_thumbHeight / 2) + _boxWidth;
			var total:Number = sMax - sMin;
			
			var perc:Number = (_target.x) / (_target.height - _windowHeight);
			
			if (_target.x == 0) { perc = 0 }
			else if (_target.x == -(_target.height - _windowHeight)) { perc = 1 };
			
			_thumb.y = ((_thumbHeight / 2) + _boxWidth) + (total * perc);
			
			if (_thumb.y < (_thumbHeight/2)+_boxWidth)
			{
				_thumb.y = (_thumbHeight/2)+_boxWidth;
			}
			else if (_thumb.y > _boxHeight - ((_thumbHeight/2)+_boxWidth))
			{
				_thumb.y = _boxHeight - ((_thumbHeight/2)+_boxWidth);
			}
		}
		
		private function updateBar(e:Event):void
		{
			update();
		}
		
		private function onScrollBar(e:Event):void
		{
			if (!_scrolling)
			{
				scrollBar();
			}
		}
		
		private function onScrollWheel(e:MouseEvent):void
		{
			e.stopImmediatePropagation();
			e.preventDefault();
			
			_scrolling = false;
			
			_thumb.y -= e.delta * 5;
			
			
			if (_thumb.y > _boxHeight - ((_thumbHeight/2)+_boxWidth))
			{
				_thumb.y = _boxHeight - ((_thumbHeight/2)+_boxWidth);
			}
			if (_thumb.y < (_thumbHeight/2)+_boxWidth)
			{
				_thumb.y = (_thumbHeight/2)+_boxWidth;
			}
			
			calculateScroll();
		}
		
		public function update():void
		{
			if (_target.height > _windowHeight)
			{
				
				enable = true;
				setListeners();
			}
			else
			{
				enable = false;
				setListeners();
			}
			
			//calculate the percentage for thumb height
			_thumbHeight = ((_windowHeight / _target.height) * _boxHeight) - (2 * _boxWidth);
			
			if (_thumbHeight < 20)
			{
				_thumbHeight = 20;
			}
			
			drawThumb(_textColour);
			scrollTo(_scrollPos);
		}
		
		public function setTarget(m:DisplayObject,windowHeight:Number):void
		{
			_target = m;
			_yoffset = m.y;
			_target.addEventListener(MouseEvent.MOUSE_WHEEL, onScrollWheel);
			_windowHeight = windowHeight;
		}
		
		public function scrollTo(n:Number):void
		{
			n = n > 1 ? 1 : n;
			n = n < 0 ? 0 : n;
			
			var max:Number = _boxHeight - ((_thumbHeight / 2) + _boxWidth);
			var min:Number = (_thumbHeight / 2) + _boxWidth;
			_thumb.y = (n * (max - min)) + min;
			
			calculateScroll();
		}
		
		
		//-----------------------SETTERS--------------------------------
		
		public override function set id(c:int):void
		{
			super.id = c;
		}
		
		public override function set baseColour(c:uint):void
		{
			super.baseColour = c;
			redraw();
		}
		
		public override function set accent(c:uint):void
		{
			super.accent = c;
		}
		
		public override function set textColour(c:uint):void
		{
		}
		
		public function set secondColour(c:uint):void
		{
			super.textColour = c;
			drawArrowButton(_upArrow,_textColour);
			drawArrowButton(_dnArrow, _textColour);
			drawThumb(_textColour);
		}
		
		public override function set boxWidth(n:Number):void
		{
			//super.boxWidth = n;
		}
		
		public override function set boxHeight(n:Number):void
		{
			super.boxHeight = n;
			_thumbHeight =( _boxHeight-(2*_boxWidth))/2;
			redraw();
		}
		
		public override function set label(s:String):void
		{
			super.label = s;
		}
		
		public override function set enable(b:Boolean):void
		{
			super.enable = b;
			
			if (b)
			{
				_thumb.alpha = 1;
				this.alpha = 1;
			}
			else
			{
				_thumb.alpha = 0;
				this.alpha = 0.3;
				scrollTo(0);
			}
			setListeners();
		}
		
		///-------------GETTERS-------------------------
		
		public function get scrollPosition():Number
		{
			return _scrollPos;
		}
		
	}
	
}