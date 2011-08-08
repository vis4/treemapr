package data 
{
	import ui.MiniTreemap;
	/**
	 * ...
	 * @author gka
	 */
	public class DataDescription 
	{
		protected var _nested:Boolean;
		protected var _columns:Array;
		protected var _childrenProperty:String;
		protected var _labelColumn:uint;
		protected var _weightColumn:uint;
		
		public function DataDescription(nested:Boolean, columns:Array, childrenProperty:String) 
		{
			_childrenProperty = childrenProperty;
			_columns = columns;
			_nested = nested;
			
		}
		
		public function get nested():Boolean 
		{
			return _nested;
		}
		
		public function get columns():Array 
		{
			return _columns;
		}
		
		public function get childrenProperty():String 
		{
			return _childrenProperty;
		}
		
	}
}