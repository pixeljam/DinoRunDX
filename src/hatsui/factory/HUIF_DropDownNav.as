package hatsui.factory 
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.text.TextField;
	
	import hatsui.view.HUI_View;
	
	import util.Stats;
	
	/// Hats UI Factory class for : Drop down sorting navigation
	public class HUIF_DropDownNav
	{
		static public var color_text:uint = 0x635b52;
		static public var color_text_hover:uint = 0xFFFFFF;
		
		static public const sort_items:Array = 
		[ 
			'Classic', 'Indie_Collection', 'Halloween','The_Vault','Adult_Swim','Prestige',
			'Favorites', 'Favorite_Combos', 
			'Recent_Combos' 
		];
		
		//add new categories!
		static public function isCombo( sort_item:String ):Boolean
		{
			var sort_index:int = sort_items.indexOf( sort_item );
			if ( sort_index == -1 ) throw new Error( "Undefined sort item");
			return sort_index >= 7; //<- this fuckin thing
		}
		
		static public function connect( view:HUI_View, onUpdate:Function = null ):void
		{
			var sort_text:TextField = view.GFX['sort_text'] as TextField;
			
			sort_text.text = view.sort;
			
			var sort_picker:MovieClip = view.mc('sort_picker');
			
			sort_picker.visible = false;
			
			view.disable_text( sort_picker );
			
			trace ("connect",view,view.GFX);
						
			view.ioEvent( view.GFX, 'mouseDown', function( ):void {
				
				if ( ! sort_picker.visible ) return;
				if ( sort_picker.hitTestPoint( view.GFX.stage.mouseX, view.GFX.stage.mouseY ) ) return;
				
				view.mcClick('sort_picker');
				
			});
			
			view.mcClick( 'sort_by', function():void 
			{
				
				sort_picker.visible = true;
				
				view.GFX.mouseChildren = false;
				var pos:Point = sort_picker.localToGlobal( new Point( ) );
				view.GFX.stage.addChild( sort_picker );
				pos = view.GFX.stage.globalToLocal( pos );
				sort_picker.x = pos.x;
				sort_picker.y = pos.y;
				
				pos = sort_text.localToGlobal( new Point( ) );
				view.GFX.stage.addChild( sort_text  );
				pos = view.GFX.stage.globalToLocal( pos );
				sort_text.x = pos.x;
				sort_text.y = pos.y;
				
				view.mcListApply( 'sort_picker', sort_items, color_text, 'textColor' );
				
				view.mcListApply( 'sort_picker', sort_items, 1, 'alpha' );
				
				// disable items 
				sort_picker[ view.sort ].alpha = 0.5;
				sort_picker[ 'Prestige' ].alpha = Stats.hasPrestige ? 1 : .5;
				sort_picker[ 'Recent_Combos' ].alpha = view.preview_history.length < 2 ? 0.5 : 1;
				sort_picker[ 'Favorite_Combos' ].alpha = view.favorite_combos.length == 0 ? 0.5 : 1;
				sort_picker[ 'Favorites' ].alpha = ( view.favorite_hats.length == 0 && view.favorite_raptors.length == 0 )  ? 0.5 : 1;
			});
			
			
			view.mcClick('sort_picker', function():void {
				
				sort_picker.visible = false;
				
				view.GFX.mouseChildren = true;
				view.GFX['sort_by'].addChild( sort_text  );
				sort_text.x = 104.8;
				sort_text.y = 0;
				
				if ( ! sort_picker.hitTestPoint( view.GFX.stage.mouseX, view.GFX.stage.mouseY ) ) return;
				
				var Y:int = int( sort_picker.mouseY );
				
				var value:String = sort_item_y( Y );
				
				if ( value == "null" ) return;
				
				if ( sort_picker[ value ].alpha == 1 && value != view.sort ) 
				{
					sort_text.text = value.replace("_", " ");
					
					view.sort = value;
					
					trace( "Sort item set", value );
					
					onUpdate();
				}
			});
			
			view.mcEvent('sort_picker', 'mouseMove', function():void {
				
				var Y:int = int( sort_picker.mouseY );
				
				var value:String = sort_item_y( Y );
				
				if ( value == "null" ) return;
				
				view.mcListApply( 'sort_picker', sort_items, color_text, 'textColor' );
				
				if( sort_picker[ value ].alpha == 1 ) 
					sort_picker[ value ].textColor = color_text_hover;
			});
		}
		
		static private function sort_item_y( Y:int ):String {
				
			for ( var I:int = 0; I < sort_items_pos.length; I += 2 )
			{
				if ( Y >= sort_items_pos[ I ] && Y <= sort_items_pos[ I + 1 ] ) 
				{
					return sort_items[ I / 2 ];
				}
			}
			
			return "null";
		}
		
		static public const sort_items_pos:Array = 
		[ 
			28, 55, // Classic
			55, 82, // Indie_Collection
			82, 109, // Halloween
			109, 136, // Vault
			136, 163, // AS
			163, 190, // Prestige
			190, 217, // Favorites
			217, 234, // Favorite_Combos
			234, 261 // Recent_Combos

		];
		
	}
	
}