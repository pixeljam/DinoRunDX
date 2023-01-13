package base
{
	import flash.display.Stage;
	import flash.display.StageQuality;
	
	import mdm.*;
	
	public class ScreenSettings
	{
		private var _stage:Stage;
		private var _fullScreen:Boolean = false;
		private var _maxed:Boolean = false;
		private var _quality:String = "LOW";
		private var _brain:Brain;
		
		public function ScreenSettings(stage:Stage,brain:Brain)
		{
			_stage = stage;
			_brain = brain;
		}
		
		public function toggleMinMax ():void
		{
			_maxed = !_maxed;
			if (_maxed)
				maximize();
			else
				minimize();
		}
		
		public function minimize ():void
		{
			//mdm.Forms.thisForm.width = Brain.DIMENSIONS.x;
			//mdm.Forms.thisForm.height = Brain.DIMENSIONS.y;
			Brain.left = 0;
			Brain.top = 0;
			//mdm.Application.restore();
			//mdm.Forms.thisForm.hideCaption(false);
		}
		
		public function maximize ():void
		{
			//mdm.Forms.thisForm.width = Brain.MONITOR_W;
			//mdm.Forms.thisForm.height = Brain.MONITOR_H;
			Brain.left = 0 - (Brain.MONITOR_W - Brain.DIMENSIONS.x)/2;
			Brain.top = 0 - (Brain.MONITOR_H - Brain.DIMENSIONS.y)/2;
			//mdm.Forms.thisForm.hideCaption(true);
			//if (!Brain.LINUX)
			//mdm.Application.maximize();
		}
		
		public function toggleFullScreen():void
		{
			_fullScreen = !_fullScreen;
			//mdm.Forms.getFormByName("MainForm").showFullScreen(_fullScreen);
			if (Brain.PC) {
				//mdm.Forms.getFormByName("MainForm").hideCaption(_fullScreen);
				/*if (_fullScreen) {
					_brain.removeMenu();
				} else {
					_brain.buildMenu(null);
				}*/
			}
			toggleMinMax();
		}
		
		public function set quality(value:String):void
		{
			_quality = value;
			switch (value) {
				case "BEST": _stage.quality = StageQuality.BEST; break;
				case "HIGH": _stage.quality = StageQuality.HIGH; break;
				case "MEDIUM": _stage.quality = StageQuality.MEDIUM; break;
				case "LOW": _stage.quality = StageQuality.LOW; break;
			}
		}
		
		public function get quality():String {return _quality;}
		public function get fullScreen():Boolean {return _fullScreen;}
		public function get maxed():Boolean {return _maxed;}
		
	}
}