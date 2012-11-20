/**
* GTweener by Joshua Granick. Jan 21, 2009
* Visit code.google.com/p/gtweener for more information.
*
* Copyright (c) 2009 Joshua Granick
* 
* Permission is hereby granted, free of charge, to any person
* obtaining a copy of this software and associated documentation
* files (the "Software"), to deal in the Software without
* restriction, including without limitation the rights to use,
* copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the
* Software is furnished to do so, subject to the following
* conditions:
* 
* The above copyright notice and this permission notice shall be
* included in all copies or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
* OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
* NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
* HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
* OTHER DEALINGS IN THE SOFTWARE.
**/

package com.eclecticdesignstudio.motion {
	
	
	import com.gskinner.motion.GTween;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	
	/**
	 * Manages Grant Skinner's GTween class to provide global-level functionality similar to 
	 * Tweener, and also extends GTween to provide additional properties.
	 * @author Joshua Granick
	 * @version 1.2
	 */
	public class GTweener extends GTween {
		
		
		private static var initialized:Boolean;
		private static var tweens:Dictionary = new Dictionary (true);
		
		public var onComplete:Function;
		public var onCompleteParams:Array;
		public var onStart:Function;
		public var onStartParams:Array;
		public var onUpdate:Function;
		public var onUpdateParams:Array;
		
		
		public function GTweener (target:Object = null, duration:Number = 10, properties:Object = null, tweenProperties:Object = null) {
			
			initialize ();
			
			super (target, duration, properties, tweenProperties);
			
		}
		
		
		/**
		* Constructs a new managed tween instance.
		* @param	target		The object whose properties will be tweened. Defaults to null.
		* @param	duration		The length of the tween in frames or seconds depending on the timingMode. Defaults to 10.
		* @param	properties		An object containing end property values. For example, to tween to x=100, y=100, you could pass {x:100, y:100} as the props object.
		* @param	tweenProperties		An object containing properties to set on this tween. For example, you could pass {ease:myEase} to set the ease property of the new instance. This also provides a shortcut for setting up event listeners. See .setTweenProperties() for more information.
		* @param	overwrite		Determines whether conflicting tweens should be overwritten. Defaults to true.
		* @return		A managed GTweener instance
		**/
		public static function addTween (target:Object, duration:Number = 10, properties:Object = null, tweenProperties:Object = null, overwrite:Boolean = true):GTweener {
			
			var tween:GTweener = new GTweener (target, duration, properties, tweenProperties);
			setTween (tween, properties, overwrite);
			
			return tween;
			
		}
		
		
		private static function getDictionary (target:Object):Dictionary {
			
			if (tweens[target] == null) {
				
				tweens[target] = new Dictionary (true);
				
			}
			
			return tweens[target];
			
		}
		
		
		/**
		 * Get all managed tween objects which match the target and property name
		 * @param	target		The object whose properties are being tweened
		 * @param	propertyName			The property that is being tweened
		 * @return		A managed tween object, an array of managed tween objects or null if no matching tween is found
		 */
		public static function getTween (target:Object, propertyName:String):Object {
			
			var dictionary:Dictionary = getDictionary (target);
			
			if (dictionary != null && dictionary[propertyName] != null) {
				
				return dictionary[propertyName];
				
			}
			
			return null;
			
		}
		
		
		/**
		 * Get a collection of all managed tween objects by target
		 * @param	target		The object whose properties are being tweened
		 * @param	propertyName			The property which is being tweened
		 * @return		A dictionary containing matching tween objects, or null if no matching objects are found
		 */
		public static function getTweens (target:Object):Dictionary {
			
			var dictionary:Dictionary = getDictionary (target);
			
			if (dictionary != null) {
				
				return dictionary;
				
			}
			
			return null;
			
		}
		
		
		private static function initialize ():void {
			
			if (!initialized) {
				
				GTween.defaultEase = Equations.easeOutExpo;
				
				initialized = true;
				
			}
			
		}
		
		
		/**
		 * Pauses all managed tween objects
		 */
		public static function pauseAllTweens ():void {
			
			for (var target:Object in tweens) {
				
				pauseTween (target);
				
			}
			
		}
		
		
		private static function pauseTween (target:Object):void {
			
			var dictionary:Dictionary = getDictionary (target);
			
			for each (var tweenObject:Object in dictionary) {
				
				if (tweenObject is Array) {
					
					for each (var childTweenObject:Object in tweenObject) {
						
						childTweenObject.pause ();
						
					}
					
				} else {
					
					tweenObject.pause ();
					
				}
				
			}
			
		}
		
		
		/**
		 * Pauses any managed tween objects associated with the specified target
		 * @param	... targets		The objects whose properties are being tweened
		 */
		public static function pauseTweens (... targets:Array):void {
			
			for each (var target:Object in targets) {
				
				pauseTween (target);
				
			}
			
		}
		
		
		/**
		 * Allows management of any GTween-compatible object under GTweener
		 * @param	tween		A GTween-compatible object
		 * @param	overwrite		Determines whether conflicting tweens should be overwritten. Defaults to true.
		 */
		public static function registerTween (tween:Object, overwrite:Boolean = true):void {
			
			var properties:Object = tween.getProperties ();
			setTween (tween, properties, overwrite);
			
		}
		
		
		/**
		 * Removes all managed tween objects
		 */
		public static function removeAllTweens ():void {
			
			pauseAllTweens ();
			
			for (var targetName:String in tweens) {
				
				tweens[targetName] = null;
				
			}
			
		}
		
		
		/**
		 * Removes any managed tween objects associated with the specified target
		 * @param	... targets		The objects whose properties are being tweened
		 */
		public static function removeTweens (... targets:Array):void {
			
			pauseTweens.apply (null, targets);
			
			for each (var target:Object in targets) {
				
				tweens[target] = null;
				
			}
			
		}
		
		
		/**
		 * Resumes any managed tween objects associated with the specified target
		 * @param	... targets		The objects whose properties are being tweened
		 */
		public static function resumeTweens (... targets:Array):void {
			
			for each (var target:Object in targets) {
				
				var dictionary:Dictionary = getDictionary (target);
				
				if (dictionary != null) {
					
					for each (var tweenObject:Object in dictionary) {
						
						if (tweenObject is Array) {
							
							for each (var childTweenObject:Object in tweenObject) {
								
								childTweenObject.play ();
								
							}
							
						} else {
							
							tweenObject.play ();
							
						}
						
					}
					
				}
				
			}
			
		}
		
		
		/**
		 * Applies the values of one object to another. Conflicting tweens are automatically removed. 
		 * @param	target		The object to copy properties to
		 * @param	properties		The object to copy properties from
		 */
		public static function setProperties (target:Object, properties:Object):void {
			
			var dictionary:Dictionary = getDictionary (target);
			
			for (var propertyName:String in properties) {
				
				var tweenObject:Object = dictionary[propertyName];
				
				if (tweenObject != null) {
					
					if (tweenObject is Array) {
						
						for each (var childTweenObject:Object in tweenObject) {
							
							childTweenObject.deleteProperty (propertyName);
							
						}
						
					} else {
						
						tweenObject.deleteProperty (propertyName);
						
					}
					
				}
				
				target[propertyName] = properties[propertyName];
				
			}
			
		}
		
		
		/**
		 * Creates a tween timer, enabling use of properties like delay or complete handlers without tweening a value.
		 * @param	duration		The length of the timer in frames or seconds depending on the timingMode. Defaults to 10.
		 * @param	properties		An object containing properties to set on this tween.
		 * @return		A GTweener-based timer
		 */
		public static function setTimer (duration:Number = 10, properties:Object = null):GTweener {
			
			var timer:Object = { progress: 0 };
			var tween:GTweener = new GTweener (timer, duration, { progress: 1 }, properties);
			
			return tween;
			
		}
		
		
		private static function setTween (tween:Object, properties:Object, overwrite:Boolean):void {
			
			initialize ();
			
			for (var propertyName:String in properties) {
				
				var dictionary:Dictionary = getDictionary (tween.target);
				var tweenObject:Object = dictionary[propertyName];
				
				if (overwrite || tweenObject == null) {
					
					if (tweenObject != null) {
						
						if (tweenObject is Array) {
							
							for each (var childTweenObject:Object in tweenObject) {
								
								childTweenObject.deleteProperty (propertyName);
								
							}
							
						} else {
							
							tweenObject.deleteProperty (propertyName);
							
						}
						
					}
					
					dictionary[propertyName] = tween;
					
				} else {
					
					if (tweenObject is Array) {
						
						tweenObject.push (tween);
						
					} else {
						
						var array:Array = [ dictionary[propertyName], tween ];
						dictionary[propertyName] = array;
						
					}
					
				}
				
			}
			
		}
		
		
		private function initialize ():void {
			
			onCompleteParams = new Array ();
			onStartParams = new Array ();
			onUpdateParams = new Array ();
			
		}
		
		
		public override function setTweenProperties (properties:Object):void {
			
			if (properties == null) { return; }
			
			if ("onComplete" in properties) { addEventListener (Event.COMPLETE, this_onComplete); }
			if ("onStart" in properties) { addEventListener (Event.INIT, this_onInit); }
			if ("onUpdate" in properties) { addEventListener (Event.CHANGE, this_onChange); }
			
			if ("transition" in properties) { 
				
				if (properties.transition is String) {
					
					this.ease = Equations[properties.transition];
					
				} else {
					
					this.ease = properties.transition;
					
				}
				
				delete properties.transition;
				
			}
			
			if ("rounded" in properties) { 
				
				this.snapping = properties.rounded;
				delete properties.rounded;
				
			}
			
			super.setTweenProperties (properties);
			
		}
		
		
		
		
		// Event Handlers
		
		
		
		
		private function this_onChange (event:Event):void {
			
			onUpdate.apply (null, onUpdateParams);
			
		}
		
		
		private function this_onComplete (event:Event):void {
			
			onComplete.apply (null, onCompleteParams);
			
		}
		
		
		private function this_onInit (event:Event):void {
			
			onStart.apply (null, onStartParams);
			
		}
		
		
	}
	
	
}