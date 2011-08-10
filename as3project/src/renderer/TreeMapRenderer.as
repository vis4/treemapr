package renderer 
{
	import config.TreeMapConfig;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import math.Random;
	import net.vis4.color.Color;
	import net.vis4.treemap.data.Tree;
	import net.vis4.treemap.data.TreeNode;
	import net.vis4.treemap.display.Sprite3;
	import net.vis4.treemap.TreeMap;
	/**
	 * ...
	 * @author gka
	 */
	public class TreeMapRenderer 
	{
		
		public function render(tree:Tree, bounds:Rectangle, tmconf:TreeMapConfig):void
		{
			// override me!
			_lastConfig = tmconf;
		}
		
		protected var _lastConfig:TreeMapConfig;
		
		protected function getLayout(lay:String):String
		{
			switch (lay) {
				case 'squarify': 
				default: return TreeMap.SQUARIFY_LAYOUT;
				case 'slice and dice': return TreeMap.SLICE_AND_DICE_LAYOUT;
				case 'strip': return TreeMap.STRIP_LAYOUT;
			}
		}
		
		protected function getNodeColor(node:TreeNode, level:uint):uint
		{
			switch (_lastConfig.colorMode) {
				case 'single': default: return _lastConfig.singleColor;
				case 'random': 
					if (node.hasChildren) return Color.fromHSV(Random.integer(0, 360), .8, .65)._int;
					return Color.fromInt(node.parent.layout.color).lightness('*' + (.9 + Random.next() * .2))._int; 
				case 'rainbow':
					
					if (node.parent == null) {
						node.data.rainbowMinHue = 0;
						node.data.rainbowMaxHue = 360;
					} else {
						var parent:TreeNode = node.parent, 
							 childHueRange:Number = (parent.data.rainbowMaxHue - parent.data.rainbowMinHue) / parent.children.length;
						node.data.rainbowMinHue = 
							parent.data.rainbowMinHue + parent.children.indexOf(node)*childHueRange;
						node.data.rainbowMaxHue = node.data.rainbowMinHue + childHueRange;
						trace(node.data.name, node.data.rainbowMinHue, node.data.rainbowMaxHue, childHueRange);
					}
					
					return Color.fromHSV(node.data.rainbowMinHue+(node.data.rainbowMaxHue-node.data.rainbowMinHue)*.5, .8, .65)._int;
			}
		}
		
		protected function renderNode(node:TreeNode, container:Sprite, level:uint):void
		{
			// override me
		}
		
		protected function renderBranch(node:TreeNode, container:Sprite3, level:uint):void
		{
			// override me
		}
		
	}

}