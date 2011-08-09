package ui 
{
	import assets.font.Lato;
	import com.bit101.utils.MinimalConfigurator;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
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
			_gui.y = 5;
			_open = open;
			addChild(_gui);
			
			var sideFont:Lato = new Lato( { color: 0xffffff, size: 14, weight: 400, sharpness:200, thickness: -100 } );
			lbl = new Label(_title, sideFont).attr({ selectable: false }).place(0, 0, this);
			
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
			graphics.clear();
			if (_open) {
				graphics.lineStyle(0, 0xffffff, .2);
				graphics.moveTo(10, -7);
				graphics.lineTo(212, -7);
				lbl.rotation = -90;
				lbl.text = _title;
				lbl.y = lbl.height+5;
				lbl.x = 2;
				_gui.visible = true;
			} else {
				graphics.lineStyle(0, 0xffffff, .2);
				graphics.moveTo(10, -7);
				graphics.lineTo(212, -7);
				graphics.moveTo(10, 28);
				graphics.lineTo(212, 28);
				
				lbl.rotation = 0;
				lbl.y = 0;
				lbl.text = '« ' + _title + ' »';
				lbl.x = 111-lbl.width*.5;
				_gui.visible = false;
			}
		}
		
		override public function get height():Number 
		{
			return getVisibleHeight(this);
		}
		
		/**
		 * 
		 * taken from http://www.moock.org/blog/archives/000292.html
		 * 
		 * Returns the distance from the registration point of the specified 
		 * object to the bottom-most visible pixel, ignoring any region
		 * that is not visible due to masking. For example, if a display
		 * object contains a 100-pixel-high shape and a 50-pixel-high mask,
		 * getVisibleHeight() will return 50, whereas DisplayObject's
		 * "height" variable would yield 100. 
		 * 
		 * The maximum measureable dimensions of the supplied object is
		 * 2000x2000.
		 */
		protected function getVisibleHeight (o:DisplayObject):Number {
		  var bitmapDataSize:int = 2000;
		  var bounds:Rectangle;
		  var bitmapData:BitmapData = new BitmapData(bitmapDataSize, 
																	bitmapDataSize,
																	true,
																	0);
		  bitmapData.draw(o);
		  bounds = bitmapData.getColorBoundsRect( 0xFF000000, 0x00000000, false );
		  bitmapData.dispose(); 
		  return bounds.y + bounds.height;
		}
		
		public function get minimalconf():MinimalConfigurator 
		{
			return _conf;
		}
		
				
	}

}