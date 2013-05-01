package com.shaunhusain.fingerPainting.view.managers
{
	import com.eclecticdesignstudio.motion.Actuate;
	import com.eclecticdesignstudio.motion.actuators.GenericActuator;
	import com.shaunhusain.fingerPainting.model.QueuedMessage;
	import com.shaunhusain.fingerPainting.view.managers.helpComponents.SimpleHelpDisplay;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	public class HelpManager extends Sprite
	{
		private const extraDelay:Number = 0;
		//--------------------------------------------------------------------------------
		//				Variables
		//--------------------------------------------------------------------------------
		private var _lastShown:DisplayObject;
		private var queueOfMessages:Array;
		private var displayMessageTimer:Timer;
		private var currentMessage:QueuedMessage;
		private var lastMessageShownTime:Number;
		private var shd:SimpleHelpDisplay;
		
		//--------------------------------------------------------------------------------
		//				Constructor
		//--------------------------------------------------------------------------------
		public function HelpManager(se:SingletonEnforcer)
		{
			shd = new SimpleHelpDisplay();
			queueOfMessages = [];
			displayMessageTimer = new Timer(100);
			displayMessageTimer.addEventListener(TimerEvent.TIMER, displayMessageTimerHandler);
			displayMessageTimer.start();
			
			addEventListener("dismissCurrentMessages", dismissHelpHandler);
		}
		
		//--------------------------------------------------------------------------------
		//				Singleton
		//--------------------------------------------------------------------------------
		private static var instance:HelpManager;
		public static function getIntance():HelpManager
		{
			if( instance == null ) instance = new HelpManager( new SingletonEnforcer() );
			return instance;
		}
		//--------------------------------------------------------------------------------
		//				Properties
		//--------------------------------------------------------------------------------
		private var _isShowingPanel:Boolean;
		public function get isShowingPanel():Boolean
		{
			return _isShowingPanel;
		}
		public function set isShowingPanel(value:Boolean):void
		{
			_isShowingPanel = value;
		}
		private var _currentlyShowing:DisplayObject;
		public function get currentlyShowing():DisplayObject
		{
			return _currentlyShowing;
		}
		
		//--------------------------------------------------------------------------------
		//				Handlers
		//--------------------------------------------------------------------------------
		protected function displayMessageTimerHandler(event:TimerEvent):void
		{
			if(!isNaN(lastMessageShownTime) && getTimer()-lastMessageShownTime<currentMessage.duration)
			{
				return;
			}
			hidePanel();
			if(!isNaN(lastMessageShownTime) && getTimer()-lastMessageShownTime<currentMessage.duration+extraDelay)
			{
				return;
			}
			if(queueOfMessages.length>0)
			{
				currentMessage = queueOfMessages.shift();
				
				if(currentMessage.displayObject)
					showPanel(currentMessage.displayObject);
				else
				{
					shd.showDismissButton = currentMessage.showDismiss;
					shd.helpText = currentMessage.displayText;
					showPanel(shd);
				}
				lastMessageShownTime = getTimer();
			}
		}
		
		
		protected function dismissHelpHandler(event:Event):void
		{
			dismissCurrentAndClearQueue();
			event.stopImmediatePropagation();
		}
		//--------------------------------------------------------------------------------
		//				Public methods
		//--------------------------------------------------------------------------------
		public function showMessage(message:Object, duration:Number=NaN, showDismiss:Boolean = true):void
		{
			if(message is DisplayObject)
				queueOfMessages.push(new QueuedMessage(duration, null, message as DisplayObject));
			else if(message is String)
			{
				queueOfMessages.push(new QueuedMessage(duration, message as String, null, showDismiss));
			}
			else if(message is Array)
			{
				for each(var queuedMessage:QueuedMessage in message)
				{
					queuedMessage.displayObject = new SimpleHelpDisplay();
					(queuedMessage.displayObject as SimpleHelpDisplay).helpText = queuedMessage.displayText;
				}
				queueOfMessages = queueOfMessages.concat(message);
			}
			else
			{
				throw new Error("showMessage expects a DisplayObject, String, or Array of QueuedMessage objects");
			}
		}
		public function dismissCurrentAndClearQueue():void
		{
			hidePanel();
			queueOfMessages = [];
		}
		
		//--------------------------------------------------------------------------------
		//				Helper functions
		//--------------------------------------------------------------------------------
		private function showPanel(displayObject:DisplayObject):void
		{
			if(_currentlyShowing)
				hidePanel();
			
			addChild(displayObject);
			_currentlyShowing = displayObject;
			
			displayObject.x = stage.fullScreenWidth/2-displayObject.width/2;
			displayObject.y = stage.fullScreenHeight;
			
			isShowingPanel = true;
			
			Actuate.tween(displayObject, .5, {y:stage.fullScreenHeight-displayObject.height-20});
		}
		private function hidePanel():void
		{
			if(!currentlyShowing || !isShowingPanel)
				return;
			
			_lastShown = currentlyShowing;
			
			isShowingPanel = false;
			_currentlyShowing = null;
			
			var ge:GenericActuator = Actuate.tween(_lastShown, .5, {y:stage.fullScreenHeight});
			ge.onComplete(function():void
			{
				if(_lastShown && _lastShown.parent == this)
					removeChild(_lastShown);
			});
		}
	}
}
internal class SingletonEnforcer {public function SingletonEnforcer(){}}