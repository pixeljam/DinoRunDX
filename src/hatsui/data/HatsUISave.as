package hatsui.data
{
	import flash.net.SharedObject;
	import flash.utils.Dictionary;
	import flash.utils.setInterval;
	/** @author vladik.voina@gmail.com */
	public class HatsUISave extends Object
	{
		public static var TOKEN:String = "dinorun-hatsui-save";
		
		static private var so:SharedObject;
		static public var data:Object;
		
		/// Initialized shared local object, temp memory data and auto save [ if value is greater then 200ms ]
		public static function init( auto_save_interval:int = 30000 ) :void
		{
			if ( data ) return;
			
			data = new Object();
			so = SharedObject.getLocal( TOKEN );
			
			if( auto_save_interval > 200 ) setInterval( save, auto_save_interval );
		}
		
		/// Flush all data in memory to shared local object
		public static function save():void
		{
			for ( var key:Object in data ) so.data[key] = data[key];
			
			so.flush();
		}
		
		/// On app open load all assigned variables in shared local object to memory
		public static function load():void
		{
			for ( var key:Object in so.data ) data[key] = so.data[key];
		}
		
		public static function readObject( objectName:String, variableName:String ):* 
		{
			if ( data[ objectName ] == null || data[ objectName ] == undefined ) return null;
			
			return data[ objectName ][ variableName ];
		}
		
		public static function writeObject( objectName:String, variableName:String, value:* ):void
		{
			if ( data[ objectName ] == null || data[ objectName ] == undefined ) data[ objectName ] = new Object();
			
			data[ objectName ][ variableName ] = value;
		}
		
		/// Read data [ return ] from shared local object [ variableName ]
		public static function read( variableName:String ):* 
		{
			return data[variableName];
		}
		
		/// Write data [ value ] into shared local object [ variableName ]
		public static function write( variableName:String, value:* ):void
		{
			data[variableName] = value;
		}
		
		/// Attempt to read the variable and return it from shared local object, if null write default value and return it.
		public static function readElseWrite( variableName:String, defaultValue:* ):*
		{
			if ( data[variableName] != null || data[variableName] != undefined ) return data[variableName];
			
			write( variableName, defaultValue );
			
			return defaultValue;
		}
	}

}