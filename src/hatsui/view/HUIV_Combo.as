package hatsui.view
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;
	
	import gfx.HatUI;
	
	import hatsui.data.HatsUIMatrix;
	import hatsui.data.HatsUISave;
	import hatsui.factory.HUIF_ColorSwap;
	import hatsui.factory.HUIF_DropDownNav;
	import hatsui.tiles.HUIT_Combo;
	
	public class HUIV_Combo extends HUI_View
	{
		private var combo_matrix:HatsUIMatrix;
		
		public function HUIV_Combo() { }
		
		override public function initialize(parent:DisplayObjectContainer = null,interF=null,h="",clr=""):Boolean 
		{
			GFX = new _HUIV_Combo();
			
			if ( ! super.initialize(parent,interF,h,clr) ) return false;
			
			// self reference
			var main:MovieClip = this;
			
			
			
			// --------------------------------------------------------
			// **** 
			/// \Drop \Down \Menu
			// **** 
			// --------------------------------------------------------
						
			HUIF_DropDownNav.connect( this, function():void 
			{
				if ( ! HUIF_DropDownNav.isCombo( sort ) ) 
				{	
					swap( new HUIV_Main() );
				}
				else
				{
					populate_tiles();
						
					combo_matrix.connect( HatsUIMatrix.item_array_to_vector( combo_tiles ) );
					
					update_combo_tiles();
				}
			});
			
			// --------------------------------------------------------------
			// **** 
			/// \Color \Swap
			// **** 
			// --------------------------------------------------------------
			
			HUIF_ColorSwap.connect( this, function( color_new:uint ):void {
				
				// check if colors are the same, prevent change 
				if ( color == color_new ) return;
				
				// Update color value 
				color = color_new;
				trace( 'color', color_new );
				
				// render
				preview_update();
			});
			
			var color_swap:MovieClip = mc('color_swap');
			
			mcClick( 'color_swap', function():void {
				
				var color_new:uint = 0x151515; // [ 21,21,21 ]; 
				
				if ( color_swap.mouseX < 19 ) color_new = 0xA3E6FD; // [ 163, 230, 253 ];
				
				else if ( color_swap.mouseX < 38 ) color_new = 0xDCD8D0; // [ 220, 216, 208 ];
				
				else if ( color_swap.mouseX < 57 ) color_new = 0xFFFFFF; // [ 255,255,255 ];
				
				if ( color != color_new ) 
				{
					color = color_new;
					
					HatsUISave.write("color", color );
					
					trace( 'color', color_new );
					
					preview_update();
					
					// update_hat_tiles();
					
					// update_combo_tiles();
				}
				
			});
			
			// --------------------------------------------------------------
			// **** 
			/// \Save \Picture
			// **** 
			// --------------------------------------------------------------
			
			mcClick('save_pic', function():void {
				
				swap( new HUIV_Portrait() );
				
			});
			
			// --------------------------------------------------------------
			// **** 
			/// \Preview
			// **** 
			// --------------------------------------------------------------
			
			var preview_combo:String = hat + "." + raptor;
			
			// check if current combo is fav 
			var fav_combo:Boolean = favorite_combos.indexOf( preview_combo ) > -1;
			
			var preview_dino:MovieClip = mc('preview_dino');
			
			preview_dino.mouseEnabled = false;
			preview_dino.mouseChildren = false;
			
			var preview_fav:MovieClip = mc('preview_fav');
			
			preview_fav.mouseEnabled = false;
			preview_fav.mouseChildren = false;
			
			preview_fav.visible = fav_combo;
			
			//var preview_index:int = 0; -> moved to HatsUI_View.as
			
			if ( preview_history.length == 0 ) preview_history = [ hat + "." + raptor ];
			
			var preview_back:MovieClip = mc("preview_back");
			var preview_forward:MovieClip = mc("preview_forward");
			
			function preview_update( ):void
			{
				mcColor( mc('preview_bg'), color );
								
				mcRaptor( preview_dino, data.dColors[ raptor ] );
				
				updateDino(raptor,hat);
				
				mcHat( preview_dino['hat'] as MovieClip, hat ); 
				
				preview_combo = hat + "." + raptor;
				
				// check if preview allready exists in history, if not add 
				if ( preview_history.indexOf( preview_combo ) == -1 ) 
				{
					preview_history.splice( preview_index + 1, 0, preview_combo );
					
					preview_index ++;
				}
				
				// check if preview combo is in favorites, display start
				preview_fav.visible = favorite_combos.indexOf( preview_combo ) > -1;
				
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
					
					combo_selection_clear();
					
					preview_update();
				}
				
			});
			
			mcClick('preview_forward', function():void {
				
				if ( preview_index < preview_history.length - 1 ) 
				{
					preview_index ++ ;
					
					preview_load();
					
					combo_selection_clear();
					
					preview_update();
				}
				
			});
			
			mcClick('preview_bg', function( _:*, shift_key:Boolean ):void {
				
				if ( !shift_key )
					return;
				
				// toogle fav combo visability 
				preview_fav.visible = ! preview_fav.visible;
				
				// update save data
				HatsUISave.write( "favorite_combos", 
					favorite( preview_fav.visible, preview_combo, favorite_combos ) );
				HatsUISave.save();
			});
			
			mcClick('dino', function( _:*, shift_key:Boolean ):void {
				
				if ( !shift_key )
					return;
				
				// toogle fav combo visability 
				preview_fav.visible = ! preview_fav.visible;
				
				// update save data
				HatsUISave.write( "favorite_combos", 
					favorite( preview_fav.visible, preview_combo, favorite_combos ) );
				HatsUISave.save();
			});
			
			// --------------------------------------------------------------
			// **** 
			/// \Combos
			// **** 
			// --------------------------------------------------------------
			
			var combo_canvas:Shape = new Shape();
			
			GFX.addChild( combo_canvas );
			
			var combo_tiles:Array = [];
			
			var combo_selected:String = "";
			
			var combo_index:int = 0;
			
			function populate_tiles():void
			{
				var combo_array:Array = [];
				
				if ( sort == "Favorite_Combos" ) 
				{
					combo_array = favorite_combos;
				}
				else if ( sort == "Recent_Combos" ) 
				{
					combo_array = preview_history;
				}
				
				combo_tiles = [];
								
				for ( var i:int = 0; i < combo_array.length; ++i ) 
				{
					var combo:String = combo_array[ i ];
					
					var combo_hat:String = combo.split('.')[ 0 ];
					var combo_raptor:String = combo.split('.')[ 1 ];
					
					var raptor_data:Object = data.dColors[ combo_raptor ];
					
					if ( raptor_data == null ) continue;
					
					var tile:MovieClip = new HUIT_Combo().GFX;
					
					mcRaptor( tile['dino'], raptor_data );
					
					tile['dino']['hat'].visible = true;
					tile['dino']['hat'].gotoAndStop( (combo_hat == "xx" ? "xx" : combo_hat + "1"), null );
					
					// by default favorite combos are all favorite
					tile['star'].visible = favorite_combos.indexOf( combo ) > -1;
					
					// prevent flickering ( set selection to false )
					tile.gotoAndStop( 1 );
					
					// prevent click anomaly 
					tile.mouseChildren = false;
					
					tile.name = combo_hat + "." + combo_raptor;
					
					combo_tiles.push( tile );
				}
			}
			
			var combo_container:Sprite = new Sprite();
			GFX.addChild( combo_container );
			combo_container.x = 283;
			combo_container.y = 56;
			
			combo_matrix = new HatsUIMatrix( combo_container, 4, 5, 0, 0 );
			
			populate_tiles();
			
			combo_matrix.connect( HatsUIMatrix.item_array_to_vector( combo_tiles ) );
			
			combo_matrix.resize( 543.95, 433.9 );
			
			var combo_page:TextField = GFX['mat_text'] as TextField;
			
			function update_combo_tiles():void {
				
				var combo_controls:Boolean = combo_matrix.page_count > 1 ;
				
				if ( combo_controls ) 
				{
					combo_page.text = ( combo_matrix.page_index + 1 ) + "/" + combo_matrix.page_count;
					
					render_page_indicators( combo_canvas.graphics, 
					820, 500-3, combo_matrix.page_count, combo_matrix.page_index );
				}
				else 
				{
					combo_page.text = "1";
					
					combo_canvas.graphics.clear();
				}
				
				mc('mat_forward').mouseEnabled =
				mc('mat_back').mouseEnabled = combo_controls;
				
				mc('mat_forward').alpha = combo_controls ? 1 : 0.5;
				mc('mat_back').alpha = combo_controls ? 1 : 0.5;
				
				// clean up
				for ( combo_index = 0; combo_index < combo_tiles.length; ++ combo_index ) 
				{
					combo_tiles[ combo_index ].visible = false;
				}
				
				combo_matrix.align_items();
				
				for ( combo_index = 0; combo_index < combo_tiles.length; ++ combo_index ) 
				{
					// skip invisble items 
					if ( ! combo_matrix.is_index_visible( combo_index ) ) continue;
					
					var combo_tile:MovieClip = combo_tiles[ combo_index ] as MovieClip;
					
					// change color
					mcColor( combo_tile['color'], color );
					
					// update color selection
					if ( combo_tile.name == combo_selected ) 
						combo_tile.gotoAndStop( color == 0xFFFFFF ? 3 : 2 );
				}
				
			};
			
			update_combo_tiles();
			
			function combo_selection_clear():void {
				
				for ( combo_index = 0; combo_index < combo_tiles.length; ++ combo_index ) 
				{
					combo_tiles[ combo_index ].gotoAndStop( 1 );
				}
			};
			
			combo_matrix.on_item_select = function( sprite:Sprite ):void
			{
				if ( combo_selected != sprite.name ) 
				{
					combo_selection_clear();
					
					// display new selection
					( sprite as MovieClip ).gotoAndStop( color == 0xFFFFFF ? 3 : 2 );
					
					combo_selected = sprite.name;
					
					trace( "selected combo" , combo_selected );
					
					hat = combo_selected.split('.')[ 0 ];
					raptor = combo_selected.split('.')[ 1 ];
					
					preview_update();
				}
			};
			
			combo_matrix.on_item_shift = function( sprite:Sprite ):void
			{
				// toogle start visability
				sprite['star'].visible = ! sprite['star'].visible;
				
				// update save data
				HatsUISave.write( "favorite_combos", 
					favorite( sprite['star'].visible, sprite.name, favorite_combos ) );
				HatsUISave.save();
			};
						
			mcClick('mat_forward', function():void {
				
				combo_matrix.page_next();
				
				update_combo_tiles();
				
			});
			
			mcClick('mat_back', function():void {
				
				combo_matrix.page_prev();
				
				update_combo_tiles();
				
			});
			
			
			// --------------------------------------------------------------
			// **** 
			/// \Buttons
			// **** 
			// --------------------------------------------------------------
			
			// exit and save changes
			mcClick('close', exit );
			
			mc('done').gotoAndStop( 1 );
			
			mc('select').gotoAndStop( 2 );
			
			// exit and save changes
			mcClick('done', exit, true );
			
			mcClick('select', function():void {
				
				sort = "Classic";
				
				swap( new HUIV_Main() );
				
			},true);
			
			return true;
		}
		
		override public function dispose():Boolean 
		{
			if ( ! super.dispose() ) return false;
			
			combo_matrix.hide_all();
			combo_matrix = null;
			
			return true;
		}
	}
}