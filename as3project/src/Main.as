package 
{
	import assets.font.Lato;
	import assets.font.RondaSeven;
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
			
			var minimalConf:MinimalConfigurator = new MinimalConfigurator(this);
			minimalConf.loadXML('ui/ui.xml');
			
		}
		
	}
	
}