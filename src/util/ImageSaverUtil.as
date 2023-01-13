package util
{
	import com.adobe.images.PNGEncoder;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class ImageSaverUtil 
	{
		public static function scaleBitmapData(bitmapData:BitmapData, scale:Number):BitmapData {
			scale = Math.abs(scale);
			var width:int = (bitmapData.width * scale) || 1;
			var height:int = (bitmapData.height * scale) || 1;
			var transparent:Boolean = bitmapData.transparent;
			var result:BitmapData = new BitmapData(width, height, transparent);
			var matrix:Matrix = new Matrix();
			matrix.scale(scale, scale);
			result.draw(bitmapData, matrix);
			return result;
		}
		
		public static var id:int = 0;
		
		public static function saveAsPNG(bmpData:BitmapData):void
		{
			id++;
			
			var bmp = scaleBitmapData(bmpData,6);
			
			var byteArray:ByteArray = PNGEncoder.encode(bmp);
			var fileRef:FileReference = new FileReference();
			
			var dateString:String = _getYYMMDD();
			var saveName:String = "DinoPortrait_" + dateString + "_"+id+".png";
			fileRef.save(byteArray, saveName);
		}
		
		//current date function
		private static function _getYYMMDD():String
		{
			var dateObj:Date = new Date();
			var year:String = String(dateObj.getFullYear());
			var month:String = String(dateObj.getMonth() + 1);
			if (month.length == 1) {
				month = "0"+month;
			}
			var date:String = String(dateObj.getDate());
			if (date.length == 1) {
				date = "0"+date;
			}
			return year.substring(0, 4)+"_"+month+"_"+date;
		}
		
	}
	
}