package hatsui.display {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.StageQuality;
	import flash.geom.Rectangle;
	
	
	public class HUI_Render
	{
		/// render quality, a value from StageQuality class 
		static public var RENDER_QUALITY:String = StageQuality.LOW;
		
		/// create a bitmap from display object & auto-rander
		static public function make( target:DisplayObject ):Bitmap
		{
			var r:Rectangle = target.getBounds( target );
			
			var rw:int = Math.round( r.width );
			var rh:int = Math.round( r.height );
			
			var bd:BitmapData = new BitmapData( rw, rh, true, 0 );
			
			render( target, bd );
			
			var b:Bitmap = new Bitmap( bd, "auto", false );
			
			return b;
		}
		
		/// update source with bitmapdata target 
		static public function render( target:DisplayObject, source:BitmapData ):void
		{
			// Exact whole value for pixel postioning 
			target.x = Math.round( target.x );
			target.y = Math.round( target.y );
			
			// clear current display bitmapdata
			source.fillRect( new Rectangle( 0, 0, int( source.width ), int( source.height ) ), 0 );
			
			// draw target 
			source.drawWithQuality( target, null, null, null, null, false, RENDER_QUALITY );
		}
	}
}