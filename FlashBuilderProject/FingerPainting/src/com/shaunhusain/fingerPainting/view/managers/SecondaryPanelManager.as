package com.shaunhusain.fingerPainting.view.managers
{
	import com.eclecticdesignstudio.motion.Actuate;
	import com.eclecticdesignstudio.motion.actuators.GenericActuator;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	/**
	 * Basically a simplified replacement for the Flex PopUpManager.
	 * Handles toggling visibility on panels is itself
	 */
	public class SecondaryPanelManager extends Sprite
	{
		//--------------------------------------------------------------------------------
		//				Variables
		//--------------------------------------------------------------------------------
		private var _lastShown:DisplayObject;
		
		//--------------------------------------------------------------------------------
		//				Constructor
		//--------------------------------------------------------------------------------
		public function SecondaryPanelManager(se:SingletonEnforcer)	{}
		
		//--------------------------------------------------------------------------------
		//				Singleton
		//--------------------------------------------------------------------------------
		private static var instance:SecondaryPanelManager;
		public static function getIntance():SecondaryPanelManager
		{
			if( instance == null ) instance = new SecondaryPanelManager( new SingletonEnforcer() );
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
		//				Public Methods
		//--------------------------------------------------------------------------------
		public function showPanel(displayObject:DisplayObject):void
		{
			if(_currentlyShowing)
				hidePanel();
			
			displayObject.alpha = 0;
			addChild(displayObject);
			displayObject.x = 0;
			displayObject.x = stage.fullScreenWidth-displayObject.width-(FingerPainting.TOOLBAR_OFFSET_FROM_RIGHT_OPEN-FingerPainting.TOOLBAR_OFFSET_FROM_RIGHT)+20;
			displayObject.y = 115;
			_currentlyShowing = displayObject;
			isShowingPanel = true;
			
			Actuate.tween(displayObject, .5, {alpha:1}).autoVisible(false);
		}
		public function hidePanel():void
		{
			if(!currentlyShowing || !isShowingPanel)
				return;
			
			_lastShown = currentlyShowing;
			
			isShowingPanel = false;
			_currentlyShowing = null;
			
			var ge:GenericActuator = Actuate.tween(_lastShown, .5, {alpha:0});
			ge.autoVisible(false);
			ge.onComplete(function():void
			{
				removeChild(_lastShown);
			});
		}
	}
}

internal class SingletonEnforcer {public function SingletonEnforcer(){}}