package gfx
{
	import flash.display.MovieClip;
	
	public class DinoClip extends MovieClip
	{
		public var graphic:MovieClip
		
		public function assignGFX (g:MovieClip)
		{
			graphic = g;
			addChild (graphic);
		}
	}
}