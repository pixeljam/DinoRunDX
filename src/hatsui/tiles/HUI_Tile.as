package hatsui.tiles {
	import flash.display.MovieClip;
	
	import hatsui.display.HUI_Display;
	public class HUI_Tile extends MovieClip {
		public function HUI_Tile() {} 
		
		public var value:String = "null";
		public var index:int = -1;
		public var GFX:MovieClip;
		
		public function set favorite( val:Boolean ):void
		{ 
			GFX['star'].visible = val; 
		}
		
		public function get favorite( ):Boolean 
		{ 
			return GFX['star'].visible; 
		}
	}
}