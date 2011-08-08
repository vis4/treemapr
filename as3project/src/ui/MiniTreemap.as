package ui 
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import net.vis4.color.Color;
	import net.vis4.treemap.data.Tree;
	import net.vis4.treemap.data.TreeNode;
	import net.vis4.treemap.TreeMap;
	/**
	 * ...
	 * @author gka
	 */
	public class MiniTreemap extends Sprite
	{
		protected var _bounds:Rectangle;
		protected var _values:Array;
		
		public function MiniTreemap(values:Array, bounds:Rectangle) 
		{
			_values = values;
			_bounds = bounds;
			
			var sum:Number = 0;
			for each (var val:Number in values) {
				sum += val;
			}
			
			var root:TreeNode = new TreeNode( { }, sum);
			for each (val in values) {
				root.addChild(new TreeNode( { }, val));
				
			}
			var tree:Tree = new Tree(root);
			var treemap:TreeMap = new TreeMap(
				tree, 
				bounds, 
				TreeMap.SQUARIFY_LAYOUT,
				renderNodes
			);
			addChild(treemap);
			treemap.render();
		}
		
		private var nodeIndex:uint = 0;
		
		protected function renderNodes(node:TreeNode, container:Sprite, level:uint):void 
		{
			var col:uint = Color.fromHSL(nodeIndex++ / _values.length * 180+180, .8, .7)._int;
			container.graphics.lineStyle(1, 0);
			container.graphics.beginFill(col);
			container.graphics.drawRect(node.layout.x, node.layout.y, node.layout.width, node.layout.height);
			
			trace('rendering ' + node);
		}
		
	}

}