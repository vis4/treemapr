package renderer 
{
	import config.TreeMapConfig;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import net.vis4.color.Color;
	import net.vis4.treemap.data.Tree;
	import net.vis4.treemap.data.TreeNode;
	import net.vis4.treemap.display.Sprite3;
	import net.vis4.treemap.TreeMap;
	import net.vis4.utils.FileUtil;
	import org.alivepdf.colors.RGBColor;
	import org.alivepdf.fonts.CoreFont;
	import org.alivepdf.fonts.FontFamily;
	import org.alivepdf.layout.Align;
	import org.alivepdf.layout.Orientation;
	import org.alivepdf.layout.Size;
	import org.alivepdf.layout.Unit;
	import org.alivepdf.pdf.PDF;
	import org.alivepdf.saving.Method;
	/**
	 * ...
	 * @author gka
	 */
	public class PDFRenderer extends TreeMapRenderer
	{
		protected var _pdf:PDF;
		protected var scale:Number;
		
		override public function render(tree:Tree, bounds:Rectangle, tmconf:TreeMapConfig):void 
		{
			var pageSize:Size = Size.A4;
			_pdf = new PDF(bounds.width > bounds.height ? Orientation.LANDSCAPE : Orientation.PORTRAIT, Unit.MM, pageSize);
			scale = 0;
			var left:Number = 0;
			var top:Number = 0;
			var pageBorder:Number = 10;;
			trace(Size.A4.mmSize);
			
			if (bounds.width > bounds.height) {
				// landscape
				scale = Math.min((pageSize.mmSize[1] - pageBorder * 2) / bounds.width, (pageSize.mmSize[0] - pageBorder * 2) / bounds.height);
				left = (pageSize.mmSize[1] - scale * bounds.width) * .5;
				top = (pageSize.mmSize[0] - scale * bounds.height) * .5;
			} else {
				// portrait
				scale = Math.min((pageSize.mmSize[0] - pageBorder * 2) / bounds.width, (pageSize.mmSize[1] - pageBorder * 2) / bounds.height);
				left = (pageSize.mmSize[0] - scale * bounds.width) * .5;
				top = (pageSize.mmSize[1] - scale * bounds.height) * .5;
			}
			
			
			
			bounds = new Rectangle(left, top, bounds.width * scale, bounds.height * scale);
			_pdf.addPage();
			_pdf.setAutoPageBreak(false, 0);
			/*
			_pdf.lineStyle(new RGBColor(tmconf.border), 0.2);
			_pdf.beginFill(new RGBColor(tmconf.singleColor));
			_pdf.drawRect(new Rectangle(bounds.left, bounds.top, bounds.width, bounds.height));
			//_pdf.drawRect(new Rectangle(left, top, bounds.width*scale, bounds.height*scale));
			
			_pdf.setFont(new CoreFont(FontFamily.ARIAL), tmconf.labelSize, false);
			//pdf.setFontSize(tmconf.labelSize);
			_pdf.textStyle(new RGBColor(tmconf.labelColor));
			_pdf.addText('Hello World', 10, 10);//
			var ba:ByteArray = _pdf.save(Method.LOCAL);
			FileUtil.send('treemap.pdf', ba);
			return;
			*/
			var treemap:TreeMap = new TreeMap(tree, bounds, getLayout(tmconf.layout), renderNode, renderBranch); 
			
			super.render(tree, bounds, tmconf);
			
			treemap.render(tmconf.maxDepth);
			
			var ba:ByteArray = _pdf.save(Method.LOCAL);
			FileUtil.send('treemap.pdf', ba);
			
		}
		
		override protected function renderNode(node:TreeNode, container:Sprite, level:uint):void 
		{
			var col:uint = getNodeColor(node, level);	
			
			if (_lastConfig.border > 0) {
				//_pdf.lineStyle(new RGBColor(tmconf.border), _lastConfig.border*.2);
				_pdf.lineStyle(new RGBColor(Color.fromInt(col, 'hsv').value('*.6')._int), _lastConfig.border * 0.25);
				
			} else {
				
			}
			_pdf.beginFill(new RGBColor(col));
						
			var size:Rectangle = node.layout.bounds.clone();
			
			if (_lastConfig.padding > 0) {
				size.inflate(-_lastConfig.padding, -_lastConfig.padding);
			}
			
			if (_lastConfig.borderRadius == 0) {
				_pdf.drawRect(size);
			} else {				
				_pdf.drawRoundRect(size, _lastConfig.borderRadius);
			}
			
			// node labels
			if (_lastConfig.showLabels) {
				
				var ly:Number = 0, lh:Number, textHeight:Number = _lastConfig.labelSize * scale * 1.75;
				
				
				switch (_lastConfig.labelVertAlign) {
					case 'top': 	ly = node.layout.y+1; lh = textHeight; break;
					case 'middle': ly = node.layout.y; lh = node.layout.height; break;
					case 'bottom': ly = node.layout.y+ node.layout.height - textHeight; lh = textHeight; break;
				}
				
				_pdf.setXY(node.layout.x, ly);
				_pdf.textStyle(new RGBColor(_lastConfig.labelColor));
				_pdf.setFont(new CoreFont(FontFamily.ARIAL), _lastConfig.labelSize*scale*3.5, false);
				_pdf.addCell(node.layout.width, lh, node.data[_lastConfig.labelProperty], 0, 0, _lastConfig.labelHorzAlign == 'left' ? Align.LEFT : _lastConfig.labelHorzAlign == 'center' ? Align.CENTER : Align.RIGHT);
			}
		}
		
		override protected function renderBranch(node:TreeNode, container:Sprite3, level:uint):void 
		{
			
			node.layout.color = getNodeColor(node, level);
		}
	}

}