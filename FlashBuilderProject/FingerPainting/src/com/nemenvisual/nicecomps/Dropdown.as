package com.nemenvisual.nicecomps
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import com.nemenvisual.nicecomps.IComponent;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.greensock.plugins.*;
	
	/**
	 * ...
	 * @author Ben Foster
	 */
	public class Dropdown extends ComponentBase
	{
		private var _expandButton:Sprite;
		private var _selectBox:Sprite;
		private var _text:TextField;
		private var _labelTxt:TextField;
		private var _prompt:String;
		private var _tf:TextFormat;
		private var _ltf:TextFormat;
		private var _list:List;
		private var _dropdownOpen:Boolean;
		private var _selectedItem:Object;
		private var _selectedIndex:int;
		private var _mouseOver:Boolean;
		private var _noSelection:Boolean;
		private var _timer:Timer;
		private var _ref:String;
		private var _numToDisplay:int;
		private var _portal:Sprite;
		private var _type:String;
		private var _prefix:String;
		
		public function Dropdown(dispatch:Boolean = true):void
		{
			super(dispatch);
			init();
		}
		
		protected override function init():void
		{
			TweenPlugin.activate([AutoAlphaPlugin]);
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			_list 			= new List(false);
			_portal 		= new Sprite();
			_selectBox 		= new Sprite();
			_expandButton 	= new Sprite();
			_text 			= new TextField();
			_labelTxt 		= new TextField();
			_tf				= new TextFormat();
			_ltf 			= new TextFormat();
			_dropdownOpen	= false;
			_noSelection 	= true;
			_timer			= new Timer(200)
			_selectedIndex 	= -1;
			_selectedItem 	= new Object();
			_accent 		= 0xF72B2B;
			_boxWidth 		= 100;
			_boxHeight 		= 30;
			_numToDisplay 	= 5;
			_type			= "normal";
			_prefix			= "";
			_prompt 		= "";
			
			_tf.color 		= 0x7C7C7C;
			_tf.size 		= 14;
			_tf.font 		= "Arial";
			
			_text.text 		= _prompt;
			_text.x 		= 4;
			_text.y 		= 4;
			_text.height 	= 25;
			_text.defaultTextFormat = _tf;
			_text.selectable 		= false;
			_text.mouseEnabled 		= false;
			
			_ltf.color 	= 0xFFFFFF;
			_ltf.size 	= 14;
			_ltf.font 	= "Arial";
			
			_labelTxt.autoSize = TextFieldAutoSize.RIGHT;
			_labelTxt.text 		= "";
			_labelTxt.x 		= -5;
			_labelTxt.y 		= 3;
			_labelTxt.height 	= 25;
			_labelTxt.defaultTextFormat = _ltf;
			_labelTxt.selectable 		= false;
			_labelTxt.mouseEnabled 		= false;
			
			_selectBox.y = 0;
			_expandButton.x = _boxWidth;
			_expandButton.y = 0;
			
			enable = true;
			
			_selectBox.buttonMode = true;
			_selectBox.useHandCursor = false;
			_expandButton.buttonMode = true;
			_expandButton.useHandCursor = false;
			
			_list.visible = false;
			_list.alpha = 0;
			_list.maxToDisplay = 5;
			_list.filters = [new DropShadowFilter(2,90,0x000000,0.5,4,2,1,3)];
			
			
			drawSelectedBox();
			drawExpandButton();
			addChild(_expandButton);
			addChild(_selectBox);
			addChild(_text);
			addChild(_list);
			addChild(_labelTxt);
			
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			
		}
		
		private function onAddedToStage(e:Event):void
		{
			_stage = stage;
			_stage.addEventListener(MouseEvent.CLICK, onStage);
		}
		
		private function onStage(e:MouseEvent):void
		{
			if (e.target == _stage && _dropdownOpen)
			{
				closeDropdown(null);
			}
		}
		
		protected override function redraw():void
		{
			super.redraw();
		}
		
		private function onOpen(e:MouseEvent):void
		{
			e.stopPropagation();
			if (!_dropdownOpen)
			{
				_dropdownOpen = true;
				_list.addEventListener("onSelect", onSelect);
				_list.mouseChildren = true;
				_list.mouseEnabled = true;
				TweenLite.to(_list, 0.2, { autoAlpha:1 } );
			}
			else
			{
				_noSelection = false;
				closeDropdown(null);
			}
		}
		
		private function onOver(e:MouseEvent):void
		{
			_mouseOver = true;
			drawExpandButton();
		}
		
		private function onOut(e:MouseEvent):void
		{
			_mouseOver = false;
			drawExpandButton();
		}
		
		private function closeDropdown(e:MouseEvent):void
		{
			_dropdownOpen = false;
			if (_type == ListItemType.CHECK)
			{
				dispatchEvent(new Event("itemsSelected"));
			}
			_list.removeEventListener("onSelect", onSelect);
			_list.mouseChildren = false;
			_list.mouseEnabled = false;
			TweenLite.to(_list, 0.2, {  autoAlpha:0 } );
		}
		
		private function onSelect(e:Event):void
		{
			_noSelection = false;
			_text.text = _prefix + _list.selectedItem.label;
			_selectedIndex = _list.selectedIndex;
			_selectedItem.label = _list.selectedItem.label;
			_selectedItem.data = _list.selectedItem.data;
			closeDropdown(null);
			if (e != null)
			{
				dispatchEvent(new Event("dropdownSelect"));
			}
			else
			{
				dispatchEvent(new Event("selectedSet"));
			}
		}
		
		
		private function onFocusOut(e:FocusEvent):void
		{
			_timer.start();
		}
		private function onTimer(e:TimerEvent):void
		{
			closeDropdown(null);
			_timer.reset();
		}
		
		private function updatePortal():void
		{
			_portal.graphics.clear();
			_portal.graphics.beginFill(0xFF0000, 1);
			var w:Number = _list.width;
			var h:Number = _list.itemHeight * _numToDisplay;
			_portal.graphics.drawRect(_list.x, _list.y, w, h);
			
			_list.mask = _portal;
		}
		
		private function drawSelectedBox():void
		{
			_selectBox.graphics.clear();
			_selectBox.graphics.beginFill(0xFFFFFF, 1);
			_selectBox.graphics.drawRect(0, 0, _boxWidth, _boxHeight);
			_selectBox.graphics.endFill();
			_selectBox.graphics.lineStyle(1, _accent, 1);
			_selectBox.graphics.moveTo(_boxWidth, 0);
			_selectBox.graphics.lineTo(_boxWidth, _boxHeight);
		}
		
		private function drawExpandButton():void
		{
			_expandButton.graphics.clear();
			_expandButton.graphics.beginFill(0xFFFFFF, 1);
			_expandButton.graphics.drawRect(0, 0, _boxHeight, _boxHeight);
			_expandButton.graphics.endFill();
			if (_mouseOver)
			{
				_expandButton.graphics.beginFill(_accent, 1);
			}
			else
			{
				_expandButton.graphics.beginFill(0x7C7C7C, 1);
			}
			_expandButton.graphics.moveTo(_boxHeight/3, _boxHeight/2.3);
			_expandButton.graphics.lineTo(_boxHeight/3*2, _boxHeight/2.3);
			_expandButton.graphics.lineTo(_boxHeight/2, _boxHeight/1.7);
			_expandButton.graphics.lineTo(_boxHeight/3, _boxHeight/2.3);
		}
		
		/*private function sbDown(e:MouseEvent):void
		{
			if (e.target != _list || e.target != _expandButton || e.target != _selectBox)
			{
				trace("mouse down");
			}
		}*/
		
		private function sbUp(e:MouseEvent):void
		{
			e.stopPropagation();
			removeEventListener(MouseEvent.MOUSE_UP, sbUp);
			enableFocus();
		}
		
		private function disableFocus():void
		{
			this.removeEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
		}
		
		private function enableFocus():void
		{
			this.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
		}
		
		
		//----------------------PUBLIC FUNCTIONS--------------------
		
		public function addItem(o:Object):void
		{
			_list.addItem(o,_type);
			_list.listWidth = _boxWidth;
		}
		
		/*public function addItemAt(o:Object,index:int):void
		{
			_list.addItemAt(o,index);
			_list.listWidth = _boxWidth;
		}*/
		
		public function removeAll():void
		{
			removeChild(_list);
			_dropdownOpen = false;
			_list = new List(false);
			_list.accent = _accent;
			_selectedIndex = -1;
			_selectedItem = new Object();
			_list.visible = false;
			_list.alpha = 0;
			_list.type = _type;
			_list.filters = [new DropShadowFilter(2,90,0x000000,0.5,4,2,1,3)];
			addChild(_list);
		}
		
		public function close():void
		{
			if (_dropdownOpen)
			{
				closeDropdown(null);
			}
		}
		
		public function unSelect():void
		{
			_text.text = _prompt;
			_selectedIndex = -1;
			_selectedItem = new Object();
			
			_list.unSelect();
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
			_list.accent = c;
			drawSelectedBox();
		}
		
		public override function set textColour(c:uint):void
		{
			super.textColour = c;
			_list.textColour = c;
		}
		
		public override function set boxWidth(n:Number):void
		{
			super.boxWidth = n;
			_list.listWidth = n;
			_expandButton.x = _boxWidth;
			_text.width = _boxWidth;
			
			drawSelectedBox();
		}
		
		public override function set boxHeight(n:Number):void
		{
			super.boxHeight = n;
			drawSelectedBox();
			drawExpandButton();
			_labelTxt.y = -2;
			_list.y = _boxHeight;
			_text.y = 0;
		}
		
		public override function set label(s:String):void
		{
			super.label = s;
			_labelTxt.text = _label;
		}
		
		public override function set enable(b:Boolean):void
		{
			if (b)
			{
				_expandButton.addEventListener(MouseEvent.CLICK, onOpen);
				_expandButton.addEventListener(MouseEvent.MOUSE_OVER, onOver);
				_expandButton.addEventListener(MouseEvent.MOUSE_OUT, onOut);
				_selectBox.addEventListener(MouseEvent.CLICK, onOpen);
				_selectBox.addEventListener(MouseEvent.MOUSE_OVER, onOver);
				_selectBox.addEventListener(MouseEvent.MOUSE_OUT, onOut);
				
				_selectBox.buttonMode = true;
				_expandButton.buttonMode = true;
				
				this.alpha = 1;
			}
			else
			{
				_expandButton.removeEventListener(MouseEvent.CLICK, onOpen);
				_expandButton.removeEventListener(MouseEvent.MOUSE_OVER, onOver);
				_expandButton.removeEventListener(MouseEvent.MOUSE_OUT, onOut);
				_selectBox.removeEventListener(MouseEvent.CLICK, onOpen);
				_selectBox.removeEventListener(MouseEvent.MOUSE_OVER, onOver);
				_selectBox.removeEventListener(MouseEvent.MOUSE_OUT, onOut);
				
				_selectBox.buttonMode = false;
				_expandButton.buttonMode = false;
				
				this.alpha = 0.7;
				
				this.removeEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			}
			
			super.enable = b;
		}
		
		public function set prompt(s:String):void
		{
			_prompt = s;
			_text.text = _prompt;
		}
		
		public function set selectedItem(o:Object):void
		{
			_list.selectedItem = o;
			onSelect(null);
		}
		
		public function set selectedIndex(c:int):void
		{
			_list.selectedIndex = c;
			onSelect(null);
		}
		
		public function set selectedPrefix(s:String):void
		{
			_prefix = s;
			_text.text = _prefix + _selectedItem.label;
		}
		
		public function set maxToDisplay(n:int):void
		{
			_numToDisplay = n;
			_list.y = _boxHeight;
			_list.maxToDisplay = n;
		}
		
		public function set type(s:String):void
		{
			_type = s;
			_list.type = s;
		}
		
		//-------------------------GETTERS-------------------------
		
		public function get prompt():String
		{
			return _prompt;
		}
		
		public function get selectedItem():Object
		{
			return _selectedItem;
		}
		
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}
		
		public function get selectedItems():Array
		{
			if (_type == ListItemType.CHECK)
			{
				return _list.selectedItems;
			}
			return [];
		}
		
		public function get selectedIndexes():Array
		{
			if (_type == ListItemType.CHECK)
			{
				return _list.selectedIndexes;
			}
			return [];
		}
		
		public function get text():String
		{
			return _labelTxt.text;
		}
		
		public function get numItems():int
		{
			return _list.listLength;
		}
		
		public function get type():String
		{
			return _type;
		}
		
	}
	
}