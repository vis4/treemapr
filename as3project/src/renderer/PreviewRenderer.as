package renderer 
{
	import config.TreeMapConfig;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import math.Random;
	import net.vis4.color.Color;
	import net.vis4.text.fonts.SystemFont;
	import net.vis4.text.Label;
	import net.vis4.treemap.data.Tree;
	import net.vis4.treemap.data.TreeNode;
	import net.vis4.treemap.display.Sprite3;
	import net.vis4.treemap.TreeMap;
	import ui.MiniTreemap;
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
		protected var _lastTreeMap:TreeMap;
		
		override public function render(tree:Tree, bounds:Rectangle, tmconfig:TreeMapConfig):void 
		{
			// ignore bounds
			bounds = _container.stage ? new Rectangle(_left, _top, _container.stage.stageWidth - _left - _right, _container.stage.stageHeight - _top - _bottom) : bounds;
			
			super.render(tree, bounds, tmconfig);
			
			// remove old treemap
			if (_lastTreeMap !== null) {
				_container.removeChild(_lastTreeMap);
			} else {
				if (_container.stage) _container.stage.addEventListener(Event.RESIZE, onResize);
			}
			
			
			
			var treemap:TreeMap = new TreeMap(tree, bounds, getLayout(tmconfig.layout), renderNode, renderBranch);
			
			_container.addChild(treemap);
			
			// save for on-resize renderin
			_lastTree = tree;
			_lastTreeMap = treemap;
			
			treemap.render(_lastConfig.maxDepth);
		}
		
		protected var _labelCache:Array = [];
		
		
		
		protected function onResize(e:Event):void 
		{
			render(_lastTree, null, _lastConfig);
		}
		
		override protected function renderNode(node:TreeNode, container:Sprite, level:uint):void 
		{
			var col:uint = getNodeColor(node, level);	
			var g:Graphics = container.graphics;
			if (_lastConfig.border > 0) {
				g.lineStyle(_lastConfig.border, Color.fromInt(col,'hsv').value('*.6')._int);
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
			
			if (_lastConfig.showLabels) {
				var label:Label = new Label(node.data[_lastConfig.labelProperty], new SystemFont( { name: _lastConfig.labelFont, size: _lastConfig.labelSize, color: _lastConfig.labelColor } )).place(0, 0, container);
				
				switch (_lastConfig.labelHorzAlign) {
					case 'left': 	label.x = node.layout.x+2; break;
					case 'center': label.x = node.layout.x + (node.layout.width - label.width) * .5; break;
					case 'right': 	label.x = node.layout.x-2 + node.layout.width - label.width; break;
				}
				switch (_lastConfig.labelVertAlign) {
					case 'top': 	label.y = node.layout.y+2; break;
					case 'middle': label.y = node.layout.y + (node.layout.height - label.height) * .5; break;
					case 'bottom': label.y = node.layout.y -2+ node.layout.height - label.height; break;
				}
				
				var mask:Shape = new Shape();
				mask.graphics.beginFill(0xff0000);
				mask.graphics.drawRect(node.layout.x+2, node.layout.y+2, node.layout.width-4, node.layout.height-4);
				label.mask = mask;
			}
			
			
		}
		
		override protected function renderBranch(node:TreeNode, container:Sprite3, level:uint):void 
		{
			
			node.layout.color = getNodeColor(node, level);
		}
		
	}

}