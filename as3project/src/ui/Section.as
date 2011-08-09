package ui 
{
	import assets.font.Lato;
	import com.bit101.utils.MinimalConfigurator;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import net.vis4.text.Label;
	/**
	 * ...
	 * @author gka
	 */
	public class Section extends Sprite
	{
		protected var _title:String;
		protected var _config:XML;
		protected var _gui:Sprite;
		protected var _conf:MinimalConfigurator;
		protected var _open:Boolean = true;
		protected var lbl:Label;
		
		public function Section(title:String, config:XML, open:Boolean = true) 
		{
			_config = config;
			_title = title;
			_gui = new Sprite();
			_gui.x = 30;
			_open = open;
			addChild(_gui);
			
			var sideFont:Lato = new Lato( { color: 0xffffff, size: 14, weight: 400, sharpness:200, thickness: -100 } );
			lbl = new Label(_title, sideFont).place(0, 0, this);
			
			lbl.addEventListener(MouseEvent.CLICK, changeState);
			load();
			
			draw();
		}
		
		protected function changeState(e:MouseEvent):void 
		{
			open = !open;
		}
		
		protected function load():void 
		{
			_conf = new MinimalConfigurator(_gui);
			_conf.parseXML(_config);
		}
		
		public function get open():Boolean 
		{
			return _open;
		}
		
		public function set open(value:Boolean):void 
		{
			if (_open != value) {
				_open = value;
				draw();
				dispatchEvent(new Event(Event.RESIZE));
				
			}
		}
		
		protected function draw():void 
		{
			if (_open) {
				lbl.rotation = -90;
				lbl.y = lbl.height;
				lbl.x = 2;
				_gui.visible = true;
			} else {
				lbl.rotation = 0;
				lbl.y = 0;
				lbl.x = 5;
				_gui.visible = false;
			}
		}
		
		override public function get height():Number 
		{
			return _open ? _gui.height : lbl.height;
		}
		
		public function get minimalconf():MinimalConfigurator 
		{
			return _conf;
		}
		
				
	}

}