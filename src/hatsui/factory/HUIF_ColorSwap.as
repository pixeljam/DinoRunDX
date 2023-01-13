package hatsui.factory 
{
	import hatsui.view.HUI_View;
	/**
	 * ...
	 * @author www.wad1m.com, twitter:@_wad1m
	 */
	public class HUIF_ColorSwap 
	{
		/// onUpdate ( new_color : uint ) : void
		static public function connect( view:HUI_View, onUpdate:Function = null ):void
		{
			view.mcClick( 'color_swap', function():void
			{
				var mouse_X:Number = view.mc('color_swap').mouseX;
					
				var color:uint = COLORS[ 0 ];
				if ( mouse_X < 19 ) color = COLORS[ 1 ];
				else if ( mouse_X < 38 ) color = COLORS[ 2 ];
				else if ( mouse_X < 57 ) color = COLORS[ 3 ];
				
				onUpdate( color );
			});
		}
		
		static public const COLORS:Array = [ 
			0x151515 // left most color [ 21,21,21 ]
			,0xA3E6FD // 2nd color [ 163, 230, 253 ]
			,0xDCD8D0 // 3rd color [ 220, 216, 208 ]
			,0xFFFFFF // right most color [ 255,255,255 ]
		];
	}

}