package com.nemenvisual.nicecomps
{
	
	/**
	 * ...
	 * @author Ben Foster
	 */
	public interface IComponent 
	{
		function set id				(c:int)			:void
		function set baseColour		(c:uint)		:void
		function set accent			(c:uint)		:void
		function set textColour		(c:uint)		:void
		function set boxWidth		(n:Number)		:void
		function set boxHeight		(n:Number)		:void
		function set label			(s:String)		:void
		function set enable			(b:Boolean)		:void
		
		function get id				()				:int
		function get baseColour		()				:uint
		function get accent			()				:uint
		function get textColour		()				:uint
		function get boxWidth		()				:Number
		function get boxHeight		()				:Number
		function get label			()				:String
		function get enable			()				:Boolean
	}
	
}