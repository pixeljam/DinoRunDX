package hatsui.display {
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	
	public class HUI_Display extends MovieClip
	{
		public function HUI_Display() 
		{
			if ( stage ) connect_stage( null );
			else addEventListener('addedToStage', connect_stage);
		}
		
		protected var bitmap:Bitmap;
		
		private function connect_stage(_:*):void
		{
			bitmap = HUI_Render.make( this );
			
			childrenApply( 'visible', false );
			
			addChild( bitmap );
		}
		
		override public function gotoAndStop(frame:Object, scene:String = null):void 
		{
			super.gotoAndStop(frame, scene);
			
			render();
		}
		
		public function setFrame( target:String = "this", frame:uint = 0 ):void
		{
			if ( target == "this" && ! this[ target ] is MovieClip ) 
			throw new Error("Target " + target + " is not a MovieClip");
				
			var mc:MovieClip = target == "this" ? this : MovieClip( this[ target ] );
			mc.gotoAndStop( frame );
		}
		
		public function render( ):void
		{
			if ( bitmap == null ) return;
			
			childrenApply( 'visible', true );
			bitmap.visible = false;
			
			HUI_Render.render( this, bitmap.bitmapData );
			
			childrenApply( 'visible', false );
			bitmap.visible = true;
		}
		
		protected function childrenApply( property:String, value:* ):void
		{
			var c:DisplayObject;
			
			for (var i:int = 0; i < numChildren; i++) 
			{
				c = getChildAt( i );
				if ( ! c.hasOwnProperty( property ) ) 
				throw new Error("Invalid property " + property);
				
				c[ property ] = value;
			}
		}
		
		protected function fixatePosition( container:DisplayObjectContainer ):void
		{
			var c:DisplayObject;
			
			for (var i:int = 0; i < numChildren; i++) 
			{
				c = getChildAt( i );
				c.x = Math.round( c.x );
				c.y = Math.round( c.y );
				if ( c is DisplayObjectContainer ) 
				fixatePosition( c as DisplayObjectContainer );
			}
		}
	}
}