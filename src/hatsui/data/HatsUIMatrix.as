package hatsui.data
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Graphics;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	/** 
	 * @author wad1m.com, twitter: @_wad1m 
	 * 
	 * -- HatsUIMatrix.as -- 
	 * Version 0.1 - 16.June.16 - 3:00 AM - 5:00 AM 
		* item connector & basic align algorithm implemntation 
	 * Version 0.2 - 16.June.16 - 1:30 PM - 2:00 PM
		* ajustable size, items. dynamic properties. 
	 * Version 0.3 - 16.June.16 - 2:30 PM - 3:30 PM
		* added margin and padding with relative calculations.
	 * Version 0.4 - 16.June.16 - 3:30 PM - 4:00 PM
		* fixed algiment for varius item bounds size & abnormal transformation origin 
	 * Version 0.5 - 16.June.16 - 4:00 PM - 4:15 PM 
		* fixed none equal rows and cols values, were aligment breaks down  
	 * Version 0.6 - 16.June.16 - 4:15 PM - 5:00 PM 
		* added items fit algorithm, to display extra small items.
		* ajusted aligment for abnormal transformation origin & item bounds size.
	 * Version 0.7 - 16.Jone.16 - 7:30 PM - 8:00 PM 
		* visible item control functionality 
		* change default item status 
		* add static methods 
		* add extension methods to change class core data in the runtime
	 * Version 0.8 - 19.June.16 - 1:00 AM - 1:20 AM
		* added selection functionality  
	 * Version 0.9 - 19.June.16 - 4:00 AM - 4:10 AM
		* removed auto align functionality for all properties and methods
		* added sorting functionality in align method  
	 * Version 1.0 - 28.June.16
		* added function for index visability check 
		* added parent propagation toogle 
		* added get_visible_item, get_item functions 
		* added selected_index, selected_index_prev
	 * 
	 */
	public class HatsUIMatrix 
	{
		//  ---- ----- ----- ----- ----- ----- ----- ----- ----- --------
		/// ::: \V\A\R\I\A\B\L\E\S ::: - ::: - :::
		//  ---- ----- ----- ----- ----- ----- ----- ----- ----- --------
		
		/// items container ( optional )
		private var _parent:Sprite = null;
		/// amount of rows to destribut the items to 
		private var _rows:int = 0;
		/// amount of columns to destribut the items to 
		private var _cols:int = 0;
		/// space between items 
		private var _padding:Number = 0;
		/// empty space between drwaing size and items on the edge
		private var _margin:Number = 0;
		/// the current display page 
		private var _page_current:int = 0;
		/// amount of display pages to scroll threw 
		private var _page_total:int = 0;
		/// amount of items per page
		private var _page_size:int = 0;
		/// items reference 
		private var _items:Vector.<Sprite> = null;
		/// list of visible items on page 
		private var _items_visible:Vector.<Sprite> = null;
		/// align horizontal bounds size 
		private var _width:Number = 200;
		/// align vertical bounds size 
		private var _height:Number = 200;
		/// set true if items need to be forcfully scaled to the correct matrix proportions 
		private var _auto_fit:Boolean = false;
		/// enable / disable mouse event parent propagation 
		public var parent_propagation:Boolean = true;
		/// method will be executed on item click, function must accept [Sprite] argument
		public var on_item_select:Function = null;
		/// method will be executed on item shift + click, function must accept [Sprite] argument
		public var on_item_shift:Function = null;
		/// currently selected item index ( !note tested with parent_propagation flag ) 
		public var selected_index:int = 0;
		/// last selected item index ( !note tested with parent_propagation flag ) 
		public var selected_index_prev:int = -1;
		
		
		
		//  ---- ----- ----- ----- ----- ----- ----- ----- ----- --------
		/// ::: \C\O\N\S\T\R\A\C\T\O\R ::: - ::: - :::
		//  ---- ----- ----- ----- ----- ----- ----- ----- ----- --------
		
		/**
		 * @param	parent ( optional ) container where the items will be stored, displayed and aligned ( keep null to use default object's parent )
		 * @param	rows amount of rows to display 
		 * @param	cols amount of columns to display 
		 * @param	padding distance between items 
		 * @param	margin distance between items on the edge and the container bounds  
		 */
		public function HatsUIMatrix( parent:Sprite = null, rows:int = 0, cols:int = 0, padding:Number = 0, margin:Number = 0 )
		{
			_parent = parent;
			_rows = rows;
			_cols = cols;
			_padding = padding;
			_margin = margin;
			
			_page_current = 0;
			_page_size = _rows * _cols;
			_items = null;
			_width = 200;
			_height = 200;
		}
		
		//  ---- ----- ----- ----- ----- ----- ----- ----- ----- --------
		/// ::: \M\E\T\H\O\D\S ::: - ::: - :::
		//  ---- ----- ----- ----- ----- ----- ----- ----- ----- --------
		
		/// change to new align bounds size ( automatic alignment )
		public function resize( new_width:Number, new_height:Number ):void
		{
			_width = new_width;
			_height = new_height;
		}
		
		/// attach a list of display objects to page matrix 
		public function connect( items:Vector.<Sprite> ):void 
		{
			hide_all();
			
			_items = items;
			
			_page_current = 0;
			
			_page_total = int( items.length / _page_size ) + 1;
			if (items.length / _page_size == 1) {
				_page_total--;
			}
		}
		
		/*/ TEMP: debug draw 			-			-			-			-			-			-			- /*/
		/// reference a graphics instance to draw alignment calculations 
		public var debug:Graphics = null;
		/*/ TEMP: debug draw 			-			-			-			-			-			-			- /*/
		
		/// apply sort on current visible items in the netire matrix, (optional) apply sort to object property in "acs" for acsending or "des" for desending   
		public function sort( sortOn:String = "null", sortOrder:String = "acs" ):void
		{
			// prevent errors
			if ( _items == null || _items.length == 0 ) return;
			
			if ( sortOn != 'null' ) _items = _items.sort( function( A:Sprite, B:Sprite ):Number 
			{
				if ( A.hasOwnProperty( sortOn ) && B.hasOwnProperty( sortOn ) ) 
				{
					try 
					{
						var a:Number = Number( A[ sortOn ] );
						var b:Number = Number( B[ sortOn ] );
					}
					catch ( e:Error )
					{
						trace("failed to convert value", sortOn, "to number");
					}
					
					return a - b;
					
					//if ( a == b ) return 0;
					//if ( a < b ) return -1;
					//return 1;
				}
				
				trace( "sorting failed, value", sortOn, "is not part of", A, "or", B );
				return 0;
				
			});
		}
		
		/// update current visible items on page  
		public function align_items():void
		{
			// prevent null aligment 
			if ( _items == null || _items.length == 0 ) return;
			
			// hide & disconnect all items 
			hide_all();
			
			/*/ TEMP: debug draw 			-			-			-			-			-			-		 /*/
			if ( debug != null ) {	debug.clear();
				debug.lineStyle( 1, 0xFF0000 );
				debug.drawRect( 1, 1, _width - 2, _height - 2); }
			/*/ TEMP: debug draw 			-			-			-			-			-			-		 /*/
			
			var item:Sprite;
			var item_index:int = 0;
			var index:int = _page_current * _page_size;
			var item_x:Number = 0;
			var item_y:Number = 0;
			var item_w:Number = ( _width - _padding * ( _cols - 1 ) - _margin * 2 ) / _cols;
			var item_h:Number = ( _height - _padding * ( _rows - 1 ) - _margin * 2 ) / _rows;
			var item_b:Rectangle = null; // bounds
			
			_items_visible = new Vector.<Sprite>();
			
			// loop threw page items 
			while ( item_index < _page_size && index < _items.length )
			{
				// show item 
				item = _items[ index ];
				if ( _parent ) _parent.addChild( item );
				item.visible = true;
				item.addEventListener('click', capture_click, false, 0, true );
				item.useHandCursor = item.buttonMode = true;
				
				// calculate item index position 
				item_x = int(item_index % _cols)
				item_y = int( item_index / _cols );
				
				// align item to it's position index
				item_x = ( item_x ) * item_w + _margin + _padding * ( item_x );
				item_y = ( item_y ) * item_h + _margin + _padding * ( item_y );
				
				/*/ TEMP: debug draw 			-			-			-			-			-			-	 /*/
				if ( debug ) debug.drawRect( item_x, item_y, item_w, item_h );
				/*/ TEMP: debug draw 			-			-			-			-			-			-	 /*/
				
				// scale item to fit aligment bounds 
				if ( _auto_fit ) 
				{
					item.height = item_h;
					item.scaleX = item.scaleY;
				}
				else 
				{
					item.scaleX = item.scaleY = 1;
				}
				
				// position item relative to it's bounds 
				item_b = item.parent ? item.getBounds( item.parent ) : item.getBounds( item );
				item.x = Math.ceil(item_x);// + ( item_w - item_b.width ) / 2 - ( item_b.x - item.x ) ); 
				item.y = Math.ceil(item_y);// + ( item_h - item_b.height ) / 2 - ( item_b.y - item.y ) ); 
				
				// record visible 
				_items_visible.push( item );
				
				// advance counters 
				index ++ ;
				item_index ++ ;
			}
		}
		
		/// set true if items need to be forcfully scaled to the correct matrix proportions, else the items scale values will be set to 1 ( automatic alignment )
		public function get auto_fit():Boolean { return _auto_fit; }
		public function set auto_fit(v:Boolean):void { _auto_fit = v; }
		
		/// get the current display page ( zero based ) 
		public function get page_index():int { return _page_current; }
		
		/// get the amount of display pages to scroll threw 
		public function get page_count():int { return _page_total; }
		
		/// display next page ( automatic alignment )
		public function page_next():void 
		{ 
			if ( ++ _page_current + 1 > _page_total ) 
			_page_current = 0;
		}
		
		/// display prev page ( automatic alignment )
		public function page_prev():void
		{
			if ( -- _page_current < 0 ) 
			_page_current = _page_total - 1;
		}
		
		private function capture_click( e:* ):void 
		{
			if ( e.target == null ) return;
			
			var target:Sprite = e.target;
			
			if ( _parent != null && parent_propagation ) 
			{
				while ( target.parent != _parent ) 
				target = target.parent as Sprite;
			}
			
			selected_index_prev = selected_index;
			
			selected_index = _items.indexOf( target );
			
			if ( on_item_select != null && !e.shiftKey ) on_item_select( target as Sprite );
			
			if ( on_item_shift != null && e.shiftKey ) on_item_shift( target as Sprite );
		}
		
		/// hide all display objects connected to matrix, and set visible items vector to zero 
		public function hide_all():void 
		{
			if ( _items_visible == null || _items_visible.length == 0 ) return;
			var object:Sprite;
			while ( _items_visible.length > 0 ) 
			{
				object = _items_visible.pop();
				object.removeEventListener('click', capture_click );
				if ( _parent && _parent.contains( object ) )
				_parent.removeChild( object );
				object.visible = false;
			}
			_items_visible.length = 0;		_items_visible = null;
		}
		
		/// recieve Vector list of all items from the current page type of Sprite
		public function get visible_items():Vector.<Sprite>
		{
			return _items_visible;
		}
		/// Read item from relative visible items by index and return it 
		public function get_visible_item( index:int ):Sprite
		{
			return _items_visible[ index ];
		}
		
		/// Read item from list of all items by index and return it 
		public function get_item( index:int ):Sprite
		{
			return _items[ index ];
		}
		
		/// check if target index is visible on current page or not.
		public function is_index_visible( index:int ):Boolean
		{
			if ( index < _page_current * _page_size ) return false;
			
			if (  index >= _items.length ) return false;
			
			return true;
		}
		
		/// change the layout table size ( this will not align the items automaticlly, call align_items() to take effect ). 
		/// Keep values to NaN to not effect original values 
		public function change( new_row_size:int, new_col_size:int, new_padding:Number = NaN, new_margin:Number = NaN ):void
		{
			_rows = new_row_size;
			_cols = new_col_size;
			_page_current = 0;
			_page_size = _rows * _cols;
			
			if ( ! isNaN ( new_padding ) ) _padding = new_padding;
			if ( ! isNaN ( new_margin ) ) _padding = new_margin;
		}
		
		//  ---- ----- ----- ----- ----- ----- ----- ----- ----- --------
		/// ::: \S\T\A\T\I\C ::: - ::: - :::
		//  ---- ----- ----- ----- ----- ----- ----- ----- ----- --------
		
		static public function item_array_to_vector( items:Array ):Vector.<Sprite>
		{
			var output:Vector.<Sprite> = new Vector.<Sprite>( items.length, true );
			for( var index:int = 0; index < items.length; ++index ) 
			{
				var item:Sprite;
				try { item = items[ index ] as Sprite; }
				catch ( e:Error ) { throw new Error( "item[" + index + "] is not display object instance" ); }
				item.visible = false;
				output[ index ] = item;
			}
			return output;
		}
		
		static public function item_dict_to_vector( items:Dictionary ):Vector.<Sprite> 
		{
			var output:Vector.<Sprite> = new Vector.<Sprite>( );
			for ( var key:Object in items ) 
			{
				var item:Sprite;
				try { item = items[ key ] as Sprite; }
				catch ( e:Error ) { throw new Error( "item[" + key + "] is not display object instance" ); }
				if ( item == null ) 
				{
					trace( "/!\ Warnning item [" + key + "] has failed to convert and was skipped" );
					continue;
				}
				item.visible = false;
				output.push( item );
			}
			return output;
		}
	}
}