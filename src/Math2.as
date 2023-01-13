package  {
	import Box2D.Common.Math.b2Vec2;
	
	import flash.geom.Point;

	public class Math2 {
		
		public static const DEG2RAD:Number = Math.PI/180;
		public static const RAD2DEG:Number = 180/Math.PI;
		public static const CIRCLE_RAD:Number = Math.PI * 2;
		public static const ANGLE_U:Number = Math.PI * 1.5;
		public static const ANGLE_L:Number = Math.PI;
		public static const ANGLE_D:Number = Math.PI * 0.5;
		public static const ANGLE_R:Number = 0;
		
		public function Math2 () {}
		
		public static function dampen(x:Number, factor:Number, dt:Number):Number {
			var absx:Number = Math.abs(x);
			//A = A - A * (1-factor)*dt
			absx *= (1 - (1-factor)*dt);
			if(absx < 0) return 0;
			else return x<0 ? -absx : absx;
		}
		
		public static function clamp (num:Number, min:Number, max:Number):Number
		{
			if (num < min)
				return min;
			if (num > max)
				return max;
			return num;
		}		
		
		public static function clampInt (num:int, min:int, max:int):int
		{
			if (num < min)
				return min;
			if (num > max)
				return max;
			return num;
		}
		
		public static function cosineCurve (step:Number, stepMax:Number):Number
		{
			return 1-(Math.cos(step/stepMax * Math.PI) + 1)/2
		}
		
		public static function easeIn (t:Number, b:Number, c:Number, d:Number):Number {
			return c*(t/=d)*t*t + b;
		}
		
		public static function easeOut (t:Number, b:Number, c:Number, d:Number):Number {
			return c*((t=t/d-1)*t*t + 1) + b;
		}
		
		public static function easeInOut (t:Number, b:Number, c:Number, d:Number):Number {
			if ((t/=d/2) < 1) return c/2*t*t*t + b;
			return c/2*((t-=2)*t*t + 2) + b;
		}
		
		public static function easeInX (t:Number, b:Number, c:Number, d:Number):Number {
			return (t==0) ? b : c * Math.pow(2, 10 * (t/d - 1)) + b;
		}
		public static function easeOutX (t:Number, b:Number, c:Number, d:Number):Number {
			return (t==d) ? b+c : c * (-Math.pow(2, -10 * t/d) + 1) + b;
		}
		public static function easeInOutX (t:Number, b:Number, c:Number, d:Number):Number {
			if (t==0) return b;
			if (t==d) return b+c;
			if ((t/=d/2) < 1) return c/2 * Math.pow(2, 10 * (t - 1)) + b;
			return c/2 * (-Math.pow(2, -10 * --t) + 2) + b;
		}

		public static function translate (num:Number,min1:Number,max1:Number,min2:Number,max2:Number,clamp:Boolean = false):Number 
		{
			var val:Number = ((num-min1)/(max1-min1)*(max2-min2))+min2;
			return clamp ? (min2 < max2 ? Math2.clamp (val,min2,max2) : Math2.clamp (val,max2,min2)) : val;
		}
		
		/*public static function getAngleBetween(vector1:b2Vec2, vector2:b2Vec2):Number
		{
			return Math.atan2((vector1.y - vector2.y),(vector1.x - vector2.x)) * RAD2DEG;
		}
		
		public static function getAngleBetweenRAD(vector1:b2Vec2, vector2:b2Vec2):Number
		{
			return Math.atan2((vector1.y - vector2.y),(vector1.x - vector2.x));
		}
		
		public static function interpolate(v1:b2Vec2, v2:b2Vec2, f:Number):b2Vec2
		{
			var p:Point = Point.interpolate(new Point(v1.x,v1.y), new Point(v2.x,v2.y), 1-f);
			return new b2Vec2 (p.x,p.y);
		}*/
		
		public static function toStandardAngleDEG(ang:Number):Number
		{
			var a:Number = 360-(((ang%=360)<0) ? ang+360 : ang);
			return (a==360) ? 0 : a;
		}
		
		public static function toStandardAngleRAD(ang:Number):Number
		{
			var c:Number = Math.PI * 2;
			var a:Number = c-(((ang%=c)<0) ? ang+c : ang);
			return (a==c) ? 0 : a;
		}
		
		/*public static  function getDistance (p1:b2Vec2, p2:b2Vec2):Number
		{
			var x:Number = p1.x - p2.x;
			var y:Number = p1.y - p2.y;
			return Math.sqrt(x*x + y*y);
		}
		
		public static  function getDistanceFast (p1:b2Vec2, p2:b2Vec2):Number
		{
			var x:Number = p1.x - p2.x;
			var y:Number = p1.y - p2.y;
			return x*x + y*y;
		}
		
		public static function getAngleFromVector(vector:b2Vec2):Number
		{
			return Math.atan2(vector.y,vector.x) * RAD2DEG;
		}*/
		
		static public function randInt(min:int, max:int):int 
		{
			return (Math.floor(Math.random()*(max-min+.99))+min);
		}
		
		static public function randNum(min:Number, max:Number):Number 
		{
			return (Math.round(((Math.random()*(max-min))+min)*1000))/1000;
		}
		
		static public function roundTo (num:Number, to:Number):Number 
		{
			return Math.round(num/to)*to;
		}
		
	}

}