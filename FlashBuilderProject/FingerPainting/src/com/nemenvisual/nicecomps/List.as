package com.nemenvisual.nicecomps
{
	import flash.display.Sprite;
	import flash.events.Event;
	import com.nemenvisual.nicecomps.IComponent;
	
	/**
	 * ...
	 * @author Ben Foster
	 */
	public class List extends ComponentBase
	{
		private var _selectedIndex:int;
		private var _selectedItem:Object;
		private var _allItems:Array;
		private var _container:Sprite;
		private var _yPos:int;
		private var _listLength:int = 0;
		private var _listWidth:Number = 100;
		private var _itemheight:Number;
		private var _maxToDisplay:Number = 5;
		private var _scroller:DisplayScroller;
		private var _portal:Sprite;
		private var _type:String;
		
		public function List(dispatch:Boolean = true):void
		{
			super(dispatch);
			init();
		}
		
		protected override function init():void
		{
			_type = ListItemType.NORMAL;
			_selectedItem = new Object();
			_allItems = new Array();
			_container = new Sprite();
			
			_scroller = new DisplayScroller(false);
			_scroller.accent = 0x9ADD43;
			_scroller.baseColour = 0xFFFFFF;
			_scroller.secondColour = 0x999999;
			_scroller.x = _listWidth-10;
			_scroller.y = 0;
			
			_portal = new Sprite();
			
			_yPos = 0;
			_itemheight = 0;
			
			addChild(_container);
			addChild(_portal);
			addChild(_scroller);
			
			hideScrollBar();
		}
		
		protected override function redraw():void
		{
			super.redraw();
			graphics.clear();
			graphics.beginFill(0xFFFFFF, 1);
			
			if (_listLength < _maxToDisplay)
			{
				graphics.drawRect(0, 0, _listWidth, _itemheight * _listLength);
			}
			else
			{
				graphics.drawRect(0, 0, _listWidth, _itemheight * _maxToDisplay);
			}
			graphics.endFill();
		}
		
		public function addItem(o:Object, _type:String):void
		{
			var li:*;
			
			switch (_type)
			{
				case ListItemType.NORMAL :
					li = new ListItem(false);
					li.accent = _accent;
					li.label = o.label;
					li.data = o.data;
					li.index = _listLength;
					li.overColour = _accent;
					li.boxWidth = _listWidth;
					li.y = _yPos;
					li.addEventListener("itemSelected", onSelect);
				break;
				case ListItemType.SWATCH :
					li = new SwatchListItem(false);
					li.accent = _accent;
					li.label = o.label;
					li.data = o.data;
					li.colour = o.colour;
					li.index = _listLength;
					li.overColour = _accent;
					li.boxWidth = _listWidth;
					li.y = _yPos;
					li.addEventListener("itemSelected", onSelect);
				break;
				case ListItemType.CHECK :
					li = new CheckListItem(false);
					li.accent = _accent;
					li.label = o.label;
					li.data = o.data;
					li.index = _listLength;
					li.overColour = _accent;
					li.boxWidth = _listWidth;
					li.y = _yPos;
				break;
			}
			
			
			_itemheight = li.height;
			
			
			
			_allItems.push(li);
			
			_container.addChild(li);
			_listLength++;
			_yPos += li.height;
			
			if (_listLength > _maxToDisplay)
			{
				showScrollBar();
			}
			else
			{
				hideScrollBar();
			}
			
			redraw();
		}
		
		/*public function addItemAt(o:Object,index:int):void
		{
			var li:ListItem = new ListItem();
			li.label = o.label;
			li.data = o.data;
			li.index = _listLength;
			li.overColour = _accent;
			li.boxWidth = _listWidth;
			li.y = _yPos;
			
			_itemheight = li.height;
			
			li.addEventListener("itemSelected", onSelect);
			
			_allItems.push(li);
			
			_container.addChild(li);
			_listLength++;
			_yPos += li.height;
			
			if (_listLength > _maxToDisplay)
			{
				showScrollBar();
			}
			else
			{
				hideScrollBar();
			}
			
			redraw();
		}*/
		
		private function showScrollBar():void
		{
			_scroller.x = _listWidth-11;
			_scroller.boxHeight = _itemheight * _maxToDisplay;
			_scroller.setTarget(_container, _itemheight * _maxToDisplay);
			_scroller.visible = true;
			_scroller.enable = true;
			
			_portal.graphics.clear();
			_portal.graphics.beginFill(0xFF0000, 1);
			_portal.graphics.drawRect(0, 0, _listWidth, _itemheight * _maxToDisplay);
			_portal.graphics.endFill();
			_portal.visible = true;
			
			_container.mask = _portal;
		}
		
		private function hideScrollBar():void
		{
			_scroller.visible = false;
			_scroller.enable = false;
			
			_container.mask = null;
			_portal.visible = false;
		}
		
		private function onSelect(e:Event):void
		{
			if (e != null)
			{
				_selectedItem.label = e.target.label;
				_selectedItem.data = e.target.data;
				_selectedIndex = e.target.index;
				
				for (var i:int = 0; i < _listLength; i++)
				{
					if (i != e.target.index)
					{
						_allItems[i].selected = false;
					}
					else
					{
						_allItems[i].selected = true;
					}
				}
			}
			else
			{
				_selectedItem.label = _allItems[_selectedIndex].label;
				_selectedItem.data = _allItems[_selectedIndex].data;
				
				for (var j:int = 0; j < _listLength; j++)
				{
					if (j != _selectedIndex)
					{
						_allItems[j].selected = false;
					}
					else
					{
						_allItems[j].selected = true;
					}
				}
				
			}
			
			
			dispatchEvent(new Event("onSelect",true));
		}
		
		public function unSelect():void
		{
			_selectedIndex = -1;
			_selectedItem = new Object();
			
			for (var i:int = 0; i < _allItems.length; i++)
			{
				_allItems[i].selected = false;
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
			
			_scroller.accent = c;
			
			for (var i:int = 0; i < _allItems.length; i++)
			{
				_allItems[i].accent = c;
				if (_allItems[i].selected == true)
				{
					_allItems[i].selected = true;
				}
			}
		}
		
		public override function set textColour(c:uint):void
		{
			super.textColour = c;
			for (var i:int = 0; i < _allItems.length; i++)
			{
				_allItems[i].textColour = c;
				if (_allItems[i].selected == false)
				{
					_allItems[i].selected = false;
				}
			}
		}
		
		public override function set boxWidth(n:Number):void
		{
			super.boxWidth = n;
		}
		
		public override function set boxHeight(n:Number):void
		{
			super.boxHeight = n;
		}
		
		public override function set label(s:String):void
		{
			super.label = s;
		}
		
		public override function set enable(b:Boolean):void
		{
			super.enable = b;
		}
		
		public function set selectedIndex(i:int):void
		{
			_selectedIndex = i;
			onSelect(null);
		}
		
		public function set selectedItem(o:Object):void
		{
			for (var i:int = 0; i < _allItems.length; i++)
			{
				if (_allItems[i].data == o.data)
				{
					_selectedIndex = i;
					break;
				}
			}
			onSelect(null);
		}
		
		public function set listWidth(n:Number):void
		{
			for (var i:int = 0; i < _listLength; i++)
			{
				_allItems[i].boxWidth = n;
				
			}
			_listWidth = n;
			redraw();
		}
		
		public function set maxToDisplay(n:int):void
		{
			_maxToDisplay = n;
			if (_listLength > _maxToDisplay)
			{
				showScrollBar();
			}
			else
			{
				hideScrollBar();
				redraw();
				for (var i:int = 0; i < _listLength; i++)
				{
					_allItems[i].boxWidth = _listWidth;
				}
			}
		}
		
		public function set type(t:String):void
		{
			if (t != _type)
			{
				for (var i:int = 0; i < _allItems.length; i++)
				{
					removeChild(_allItems[i]);
				}
				_type = t;
			}
		}
		
		//---------------------------GETTERS-----------------------------
		
		public function get listLength():int
		{
			return _listLength;
		}
		
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}
		
		public function get selectedItem():Object
		{
			var si:Object = { label:_selectedItem.label, data:_selectedItem.data };
			return si;
		}
		
		public function get selectedIndexes():Array
		{
			if (_type == ListItemType.CHECK)
			{
				var arr:Array = [];
				
				for (var i:int = 0; i < _listLength; i++)
				{
					if (_allItems[i].selected == true)
					{
						arr.push(i);
					}
				}
				return arr;
			}
			return [];
		}
		
		public function get selectedItems():Array
		{
			if (_type == ListItemType.CHECK)
			{
				var arr:Array = [];
				
				for (var i:int = 0; i < _listLength; i++)
				{
					if (_allItems[i].selected == true)
					{
						arr.push( { label:_allItems[i].label, data:_allItems[i].data } );
					}
				}
				return arr;
			}
			return [];
		}
		
		public function get itemHeight():Number
		{
			return _itemheight;
		}
		
		public function get scrollBar():DisplayScroller
		{
			return _scroller;
		}
		
		public function get maxToDisplay():int
		{
			return _maxToDisplay;
		}
	}
	
}