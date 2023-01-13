package
{
	public class Config
	{
		public function Config()
		{
		}
		
		//false / 0 for launch
		public static var FORCE_NEWS:Boolean				=false;
		public static var SHORT:Boolean						=false;
		public static var MUTE:Boolean						=false;
		public static var GIFT:Boolean						=false;
		public static var AUTO_LOGIN:Boolean				=false;
		public static var FAST:Boolean 						=false;
		public static var SHOW_LOG:Boolean 					=false;
		public static var PARSE_NODES:Boolean 				=false;
		public static var RENDER_GAME_TO_BITMAP:Boolean 	=false;
		public static var SAVE_OVERRIDE:Boolean 			=false;	/////// FALSE! FALSE! FALSE! FALSE! <<<<<<<<<<<<<<<<<<<<<<<<<<<<
		public static var XO:int 							=0;
		public static var YO:int 							=0;
		public static var START_LEVEL:int 					=0;
		
		
		
		//true for launch
		public static var MMOCHA2:Boolean					=true;
		public static var HALLOWEEN:Boolean					=true; // TRUE for non web
		
		//variable
		public static var STEAM_MP:Boolean					=false;
		public static var VERBOSE_MP:Boolean				=false;
		public static var LOG_ERRORS:Boolean				=true; // 
		public static var SHOW_ERRORS:Boolean				=false; //
		public static var WEB:Boolean 						=false;
		public static var VERSION:Number					=1.61;
		public static var UPDATE_ID:int 					=3;
		public static var STEAM:Boolean 					=true; ///  CHECK THIS TOO <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

	}
}