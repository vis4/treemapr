package 
{
	import assets.font.Lato;
	import assets.font.RondaSeven;
	import com.bit101.components.CheckBox;
	import com.bit101.components.ComboBox;
	import com.bit101.components.Component;
	import com.bit101.components.HBox;
	import com.bit101.components.PushButton;
	import com.bit101.components.RadioButton;
	import com.bit101.components.Style;
	import com.bit101.utils.MinimalConfigurator;
	import config.TreeMapConfig;
	import data.DataDescription;
	import data.TreeImporter;
	import data.XMLTreeImporter;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.Font;
	import flash.text.FontStyle;
	import flash.text.FontType;
	import flash.text.TextField;
	import math.Random;
	import net.vis4.text.Label;
	import net.vis4.treemap.data.Tree;
	import net.vis4.treemap.data.TreeNode;
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
			
			
			
			var treemapConfig:TreeMapConfig = new TreeMapConfig();
			
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
			
		}
		
		protected function onUiXmlLoaded(e:Event):void 
		{
			var raw:String = URLLoader(e.target).data;
			
			try {
				var uixml:XML = new XML(raw);
				for each (var sectXML:XML in uixml..comp) {
					var section:Section = new Section(sectXML.@title, sectXML, sectXML.@open == "true");
					addChild(section);
					section.addEventListener(Event.RESIZE, layoutSections);
					sectionsById[String(sectXML.@title).toLowerCase()] = section;
					sections.push(section);
				}
				layoutSections();
				
			
			} catch (e:Error) {
				trace('Error while parsing ui xml');
				return;
			}
			
			initGuiEvents();
			
		}
		
		protected function initGuiEvents():void 
		{
			CB("customize.layout").items = ['squarify', 'slice and dice', 'strip'];
			CB("customize.layout").selectedIndex = 0;
			
			CB("customize.colorMode").items = ['single', 'random', 'by value'];
			
			CHK("customize.showLabels").selected = true;
			CHK("customize.showLabels").addEventListener(Event.CHANGE, onShowLabelsChange);
			CB("customize.lblVert").items = ['top', 'middle', 'bottom'];
			CB("customize.lblVert").selectedIndex = 0;;
			CB("customize.lblHorz").items = ['left', 'center', 'right'];
			CB("customize.lblHorz").selectedIndex = 0;
			CB("customize.lblFont").items = getDeviceFonts();   
		
			CB("customize.colorScale").items = ['cool', 'hot', 'ramp', 'diverging']; 
			//sComp("customize.scale").visible = false;
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