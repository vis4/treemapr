package 
{
	import assets.font.Lato;
	import assets.font.RondaSeven;
	import com.adobe.images.PNGEncoder;
	import com.adobe.serialization.json.JSON;
	import com.bit101.components.CheckBox;
	import com.bit101.components.ColorChooser;
	import com.bit101.components.ComboBox;
	import com.bit101.components.Component;
	import com.bit101.components.HBox;
	import com.bit101.components.InputText;
	import com.bit101.components.PushButton;
	import com.bit101.components.RadioButton;
	import com.bit101.components.Style;
	import com.bit101.utils.MinimalConfigurator;
	import config.TreeMapConfig;
	import data.DataDescription;
	import data.TreeImporter;
	import data.XMLTreeImporter;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Rectangle;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.Font;
	import flash.text.FontStyle;
	import flash.text.FontType;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	import math.Random;
	import net.vis4.text.Label;
	import net.vis4.treemap.data.Tree;
	import net.vis4.treemap.data.TreeNode;
	import net.vis4.utils.DelayedTask;
	import net.vis4.utils.FileUtil;
	import org.alivepdf.encoding.JPEGEncoder;
	import renderer.PDFRenderer;
	import renderer.PreviewRenderer;
	import ui.MiniTreemap;
	import ui.Section;
	import ui.TreemaprLogo;

	
	/**
	 * ...
	 * @author gka
	 */
	public class Main extends Sprite 
	{
		protected var conf:MinimalConfigurator;
		protected var randomValues:Array;
		protected var fileRef:FileReference;
		protected var sections:Array = [];
		protected var sectionsById:Object = { };
		protected var _demoTree:Tree;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			stage.scaleMode = 'noScale';
			stage.align = 'TL';
			
			new TreemaprLogo(this);
			
			Style.setStyle(Style.BLACK);
			//Style.fontName = 'Lato Normal';
			//Style.fontSize = 11;
			
			var ldr:URLLoader = new URLLoader();
			ldr.addEventListener(Event.COMPLETE, onUiXmlLoaded);
			ldr.load(new URLRequest('ui/ui.xml'));
			
			
			
			/*var treemapConfig:TreeMapConfig = new TreeMapConfig();
			
			treemapConfig.padding = 0;
			treemapConfig.border = 1;
			
			var preview:PreviewRenderer = new PreviewRenderer(this, 10, 10, 10, 222);
			var t:Number = new Date().time;
			preview.render(randomTree(), null, treemapConfig);
			trace('rendering took ' + ((new Date().time - t)) + ' ms');
//			cbLayout.items = ['squarify', 'slice and dice', 'strip'];

			var xml1:XML = 
				<node language="de">
					<id>23</id>
					<name>Foobar</name>
					<children>
						<node>
							<id>231</id>
							<name>Child1</name>
							<fooo>Bar</fooo>
							<children>
								<node>
									<id>231</id>
									<name>Child1</name>
									<test>Bar</test>
								</node>
							</children>
						</node>
					</children>
				</node>;
				
			var xml2:XML = 
				<nodes>
					<node>
						<id>23</id>
						<name>Foobar</name>
					</node>
					<node>
						<id>231</id>
						<name>Child1</name>
						<parent>23</parent>
					</node>
				</nodes>;
				
			var xml3:XML = 
				<node id="1" size="23" label="Foo">
					<node id="1.1" size="23" label="Foo">						
					</node>
					<node id="1.2" size="23" label="Foo">						
					</node>
					<node id="1.3" size="23" test="test" label="Foo">	
						<node id="1.1" size="23" foo="bar" label="Foo">						
						</node>
					</node>					
				</node>;
				
			trace(XMLTreeImporter.describeData(xml1));
			trace(XMLTreeImporter.describeData(xml2));
			trace(XMLTreeImporter.describeData(xml3));
			*/
		}
		
		
		
		protected function onUiXmlLoaded(e:Event):void 
		{
			var raw:String = URLLoader(e.target).data;
			
			try {
				var uixml:XML = new XML(raw);
				for each (var sectXML:XML in uixml..comp) {
					var section:Section = new Section(sectXML.@title, sectXML, sectXML.@open == "true");
					addChild(section);
					section.addEventListener(Event.RESIZE, onSectionResize);
					sectionsById[String(sectXML.@title).toLowerCase()] = section;
					sections.push(section);
				}
				layoutSections();
				
			
			} catch (e:Error) {
				trace('Error while parsing ui xml');
				return;
			}
			
			initGuiEvents();
			
			loadDemoData();
			
		}
		
	
		
		protected function onSectionResize(e:Event = null):void 
		{
			new DelayedTask(33, this, layoutSections);
		}
		
		protected function initGuiEvents():void 
		{
			CB('customize.layout').items = ['squarify', 'strip', 'slice and dice'];
			CB('customize.layout').selectedIndex = 0;
			CB('customize.layout').addEventListener(Event.SELECT, updateTreeMap);
			
			CB("customize.colorMode").items = ['single', 'random', 'by value'];
			
			CHK("customize.showLabels").selected = true;
			CHK("customize.showLabels").addEventListener(Event.CHANGE, onShowLabelsChange);
			CHK("customize.showLabels").addEventListener(Event.CHANGE, updateTreeMap);
			CB('customize.layout').addEventListener(Event.CHANGE, updateTreeMap);
			
			CB("customize.lblVert").items = ['top', 'middle', 'bottom'];
			CB("customize.lblVert").selectedIndex = 0;;
			CB('customize.lblVert').addEventListener(Event.SELECT, updateTreeMap);
			CB("customize.lblHorz").items = ['left', 'center', 'right'];
			CB("customize.lblHorz").selectedIndex = 0;
			CB('customize.lblHorz').addEventListener(Event.SELECT, updateTreeMap);
			CB("customize.lblFont").items = getDeviceFonts();  
			CB('customize.lblFont').selectedItem = 'Arial';
			CB('customize.lblFont').addEventListener(Event.SELECT, updateTreeMap);
			IT('customize.lblFontSize').addEventListener(Event.CHANGE, updateTreeMap);
			CS('customize.lblColor').addEventListener(Event.CHANGE, updateTreeMap);
			
			CB('customize.colorMode').addEventListener(Event.SELECT, onColorModeChange);
			CB('customize.colorMode').selectedIndex = 0;
			CB('customize.colorMode').addEventListener(Event.SELECT, updateTreeMap);
			CS('customize.singleColor').addEventListener(Event.CHANGE, updateTreeMap);
			
			CB('customize.colorScale').items = ['cool', 'hot', 'ramp', 'diverging']; 
			CB('customize.colorScale').addEventListener(Event.SELECT, onColorScaleChange);
			CB('customize.colorScale').selectedIndex = 0;
			
			/*
			 * EXPORT
			 */
			
			PB('export.btnExport').addEventListener(MouseEvent.CLICK, exportTreeMap);
			
			new DelayedTask(333, this, layoutSections);
		}
			
		protected function loadDemoData():void 
		{
			var ldr:URLLoader = new URLLoader();
			ldr.addEventListener(Event.COMPLETE, onDemoDataLoaded);
			ldr.load(new URLRequest('flare.json'));
		}
		
		protected function onDemoDataLoaded(e:Event):void 
		{
			var jsondata:Object = JSON.decode(URLLoader(e.target).data);
			
			_demoTree = new Tree(parseFlareTree(jsondata));
			
			CB('customize.colorValue').items = _dataColumns;
			
			updateTreeMap();
			
		}
		
		protected var _dataColumns:Array = [];
		protected var preview:PreviewRenderer;
		
		protected function parseFlareTree(jsondata:Object):TreeNode 
		{
			var node:TreeNode = new TreeNode(jsondata, jsondata.children ? 0 : jsondata.size);
			node.data.classes = jsondata.children ? 0 : 1;
			
			for (var v:String in node.data) {
				if (_dataColumns.indexOf(v) < 0) _dataColumns.push(v);
			}
			for each (var childData:Object in jsondata.children) {
				var child:TreeNode = parseFlareTree(childData);
				node.weight += child.weight;
				node.addChild(child);
				node.data.classes += child.data.classes;
			}
			return node;
		}
		
		protected function getCurrentTreeMapConfig():TreeMapConfig
		{
			var tmconf:TreeMapConfig = new TreeMapConfig();
			tmconf.showLabels = CHK('customize.showLabels').selected;
			tmconf.labelColor = CS('customize.lblColor').value;
			tmconf.labelFont = String(CB('customize.lblFont').selectedItem);
			tmconf.labelHorzAlign = String(CB('customize.lblHorz').selectedItem);
			tmconf.labelVertAlign = String(CB('customize.lblVert').selectedItem);
			tmconf.labelSize = Number(IT('customize.lblFontSize').text);
			tmconf.layout = String(CB('customize.layout').selectedItem);
			
			tmconf.colorMode = String(CB('customize.colorMode').selectedItem);
			tmconf.singleColor = CS('customize.singleColor').value;
			
			return tmconf;
		}
		
		protected function updateTreeMap(e:Event = null):void
		{
			preview = preview !== null ? preview : new PreviewRenderer(this, 10, 10, 10, 222);
			preview.render(_demoTree, null, getCurrentTreeMapConfig());
		}
		
		
		protected function onColorModeChange(e:Event):void 
		{
			Comp('customize.colorMode-scale').visible = CB("customize.colorMode").selectedIndex == 2;
			Comp('customize.colorMode-single').visible = CB("customize.colorMode").selectedIndex == 0;
			Comp('customize.colorMode-random').visible = CB("customize.colorMode").selectedIndex == 1;
		}
		
		protected function onColorScaleChange(e:Event):void 
		{
			Comp('customize.colorMode-scale-ramp').visible = CB("customize.colorScale").selectedIndex == 2;
			Comp('customize.colorMode-scale-diverging').visible = CB("customize.colorScale").selectedIndex == 3;
			
		}
		
		/*
		 * function taken from http://hasseg.org/blog/post/526/getting-a-list-of-installed-fonts-with-flash-and-javascript/
		 */
		protected function getDeviceFonts():Array
		{
			var embeddedAndDeviceFonts:Array = Font.enumerateFonts(true);
		  
			var deviceFontNames:Array = [];
			for each (var font:Font in embeddedAndDeviceFonts)
			{
				 if (font.fontType == FontType.EMBEDDED
					  || font.fontStyle != FontStyle.REGULAR
					  )
					  continue;
				 deviceFontNames.push(font.fontName);
			}
		  
			deviceFontNames.sort();
			return deviceFontNames;
		}
		
		protected function onShowLabelsChange(e:Event):void 
		{
			var sl:Boolean = CHK("customize.showLabels").selected;
			Comp("customize.lblVert").enabled = sl;
			Comp("customize.lblHorz").enabled = sl;
			Comp("customize.lblColor").enabled = sl;
		}
		
		protected function layoutSections(e:Event=null):void 
		{
			var yo:Number = 70;
			for each (var s:Section in sections) {
				s.y = Math.round(yo);
				yo += s.height + 30;
				
			}
		}
		
		
		protected function exportTreeMap(e:MouseEvent):void 
		{
			var format:String = RadioButton.getGroupValue('exportFormat');
			trace('exporting to ' + format);
			
			var w:Number = Number(IT('export.width').text),
				 h:Number = Number(IT('export.height').text);
			
			switch (format) {
				case 'PNG':
				case 'JPG':
					exportAsImage(format, w, h); break;
				case 'PDF':
					exportPDF(w, h); break;
			}
			
			try {
				if (ExternalInterface.available) {
					ExternalInterface.call('trackExport', format);
				}
			} catch (e:Error) {}
		}
		
		protected function exportAsImage(format:String, w:Number, h:Number):void
		{
			
			var image:BitmapData = new BitmapData(w, h);
			var canvas:Sprite = new Sprite();
			var treemap:PreviewRenderer = new PreviewRenderer(canvas, 0,0,0,0);
			treemap.render(_demoTree, new Rectangle(0,0,w-1,h-1), getCurrentTreeMapConfig());
			image.draw(canvas);
			
			var imgData:ByteArray = format == 'PNG' ? PNGEncoder.encode(image) : new JPEGEncoder(95).encode(image);
			
			FileUtil.send('treemap-'+w+'x'+h+'.' + format.toLowerCase(), imgData);
		}

		protected function exportPDF(w:Number, h:Number):void
		{
			new PDFRenderer().render(_demoTree, new Rectangle(0, 0, w, h), getCurrentTreeMapConfig());
		}
		
		protected function uiComplete(e:Event):void 
		{
			//ComboBox(conf.getCompById("fooo")).addItem('squarify');
			//ComboBox(conf.getCompById("fooo")).addItem('slice and dice');
			//ComboBox(conf.getCompById("fooo")).addItem('strip');
			
			/*CB("import.layoutselect").
			CB("import.colorselect").items = ['single', 'random', 'by value'];
			CB("import.label-v").items = ['off', 'top', 'middle', 'bottom'];
			CB("import.label-h").items = ['left','center','right'];
			
			comp("import").addEventListener(MouseEvent.CLICK, showFileDialog);
			
			RB("import.nested").addEventListener(Event.CHANGE, nestedFlatChanged);*/
		}
		
		protected function nestedFlatChanged(e:Event):void 
		{
			var nested:Boolean = RB("import.nested").selected;
			
			CB("import.combobox-children").visible = nested;
			L("import.label-children").visible = nested;
			CB("import.combobox-id").visible = !nested;
			CB("import.combobox-pid").visible = !nested;
			L("import.label-id").visible = !nested;
			L("import.label-pid").visible = !nested;
		}
		
		protected function showFileDialog(e:MouseEvent):void 
		{
			var fileFilter:FileFilter = new FileFilter("Data files", "*.txt;*.csv;*.tsv;*.xml;*.json");
			fileRef = new FileReference();
			fileRef.addEventListener(Event.SELECT, onFileSelected);
			fileRef.browse([fileFilter]);
			
		}
		
		protected function onFileSelected(e:Event):void 
		{
			fileRef.addEventListener(Event.COMPLETE, onFileLoaded);
			fileRef.load();
		}
		
		protected function onFileLoaded(e:Event):void 
		{
			var rawfile:String = e.target.data;
			var filetype:String = TreeImporter.guessFileType(rawfile);
			L("import.filetype").text = filetype.toUpperCase();
			L("import.filetype").enabled = true;
			
			switch (filetype) {
				case "csv": 
					RB("import.flat").enabled = true;
					RB("import.nested").enabled = false;
					RB("import.flat").selected = true;
					break;
				case "json":
					RB("import.flat").enabled = true;
					RB("import.nested").enabled = true;
					break;
				case "xml":
					
					try {
						var desc:DataDescription = XMLTreeImporter.describeData(XML(rawfile));
						
						RB("import.flat").enabled = true;
						RB("import.nested").enabled = true;
						
						CB("import.combobox-label").items = desc.columns;
						CB("import.combobox-weight").items = desc.columns;
						CB("import.combobox-id").items = desc.columns;
						CB("import.combobox-pid").items = desc.columns;
						CB("import.combobox-children").items = desc.columns;
						
						if (desc.nested) RB("import.nested").selected = true;
						else RB("import.flat").selected = true;
						
					} catch (e:Error) {
						L("import.filetype").text = "Error";
						RB("import.flat").enabled = false;
						RB("import.nested").enabled = false;
					}
					
					break;
			}
		}
		
		protected function randomTree():Tree
		{
			randomValues = [];
			var numVals:uint = Random.integer(10, 20);
			for (var i:uint = 0; i < numVals; i++) {
				randomValues.push(Random.integer(0, 100));
			}
			var sum:Number = 0;
			for each (var val:Number in randomValues) {
				sum += val;
			}
			var root:TreeNode = new TreeNode( { }, sum);
			for each (val in randomValues) {
				var node:TreeNode = new TreeNode( { }, val);
				numVals = Random.integer(0, 10);
				for (i = 0; i < numVals; i++) {
					var subval:Number = i+1 < numVals ? Random.next() * val * .3 : val;
					val -= subval;
					node.addChild(new TreeNode( { }, subval));
				}
				
				root.addChild(node);
				
			}
			return new Tree(root);
		}
		
		
		protected function IT(id:String):InputText { return InputText(Comp(id));  }
		
		protected function CS(id:String):ColorChooser { return ColorChooser(Comp(id));  }
		
		protected function PB(id:String):PushButton { return PushButton(Comp(id));  }
		
		protected function CB(id:String):ComboBox { return ComboBox(Comp(id));  }
		
		protected function CHK(id:String):CheckBox { return CheckBox(Comp(id));  }
		
		protected function RB(id:String):RadioButton { return RadioButton(Comp(id));  }
		
		protected function L(id:String):com.bit101.components.Label 
		{ 
			return com.bit101.components.Label(Comp(id));
		}

		protected function Comp(id:String):Component
		{
			var n:Array = id.split('.');
			return sectionsById[n[0]].minimalconf.getCompById(n[1]);
		}
		
	}
	
}