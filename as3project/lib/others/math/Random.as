
/**		
 * 
 *	Random
 *	
 *	@version 1.00 | Feb 7, 2010
 *	@author Justin Windle
 *  
 **/
 
package math 
{

	/**
	 * Random
	 */
	public class Random 
	{

		//	----------------------------------------------------------------
		//	CONSTANTS
		//	----------------------------------------------------------------

		private static var _num : Number = 1.0;
		private static var _seed : Number = 1.0;

		//	----------------------------------------------------------------
		//	METHODS
		//	----------------------------------------------------------------

		public static function randomSeed() : void
		{
			seed = Math.random() * 2147483647;
			trace("seed: " + _seed);
		}

		public static function next() : Number
		{
			_num = ( _num * 16807 ) % 2147483647;
			return _num * 4.656612875245797e-10;
		}

		public static function float( min : Number, max : Number = NaN ) : Number
		{
			if ( isNaN(max) )
			{
				max = min;
				min = 0;
			}
			
			return next() * ( max - min ) + min;
		}

		public static function integer( min : Number, max : Number = NaN ) : int
		{
			if ( isNaN(max) )
			{
				max = min;
				min = 0;
			}
			
			return int( (next() * ( max - min ) + min) + 0.5 );
		}

		public static function bool(chance : Number = 0.5) : Boolean
		{
			return Random.next() < chance;
		}

		public static function sign(change : Number = 0.5) : int
		{
			return next() < change ? 1 : -1;
		}

		public static function obj(list : Array) : *
		{
			return list[ int(next() * list.length) ];
		}

		//	----------------------------------------------------------------
		//	ACCESSORS
		//	----------------------------------------------------------------

		public static function get seed() : Number
		{
			return _seed;
		}

		public static function set seed(value : Number) : void
		{
			_seed = _num = value;
		}
	}
}