package hatsui.view
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.PixelSnapping;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import gfx.HatUI;
	
	import hatsui.data.HatsUIMatrix;
	import hatsui.movieclip.HUI_Background;
	import hatsui.tiles.HUIT_Background;
	
	import model.GameModel;
	
	import util.ImageSaverUtil;
	
	import utils.ImageSaverUtil;
	
	public class HUIV_Portrait extends HUI_View
	{
		private var background_matrix:HatsUIMatrix;
		private var previewBMP:Bitmap;
		private var previewBMPD:BitmapData;
		public function HUIV_Portrait() { }
		
		override public function initialize(parent:DisplayObjectContainer = null,interF=null,h="",clr=""):Boolean 
		{
			GFX = new _HUIV_Portrait();
			
			if ( ! super.initialize(parent,interF,h,clr) ) return false;
			
			// self reference
			var main:MovieClip = this;
			
			//new shit
			GFX.final.visible = false;
			GFX.final.tryAgain.gotoAndStop( 3 )
			GFX.final.save.gotoAndStop( 4 )
				
			mcClick(GFX.final.tryAgain, function():void {
				GFX.final.visible = false;
				GFX.removeChild(previewBMP);
			},true);
				
			mcClick(GFX.final.save, function():void {
				ImageSaverUtil.saveAsPNG(previewBMPD);
				GFX.final.visible = false;
				GFX.removeChild(previewBMP);
			},true);
			
			
			// --------------------------------------------------------------
			// **** 
			/// \Save \Picture
			// **** 
			// --------------------------------------------------------------
			
			mcClick('snap', function():void {
				
				// position relative to view container 
				var mc_raptor_and_hat:MovieClip = GFX.dino;
				
				// position relative to view container 
				var mc_background:MovieClip = mc('preview_background');
				var mc_foreground:MovieClip = mc('preview_foreground');
				
				/// TODO: #export picture script
				trace("TODO: complete save picture function");
				
				previewBMPD= new BitmapData(90,90);
				previewBMPD.draw(mc_background);
				var m:Matrix = new Matrix();
				m.translate(42, 51);
				previewBMPD.draw(mc_raptor_and_hat,m);
				previewBMPD.draw(mc_foreground);
				
				previewBMP = new Bitmap(previewBMPD);
				previewBMP.x = mc_background.x;
				previewBMP.y = mc_background.y;
				previewBMP.scaleX = previewBMP.scaleY = 1.666666666;
				GFX.addChild(previewBMP);
				
				GFX.final.visible = true;
				
			});
			
			// --------------------------------------------------------------
			// **** 
			/// \Preview
			// **** 
			// --------------------------------------------------------------
			
			var background_selected:String = "1";
			
			var preview_dino:MovieClip = mc('preview_dino');
			
			preview_dino.mouseEnabled = false;
			preview_dino.mouseChildren = false;
			
			var preview_back:MovieClip = mc("preview_back");
			var preview_forward:MovieClip = mc("preview_forward");
			
			//var preview_bitmap:Bitmap = new Bitmap( new BitmapData( 180, 180, false, 0 ), PixelSnapping.ALWAYS, false );
			//addChildAt( preview_bitmap, getChildIndex( preview_dino ) - 1 );
			//preview_bitmap.x = mc('preview_background').x;
			//preview_bitmap.y = mc('preview_background').y;
			//mc('preview_background').visible = false;
			//function preview_draw():void
			//{
				//var bg:MovieClip = new HatsUI_BG();
				//bg.gotoAndStop( parseInt( background_selected ) );
				//var matrix:Matrix = new Matrix();
				//matrix.scale(2, 2);
				//preview_bitmap.bitmapData.fillRect( new Rectangle(0, 0, 180, 180), 0 );
				//preview_bitmap.bitmapData.drawWithQuality(bg, matrix, null, null, null, false, 'low');
			//}
			
			function preview_update( ):void
			{
				mcRaptor( preview_dino, data.dColors[ raptor ] );
				
				mcHat( preview_dino['hat'] as MovieClip, hat ); 
				
				updateDino(raptor,hat);
				
				//preview_draw();
				
				mc('preview_background').gotoAndStop( parseInt( background_selected ) );
				mc('preview_foreground').gotoAndStop( parseInt( background_selected ) );
				
				var preview_back_enabled:Boolean = preview_index > 0;
				
				preview_back.alpha = preview_back_enabled ? 1 : 0.5;
				preview_back.mouseEnabled = preview_back_enabled;
				
				var preview_forward_enabled:Boolean = preview_index < preview_history.length - 1;
				
				preview_forward.alpha = preview_forward_enabled ? 1 : 0.5;
				preview_forward.mouseEnabled = preview_forward_enabled;
			}
			
			preview_update();
			
			/// load preview data from preview_index
			function preview_load( ):void
			{
				var preview_data_array:Array = preview_history[ preview_index ].split('.');
				
				hat = preview_data_array[ 0 ];
				
				raptor = preview_data_array[ 1 ];
			}
			
			mcClick('preview_back', function():void {
				
				if ( preview_index > 0 ) 
				{
					preview_index -- ;
					
					preview_load();
					
					preview_update();
				}
				
			});
			
			mcClick('preview_forward', function():void {
				
				if ( preview_index < preview_history.length - 1 ) 
				{
					preview_index ++ ;
					
					preview_load();
					
					preview_update();
				}
				
			});
			
			// --------------------------------------------------------------
			// **** 
			/// \Backgrounds
			// **** 
			// --------------------------------------------------------------
			
			var background_canvas:Shape = new Shape();
			
			GFX.addChild( background_canvas );
			
			var background_tiles:Array = [];
			
			var background_index:int = 0;
			
			function populate_tiles():void
			{
				background_tiles = [];
				
				var background_count:int = new HUI_Background().GFX.totalFrames;
				
				trace( "Backgrounds count", background_count );
				
				for ( var i:int = 1; i <= background_count; ++i ) 
				{
					var tile:MovieClip = new HUIT_Background().GFX;
					
					tile['bg'].gotoAndStop( i );
					
					// prevent flickering ( set selection to false )
					tile.gotoAndStop( 1 );
					
					// prevent click anomaly 
					tile.mouseChildren = false;
					
					tile.name = i.toString();
					
					background_tiles.push( tile );
				}
			}
			
			var background_container:Sprite = new Sprite();
			GFX.addChild( background_container );
			background_container.x = 284;
			background_container.y = 57;
			
			background_matrix = new HatsUIMatrix( background_container, 4, 5, 0, 0 );
			
			populate_tiles();
			
			background_matrix.connect( HatsUIMatrix.item_array_to_vector( background_tiles ) );
			
			background_matrix.resize( 544, 434 );
			
			var background_page:TextField = GFX['mat_text'] as TextField;
			
			function update_background_tiles():void {
				
				var background_controls:Boolean = background_matrix.page_count > 1 ;
				
				if ( background_controls ) 
				{
					background_page.text = ( background_matrix.page_index + 1 ) + "/" + background_matrix.page_count;
					
					render_page_indicators( background_canvas.graphics, 
					820, 500-3, background_matrix.page_count, background_matrix.page_index );
				}
				else 
				{
					background_page.text = "1";
					
					background_canvas.graphics.clear();
				}
				
				mc('mat_forward').mouseEnabled =
				mc('mat_back').mouseEnabled = background_controls;
				
				mc('mat_forward').alpha = background_controls ? 1 : 0.5;
				mc('mat_back').alpha = background_controls ? 1 : 0.5;
				
				// clean up
				for ( background_index = 0; background_index < background_tiles.length; ++ background_index ) 
				{
					background_tiles[ background_index ].visible = false;
				}
				
				background_matrix.align_items();
				
				for ( background_index = 0; background_index < background_tiles.length; ++ background_index ) 
				{
					// skip invisble items 
					if ( ! background_matrix.is_index_visible( background_index ) ) continue;
					
					var background_tile:MovieClip = background_tiles[ background_index ] as MovieClip;
					
					// selection
					if ( background_tile.name == background_selected ) 
						background_tile.gotoAndStop( 2 );
					else background_tile.gotoAndStop( 1 );
				}
				
			};
			
			update_background_tiles();
			
			function background_selection_clear():void {
				
				for ( background_index = 0; background_index < background_tiles.length; ++ background_index ) 
				{
					background_tiles[ background_index ].gotoAndStop( 1 );
				}
			};
			
			background_matrix.on_item_select = function( sprite:Sprite ):void
			{
				if ( background_selected != sprite.name ) 
				{
					background_selection_clear();
					
					// display new selection
					( sprite as MovieClip ).gotoAndStop( 2 );
					
					background_selected = sprite.name;
					
					trace( "selected background" , background_selected );
					
					preview_update();
				}
			};
			
			mcClick('mat_forward', function():void {
				
				background_matrix.page_next();
				
				update_background_tiles();
				
			});
			
			mcClick('mat_back', function():void {
				
				background_matrix.page_prev();
				
				update_background_tiles();
				
			});
			
			
			// --------------------------------------------------------------
			// **** 
			/// \Buttons
			// **** 
			// --------------------------------------------------------------
			
			// exit and save changes
			mcClick('close', exit );
			
			mcClick('back', function():void {
				
				sort = "Classic";
				
				swap( new HUIV_Main() );
				
			});
			
			return true;
		}
		
		override public function dispose():Boolean 
		{
			if ( ! super.dispose() ) return false;
			
			background_matrix.hide_all();
			background_matrix = null;
			
			return true;
		}
	}
}