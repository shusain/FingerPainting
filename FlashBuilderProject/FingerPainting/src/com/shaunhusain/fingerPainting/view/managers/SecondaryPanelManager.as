package com.shaunhusain.fingerPainting.view.managers
{
	import com.eclecticdesignstudio.motion.Actuate;
	import com.eclecticdesignstudio.motion.actuators.GenericActuator;
	import com.shaunhusain.fingerPainting.model.PaintModel;
	
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
		private var model:PaintModel = PaintModel.getInstance();
		
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
			
			addChild(displayObject);
			
			trace("Secondary panel width" + displayObject.width);
			
			displayObject.x = stage.fullScreenWidth-displayObject.width-(FingerPainting.TOOLBAR_OFFSET_FROM_RIGHT*model.dpiScale-FingerPainting.TOOLBAR_OFFSET_FROM_RIGHT_OPEN*model.dpiScale);
			
			trace("diplayObject.x",displayObject.x)
			displayObject.y = FingerPainting.TOOLBAR_OFFSET_FROM_TOP*model.dpiScale;
			_currentlyShowing = displayObject;
			isShowingPanel = true;
			
			//Actuate.tween(displayObject, .5, {alpha:1}).autoVisible(false);
		}
		public function hidePanel():void
		{
			if(!currentlyShowing || !isShowingPanel)
				return;
			
			_lastShown = currentlyShowing;
			
			isShowingPanel = false;
			_currentlyShowing = null;
			
			/*var ge:GenericActuator = Actuate.tween(_lastShown, .5, {alpha:0});
			ge.autoVisible(false);
			ge.onComplete(function():void
			{
				removeChild(_lastShown);
			});*/
			removeChild(_lastShown);
		}
	}
}

internal class SingletonEnforcer {public function SingletonEnforcer(){}}