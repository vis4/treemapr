package config 
{
	import flash.errors.ScriptTimeoutError;
	import ui.MiniTreemap;
	/**
	 * ...
	 * @author gka
	 */
	public class TreeMapConfig 
	{
		public var layout:String = 'squarify';
		
		public var showLabels:Boolean = true;
		
		public var labelFont:String = 'Arial';
		
		public var labelColor:uint = 0xffffff;
		
		public var labelSize:Number = 12;
		
		public var labelHorzAlign:String = 'left';
		
		public var labelVertAlign:String = 'top';
		
		public var border:Number = 1;
		
		public var borderRadius:Number = 0;
		
		public var padding:Number = 0;
		
		public var colorMode:String = 'single';
		
		public var singleColor:uint = 0xcccccc;
		
		public var labelProperty:String = 'name';
		
		public var maxDepth:uint = 1;
		
	}

}