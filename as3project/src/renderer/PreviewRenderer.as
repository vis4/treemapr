package renderer 
{
	import config.TreeMapConfig;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
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
	public class PreviewRenderer extends TreeMapRenderer
	{
		protected var _container:Sprite;
		protected var _top:Number;
		protected var _right:Number;
		protected var _bottom:Number;
		protected var _left:Number;
		
		public function PreviewRenderer(container:Sprite, top:Number, right:Number, bottom:Number, left:Number) 
		{
			_left = left;
			_bottom = bottom;
			_right = right;
			_top = top;
			_container = container;
			
		}
		
		protected var _lastTree:Tree;
		protected var _lastConfig:TreeMapConfig;
		protected var _lastTreeMap:TreeMap;
		
		override public function render(tree:Tree, bounds:Rectangle, tmconfig:TreeMapConfig):void 
		{
			// ignore bounds
			bounds = new Rectangle(_left, _top, _container.stage.stageWidth - _left - _right, _container.stage.stageHeight - _top - _bottom);
			
			// remove old treemap
			if (_lastTreeMap) {
				_container.removeChild(_lastTreeMap);
			} else {
				_container.stage.addEventListener(Event.RESIZE, onResize);
			}
			
			var treemap:TreeMap = new TreeMap(tree, bounds, tmconfig.layout, renderNode, renderBranch);
			_container.addChild(treemap);
			
			// save for on-resize rendering
			_lastConfig = tmconfig;
			_lastTree = tree;
			_lastTreeMap = treemap;
			
			treemap.render();
		}
		
		protected function onResize(e:Event):void 
		{
			render(_lastTree, null, _lastConfig);
		}
		
		protected function renderNode(node:TreeNode, container:Sprite, level:uint):void 
		{
			var col:uint = Color.fromInt(node.parent.layout.color).lightness('*' + (.9 + Math.random() * .2))._int;
			var g:Graphics = container.graphics;
			if (_lastConfig.border > 0) {
				g.lineStyle(_lastConfig.border, 0);
			} else {
				g.lineStyle();
				
			}
			g.beginFill(col);
			
			var size:Rectangle = node.layout.bounds.clone();
			
			if (_lastConfig.padding > 0) {
				size.inflate(-_lastConfig.padding, -_lastConfig.padding);
			}
			
			if (_lastConfig.borderRadius == 0) {
				g.drawRect(size.left, size.top, size.width, size.height);
			} else {
				g.drawRoundRect(size.left, size.top, size.width, size.height, _lastConfig.borderRadius, _lastConfig.borderRadius);
			}
			
			
		}
		
		protected function renderBranch(node:TreeNode, container:Sprite3, level:uint):void 
		{
			var col:uint =  Color.fromHSV(Random.integer(120, 360), .8, .65)._int;
			node.layout.color = col;
		}
		
	}

}