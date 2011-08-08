package 
{
	import assets.font.Lato;
	import assets.font.RondaSeven;
	import com.bit101.components.ComboBox;
	import com.bit101.components.Component;
	import com.bit101.components.HBox;
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
	import math.Random;
	import net.vis4.text.Label;
	import net.vis4.treemap.data.Tree;
	import net.vis4.treemap.data.TreeNode;
	import renderer.PreviewRenderer;
	import ui.MiniTreemap;
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
			
			conf = new MinimalConfigurator(this);
			conf.addEventListener(Event.COMPLETE, uiComplete);
			conf.loadXML('ui/ui.xml');	
			
			var sideFont:Lato = new Lato( { color: 0xffffff, size: 14, weight: 400, sharpness:200, thickness: -100 } );
			var sideAttr:Object = { rotation: -90, selectable: false };
			
			new Label('IMPORT', sideFont).attr(sideAttr).place(3, 118, this);
			new Label('CUSTOMIZE', sideFont).attr(sideAttr).place(3, 365, this);
			new Label('EXPORT', sideFont).attr(sideAttr).place(3, 495, this);
			
		
			
			var treemapConfig:TreeMapConfig = new TreeMapConfig();
			
			treemapConfig.padding = 0;
			treemapConfig.border = 1;
			
			var preview:PreviewRenderer = new PreviewRenderer(this, 10, 10, 10, 215);
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
		
		protected function uiComplete(e:Event):void 
		{
			//ComboBox(conf.getCompById("fooo")).addItem('squarify');
			//ComboBox(conf.getCompById("fooo")).addItem('slice and dice');
			//ComboBox(conf.getCompById("fooo")).addItem('strip');
			
			combobox("layoutselect").items = ['squarify', 'slice and dice', 'strip'];
			combobox("colorselect").items = ['single', 'random', 'by value'];
			combobox("label-v").items = ['off', 'top', 'middle', 'bottom'];
			combobox("label-h").items = ['left','center','right'];
			
			comp("import").addEventListener(MouseEvent.CLICK, showFileDialog);
			
			radiobtn("nested").addEventListener(Event.CHANGE, nestedFlatChanged);
		}
		
		protected function nestedFlatChanged(e:Event):void 
		{
			var nested:Boolean = radiobtn("nested").selected;
			
			combobox("combobox-children").visible = nested;
			label("label-children").visible = nested;
			combobox("combobox-id").visible = !nested;
			combobox("combobox-pid").visible = !nested;
			label("label-id").visible = !nested;
			label("label-pid").visible = !nested;
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
			label("filetype").text = filetype.toUpperCase();
			label("filetype").enabled = true;
			
			switch (filetype) {
				case "csv": 
					radiobtn("flat").enabled = true;
					radiobtn("nested").enabled = false;
					radiobtn("flat").selected = true;
					break;
				case "json":
					radiobtn("flat").enabled = true;
					radiobtn("nested").enabled = true;
					break;
				case "xml":
					
					try {
						var desc:DataDescription = XMLTreeImporter.describeData(XML(rawfile));
						
						radiobtn("flat").enabled = true;
						radiobtn("nested").enabled = true;
						
						combobox("combobox-label").items = desc.columns;
						combobox("combobox-weight").items = desc.columns;
						combobox("combobox-id").items = desc.columns;
						combobox("combobox-pid").items = desc.columns;
						combobox("combobox-children").items = desc.columns;
						
						if (desc.nested) radiobtn("nested").selected = true;
						else radiobtn("flat").selected = true;
						
					} catch (e:Error) {
						label("filetype").text = "Error";
						radiobtn("flat").enabled = false;
						radiobtn("nested").enabled = false;
					}
					
					break;
			}
		}
		
		protected function randomTree():Tree
		{
			randomValues = [];
			for (var i:uint = 0; i < Random.integer(10,60); i++) {
				randomValues.push(Random.integer(0, 100));
			}
			var sum:Number = 0;
			for each (var val:Number in randomValues) {
				sum += val;
			}
			var root:TreeNode = new TreeNode( { }, sum);
			for each (val in randomValues) {
				root.addChild(new TreeNode( { }, val));
				
			}
			return new Tree(root);
		}

		protected function label(id:String):com.bit101.components.Label { return com.bit101.components.Label(conf.getCompById(id));  }
		protected function combobox(id:String):ComboBox { return ComboBox(conf.getCompById(id));  }
		protected function comp(id:String):Component { return conf.getCompById(id); }
		protected function radiobtn(id:String):RadioButton { return RadioButton(conf.getCompById(id)); }
		
	}
	
}