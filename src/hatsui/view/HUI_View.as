package hatsui.view
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import base.Brain;
	
	import fx.ColorChange;
	
	import gfx.HatUI;
	import gfx.InterF;
	
	import hatsui.data.HatsUISave;
	
	public class HUI_View extends MovieClip
	{
		//  ---- ----- ----- ----- ----- ----- ----- ----- ----- --------
		/// ::: \S\T\A\T\I\C ::: - ::: - :::
		//  ---- ----- ----- ----- ----- ----- ----- ----- ----- --------
		
		static private var _save_init:Boolean = false;
		
		static private function save_init():void {
			
			if ( _save_init ) return; _save_init = true;
			
			HatsUISave.init( 0 );
			HatsUISave.load();
			
			trace( "loaded", HatsUISave.TOKEN, "SO" );
			
			//trace( JSON.stringify( HatsUISave.data ) );
		}
		
		
		//static public var _data:HatUI = new HatUI();
		static public var _data:InterF;
		static public var _sort:String = "Classic";
		static public var _preview_history:Array = [];
		static public var _preview_index:int = 0;
		
		//  ---- ----- ----- ----- ----- ----- ----- ----- ----- --------
		/// ::: \D\A\T\A\ ::: - ::: - :::
		//  ---- ----- ----- ----- ----- ----- ----- ----- ----- --------
		
		public function get preview_index():uint { return _preview_index; }
		public function set preview_index(v:uint):void { _preview_index = v; }
		
		public function get data():InterF { return HUI_View._data; }
		
		public function get color():uint { return HatsUISave.readElseWrite("color", 0xA3E6FD ); }
		public function set color( v:uint ):void { HatsUISave.write("color", v ); }
		
		public function get sort():String { return HUI_View._sort; }
		public function set sort(v:String):void { HUI_View._sort = v; }
		
		public function get preview_history():Array { return HUI_View._preview_history; }
		public function set preview_history(a:Array):void { HUI_View._preview_history = a; }
		
		public function get hat():String { return HatsUISave.readElseWrite( "hat", "A" ); }
		public function set hat(v:String):void { HatsUISave.write('hat', v ); }
		
		public function get raptor():String { return HatsUISave.readElseWrite( "raptor", "y" ); }
		public function set raptor(v:String):void { HatsUISave.write('raptor', v ); }
		
		public function get favorite_hats():Array { return HatsUISave.readElseWrite( "favorite_hats", [] ) }
		public function get favorite_raptors():Array { return HatsUISave.readElseWrite( "favorite_raptors", [] ) }
		public function get favorite_combos():Array {return HatsUISave.readElseWrite( "favorite_combos", [] ) }
		
		/// modify favorites
		public function favorite( favorite_state:Boolean, favorite_item:String, favorite_array:Array ):Array
		{
			if ( favorite_state ) 
			{
				if ( favorite_array.indexOf( favorite_item ) == -1 ) 
				{
					favorite_array.push( favorite_item );
				}
			}
			else
			{
				if ( favorite_array.indexOf( favorite_item ) != -1 ) 
				{
					favorite_array.splice( favorite_array.indexOf( favorite_item ), 1 );
				}
			}
			
			return favorite_array;
		}
		
		//  ---- ----- ----- ----- ----- ----- ----- ----- ----- --------
		/// ::: \V\A\R\I\A\B\L\E\S\ ::: - ::: - ::: - :::
		//  ---- ----- ----- ----- ----- ----- ----- ----- ----- --------
		
		private var disposed:Boolean = true;
		private var active:Boolean = false;
		
		// hold events for disposale
		public var events:Array = [];
		
		//gfx
		public var GFX:MovieClip;
		public var parentClip:DisplayObjectContainer;
		
		//  ---- ----- ----- ----- ----- ----- ----- ----- ----- --------
		/// :::  \C\O\N\S\T\R\U\C\T\O\R\ ::: - ::: - ::: - :::
		//  ---- ----- ----- ----- ----- ----- ----- ----- ----- --------
		
		public function HUI_View( ) 
		{
			trace( this, "constructor" );
			
			save_init();
			
			var on_dispose:Function = function():void { dispose( ); };
			
			addEventListener('removedFromStage', on_dispose ); 
			
			var on_added:Function = function( _:* ):void { initialize( ); };
			
			addEventListener('addedToStage', on_added );
				
			if ( stage != null ) initialize( );
		}
		
		//  ---- ----- ----- ----- ----- ----- ----- ----- ----- --------
		/// :::  \M\E\T\H\O\D\S\ ::: - ::: - ::: - :::
		//  ---- ----- ----- ----- ----- ----- ----- ----- ----- --------
		
		public function exit(  ):void
		{
			_sort = "Classic";
			
			HatsUISave.save();
			
			// keep this
			trace( 'exit', dispose() );
			
			//send data to game
			if (data.current != "MPLobby") {
				data.stats.hat = hat;
				data.stats.clr = raptor;
				data.updateDino (data.stats.clr,data.stats.hat,data.dino);
			} else {
				data.updateDino (raptor,hat,null,true);
			}
			trace (data.stats.hat,data.stats.clr);
		}
		
		/// dipose this view, and initialize target view, return false if failed
		public function swap( target:HUI_View ):Boolean
		{
			if ( ! active ) return false;
			
			if ( target.isActive ) return false;
			
			var parent_ref:DisplayObjectContainer = parentClip;
			
			trace ("swap",this,parent_ref);
			
			if ( ! dispose() ) return false;
			
			if ( ! target.initialize( parent_ref ) ) 
			{
				throw new Error( "Critical Error! target " + String( target ) + " view failed to initialize" );
				
				return false;
			}
			return true;
		}
		
		/// check if view is active 
		public function get isActive():Boolean 
		{
			return active;
		}
		
		/// load view control and add to display list, return false if fail
		public function initialize( parent:DisplayObjectContainer = null,interF=null,h="",clr="" ):Boolean 
		{
			if (interF != null) {
				HUI_View._data = interF;
			}
			if ( active ) return false;
						
			active = true;
			disposed = false;
			
			trace( this, "initialize",parent );
			
			disable_text( GFX );
			
			if ( parent != null ) parent.addChild( GFX );
			
			if ( parent ) 
			{
				//GFX.x = Math.round( ( parent.width - GFX.width ) / 2 );
				//GFX.y = Math.round( ( parent.height - GFX.height ) / 2 );
				GFX.x = Math.round( ( 900 - 891 ) / 2 );
				GFX.y = Math.round( ( 550 - 534 ) / 2 );
				
				parentClip = parent;
			}
			
			GFX.dino.gotoAndPlay ("Still0");
			GFX.dino.addEventListener(MouseEvent.CLICK,dinoClick,false,0,true);
			GFX.dino.buttonMode = true;
			
			return true;
		}
		
		public function dinoClick(e:MouseEvent):void
		{
			if (e.shiftKey) {
				
			} else {
				matchHat();
			}
		}
		
		private function matchHat ():void
		{
			if (data.hatMatcher[hat] == undefined)
				return;
			updateDino (data.hatMatcher[hat],hat);
			raptor = data.hatMatcher[hat];
		}
		
		/// remove from parent, disconnect events, return false if fail
		public function dispose( ):Boolean
		{
			if ( disposed ) return false;
			
			trace( this, "dispose", parent );
			
			active = false;
			disposed = true;
			
			while ( events.length > 0 ) 
			{
				var target:InteractiveObject = events.shift() as InteractiveObject;
				
				var type:String = events.shift() as String;
				
				var event:Function = events.shift() as Function;
				
				target.removeEventListener( type, event );
			}
							
			if ( parentClip ) parentClip.removeChild( GFX );
			
			return true;
		}
		
		//  ---- ----- ----- ----- ----- ----- ----- ----- ----- --------
		/// ::: \P\R\O\T\E\C\T\E\D\ ::: - ::: - ::: - :::
		//  ---- ----- ----- ----- ----- ----- ----- ----- ----- --------
		
		/// draw page indicators where current_index is zero based ~ count is not 
		public function render_page_indicators( canvas:Graphics,  
		startX:int, startY:int,  count:int, current_index:int  ):void 
		{
			
			canvas.clear();
			
			for ( var i:int = 0; i < count; ++i ) 
			{
				var drawX:int = startX - ( count - 1 - i ) * 22;
				var drawY:int = startY;
				
				canvas.beginFill( i == current_index ? 0xFFFFFF : 0xA19B8A );
				canvas.drawRect( drawX, drawY, 9, 9 );
				canvas.drawRect( drawX + 3, drawY + 3, 3, 3 );
				canvas.endFill();
			}
		}
		
		/// disable mouse of all text isntance inside target 
		public function disable_text( target:DisplayObjectContainer ):void
		{
			for ( var I:int = 0; I < target.numChildren; ++ I )
			{
				var child:DisplayObject = target.getChildAt( I );
				
				if ( child is TextField ) (child as TextField).mouseEnabled = false;
			}
		}
		
		/// cast target string to movieClip
		public function mc( target:String ):MovieClip
		{
			function mc_get( value:String, owner:* ):MovieClip
			{
				if ( ! owner.hasOwnProperty( value ) ) 
				
				throw new Error( value + " was not found in " + String( owner ) );
				
				else return owner[ value ] as MovieClip;
			}
			
			if ( target.indexOf('.') != -1 ) 
			{
				var chain:Array = target.split('.');
				
				var parent2:MovieClip = GFX;
				var child:MovieClip = null;
				
				while ( chain.length > 0 ) 
				{
					child = mc_get( chain.shift() as String, parent2 );
					
					parent2 = child;
				}
				
				return child;
			}
			
			else return mc_get( target, GFX );
		}
		
		/// assign on click event to movieclip target, callBack accepts 2 optional arguemnts ( target : *, shiftClick : Boolean ). If callBack is null, attempt to dispatch click event for target 
		public function mcClick( target:*, callBack:Function = null, hover:Boolean = false ):void
		{
			var mc:MovieClip;
			
			if( target is String ) mc = this.mc( target );
			else if ( target is MovieClip ) mc = target;
			else throw new Error( "target must be MovieClip or MovieClip name (string)" );
			
			var mcClick:Function = function( _:* ):void 
			{
				if ( callBack.length == 2 ) callBack( target, _.shiftKey );
				
				else callBack.length == 1 ? callBack( target ) : callBack( );
			};
			
			if ( callBack == null )
			{
				var callBackIndex:int = 0;
				
				while ( callBackIndex != -1 && events[ callBackIndex + 1 ] != 'click' ) 
				{
					callBackIndex = events.indexOf( mc, callBackIndex );
				}
				
				if ( callBackIndex == -1 ) 
				{
					trace( "failed to dispatch click event for", mc, mc.name, target );
					
					return;
				}
				
				// register temp call back reference 
				callBack = events[ callBackIndex + 2 ];
				
				trace( callBackIndex, callBack, target );
				
				// dispatch event 
				if ( callBack.length == 2 ) callBack( target, false );
				else callBack.length == 1 ? callBack( target ) : callBack() ;
				
				return;
			}
			
			mc.mouseChildren = false;
			mc.useHandCursor = true;
			mc.buttonMode = true;
			
			events.push( mc, 'click' , mcClick );
			
			mc.addEventListener('click', mcClick );
			
			if (hover) {
				mc.addEventListener(MouseEvent.MOUSE_OVER, function(e){mc.gotoAndStop (mc.currentFrame+4)});
				mc.addEventListener(MouseEvent.MOUSE_OUT, function(e){mc.gotoAndStop (mc.currentFrame-4)});
			}
		}
		
		/// assign any event to an InteractiveObject, callBack accepts 1 optional arguemnts ( target : InteractiveObject ) 
		public function ioEvent( target:InteractiveObject, event:String, callBack:Function ):void
		{
			var event_callBack:Function = function( _:* ):void 
			{
				callBack.length == 1 ? callBack( target ) : callBack( ) ;
			};
			
			events.push( target, event , event_callBack );
			
			target.addEventListener( event, event_callBack );
		}
		
		/// assign on any event to movieclip target, callBack accepts 1 optional arguemnts ( target : String )
		public function mcEvent( target:String, event:String, callBack:Function ):void
		{
			var mc:MovieClip = this.mc( target );
			
			var mc_event:Function = function( _:* ):void 
			{
				callBack.length == 1 ? callBack( target ) : callBack( ) ;
			};
			
			events.push( mc, event , mc_event );
			
			mc.addEventListener( event, mc_event );
		}
		
		/// Set similar value to list of object's inside target 
		public function mcListApply( target:String, list:Array, value:*, property:String = "? list item" ):void
		{
			var itemName:String = "''";
			
			for ( var i:int = 0 ; i < list.length; ++ i ) 
			{
				var item:MovieClip = mc( target );
				
				try 
				{
					if ( property == "? list item" ) item[ list[ i ] ] = value;
					
					else item[ list[ i ] ][ property ] = value;
					
					itemName = item.name;
				}
				
				catch ( e:Error ) { trace
				(
					"Did not assign value[", value
					, "] to object[", list[i]
					, "] with property [", property
					, "] for", String( item ), itemName
				);}
			}
		}
		
		/// target MovieClip from name, stop at given frame
		public function mcStop( target:String, at_frame:int ):void
		{
			mc( target ).gotoAndStop( at_frame );
		}
		
		/// hide hat, and color raptor 
		public function mcRaptor( dino:MovieClip, data:Object ):void
		{
			// toogle raptor parts visability
			dino['eye'].visible = data.eye.length > 0;
			dino['stripe'].visible = data.stripe.length > 0;
			dino['dot'].visible = data.dot.length > 0;
			dino['hat'].visible = false;
			
			// apply colors 
			mcColor( dino['main'], colorRgbToHex( data.body ) );
			mcColor( dino['head'], colorRgbToHex( data.body ) );
			if ( dino['dot'].visible ) mcColor( dino['dot'], colorRgbToHex( data.dot ) );
			if ( dino['eye'].visible ) mcColor( dino['eye'], colorRgbToHex( data.eye ) );
			if ( dino['stripe'].visible ) mcColor( dino['stripe'], colorRgbToHex( data.stripe ) );
		}
		
		/// display dino hat 
		public function mcHat( mc:MovieClip, hat:String ):void
		{
			mc.visible = true;
			
			// display first hat in the set of 5 
			mc.gotoAndStop( hat + (hat == "xx" ? "" : "1") );
		}
		
		/// apply color transformation onto display object, were colors is an RGB array with the range of [0,255]
		public function mcColors( object:DisplayObject, colors:Array ):void
		{
			// http://www.republicofcode.com/tutorials/flash/as3colortransform/
			var my_color:ColorTransform = new ColorTransform();
			my_color.alphaMultiplier = 1;
			my_color.blueOffset = colors[ 0 ];
			my_color.greenOffset = colors[ 1 ];
			my_color.redOffset = colors[ 2 ];
			
			object.transform.colorTransform = my_color;
		}
		
		/// apply color transformation onto display object, were color hex value 
		public function mcColor( object:DisplayObject, color:uint ):void
		{
			// http://www.republicofcode.com/tutorials/flash/as3colortransform/
			var my_color:ColorTransform = new ColorTransform();
			my_color.color = color;
			object.transform.colorTransform = my_color;
		}
		
		/// align target relative to it's wrapper and auto size if target's area is greater then it's wrapper
		/// ( note both object 'should' have a common parent )
		public function mcCenter( target:DisplayObject, targetWrapper:DisplayObject ):void
		{
			///// ISS#1
			//if ( target.width > targetWrapper.width || target.height > targetWrapper.height ) 
			//{
				//target.scaleX = target.scaleY = 0.8;
			//}
			
			var b1:Rectangle = target.getBounds( target.parent );
			var b2:Rectangle = targetWrapper.getBounds( targetWrapper.parent );
			
			target.x = Math.ceil(( b2.width - b1.width ) / 2 - ( b1.x - target.x ));
			target.y = Math.ceil(( b2.height - b1.height ) / 2 - ( b1.y - target.y ));
			
		}
		
		public function colorRgbToHex( rgb:Array ):uint
		{
			// http://stackoverflow.com/questions/5623838/rgb-to-hex-and-hex-to-rgb 
			// by @casablanca
			return (rgb[0] << 16) + (rgb[1] << 8) + rgb[2];
		}
		
		public function updateDino (clr,hat) {
			
			if (data.dColors[clr]!=undefined) {
				
				//dino colors
				var bodyC:Array=data.dColors[clr].body;
				var stripeC:Array=data.dColors[clr].stripe;
				var dotC:Array=data.dColors[clr].dot;
				var eyeC:Array=data.dColors[clr].eye;
				//
				GFX.dino.dot.visible=true;
				GFX.dino.stripe.visible=true;
				GFX.dino.head.stripe.visible=true;
				var ccB=new ColorChange (GFX.dino.main); ccB.cChange ([bodyC[0],bodyC[1],bodyC[2],1,1,1,1]);
				if (dotC.length>0) { var ccD=new ColorChange (GFX.dino.dot); ccD.cChange ([dotC[0],dotC[1],dotC[2],1,1,1,1]) } else { GFX.dino.dot.visible=false }
				if (stripeC.length>0) { var ccS=new ColorChange (GFX.dino.stripe); ccS.cChange ([stripeC[0],stripeC[1],stripeC[2],1,1,1,1]) } else { GFX.dino.stripe.visible=false }
				var ccH=new ColorChange (GFX.dino.head.main); ccH.cChange ([bodyC[0],bodyC[1],bodyC[2],1,1,1,1]);
				if (stripeC.length>0) { var ccHS=new ColorChange (GFX.dino.head.stripe); ccHS.cChange ([stripeC[0],stripeC[1],stripeC[2],1,1,1,1]) } else { GFX.dino.head.stripe.visible=false }
				var ccHE=new ColorChange (GFX.dino.head.eye); ccHE.cChange ([eyeC[0],eyeC[1],eyeC[2],1,1,1,1]);
				var ccE=new ColorChange (GFX.dino.eye); ccE.cChange ([eyeC[0],eyeC[1],eyeC[2],1,1,1,1]);
				
			}
			GFX.updater.hat=hat;
			
		}
	}
}