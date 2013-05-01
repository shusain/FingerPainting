package com.nemenvisual.nicecomps
{
	import flash.display.Stage;
	import com.nemenvisual.nicecomps.events.AddEvent;
	
	/**
	 * ...
	 * @author Ben Foster
	 */
	public class ComponentManager 
	{
		private var comps:Vector.<IComponent>;
		private var _accent:uint = 0x9ADD43;
		
		public function ComponentManager(st:Stage):void
		{
			comps = new Vector.<IComponent>();
			st.addEventListener(AddEvent.COMP_ADDED, onCompAdded);
		}
		
		private function onCompAdded(e:AddEvent):void
		{
			comps.push(e.targetComp);
			e.targetComp.accent = _accent;
		}
		
		public function addComponent(c:IComponent):void
		{
			comps.push(c);
		}
		
		public function set accent(u:uint):void
		{
			_accent = u;
			
			if (comps.length > 0)
			{
				for (var i:int = 0; i < comps.length; i++)
				{
					comps[i].accent = u;
				}
			}
		}
		
		
		
		/*public function set baseColour(u:uint):void
		{
			for (var i:int = 0; i < comps.length; i++)
			{
				comps[i].baseColour = u;
			}
		}
		
		public function set enable(b:Boolean):void
		{
			for (var i:int = 0; i < comps.length; i++)
			{
				comps[i].enable = b;
			}
		}*/
		
	}
	
}