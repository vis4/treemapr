package 
{
	import assets.font.Lato;
	import assets.font.RondaSeven;
	import com.bit101.components.ComboBox;
	import com.bit101.components.Style;
	import com.bit101.utils.MinimalConfigurator;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import net.vis4.text.Label;
	import ui.TreemaprLogo;
	
	/**
	 * ...
	 * @author gka
	 */
	public class Main extends Sprite 
	{
		protected var conf:MinimalConfigurator;
		
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
			new Label('CUSTOMIZE', sideFont).attr(sideAttr).place(3, 330, this);
			new Label('EXPORT', sideFont).attr(sideAttr).place(3, 470, this);
			
			
//			cbLayout.items = ['squarify', 'slice and dice', 'strip'];
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
			
		}
		
		protected function combobox(id:String):ComboBox
		{
			return ComboBox(conf.getCompById(id));
		}
		
	}
	
}