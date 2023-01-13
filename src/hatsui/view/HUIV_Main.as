package hatsui.view
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.geom.Point;
	import flash.text.TextField;
	
	import gfx.HatUI;
	
	import hatsui.data.HatsUIMatrix;
	import hatsui.data.HatsUISave;
	import hatsui.factory.HUIF_ColorSwap;
	import hatsui.factory.HUIF_DropDownNav;
	import hatsui.tiles.HUIT_Hat;
	import hatsui.tiles.HUIT_Raptor;
		
	public class HUIV_Main extends HUI_View
	{
		private var raptor_matrix:HatsUIMatrix;
		private var hat_matrix:HatsUIMatrix;
		
		public function HUIV_Main() {}
		
		override public function initialize(parent:DisplayObjectContainer = null,interF=null,h="",clr=""):Boolean 
		{
			GFX = new _HUIV_Main();
			
			if (h != "") {
				hat = h;
				raptor = clr;
			}
			
			if ( ! super.initialize(parent,interF,h,clr) ) return false;
			
			// self reference
			var main:MovieClip = this;
			
			
			
			// --------------------------------------------------------------
			// **** 
			///    \Filter
			// **** 
			// --------------------------------------------------------------
			
			function filter_raptors():Array {
				
				var _filter_index:int = 0;
				
				var output:Array = [];
				
				for ( ; _filter_index < raptor_tiles.length; ++ _filter_index )
				{
					var _filter_key:String = raptor_tiles[ _filter_index ].name.split(".")[0];
					
					var _filter_index_2:int = raptor_filter_key.indexOf( _filter_key );
					
					var _filter_value:String = raptor_filter_value[ _filter_index_2 ];
					
					if ( (raptor_type == 0 && _filter_value == "body") ||
							(raptor_type == 1 && _filter_value == "dot") ||
							(raptor_type == 2 && _filter_value == "stripe") ) 
							
						output.push( raptor_tiles[ _filter_index ] );
				}
				
				trace( "filtered raptors", raptor_type, output.length, "/", raptor_tiles.length );
				
				return output;
			}
			
			// --------------------------------------------------------
			// **** 
			///    \Drop \Down \Menu
			// **** 
			// --------------------------------------------------------
			
			HUIF_DropDownNav.connect( this, function():void 
			{
				trace ("connect");
				if ( HUIF_DropDownNav.isCombo( sort ) ) 
				{
					swap( new HUIV_Combo() );
					return;
				}
				
				// hats collection / favorites 
				hat_tiles_sort();
				
				// raptors favorites 
				if ( sort == 'Favorites' )
				{
					raptor_filtered = HUI_Array.clone( raptor_tiles );
					
					HUI_Sort.sort_tiles_favorite( raptor_filtered );
					
					raptor_matrix.connect( HatsUIMatrix.item_array_to_vector( raptor_filtered ) );
					
					update_raptor_tiles();
					
					// display no selection on raptor check box 
					mcStop( 'raptor_checkbox', 4 );
				}
				else if ( sort != 'Favorites' )
				{
					raptor_type_update( );
				}
			});
			
			// --------------------------------------------------------------
			// **** 
			///    \Color \Swap
			// **** 
			// --------------------------------------------------------------
			
			HUIF_ColorSwap.connect( this, function( color_new:uint ):void
			{
				// check if colors are the same, prevent change 
				if ( color_new == color ) return;
				
				// Update color value 
				color = color_new;
				trace( 'color', color_new );
				
				// render
				preview_update();
				update_hat_tiles();
				update_raptor_tiles();
			});
			
			// --------------------------------------------------------------
			// **** 
			///    \Auto \Match
			// **** 
			// --------------------------------------------------------------
			
			/// current match value 
			var match:Boolean = false;
			
			mcStop( 'auto_match', match ? 2 : 1 );
			
			mcClick( 'auto_match', function():void {
				
				match = ! match;
				
				mcStop( 'auto_match', match ? 2 : 1 );
				
				trace( "Auto match set to", match ); 
				
			});
			
			// --------------------------------------------------------------
			// **** 
			///    \Raptor \Type
			// **** 
			// --------------------------------------------------------------
			
			var raptor_filter_key:Array = [];
			var raptor_filter_value:Array = [];
			
			for ( var _data_key:String in data.dColors ) {
				
				raptor_filter_key.push( _data_key );
				
				if ( data.dColors[ _data_key ][ 'dot' ].length > 0 ) 
					raptor_filter_value.push( 'dot' );
				else if ( data.dColors[ _data_key ][ 'stripe' ].length > 0 ) 
					raptor_filter_value.push( 'stripe' );
				else raptor_filter_value.push( 'body' );
			}
			
			// current raptor type, were 0 is body/eye, 1 is dot, spot, 2 is stripe, 3 is all 
			var raptor_type:int = HatsUISave.readElseWrite("raptor_type", 1 );
			
			mcStop('raptor_checkbox', raptor_type + 1 );
			
			mcClick('raptor_checkbox', function():void {
				
				var X:int = int( mc('raptor_checkbox').mouseX );
				
				var V:uint = 2;
				
				if ( X <= 54 ) V = 0;
				
				else if ( X <= 108 ) V = 1;
				
				if ( V != raptor_type ) 
				{
					raptor_type = V;
					
					raptor_type_update();
				}
			});
			
			function raptor_type_update():void {
				
				mcStop('raptor_checkbox', raptor_type + 1 );
				
				HatsUISave.write( "raptor_type", raptor_type );
				
				trace( 'raptor type set to', raptor_type );
				
				raptor_filtered = filter_raptors( );
				
				HUI_Sort.sort_tiles( raptor_filtered );
				
				raptor_matrix.connect( HatsUIMatrix.item_array_to_vector( raptor_filtered ) );
				
				update_raptor_tiles( );
			};
			
			// --------------------------------------------------------------
			// **** 
			///    \Save \Picture
			// **** 
			// --------------------------------------------------------------
			
			mcClick('save_pic', function():void {
				
				swap( new HUIV_Portrait() );
				
			});
			
			// --------------------------------------------------------------
			// **** 
			///    \Preview
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
			
			function preview_update( ):void {
				
				mcColor( mc('preview_bg'), color );
				
				mcRaptor( preview_dino, data.dColors[ raptor ] );
				
				mcHat( preview_dino['hat'] as MovieClip, hat ); 
				
				updateDino(raptor,hat);
				
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
			function preview_load( ):void {
				
				var preview_data_array:Array = preview_history[ preview_index ].split('.');
				
				hat = preview_data_array[ 0 ];
				
				raptor = preview_data_array[ 1 ];
			}
			
			mcClick('preview_back', function():void {
				
				if ( preview_index > 0 ) 
				{
					preview_index -- ;
					
					preview_load();
					
					hat_selection_clear();
					
					raptor_selection_clear();
					
					preview_update();
				}
				
			});
			
			mcClick('preview_forward', function():void {
				
				if ( preview_index < preview_history.length - 1 ) 
				{
					preview_index ++ ;
					
					preview_load();
					
					hat_selection_clear();
					
					raptor_selection_clear();
					
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
			///    \HATS
			// **** 
			// --------------------------------------------------------------
			
			var hat_canvas:Shape = new Shape();
			
			GFX.addChild( hat_canvas );
			
			var hat_tiles:Array = [];
			
			var hat_selected:int = 0;
			
			// skip first "xx" hat 
			var hat_index:int = 1;
			
			for ( ; hat_index < data.hats.length; hat_index++ ) {
								
				var hat_tile:MovieClip = new HUIT_Hat().GFX;
				
				hat_tile['hat'].gotoAndStop( data.hats[ hat_index ] == "xx" ? "xx" : data.hats[ hat_index ] + "1", null );
				
				// check if hat is favorited and display star if needed
				hat_tile['star'].visible = favorite_hats.indexOf( data.hats[ hat_index ] ) > -1;
				
				// prevent flickering ( set selection to false )
				hat_tile.gotoAndStop( 1 );
				
				// prevent click anomaly 
				hat_tile.mouseChildren = false;
				
				// hat name includes name from data and index 
				hat_tile.name = data.hats[ hat_index ] + "." + (hat_index);
				//trace (hat_tile.name);
				
				hat_tiles.push( hat_tile );
				
				orig_order = hat_tiles.slice();
			}
			
			var orig_order:Array;
			
			function hat_tiles_sort():void {
				hat_tiles = orig_order;
				trace ("sort",sort);
				// sort by collection type
				if ( sort == 'Classic' )
				{
					hat_tiles=HUI_Sort.sort_hats_classic( hat_tiles );
				}
				if ( sort == 'Halloween' )
				{
					hat_tiles=HUI_Sort.sort_hats_halloween( hat_tiles );
				}
				if ( sort == "Indie_Collection" ) 
				{
					hat_tiles=HUI_Sort.sort_hats_indie( hat_tiles );
				}
				if ( sort == "The_Vault" ) 
				{
					hat_tiles=HUI_Sort.sort_hats_vault( hat_tiles );
				}
				if ( sort == "Adult_Swim" ) 
				{
					hat_tiles=HUI_Sort.sort_hats_AS( hat_tiles );
				}
				if ( sort == "Prestige" ) 
				{
					hat_tiles=HUI_Sort.sort_hats_prestige( hat_tiles );
				}
				if ( sort == "Favorites" ) 
				{
					HUI_Sort.sort_tiles_favorite( hat_tiles );
				}
				
				hat_matrix.connect( HatsUIMatrix.item_array_to_vector( hat_tiles ) );
				
				update_hat_tiles( );
			}
			
			var hat_container:Sprite = new Sprite();
			GFX.addChild( hat_container );
			hat_container.x = 260;
			hat_container.y = 59;
			
			hat_matrix = new HatsUIMatrix( hat_container, 4, 9, 0, 0 );
			
			hat_matrix.resize( 569, 230 );
			
			var hat_page:TextField = GFX['mat_top_text'] as TextField;
			
			function update_hat_tiles():void {
				
				var hat_controls:Boolean = hat_matrix.page_count > 1 ;
				
				if ( hat_controls ) 
				{
					hat_page.text = ( hat_matrix.page_index + 1 ) + "/" + hat_matrix.page_count;
					
					render_page_indicators( hat_canvas.graphics, 
					820, 300-3, hat_matrix.page_count, hat_matrix.page_index );
				}
				else 
				{
					hat_page.text = "1";
					
					hat_canvas.graphics.clear();
				}
				
				mc('mat_top_forward').mouseEnabled =
				mc('mat_top_back').mouseEnabled = hat_controls;
				
				mc('mat_top_forward').alpha = hat_controls ? 1 : 0.5;
				mc('mat_top_back').alpha = hat_controls ? 1 : 0.5;
				
				// clean up
				for ( hat_index = 0; hat_index < hat_tiles.length; ++ hat_index ) 
				{
					hat_tiles[ hat_index ].visible = false;
				}
				
				hat_matrix.align_items();
				
				for ( hat_index = 0; hat_index < hat_tiles.length; ++ hat_index ) 
				{
					// skip invisble items 
					if ( ! hat_matrix.is_index_visible( hat_index ) ) continue;
					
					var hat_tile:MovieClip = hat_tiles[ hat_index ] as MovieClip;
					
					// change color
					mcColor( hat_tile['color'], color );
					
					// update color selection
					if ( HUI_Tile.getName( hat_tile ) == hat ) 
						hat_tile.gotoAndStop( color == 0xFFFFFF ? 3 : 2 );
					
					// align hat to the center of 'color' mc.
					mcCenter( hat_tile['hat'], hat_tile['color'] );
				}
				
			};
			
			function hat_selection_clear():void {
				
				for ( hat_index = 0; hat_index < hat_tiles.length; ++ hat_index ) 
				{
					hat_tiles[ hat_index ].gotoAndStop( 1 );
				}
			};
			
			hat_matrix.on_item_select = function( sprite:Sprite ):void {
				
				// trace( sprite.name );
				
				var hi = parseInt( sprite.name.split(".") [ 1 ] );
				
				trace (hi);
				
				if ( hat_selected != hi ) 
				{
					hat = String( sprite.name.split(".") [ 0 ] );
					
					hat_selection_clear();
					
					// display new selection
					( sprite as MovieClip ).gotoAndStop( color == 0xFFFFFF ? 3 : 2 );
					
					hat_selected = hi;
					
					trace( "selected hat" , sprite.name, hi, hat );
					
					if ( match ) 
					{
						var raptor_match:String = data.hatMatcher[ hat ];
						
						if ( raptor_match != null )
						{
							raptor = raptor_match;
							
							raptor_selection_clear();
							
							preview_update();
							
							trace( "hat", hat ,"match raptor", raptor_match );
						}
						else 
						{
							match = false;
							
							mcStop( 'auto_match', 1 );
							
							trace( "Failed to match hat", hat ,"to raptor data" );
						}
					}
				}
				
				preview_update();
			};
			
			hat_matrix.on_item_shift = function( sprite:Sprite ):void {
				
				// toogle start visability
				sprite['star'].visible = ! sprite['star'].visible;
				
				// update save data
				HatsUISave.write( "favorite_hats", 
					favorite( sprite['star'].visible, sprite.name.split(".")[ 0 ], favorite_hats ) );
				HatsUISave.save();
			};
			
			mcClick('mat_top_forward', function():void {
				
				hat_matrix.page_next();
				
				update_hat_tiles();
				
			});
			
			mcClick('mat_top_back', function():void {
				
				hat_matrix.page_prev();
				
				update_hat_tiles();
				
			});
			
			hat_tiles_sort();
			
			// --------------------------------------------------------------
			// **** 
			///    \RAPTORS
			// **** 
			// --------------------------------------------------------------
			
			var raptor_canvas:Shape = new Shape();
			
			GFX.addChild( raptor_canvas );
			
			var raptor_tiles:Array = [];
			
			var raptor_selected:int = 0;
			
			var raptor_index:int = 0;
			
			for ( var key:String in data.dColors ) {
				
				var raptor_tile:MovieClip = new HUIT_Raptor().GFX;
				
				mcRaptor( raptor_tile['raptor'], data.dColors[ key ] );
				
				// check if raptor is favorited and display STAR if needed
				raptor_tile['star'].visible = favorite_raptors.indexOf( key ) > -1;
				
				// prevent flickering ( set selection to false )
				raptor_tile.gotoAndStop( 1 );
				
				// prevent click anomaly 
				raptor_tile.mouseChildren = false;
				
				// hat name includes name from data and index 
				raptor_tile.name = key + "." + ( raptor_index++ );
				
				raptor_tiles.push( raptor_tile );
			}
			
			var raptor_container:Sprite = new Sprite();
			GFX.addChild( raptor_container );
			raptor_container.x = 260;
			raptor_container.y = 332;
			
			// load filtered raptor tiles
			var raptor_filtered:Array = filter_raptors( );
			
			HUI_Sort.sort_tiles( raptor_filtered );
			
			raptor_matrix = new HatsUIMatrix( raptor_container, 3, 9, 0, 0 );
			
			raptor_matrix.connect( HatsUIMatrix.item_array_to_vector( raptor_filtered ) );
			
			raptor_matrix.resize( 569, 158 );
			//raptor_matrix.resize( 560, 153 );
			
			var raptor_page:TextField = GFX['mat_bottom_text'] as TextField;
			
			function update_raptor_tiles():void {
				
				var raptor_controls:Boolean = raptor_matrix.page_count > 1 ;
				
				if ( raptor_controls ) 
				{
					raptor_page.text = ( raptor_matrix.page_index + 1 ) + "/" + raptor_matrix.page_count;
					
					render_page_indicators( raptor_canvas.graphics, 
					820, 500-3, raptor_matrix.page_count, raptor_matrix.page_index );
				}
				else 
				{
					raptor_page.text = "1";
					
					raptor_canvas.graphics.clear();
				}
				
				mc('mat_bottom_forward').mouseEnabled =
				mc('mat_bottom_back').mouseEnabled = raptor_controls;
				
				mc('mat_bottom_forward').alpha = raptor_controls ? 1 : 0.5;
				mc('mat_bottom_back').alpha = raptor_controls ? 1 : 0.5;
				
				// clean up
				for ( raptor_index = 0; raptor_index < raptor_tiles.length; ++ raptor_index ) 
				{
					raptor_tiles[ raptor_index ].visible = false;
				}
				
				raptor_matrix.align_items();
				
				for ( raptor_index = 0; raptor_index < raptor_filtered.length; ++ raptor_index ) 
				{
					// skip invisble items 
					if ( ! raptor_matrix.is_index_visible( raptor_index ) ) continue;
					
					var raptor_tile:MovieClip = raptor_filtered[ raptor_index ] as MovieClip;
					
					// change color
					mcColor( raptor_tile['color'], color );
					
					// update color selection
					if ( HUI_Tile.getName( raptor_tile ) == hat ) 
						raptor_tile.gotoAndStop( color == 0xFFFFFF ? 3 : 2 );
					
					// align raptor to the center of 'color' mc.
					//mcCenter( raptor_tile['raptor'], raptor_tile['color'] );
				}
				
			};
			
			update_raptor_tiles();
			
			function raptor_selection_clear():void {
				
				for ( raptor_index = 0; raptor_index < raptor_filtered.length; ++ raptor_index ) 
				{
					raptor_filtered[ raptor_index ].gotoAndStop( 1 );
				}
			};
			
			raptor_matrix.on_item_select = function( sprite:Sprite ):void {
				raptor_index = parseInt( sprite.name.split(".") [ 1 ] );
				
				if ( raptor_selected != raptor_index ) 
				{
					raptor = String( sprite.name.split(".") [ 0 ] );
					
					raptor_selection_clear();
					
					// display new selection
					( sprite as MovieClip ).gotoAndStop( color == 0xFFFFFF ? 3 : 2 );
					
					raptor_selected = raptor_index;
					
					trace( "selected raptor" , sprite.name, raptor_selected );
				}
				
				preview_update();
			};
			
			raptor_matrix.on_item_shift = function( sprite:Sprite ):void {
				// toogle start visability
				sprite['star'].visible = ! sprite['star'].visible;
				
				// update save data
				HatsUISave.write( "favorite_raptors", 
					favorite( sprite['star'].visible, sprite.name.split(".")[0], favorite_raptors ) );
				HatsUISave.save();
			};
			
			mcClick('mat_bottom_forward', function():void {
				
				raptor_matrix.page_next();
				
				update_raptor_tiles();
				
			});
			
			mcClick('mat_bottom_back', function():void {
				
				raptor_matrix.page_prev();
				
				update_raptor_tiles();
				
			});
			
			// --------------------------------------------------------------
			// **** 
			///    \>>>ButtonS<<<
			// **** 
			// --------------------------------------------------------------
			
			// exit and save changes
			mcClick('close', exit );
			
			mc('done').gotoAndStop( 1 );
			
			// exit and save changes
			mcClick('done', exit,true );
			
			return true;
		}
		
		// --------------------------------------------------------------
		// **** 
		///    \Public \Methods
		// **** 
		// --------------------------------------------------------------
			
		override public function dispose():Boolean 
		{
			if ( ! super.dispose() ) return false;
			
			raptor_matrix.hide_all();
			hat_matrix.hide_all();
			
			raptor_matrix = null;
			hat_matrix = null;
			
			return true;
		}
	}
}
import flash.display.MovieClip;

// -- [ Classes ] --

// --------------------------------------------------------
// **** 
///    \Sort
// **** 
// --------------------------------------------------------

// http://stackoverflow.com/questions/9861400/sorting-array-as3		
class HUI_Sort 
{	
	static public function sort_tiles_favorite( sort_array:Array ):void
	{
		sort_array.sort( function( a:MovieClip, b:MovieClip ):Number 
		{
			var sort_fav:Number = compare_fav( a, b );
			
			if ( sort_fav != 0 ) return sort_fav;
			
			return compare_name( HUI_Tile.getName( a ), HUI_Tile.getName( b ) );
		});
	}
	
	static public function sort_hats_prestige( sort_array:Array ):Array
	{
		var a:Array = [];
		var b:Array = [];
		var c:Array = [];
		for each (var i:MovieClip in sort_array) {
			if (HUI_Tile.isPrestige(i)) {
				a.push (i);
			} else {
				b.push(i);
			}
		}
		c = a.concat(b);
		
		// update indexes 
		update_tiles( c );
		
		return c;
	}
	
	static public function sort_hats_AS( sort_array:Array ):Array
	{
		var a:Array = [];
		var b:Array = [];
		var c:Array = [];
		for each (var i:MovieClip in sort_array) {
			if (HUI_Tile.isAS(i)) {
				a.push (i);
			} else {
				b.push(i);
			}
		}
		c = a.concat(b);
		
		// update indexes 
		update_tiles( c );
		
		return c;
	}
	
	static public function sort_hats_vault( sort_array:Array ):Array
	{
		var a:Array = [];
		var b:Array = [];
		var c:Array = [];
		for each (var i:MovieClip in sort_array) {
			if (HUI_Tile.isVault(i)) {
				a.push (i);
			} else {
				b.push(i);
			}
		}
		c = a.concat(b);
		
		// update indexes 
		update_tiles( c );
		
		return c;
	}
	
	static public function sort_hats_halloween( sort_array:Array ):Array
	{
		var a:Array = [];
		var b:Array = [];
		var c:Array = [];
		for each (var i:MovieClip in sort_array) {
			if (HUI_Tile.isHalloween(i)) {
				a.push (i);
			} else {
				b.push(i);
			}
		}
		c = a.concat(b);
		
		// update indexes 
		update_tiles( c );
		
		return c;
	}
	
	static public function sort_hats_indie( sort_array:Array ):Array
	{
		var a:Array = [];
		var b:Array = [];
		var c:Array = [];
		for each (var i:MovieClip in sort_array) {
			if (HUI_Tile.isIndie(i)) {
				a.push(i);
			} else {
				b.push(i);
			}
		}
		c = a.concat(b);
		
		// update indexes 
		update_tiles( c );
		
		return c;
	}
	
	static public function sort_hats_classic( sort_array:Array ):Array
	{
		var a:Array = [];
		var b:Array = [];
		var c:Array = [];
		for each (var i:MovieClip in sort_array) {
			if (HUI_Tile.isClassic(i)) {
				a.push (i);
			} else {
				b.push(i);
			}
		}
		c = a.concat(b);
		
		// update indexes 
		update_tiles( c );
		
		return c;
	}
	
	static public function sort_tiles( sort_array:Array ):void
	{
		
		// sort function
		sort_array.sort( function( a:MovieClip, b:MovieClip ):Number 
		{
			var sort_fav:Number = compare_fav( a, b );
			
			if ( sort_fav != 0 ) return sort_fav;
			
			return compare_name( HUI_Tile.getName( a ), HUI_Tile.getName( b ) );
		});
		
		// update indexes 
		update_tiles( sort_array );
	}
	
	static public function update_tiles( sort_array:Array ):void
	{
		for ( var sort_index:int = 0; sort_index < sort_array.length; ++sort_index )
		
		HUI_Tile.setIndex( sort_array[ sort_index ], sort_index );
	}
		
	static public function compare_fav( a:MovieClip, b:MovieClip ):Number
	{
		var A:Boolean = HUI_Tile.isFav( a );
		var B:Boolean = HUI_Tile.isFav( b );
		return A && !B ? -1 : ( !A && B ? +1 : 0 );
	}
	
	static public function compare_name( a:String, b:String ):Number
	{
		// sort by lenght ( shortest first ) 
		if ( a.length != b.length ) 
			return a.length - b.length; 
		// else sort them alphabetically 
		return a < b ? -1 : 1;
	}
}

// --------------------------------------------------------
// **** 
///    \Tile
// **** 
// --------------------------------------------------------

class HUI_Tile
{
	static public function isFav( mc:MovieClip ):Boolean
	{
		return mc['star'].visible;
	}
	
	static public function isIndie( mc:MovieClip ):Boolean
	{
		return indie.indexOf(mc.name.split(".")[0]) != -1;
	}
	static public function isHalloween( mc:MovieClip ):Boolean
	{
		return halloween.indexOf(mc.name.split(".")[0]) != -1;
	}
	static public function isClassic( mc:MovieClip ):Boolean
	{
		return classic.indexOf(mc.name.split(".")[0]) != -1;
	}
	static public function isVault( mc:MovieClip ):Boolean
	{
		return vault.indexOf(mc.name.split(".")[0]) != -1;
	}
	static public function isHair( mc:MovieClip ):Boolean
	{
		return hair.indexOf(mc.name.split(".")[0]) != -1;
	}
	static public function isAS( mc:MovieClip ):Boolean
	{
		return AS.indexOf(mc.name.split(".")[0]) != -1;
	}
	static public function isPrestige( mc:MovieClip ):Boolean
	{
		return prestige.indexOf(mc.name.split(".")[0]) != -1;
	}
	
	static public var classic:Array = ["A","B","vaultQ_","vaultR_","vaultP_","vaultT_","pra","vaultU_","vaultS_","vaultD_","vaultC_","q","bd","vaultB_","N","G","csa","vaultCC_","E","vaultE_","vaultKK_","vaultJJ_","gc","u","h","T","vaultG_","vaultF_","c","b","vaultI_","dc","ic","ec","d","W","S","vaultPPP_","vaultV_","Y","vaultO_","a","vaultY_","vaultAA_","vaultZ_","i","vaultEE_","vaultDD_","H","vaultFF_","vaultJ_","vaultK_","vaultL_","vaultGG_","vaultHH_","vaultII_","vaultW_","X","vaultN_","kk","ll","mm","p","vaultX_","vaultBB_","csc","cse","M","L","vaultM_","F","D","C","bc","nn","tt","R","J","m","O","Q","P","Z","ed","prc","hd","f","g","l","ob","gd","prb","vaultA_","e","qc","cc","n  		","fd","cd","ii","hh","mc","vv","jd","zz","yy","vaultYY_","vaultXX_","jb","vaultWW_","hhn","vaultNNN_","pc  		","nc","oc","cb","z","aa","ee","ff","gg","lc","dd","zb","vaultLL_","vaultMM_","csg","sc","tc","vaultOOO_","rb","bb","mb","vaultPP_","kb","vaultOO_","vaultQQ_","vaultRR_","ad","uc","hht","hhq","hhr","hhs","vaultNN_","csd","zc","vaultSS_","vaultVV_","vaultUU_","V    			","xc","t","uu","u","v","w","ww","s","pb","r","hc","eb","db","qb","fb","lb","fc","jc","ab","kc","ib","vaultZZ_","xxx","vc","wc","id","yc","i","gb","hb","xb","wb","yb","x","y","nb","sb","tb","csf","cov1_","cov2_","cov3_","cov4_","cov5_","cov6_","cov7_"];
	static public var halloween:Array = ["hhe_","hhf_","hhd","hhg_","ss","hhh_","hhi_","hhb","hhc","k","hha","o","f","hhl_","hhu_","hhv_","hhw_","hhx_","hho_","hhp_","hhn_","hhm_","j","rc","gd","ab","db","sc","id","r","s","pb","rb","ic_51_","csd","vaultWW_"];
	static public var vault:Array = ["vaultA_","vaultB_","vaultD_","vaultE_","vaultF_","vaultG_","vaultH_","vaultI_","vaultJ_","vaultK_","vaultM_","vaultN_",
		"vaultQ_","vaultS_","vaultT_","vaultV_","vaultW_","vaultY_","vaultAA_","vaultBB_","vaultDD_",
		"vaultEE_","vaultGG_","vaultHH_","vaultJJ_","vaultLL_","vaultMM_","vaultNN_","vaultOO_","vaultPP_","vaultQQ_","vaultRR_",
		"vaultSS_","vaultTT_","vaultUU_","vaultVV_","vaultWW_","vaultXX_","vaultYY_","vaultZZ_","vaultAAA_","vaultDDD_","vaultFFF_",
		"vaultGGG_","vaultHHH_","vaultJJJ_","vaultLLL_","vaultNNN_","vaultOOO_"];
	static public var hair:Array = ["vb","ac","K","ub","oo","pp","od","rr","qq","pd","vaultJJ_","nd","qd","vautGGG_","vaultIII_","vaultHHH_","vaultLLL_","vaultMMM_","ld","td","vaultAAA_","sd","vaultCCC_","kd","vaultBBB_","vaultDDD_","rd","md","vaultEEE_","vaultFFF_","csb"];
	static public var indie:Array = ["ic_02_","ic_03_","ic_04_","ic_05_","ic_41_","ic_42_","ic_43_","ic_40_","ic_39_","ic_38_","ic_75_","ic_25_","ic_24_","ic_74_","ic_16_","ic_21_","ic_22_","ic_23_","ic_18_","ic_19_","ic_20_","vaultTT_","ic_64_","ic_63_","ic_50_","ic_51_","ic_52_","ic_53_","ic_61_","ic_60_","ic_54_","ic_29_","ic_37_","ic_26_","ic_27_","ic_48_","ic_47_","ic_46_","ic_45_","ic_44_","ic_76_","ic_49_","ic_32_","ic_15_","ic_59_","ic_65_","ic_28_","ic_14_","ic_12_","ic_13_","ic_11_","ic_10_","ic_08_","ic_06_","ic_17_","ic_68_","ic_36_","ic_62_","ic_55_","ic_58_","ic_33_","ic_35_","ic_34_","ic_09_","ic_77_","ic_78_","ic_79_","jj"];
	static public var AS:Array = ["jd","zz","yy","vaultYY_","vaultXX_","jb","vaultWW_","hhn","vaultNNN_","ASd_","ASb_","ASc_","ASe_","ASf_","ASg_","ASh_","ASi_","ASj_","ASk_","ASl_","ASm_","ASn_","ASo_","ASp_","ASq_","ASr_","ASs_","ASa_"];
	static public var prestige:Array = ["vaultR_","vaultCC_","vaultP_","vaultO_","vaultPPP_","vaultC_","vaultU_","pra","vaultKK_","vaultL_","vaultFF_","vaultZ_","vaultII_","vaultX_","vaultIII_","vaultEEE_","vaultCCC_","vaultBBB_","prb","prc","vaultMMM_","hhb"];

	
	
	
	static public function setData( mc:MovieClip, name:String, index:int ):void
	{
		mc.name = name + "." + index;
	}
	
	static public function setName( mc:MovieClip, name:String ):void
	{
		var index:int = parseInt( mc.name.split(".")[ 1 ] );
		mc.name = name + "." + index;
	}
	
	static public function getName( mc:MovieClip ):String 
	{
		return mc.name.split(".")[ 0 ];
	}
	
	static public function getIndex( mc:MovieClip ):int
	{
		return parseInt( mc.name.split(".")[ 1 ] );
	}
	
	static public function setIndex( mc:MovieClip, index:int ):void 
	{
		var name:String = mc.name.split(".")[ 0 ];
		mc.name = name + "." + index;
	}
}

// --------------------------------------------------------
// **** 
///    \Array
// **** 
// --------------------------------------------------------

class HUI_Array 
{
	static public function clone( array:Array ):Array 
	{
		var output:Array = [];
		for ( var i:int = 0; i < array.length; ++i ) 
		{
			output.push( array[ i ] );
		}
		return output;
	}
	
	/// filter_function must return boolean ( if to add item to output )
	static public function filter( array:Array, filter_function:Function ):Array
	{
		var output:Array = [];
		for ( var i:int = 0; i < array.length; ++i ) 
		{
			if( filter_function( array[ i ] ) ) output.push( array[ i ] );
		}
		return output;
	}
}