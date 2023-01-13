package util {
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.GameInputEvent;
	import flash.ui.GameInput;
	import flash.ui.GameInputControl;
	import flash.ui.GameInputDevice;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	
	import base.Brain;
		
	public final class Controller {
		
		private var gameInput:GameInput;
		private var device:GameInputDevice;
		private var controls:Object = new Object();
		
		public static var instance:Controller;
		
		public static var connected:Boolean = false;
		
		[Embed(source="DeviceData.txt",mimeType="application/octet-stream")]
		private var deviceData:Class;
		private var devices:Object;
		private var currentDevice:Object;
		
		//keys.addKeys ({exe:dino,vals:{D:[40,83],L:[37,65],R:[39,68],J:[38,87],S:[16],1:[49],2:[50],3:[51]},exeD:true,exeU:true});//J:38,

		private var keyMap:Object = {
			DPAD_LEFT : [37],
			DPAD_RIGHT : [39],
			DPAD_UP : [10], // not used
			DPAD_DOWN : [40],
			START : [32], // space
			SELECT : [13], // return
			RIGHT : [40],//JUMP
			DOWN : [38],//DOWN (40) or JUMP (38) ???
			LEFT : [38],//JUMP
			UP : [38],//JUMP
			LEFT_STICK_HORIZ : [],
			LEFT_STICK_VERT : [],
			RIGHT_STICK_HORIZ : [],
			RIGHT_STICK_VERT : [],
			BUMPER_LEFT:[49],
			BUMPER_RIGHT:[50],
			TRIGGER_LEFT:[16],
			TRIGGER_RIGHT:[51]
			
		};
		
		private var defaultMode:Boolean = false;
		
		private var brain:Brain;
		
		public static function init(stage:Stage,br:Brain):void
		{
			instance = new Controller(stage,br);
		}
		
		public function Controller(stage:Stage,br:Brain):void
		{
			brain = br;
			
			gameInput = new GameInput();
			gameInput.addEventListener(GameInputEvent.DEVICE_ADDED, handleDeviceAttached);
			gameInput.addEventListener(GameInputEvent.DEVICE_REMOVED, handleDeviceRemoved);
			
			//parse data
			devices = {};
			var txt:String = String(new deviceData() as ByteArray);
			
			var lines:Array = txt.split("\n");
			lines.shift(); // dont need casual names
			var firstLine:String = lines[0];
			var deviceNames:Array = firstLine.split(",");
			deviceNames.shift();
			lines.shift();
			var i:int;
			for (i = 0; i < deviceNames.length; i++) {
				var name:String = deviceNames[i];
				devices[name] = {};
				for (var j:int = 0; j < lines.length; j++) {
					var line:String = lines[j];
					var lineItems:Array = line.split(",");
					devices[name][lineItems[i+1]] = lineItems[0];
				}
			}
			
			
		}
		
		protected function handleDeviceRemoved(event:GameInputEvent):void
		{
			trace("Device is removed");
			Controller.connected = false;
			/*var TIT:TITLE = UI._getInstance().getUIByClass(TITLE) as TITLE;
			if (TIT)
				TIT.controllerRemoved();
			var GO:GAMEOVER = UI._getInstance().getUIByClass(GAMEOVER) as GAMEOVER;
			if (GO)
				GO.controllerRemoved();*/
		}
		
		protected function handleDeviceAttached(e:GameInputEvent):void
		{
			trace("Device is added");
			
			for(var k:Number=0;k<GameInput.numDevices;k++){
				device = GameInput.getDeviceAt(k);
				device.enabled = true;
				trace (device.name);
				trace (device.id);
				
				for (var i:Number = 0; i < device.numControls; i++) {
					var control:GameInputControl = device.getControlAt(i);
					control.addEventListener(Event.CHANGE,onChange);
					//controls[control.id] = 0;
				}
				
				Controller.connected = true;
				/*var TIT:TITLE = UI._getInstance().getUIByClass(TITLE) as TITLE;
				if (TIT)
					TIT.controllerConnected();
				var GO:GAMEOVER = UI._getInstance().getUIByClass(GAMEOVER) as GAMEOVER;
				if (GO)
					GO.controllerConnected();*/
				
			}
			
			var name:String = device.name;
			
			//override for XINPUT DEVICE
			if (device.id.indexOf("XINPUT")!=-1) {
				trace ("X INPUT DETECTED");
				name = "XINPUT";
			}
			
			//override for james's weird logitech dual action
			if (device.id == "1133_49686_0") {
				name = "Logitech2";
			}
			
			currentDevice = devices[name];
			if (!currentDevice) {
				defaultMode = true;
			}
		}	
		
		private const DEADZONE:Number = .3;
		private var activeAxis:String = "";
		
		protected function onChange(event:Event):void
		{
			
			var control:GameInputControl = event.target as GameInputControl;
			
			var id:String;
			var val:Number = control.value;

			if (defaultMode) {
				id = control.id;
				if (id == "AXIS_0" || id == "AXIS_2") {
					if (val < -DEADZONE) {
						brain.keys.keyDFunc(Keyboard.LEFT);
					} else if (controls[id] < -DEADZONE) {
						brain.keys.keyUFunc(Keyboard.LEFT);
					}
					if (val > DEADZONE) {
						brain.keys.keyDFunc(Keyboard.RIGHT);
					} else if (controls[id] > DEADZONE) {
						brain.keys.keyUFunc(Keyboard.RIGHT);
					}
				}
				if (id == "AXIS_1" || id == "AXIS_3") {
					if (val < -DEADZONE) {
						brain.keys.keyDFunc(Keyboard.UP);
					} else if (controls[id] < -DEADZONE) {
						brain.keys.keyUFunc(Keyboard.UP);
					}
					if (val > DEADZONE) {
						brain.keys.keyDFunc(Keyboard.DOWN);
					} else if (controls[id] > DEADZONE) {
						brain.keys.keyUFunc(Keyboard.DOWN);
					}
				}
				if ((id.indexOf("BUTTON") > -1) && val == 1) {
					brain.keys.keyDFunc(38);//jump
				}
				if ((id.indexOf("BUTTON") > -1) && val == 0) {
					brain.keys.keyUFunc(38);
				}
				controls[id] = val;
				return;
			}
			
			id = currentDevice[control.id];
			//trace("The pressed control is " +control.id+" with value "+control.value);
			//trace (currentDevice[control.id],control.value);
			var keyCodes:Array = keyMap[id];
			//trace (id);
			if (keyCodes) {
				if (id == "LEFT_STICK_HORIZ" || id == "RIGHT_STICK_HORIZ") {
					if (val < -DEADZONE) {
						brain.keys.keyDFunc(Keyboard.LEFT);
					} else if (controls[id] < -DEADZONE) {
						brain.keys.keyUFunc(Keyboard.LEFT);
					}
					if (val > DEADZONE) {
						brain.keys.keyDFunc(Keyboard.RIGHT);
					} else if (controls[id] > DEADZONE) {
						brain.keys.keyUFunc(Keyboard.RIGHT);
					}					
				} else if (id == "LEFT_STICK_VERT" || id == "RIGHT_STICK_VERT") {
					if (val < -DEADZONE) {
						brain.keys.keyDFunc(Keyboard.UP);
					} else if (controls[id] < -DEADZONE) {
						brain.keys.keyUFunc(Keyboard.UP);
					}
					if (val > DEADZONE) {
						brain.keys.keyDFunc(Keyboard.DOWN);
					} else if (controls[id] > DEADZONE) {
						brain.keys.keyUFunc(Keyboard.DOWN);
					}					
				} else if (val == 1) {
					for (var i:int = 0; i < keyCodes.length; i++) {
						var code:int = keyCodes[i];
						brain.keys.keyDFunc(code);
					}
				} else if (val == 0) {
					for (var i:int = 0; i < keyCodes.length; i++) {
						var code:int = keyCodes[i];
						brain.keys.keyUFunc(code);
					}
				}
				controls[id] = val;
			}
			
		}
		
		public static function _getInstance():Controller
		{
			return instance;
		}
		
		public function reset():void
		{
			for (var id:String in controls) {
				controls[id] = 0;
			}
		}
		
	}
	
}