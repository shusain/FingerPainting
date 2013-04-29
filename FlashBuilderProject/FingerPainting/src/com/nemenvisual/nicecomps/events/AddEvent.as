package com.nemenvisual.nicecomps.events
{
	import flash.events.Event;
	import com.nemenvisual.nicecomps.IComponent;

	public class AddEvent extends Event {
		
		public static const COMP_ADDED:String = "compAdded";
		
		public var targetComp:IComponent;
		
		public function AddEvent(type:String, comp:IComponent)
		{
			super(type);
			
			this.targetComp = comp as IComponent;
		}
	}
}