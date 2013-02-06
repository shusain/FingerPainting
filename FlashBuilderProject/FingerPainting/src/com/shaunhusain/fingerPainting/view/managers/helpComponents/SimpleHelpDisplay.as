package com.shaunhusain.fingerPainting.view.managers.helpComponents
{
	import com.shaunhusain.fingerPainting.view.Box;
	import com.shaunhusain.fingerPainting.view.mobileUIControls.CircleButton;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.Capabilities;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class SimpleHelpDisplay extends Sprite
	{
		private var textField:TextField;
		private var textFormat:TextFormat;
		private var container:Box;
		private var button:CircleButton;
		
		private var _showDismissButton:Boolean=true;

		public function get showDismissButton():Boolean
		{
			return _showDismissButton;
		}

		public function set showDismissButton(value:Boolean):void
		{
			if(_showDismissButton == value)
				return;
			_showDismissButton = value;
			if(value && container)
			{
				container.addChild(button);							
			}
			else if(container)
			{
				container.removeChild(button);
			}
		}

		
		public function SimpleHelpDisplay()
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			
		}
		
		protected function addedToStageHandler(event:Event):void
		{
			if(!container)
			{
				container = new Box();
				container.direction = "horizontal";
				container.x = 50;
				container.y = 10
				addChild(container);
			}
			
			
			if(!textField)
			{
				trace("font size:",36*Capabilities.screenDPI/320);
				textFormat = new TextFormat("myFont", 36*Capabilities.screenDPI/320);
				
				textField = new TextField();
				textField.defaultTextFormat = textFormat;
				textField.autoSize = TextFieldAutoSize.LEFT;
				textField.wordWrap = true;
				textField.text = _helpText;
				textField.width = stage.fullScreenWidth-200;
				
				container.addChild(textField);
				
			}
			
			if(!button)
			{
				button = new CircleButton();
				button.text = "Dismiss";
				button.addEventListener("circleButtonClicked", dismissHelpHandler);
				if(showDismissButton)
					container.addChild(button);
			}
			drawBackground();
		}
		
		protected function dismissHelpHandler(event:Event):void
		{
			dispatchEvent(new Event("dismissCurrentMessages",true));
		}
		
		private var _helpText:String = "";

		public function get helpText():String
		{
			return _helpText;
		}

		public function set helpText(value:String):void
		{
			_helpText = value;
			if(textField)
			{
				textField.text = value;
				drawBackground();
			}
		}

		
		private function drawBackground():void
		{
			graphics.clear();
			graphics.beginFill(0xddddff,1);
			graphics.drawRoundRectComplex(0,0,container.width + 100, container.height+20,0,100,100,0);
			graphics.endFill();
		}
	}
}